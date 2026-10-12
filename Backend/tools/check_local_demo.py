"""Read-only demo routing/authorization checks; no exam import or editing."""
from pathlib import Path
import http.cookiejar, urllib.request, urllib.error, re, json

root=Path(__file__).resolve().parents[2]
base='http://localhost:5100'
client=urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
def request(path, data=None, headers=None):
    return client.open(urllib.request.Request(base+path,data=data,headers=headers or {}),timeout=30)
page=request('/Reading').read().decode()
token=re.search(r'name="__RequestVerificationToken"[^>]*value="([^"]+)"',page).group(1)
assert b'User' in request('/').read()
assert json.loads(request('/Reading/Exams').read())['success']
boundary='ReadingStudioDemoCheck'
data=(f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="exam.docx"\r\nContent-Type: application/vnd.openxmlformats-officedocument.wordprocessingml.document\r\n\r\n'.encode()+(root/'Backend/docs/TOEIC-Reading-Test10-Tagged.docx').read_bytes()+f'\r\n--{boundary}--\r\n'.encode())
headers={'Content-Type':f'multipart/form-data; boundary={boundary}','RequestVerificationToken':token,'X-XSRF-TOKEN':token}
preview=json.loads(request('/Reading/PreviewFile',data,headers).read())
assert preview['success'] and preview['result']['totalQuestions']==100
try:
    request('/Reading/PreviewFile',data,{'Content-Type':headers['Content-Type']})
    raise AssertionError('Missing CSRF token was accepted')
except urllib.error.HTTPError as error:
    assert error.code==400
print('PASS unified portal, local anonymous Admin list/valid DOCX preview, missing-CSRF rejection. No SQL writes.')
