USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Tahodat].[0009]    Script Date: 3/12/2022 12:41:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [Tahodat].[0009]
AS BEGIN
--وصولی نقد ها رو از اون سرور بیار این سرور 

truncate table tahodat.[VosoolNaghd]
--پرکردن با اطلاعات لینک سرور
insert into tahodat.[VosoolNaghd]
select * from [172.26.0.4].[Qeraat2].BI.[VosoolNaghd]

--started with how many data 

select top 10 * from tahodat.[VosoolNaghd]
END
