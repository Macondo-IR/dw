USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetTitleofMainZone]    Script Date: 3/12/2022 12:43:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER function [Fn].[GetTitleofMainZone] (@mainZoneCode int ) returns nvarchar(max)
as begin 
return (
select title from Internal.[MainZone] where [MainZoneCode]= @mainZoneCode
) end
