-- find the match number for the game with the highest number of
-- penalty shots, and which countries played that match
select team1.match_no, country1.country_name, country2.country_name,
       (team1.penalty_score + team2.penalty_score) penalty_shots
 from  match_details team1, soccer_country country1,
       match_details team2, soccer_country country2
 where (team1.match_no = team2.match_no and team1.team_id != team2.team_id)
  and  team1.team_id = country1.country_id
  and  team2.team_id = country2.country_id
 order by penalty_shots desc
 limit 1;

-- match_no, country_name, country_name, penalty_shots
-- '47',     'Germany',    'Italy',      '11'

