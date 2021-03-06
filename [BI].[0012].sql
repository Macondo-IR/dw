USE [Zone6BI]
GO
/****** Object:  StoredProcedure [BI].[0012]    Script Date: 3/12/2022 12:37:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [BI].[0012]
@mainZoneKey int 
AS BEGIN
SET NOCOUNT ON;

--drop table #group
declare @StartT datetime=getdate() 
declare @ErrorIno nvarchar(max) ='start procedure 0012'
declare @command nvarchar(max) 
--declare @mainZoneKey int =6
begin try 
	set @ErrorIno='Delete old Internal Mobile'
	delete Internal.Mobile  where MainZoneKey=@mainZoneKey 
	set @ErrorIno='Get data from server'
	set @command= [FnInternal].GetString('0012-i-Internal',@mainZoneKey);exec  (@command)

	set @ErrorIno='Prepare to insert '
	update Internal.Mobile 	set CustomerKey=d.CustomerKey 	from (	select distinct c.CustomerKey,i.Id from  Internal.Mobile  i join Bi.FactCustomer c on c.ID=i.Id where i.MainZoneKey=@mainZoneKey	)d where d.Id= Internal.Mobile.Id
	update Internal.Mobile 	set IsChecked=1 	from (	select distinct i.CustomerKey from  Internal.Mobile  i join Bi.Mobile c on c.CustomerKey=i.CustomerKey where c.MainZoneKey=i.MainZoneKey and i.MainZoneKey=@mainZoneKey	)d where d.CustomerKey= Internal.Mobile.CustomerKey
	update Internal.Mobile  set Mobile =RTRIM( LTRIM(Mobile)) where mainzonekey=@mainzonekey
	set @ErrorIno='Insert new Items'
	insert into BI.Mobile (mainZonekey, customerkey)
	select distinct @mainZoneKey, customerkey from Internal.Mobile where MainZoneKey=@mainZoneKey and customerkey not in (select customerkey from  BI.Mobile where MainZoneKey=@mainZoneKey )
	
	

	update BI.Mobile set _group= (_row/1000)+1 where MainZoneKey=@mainZoneKey
	set @ErrorIno='Update Mobile Numbers'
				select distinct _group into #group from BI.Mobile where MainZoneKey=@mainZoneKey
				DECLARE @group int  ;DECLARE _cursor CURSOR FOR select _group from #group
				OPEN _cursor; FETCH NEXT FROM _cursor into @group  ;  
				WHILE @@FETCH_STATUS = 0  
				BEGIN  
	
				drop table if exists #prepare
					--declare @mainZoneKey int =6 ,@group int =1 

				select i.CustomerKey ,STRING_AGG( ISNULL( i.Mobile, ' '), ', ')  As mobile 
				into #prepare
				from Internal.Mobile i join BI.Mobile fact on fact.CustomerKey=i.CustomerKey 
				where 1=1
				and fact._group =@group and fact.mainzonekey=@mainZoneKey
				and fact.NeedUpdate =0 
				group by i.CustomerKey  

				update BI.Mobile
				set Mobile=d.mobile,NeedUpdate=1
				from 
				(select CustomerKey , mobile from #prepare
				)d where d.CustomerKey=BI.Mobile.CustomerKey and BI.Mobile.mainZonekey=@mainZoneKey
				
				FETCH NEXT FROM _cursor into @group ; 
				END  
				CLOSE _cursor;  
				DEALLOCATE _cursor;  
	set @ErrorIno='Update Registered Mobile Numbers'
	update BI.Mobile set RegisteredMobileNumber=d.t from 
	( select customerkey,count(*) as t from Internal.Mobile group by customerkey  )d where d.CustomerKey=BI.Mobile.CustomerKey
	and BI.Mobile.mainzonekey=@mainZoneKey



	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime=@StartT,@summary = N'UpdateMobile',@issuccessfull = 1
end try 
begin catch 
	EXEC [Security].[Log] @MainZoneCode=@mainZoneKey,@StartTime =@StartT,@summary = @ErrorIno, @issuccessfull = 0
end catch
	exec [Security].[ShowLogLatestItem]		@MainZoneCode =@mainZoneKey

END
