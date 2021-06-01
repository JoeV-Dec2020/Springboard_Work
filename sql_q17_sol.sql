-- find the country where the most assistant referees come from,
-- and the count of the assistant referees
select soccer_country.country_name, count(*) asst_ref_count
 from  asst_referee_mast, soccer_country
 where asst_referee_mast.country_id = soccer_country.country_id
 group by soccer_country.country_name
 order by asst_ref_count desc
 limit 1;

-- country_name, asst_ref_count
-- 'England',    '4'
