"""Inspect only Git-index contents; never print secret values."""
from pathlib import Path
import re
import subprocess

root = Path(__file__).resolve().parents[1]
entries = subprocess.check_output(['git', 'ls-files', '-s', '-z'], cwd=root).split(b'\0')
total = 0
blocked = []
for entry in entries:
    if not entry:
        continue
    metadata, raw_name = entry.split(b'\t', 1)
    name = raw_name.decode('utf-8')
    oid = metadata.split()[1].decode()
    data = subprocess.check_output(['git', 'cat-file', 'blob', oid], cwd=root)
    total += len(data)
    if len(data) > 95 * 1024 * 1024:
        blocked.append((name, 'too large for normal GitHub upload'))
    if re.search(r'(^|/)(tmp|\.runtime|\.recovery|node_modules|build|obj|bin)(/|$)', name) or name.endswith(('appsettings.Local.json', 'secrets.json', 'Logs.txt')):
        blocked.append((name, 'local/runtime file'))
    if b'\0' not in data:
        if re.search(rb'gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|sk-proj-[A-Za-z0-9_-]{30,}|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----', data):
            blocked.append((name, 'credential pattern'))
        if b'103.72.56.55' in data:
            blocked.append((name, 'retired remote SQL address'))
print(f'Git index: {len(entries)-1} files; {total/1024/1024:.1f} MiB; {len(blocked)} blocking findings.')
for name, reason in blocked:
    print(f'{name}: {reason}')
raise SystemExit(bool(blocked))
