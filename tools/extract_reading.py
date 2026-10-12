from pathlib import Path
import pymupdf,re,json
pdf=pymupdf.open(r'C:\Users\lemin\Downloads\Reading v10.pdf')
out=Path('tmp/inspection');out.mkdir(parents=True,exist_ok=True)
all_pages=[]
for i,p in enumerate(pdf):
    lines=[]
    for b in p.get_text('dict')['blocks']:
        for l in b.get('lines',[]):
            text=''.join(s['text'] for s in l['spans']).strip()
            if text: lines.append({'text':text,'box':l['bbox']})
    all_pages.append(lines)
(out/'lines.json').write_text(json.dumps(all_pages,indent=2,ensure_ascii=False),encoding='utf-8')
questions=[]
for i,lines in enumerate(all_pages):
    for col in (0,1):
        ls=[l for l in lines if (l['box'][0]<270)==(col==0)]
        ls.sort(key=lambda l:(round(l['box'][1]/3)*3,l['box'][0]))
        current=None
        for l in ls:
            t=l['text']
            m=re.match(r'^(1\s*\d\s*\d|200)\s*\.\s*(.*)',t)
            if m:
                n=int(m[1].replace(' ',''))
                if 131<=n<=146 and not m[2].startswith('(A)'): continue
                if 101<=n<=200:
                    current={'number':n,'page':i+1,'col':col,'y':l['box'][1],'lines':[m[2]]}
                    questions.append(current)
                    continue
            if current: current['lines'].append(t)
for q in questions:
    s=' '.join(q.pop('lines'))
    parts=re.split(r'\(([ABCD])\)\s*',s)
    q['text']=parts[0].strip()
    q['options']={parts[k]:parts[k+1].strip() for k in range(1,len(parts)-1,2)}
    if 'D' in q['options']:
        q['options']['D']=re.split(r'GO ON|TEST 10|Questions\s|Question s\s|PART\s*7|\b(?:29[4-9]|3[0-2]\d)\s*$',q['options']['D'])[0].strip()
questions.sort(key=lambda q:q['number'])
(out/'questions-extracted.json').write_text(json.dumps(questions,indent=2,ensure_ascii=False),encoding='utf-8')
print('Questions',len(questions),'missing',sorted(set(range(101,201))-{q['number'] for q in questions}))
print('Bad options',[(q['number'],list(q['options'])) for q in questions if len(q['options'])!=4])
print('Group headers')
for i,ls in enumerate(all_pages):
    for l in ls:
        if re.search(r'(?i)question\s*s?\s*1\d\d',l['text']):print(i+1,l['text'],l['box'])
