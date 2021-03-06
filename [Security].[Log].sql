USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Security].[Log]    Script Date: 3/12/2022 12:41:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USE Zone6BI

-- =============================================
ALTER PROCEDURE [Security].[Log](
@MainZoneCode int 
,@StartTime datetime
,@summary nvarchar(max)
,@issuccessfull int 
) 
AS
BEGIN
declare @endtime datetime =getdate();
declare @duration time ;
set 	@duration=CAST(@endtime - @StartTime as Time) 

INSERT INTO [Security].[MyLog]
           ([Datekey]
		   ,MainZoneKey
           ,[StartedTime]
           ,[EndTime]
           ,[Duration]
           ,[Summary]
           ,[IsSuccessFull])
     VALUES
           ([Fn].[GetTodayDateKey]()
		   ,@MainZoneCode
           ,@StartTime
           ,@endtime
           ,@duration
           ,@summary
           ,@issuccessfull
		   )




END

