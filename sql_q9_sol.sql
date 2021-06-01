-- find the goalkeeper’s name and jersey number, playing for
-- Germany, who played in Germany’s group stage matches
select distinct player_mast.player_name, player_mast.jersey_no
 from  player_mast, match_details, soccer_country, playing_position
 where match_details.team_id = soccer_country.country_id
  and  match_details.team_id = player_mast.team_id
  and  player_mast.posi_to_play = playing_position.position_id
  and  soccer_country.country_name = 'Germany'
  and  match_details.play_stage = 'G'
  and  playing_position.position_desc = 'Goalkeepers';

-- player_name,             jersey_no
-- 'Manuel Neuer',          '1'
-- 'Bernd Leno',            '12'
-- 'Marc-Andre ter Stegen', '22'
