from pathlib import Path
import json
import fitz

root = Path(__file__).resolve().parents[1]
pdf = fitz.open(root / 'tmp/inspection/report-final.pdf')
for index, page in enumerate(pdf):
    page.get_pixmap(matrix=fitz.Matrix(1.4, 1.4)).save(root / f'tmp/inspection/report-final/page-{index + 1}.png')
print(f'Rendered {len(pdf)} report pages for visual review.')

summary = '''Verified 12/10/2026
Backend: build successful; 23 passed, 0 failed, 0 skipped.
SQL/API: 22 real integration cases passed on localhost/ToeicReadingDB.
Flutter: analyze has no issues; 1 widget test passed; web build successful.
Mobile login/register removed. Guest library opens directly.
Manual Flutter web: real SQL data, Part 5/6/7, zoom, 100-question grid,
offline answer queue, resync and reload recovery verified.
Manual result: 1 correct, 1 wrong, 98 skipped; total 100.
Report: cloned original template; eight pages with real screenshots.
Tagged Word: 100 questions, 30/16/54, 75 minutes; 49 pages reviewed.
Figma Make: actual 16-screen prototype. Native handoff QA incomplete (quota).
Not verified: Android, continuous 75-minute run, official ETS answer key.
Not produced: submission video. No GitHub push.
See backend-tests.trx, sql-api-integration.json, manual-web-checks.json.
'''
(root / 'docs/evidence/verification.txt').write_text(summary, encoding='utf-8')

source = root / 'tools/figma-make-editable.js'
script = source.read_text(encoding='utf-8')
data = json.loads((root / 'docs/reading-test10.json').read_text(encoding='utf-8'))
questions = {q['number']: q for q in data['questions']}
script = script.replace("['comply','conduct','confer','conserve']", json.dumps(list(questions[131]['options'].values()), ensure_ascii=False))
for number in (176, 186):
    lines = script.splitlines()
    for i, line in enumerate(lines):
        if f',7,{number},' in line:
            line = line.replace("['Lựa chọn A','Lựa chọn B','Lựa chọn C','Lựa chọn D']", json.dumps(list(questions[number]['options'].values()), ensure_ascii=False))
            if number == 186:
                line = line.replace("'Nhóm câu 186–190 · Ba tài liệu liên quan'", json.dumps(questions[number]['text'], ensure_ascii=False))
            lines[i] = line
    script = '\n'.join(lines) + '\n'
source.write_text(script, encoding='utf-8')
