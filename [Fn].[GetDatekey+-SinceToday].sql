USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetDatekey+-SinceToday]    Script Date: 3/12/2022 12:42:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER function [Fn].[GetDatekey+-SinceToday] (@days int ) returns int as
begin
DECLARE @Result varchar(10)
declare @Ago date set @Ago=DATEADD(day,@days, GETDATE()) --print @Ago
select @Result=DateKey from [BI].[DimDate] where MiladiDate= @Ago
return @Result
end
