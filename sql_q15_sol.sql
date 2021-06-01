--  find the referees who booked the most number of players
select referee_mast.referee_name, count(*) bookings_made,
       count(distinct player_booked.player_id) players_booked
 from  referee_mast, match_mast, player_booked
 where referee_mast.referee_id = match_mast.referee_id
  and  match_mast.match_no = player_booked.match_no
 group by referee_mast.referee_name
 order by players_booked desc
 limit 1;

-- referee_name,       bookings_made, players_booked
-- 'Mark Clattenburg', '21',          '21'
