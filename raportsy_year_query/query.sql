SELECT
ROUND(SUM(CASE WHEN accid IN (257, 258, 1025, 1026, 16385, 16386, 32769, 32770) then "pages" ELSE 0 END),0) AS "Count_Total",
ROUND(SUM(CASE WHEN accid IN (1025, 1026, 32769, 32770) then "pages" ELSE 0 END),0) AS "Count_Color",
ROUND(SUM(CASE WHEN accid IN (257, 258, 16385, 16386) then "pages" ELSE 0 END),0) AS "Count_Black",
"users_login" AS "User_Name", 

date_trunc('month', now()) - interval '1 month' as "Okres_rozliczeniowy_start",
date_trunc('month', now()) - interval '1 sec' as "Okres_rozliczeniowy_stop"

FROM  safeq_stats 
WHERE ("date">=date_trunc('month', now()) - interval '1 month')
AND ("date"<date_trunc('month', now()) - interval '1 sec')
AND accid NOT IN (260,516,1028,2049,-1024,2050,369131521,320,369115137,369099777,369099009,65538,262145) 
GROUP BY "user_id","users_login"  
\pset footer off