
-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
Create procedure [dbo].[CreateRoyaltyReport]
	@LoginID int,
	@CustomerID int,
	@ReportMonth int,
	@ReportYear int,
	@ReportStatusID int,
	@SubmittedDate datetime
as
begin
Declare @ProductID int
Declare @Count int
Declare @MonthYear int
Declare @RoyaltyReportID int
Declare @CustomerProductID int

Set @MonthYear = @ReportYear + @ReportMonth
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

	--Build the Royaltycount	
	/*Prior to update
	Declare CustomerProduct_Cursor cursor for
		Select ID, Product_ID from CustomerProductList
		where Customer_ID = @CustomerID
		and cast(STR( YEAR( Start_Dt ) )as int) + cast(STR( MONTH( Start_Dt ) )as int) >= @MonthYear
		and ((cast(STR( YEAR( End_Dt ) )as int) + cast(STR( MONTH( End_Dt ) )as int) <= @MonthYear) or (End_Dt is null)	) */

	Declare CustomerProduct_Cursor cursor for
		Select CustomerProductList.ID, Product_ID 
		from Customer		
		INNER JOIN dbo.CustomerProductList ON dbo.Customer.ID = dbo.CustomerProductList.Customer_Id 
		INNER JOIN dbo.ProductList ON dbo.CustomerProductList.ProductList_Id = dbo.ProductList.ID 
		INNER JOIN dbo.ProductList_Product 
		INNER JOIN dbo.Product ON dbo.ProductList_Product.Product_Id = dbo.Product.ID 
			ON dbo.ProductList.ID = dbo.ProductList_Product.ProductList_Id
		WHERE (cast(STR( YEAR( Start_Dt ) )as int) + cast(STR( MONTH( Start_Dt ) )as int) >= @MonthYear or (Start_Dt is null))
		and ((cast(STR( YEAR( End_Dt ) )as int) + cast(STR( MONTH( End_Dt ) )as int) <= @MonthYear) or (End_Dt is null))


	Open CustomerProduct_Cursor

	FETCH NEXT FROM CustomerProduct_Cursor INTO @CustomerProductID, @ProductID 

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

	FETCH NEXT FROM CustomerProduct_Cursor INTO @CustomerProductID, @ProductID
	END

	CLOSE CustomerProduct_Cursor 
	DEALLOCATE CustomerProduct_Cursor

end



CREATE procedure [dbo].[GetCount]
	@LoginID int,
	@CustomerID int,
	@ReportMonth int,
	@ReportYear int
as
begin

Declare @MonthYear int
Set @MonthYear = @ReportYear + @ReportMonth

		SELECT distinct dbo.ProductList.ListName, dbo.Product.ID AS ProductID, dbo.Product.Code, dbo.Product.Label, dbo.Product.ProductGroup, dbo.Product.Order_Index, 
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
		WHERE (cast(STR( YEAR( Start_Dt ) )as int) + cast(STR( MONTH( CustomerProductList.Start_Dt ) )as int) >= @MonthYear or (CustomerProductList.Start_Dt is null))
		and ((cast(STR( YEAR( End_Dt ) )as int) + cast(STR( MONTH( CustomerProductList.End_Dt ) )as int) <= @MonthYear) or (CustomerProductList.End_Dt is null))
		and dbo.Customer.ID = @CustomerID
		and RoyaltyReport.LoginID = @LoginID
		group by ProductGroup, Product.ID, ProductList.ListName, Customer.ID, Product.Code, Product.Label, 
		Product.Order_Index, Customer.Customer_Name, Customer.Cust_Key, CustomerProductList.Start_Dt, 
		CustomerProductList.End_Dt, RoyaltyCount, RoyaltyCount.ID 
		--Order by Order_Index
		
end



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
create procedure [dbo].[GetRoyaltyReport]
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


-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
create procedure [dbo].[MonthYear]
as
begin
	Select ID, [Month] from Rpt_Month
	Select ID, [Year] from Rpt_Year order by [year]
end

USE [NVFR]
GO
/****** Object:  StoredProcedure [dbo].[RoyaltyReportStatus]    Script Date: 02/17/2009 19:59:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author: Adonis Villanueva

-- ALTER date: 2/16/2009

-- =============================================

Create procedure [dbo].[RoyaltyReportStatus]
@LoginID int,
@CustomerID int,
@ReportMonth int,
@ReportYear int,
@ReportStatusID int
as
begin
	update RoyaltyReport
	set ReportStatusID = @ReportStatusID
	where loginID = @LoginID
	and ReportedMonth = @ReportMonth
	and ReportedYear = @ReportYear
	and CustomerID = @CustomerID
end



-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/16/2009
-- =============================================
Create procedure [dbo].[SaveCount]
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

