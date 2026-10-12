"""Create an owned temporary exam, verify import/edit persistence, then remove only that fixture."""
from pathlib import Path
import sys,io,zipfile,json,uuid,base64
sys.path.insert(0,str(Path(__file__).resolve().parent))
import integration_check as t
name='AUDIT-'+uuid.uuid4().hex
root=Path(__file__).resolve().parents[1]
original=(root/'docs/TOEIC-Reading-Test10-Tagged.docx').read_bytes()
buffer=io.BytesIO()
with zipfile.ZipFile(io.BytesIO(original)) as source,zipfile.ZipFile(buffer,'w') as target:
    for n in source.namelist():
        b=source.read(n)
        if n=='word/document.xml':b=b.replace(b'name="ETS TOEIC Reading Test 10"',('name="'+name+'"').encode(),1)
        target.writestr(n,b)
with zipfile.ZipFile(io.BytesIO(buffer.getvalue())) as prepared:
    assert name.encode() in prepared.read('word/document.xml')
opener,token=t.admin();eid=None
try:
    c,j=t.file_call(opener,token,'/Reading/Import',buffer.getvalue());eid=t.unwrap(c,j)['id']
    c,j,_=t.request('/Reading/Preview?id='+str(eid),opener=opener);exam=t.unwrap(c,j);assert exam['name']==name
    assert t.counts(eid)=={'Exams':1,'Parts':3,'Groups':19,'Documents':27,'Questions':100,'Choices':400}
    q=exam['parts'][0]['questions'][0];options=[o['text'] for o in q['options']];changed=options[:];changed[0]+=' [audit]'
    headers={'Content-Type':'application/json','RequestVerificationToken':token,'X-XSRF-TOKEN':token}
    payload={'number':101,'text':q['text']+' [audit]','options':changed,'answer':'A','status':'proposed'}
    c,j,_=t.request('/Reading/EditQuestion?id='+str(eid),'POST',json.dumps(payload).encode(),headers,opener);t.unwrap(c,j)
    c,j,_=t.request('/Reading/Preview?id='+str(eid),opener=opener);updated=t.unwrap(c,j)['parts'][0]['questions'][0]
    assert updated['text']==payload['text'] and updated['options'][0]['text']==changed[0] and updated['correctAnswer']=='A'
    d=exam['parts'][1]['groups'][0]['documents'][0];image=t.request(d['imageUrl'],opener=opener)[2]
    payload={'id':d['id'],'text':d['text']+'\nAudit note','imageBase64':None,'removeImage':False}
    c,j,_=t.request('/Reading/EditDocument?id='+str(eid),'POST',json.dumps(payload).encode(),headers,opener);t.unwrap(c,j)
    c,j,_=t.request('/Reading/Preview?id='+str(eid),opener=opener);updated=t.unwrap(c,j)['parts'][1]['groups'][0]['documents'][0]
    assert updated['text']==payload['text'] and updated['textWasEdited']
    payload={'id':d['id'],'text':d['text'],'imageBase64':base64.b64encode(image).decode(),'removeImage':False}
    c,j,_=t.request('/Reading/EditDocument?id='+str(eid),'POST',json.dumps(payload).encode(),headers,opener);t.unwrap(c,j)
    c,j,_=t.request('/Reading/Preview?id='+str(eid),opener=opener);updated=t.unwrap(c,j)['parts'][1]['groups'][0]['documents'][0]
    assert updated['text']==d['text'] and not updated['textWasEdited'] and t.request(updated['imageUrl'],opener=opener)[2]==image
    record={'validImportFreshSql':'PASS','questionOptionsAnswerPersisted':'PASS','documentTextImagePersisted':'PASS','fixtureName':name,'fixtureId':eid}
finally:
    if eid is not None:
        # The exact returned ID and unique name prove ownership; any attempt aborts cleanup.
        t.sql(f"""SET XACT_ABORT ON; BEGIN TRANSACTION;
DECLARE @r int; EXEC @r=sys.sp_getapplock @Resource='reading-exam:{eid}',@LockMode='Exclusive',@LockOwner='Transaction',@LockTimeout=10000;
IF @r<0 THROW 51000,'Fixture lock unavailable',1;
IF NOT EXISTS(SELECT 1 FROM ReadingExams WHERE Id={eid} AND Name='{name}') THROW 51000,'Fixture ownership mismatch',1;
IF EXISTS(SELECT 1 FROM ReadingAttempts WHERE ExamId={eid}) THROW 51000,'Fixture has an attempt; preserving it',1;
DELETE FROM ReadingChoices WHERE QuestionId IN(SELECT Id FROM ReadingQuestions WHERE ExamId={eid});
DELETE FROM ReadingQuestions WHERE ExamId={eid};
DELETE FROM ReadingDocuments WHERE GroupId IN(SELECT g.Id FROM ReadingGroups g JOIN ReadingParts p ON p.Id=g.PartId WHERE p.ExamId={eid});
DELETE FROM ReadingGroups WHERE PartId IN(SELECT Id FROM ReadingParts WHERE ExamId={eid});
DELETE FROM ReadingParts WHERE ExamId={eid}; DELETE FROM ReadingExams WHERE Id={eid} AND Name='{name}';
COMMIT; SELECT COUNT(*) Remaining FROM ReadingExams WHERE Id={eid};""")
        assert t.counts(eid)['Exams']==0
record['ownedFixtureCleanup']='PASS'
(root/'docs/evidence/final-admin-edit-audit.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
print('PASS fresh Word import, question/options/key editing, document/text/image persistence; owned fixture cleaned.')
