USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [FnInternal].[GetTodayAnotherld]    Script Date: 3/12/2022 12:43:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [FnInternal].[GetTodayAnotherld] () returns int as
begin
declare @date date select @date =GETDATE()
return (select anotherid from M6BI.[BI]. [DimDate] where MiladiDate= @date) end
