USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Security].[ShowHelp]    Script Date: 3/12/2022 12:41:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Security].[ShowHelp]
(@MainZoneCode int )
AS
BEGIN
--drop table if exists #Result,#temp

create table #Result(
MainZoneKey int , 
code nvarchar(4),
Title nvarchar (max) collate arabic_ci_as,
id int ,
Datekey int ,
StartedTime datetime,
EndTime datetime,
Duration time(7),
Summary nvarchar(max) collate arabic_ci_as,
IsSuccessFull int 
)
insert into #Result(mainzonekey,code,Title)
select @MainZoneCode,code,Title from [dbo].[Help] order by [code] desc


select Summary,max(id) as id 
into #temp 
from  [Security].[MyLog]
where 1=1 and IsSuccessFull=1 and MainZoneKey =@MainZoneCode
group by Summary


UPDATE #Result
   SET [Datekey] = d.Datekey
      ,[StartedTime] =d.StartedTime
      ,[EndTime] =d.EndTime
      ,[Duration] =d.Duration
      ,[Summary] =d.Summary
      ,[IsSuccessFull] =d.IsSuccessFull
from (
select * from [Security].[MyLog] 
where id in (select id from #temp )
) d 
where d.Summary=#Result.Title


select 
MainZoneKey  , 
code ,
Title ,
Datekey  ,
StartedTime ,
EndTime ,
Duration,
Summary ,
IsSuccessFull  
from #Result
order by code 




END

