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