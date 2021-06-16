-- What was the bottleneck?
   -- The select was performing a table scan because the index only had IDs

-- How did you identify it?
   -- using an Explain analyze and seeing that it was a table scan

   -- # EXPLAIN
   -- -> Filter: (student.id between <cache>((@v2)) and <cache>((@v3)))  (cost=41.00 rows=278) (actual time=0.019..0.989 rows=278 loops=1)
   -- -> Table scan on Student  (cost=41.00 rows=400) (actual time=0.017..0.955 rows=400 loops=1)\n'

-- What method you chose to resolve the bottleneck
   -- changed the stud_id index created for #1 to include both the ID and NAME: 
create index stud_id on student(id,name);

   -- # EXPLAIN
   -- -> Filter: (student.id between <cache>((@v2)) and <cache>((@v3)))  (cost=64.52 rows=278) (actual time=0.027..0.183 rows=278 loops=1)
   -- -> Index range scan on Student using stud_id  (cost=64.52 rows=278) (actual time=0.025..0.161 rows=278 loops=1)\n'

