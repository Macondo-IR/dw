USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [Fn].[GetMainTableofMainZone]    Script Date: 3/12/2022 12:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER function [Fn].[GetMainTableofMainZone] (@mainZoneCode int ) returns nvarchar(max)
as begin 
return (
select MainTable from Internal.[MainZone] where [MainZoneCode]= @mainZoneCode
) end
