


-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
create  PROCEDURE [dbo].[UserSelect] 
	-- Add the parameters for the stored procedure here
	@Login varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		L.ID,
		L.Customer_Id,
		L.LoginName,
		L.Password,
		L.FirstName,
		L.LastName,
		L.Email,
		L.Phone,
		L.Active,
		L.LastLogonDt,
		L.Blocked,
		L.Admin
	FROM [dbo].Login AS L
	WHERE (@login IS NULL OR [LoginName] = @Login)
END



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
create procedure MonthYear
as
begin
	Select ID, [Month] from Rpt_Month
	Select ID, [Year] from Rpt_Year order by [year]
end


-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
create procedure GetRoyaltyReport
	@LoginID int,
	@CustomerID int,
	@ReportMonth int,
	@ReportYear int
as
begin
	SELECT [ID]
      ,[CustomerID]
      ,[LoginId]
      ,[ReportedMonth]
      ,[ReportedYear]
      ,[ReportStatusID]
      ,[SUBMITTEDDATE]
  FROM [NVFR].[dbo].[RoyaltyReport]
  WHERE [ReportedMonth] = @ReportMonth
		AND [ReportedYear] = @ReportYear
		AND [LoginId] = @LoginID
		AND [CustomerID] = @CustomerID
end





ALTER   procedure [dbo].[CreateRoyaltyReport]
	@LoginID int,
	@CustomerID int,
	@ReportMonth int,
	@ReportYear int,
	@ReportStatusID int,
	@SubmittedDate datetime,
	@RoyaltyReportIDOut int OUTPUT 
as
begin
Declare @ProductID int
Declare @Count int
Declare @MonthYear int
Declare @RoyaltyReportID int

declare @TmpDate datetime

set @TmpDate = cast(@ReportMonth as varchar) + '/1/' + cast(@ReportYear as varchar)

Set @Count = 0 --No value entered for initial creation

	--Build the RoyalyReport
	Insert into RoyaltyReport(
       [CustomerID],
       [LoginId],
       [ReportedMonth],
       [ReportedYear],
       [ReportStatusID],
       [SUBMITTEDDATE])
	Values(
	   @CustomerID,
	   @LoginID,
       	   @ReportMonth,
	   @ReportYear,
	   @ReportStatusID,
           @SubmittedDate)

	--Get the Scope *This will be the RoyaltyReportID used in RoyaltyCount
	Set @RoyaltyReportID = SCOPE_IDENTITY()
	Set @RoyaltyReportIDOut = @RoyaltyReportID

	--Build the Royaltycount	
	Declare CustomerProduct_Cursor cursor for
		SELECT     dbo.ProductList_Product.Product_Id
		FROM         dbo.Customer INNER JOIN
                      dbo.CustomerProductList ON dbo.Customer.ID = dbo.CustomerProductList.Customer_Id INNER JOIN
                      dbo.ProductList ON dbo.CustomerProductList.ProductList_Id = dbo.ProductList.ID INNER JOIN
                      dbo.ProductList_Product INNER JOIN
                      dbo.Product ON dbo.ProductList_Product.Product_Id = dbo.Product.ID ON dbo.ProductList.ID = dbo.ProductList_Product.ProductList_Id
		WHERE     (dbo.Customer.ID = @CustomerID) AND (dbo.CustomerProductList.Start_Dt <= @TmpDate) AND 
                      (dbo.CustomerProductList.End_Dt IS NULL) OR
                      (dbo.CustomerProductList.Start_Dt <= @TmpDate) AND (dbo.CustomerProductList.End_Dt >= @TmpDate)

	Open CustomerProduct_Cursor

	FETCH NEXT FROM CustomerProduct_Cursor INTO @ProductID 

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
	   Insert into RoyaltyCount(
		   RoyaltyReportID,
		   ProductID,
		   RoyaltyCount)
	   Values(
		   @RoyaltyReportID,
		   @ProductID,
		   @Count)

	FETCH NEXT FROM CustomerProduct_Cursor INTO @ProductID
	END

	CLOSE CustomerProduct_Cursor 
	DEALLOCATE CustomerProduct_Cursor

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



select * from customer
Select * from Product
select * from customerproduct
Select * from RoyaltyCount
Select * From RoyaltyReport



1	1720	8	1	2008	1	2009-02-12 15:32:06.917

CreateRoyaltyReport 8, 1686, 1, 2009, 1, '2009-02-12', 1

delete Royaltycount
delete RoyaltyReport


select SCOPE_IDENTITY()


-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
SET QUOTED_IDENTIFIER ON 

GO

SET ANSI_NULLS ON 

GO

 

ALTER  procedure [dbo].[GetCount]
    @LoginID int,
    @CustomerID int,
    @ReportMonth int,
    @ReportYear int

as
begin

