USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetDaysSinceTodayFromDatekey]    Script Date: 3/12/2022 12:42:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [Fn].[GetDaysSinceTodayFromDatekey] (@datekey int )
returns int as

begin
return (select 
[FnInternal].[GetAnotherldFromDateKey](@datekey)-[FnInternal].[GetTodayAnotherld]())
end
