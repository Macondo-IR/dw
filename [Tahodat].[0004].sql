USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0004]    Script Date: 3/12/2022 12:40:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Tahodat].[0004]
AS BEGIN



update [Zone6BI].[Tahodat].[AllInstallmentBookSW]
set  [ExpireDate]=N'13'+ [ExpireDate]
where len( [ExpireDate])=8
and left( [ExpireDate],1)='9'

update [Zone6BI].[Tahodat].[AllInstallmentBookSW]
set [ExpireDate]=N'13'+ [ExpireDate]
where len( [ExpireDate])=8
and left( [ExpireDate],1)='8'

update [Zone6BI].[Tahodat].[AllInstallmentBookSW]
set  [ExpireDate]=N'14'+ [ExpireDate]
where len( [ExpireDate])=8
and left( [ExpireDate],2)='00'



 --اگه جزو پرداخت شده ها هست 
UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET [IsReceipt] =0
where [IsReceipt] =1
and ReceiptAmount =0


END
