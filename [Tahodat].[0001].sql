USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0001]    Script Date: 3/12/2022 12:40:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Tahodat].[0001]
AS BEGIN


--خالی کردن جدول 
truncate table tahodat.AllInstallmentBookBahman
--پرکردن با اطلاعات لینک سرور
insert into tahodat.AllInstallmentBookBahman
select * from [172.26.0.4].[Qeraat2].[Temp].[AllInstallmentBookBahman]

--started with how many data 



END
