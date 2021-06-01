-- find the highest number of foul cards given in one match
select max(match_fouls) max_match_fouls
 from  (select count(*) match_fouls
         from  player_booked
         group by match_no) tmp_tbl;

-- max_match_fouls
-- '10'
