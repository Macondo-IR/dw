USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetTodayDateKey]    Script Date: 3/12/2022 12:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [Fn].[GetTodayDateKey]
()
RETURNS INT 
AS
BEGIN

	DECLARE @OUT INT 
	DECLARE @DATE DATE 
	SET @DATE=GETDATE() 


	select @OUT= DateKey from  Zone6BI.[BI].[DimDate] where [MiladiDate]=@DATE


	RETURN @OUT

END
