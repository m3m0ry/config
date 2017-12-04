#/usr/bin/env python3

import sys
commands = sys.stdin.read()
lines = commands.split(';')

result = []
for l in lines:
    l = l.replace("'", "")
    if  not 'LMFILES' in l and not 'LOADEDMODULES' in l and not 'LD_LIBRARY_PATH' in l:
        l = l.replace(':', " ")
    
    if 'export' in l and '=' not in l:
        continue
    
    l = l.replace('unset', 'set -e -x')
    if '=' in l:
        l = "set -g -x " + l
        l = l.replace('=', ' ')
        l = l.replace('export', '')
    result.append(l)

print (";".join(result) )
