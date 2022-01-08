# Muck Rack Take-Home Assignment

## Assignment Question:
Write a SQL query (any dialect is fine) that combines data from these two sources that lists everyone who has expressed interest in trying Pitch Recs and when they first expressed that interest.

![Question output](https://muckrack.s3.us-west-2.amazonaws.com/result.png)


## Doug Dement - SQL Answer

```SQL
------------------------------------------------------------------------
-- QUERY TO SHOW EVERYONE WHO EXPRESSED INTERESTED IN TRYING PITCH RECS
------------------------------------------------------------------------

with total_data as
(
-- query to select hubspot contact 
select
ct.email,
to_timestamp(property_recc_interest/1000) as created_at,
null AS tag,
case
  when property_recc_interest is not null
  then true
  else false
end as pitch_rec

from
muckrack.hubspot_contact ct

union all
	
-- union conversation details
select
cn.email,
cn.created_at,
cnt.tag,
case
  when cnt.tag in('recc-interest')
  then true
  else false
end as pitch_rec

from
muckrack.conversation cn
left join muckrack.conversation_tag cnt
	on cn.id = cnt.conversation_id
)

select
email,
MIN(created_at) as expressed_interest_at --select min date in case there are duplicate pitch recs by email

from
total_data

where
pitch_rec = true --only include records with interest in pitch rec

group by
1

order by
2 asc --order by earlist date of interest
```





