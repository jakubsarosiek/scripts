declare @pierwszy datetime,@ostatni datetime; 
set @ostatni = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -.0000001);
set @pierwszy = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0);

SELECT

@pierwszy as "Okres_rozliczeniowy_start",
@ostatni as "Okres_rozliczeniowy_stop",

substring("device_name",0,len("device_name")-10) as "Device Model",
substring("device_name",len("device_name")-9,10) as "Device S/N",
ROUND(SUM(CASE WHEN accid in (257,258,1025,1026,16385,16386,32769,32770) then "pages" ELSE 0 END),0) AS "Count_Total",

ROUND(SUM(CASE WHEN accid in (1025,1026,32769,32770) then "pages" ELSE 0 END),0) AS "Count_Color",

ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0) AS "Count_Color_A4",

replace((case
when(lower(device_name) like '%b405%') then 0
when(lower(device_name) like '%b7030%') then 0
when(lower(device_name) like '%b8055%') then 0
when(lower(device_name) like '%c605%') then 0.0824
when(lower(device_name) like '%c7030%') then 0.0824
when(lower(device_name) like '%c8045%') then 0.0824
when(lower(device_name) like '%wc3655%') then 0
when(lower(device_name) like '%wc6655%') then 0.0824
when(lower(device_name) like '%wc7835%') then 0.0824
else 0 end),'.',',') as "Price_per_Color_A4",

replace((case
when(lower(device_name) like '%b405%') then 0
when(lower(device_name) like '%b7030%') then 0
when(lower(device_name) like '%b8055%') then 0
when(lower(device_name) like '%c605%') then  0.0824 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c7030%') then 0.0824 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c8045%') then 0.0824 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc3655%') then 0
when(lower(device_name) like '%wc6655%') then 0.0824 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc7835%') then 0.0824 * ROUND(SUM(CASE WHEN accid in (1025,1026) then "pages" ELSE 0 END),0)
else 0 end),'.',',') as "Cost_Sum_Color_A4",

ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0) AS "Count_Color_A3",

replace((case
when(lower(device_name) like '%b405%') then 0
when(lower(device_name) like '%b7030%') then 0
when(lower(device_name) like '%b8055%') then 0
when(lower(device_name) like '%c605%') then 0.0824 * 2
when(lower(device_name) like '%c7030%') then 0.0824 * 2
when(lower(device_name) like '%c8045%') then 0.0824 * 2
when(lower(device_name) like '%wc3655%') then 0
when(lower(device_name) like '%wc6655%') then 0.0824 * 2
when(lower(device_name) like '%wc7835%') then 0.0824 * 2
else 0 end),'.',',') as "Price_per_Color_A3",

replace((case
when(lower(device_name) like '%b405%') then 0
when(lower(device_name) like '%b7030%') then 0
when(lower(device_name) like '%b8055%') then 0
when(lower(device_name) like '%c605%') then 0.0824 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c7030%') then 0.0824 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c8045%') then 0.0824 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc3655%') then 0
when(lower(device_name) like '%wc6655%') then 0.0824 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc7835%') then 0.0824 * 2 * ROUND(SUM(CASE WHEN accid in (32769,32770) then "pages" ELSE 0 END),0)
else 0 end),'.',',') as "Cost_Sum_Color_A3",

ROUND(SUM(CASE WHEN accid in (257,258,16385,16386) then "pages" ELSE 0 END),0) AS "Count_Black",

ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0) AS "Count_Black_A4",

replace((case
when(lower(device_name) like '%b405%') then 0.0156
when(lower(device_name) like '%b7030%') then 0.0156
when(lower(device_name) like '%b8055%') then 0.0156
when(lower(device_name) like '%c605%') then 0.0156
when(lower(device_name) like '%c7030%') then 0.0156
when(lower(device_name) like '%c8045%') then 0.0156
when(lower(device_name) like '%wc3655%') then 0.0156
when(lower(device_name) like '%wc6655%') then 0.0156
when(lower(device_name) like '%wc7835%') then 0.0156
else 0 end),'.',',') as "Price_per_Black_A4",

replace((case
when(lower(device_name) like '%b405%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%b7030%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%b8055%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c605%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c7030%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c8045%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc3655%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc6655%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc7835%') then 0.0156 * ROUND(SUM(CASE WHEN accid in (257,258) then "pages" ELSE 0 END),0)
else 0 end),'.',',') as "Cost_Sum_Black_A4",

ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0) AS "Count_Black_A3",

replace((case
when(lower(device_name) like '%b405%') then 0.0156 * 2
when(lower(device_name) like '%b7030%') then 0.0156 * 2
when(lower(device_name) like '%b8055%') then 0.0156 * 2
when(lower(device_name) like '%c605%') then 0.0156 * 2
when(lower(device_name) like '%c7030%') then 0.0156 * 2
when(lower(device_name) like '%c8045%') then 0.0156 * 2
when(lower(device_name) like '%wc3655%') then 0.0156 * 2
when(lower(device_name) like '%wc6655%') then 0.0156 * 2
when(lower(device_name) like '%wc7835%') then 0.0156 * 2
else 0 end),'.',',') as "Price_per_Black_A3",

replace((case
when(lower(device_name) like '%b405%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%b7030%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%b8055%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c605%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c7030%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%c8045%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc3655%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc6655%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
when(lower(device_name) like '%wc7835%') then 0.0156 * 2 * ROUND(SUM(CASE WHEN accid in (16385,16386) then "pages" ELSE 0 END),0)
else 0 end),'.',',') as "Cost_Sum_Black_A3",

[Xerox_SQ1].[dwhtenant_1].[safeq_stats].ou_name as "MPK",
CMPK.surname as "MPK Dep"

FROM [Xerox_SQ1].[dwhtenant_1].[safeq_stats]
left join [Xerox_SQ1].[tenant_1].[users] CMPK on CMPK.id = user_id
where [Xerox_SQ1].[dwhtenant_1].[safeq_stats].date > @pierwszy and [Xerox_SQ1].[dwhtenant_1].[safeq_stats].date < @ostatni and ([Xerox_SQ1].[dwhtenant_1].[safeq_stats].ou_name != '' and  CMPK.surname IS NOT NULL)
GROUP BY device_name,[Xerox_SQ1].[dwhtenant_1].[safeq_stats].ou_name,CMPK.surname