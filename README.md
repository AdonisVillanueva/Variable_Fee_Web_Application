# Variable_Fee_Web_Application
This application is calculates and reports on royalties for customers.

Variable Fee Reporting Website.

•	Attach the NVFR.mdf locally
•	Include the NVFRCommon.csproj in your solution.  Use the TableAdapters for CRUD operations.
o	User PasswordUtils for passwords.

General flow and requirements for site:

1.	Login page, enter username, password.
2.	Find Login record, and verify password (using PasswordUtils).
3.	If authenticated, go to page where user select Year, Month (from Rpt_Month, Rpt_Year).
4.	If a record exists in ROYALTYREPORT for that Company, for that Login, for the selected Month/Year
a.	If Report Status is IN PROGRESS
i.	Allow user to edit data – this data will be stored in ROYALTYCOUNT.
b.	If Report Status is anything else, only allow user Read only access to the data from ROYALTYCOUNT
5.	If a record does NOT exist in ROYALTYREPORT for that Company, Login, Month, Year, then Create a new ROYALTYREPORT record with status = In Progress.
a.	Build the ROYALTYCOUNT records from CUSTOMERPRODUCT TABLE.  Make sure to look at STARTDT, ENDDT when building, and don’t include any products that fall outside the month/year the customer is reporting on.
6.	Page for entering/viewing will be dynamically built from the ROYALTY COUNT table, using the Customer and Product tables as well.  Need to show CustomerName, login at top of page.  Need to GROUP info they’re entering by PRODUCT.PRODUCTGROUP, and order within that grouping by PRODUCT.ORDERINDEX.
7.	No paging for this page, just build the screen as large as it needs to be.
8.	After user has entered values for ALL field (Zero is acceptable), the user can either SAVE, or Submit.  If saved, populate the ROYALTYCOUNT table and leave status as IN PROGRESS.  If submitted, populate the ROYALTY count table, change status to SUBMITTED, and put current datestamp in the ROYALTYREPORT.SUBMITTEDDATE.
9.	Once a report is submitted, we’ll need to send an email.  I’ll talk to you more about this when we get to it.
10.	Also, on the bottom of this page, we need to allow users to upload supporting files, if applicable for them.  I have a table (REPORTFILES) to store this info.  We’ll need to be able to rename each physical file to a unique name, and then store the file on the webserver, with appropriate info in the REPORTFILES table.  If a user has NOT submitted info, they need to be able to delete files they have uploaded.
11.	I’ve added a couple of accounts you can use for testing.
a.	Login:  adm, password: dmybGM
b.	Login: donbeal, password: GkFXCe
You could use the pbrower account for testing if you like.  That password is rj42np.

Note:  the NVFR_DS (strongly typed dataset) is available for you to use, but you don’t have to use it.

If you do want to use it, the TableAdapters are all set up for getting and updating data.

Here is a test for filling the Login table.  Please note, since the dataset enforces all database constraints, you have to fill the customer table first.

        [Test]
        public void testFillLoginTable()
        {
            CustomerTableAdapter custTA = new CustomerTableAdapter();
            LoginTableAdapter loginTA = new LoginTableAdapter();
            NVFR_DS ds = new NVFR_DS();

            custTA.Fill(ds.Customer);
            loginTA.Fill(ds.Login);

            Assert.IsTrue(ds.Login.Rows.Count > 0);
        }

Here is a test using TableAdapter to update info.  The TableAdapter will automatically determine whether Inserts, Updates, or Deletes are necessary:

        [Test]
        public void UpdateRecordWithTableAdapter()
        {
            CustomerTableAdapter custTA = new CustomerTableAdapter();
            NVFR_DS ds = new NVFR_DS();
            custTA.Fill(ds.Customer);
            Assert.IsTrue(ds.Customer.FindByID(2520).Cust_Key == "NEWSHAM");
            ds.Customer.FindByID(2520).Cust_Key = "NEWSHAMTEST";
            custTA.Update(ds.Customer);

            custTA = new CustomerTableAdapter();
            ds = new NVFR_DS();
            custTA.Fill(ds.Customer);
            Assert.IsTrue(ds.Customer.FindByID(2520).Cust_Key == "NEWSHAMTEST");
            ds.Customer.FindByID(2520).Cust_Key = "NEWSHAM";
            custTA.Update(ds.Customer);
        }


