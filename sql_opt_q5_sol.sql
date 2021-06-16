-- What was the bottleneck?
   -- There was no index on the course table

-- How did you identify it?
   -- using an Explain analyze to identify that course table was being scanned

   -- # EXPLAIN
   -- -> Nested loop inner join                                                       (cost=17.41 rows=10)  (actual time=3.016..8.523 rows=30 loops=1)
   -- -> Nested loop inner join                                                       (cost=13.80 rows=10)  (actual time=1.465..1.634 rows=30 loops=1)
   -- -> Filter: ((course.deptId = <cache>((@v6))) and (course.crsCode is not null))  (cost=10.25 rows=10)  (actual time=1.430..1.509 rows=26 loops=1)
   -- -> Table scan on Course                                                         (cost=10.25 rows=100) (actual time=0.986..1.049 rows=100 loops=1)
   -- -> Filter: (transcript.studId is not null)                                      (cost=0.26 rows=1)    (actual time=0.003..0.005 rows=1 loops=26)
   -- -> Index lookup on Transcript using crs_stud_sem (crsCode=course.crsCode)       (cost=0.26 rows=1)    (actual time=0.003..0.004 rows=1 loops=26)
   -- -> Filter: <in_optimizer>(transcript.studId,<exists>(select #3) is false)       (cost=0.26 rows=1)    (actual time=0.229..0.229 rows=1 loops=30)
   -- -> Index lookup on Student using stud_id (id=transcript.studId)                 (cost=0.26 rows=1)    (actual time=0.045..0.046 rows=1 loops=30)
   -- -> Select #3 (subquery in condition; dependent)
   -- -> Limit: 1 row(s)                                                                                    (actual time=0.180..0.180 rows=0 loops=30)
   -- -> Filter: <if>(outer_field_is_not_null, <is_not_null_test>(transcript.studId), true)                 (actual time=0.180..0.180 rows=0 loops=30)
   -- -> Nested loop inner join                                                       (cost=15.38 rows=20)  (actual time=0.180..0.180 rows=0 loops=30)
   -- -> Filter: ((course.deptId = <cache>((@v7))) and (course.crsCode is not null))  (cost=10.25 rows=10)  (actual time=0.004..0.066 rows=32 loops=30)
   -- -> Table scan on Course                                                         (cost=10.25 rows=100) (actual time=0.002..0.052 rows=100 loops=30)
   -- -> Filter: ((transcript.crsCode = course.crsCode) and <if>(outer_field_is_not_null,
   --            ((<cache>(transcript.studId) = transcript.studId) or (transcript.studId is null)), true))
   --                                                                                 (cost=0.33 rows=2)    (actual time=0.003..0.003 rows=0 loops=960)
   -- -> Alternative plans for IN subquery: Index lookup unless studId IS NULL        (cost=0.33 rows=2)    (actual time=0.003..0.003 rows=0 loops=960)
   -- -> Index lookup on Transcript using crs_stud_sem (crsCode=course.crsCode, studId=<cache>(transcript.studId) or NULL)
   --                                                                                                       (actual time=0.003..0.003 rows=0 loops=960)
   -- -> Table scan on Transcript  (never executed)

-- What method you chose to resolve the bottleneck
create index dept_crs on course(deptId,crsCode);

   -- # EXPLAIN
   -- -> Nested loop inner join                                                  (cost=42.68 rows=27)  (actual time=0.226..3.452 rows=30 loops=1)
   -- -> Nested loop inner join                                                  (cost=33.29 rows=27)  (actual time=0.040..0.264 rows=30 loops=1)
   -- -> Filter: (course.crsCode is not null)                                    (cost=4.41 rows=26)   (actual time=0.028..0.060 rows=26 loops=1)
   -- -> Index lookup on Course using dept_crs (deptId=(@v6))                    (cost=4.41 rows=26)   (actual time=0.026..0.055 rows=26 loops=1)
   -- -> Filter: (transcript.studId is not null)                                 (cost=1.01 rows=1)    (actual time=0.005..0.008 rows=1 loops=26)
   -- -> Index lookup on Transcript using crs_stud_sem (crsCode=course.crsCode)  (cost=1.01 rows=1)    (actual time=0.005..0.007 rows=1 loops=26)
   -- -> Filter: <in_optimizer>(transcript.studId,<exists>(select #3) is false)  (cost=0.25 rows=1)    (actual time=0.105..0.106 rows=1 loops=30)
   -- -> Index lookup on Student using stud_id (id=transcript.studId)            (cost=0.25 rows=1)    (actual time=0.006..0.007 rows=1 loops=30)
   -- -> Select #3 (subquery in condition; dependent)
   -- -> Limit: 1 row(s)                                                                               (actual time=0.096..0.096 rows=0 loops=30)
   -- -> Filter: <if>(outer_field_is_not_null, <is_not_null_test>(transcript.studId), true)            (actual time=0.096..0.096 rows=0 loops=30)
   -- -> Nested loop inner join                                                  (cost=45.75 rows=103) (actual time=0.096..0.096 rows=0 loops=30)
   -- -> Filter: (<if>(outer_field_is_not_null, ((<cache>(transcript.studId) = transcript.studId) or (transcript.studId is null)), true)
   --             and (transcript.crsCode is not null))                          (cost=10.25 rows=100) (actual time=0.076..0.089 rows=1 loops=30)
   -- -> Index scan on Transcript using crs_stud_sem                             (cost=10.25 rows=100) (actual time=0.003..0.077 rows=100 loops=30)
   -- -> Index lookup on Course using dept_crs (deptId=(@v7), crsCode=transcript.crsCode)
                                                                           (cost=0.25 rows=1)    (actual time=0.006..0.006 rows=0 loops=30)
