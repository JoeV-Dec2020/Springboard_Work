# !/usr/bin/env python
import sys

# [Define group level master information]
master_data = ['','','','']
current_vin = ''
accident_found = False

def reset():
    # [Logic to reset master info for every new group]
    master_data = ['','','','']

# Run for end of every group
def flush():
    # [Write the output]
    if accident_found:
        print '%s' % (master_data[0] + ',' + master_data[1] + ',' + master_data[2] + ',' + master_data[3])

# input comes from STDIN
for line in sys.stdin:
    # [parse the input we got from mapper and update the master info]
    line_data = line.strip('\n').split(',')
    vin = line_data[0]
	
    # [detect key changes]
    if current_vin != vin:
        if current_vin != '':
            # write result to STDOUT
            flush()
        reset()
        accident_found = False

        current_vin = vin
        master_data[0] = vin

    # [update more master info after the key change handling]
    if line_data[2] != '': master_data[1] = line_data[2]
    if line_data[3] != '': master_data[2] = line_data[3]
    if line_data[4] != '': master_data[3] = line_data[4]
    if line_data[1] == 'A': accident_found = True

# do not forget to output the last group if needed!
if current_vin != '': flush()
