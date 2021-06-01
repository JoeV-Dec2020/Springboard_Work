-- find the number of matches that were won by a single point, but
-- do not include matches decided by penalty shootout
select count(*) one_point_games
 from  match_mast
 where decided_by != 'P'
  and  ABS(CONVERT(SUBSTRING(goal_score,1,LOCATE('-',goal_score)-1), SIGNED INTEGER) -
           CONVERT(SUBSTRING(goal_score,LOCATE('-',goal_score)+1), SIGNED INTEGER)) = 1;

-- one_point_games
-- '21'

