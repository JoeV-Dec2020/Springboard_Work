# !/usr/bin/env python
import sys

# input comes from STDIN (standard input)
for line in sys.stdin:
    # [derive mapper make/year & count]
    rec_parts = line.strip('\n').split(',')
    print '%s' % (rec_parts[1] + '-' + rec_parts[2] + '-' + rec_parts[3] + ',1')
