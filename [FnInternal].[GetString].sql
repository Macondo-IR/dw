USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [FnInternal].[GetString]    Script Date: 3/12/2022 12:43:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [FnInternal].[GetString]
(@code nvarchar(max),@mainZoneKey int )
RETURNS nvarchar(max) 
AS
BEGIN

	DECLARE @OUT nvarchar(max) 
declare @Mi nvarchar(max)=[Fn].[GetTitleofMainZone](@mainZoneKey)--
declare @zonekey nvarchar(max) =cast (@mainZoneKey as nvarchar(max))
declare @MainTable nvarchar(max)=[Fn].GetMainTableofMainZone(@mainZoneKey)

	select @OUT=
	case 
		when @code='0010-i-Internal'
			then 'insert into internal.BillingBaseId(id,mainZoneKey,[fldcustomernumber],[SaledUnit],[RemoveCode],[WaterinstallationDate],[karbariCode],[customerRegionCode]) select tbBillingBase_ID ,'+cast (@mainZoneKey as nvarchar(max))+' ,fldcustomernumber ,fldsalewaterunit, Remove_fldCode ,fldWaterinstallationDate ,KarbariUsage_fldCode,tbCustomerOfficeRegion_ID from '+[Fn].[GetMainTableofMainZone](@mainZoneKey)+'.dbo.tbbillingbase'
		when @code='0010-u-StatusKey'
			then 'update BI.FactCustomer  set [StatusKey]=d.StatusKey from(select  CustomerKey,s.StatusKey from [BI].[FactCustomer] f   left join [BI].[DimStatus] s on f.RemoveCode=s.'+[Fn].[GetTitleofMainZone](@mainZoneKey)+'RemoveType where NeedProcess=1 and f.mainzonekey='+cast (@mainZoneKey as nvarchar(max))+')d where d.CustomerKey= BI.FactCustomer.CustomerKey'
		when @code='0010-u-InstallationDateKey'
			then 'update BI.FactCustomer  set InstallationDateKey=d.DateKey from(select  CustomerKey,d.DateKey from [BI].[FactCustomer] f left join [BI].DimDate d on d.DateName  collate Arabic_CI_AS  =  WaterInstallationDate  where NeedProcess=1 and f.mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' )d where d.CustomerKey=BI.FactCustomer.CustomerKey'
		when @code='0010-u-UsageKey'
			then 'update BI.FactCustomer  set UsageKey=d.UsageKey from(select  CustomerKey,u.UsageKey from [BI].[FactCustomer] f left join BI.DimUsage u on u.'+[Fn].[GetTitleofMainZone](@mainZoneKey)+'UsageCode =f.KarbariCode  where NeedProcess=1 and f.mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' )d where d.CustomerKey= BI.FactCustomer.CustomerKey'
		when @code='0010-u-ZoneKey'
			then 'update BI.FactCustomer  set ZoneKey=d.ZoneKey from(select  CustomerKey,z.ZoneKey from [BI].[FactCustomer] f left join BI.DimZone z on z.tbCustomerOfficeRegion_ID =f.CustomerRegionCode  where NeedProcess=1 and f.mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' )d where d.CustomerKey=BI.FactCustomer.CustomerKey'

		when @code='0011-i-internal'
			then 'INSERT INTO [Internal].[BillingBaseInfo]([MainZoneKey] ,[Id] ,[Identification] ,[ReadingCode] ,[CodingCode] ,[UnitBilling] ,[UnitMain] ,[UnitMinor] ,[UnitSWMain] ,[UnitSwMinor] ,[Capacity] ,[CapacitySewage]  ,[BodyNumber] ,[InstallationDateSewage] ,[ChangeDate] ,[fldLname] ,[fldFname] ,[_NameInstitution] ,[Maneh_fldCode] ,[WaterDiameter_fldCode] ,[SewageDiameter_fldCode] ,[_Address]) select '+cast (@mainZoneKey as nvarchar(max))+' ,tbb.tbBillingBase_ID ,fldIdentificationCode ,fldreadingcode,tbb.KarbariUsageLevel_fldCode ,fldBillingWaterUnit,fldSaleWaterUnit,fldMinorUnit ,fldSewageUnit,fldSewageMinorUnit,fldContractCapacity,fldSewageContractCapacity  ,tbb.fldKontourBodyNumber as BodyNumber,fldSewageInstallationDate,fldKontourChangeDate ,tp.fldLname ,tp.fldFname ,tp.fldInstitutionTitle as _NameInstitution,isnull(tbb.Maneh_fldCode,0) ,isnull(tbb.WaterDiameter_fldCode,0) ,isnull(tbb.SewageDiameter_fldCode,0) ,fldAddress as _Address from '+[Fn].[GetMainTableofMainZone](@mainZoneKey)+'.dbo.tbbillingbase tbb join '+[Fn].[GetMainTableofMainZone](@mainZoneKey)+'.dbo.tbPerson tp on tp.tbPerson_ID =tbb.tbPerson_ID'
		when @code='0012-i-Internal'
			then 'insert into Internal.Mobile (MainZoneKey,Id,Mobile) select '+ @zonekey+', mob.tbBillingBase_ID as ID ,mob.fldMultiMediaContact from  '+@MainTable+'.dbo.tbMultiMediaContactNumber mob where mob.fldIsActive=1'
		when @code='0013-i-Internal'
			then 'INSERT INTO [Internal].[Finance]([Id],[MainZoneKey] ,[AmountBilling],[AmountWaterBranch],[AmountSewageBranch] )		select tbBillingBase_ID ,'+cast (@mainZoneKey as nvarchar(max))+' ,[fldbillingdebtamount] ,[fldwaterbranchdebtamount] ,[fldsewagebranchdebtamount]  from '+[Fn].[GetMainTableofMainZone](@mainZoneKey)+'.dbo.tbbillingbase'
			
		when @code='0011-u-WaterDiameterKey'
			then 'update bi.FactCustomerInfo set [WaterDiameterKey]=d.WaterDiameterKey from( select WaterDiameterKey ,'+@Mi+'WaterDiameterCode as WaterDiameterCode from [BI].[DimWaterDiameter]) d where d.WaterDiameterCode=WaterDiameter_fldCode and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' and NeedProcess=1 '
		when @code='0011-u-SewageDiameterKey'
			then 'update bi.FactCustomerInfo set [SewageDiameterKey]=d.SewageDiameterKey from( select SewageDiameterKey ,'+@Mi+'SewageDiameterCode as SewageDiameterCode from [BI].[DimSewageDiameter]) d where d.SewageDiameterCode=SewageDiameter_fldCode and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' and NeedProcess=1 '
		when @code ='0011-u-BlockKey'
			then 'update [BI].FactCustomerInfo set [BlockKey] =d.BlockKey from (select '+@Mi+'RemoveCode as  removecode , BlockKey  FROM [BI].[DimBlock])d   where d.removecode= [BI].FactCustomerInfo.Maneh_fldCode  and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' and NeedProcess=1 '
		when @code ='0015-u-usagekey'
			then 'update [BI].[FactIncomeBillAmount] set  usagekey =d.usagekey  from (select 	  UsageKey      ,['+@Mi+'UsageCode] as usageCode  FROM [BI].[DimUsage] ) d where d.usagecode=[BI].[FactIncomeBillAmount].usageCode and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' and NeedProcess=1 and  IncomeTypeKey=10'
		when @code ='0016-u-usagekey'
			then 'update [BI].[FactIncomeBillAmount] set  usagekey =d.usagekey  from (select 	  UsageKey      ,['+@Mi+'UsageCode] as usageCode  FROM [BI].[DimUsage] ) d where d.usagecode=[BI].[FactIncomeBillAmount].usageCode and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+' and NeedProcess=1 and  IncomeTypeKey=30'
		when @code ='0022-u-usagekey'
			then 'update [Internal].[LastBill] set  usagekey =d.usagekey  from (select 	  UsageKey      ,['+@Mi+'UsageCode] as usageCode  FROM [BI].[DimUsage] ) d where d.usagecode=[Internal].[LastBill].usageCode and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+''
		when @code ='0022-u-BlockKey'
			then 'update [Internal].[LastBill] set [BlockKey] =d.BlockKey from (select '+@Mi+'RemoveCode as  removecode , BlockKey  FROM [BI].[DimBlock])d   where d.removecode= [Internal].[LastBill].Maneh_fldCode  and mainzonekey='+cast (@mainZoneKey as nvarchar(max))+''
		when @code ='0022-u'
			then 'UPDATE [Internal].[LastBill] set [CustomerNumber]=d.CustomerNumber ,[BillIdentifier]=d.BillIdentifier ,[PaymentIdentifier]=d.PaymentIdentifier ,[BillDays]=d.BillDays ,[DateOfRead]=d.DateOfRead ,[DateOfPrvRead]=d.DateOfPrvRead ,[DateOfRegister]=d.DateOfRegister ,[BillUsage]=d.BillUsage ,[Capacity]=d.[Capacity] ,[UnitMain]=d.UnitMain ,[UnitMinor]=d.UnitMinor ,[AmountPrv]=d.AmountPrv ,[AmountBill]=d.AmountBill ,[DigitNumberPrv]=d.DigitNumberPrv ,[DigitNumber]=d.DigitNumber ,[ListNumber]=d.ListNumber ,[BillingEmissionType_fldCode]=d.BillingEmissionType_fldCode ,[Maneh_FldCode]=d.Maneh_FldCode ,UsageCode=d.UsageCode	from(	SELECT t.fldcustomernumber as [CustomerNumber] ,[customerkey] ,[Id] ,[RegisterDateKey] ,t.fldBillIdentifier as BillIdentifier ,t.fldPaymentIdentifier as PaymentIdentifier ,t.fldDay as BillDays ,fldReadingNowDate as DateOfRead ,fldReadingPreviousDate as DateOfPrvRead	,fldRegisterDate as DateOfRegister ,t.fldUsage as BillUsage ,t.fldWaterMaghtouCapacity as Capacity 	,t.fldMinorUnit as UnitMinor ,t.fldPreviousDigit as DigitNumberPrv ,t.fldNowDigit as DigitNumber	,t.fldBillAmount as AmountBill ,t.fldUnitTedad as UnitMain ,t.fldReadingListNumber as ListNumber 	,t.[BillingEmissionType_fldCode] ,isnull(t.Maneh_FldCode,0) as Maneh_FldCode ,isnull(t.KarbariUsage_fldCode,0) as UsageCode 	,t.fldBillingPreviousDebt as AmountPrv 	FROM [Internal].[LastBill] 	join '+@MainTable+'.dbo.tbbillingemissioninformation t 	on [Internal].[LastBill].Id= t.tbBillingEmissionInformation_ID	and [Internal].[LastBill].mainzonekey='+@zonekey+'	)d where d.id =[Internal].[LastBill].Id '
	end 

	RETURN @OUT

END
