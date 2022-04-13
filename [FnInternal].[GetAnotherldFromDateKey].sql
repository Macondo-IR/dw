USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [FnInternal].[GetAnotherldFromDateKey]    Script Date: 3/12/2022 12:43:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [FnInternal].[GetAnotherldFromDateKey] (@datekey int ) returns int as begin return (select anotherid from M6BI.[BI]. [DimDate] where datekey= @datekey) end