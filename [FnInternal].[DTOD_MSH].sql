USE [Zone6BI]
GO
/****** Object:  UserDefinedFunction [FnInternal].[DTOD_MSH]    Script Date: 3/12/2022 12:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  Function [FnInternal].[DTOD_MSH] (@Miladi varchar(10))
Returns varchar(10) 
AS
Begin

declare @EMon int ,
	@EDay int ,
	@EYear int ,
	@FDate varchar(10)

set @EYear=Substring(@Miladi,1,4)
set @EMon=Substring(@Miladi,6,2)
set @EDay=Substring(@Miladi,9,2)
--....................
declare @T int
declare @Temp int
declare @Cnt Int 
declare @EDayOfYear int
declare @FMon int 
declare @FDay int 
declare @FYear int 

declare  @FMonArr varchar(100)
declare  @EMonArr varchar(100)
set @FMonArr='31,31,31,31,31,31,30,30,30,30,30,29'
set @EMonArr='31,28,31,30,31,30,31,31,30,31,30,31'
--...........................

 set @Temp=0
 set @Cnt=1
 While @Cnt<=@EMon-1 
 Begin
-- for @Cnt=1 to @EMon-1  
  if (@Cnt=2) and ((@EYear % 4)=0)
    set @Temp=@Temp+29
  else
   Begin 
    set @T=((@Cnt-1)*3)+1 
    set @Temp=@Temp+cast(substring(@EMonArr,@T,2) as Int)
   ENd 
  Set  @Cnt=@Cnt+1 
 End --while 
 set @EDayOfYear=@Temp+@EDay
--..............

 set @Temp= @EDayOfYear - 79
 if @Temp>0 
  set @FYear=@EYear-621
 else
  begin
   set @FYear=@EYear-622
   if ((@FYear % 4)=3)
    set @Temp=@Temp+366
    else
     set @Temp=@Temp+365
  end

 set @Cnt=1

 set @T=((@Cnt-1)*3)+1 
 

 while (@Temp<>0) and (@Temp>cast(substring(@FMonArr,@T,2) as Int)) 
  begin
      if @Cnt=12 
       if ((@FYear%4)=3) 
        set @Temp=@Temp-30
       else
        set @Temp=@Temp-29
      else
        set @Temp=@Temp-cast(substring(@FMonArr,@T,2) as Int)
      
      set @Cnt=@Cnt+1 
      set @T=((@Cnt-1)*3)+1 
  end

  if @Temp<>0
   begin
    set @FMon=@Cnt
    set @FDay=@Temp
   end
  else
   begin
    set @FMon=12
    set @FDay=30
   end

--.......... GetDAteStr
declare  @YearStr varchar(4)
declare  @MonStr  varchar(2)
declare  @DayStr  varchar(2)
declare  @sw1 int
declare  @sw2 int

 set @sw1=0
 set @sw2=0
 if @FMon<10 
   set @sw1=1
 if @FDay<10 
   set @sw2=1

 set @YearStr=cast(@FYear as Varchar)
 set @MonStr=cast(@FMon as Varchar)
 set @DayStr=cast(@FDay as Varchar)

 if @sw1=1 
  set @MonStr='0'+@MonStr;
 if @sw2=1 
  set @DayStr='0'+@DayStr;

 set @FDate=@YearStr+'/'+@MonStr+'/'+@DayStr
 Return @FDate

End


