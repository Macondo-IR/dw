USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0002]    Script Date: 3/12/2022 12:40:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Tahodat].[0002]
AS BEGIN


--خالی کردن جدول 
truncate table tahodat.AllInstallmentBookEsfandVosool
--پرکردن با اطلاعات لینک سرور
insert into tahodat.AllInstallmentBookEsfandVosool
select * from [172.26.0.4].[Qeraat2].[Temp].AllInstallmentBookEsfandVosool

--started with how many data 

select top 10 * from tahodat.AllInstallmentBookEsfandVosool


END
