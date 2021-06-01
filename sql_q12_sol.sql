-- returns the total number of goals scored by each position on each
-- country’s team. Do not include positions which scored no goals
select soccer_country.country_name, playing_position.position_desc, count(*) goals_scored
 from  goal_details, soccer_country, player_mast, playing_position
 where goal_details.team_id = soccer_country.country_id
  and  goal_details.player_id = player_mast.player_id
  and  player_mast.posi_to_play = playing_position.position_id
 group by soccer_country.country_name, playing_position.position_desc;

-- country_name, position_desc, goals_scored
-- 'Albania', 'Defenders', '1'
-- 'Austria', 'Midfielders', '1'
-- 'Belgium', 'Defenders', '4'
-- 'Belgium', 'Midfielders', '5'
-- 'Croatia', 'Midfielders', '4'
-- 'Croatia', 'Defenders', '1'
-- 'Czech Republic', 'Defenders', '2'
-- 'England', 'Defenders', '3'
-- 'England', 'Midfielders', '1'
-- 'France', 'Defenders', '9'
-- 'France', 'Midfielders', '4'
-- 'Germany', 'Midfielders', '3'
-- 'Germany', 'Defenders', '4'
-- 'Hungary', 'Defenders', '4'
-- 'Hungary', 'Midfielders', '1'
-- 'Iceland', 'Defenders', '6'
-- 'Iceland', 'Midfielders', '3'
-- 'Italy', 'Defenders', '5'
-- 'Italy', 'Midfielders', '1'
-- 'Northern Ireland', 'Defenders', '3'
-- 'Poland', 'Defenders', '2'
-- 'Poland', 'Midfielders', '2'
-- 'Portugal', 'Defenders', '8'
-- 'Portugal', 'Midfielders', '1'
-- 'Republic of Ireland', 'Defenders', '1'
-- 'Republic of Ireland', 'Midfielders', '3'
-- 'Romania', 'Defenders', '2'
-- 'Russia', 'Midfielders', '1'
-- 'Russia', 'Defenders', '1'
-- 'Slovakia', 'Midfielders', '3'
-- 'Spain', 'Defenders', '5'
-- 'Switzerland', 'Defenders', '2'
-- 'Switzerland', 'Midfielders', '1'
-- 'Turkey', 'Midfielders', '1'
-- 'Turkey', 'Defenders', '1'
-- 'Wales', 'Defenders', '8'
-- 'Wales', 'Midfielders', '1'
