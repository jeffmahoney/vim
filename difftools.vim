function!Diff(mode)
python <<EOF
import vim
import re
import difflib
import sys
import os

def diff(use_source=True):
    reject_window = None
    source_window = None
    reject_buffer = None
    source_buffer = None

    if use_source:
	skip_char = '+'
    else:
	skip_char = '-'

    m = re.match("^(.*)\.rej$", vim.current.buffer.name)
    if m:
	reject_buffer = vim.current.buffer
	reject_name = reject_buffer.name
	source_name = m.group(1)
    else:
	source_buffer = vim.current.buffer
	reject_name = "%s.rej" % source_buffer.name
	source_name = source_buffer.name

    if reject_buffer is None:
	for b in vim.buffers:
	    if b.name == reject_name:
		reject_buffer = b

    if source_buffer is None:
	for b in vim.buffers:
	    if b.name == source_name:
		source_buffer = b

    source_name = source_name.replace("%s/" % os.getcwd(), "")

    for w in vim.windows:
	if w.buffer == reject_buffer:
	    reject_window = w
	if w.buffer == source_buffer:
	    source_window = w

    reject_text = None
    source_text = None

    if reject_window and reject_buffer:
	grab = False
	reject_text = []
	for line in reject_buffer:
	    # Context source
	    if re.match("^\*\*\* ([0-9]+)", line):
		if grab:
		    break
		grab = use_source
		skip = 2
		continue

	    # Context destination
	    if re.match("^\-\-\- ([0-9]+)", line):
		if grab:
		    break
		grab = not use_source
		skip = 2
		continue

	    # Unified
	    if re.match("^@@ \-", line):
		if grab:
		    break
		grab = True
		skip = 1
		continue
	    if grab and re.match("^\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*", line):
		break

	    if grab:
		if line[0] != skip_char:
		    reject_text.append(line[skip:])
    else:
	print "No matching buffer for %s.rej" % source_name

    if source_window and reject_text:
	row = source_window.cursor[0] - 1
	source_text = source_buffer[row:row+len(reject_text)]

	diff = difflib.unified_diff(source_text, reject_text,
				    "a/%s" % source_name,
				    "b/%s" % source_name, lineterm='\n')
	for line in diff:
	    print line
	print "ok"
    else:
	    if not source_window:
		print "ERROR: No source window"
	    else:
		print "ERROR: No reject text"

mode = vim.eval("a:mode")

if mode == "diff":
    diff(True)
elif mode == "applied":
    diff(False)
else:
    print "Invalid argument %s" % mode
EOF
endfunction
cabbrev diff <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call Diff("diff")' : 'diff')<CR>
cabbrev applied <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call Diff("applied")' : 'applied')<CR>

function!ChunkSize()
python <<EOF
import vim
import re

def chunksize():
    b = vim.current.buffer
    w = vim.current.window

    row = 0
    for n in range(w.cursor[0] - 1, 0, -1):
	if re.match('^@@', b[n]):
	    row = n
	    break

    old = 0
    new = 0
    for n in range(row + 1, len(b)):
	if re.match("^\-", b[n]) and not re.match("^\-\-\- ", b[n]):
	    old += 1
	elif re.match("^\+", b[n]) and not re.match("^\+\+\+ ", b[n]):
	    new += 1
	elif re.match("^[ \t]", b[n]):
	    old +=1
	    new += 1
	else:
	    break;

    m = re.match("^@@ \-([0-9]+),([0-9]+) \+([0-9]+),([0-9]+) @@(.*)", b[row])
    if m:
	line = "@@ -%s,%d +%s,%d @@%s" % (m.group(1), old, m.group(3), \
					  new, m.group(5))
	if line != b[row]:
	    b[row] = line
	    print "updated"
	else:
	    print "ok"
    else:
	print "No @@ line found"
chunksize()
EOF
endfunction
cabbrev size <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'call ChunkSize()' : 'size')<CR>

