To execute the Accident data stream, place the data file, as well as 2 mapper and 2 reducer jobs, in the same directory location.

To get the stream to function, I ended up using the command:
cat data.csv | python autoinc_mapper1.py | sort | python autoinc_reducer1.py | python autoinc_mapper2.py | sort | python autoinc_reducer2.py


The job execution output for the data.csv file is:

[root@sandbox-host hdp_miniproj1]# cat data.csv | python autoinc_mapper1.py | sort | python autoinc_reducer1.py | python autoinc_mapper2.py | sort | python autoinc_reducer2.py
Mercedes-C300-2015,1
Mercedes-E350-2015,1
Mercedes-SL550-2016,1
Nissan-Altima-2003,1
