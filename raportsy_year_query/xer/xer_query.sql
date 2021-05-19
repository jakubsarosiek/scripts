Select
date_trunc('month', now()) - interval '1 month' as "Okres_rozliczeniowy_start",

date_trunc('month', now()) - interval '1 sec' as "Okres_rozliczeniowy_stop",

substring("device_name" from 4 for 5) as "Device name",

ROUND(SUM(CASE WHEN accid in (257,258,1025,1026,16385,16386,32769,32770) then "pages" ELSE 0 END),0) AS "Count_Total",

ROUND(SUM(CASE WHEN accid in (1025,1026,32769,32770) then "pages" ELSE 0 END),0) AS "Count_Color",

ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0) AS "Count_Color_A4",

replace((case
when(lower(device_name) like '%xerb8045%') then 0
when(lower(device_name) like '%xerb605%') then 0
when(lower(device_name) like '%xerc8030%') then 0.1554
when(lower(device_name) like '%xerb405%') then 0
when(lower(device_name) like '%xerc405%') then 0.1994
when(lower(device_name) like '%xerb8090%') then 0
else 0 end)::text,'.',',') as "Price_per_Color_A4",

replace((case
when(lower(device_name) like '%xerb8045%') then 0
when(lower(device_name) like '%xerb605%') then 0
when(lower(device_name) like '%xerc8030%') then 0.1554 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb405%') then 0
when(lower(device_name) like '%xerc405%') then 0.1994 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb8090%') then 0
else 0 end)::text,'.',',') as "Cost_Sum_Color_A4",

ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0) AS "Count_Color_A3",

replace((case
when(lower(device_name) like '%xerb8045%') then 0
when(lower(device_name) like '%xerb605%') then 0
when(lower(device_name) like '%xerc8030%') then 0.1554*2
when(lower(device_name) like '%xerb405%') then 0
when(lower(device_name) like '%xerc405%') then 0.1994*2
when(lower(device_name) like '%xerb8090%') then 0
else 0 end)::text,'.',',') as "Price_per_Color_A3",

replace((case
when(lower(device_name) like '%xerb8045%') then 0
when(lower(device_name) like '%xerb605%') then 0
when(lower(device_name) like '%xerc8030%') then 0.1554 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb405%') then 0
when(lower(device_name) like '%xerc405%') then 0.1994 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb8090%') then 0
else 0 end)::text,'.',',') as "Cost_Sum_Color_A3",

ROUND(SUM(CASE WHEN accid in (257,258,16385,16386) then "pages" ELSE 0 END),0) AS "Count_Black",

ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0) AS "Count_Black_A4",

replace((case
when(lower(device_name) like '%xerb8045%') then 0.0162
when(lower(device_name) like '%xerb605%') then 0.0195
when(lower(device_name) like '%xerc8030%') then 0.0227
when(lower(device_name) like '%xerb405%') then 0.0286
when(lower(device_name) like '%xerc405%') then 0.0466
when(lower(device_name) like '%xerb8090%') then 0.0153
else 0 end)::text,'.',',') as "Price_per_Black_A4",

replace((case
when(lower(device_name) like '%xerb8045%') then 0.0162 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb605%') then 0.0195 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerc8030%') then 0.0227 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb405%') then 0.0286 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerc405%') then 0.0466 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb8090%') then 0.0153 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
else 0 end)::text,'.',',') as "Cost_Sum_Black_A4",

ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0) AS "Count_Black_A3",

replace((case
when(lower(device_name) like '%xerb8045%') then 0.0162 * 2
when(lower(device_name) like '%xerb605%') then 0.0195 * 2
when(lower(device_name) like '%xerc8030%') then 0.0227 * 2
when(lower(device_name) like '%xerb405%') then 0.0286 * 2
when(lower(device_name) like '%xerc405%') then 0.0466 * 2
when(lower(device_name) like '%xerb8090%') then 0.0153 * 2
else 0 end)::text,'.',',') as "Price_per_Black_A3",

replace((case
when(lower(device_name) like '%xerb8045%') then 0.0162 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb605%') then 0.0195 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerc8030%') then 0.0227 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb405%') then 0.0286 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerc405%') then 0.0466 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%xerb8090%') then 0.0153 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
else 0 end)::text,'.',',') as "Cost_Sum_Black_A3",

table2.homedir as "Legal Entity"

from safeq_stats

INNER JOIN
dblink('hostaddr=127.0.0.1 port=5433 dbname=SQDB5 user=postgres password=*********', $$
	SELECT
		users.id,
		users.flag,
		users.homedir
	FROM users
	where (users.flag & 1) = 1 AND (users.flag & 16384) <> 16384 AND (users.flag & 32768) <> 32768
	$$) as table2 (id bigint, flag int, homedir varchar(50))
	on user_id = table2.id

where	    ("date">=date_trunc('month', now()) - interval '1 month')
	AND ("date"<date_trunc('month', now()) - interval '1 sec')
	AND (lower(device_name) like '%xer%')
	
GROUP BY device_name,table2.homedir

\pset footer off