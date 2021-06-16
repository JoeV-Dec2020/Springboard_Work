-- What was the bottleneck?
   -- There are no indexes on the transcript table

-- How did you identify it?
   -- using an Explain analyze and seeing that the Transcript table was being scanned

   -- # EXPLAIN
   -- -> Nested loop inner join  (cost=13.00 rows=10) (actual time=0.108..0.112 rows=2 loops=1)
   -- -> Filter: (`<subquery2>`.studId is not null)  (cost=2.00 rows=10) (actual time=0.096..0.097 rows=2 loops=1)
   -- -> Table scan on <subquery2>  (cost=2.00 rows=10) (actual time=0.001..0.001 rows=2 loops=1)
   -- -> Materialize with deduplication  (cost=10.25 rows=10) (actual time=0.096..0.096 rows=2 loops=1)
   -- -> Filter: (transcript.studId is not null)  (cost=10.25 rows=10) (actual time=0.055..0.089 rows=2 loops=1)
   -- -> Filter: (transcript.crsCode = <cache>((@v4)))  (cost=10.25 rows=10) (actual time=0.054..0.089 rows=2 loops=1)
   -- -> Table scan on Transcript  (cost=10.25 rows=100) (actual time=0.028..0.073 rows=100 loops=1)
   -- -> Index lookup on Student using stud_id (id=`<subquery2>`.studId)  (cost=10.10 rows=1) (actual time=0.006..0.006 rows=1 loops=2)

-- What method you chose to resolve the bottleneck
   -- create a Transcript index comprised of crscode and studid
create index crs_stud on transcript(crscode,studid);

   -- # EXPLAIN
   -- -> Nested loop inner join  (cost=2.68 rows=2) (actual time=0.547..0.565 rows=2 loops=1)
   -- -> Remove duplicates from input sorted on crs_stud  (cost=0.48 rows=2) (actual time=0.016..0.024 rows=2 loops=1)
   -- -> Filter: (transcript.studId is not null)  (cost=0.48 rows=2) (actual time=0.014..0.020 rows=2 loops=1)
   -- -> Index lookup on Transcript using crs_stud (crsCode=(@v4))  (cost=0.48 rows=2) (actual time=0.013..0.018 rows=2 loops=1)
   -- -> Index lookup on Student using stud_id (id=transcript.studId)  (cost=2.10 rows=1) (actual time=0.267..0.269 rows=1 loops=2)
