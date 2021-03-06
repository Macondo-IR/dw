USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0021]    Script Date: 3/12/2022 12:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0021]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;

--declare @mainZoneKey int 
--set @mainZoneKey=6;
declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0021'
declare @command nvarchar(max) 

 begin try 
	declare @pastDaysDatekey int =[Fn].[GetDatekey+-SinceToday](-60)
	declare @todayDatekey int = fn.GetTodayDateKey()
	set @ErrorIno='Delete old Internal DueDateList'
	delete [Internal].[DueDateList] where MainZonekey=@mainZoneKey
	set @ErrorIno='Get data from server'

	set @command= [FnInternal].[GetStringWith2DateKey]('0021-i-Internal',@mainZoneKey,@pastDaysDatekey,@todayDatekey);exec   (@command)
	set @ErrorIno='Determine new items'
	update [Internal].[DueDateList] set [NeedUpdate]=1  where mainzonekey=@mainZoneKey and  ListNumber not in (select ListNumber from bi.DueDateList  where mainZoneKey=@mainZoneKey)
	set @ErrorIno='Insert new items in Bi.DueDateList'
	INSERT INTO [BI].[DueDateList]([MainZoneKey],[ListNumber],[DueDate],[NeedProcess]) select  [MainZoneKey],[ListNumber],[DueDate],1 FROM [Internal].[DueDateList] where [NeedUpdate]=1 and mainZoneKey=@mainZoneKey
	set @ErrorIno='Update DueDateKey'
	UPDATE [BI].[DueDateList] SET [DueDateKey] = d.datekey from( SELECT li.[DueDate] ,d.DateKey FROM [BI].[DueDateList] li join bi.dimdate d on d.DateName=li.DueDate where NeedProcess=1)d where d.DueDate=[BI].[DueDateList].DueDate
	set @ErrorIno='finish Updated Items'
	UPDATE [BI].[DueDateList] set NeedProcess =0 where MainZoneKey=@mainZoneKey
		EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'DueDate',@issuccessfull = 1
end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
