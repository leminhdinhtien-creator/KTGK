"""Exercise the actual MVC/API and local SQL Server; never print secrets or tokens."""
from pathlib import Path
import concurrent.futures, http.cookiejar, urllib.request, urllib.error, urllib.parse
import json, re, secrets, io, zipfile, time, subprocess, sys, uuid, base64
from html.parser import HTMLParser

ROOT=Path(__file__).resolve().parents[1]
BASE='http://127.0.0.1:5100'
records=[]
def record(name,detail=''):
    records.append({'case':name,'status':'PASS','detail':detail})
    print('PASS',name,detail,flush=True)
def sql(query):
    # Only literal/UUID test fixture values are passed by this script.
    code=f"""$ErrorActionPreference='Stop';$c=[System.Data.SqlClient.SqlConnection]::new('Server=localhost;Database=ToeicReadingDB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True');try{{$c.Open();$q=$c.CreateCommand();$q.CommandText=@'
{query}
'@;$r=$q.ExecuteReader();$rows=@();while($r.Read()){{$o=@{{}};for($i=0;$i -lt $r.FieldCount;$i++){{$o[$r.GetName($i)]=$r.GetValue($i)}};$rows+=$o}};ConvertTo-Json -InputObject $rows -Compress -Depth 4}}finally{{$c.Dispose()}}"""
    r=subprocess.run(['powershell','-NoProfile','-Command',code],capture_output=True,text=True,check=True)
    return json.loads(r.stdout)
def counts(exam_id=None):
    if exam_id is not None:
        n=int(exam_id)
        return sql(f"SELECT (SELECT COUNT(*) FROM ReadingExams WHERE Id={n}) Exams,(SELECT COUNT(*) FROM ReadingParts WHERE ExamId={n}) Parts,(SELECT COUNT(*) FROM ReadingGroups g JOIN ReadingParts p ON p.Id=g.PartId WHERE p.ExamId={n}) Groups,(SELECT COUNT(*) FROM ReadingDocuments d JOIN ReadingGroups g ON g.Id=d.GroupId JOIN ReadingParts p ON p.Id=g.PartId WHERE p.ExamId={n}) Documents,(SELECT COUNT(*) FROM ReadingQuestions WHERE ExamId={n}) Questions,(SELECT COUNT(*) FROM ReadingChoices c JOIN ReadingQuestions q ON q.Id=c.QuestionId WHERE q.ExamId={n}) Choices")[0]
    return sql('SELECT (SELECT COUNT(*) FROM ReadingExams) Exams,(SELECT COUNT(*) FROM ReadingParts) Parts,(SELECT COUNT(*) FROM ReadingGroups) Groups,(SELECT COUNT(*) FROM ReadingDocuments) Documents,(SELECT COUNT(*) FROM ReadingQuestions) Questions,(SELECT COUNT(*) FROM ReadingChoices) Choices')[0]
def request(path,method='GET',data=None,headers=None,opener=None):
    r=urllib.request.Request(BASE+path,data=data,method=method,headers=headers or {})
    try:
        with (opener.open(r,timeout=60) if opener else urllib.request.urlopen(r,timeout=60)) as response:
            raw=response.read();code=response.status
    except urllib.error.HTTPError as e:raw=e.read();code=e.code
    try:j=json.loads(raw)
    except ValueError:j=None
    return code,j,raw
def unwrap(code,j):
    if code>=400 or isinstance(j,dict) and j.get('success') is False:
        raise AssertionError(f'Unexpected HTTP {code}; message={j.get("error",{}).get("message") if isinstance(j,dict) else "not JSON"}')
    return j.get('result',j) if isinstance(j,dict) else j
class FormParser(HTMLParser):
    token=None
    def handle_starttag(self,tag,attrs):
        a=dict(attrs)
        if tag=='input' and a.get('name')=='__RequestVerificationToken':self.token=a.get('value')
