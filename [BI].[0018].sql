USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0018]    Script Date: 3/12/2022 12:37:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0018]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;

declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0018'
declare @command nvarchar(max) 

begin try 
	declare @pastDaysDatekey int =[Fn].[GetDatekey+-SinceToday](-10)
		--set  @pastDaysDatekey  =14000101

declare @todayDatekey int = fn.GetTodayDateKey()
	set @ErrorIno='Delete old Internal Income (40)'
	delete [Internal].IncomeBilling where MainZoneKey=@mainZoneKey and IncomeTypeKey in (40)
	set @ErrorIno='Get data from server'
	set @command= [FnInternal].GetStringWith2DateKey('0018-i-Internal',@mainZoneKey,@pastDaysDatekey,@todayDatekey);exec  (@command)
	set @ErrorIno='Determine new items'
	update Internal.IncomeBilling set Ischecked =1 from Internal.IncomeBilling temp join  BI.FactIncomeBillAmount  fact on  temp.ID=fact.Id and temp.MainZoneKey=fact.MainZoneKey and temp.IncomeTypeKey=fact.IncomeTypeKey where temp.MainZoneKey=@mainZoneKey and temp.IncomeTypeKey=40
	set @ErrorIno='Prepare to insert'
	select f.CustomerKey,d.DateKey as registerDatekey,t.Id,[Amount],t.mainzonekey,IncomeTypeKey 	into #newItems from Internal.IncomeBilling  t join bi.FactCustomer f on t.fldCustomerNumber=f.Customernumber 	join bi.DimDate  d on d.DateName=t.fldRegisterDate where t.Ischecked=0 and t.MainZoneKey=@mainZoneKey and t.IncomeTypeKey =40
	set @ErrorIno='insert in bi FactIncomeBillAmount'
	INSERT INTO [BI].[FactIncomeBillAmount] ([MainZoneKey],[Id],[customerkey],[registerDatekey],[Amount],IncomeTypeKey,[NeedProcess])select mainzonekey, [Id],[customerkey],[registerDatekey],[Amount],IncomeTypeKey,1 from #newItems
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'IncomeBilling(40)',@issuccessfull = 1
end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
