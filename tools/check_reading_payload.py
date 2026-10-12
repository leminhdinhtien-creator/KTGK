"""Regression for oversized start/save payloads, using isolated guest attempts."""
from pathlib import Path
import json, secrets, time, urllib.request

root=Path(__file__).resolve().parents[1]
base='http://localhost:5100'
def request(path,method='GET',body=None,key=None):
    headers={'Content-Type':'application/json'}
    if key: headers['X-Reading-Session']=key
    start=time.perf_counter()
    with urllib.request.urlopen(urllib.request.Request(base+path,data=json.dumps(body).encode() if body is not None else (b'' if method=='POST' else None),headers=headers,method=method),timeout=45) as response:
        raw=response.read(); content_type=response.headers.get('Content-Type')
    duration=time.perf_counter()-start
    if content_type.startswith('application/json'):
        data=json.loads(raw)
        assert data.get('success',True), data.get('error')
        data=data.get('result',data)
    else:data=raw
    return data,len(raw),duration,content_type

records=[]
exams,_,_,_=request('/api/reading/exams')
for exam in exams:
    key=secrets.token_hex(32)
    state,size,seconds,_=request(f"/api/reading/exams/{exam['id']}/start",'POST',key=key)
    print('start',exam['id'],size,round(seconds,3),flush=True)
    assert size<500_000 and seconds<15
    assert 'correctAnswer' not in json.dumps(state)
    assert sum(len(p['questions']) for p in state['exam']['parts'])==100
    docs=[d for p in state['exam']['parts'] for g in p['groups'] for d in g['documents']]
    assert all(d['image'] is None for d in docs) and any(d['imageUrl'] for d in docs)
    records.append({'exam':exam['name'],'operation':'start','bytes':size,'seconds':round(seconds,3)})
    doc=next(d for d in docs if d['imageUrl'])
    image,image_size,image_seconds,mime=request(doc['imageUrl'])
    assert mime.startswith('image/') and (image[:8]==b'\x89PNG\r\n\x1a\n' or image[:3]==b'\xff\xd8\xff')
    records.append({'exam':exam['name'],'operation':'separate SQL image','bytes':image_size,'seconds':round(image_seconds,3)})
    aid=state['id']
    saved,size,seconds,_=request(f'/api/reading/attempts/{aid}/answer','PUT',{'number':101,'letter':'B'},key)
    assert saved['answered']==1 and size<500_000 and seconds<15
    records.append({'exam':exam['name'],'operation':'save answer','bytes':size,'seconds':round(seconds,3)})
    restored,_,_,_=request(f'/api/reading/attempts/{aid}',key=key)
    assert restored['id']==aid and restored['answered']==1
    submitted,_,_,_=request(f'/api/reading/attempts/{aid}/submit','POST',key=key)
    assert submitted['correct']+submitted['wrong']+submitted['skipped']==100
    review,_,_,_=request(f'/api/reading/attempts/{aid}/result',key=key)
    assert len(review['review'])==100
(root/'docs/evidence/reading-payload-performance.json').write_text(json.dumps(records,ensure_ascii=False,indent=2),encoding='utf-8')
for row in records: print(json.dumps(row,ensure_ascii=False))
print('PASS lightweight start/save, separate SQL images, restore, submit and result for all current exams.')

