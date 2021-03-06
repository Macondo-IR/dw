USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0008]    Script Date: 3/12/2022 12:41:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [Tahodat].[0008]
AS BEGIN
--آتی ها مشخص شود 


declare @datekey int 
set  @datekey=[Fn].[GetTodayDateKey]()



--هنوز پرداختی نداشته است 

UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET IsFutureDebt =1,FutureDebt=Amount 
where ExpireDatekey>=@datekey
and  [IsReceipt]=0




-- تمام قسط اینده پرداخت کرده 
--کامل   

UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET IsFutureDebt =1,FutureDebt=0 
where ExpireDatekey>=@datekey
and  [IsReceipt]=1
AND IsBalancedReceipt=1


--کمتر   
UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET IsFutureDebt =1,FutureDebt=RemainedAmount 
where ExpireDatekey>=@datekey
and  [IsReceipt]=1
AND IsNotBalancedReceipt=1
AND RemainedAmount>0

--بیشتر
UPDATE [Zone6BI].[Tahodat].[AllInstallmentBookSW]
SET IsFutureDebt =1,FutureDebt=RemainedAmount 
where ExpireDatekey>=@datekey
and  [IsReceipt]=1
AND IsNotBalancedReceipt=1
AND RemainedAmount<0


END
