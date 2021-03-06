USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0022]    Script Date: 3/12/2022 12:38:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0022]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;

declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0022'
declare @command nvarchar(max) 

begin try 
	declare @pastDaysDatekey int =[Fn].[GetDatekey+-SinceToday](-10)
	declare @todayDatekey int = fn.GetTodayDateKey()
	set @ErrorIno='Delete old  Internal.LastBill'
	delete [Internal].[LastBill] where MainZoneKey=@mainZoneKey 
	set @ErrorIno='Get data from server'
	set @command= [FnInternal].GetStringWith2DateKey('0022-i-Internal',@mainZoneKey,@pastDaysDatekey,@todayDatekey);exec  (@command)
	set @ErrorIno='Delete Existing Id in Bi LastBill'
	update  [Internal].[LastBill]  set NeedUpdate=-1   where MainZoneKey=@mainZoneKey and  id  in (select id  from Bi.lastBill where  MainZoneKey=@mainZoneKey)
	delete [Internal].[LastBill] where customerkey in ( select distinct customerkey from [Internal].[LastBill] where NeedUpdate=-1 and MainZoneKey=@mainZoneKey)
	set @ErrorIno='Determine new items'
	UPDATE [Internal].[LastBill] set _row=d.row 	from (		select id, ROW_NUMBER() OVER (partition BY customerkey ORDER BY registerdatekey DESC) AS row from [Internal].[LastBill] where MainZonekey =@mainZoneKey )d where d.Id=[Internal].[LastBill].Id
	set @ErrorIno='Update data from server'
	set @command= [FnInternal].GetString('0022-u',@mainZoneKey);exec  (@command)
	set @ErrorIno='Update LastBill UsageKey'
	set   @command=[FnInternal].GetString('0022-u-usagekey',@mainZoneKey);exec (@command);
	set @ErrorIno='Update LastBill BlockKey'
	set   @command=[FnInternal].GetString('0022-u-BlockKey',@mainZoneKey);exec (@command);--delete [Internal].[LastBill] where _row <>1 and MainZonekey=@mainZoneKey
	set @ErrorIno='Update DueDate BlockKey'
	UPDATE [Internal].[LastBill] set DateOfExpirePayment=d.DueDate,ExpirePaymentDateKey=d.DueDateKey 	from (	select distinct   i.ListNumber,dl.DueDate,dl.DueDateKey from [Internal].[LastBill] i join [BI].[DueDateList] dl on dl.ListNumber=i.ListNumber where dl.MainZoneKey=@mainZoneKey	)d where [Internal].[LastBill].ListNumber=d.ListNumber
	set @ErrorIno='Determine new items'
	UPDATE [Internal].[LastBill] set NeedUpdate=9 where customerkey not in (select customerkey from Bi.lastBill)
	set @ErrorIno='Insert new items in Bi LastBill'
	INSERT INTO [BI].[LastBill]([MainZoneKey] ,[CustomerNumber] ,[customerkey] ,[Id] ,[RegisterDateKey] ,[BillIdentifier] ,[PaymentIdentifier] ,[BillDays] ,[DateOfRead] ,[DateOfPrvRead] ,[DateOfRegister] ,[DateOfExpirePayment] ,[BillUsage] ,[BlockKey] ,[UsageKey] ,[Capacity] ,[UnitMain] ,[UnitMinor] ,[AmountPrv] ,[AmountBill] ,[AmountTotal] ,[DigitNumberPrv] ,[DigitNumber] ,[ListNumber] ,[BillingEmissionType_fldCode] ,[usageCode] ,[ExpirePaymentDateKey]) select [MainZoneKey] ,[CustomerNumber] ,[customerkey] ,[Id] ,[RegisterDateKey] ,[BillIdentifier] ,[PaymentIdentifier] ,[BillDays] ,[DateOfRead] ,[DateOfPrvRead] ,[DateOfRegister] ,[DateOfExpirePayment] ,[BillUsage] ,[BlockKey] ,[UsageKey] ,[Capacity] ,[UnitMain] ,[UnitMinor] ,[AmountPrv] ,[AmountBill] ,[AmountTotal] ,[DigitNumberPrv] ,[DigitNumber] ,[ListNumber] ,[BillingEmissionType_fldCode] ,[usageCode] ,[ExpirePaymentDateKey] from Internal.LastBill where MainZoneKey=@mainZoneKey and NeedUpdate=9 
	set @ErrorIno='Determine Changed items'
	UPDATE [Internal].[LastBill] set NeedUpdate=4 where NeedUpdate =0
 	set @ErrorIno='Update  Changed items in Bi LastBill'
	UPDATE [BI].[LastBill] SET [Id] = d.Id ,[RegisterDateKey] = d.RegisterDateKey ,[BillIdentifier] = d.BillIdentifier ,[PaymentIdentifier] =d.PaymentIdentifier ,[BillDays] = d.BillDays ,[DateOfRead] = d.DateOfRead ,[DateOfPrvRead] = d.DateOfPrvRead ,[DateOfRegister] =d.DateOfRegister ,[DateOfExpirePayment] =d.DateOfExpirePayment ,[BillUsage] =d.BillUsage ,[BlockKey] = d.BlockKey ,[UsageKey] = d.UsageKey ,[Capacity] = d.Capacity ,[UnitMain] = d.UnitMain ,[UnitMinor] = d.UnitMinor ,[AmountPrv] = d.AmountPrv ,[AmountBill] =d.AmountBill ,[AmountTotal] = d.AmountTotal ,[DigitNumberPrv] = d.DigitNumberPrv ,[DigitNumber] = d.DigitNumber ,[ListNumber] = d.ListNumber ,[BillingEmissionType_fldCode] = d.BillingEmissionType_fldCode ,[usageCode] = d.usageCode ,[ExpirePaymentDateKey] = d.ExpirePaymentDateKey from( select * from [Internal].[LastBill] where NeedUpdate=4 and MainZoneKey=@mainZoneKey)d  WHERE [BI].[LastBill].[MainZoneKey] = @MainZoneKey and [BI].[LastBill].customerkey=d.customerkey 
 	set @ErrorIno='Cast BillIdentifier as BigInt and Save Temporary'
	update [BI].[LastBill] set AmountTotal =cast( PaymentIdentifier as  bigint )
	set @ErrorIno='Update  TotalAmount in Bi LastBill'
	update [BI].[LastBill] set AmountTotal =( AmountTotal-AmountTotal% 100000)/100 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'LastBillInfo',@issuccessfull = 1
end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
