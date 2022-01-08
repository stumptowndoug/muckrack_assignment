# Muck Rack Take-Home Assignment

## Assignment Question:
Write a SQL query (any dialect is fine) that combines data from these two sources that lists everyone who has expressed interest in trying Pitch Recs and when they first expressed that interest.


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
```

![SQL Result](https://muckrack.s3.us-west-2.amazonaws.com/query_results.png)

## Doug Dement - SQL Notes
The answer came back as expected with one exception, I've calculated the unix timestamp from hubspot (1534101377000) as being in the year 2018. It's possible I've interpreted this incorreclty but the date on epochconverter.com also showed 2018.

![Epoch Calc](https://muckrack.s3.us-west-2.amazonaws.com/epoch_calc.png)

Please note that the hubspot table name is slightly different than laid out in the assignment document. This is simply how I setup the structure to test the code in postgres.


## Doug Dement - Appendix information
Steps I took to build out this query.

 1. **Stood up an instance of postgres using docker**
    * [Docker Yaml file](https://github.com/stumptowndoug/muckrack_assignment/blob/main/docker-compose.yml)
  
  
 2. **Added tables laid out in the assignent file and insterted data records**
    * [SQL table creation and inserts](https://github.com/stumptowndoug/muckrack_assignment/tree/main/sql)

 3. **Tested SQL query against given data inputs**
    * [SQL Answer](https://github.com/stumptowndoug/muckrack_assignment/blob/main/sql/pitch_rec_data.sql)


