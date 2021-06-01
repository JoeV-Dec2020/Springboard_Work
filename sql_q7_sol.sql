-- find all the venues where matches with penalty shootouts were played
select distinct soccer_venue.venue_id, soccer_venue.venue_name
 from  match_mast, soccer_venue
 where match_mast.venue_id = soccer_venue.venue_id
  and  match_mast.decided_by = 'P';

-- venue_id, venue_name
-- '20001',  'Stade de Bordeaux'
-- '20005',  'Stade VElodrome'
-- '20009',  'Stade Geoffroy Guichard'
