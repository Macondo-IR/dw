USE [Zone6BI]
GO
/****** Object:  StoredProcedure [Security].[AddHelp]    Script Date: 3/12/2022 12:41:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Security].[AddHelp]
(@Code nvarchar(4) ,@Title nvarchar(max) ) 
AS
BEGIN

declare @datekey int =[Fn].[GetTodayDateKey]()

INSERT INTO [dbo].[Help]
           ([code]
           ,[Title]
           ,[CreatedAt])
     VALUES (@Code,@Title,@datekey)

select * from [dbo].[Help]
where 1=1 order by code desc



END

