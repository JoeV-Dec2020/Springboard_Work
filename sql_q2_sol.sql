-- find the number of matches that were won by penalty shootout
select count(*) penalty_games
 from  match_mast
 where decided_by = 'P';

-- penalty_games
-- 3
