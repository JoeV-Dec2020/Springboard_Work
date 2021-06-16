-- What was the bottleneck?
   -- The select was performing a table scan because the IDs were not indexed

-- How did you identify it?
   -- using an Explain analyze and seeing that the number of rows checked, and related cost, was high

   -- # EXPLAIN
   -- -> Filter: (student.id = <cache>((@v1)))  (cost=41.00 rows=40) (actual time=1.612..2.772 rows=1 loops=1)
   -- -> Table scan on Student  (cost=41.00 rows=400) (actual time=1.156..2.365 rows=400 loops=1)


-- What method you chose to resolve the bottleneck
create index stud_id on student(id);

   -- # EXPLAIN
   -- -> Index lookup on Student using stud_id (id=(@v1))  (cost=0.35 rows=1) (actual time=0.016..0.018 rows=1 loops=1)