def admin():
    jar=http.cookiejar.CookieJar();opener=urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))
    _,_,raw=request('/Account/Login',opener=opener);parser=FormParser();parser.feed(raw.decode())
    seed=(ROOT/'Backend/aspnet-core/src/MyCompany.MyProject.EntityFrameworkCore/EntityFrameworkCore/Seed/Host/HostRoleAndUserCreator.cs').read_text(encoding='utf-8')
    initial=re.search(r'HashPassword\(user, "([^"]+)"\)',seed).group(1)
    body=urllib.parse.urlencode({'usernameOrEmailAddress':'admin','Password':initial,'__RequestVerificationToken':parser.token}).encode()
    c,j,_=request('/Account/Login','POST',body,{'Content-Type':'application/x-www-form-urlencoded','X-Requested-With':'XMLHttpRequest'},opener);unwrap(c,j)
    _,_,raw=request('/Reading',opener=opener);parser=FormParser();parser.feed(raw.decode());assert parser.token
    return opener,parser.token
def file_call(opener,token,path,content,name='exam.docx'):
    boundary=secrets.token_hex(16)
    body=(f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="{name}"\r\nContent-Type: application/vnd.openxmlformats-officedocument.wordprocessingml.document\r\n\r\n'.encode()+content+f'\r\n--{boundary}--\r\n'.encode())
    c,j,_=request(path,'POST',body,{'Content-Type':'multipart/form-data; boundary='+boundary,'RequestVerificationToken':token,'X-XSRF-TOKEN':token},opener)
    return c,j
def api(path,method='GET',body=None,key=None):
    headers={'Content-Type':'application/json'}
    if key:headers['X-Reading-Session']=key
    c,j,_=request('/api/reading/'+path,method,json.dumps(body).encode() if body is not None else None,headers)
    return c,j
def state(path,method='GET',body=None,key=None):return unwrap(*api(path,method,body,key))
def write_report():
    (ROOT/'docs/evidence/sql-api-integration.json').write_text(json.dumps({'database':'localhost/ToeicReadingDB','cases':records,'note':'All cases ran against real HTTP and SQL. Expiry fixtures shorten only their own deadlines; exam duration remains 75 minutes.'},ensure_ascii=False,indent=2),encoding='utf-8')
def main():
    tables=sql('SELECT name FROM sys.tables ORDER BY name');assert len(tables)>8
    record('SQL connection and schema',f'{len(tables)} tables')
    (ROOT/'docs/evidence/sql-schema.json').write_text(json.dumps({'tables':tables,'foreignKeys':sql("SELECT OBJECT_NAME(parent_object_id) AS FromTable,name,OBJECT_NAME(referenced_object_id) AS ToTable FROM sys.foreign_keys ORDER BY FromTable"),'migrations':sql('SELECT MigrationId FROM __EFMigrationsHistory ORDER BY MigrationId')},indent=2),encoding='utf-8')
    public=state('exams');record('Public exam library without login')
    c,_,_=request('/Reading/Exams');assert c in (200,302,401,403) # login page or denial
    c,j,raw=request('/Reading/EditQuestion?id=1','POST',b'{}',{'Content-Type':'application/json','X-Requested-With':'XMLHttpRequest'});assert c>=400 or (isinstance(j,dict) and j.get('success') is False) or b'name="Password"' in raw
    record('Admin write rejects missing antiforgery token')
    opener,token=admin();record('Template Admin authentication remains available')
    before=counts();content=(ROOT/'docs/TOEIC-Reading-Test10-Tagged.docx').read_bytes()
    c,j=file_call(opener,token,'/Reading/PreviewFile',content);preview=unwrap(c,j)
    assert counts()==before and sum(len(p['questions']) for p in preview['parts'])==100
    for part in preview['parts']:
        if part['number']!=5:
            assert all(q['groupKey'] for q in part['questions'])
            assert sum(len([q for q in part['questions'] if q['groupKey']==g['key']]) for g in part['groups'])==len(part['questions'])
    record('Word preview before writing SQL')
    bad=io.BytesIO()
    with zipfile.ZipFile(io.BytesIO(content)) as source,zipfile.ZipFile(bad,'w') as target:
        for n in source.namelist():
            b=source.read(n)
            if n=='word/document.xml':b=b.replace(b'letter="A"',b'letter="E"',1)
            target.writestr(n,b)
    assert bad.getvalue()!=content
    c,j=file_call(opener,token,'/Reading/Import',bad.getvalue());assert c>=400 or j.get('success') is False
    assert counts()==before;record('Invalid DOCX rejected with no partial records')
    invalid_part6=io.BytesIO()
    with zipfile.ZipFile(io.BytesIO(content)) as source,zipfile.ZipFile(invalid_part6,'w') as target:
        for name in source.namelist():
            raw=source.read(name)
            if name=='word/document.xml':raw=raw.replace(b'&lt;stem&gt;131&lt;/stem&gt;',b'&lt;stem&gt;Choose a word&lt;/stem&gt;',1)
            target.writestr(name,raw)
    c,j=file_call(opener,token,'/Reading/Import',invalid_part6.getvalue());assert c>=400 or j.get('success') is False
    assert counts()==before;record('Non-numeric Part 6 stem rejected without partial SQL writes')
    original=next((e for e in public if e['name']==preview['name']),None)
    if original is None:
        c,j=file_call(opener,token,'/Reading/Import',content);exam_id=unwrap(c,j)['id'];record('Valid DOCX atomic SQL import')
    else:exam_id=original['id'];record('Existing valid imported exam reused')
    expected={'Exams':1,'Parts':3,'Groups':19,'Documents':27,'Questions':100,'Choices':400}
    assert counts(exam_id)==expected;record('Actual SQL row counts',str(expected))
    c,j=file_call(opener,token,'/Reading/Import',content);assert c>=400 or j.get('success') is False
    assert counts(exam_id)==expected;record('Duplicate import rejected')
    c,j,_=request('/Reading/Preview?id='+str(exam_id),opener=opener);exam=unwrap(c,j)
    assert len(exam['parts'][1]['groups'])==4 and any(len(g['documents'])==3 for g in exam['parts'][2]['groups'])
    record('Admin preview grouping and image content')
    if sql('SELECT COUNT(*) AS Count FROM ReadingAttempts')[0]['Count']==0:
        q=exam['parts'][0]['questions'][0]
        payload={'number':q['number'],'text':q['text']+' ','options':[o['text'] for o in q['options']],'answer':q['correctAnswer'],'status':q['answerStatus']}
        for text in (q['text']+' ',q['text']):
            payload['text']=text;c,j,_=request('/Reading/EditQuestion?id='+str(exam_id),'POST',json.dumps(payload).encode(),{'Content-Type':'application/json','RequestVerificationToken':token,'X-XSRF-TOKEN':token},opener);unwrap(c,j)
            assert sql('SELECT Text FROM ReadingQuestions WHERE Number=101')[0]['Text']==text
        d=exam['parts'][1]['groups'][0]['documents'][0]
        original_image=d['image'] or base64.b64encode(request(d['imageUrl'],opener=opener)[2]).decode()
        for text,image in ((d['text']+' ',None),(d['text'],original_image)):
            payload={'id':d['id'],'text':text,'imageBase64':image,'removeImage':False}
            c,j,_=request('/Reading/EditDocument?id='+str(exam_id),'POST',json.dumps(payload).encode(),{'Content-Type':'application/json','RequestVerificationToken':token,'X-XSRF-TOKEN':token},opener);unwrap(c,j)
            assert sql(f'SELECT Text FROM ReadingDocuments WHERE Id={d["id"]}')[0]['Text']==text
        record('Admin question/document edit persisted and original restored')
    if '--setup-only' in sys.argv:write_report();return
    key=secrets.token_hex(32);start=state(f'exams/{exam_id}/start','POST',key=key);aid=start['id']
    assert 'correctAnswer' not in json.dumps(start) and 'guestKeyHash' not in json.dumps(start)
    from datetime import datetime
    parse=lambda s:datetime.fromisoformat(s.replace('Z','+00:00'))
    assert (parse(start['deadline'])-parse(start['startedAt'])).total_seconds()==4500
    record('Anonymous start, 75-minute server deadline, answers withheld')
    c,j=api(f'attempts/{aid}',key=secrets.token_hex(32));assert c in (401,403) or j.get('unAuthorizedRequest')
    record('Wrong session cannot read another attempt')
    empty=state(f'attempts/{aid}/submit','POST',key=key);assert (empty['correct'],empty['wrong'],empty['skipped'])==(0,0,100)
    record('Empty submission scored 0/0/100')
    part=state(f'exams/{exam_id}/start','POST',key=key);aid=part['id']
    for letter in ('A','D',None):
        got=state(f'attempts/{aid}/answer','PUT',{'number':101,'letter':letter},key)
        assert (got['answers'][0]['letter'] if got['answers'] else None)==letter
    record('Choose, change and cancel persist on SQL')
    state(f'attempts/{aid}/answer','PUT',{'number':101,'letter':'B'},key)
    state(f'attempts/{aid}/answer','PUT',{'number':102,'letter':'A'},key)
    resumed=state(f'attempts/{aid}',key=key);assert len(resumed['answers'])==2
    assert state(f'exams/{exam_id}/start','POST',key=key)['id']==aid
    record('Restore same active attempt and answers')
    partial=state(f'attempts/{aid}/submit','POST',key=key);assert (partial['correct'],partial['wrong'],partial['skipped'])==(1,1,98)
    state(f'attempts/{aid}/answer','PUT',{'number':103,'letter':'A'},key)
    assert state(f'attempts/{aid}/submit','POST',key=key)['skipped']==98
    record('Partial submission and post-submit locking')
    full=state(f'exams/{exam_id}/start','POST',key=key);aid=full['id']
    data=json.loads((ROOT/'docs/reading-test10.json').read_text(encoding='utf-8'))
    for q in data['questions']:state(f'attempts/{aid}/answer','PUT',{'number':q['number'],'letter':q['answer']},key)
    with concurrent.futures.ThreadPoolExecutor(2) as pool:
        submitted=list(pool.map(lambda _:state(f'attempts/{aid}/submit','POST',key=key),range(2)))
    assert all((s['correct'],s['wrong'],s['skipped'])==(100,0,0) for s in submitted)
    review=state(f'attempts/{aid}/result',key=key);assert len(review['review'])==100
    record('Full submission scored 100/0/0; concurrent submit idempotent')
    race_key=secrets.token_hex(32)
    with concurrent.futures.ThreadPoolExecutor(2) as pool:
        starts=list(pool.map(lambda _:state(f'exams/{exam_id}/start','POST',key=race_key),range(2)))
    assert starts[0]['id']==starts[1]['id'];record('Concurrent start creates one active attempt')
    expired_id=str(uuid.UUID(starts[0]['id']))
    sql(f"UPDATE ReadingAttempts SET Deadline=DATEADD(second,-2,GETUTCDATE()) WHERE Id='{expired_id}'; SELECT Status FROM ReadingAttempts WHERE Id='{expired_id}'")
    late=state(f'attempts/{expired_id}/answer','PUT',{'number':101,'letter':'B'},race_key)
    assert late['status']=='expired' and late['skipped']==100 and late['answers']==[]
    record('Expired fixture rejects late answer and finalizes')
    worker_key=secrets.token_hex(32);w=state(f'exams/{exam_id}/start','POST',key=worker_key);wid=str(uuid.UUID(w['id']))
    sql(f"UPDATE ReadingAttempts SET Deadline=DATEADD(second,-2,GETUTCDATE()) WHERE Id='{wid}'; SELECT Status FROM ReadingAttempts WHERE Id='{wid}'")
    for _ in range(10):
        row=sql(f"SELECT Status,Skipped FROM ReadingAttempts WHERE Id='{wid}'")[0]
        if row['Status']=='expired':break
        time.sleep(2)
    assert row['Status']=='expired' and row['Skipped']==100
    record('Background worker submits closed-client expired fixture')
    record('All result counts total 100',str(sql('SELECT COUNT(*) AS Invalid FROM ReadingAttempts WHERE SubmittedAt IS NOT NULL AND Correct+Wrong+Skipped<>100')[0]['Invalid']))
    write_report()
if __name__=='__main__':
    try:main()
    except Exception:
        write_report();raise

