-- find the players, their jersey number, and playing club who were
-- the goalkeepers for England in EURO Cup 2016
select player_mast.player_id, player_mast.jersey_no, player_mast.player_name, player_mast.playing_club
 from  player_mast, soccer_country, playing_position
 where player_mast.team_id = soccer_country.country_id
  and  soccer_country.country_name = 'England'
  and  player_mast.posi_to_play = playing_position.position_id
  and  playing_position.position_desc = 'Goalkeepers';

-- player_id, jersey_no, player_name,      playing_club
-- '160117',  '1',       'Joe Hart',       'Man. City'
-- '160116',  '13',      'Fraser Forster', 'Southampton'
-- '160118',  '23',      'Tom Heaton',     'Burnley'
