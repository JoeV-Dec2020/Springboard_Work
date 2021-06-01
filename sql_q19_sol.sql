-- find the number of captains who were also goalkeepers
select count(*) capt_goalkeepers
 from  match_captain, player_mast, playing_position
 where match_captain.player_captain = player_mast.player_id
  and  player_mast.posi_to_play = playing_position.position_id
  and  playing_position.position_desc = 'Goalkeepers';

-- capt_goalkeepers
-- '17'