Declare @TmpDate datetime
Set @TmpDate = cast(@ReportMonth as varchar) + '-1-' + cast(@ReportYear as varchar)

        SELECT dbo.ProductList.ListName, dbo.Product.ID AS ProductID, dbo.Product.Code, dbo.Product.Label, dbo.Product.ProductGroup, dbo.Product.Order_Index, 
               dbo.Customer.Customer_Name, dbo.Customer.Cust_Key, dbo.CustomerProductList.Start_Dt, dbo.CustomerProductList.End_Dt, 
               dbo.Customer.ID AS CustomerID, RoyaltyCount, RoyaltyCount.ID as RoyaltyCountID
        FROM  dbo.Customer 
        INNER JOIN dbo.CustomerProductList ON dbo.Customer.ID = dbo.CustomerProductList.Customer_Id 
        INNER JOIN dbo.ProductList ON dbo.CustomerProductList.ProductList_Id = dbo.ProductList.ID 
        INNER JOIN dbo.ProductList_Product 
        INNER JOIN dbo.Product ON dbo.ProductList_Product.Product_Id = dbo.Product.ID ON dbo.ProductList.ID = dbo.ProductList_Product.ProductList_Id
        inner join RoyaltyReport on RoyaltyReport.CustomerID = Customer.ID 
        --inner join RoyaltyCount on RoyaltyReport.ID = RoyaltyCount.RoyaltyReportID
        inner join RoyaltyCount on RoyaltyCount.ProductID = Product.ID and RoyaltyReport.ID = RoyaltyCount.RoyaltyReportID
        WHERE ((Start_Dt <= @TmpDate) AND (End_Dt Is Null OR @TmpDate <= End_Dt))
        and dbo.Customer.ID = @CustomerID
        and RoyaltyReport.LoginID = @LoginID and
        RoyaltyReport.ReportedYear = @ReportYear and RoyaltyReport.ReportedMonth = @ReportMonth
        group by ProductGroup, Product.ID, ProductList.ListName, Customer.ID, Product.Code, Product.Label, 
        Product.Order_Index, Customer.Customer_Name, Customer.Cust_Key, CustomerProductList.Start_Dt, 
        CustomerProductList.End_Dt, RoyaltyCount, RoyaltyCount.ID 
        --Order by Order_Index                       

end

 



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
Create procedure SaveCount
@RoyaltyCountID int,
@RoyaltyCount decimal(18)
as
begin
	update RoyaltyCount
	set RoyaltyCount = @RoyaltyCount
	where ID = @RoyaltyCountID

end





-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
Create procedure AddFiles
@RoyaltyReportID int,
@OriginalFileName varchar(200),
@FileExtension varchar(50),
@NewFileName varchar(200)
as
begin
	insert into ReportFiles(
	RoyaltyReportID,
	OriginalFileName,
	FileExtension,
	NewFileName)
	values(
	@RoyaltyReportID,
	@OriginalFileName,
	@FileExtension,
	@NewFileName)
end



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
Create procedure DeleteFiles
@FileID int
as
begin
	Delete from ReportFiles
	where ID = @FileID
end



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
Create procedure GetFiles
@RoyaltyReportID int
as
begin
	Select * from ReportFiles
	where RoyaltyReportID = @RoyaltyReportID
end


select * from reportfiles



GetCount 7, 1686, 1, 2009

select * from royaltycount
select * from royaltyreport

delete royaltycount
delete reportfiles
delete royaltyreport




select * from customerproductlist
select *r


select * from 

GetFiles 18



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
alter procedure RecoverPassword
@UserName varchar(50)
as
begin
	Select * from Login
	where LoginName = @UserName
end

-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
--OLD
-- =============================================
alter  PROCEDURE [dbo].[ChangePassword] 
	-- Add the parameters for the stored procedure here
	@LoginID int = NULL,
	@LoginName varchar(20),
	@NewPassWord varchar(100),
	@OldPassword varchar(100),
	@Exist int OUTPUT
AS
BEGIN

	--see if password exists
	select *
	from login
	where id = @LoginID
	and LoginName = @LoginName
	and Password = @OldPassword
	
	Set @exist = @@rowcount


	if (@Exist <> 0)
	Begin
		--select @Exist
		update login
		set Password = @NewPassWord
		WHERE [LoginName] = @LoginName
		and ID = @LoginID
	End
	else
	begin
		set @Exist = 0
	end

END


select * from login where id = 12
select @@rowcount


select * from login where password = '15441138061071110316147091515412'


old
15624141111113810865153801594773


new
120611302615027141121507312710109671130064



[ChangePassword] 1,'pbrower','15624141111113810865153801594773','1196812871148101383314732123071050210773',0

select * from login where password='119441283114754137611464412203103821063725'


		update login
		set Password = '1196812871148101383314732123071050210773'
		WHERE [LoginName] = 'pbrower'
		and ID = 1

	declare @exist int
	select @Exist = id
	from login
	where id = 1
	and LoginName = 'pbrower'
	and Password = '1196812871148101383314732123071050210773'
	select @exist

ChangePassword @LoginID = 1,@LoginName='pbrower',@OldPassword='120881307115090141931517212827111021145373',
@NewPassword='15441138061071110316147091515412',@Exist=0

select * from login
old
"155041391110858105051494015427"
new
"121031309615125142381522712892"




alter  PROCEDURE [dbo].[ChangePassword] 
	-- Add the parameters for the stored procedure here
	@LoginID int = NULL,
	@LoginName varchar(20),
	@NewPassWord varchar(100)
AS
BEGIN

		update login
		set Password = @NewPassWord
		WHERE [LoginName] = @LoginName
		and ID = @LoginID

END