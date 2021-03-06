USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0011]    Script Date: 3/12/2022 12:37:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0011]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;
	declare @StartT datetime=getdate() 
	declare @ErrorIno nvarchar(max) ='start procedure 0011'
begin try 
	declare @todayDatekey int = fn.GetTodayDateKey()
	set @ErrorIno='Delete old Internal BillingBaseInfo'
	delete [Internal].[BillingBaseInfo] where mainZoneKey=@mainZoneKey
	declare @command nvarchar(max)
	set @ErrorIno='Get data from server'
	set @command= [FnInternal].[GetString]('0011-i-Internal',@mainZoneKey);exec (@command)
	set @ErrorIno='Determine new items'
	update [Internal].[BillingBaseInfo] set [NeedUpdate]=1  where mainzonekey=@mainZoneKey and  id not in (select id from bi.factcustomerInfo )
	set @ErrorIno='Insert new items in Factcustomerinfo'
	insert into [BI].[FactCustomerInfo]( [MainZoneKey] ,[Id] ,[Identification] ,[ReadingCode] ,[Coding] ,[CodingCode] ,[UnitBilling] ,[UnitMain] ,[UnitMinor] ,[UnitSWMain] ,[UnitSwMinor] ,[Capacity] ,[CapacitySewage]  ,[BodyNumber] ,[InstallationDateSewage] ,[ChangeDate] ,[fldLname] ,[fldFname] ,[_NameInstitution] ,[Maneh_fldCode] ,[WaterDiameter_fldCode] ,[SewageDiameter_fldCode] ,[_Address],UpdateDateKey,NeedProcess )select  [MainZoneKey] ,[Id] ,[Identification] ,[ReadingCode] ,[Coding] ,[CodingCode] ,[UnitBilling] ,[UnitMain] ,[UnitMinor] ,[UnitSWMain] ,[UnitSwMinor] ,[Capacity] ,[CapacitySewage]  ,[BodyNumber] ,[InstallationDateSewage] ,[ChangeDate] ,[fldLname] ,[fldFname] ,[_NameInstitution] ,[Maneh_fldCode] ,[WaterDiameter_fldCode] ,[SewageDiameter_fldCode] ,[_Address] ,@todayDatekey,1 from [Internal].[BillingBaseInfo]  where mainzonekey=@mainZoneKey and [NeedUpdate]=1
	set @ErrorIno='Determine Changed Items'
	update [Internal].[BillingBaseInfo] set [NeedUpdate]=2 from (select i.Id from [Internal].[BillingBaseInfo] i join [BI].[FactCustomerInfo] f on i.Id=f.Id and i.mainzonekey=@mainZoneKey  and [NeedUpdate]<>1 where  i.Identification<>f.Identification or i.ReadingCode<>f.ReadingCode or i.CodingCode<>f.CodingCode or i.UnitBilling<>f.UnitBilling or i.UnitMain<>f.UnitMain or i.UnitMinor<>f.UnitMinor or i.UnitSWMain<>f.UnitSWMain or i.UnitSwMinor<>f.UnitSwMinor or i.Capacity<>f.Capacity or i.CapacitySewage<>f.CapacitySewage or i.BodyNumber<>f.BodyNumber or i.InstallationDateSewage<>f.InstallationDateSewage or i.ChangeDate<>f.ChangeDate or i.fldLname<>f.fldLname or i.fldFname<>f.fldFname or i._NameInstitution<>f._NameInstitution or i._Address<>f._Address or i.WaterDiameter_fldCode<>f.WaterDiameter_fldCode or i.SewageDiameter_fldCode<>f.SewageDiameter_fldCode)d where d.id=[Internal].[BillingBaseinfo].id
	set @ErrorIno='Update changed items  in FactCustomerInfo'
	update bi.FactCustomerInfo set Identification=d.Identification, ReadingCode=d.ReadingCode, CodingCode=d.CodingCode, UnitBilling=d.UnitBilling, UnitMain=d.UnitMain, UnitMinor=d.UnitMinor, UnitSWMain=d.UnitSWMain, UnitSwMinor=d.UnitSwMinor, Capacity=d.Capacity, CapacitySewage=d.CapacitySewage, BodyNumber=d.BodyNumber, InstallationDateSewage=d.InstallationDateSewage, ChangeDate=d.ChangeDate, fldLname=d.fldLname, fldFname=d.fldFname, _NameInstitution=d._NameInstitution, _Address=d._Address,WaterDiameter_fldCode=d.WaterDiameter_fldCode,SewageDiameter_fldCode=d.SewageDiameter_fldCode,NeedProcess=1,UpdateDateKey=@todayDatekey,IsDataOcurrepted=0 from (select * from [Internal].[BillingBaseinfo]  where mainzonekey=@mainZoneKey and [NeedUpdate]=2)d  where d.id=bi.FactCustomerinfo.id 
	set @ErrorIno='Update StatusKey,CustomerKey in FactCustomerInfo'
	update [BI].[FactCustomerInfo] set StatusKey=d.StatusKey ,customerKey=d.customerkey from( SELECT i.[Id] ,c.StatusKey ,c.CustomerKey FROM [BI].[FactCustomerInfo] i join bi.FactCustomer c on i.Id=c.ID and i.MainZoneKey=c.MainZoneKey and i.needprocess=1) d where d.Id=[Zone6BI].[BI].[FactCustomerInfo] .Id
	set @ErrorIno='Update Name in FactCustomerInfo'
	update bi.FactCustomerInfo set _Name=ltrim(rtrim(ltrim(rtrim(fldLname))+' '+ltrim(rtrim(fldFname)))) where mainzonekey=@mainZoneKey and NeedProcess=1
	update bi.FactCustomerInfo set _Name=ltrim(rtrim(_NameInstitution)) where _Name is null  and  mainzonekey=@mainZoneKey and NeedProcess=1
	set @ErrorIno='Update WaterDiameterKey in FactCustomerInfo'
	set @command=[FnInternal].[GetString]('0011-u-WaterDiameterKey',@mainZoneKey);exec (@command)
	set @ErrorIno='Update SewageDiameterKey in FactCustomerInfo'
	set @command=[FnInternal].[GetString]('0011-u-SewageDiameterKey',@mainZoneKey);exec (@command)
	set @ErrorIno='Update BlockKey in FactCustomerInfo'
	set @command=[FnInternal].[GetString]('0011-u-BlockKey',@mainZoneKey);exec (@command)
	update bi.FactCustomerInfo set BlockKey=1 where BlockKey is null and mainZoneKey =@mainZoneKey
	set @ErrorIno='Determine Deleted id '
	declare @numFact int , @numInternal int ;select @numInternal= count(*) from [Internal].BillingBaseInfo where mainzonekey=@mainZoneKey;select @numFact=count(*) from  bi.FactCustomerInfo where mainzonekey=@mainZoneKey
	set @ErrorIno='Update Universal coding in FactCustomerInfo'
	update [BI].[FactCustomerInfo] set Coding=d.CodingTitle  from( SELECT CodingTitle ,coding FROM  universal.coding  ) d where  MainZoneKey=@mainZoneKey and needprocess=1 and CodingCode=d.coding
	set @ErrorIno='Update sewage installation in FactCustomerInfo'
	update [BI].[FactCustomerInfo] set HasSewage=1 where InstallationDateSewage is not null and  MainZoneKey=@mainZoneKey and needprocess=1
	update [BI].[FactCustomerInfo] set HasSewage=0 where InstallationDateSewage is  null and  MainZoneKey=@mainZoneKey and needprocess=1
	set @ErrorIno='Determine Deleted Items '
	if @numFact>@numInternal
	begin 
		update bi.FactCustomerInfo 	set [IsDeleted]=1	from (	select f.Id from [BI].FactCustomerInfo f 	where id not in (select id from [Internal].BillingBaseInfo where  mainzonekey=@mainZoneKey  )	and f.mainzonekey=@mainZoneKey	)d 	where d.Id=bi.FactCustomerInfo.Id
	end 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'FactCustomerInfo',@issuccessfull = 1
end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary =@ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem] @MainZoneCode =@mainZoneKey

END
