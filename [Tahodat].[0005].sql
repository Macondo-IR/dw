USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0005]    Script Date: 3/12/2022 12:40:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Tahodat].[0005]
AS BEGIN

 


--بالانس ها رو معین کن 



UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET [IsBalancedReceipt] = 1,DelayedAmount=0
where [IsReceipt] =1
and  Amount=ReceiptAmount



END
