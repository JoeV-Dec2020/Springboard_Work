-- compute a list showing the number of substitutions that happened
-- in various stages of play for the entire tournament
select match_mast.play_stage, count(*) substitutions
 from  match_mast, player_in_out
 where  match_mast.match_no = player_in_out.match_no
  and   player_in_out.in_out = 'I'
 group by match_mast.play_stage;

-- play_stage, substitutions
-- 'G',        '208'
-- 'R',        '45'
-- 'Q',        '22'
-- 'S',        '12'
-- 'F',        '6'

