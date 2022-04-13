USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0003]    Script Date: 3/12/2022 12:40:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Tahodat].[0003]
AS BEGIN

truncate table [Zone6BI].[Tahodat].[AllInstallmentBookSW] 

insert into [Zone6BI].[Tahodat].[AllInstallmentBookSW]
(
 [fldCustomerNumber]
      --,[customerkey]
      ,[Amount]
      ,[ExpireDate]
      ,[IsReceipt]
      ,[IsCancelled]
      ,[tbInstallmentBookInfo_ID]
      ,[tbInstallmentBookEmission_ID]
      ,[fldBillIdentifier]
      ,[fldPaymentIdentifier]
      ,[ReceiptAmount]
      ,[fldSerial]
      ,[Code]
      --,[IsFutureDebt]
      ,[IsExpired]
      ,[IsBalancedReceipt]
      ,[IsNotBalancedReceipt]
      ,[DelayedAmount]
      ,[RemainedAmount]
      ,[FutureDebt]
      --,[VirtualReceiptAmount]
      --,[IsVirtualCase]
      --,[VirtualExtraAmount]
      --,[Row]
)

  -- SELECT [fldCustomerNumber]
  --    --,[customerkey]
  --    ,[Amount]
  --    ,[ExpireDatekey]
  --    ,[IsReceipt]
  --    ,[IsCancelled]
  --    ,[tbInstallmentBookInfo_ID]
  --    ,[tbInstallmentBookEmission_ID]
  --    ,[fldBillIdentifier]
  --    ,[fldPaymentIdentifier]
  --    ,[ReceiptAmount]
  --    ,[fldSerial]
  --    ,[Code]
  --    --,[IsFutureDebt]
  --    --,[IsExpired]
  --    --,[IsBalancedReceipt]
  --    --,[IsNotBalancedReceipt]
  --    --,[DelayedAmount]
  --    --,[RemainedAmount]
  --    --,[FutureDebt]
  --    --,[VirtualReceiptAmount]
  --    --,[IsVirtualCase]
  --    --,[VirtualExtraAmount]
  --    --,[Row]
  --FROM [Zone6BI].[Tahodat].[AllInstallmentBookSW]


SELECT   [fldCustomerNumber]
      ,[fldAmount]
      ,[ExpiryDate]
      ,[IsReceipt]
      ,[IsCancelled]
      ,[tbInstallmentBookInfo_ID]
      ,[tbInstallmentBookEmission_ID]
      ,[fldBillIdentifier]
      ,[fldPaymentIdentifier]
      ,[fldReceiptAmount]
      ,[fldSerial]
	  ,[Code]
	  ,0,0,0,0,0,0--6 tayii ha
      --,[tbFloorDetail_ID]
      --,[fldPersonIdentifier]
     
      --,[IsUpdated]
  FROM [Zone6BI].[Tahodat].[AllInstallmentBookBahman]





END
