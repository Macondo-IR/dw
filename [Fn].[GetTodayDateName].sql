USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetTodayDateName]    Script Date: 3/12/2022 12:43:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [Fn].[GetTodayDateName]
()
RETURNS varchar(10) 
AS
BEGIN

	DECLARE @OUT varchar(10)  
	DECLARE @DATE DATE 
	SET @DATE=GETDATE() 


	select @OUT= datename from  Zone6BI.[BI].[DimDate] where [MiladiDate]=@DATE


	RETURN @OUT

END
