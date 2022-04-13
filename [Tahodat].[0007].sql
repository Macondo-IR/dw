USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0007]    Script Date: 3/12/2022 12:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [Tahodat].[0007]
AS BEGIN

--مشخص کردن  منقضی شده ها 



declare @datekey int 
set  @datekey=[Fn].[GetTodayDateKey]()
--PRINT @datekey

--اونایی که یه قرون هم پول ندادن 


UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET IsExpired =1,delayedamount  =amount  
where ExpireDatekey<@datekey
and [IsReceipt]=0



--اونایی که چس مثقال پرداخت کردن ولی ... 

UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET IsExpired =1 ,delayedamount=remainedamount
where ExpireDatekey<@datekey
and [IsNotBalancedReceipt]=1
and remainedamount>0--مبلغ پرداختی کمتر هست . 



END
