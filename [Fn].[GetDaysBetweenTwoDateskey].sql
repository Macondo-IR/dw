USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetDaysBetweenTwoDateskey]    Script Date: 3/12/2022 12:42:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [Fn].[GetDaysBetweenTwoDateskey]( @daykey1 int,@daykey2 int ) returns int as
begin
return (select 
[FnInternal].[GetAnotherldFromDateKey](@daykey1)-[FnInternal].[GetAnotherldFromDateKey](@daykey2))
end
