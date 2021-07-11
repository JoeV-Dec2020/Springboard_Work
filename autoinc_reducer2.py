# !/usr/bin/env python
import sys

# [Define make/year level information]
master_data = ['',0]

# def reset():
#     # [Logic to reset master info for every new group]
#     master_data = ['',0]

# Run for end of every group
def flush():
    # [Write the output]
    print '%s' % (master_data[0] + ',' + str(master_data[1]))

# input comes from STDIN
for line in sys.stdin:
    # [parse the input we got from mapper and update the make/year info]
    line_data = line.strip('\n').split(',')
	
    # [detect key changes]
    if master_data[0] != line_data[0]:
        if master_data[0] != '':
            # write result to STDOUT
            flush()
        # reset()

        master_data[0] = line_data[0]
        master_data[1] = int(line_data[1])
    else:
        master_data[1] += int(line_data[1])

# do not forget to output the last group if needed!
if master_data[0] != '': flush()
