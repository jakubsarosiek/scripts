declare @pierwszy datetime,@ostatni datetime; 
set @ostatni = DATEADD(dd,-DAY(getdate()), getdate());
set @pierwszy = DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()) - 1, 0);
SELECT sum(d_ext.pagecount) as Count_Total
                  ,SUM (d_ext.pagecount*d_ext.colored) as Count_Color
                  ,sum(d_ext.pagecount) - SUM (d_ext.pagecount*d_ext.colored) as Count_Black
      ,substring(p_ext.submitusername,7,20) as User_Name
                  ,@pierwszy as Okres_rozliczeniowy_start
                  ,@ostatni as Okres_rozliczeniowy_stop
  FROM [eqcas].[dbo].[cas_trx_doc_ext] d_ext inner join [eqcas].[dbo].[cas_trx_print_ext] p_ext 
  on  d_ext.x_id=p_ext.xd_id
  where p_ext.printendtime > @pierwszy and p_ext.printendtime < @ostatni
  group by p_ext.submitusername;
  
  
Count_Total;Count_Color;Count_Black;User_Name;Okres_rozliczeniowy_start;Okres_rozliczeniowy_stop
2;0;2;JF150942;2015-11-01 00:00:00.000;2015-11-30 15:44:04.073
