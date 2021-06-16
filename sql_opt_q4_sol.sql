-- NOTE:  There are no transcript records that link to professor records through the teaching table - no data is returned! ...
--        I attempted to check the data to see if any course sessions linked the 3 tables today, which there were none ...

-- What was the bottleneck?
   -- There were no indexes on the professor and teaching tables, and the transcripts index needs to be updated
   -- also, took a look at modifying the select statement to be easier reading and reduce sub-query result sets

-- How did you identify it?
   -- using an Explain analyze to identify that professor and teaching tables were being scanned, and transaction index incomplete

   -- # EXPLAIN
   -- -> Inner hash join (professor.id = teaching.profId)              (cost=105.95 rows=0)  (actual time=2.205..2.205 rows=0 loops=1)
   -- -> Filter: (professor.`name` = <cache>((@v5)))                   (cost=4.32 rows=4)    (never executed)
   -- -> Table scan on Professor                                       (cost=4.32 rows=400)  (never executed)
   -- -> Hash
   -- -> Nested loop inner join                                        (cost=57.67 rows=10)  (actual time=2.152..2.152 rows=0 loops=1)
   -- -> Nested loop inner join                                        (cost=46.33 rows=10)  (actual time=2.151..2.151 rows=0 loops=1)
   -- -> Filter: (teaching.crsCode is not null)                        (cost=10.25 rows=100) (actual time=0.403..0.482 rows=100 loops=1)
   -- -> Table scan on Teaching                                        (cost=10.25 rows=100) (actual time=0.400..0.471 rows=100 loops=1)
   -- -> Filter: (transcript.semester = teaching.semester)             (cost=0.26 rows=0)    (actual time=0.017..0.017 rows=0 loops=100)
   -- -> Index lookup on Transcript using crs_stud (crsCode=teaching.crsCode), with index condition: (transcript.studId is not null)
   --                                                                  (cost=0.26 rows=1)    (actual time=0.015..0.016 rows=1 loops=100)
   -- -> Index lookup on Student using stud_id (id=transcript.studId)  (cost=1.01 rows=1)    (never executed)

-- What method you chose to resolve the bottleneck
create index name_id on professor(name,id);
create index prof_id on teaching(profId,crsCode,semester);
create index crs_stud_sem on transcript(crsCode,studId,semester);

SET @v5 = 'Amber Hill';

SELECT name
 FROM  Student
 WHERE id in (SELECT studId
               FROM  Transcript,
                     (SELECT crsCode, semester
                       FROM  Teaching
                       WHERE profId = (select id from professor where name = @v5)) as alias1
               WHERE Transcript.crsCode = alias1.crsCode
                AND  Transcript.semester = alias1.semester);

   -- # EXPLAIN
   -- -> Nested loop inner join                                                   (cost=13.34 rows=10)  (actual time=0.318..0.318 rows=0 loops=1)
   -- -> Filter: (`<subquery2>`.studId is not null)                               (cost=2.03 rows=10)   (actual time=0.317..0.317 rows=0 loops=1)
   -- -> Table scan on <subquery2>                                                (cost=2.03 rows=10)   (actual time=0.001..0.001 rows=0 loops=1)
   -- -> Materialize with deduplication                                           (cost=45.75 rows=10)  (actual time=0.317..0.317 rows=0 loops=1)
   -- -> Filter: (transcript.studId is not null)                                  (cost=45.75 rows=10)  (actual time=0.313..0.313 rows=0 loops=1)
   -- -> Nested loop inner join                                                   (cost=45.75 rows=10)  (actual time=0.313..0.313 rows=0 loops=1)
   -- -> Filter: (teaching.crsCode is not null)                                   (cost=10.25 rows=100) (actual time=0.011..0.067 rows=100 loops=1)
   -- -> Index scan on Teaching using prof_id                                     (cost=10.25 rows=100) (actual time=0.010..0.057 rows=100 loops=1)
   -- -> Filter: ((transcript.semester = teaching.semester) and (teaching.profId = (select #4)))
   --                                                                             (cost=0.25 rows=0)    (actual time=0.002..0.002 rows=0 loops=100)
   -- -> Index lookup on Transcript using crs_stud_sem (crsCode=teaching.crsCode) (cost=0.25 rows=1)    (actual time=0.002..0.002 rows=1 loops=100)
   -- -> Select #4 (subquery in condition; uncacheable)
   -- -> Index lookup on professor using name_id (name=(@v5))                     (cost=1.10 rows=1)
   -- -> Index lookup on Student using stud_id (id=`<subquery2>`.studId)          (cost=10.41 rows=1)   (never executed)
