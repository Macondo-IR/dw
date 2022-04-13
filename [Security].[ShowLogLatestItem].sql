USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Security].[ShowLogLatestItem]    Script Date: 3/12/2022 12:42:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Security].[ShowLogLatestItem](
@MainZoneCode int )
AS
BEGIN
declare  @datekey int =Zone6BI.[Fn].[GetTodayDateKey]()


select top(1) * 
from  [Security].[MyLog]
where Datekey=@datekey
and MainZoneKey=@MainZoneCode
order by endtime desc



END

