USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0010]    Script Date: 3/12/2022 12:36:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [BI].[0010]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;
declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='Start procedure 0010'
begin try 
	declare @todayDatekey int = fn.GetTodayDateKey()
	declare @command nvarchar(max)
	set @ErrorIno='Delete old Internal BillingBaseId'
	delete [Internal].[BillingBaseId] where mainZoneKey=@mainZoneKey
	set @ErrorIno='Get data from server'
	set @command= [FnInternal].[GetString]('0010-i-Internal',@mainZoneKey);	exec (@command)
	set @ErrorIno='Determine new items'
	update [Internal].[BillingBaseId] set [NeedUpdate]=1  where mainzonekey=@mainZoneKey and  id not in (select id from bi.factcustomer )
	set @ErrorIno='Insert in bi FactCustomer'
	insert into [BI].[FactCustomer](Id,[MainZoneKey],[NeedProcess],[CustomerNumber],unitnumber,RemoveCode,waterinstallationdate,KarbariCode,CustomerRegionCode,UpdateDateKey)	select *,@todayDatekey from [Internal].[BillingBaseId]  where mainzonekey=@mainZoneKey and [NeedUpdate]=1
	set @ErrorIno='Determine Changed items'
	update [Internal].[BillingBaseId] set [NeedUpdate]=2	from (	select i.Id from [Internal].[BillingBaseId] i 	join [BI].[FactCustomer] f on i.Id=f.Id and i.mainzonekey=@mainZoneKey  and [NeedUpdate]<>1 	where 	 i.fldcustomernumber<>f.CustomerNumber	 or i.SaledUnit<>f.UnitNumber	 or i.RemoveCode<>f.RemoveCode	 or i.waterinstallationdate<>f.waterinstallationdate	 or i.KarbariCode<>f.KarbariCode	 or i.CustomerRegionCode<>f.CustomerRegionCode	)d	where d.id=[Internal].[BillingBaseId].id and [Internal].[BillingBaseId].MainZonekey=@mainZoneKey
	set @ErrorIno='Update changed in FactCustomer'
	update bi.FactCustomer	set CustomerNumber=d.fldcustomernumber	,UnitNumber=d.SaledUnit	,RemoveCode=d.RemoveCode	,waterinstallationdate=d.waterinstallationdate	,KarbariCode=d.KarbariCode	,CustomerRegionCode=d.CustomerRegionCode	,NeedProcess=1	,UpdateDateKey=@todayDatekey	,IsDataOcurrepted=0	from 	(	select * from [Internal].[BillingBaseId]  where mainzonekey=@mainZoneKey and [NeedUpdate]=2	)d 	where d.id=bi.FactCustomer.id
	set @ErrorIno='Update FactCustomer StatusKey'
	set @command=[FnInternal].[GetString]('0010-u-StatusKey',@mainZoneKey);	exec (@command);
	set @ErrorIno='Update FactCustomer InstallationDateKey'
	set @command=[FnInternal].[GetString]('0010-u-InstallationDateKey',@mainZoneKey);	exec (@command)
	set @ErrorIno='Update FactCustomer UsageKey'
	set @command=[FnInternal].[GetString]('0010-u-UsageKey',@mainZoneKey);	exec (@command)
	set @ErrorIno='Update FactCustomer ZoneKey'
	set @command=[FnInternal].[GetString]('0010-u-ZoneKey',@mainZoneKey);	exec (@command)
	set @ErrorIno='Update FactCustomer Null InstallationDatekey'
	update [BI].[FactCustomer] set InstallationDateKey=13000101 where InstallationDateKey is null and NeedProcess=1 and MainZoneKey=@mainZoneKey and StatusKey=2
	update [BI].[FactCustomer] set InstallationDateKey=@todayDatekey where InstallationDateKey is null and NeedProcess=1 and MainZoneKey=@mainZoneKey and StatusKey=4
	update [BI].[FactCustomer] set InstallationDateKey=@todayDatekey where InstallationDateKey is null and MainZoneKey=@mainZoneKey and StatusKey=3
	set @ErrorIno='Update FactCustomer Null Zonekey'
	declare @internalZonekey int ;	select top(1) @internalZonekey =zonekey from bi.DimZone where  MainZoneKey=@mainZoneKey
	update [BI].[FactCustomer] set ZoneKey =@internalZonekey where ZoneKey is null and NeedProcess=1 and MainZoneKey=@mainZoneKey and StatusKey in (2,4)
	set @ErrorIno='Determine  FactCustomer DataOcurrepted items'
	update [BI].[FactCustomer] set  IsDataOcurrepted=1 where  NeedProcess=1 and MainZoneKey=@mainZoneKey and (ZoneKey is null or StatusKey is null or UsageKey is null or InstallationDateKey is null  )
	set @ErrorIno='Return FactCustomerprocesseed items to normal'
	update [BI].[FactCustomer] set  NeedProcess=0 where  NeedProcess=1 and MainZoneKey=@mainZoneKey 
	set @ErrorIno='Check For Determine Deleted Items'
	declare @numFact int , @numInternal int ;	select @numInternal= count(*) from [Internal].[BillingBaseId] where mainzonekey=@mainZoneKey;	select @numFact=count(*) from  bi.FactCustomer where mainzonekey=@mainZoneKey
	set @ErrorIno='check deleted FactCustomer Items'
	if @numFact>@numInternal
		begin 		update bi.FactCustomer		set [IsDeleted]=1		from (		select f.Id from [BI].[FactCustomer] f 		where id not in (select id from [Internal].[BillingBaseId] where  mainzonekey=@mainZoneKey  )		and f.mainzonekey=@mainZoneKey		)d		where d.Id=bi.FactCustomer.Id
	end 
	EXEC Security.[Log]	@MainZoneCode=@mainZoneKey,	@StartTime=@StartT,	@summary = N'FactCustomers',	@issuccessfull = 1
end try 
begin catch 
	EXEC Security.[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT ,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey
END
