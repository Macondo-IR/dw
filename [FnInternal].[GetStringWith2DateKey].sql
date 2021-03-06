USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [FnInternal].[GetStringWith2DateKey]    Script Date: 3/12/2022 12:43:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [FnInternal].[GetStringWith2DateKey]
(@code nvarchar(max),@mainZoneKey int ,@datekey1 int ,@datekey2 int)
RETURNS nvarchar(max) 
AS
BEGIN

declare @date1 nvarchar(10)=Fn.GetDateNameFromDateKey(@datekey1);
declare @date2 nvarchar(10)=Fn.GetDateNameFromDateKey(@datekey2);
declare @OUT nvarchar(max) 
declare @Mi nvarchar(max)=[Fn].[GetTitleofMainZone](@mainZoneKey)--
declare @MainTable nvarchar(max)=[Fn].[GetMainTableofMainZone](@mainZoneKey)
declare @ZoneKey nvarchar(max)=cast (@mainZoneKey as nvarchar(max))

select @OUT=
case 
	when @code='0015-i-Internal'
		then 'INSERT INTO [Internal].[IncomeBilling]([MainZoneKey],[IncomeTypeKey],[fldCustomerNumber],[fldRegisterdate],[Id],[Amount],[Volume],[days],[unit],usageCode) SELECT  '+@ZoneKey+',10 as IncomeTypeKey, fldCustomerNumber,tbei.fldregisterdate,tbei.tbBillingEmissionInformation_ID,fldBillAmount,fldUsage,fldDay,fldUnitTedad,KarbariUsage_fldCode FROM '+@MainTable+'.dbo.tbBillingEmissionInformation tbei WHERE 1=1 and fldRegisterDate BETWEEN '''+@date1+''' AND '''+@date2+''' And (isnull(tbei.Maneh_fldCode,0)  IN (SELECT '+@Mi+'RemoveCode   FROM [BI].[DimBlock] m where m.isbillingcontain=1))'
	when @code='0016-i-Internal'
		then 'INSERT INTO [Internal].[IncomeBilling]([MainZoneKey],[IncomeTypeKey],[fldCustomerNumber],[fldRegisterdate],[ID],[Amount],[Volume],[Days],[Unit],[UsageCode])SELECT '+@ZoneKey+',30 as IncomeTypeKey,tbei.fldCustomerNumber ,tbbc.fldRegisterDate,tbbcd.tbBillingBillCancellationDetail_ID as id,tbei.fldBillAmount,tbei.fldUsage,tbei.fldDay,tbei.fldUnitTedad,tbei.KarbariUsage_fldCode FROM '+@MainTable+'.dbo.tbBillingBillCancellation tbbc JOIN '+@MainTable+'.dbo.tbBillingBillCancellationDetail tbbcd ON tbbcd.tbBillingBillCancellation_ID = tbbc.tbBillingBillCancellation_ID JOIN '+@MainTable+'.dbo.tbBillingEmissionInformation tbei ON tbbcd.tbBillingEmissionInformation_ID=tbei.tbBillingEmissionInformation_ID WHERE 1=1  and tbbc.fldRegisterDate BETWEEN '''+@date1+''' AND '''+@date2+''' And (isnull(tbei.Maneh_fldCode,0)  IN (SELECT '+@Mi+'RemoveCode   FROM [BI].[DimBlock] m where m.isbillingcontain=1))'
	when @code='0017-i-Internal-Normal'
		then 'INSERT INTO [Internal].[IncomeBilling]([MainZoneKey],[IncomeTypeKey],[fldCustomerNumber],[fldRegisterdate],[ID],[Amount]) select  '+@ZoneKey+',21 as IncomeTypeKey,tbei.fldCustomerNumber,tcbr.fldRegisterDate,tcbi.tbCashBillInfo_ID as id,tcbi.fldAmount as Amount from  '+@MainTable+'.dbo.tbBillingEmissionInformation tbei  join '+@MainTable+'.dbo.tbCashBillInfo tcbi  on tcbi.tbBillingEmissionInformation_ID=tbei.tbBillingEmissionInformation_ID JOIN '+@MainTable+'.dbo.tbCashBillReceipt tcbr ON tcbr.tbCashBillReceipt_ID = tcbi.tbCashBillReceipt_ID WHERE tcbr.InstructionType_fldCode=2 and tcbi.tbBillingEmissionInformation_ID is not null 	and tcbr.fldRegisterDate between '''+@date1+''' AND '''+@date2+''''
	when @code='0017-i-Internal-Special'
		then 'INSERT INTO [Internal].[IncomeBilling]([MainZoneKey],[IncomeTypeKey],[fldCustomerNumber],[fldRegisterdate],[ID],[Amount]) 	select  '+@ZoneKey+',22 as IncomeTypeKey,tsst.fldCustomerNumber,tcbr.fldRegisterDate,tcbi.tbCashBillInfo_ID as id,tcbi.fldAmount as Amount 	from '+@MainTable+'.dbo.tbSaleServiceType tsst JOIN '+@MainTable+'.dbo.tbSpecialBillEmission tsbe on tsbe.tbSaleServiceType_ID=tsst.tbSaleServiceType_ID 	JOIN '+@MainTable+'.dbo.tbSpecialBillEmissionDetail tsbed on tsbe.tbSpecialBillEmission_ID=tsbed.tbSpecialBillEmission_ID 	join '+@MainTable+'.dbo.tbCashBillInfo tcbi on tcbi.tbSpecialBillEmissionDetail_ID=tsbed.tbSpecialBillEmissionDetail_ID JOIN '+@MainTable+'.dbo.tbCashBillReceipt tcbr ON tcbr.tbCashBillReceipt_ID = tcbi.tbCashBillReceipt_ID   	WHERE 1=1	and tcbr.fldRegisterDate between '''+@date1+''' AND '''+@date2+''''
	when @code='0018-i-Internal'
		then 'INSERT INTO [Internal].[IncomeBilling]([MainZoneKey],[IncomeTypeKey],[fldCustomerNumber],[fldRegisterdate],[ID],[Amount]) 	select  '+@ZoneKey+',40 as IncomeTypeKey,tsst.fldCustomerNumber,tsst.fldRequestDate,trcd.tbReceiptCancellationDetail_ID as id,trcd.fldTotalAmount as Amount FROM '+@MainTable+'.dbo.tbReceiptCancellationDetail trcd JOIN '+@MainTable+'.dbo.tbReceiptCancellation trc ON trc.tbReceiptCancellation_ID = trcd.tbReceiptCancellation_ID JOIN '+@MainTable+'.dbo.tbSaleServiceType tsst ON tsst.tbSaleServiceType_ID=trc.tbSaleServiceType_ID where  InstructionTypeDetail_fldCode=3 and tsst.fldRequestDate  between '''+@date1+''' AND '''+@date2+''''
	when @code ='0021-i-internal'
		then ' INSERT INTO [Internal].[DueDateList]([MainZoneKey],[ListNumber],PrintDate,[DueDate])SELECT '+@ZoneKey+',fldReadingListNumber ,fldprintdate,fldPrintBreak FROM  '+@MainTable+'.dbo.tbReadingListPrint p join '+@MainTable+'.dbo.tbReadingListPrintDetail  d on p.tbReadingListPrint_ID=d.tbReadingListPrint_ID where 1=1 and  fldprintdate between '''+@date1+''' AND '''+@date2+''''
	when @code ='0022-i-internal'
		then 'INSERT INTO [Internal].[LastBill](MainZoneKey,[customerkey],[Id],[RegisterDateKey]) SELECT  '+@ZoneKey+',[customerkey],[Id],[registerDatekey]  FROM [BI].[FactIncomeBillAmount]  where [IncomeTypeKey] =10  and registerDatekey between '+cast (@datekey1 as nvarchar(max))+' and '+cast (@datekey2 as nvarchar(max))+' and MainZoneKey='+@ZoneKey+''


end 

	RETURN @OUT

END
