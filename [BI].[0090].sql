USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0090]    Script Date: 3/12/2022 12:38:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0090]
AS BEGIN
SET NOCOUNT ON;

declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0090'
declare @command nvarchar(max) 

begin try 

--USE 

declare @mainZoneKey int =6



set @ErrorIno='Delete old  [mobileAban]'
delete [172.26.0.4].[Qeraat2].[dbo].[mobileAban]
insert into [172.26.0.4].[Qeraat2].[dbo].[mobileAban](p,mobile,mamoor)
SELECT  
_10.C6 'پرونده'
--,_10.C7 'اشتراک شماره '
,_10.C42 'تلفن همراه پیماییش'
--,_10.C47 'تاریخ و زمان', (_10.C9+' '+_10.C10) 'نام مشترک'
, (u.FirstName+' '+u.LastName) 'نام مامور قرائت' 
FROM [172.26.0.32].[kontori_tsw].dbo.T10 _10
JOIN [172.26.0.32].[identity_tsw].dbo.AspNetUsers u on _10.c33=u.UserCode
WHERE C42 IS NOT NULL AND LTRIM(RTRIM(C42))<>''
and _10.C47 >'2021-06-18 12:08:00.077'
EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'Mobile.0.32',@issuccessfull = 1

end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
