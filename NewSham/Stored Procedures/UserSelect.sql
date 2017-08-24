


-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
Alter  PROCEDURE [dbo].[UserSelect] 
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
alter procedure MonthYear
as
begin
	Select ID, [Month] from Rpt_Month
	Select ID, [Year] from Rpt_Year
end


-- =============================================
-- Author:		Adonis Villanueva
-- ALTER  date: 2/11/2009
-- =============================================
alter procedure GetRoyaltyReport
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
Alter procedure CreateRoyaltyReport
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

	--Get the Scope
	Set @RoyaltyReportID = SCOPE_IDENTITY()

	--Build the Royaltycount	
	Declare CustomerProduct_Cursor cursor for
		Select ID, Product_ID from CustomerProduct
		where Customer_ID = @CustomerID
		and cast(STR( YEAR( Start_Dt ) )as int) + cast(STR( MONTH( Start_Dt ) )as int) >= @MonthYear
		and ((cast(STR( YEAR( End_Dt ) )as int) + cast(STR( MONTH( End_Dt ) )as int) <= @MonthYear) or (End_Dt is null)	)

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

select * from customer
Select * from Product
select * from customerproduct
Select * from RoyaltyCount
Select * From RoyaltyReport



1	1720	8	1	2008	1	2009-02-12 15:32:06.917

CreateRoyaltyReport 8, 1720, 1, 2009, 1, '2009-02-12'

delete RoyaltyReport where ID = 1
delete Royaltycount

select SCOPE_IDENTITY()



