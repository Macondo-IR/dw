USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetDateNameFromDateKey]    Script Date: 3/12/2022 12:42:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [Fn].[GetDateNameFromDateKey](@datekey int ) returns Char(10)
AS BEGIN
DECLARE @Result Char(10)
select @Result=[DateName] from [BI].[DimDate] where DateKey= @datekey
return @Result
END
