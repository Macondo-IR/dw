USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0020]    Script Date: 3/12/2022 12:38:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0020]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;



declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0020'


begin try 
DECLARE @MinAmount bigINT;
DECLARE @MaxAmount bigINT;
DECLARE @levelKey INT;
declare @todayDatekey int = fn.GetTodayDateKey()

--declare @mainZoneKey int 
--set @mainZoneKey=6
set  @ErrorIno  ='delete old Finance data'

delete [Internal].[Finance] where mainZoneKey=@mainZoneKey
set  @ErrorIno  ='fill new Finance data '
declare @command nvarchar(max)= [FnInternal].[GetString]('0020-i-Internal',@mainZoneKey);exec (@command)
set  @ErrorIno  ='determine new ones  '
update [Internal].[Finance] set [NeedUpdate]=1  where mainzonekey=@mainZoneKey and  id not in (select id from bi.FactFinance )
set  @ErrorIno  ='fill new Finance data in Bi.FactFinance'
insert into [BI].[FactFinance](  [MainZoneKey]      ,[Id]      ,[AmountBilling]      ,[AmountWaterBranch]      ,[AmountSewageBranch] ,UpdatedDateKey,NeedProcess   ) select @mainZoneKey,[Id],[AmountBilling],[AmountWaterBranch],[AmountSewageBranch] ,@todayDatekey,1  FROM [Zone6BI].[Internal].[Finance]  where mainzonekey=@mainZoneKey and  [NeedUpdate]=1 
set  @ErrorIno  ='determine changed amount items'
update [Internal].[Finance] set [NeedUpdate]=2
from (select i.Id from [Internal].[Finance] i join [BI].[FactFinance] f on i.Id=f.Id and i.mainzonekey=@mainZoneKey  and [NeedUpdate]<>1 where     i.AmountBilling<>f.AmountBilling or i.AmountWaterBranch<>f.AmountWaterBranch or i.AmountSewageBranch<>f.AmountSewageBranch )d where d.id=[Internal].[Finance].id
set  @ErrorIno  ='update Changed Itemss in  Bi.FactFinance'
update bi.[FactFinance] set AmountBilling=d.AmountBilling,AmountWaterBranch=d.AmountWaterBranch,AmountSewageBranch=d.AmountSewageBranch,NeedProcess=1,UpdatedDateKey=@todayDatekey from (select * from [Internal].[Finance]  where mainzonekey=@mainZoneKey and [NeedUpdate]=2)d where d.id=bi.[FactFinance].id
set  @ErrorIno  ='update level debt '
DECLARE cur CURSOR FOR SELECT DebtLevelKey,MinAmount,MaxAmount FROM [BI].[DimDebtLevel]
OPEN cur;FETCH NEXT FROM cur INTO @levelKey,@MinAmount,@MaxAmount;

WHILE @@FETCH_STATUS=0
BEGIN
	set  @ErrorIno  ='update level LevelBilling'
		update Bi.FactFinance 	set LevelBilling=@levelKey 	from (	SELECT  Id  FROM  Bi.FactFinance  where AmountBilling >=@MinAmount  and AmountBilling<=@MaxAmount  and NeedProcess=1 and mainzonekey=@mainZoneKey   ) d   where  Bi.FactFinance.Id=d.Id   and  MainZoneKey=@mainZoneKey  
	set  @ErrorIno  ='update level levelWaterBranch  '
		update Bi.FactFinance 	set levelWaterBranch=@levelKey 	from (	SELECT  Id  FROM  Bi.FactFinance  where AmountWaterBranch >=@MinAmount  and AmountWaterBranch<=@MaxAmount  and NeedProcess=1 and mainzonekey=@mainZoneKey   ) d   where  Bi.FactFinance.Id=d.Id   and  MainZoneKey=@mainZoneKey  
	set  @ErrorIno  ='update level levelSewageBranch  '
		update Bi.FactFinance 	set levelSewageBranch=@levelKey 	from (	SELECT  Id  FROM  Bi.FactFinance  where AmountSewageBranch >=@MinAmount  and AmountSewageBranch<=@MaxAmount  and NeedProcess=1 and mainzonekey=@mainZoneKey   ) d   where  Bi.FactFinance.Id=d.Id   and  MainZoneKey=@mainZoneKey  
		FETCH NEXT FROM cur INTO @levelKey, @MinAmount, @MaxAmount;
END ;CLOSE cur;DEALLOCATE cur;
set  @ErrorIno  ='set Complete Process'
update Bi.FactFinance 	set NeedProcess=0 where NeedProcess=1 and MainZoneKey=@mainZoneKey

EXEC [Security].[Log]
@MainZoneCode=@mainZoneKey,
@StartTime=@StartT,
@summary = N'FactFinance',
@issuccessfull = 1

end try 
begin catch 
EXEC [Security].[Log]
@MainZoneCode=@mainZoneKey,
@StartTime =@StartT
,@summary = @ErrorIno
, @issuccessfull = 0
end catch
exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
