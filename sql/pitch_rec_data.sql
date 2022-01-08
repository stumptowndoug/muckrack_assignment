with total_data as
(
-- query to select hubspot contact 
select
ct.email,
to_timestamp(property_recc_interest/1000) as created_at

from
muckrack.hubspot_contact ct
	
where
property_recc_interest is not null

union all
	
-- union conversation details
select
cn.email,
cn.created_at

from
muckrack.conversation cn
left join muckrack.conversation_tag cnt
	on cn.id = cnt.conversation_id

where
cnt.tag in('recc-interest')
)

select
email,
MIN(created_at) as expressed_interest_at --select min date in case there are duplicate pitch recs by email

from
total_data

group by
1

order by
2 asc --order by earlist date of interest