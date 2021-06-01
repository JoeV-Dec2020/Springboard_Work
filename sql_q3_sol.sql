-- find the match number, date, and score for matches in which no
-- stoppage time was added in the 1st half

-- NOTE:  I needed to reformat some score data because it was exported as DATE data ...

select match_no, play_date, goal_score
 from  match_mast
 where stop1_sec = 0;

-- match_no, play_date,    goal_score
-- '4',      '2016-06-12', '1-1'
