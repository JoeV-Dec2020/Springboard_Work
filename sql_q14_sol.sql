-- find referees and the number of bookings they made for the entire tournament.
-- Sort your answer by the number of bookings in descending order
select referee_mast.referee_name, count(*) bookings_made
 from  referee_mast, match_mast, player_booked
 where referee_mast.referee_id = match_mast.referee_id
  and  match_mast.match_no = player_booked.match_no
 group by referee_mast.referee_name
 order by bookings_made desc;

-- referee_name,              bookings_made
-- 'Mark Clattenburg',        '21'
-- 'Nicola Rizzoli',          '20'
-- 'Milorad Mazic',           '13'
-- 'Viktor Kassai',           '12'
-- 'Damir Skomina',           '12'
-- 'Sergei Karasev',          '12'
-- 'Bjorn Kuipers',           '12'
-- 'Jonas Eriksson',          '11'
-- 'Cuneyt Cakir',            '11'
-- 'Pavel Kralovec',          '11'
-- 'Carlos Velasco Carballo', '10'
-- 'Szymon Marciniak',        '10'
-- 'Ovidiu Hategan',          '9'
-- 'Martin Atkinson',         '9'
-- 'Felix Brych',             '9'
-- 'Svein Oddvar Moen',       '8'
-- 'William Collum',          '8'
-- 'Clement Turpin',          '3'
