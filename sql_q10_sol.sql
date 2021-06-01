-- find all available information about the players under contract to
-- Liverpool F.C. playing for England in EURO Cup 2016
select player_mast.player_id,    player_mast.jersey_no, player_mast.player_name,
       player_mast.posi_to_play, player_mast.dt_of_bir, player_mast.age,
       count(distinct player_in_out.match_no) games_played,
       count(distinct goal_details.match_no) games_scored,
       count(goal_details.goal_id) total_goals_scored
 from  player_mast
       inner join soccer_country on player_mast.team_id = soccer_country.country_id
       left outer join player_in_out using (player_id)
       left outer join goal_details using (player_id)
 where player_mast.playing_club = 'Liverpool'
  and  soccer_country.country_name = 'England'
 group by player_mast.player_id,    player_mast.jersey_no, player_mast.player_name,
          player_mast.posi_to_play, player_mast.dt_of_bir, player_mast.age;

-- player_id, jersey_no, player_name,        posi_to_play, dt_of_bir,    age,  games_played, games_scored, total_goals_scored
-- '160121',  '12',      'Nathaniel Clyne',  'DF',         '1991-04-05', '25', '0',          '0',          '0'
-- '160129',  '14',      'Jordan Henderson', 'MF',         '1990-06-17', '26', '0',          '0',          '0'
-- '160130',  '8',       'Adam Lallana',     'MF',         '1988-05-10', '28', '2',          '0',          '0'
-- '160131',  '4',       'James Milner',     'MF',         '1986-01-04', '30', '1',          '0',          '0'
-- '160137',  '15',      'Daniel Sturridge', 'FD',         '1989-09-01', '26', '2',          '1',          '2'

