-- find the substitute players who came into the field in the first
-- half of play, within a normal play schedule
select player_mast.jersey_no, player_mast.player_name
 from  player_in_out, player_mast
 where player_in_out.player_id = player_mast.player_id
  and  player_in_out.in_out = 'I'
  and  player_in_out.play_half = 1
  and  player_in_out.play_schedule = 'NT';

-- jersey_no, player_name
-- '7',       'Bastian Schweinsteiger'
-- '20',      'Ricardo Quaresma'
-- '3',       'Erik Johansson'
