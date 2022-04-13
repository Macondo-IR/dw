USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Security].[ShrinkLog]    Script Date: 3/12/2022 12:42:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--USE Zone6BI

-- =============================================
ALTER PROCEDURE [Security].[ShrinkLog]
AS
BEGIN

ALTER DATABASE Zone6BI SET RECOVERY SIMPLE



DBCC SHRINKFILE (Zone6BI_log, 5)



ALTER DATABASE Zone6BI SET RECOVERY FULL





END

