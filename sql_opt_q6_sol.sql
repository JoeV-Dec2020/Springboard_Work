-- What was the bottleneck?
   -- I took a guess that the SQL was less than efficient ...

-- How did you identify it?
   -- using an Explain analyze, I identified that there were no missing indexes

   -- # EXPLAIN
   -- -> Nested loop inner join                                                              (actual time=5.392..5.392 rows=0 loops=1)
   -- -> Filter: (alias.studId is not null)                                                  (actual time=5.391..5.391 rows=0 loops=1)
   -- -> Table scan on alias                                         (cost=2.73 rows=2)      (actual time=0.017..0.017 rows=0 loops=1)
   -- -> Materialize                                                                         (actual time=5.391..5.391 rows=0 loops=1)
   -- -> Filter: (count(0) = (select #5))                                                    (actual time=5.366..5.366 rows=0 loops=1)
   -- -> Table scan on <temporary>                                                           (actual time=0.000..0.001 rows=19 loops=1)
   -- -> Aggregate using temporary table                                                     (actual time=5.361..5.363 rows=19 loops=1)
   -- -> Nested loop inner join                                      (cost=24.79 rows=20)    (actual time=1.712..1.795 rows=19 loops=1)
   -- -> Filter: (`<subquery3>`.crsCode is not null)                 (cost=3.69 rows=19)     (actual time=1.703..1.724 rows=19 loops=1)
   -- -> Table scan on <subquery3>                                   (cost=3.69 rows=19)     (actual time=0.002..0.019 rows=19 loops=1)
   -- -> Materialize with deduplication                              (cost=45.75 rows=103)   (actual time=1.702..1.721 rows=19 loops=1)
   -- -> Filter: (course.crsCode is not null)                        (cost=45.75 rows=103)   (actual time=0.938..1.176 rows=19 loops=1)
   -- -> Nested loop inner join                                      (cost=45.75 rows=103)   (actual time=0.937..1.172 rows=19 loops=1)
   -- -> Filter: (teaching.crsCode is not null)                      (cost=10.25 rows=100)   (actual time=0.861..0.924 rows=100 loops=1)
   -- -> Index scan on Teaching using prof_id                        (cost=10.25 rows=100)   (actual time=0.858..0.912 rows=100 loops=1)
   -- -> Index lookup on Course using dept_crs (deptId=(@v8), crsCode=teaching.crsCode)
   --                                                                (cost=0.25 rows=1)      (actual time=0.002..0.002 rows=0 loops=100)
   -- -> Index lookup on Transcript using crs_stud_sem (crsCode=`<subquery3>`.crsCode)
   --                                                                (cost=19.25 rows=1)     (actual time=0.003..0.003 rows=1 loops=19)
   -- -> Select #5 (subquery in condition; uncacheable)
   -- -> Aggregate: count(0)                                                                 (actual time=0.178..0.178 rows=1 loops=19)
   -- -> Nested loop inner join                                      (cost=195.18 rows=1900) (actual time=0.150..0.175 rows=19 loops=19)
   -- -> Filter: (course.crsCode is not null)                        (cost=3.28 rows=19)     (actual time=0.002..0.016 rows=19 loops=19)
   -- -> Index lookup on Course using dept_crs (deptId=(@v8))        (cost=3.28 rows=19)     (actual time=0.002..0.015 rows=19 loops=19)
   -- -> Single-row index lookup on <subquery6> using <auto_distinct_key> (crsCode=course.crsCode)
   --                                                                                        (actual time=0.000..0.000 rows=1 loops=361)
   -- -> Materialize with deduplication                              (cost=10.25 rows=100)   (actual time=0.008..0.008 rows=1 loops=361)
   -- -> Filter: (teaching.crsCode is not null)                      (cost=10.25 rows=100)   (actual time=0.002..0.052 rows=100 loops=19)
   -- -> Index scan on Teaching using prof_id                        (cost=10.25 rows=100)   (actual time=0.002..0.046 rows=100 loops=19)
   -- -> Select #5 (subquery in projection; uncacheable)
   -- -> Aggregate: count(0)                                                                 (actual time=0.178..0.178 rows=1 loops=19)
   -- -> Nested loop inner join                                      (cost=195.18 rows=1900) (actual time=0.150..0.175 rows=19 loops=19)
   -- -> Filter: (course.crsCode is not null)                        (cost=3.28 rows=19)     (actual time=0.002..0.016 rows=19 loops=19)
   -- -> Index lookup on Course using dept_crs (deptId=(@v8))        (cost=3.28 rows=19)     (actual time=0.002..0.015 rows=19 loops=19)
   -- -> Single-row index lookup on <subquery6> using <auto_distinct_key> (crsCode=course.crsCode)
   --                                                                                        (actual time=0.000..0.000 rows=1 loops=361)
   -- -> Materialize with deduplication                              (cost=10.25 rows=100)   (actual time=0.008..0.008 rows=1 loops=361)
   -- -> Filter: (teaching.crsCode is not null)                      (cost=10.25 rows=100)   (actual time=0.002..0.052 rows=100 loops=19)
   -- -> Index scan on Teaching using prof_id                        (cost=10.25 rows=100)   (actual time=0.002..0.046 rows=100 loops=19)
   -- -> Index lookup on Student using stud_id (id=alias.studId)     (cost=1.05 rows=1)      (never executed)

-- What method you chose to resolve the bottleneck
   -- rewrote the SQL to use temp tables to run sub-queries once and compare the results

SELECT Student.name
 FROM  Student,
       (SELECT Transcript.studId, count(distinct Transcript.crscode) crscnt
         FROM  Transcript, Course, Teaching
         WHERE Transcript.crsCode = Course.crsCode
          and  Course.crsCode = teaching.crscode
          and  Course.deptId = @v8
         GROUP BY Transcript.studId) studCrs,
       (SELECT COUNT(distinct course.crscode) tot_courses
         FROM  Course, Teaching
         WHERE course.deptId = @v8
          AND  course.crsCode = teaching.crscode) crsList
 WHERE Student.id = studCrs.studId
  and  studCrs.crscnt = crsList.tot_courses;

   -- # EXPLAIN
   -- -> Nested loop inner join                                                                          (actual time=0.426..0.426 rows=0 loops=1)
   -- -> Filter: (studcrs.studId is not null)                                                            (actual time=0.426..0.426 rows=0 loops=1)
   -- -> Index lookup on studCrs using <auto_key2> (crscnt=\'19\')                                       (actual time=0.002..0.002 rows=0 loops=1)
   -- -> Materialize                                                                                     (actual time=0.425..0.425 rows=0 loops=1)
   -- -> Group aggregate: count(distinct transcript.crscode)                                             (actual time=0.402..0.408 rows=19 loops=1)
   -- -> Sort: transcript.studId                                                                         (actual time=0.390..0.391 rows=19 loops=1)
   -- -> Table scan on <temporary>                                                                       (actual time=0.001..0.001 rows=19 loops=1)
   -- -> Temporary table                                                          (cost=160.27 rows=106) (actual time=0.331..0.333 rows=19 loops=1)
   -- -> Nested loop inner join                                                   (cost=160.27 rows=106) (actual time=0.053..0.311 rows=19 loops=1)
   -- -> Nested loop inner join                                                   (cost=45.75 rows=103)  (actual time=0.045..0.261 rows=19 loops=1)
   -- -> Filter: (teaching.crsCode is not null)                                   (cost=10.25 rows=100)  (actual time=0.012..0.063 rows=100 loops=1)
   -- -> Index scan on Teaching using prof_id                                     (cost=10.25 rows=100)  (actual time=0.012..0.055 rows=100 loops=1)
   -- -> Index lookup on Course using dept_crs (deptId=(@v8), crsCode=teaching.crsCode)
   --                                                                             (cost=0.25 rows=1)     (actual time=0.002..0.002 rows=0 loops=100)
   -- -> Index lookup on Transcript using crs_stud_sem (crsCode=teaching.crsCode) (cost=1.01 rows=1)     (actual time=0.002..0.002 rows=1 loops=19)
   -- -> Index lookup on Student using stud_id (id=studcrs.studId)                (cost=1.01 rows=1)     (never executed)
