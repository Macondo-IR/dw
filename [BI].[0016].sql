USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0016]    Script Date: 3/12/2022 12:37:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0016]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;

declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0016'
declare @command nvarchar(max) 

begin try 
	--declare @pastDaysDatekey int =14001001
	declare @pastDaysDatekey int =[Fn].[GetDatekey+-SinceToday](-10)
		--set  @pastDaysDatekey  =14000101

	declare @todayDatekey int = fn.GetTodayDateKey()
	set @ErrorIno='Delete old Internal Income (30)'
	delete [Internal].IncomeBilling where MainZoneKey=@mainZoneKey and IncomeTypeKey=30
	set @ErrorIno='Get data from server'
	set @command= [FnInternal].GetStringWith2DateKey('0016-i-Internal',@mainZoneKey,@pastDaysDatekey,@todayDatekey);exec (@command)
	set @ErrorIno='Determine new items'
	update Internal.IncomeBilling set Ischecked =1 from Internal.IncomeBilling temp join  BI.FactIncomeBillAmount  fact on  temp.ID=fact.Id and temp.MainZoneKey=fact.MainZoneKey and temp.MainZoneKey=@mainZoneKey and temp.MainZoneKey=@mainZoneKey and temp.IncomeTypeKey=fact.IncomeTypeKey where temp.MainZoneKey=@mainZoneKey and fact.IncomeTypeKey=30
	set @ErrorIno='Prepare to insert'
	select f.CustomerKey,d.DateKey as registerDatekey,t.Id,[Amount],t.mainzonekey,[Volume],[Days],[Unit],usagecode,IncomeTypeKey into #new from Internal.IncomeBilling  t join bi.FactCustomer f on t.fldCustomerNumber=f.Customernumber join bi.DimDate  d on d.DateName=t.fldRegisterDate where t.Ischecked=0 and t.mainzonekey =@mainZoneKey
	set @ErrorIno='insert in bi FactIncomeBillAmount'
	INSERT INTO [BI].[FactIncomeBillAmount] ([MainZoneKey],[Id],[customerkey],[registerDatekey],[Amount],IncomeTypeKey,[Volume],[Days],[Unit],[UsageCode],[NeedProcess])select mainzonekey, [Id],[customerkey],[registerDatekey],[Amount],IncomeTypeKey,[Volume],[Days],[Unit],[UsageCode],1 from #new
	set @ErrorIno='Update FactIncomeBillAmount UsageKey'
	set   @command=[FnInternal].GetString('0016-u-usagekey',@mainZoneKey);exec (@command)
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'IncomeBilling(30)',@issuccessfull = 1
end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
