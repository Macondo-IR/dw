USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Security].[ShowLog]    Script Date: 3/12/2022 12:42:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Security].[ShowLog](
@datekey int ) 
AS
BEGIN
if @datekey is null
begin
set @datekey=Zone6BI.[Fn].[GetTodayDateKey]()
end

select * 
from  [Security].[MyLog]
where Datekey=@datekey
order by endtime desc



END

