USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0006]    Script Date: 3/12/2022 12:40:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Tahodat].[0006]
AS BEGIN

--پرداخت شده اما مبلغ پرداختی متفاوت است 
UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
 SET [IsNotBalancedReceipt] = 1,remainedamount=Amount-ReceiptAmount
 where [IsReceipt] =1
 and  Amount<>ReceiptAmount



END
