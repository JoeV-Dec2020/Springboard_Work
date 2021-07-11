# !/usr/bin/env python
import sys

# input comes from STDIN (standard input)
for line in sys.stdin:
    # [derive mapper output key values]
    rec_parts = line.split(',')
    print '%s' % (rec_parts[2] + ',' + rec_parts[1] + ',' + rec_parts[3] + ',' + rec_parts[4] + ',' + rec_parts[5])
