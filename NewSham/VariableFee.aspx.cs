using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Drawing;
using NVFRCommon.DataTools;


public partial class VariableFee : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                if (!(bool)Session["Authenticated"])
                    Response.Redirect("Login.aspx");
            }
            catch (Exception)
            {
                Response.Redirect("Login.aspx");
            }
            Initialize();
            CreateDynamicTable(0);
        }

        // Run only once a postback has occured
        if (Page.IsPostBack)
        {
            //The ReportStatus is only generated once the user clicks the save button
            //it will throw an exception on the first time the Next button on the Month/year
            //selection because it is a Page Post back and the Session for report status is 
            //not yet instantiated.  Hence this exception handling.
            try
            {
                CreateDynamicTable((int)Session["ReportStatus"]);

                if (!Session["ReportStatus"].Equals(1))
                {
                    Panel3.Visible = false;
                    Button5.Visible = false;
                    ListBox2.BackColor = Color.Gray;
                    Button2.Visible = false;
                    Button3.Visible = false;
                    Button4.Visible = true;
                }
                else
                {
                    Panel3.Visible = true;
                    Button5.Visible = true;
                    ListBox2.BackColor = Color.White;
                    Button2.Visible = true;
                    Button3.Visible = true;
                    Button4.Visible = false;
                }
                
            }
            catch(Exception)
            {
                CreateDynamicTable(1);
            }
        }
    }

    /// <summary>
    /// Initialize the drop down controls.
    /// </summary>
    public void Initialize()
    {
        DBAccess MonthYear = new DBAccess();
        
        MonthYear.CommandText = "dbo.MonthYear";
        DataSet DDLData = MonthYear.ExecuteDataSet();
        
        //Bind DDLMonth
        DDLMonth.DataSource = DDLData;
        DDLMonth.DataMember = DDLData.Tables[0].TableName;
        DDLMonth.DataValueField = "ID";
        DDLMonth.DataTextField = "Month";
        DDLMonth.DataBind();
        //Bind DDLYear
        DDLYear.DataSource = DDLData;
        DDLYear.DataMember = DDLData.Tables[1].TableName;
        DDLYear.DataValueField = "Year";
        DDLYear.DataTextField = "Year";
        DDLYear.DataBind();
        
        PlaceHolder1.Controls.Clear();
        Panel1.Visible = true;
        Panel2.Visible = false;

    }
    
    protected void Button1_Click(object sender, EventArgs e)
    {
        DBAccess RoyaltyReport = new DBAccess();

        //save selection in session variable
        Session["ReportMonth"] = DDLMonth.SelectedValue;
        Session["ReportYear"] = DDLYear.SelectedValue;
        
        RoyaltyReport.CommandText = "dbo.GetRoyaltyReport";
        RoyaltyReport.AddParameter("@LoginID",Session["LoginID"]);
        RoyaltyReport.AddParameter("@CustomerID", Session["CustomerID"]);
        RoyaltyReport.AddParameter("@ReportMonth", Convert.ToInt32(Session["ReportMonth"]));
        RoyaltyReport.AddParameter("@ReportYear", Convert.ToInt32(Session["ReportYear"]));

        SqlDataReader DR = (SqlDataReader)RoyaltyReport.ExecuteReader();
                
        /// <summary>
        /// Iterate through reader.  If a record exist in ROYALTYREPORT for that Company, for that Login, for the selected Month/Year
        /// </summary>        
        if (DR.Read())
        {
            int ReportStatus = (int)DR["ReportStatusID"];
            Session["ReportStatus"] = ReportStatus;

            Session["RoyaltyReportId"] = DR["ID"];
            //If Report Status is IN PROGRESS, Allow user to edit data – this data will be stored in ROYALTYCOUNT.

                CreateDynamicTable(ReportStatus);
                //Get associated files
                GetFiles();
            
                if(!ReportStatus.Equals(1))
                {
                    Panel3.Visible = false;
                    Button5.Visible = false;
                    ListBox2.BackColor = Color.Gray;
                    Button2.Visible = false;
                    Button3.Visible = false;
                    Button4.Visible = true;
                }
                else
                {
                    Panel3.Visible = true;
                    Button5.Visible = true;
                    ListBox2.BackColor = Color.White;
                    Button2.Visible = true;
                    Button3.Visible = true;
                    Button4.Visible = false;
                }
                
                Panel1.Visible = false;
                Panel2.Visible = true;
                
        }
        else
        {// If a record does NOT exist in ROYALTYREPORT for that Company, Login, Month, Year, then Create a new ROYALTYREPORT record with status = In Progress.
            
            DBAccess RoyaltyCount = new DBAccess();
            RoyaltyCount.CommandText = "dbo.CreateRoyaltyReport";
            RoyaltyCount.AddParameter("@LoginID", Session["LoginID"]);
            RoyaltyCount.AddParameter("@CustomerID", Session["CustomerID"]);
            RoyaltyCount.AddParameter("@ReportMonth", Convert.ToInt32(Session["ReportMonth"]));
            RoyaltyCount.AddParameter("@ReportYear", Convert.ToInt32(Session["ReportYear"]));
            RoyaltyCount.AddParameter("@ReportStatusID", 1);
            RoyaltyCount.AddParameter("@SubmittedDate", DateTime.Now);
            
            //Make sure to catch the Scope ID from the inserted record.
            SqlParameter RoyaltyReportID = new SqlParameter();
            RoyaltyReportID.Direction = ParameterDirection.Output;
            RoyaltyReportID.SqlDbType = SqlDbType.Int;
            RoyaltyReportID.Size = 4;
            RoyaltyReportID.ParameterName = "@RoyaltyReportIDOut";
            RoyaltyCount.AddParameter(RoyaltyReportID);
            RoyaltyCount.ExecuteNonQuery();

            Session["RoyaltyReportId"] = RoyaltyReportID.Value;
            
            CreateDynamicTable(1);
            Panel1.Visible = false;
            Panel2.Visible = true;
        }
    }


    private void CreateDynamicTable(int ReportStatus)
    {
        if ((Session["ReportMonth"] == null) || (Session["ReportYear"] == null)) return;
        
        PlaceHolder1.Controls.Clear();
        
        DBAccess CountData = new DBAccess();

        CountData.CommandText = "GetCount";
        CountData.AddParameter("@LoginID", Session["LoginID"]);
        CountData.AddParameter("@CustomerID", Session["CustomerID"]);
        CountData.AddParameter("@ReportMonth", Convert.ToInt32(Session["ReportMonth"]));
        CountData.AddParameter("@ReportYear", Convert.ToInt32(Session["ReportYear"]));

        //Create a DataSet object
        DataSet myDataSet = CountData.ExecuteDataSet();

        // Fetch the number of Rows and Columns for the table 
        // using the properties
        int tblCols = 1;
        
        // Create a Table and set its properties 
        Table tbl = new Table();
        tbl.ID = "CountTable";
        string ProductGroup = "";
        // Add the table to the placeholder control
        PlaceHolder1.Controls.Add(tbl);
        
        // Now iterate through the table and add the controls 
        for (int i = 0; i <= myDataSet.Tables[0].Rows.Count - 1; i++)
        {
            TableRow tr = new TableRow();
            
            //Handle grouping
            if (ProductGroup == "")
            {
                //Reporting Period Information
                TableRow tr2 = new TableRow();
                TableCell tc2 = new TableCell();
                Label lblLabel2 = new Label();
                tc2.ColumnSpan = 2;
                tc2.HorizontalAlign = HorizontalAlign.Left;
                lblLabel2.Font.Size = FontUnit.Large;
                lblLabel2.Text = "Reporting Period: " + Session["ReportMonth"] + "/" + Session["ReportYear"] + "<br />"; 
                
                tc2.Controls.Add(lblLabel2);
                tr2.Cells.Add(tc2);
                tbl.Rows.Add(tr2);

                //Company Information
                TableRow tr3 = new TableRow();
                TableCell tc3 = new TableCell();
                Label lblLabel3 = new Label();
                tc3.ColumnSpan = 2;
                tc3.HorizontalAlign = HorizontalAlign.Left;
                lblLabel3.Font.Size = FontUnit.Large;
                lblLabel3.Text = "Customer Name: " + myDataSet.Tables[0].Rows[i]["Customer_Name"].ToString() + "<br /><br />";

                tc3.Controls.Add(lblLabel3);
                tr3.Cells.Add(tc3);
                tbl.Rows.Add(tr3);
                
                //Notify user of report status
                if (!ReportStatus.Equals(1))
                {
                    TableRow tr4 = new TableRow();
                    TableCell tc4 = new TableCell();
                    Label lblLabel4 = new Label();
                    tc3.ColumnSpan = 4;
                    tc3.HorizontalAlign = HorizontalAlign.Left;
                    lblLabel4.ForeColor = Color.Red;
                    lblLabel4.Text = "The data for this reporting period has already been submitted.  This page is read only.  <br />If you need to make changes to this data please <a href='mailto:email@mail.com?subject=Edit Submitted Data?'>Contact Us</a>" + "<br /><br />";

                    tc4.Controls.Add(lblLabel4);
                    tr4.Cells.Add(tc4);
                    tbl.Rows.Add(tr4);
                }
                
                //First Header
                TableRow tr1 = new TableRow();
                TableCell tc1 = new TableCell();
                Label lblLabel1 = new Label();
                ProductGroup = myDataSet.Tables[0].Rows[i]["ProductGroup"].ToString();
                //format
                tc1.ColumnSpan = 2;
                tc1.HorizontalAlign = HorizontalAlign.Center;
                tc1.BackColor = Color.Green;
                lblLabel1.Text = ProductGroup;
                lblLabel1.Font.Size = FontUnit.XLarge;
                lblLabel1.Font.Bold = true;
                lblLabel1.ForeColor = Color.WhiteSmoke;
                
                tc1.Controls.Add(lblLabel1);
                tr1.Cells.Add(tc1);
                tbl.Rows.Add(tr1);
            }
            else if (ProductGroup != myDataSet.Tables[0].Rows[i]["ProductGroup"].ToString())
            {
                TableRow tr1 = new TableRow();
                TableCell tc1 = new TableCell();

                Label lblLabel1 = new Label();
                ProductGroup = myDataSet.Tables[0].Rows[i]["ProductGroup"].ToString();
                //format
                tc1.ColumnSpan = 2;
                tc1.HorizontalAlign = HorizontalAlign.Center;
                tc1.BackColor = Color.Green;
                lblLabel1.Text = ProductGroup;
                lblLabel1.Font.Size = FontUnit.XLarge;
                lblLabel1.Font.Bold = true;
                lblLabel1.ForeColor = Color.WhiteSmoke;

                tc1.Controls.Add(lblLabel1);
                tr1.Cells.Add(tc1);
                tbl.Rows.Add(tr1);
            }
            
                for (int j = 0; j < tblCols; j++)
                {
                    
                    TableCell tc = new TableCell();
                    tc.Attributes.Add("Align", "Right");

                    TextBox txtBox = new TextBox();
                    Label lblLabel = new Label();

                    lblLabel.Text = myDataSet.Tables[0].Rows[i]["Label"].ToString() + ": ";
                    txtBox.Text = myDataSet.Tables[0].Rows[i]["RoyaltyCount"].ToString();
                    txtBox.ID = myDataSet.Tables[0].Rows[i]["RoyaltyCountID"].ToString();
                    txtBox.Attributes.Add("onkeypress", "FilterNumeric()");
                    //make read only if status is not in progress
                    if (!ReportStatus.Equals(1))
                    {
                        txtBox.ReadOnly = true;
                        txtBox.BackColor = Color.Gray;
                        Button2.Visible = false;
                        Button3.Visible = false;
                        Button4.Visible = true;
                    }
                // Add the control to the TableCell                
                    tc.Controls.Add(lblLabel);
                    tc.Controls.Add(txtBox);
                    // Add the TableCell to the TableRow
                    tr.Cells.Add(tc);
                }
            tbl.Rows.Add(tr);

        }
        // This parameter helps determine in the LoadViewState event,
        // whether to recreate the dynamic controls or not
        ViewState["dynamictable"] = true;
    }

    // Check the ViewState flag to determine whether to 
    // rebuild your table again
    protected override void LoadViewState(object earlierState)
    {
        //CreateDynamicTable(0);
        base.LoadViewState(earlierState);
        if (ViewState["dynamictable"] == null)
            CreateDynamicTable(0);
    }
    
    //submit and save
    protected void Button3_Click(object sender, EventArgs e)
    {
        //save the count
        SaveCount();
        //update the royaltyreport's status
        SaveStatus(2);

        PlaceHolder1.Controls.Clear();
        Panel1.Visible = true;
        Panel2.Visible = false;
    }
    
    protected void Button2_Click(object sender, EventArgs e)
    {
        //save the count
        SaveCount();
        
        //update the royaltyreport's status
        SaveStatus(1);

        PlaceHolder1.Controls.Clear();
        Panel1.Visible = true;
        Panel2.Visible = false;
    }
    
    //save status
    protected  void SaveStatus(int StatusCode)
    {
        DBAccess RoyaltyReportStatus = new DBAccess();

        RoyaltyReportStatus.CommandText = "RoyaltyReportStatus";

        RoyaltyReportStatus.AddParameter("@LoginID", Session["LoginID"]);
        RoyaltyReportStatus.AddParameter("@CustomerID", Session["CustomerID"]);
        RoyaltyReportStatus.AddParameter("@ReportMonth", Convert.ToInt32(Session["ReportMonth"]));
        RoyaltyReportStatus.AddParameter("@ReportYear", Convert.ToInt32(Session["ReportYear"]));
        //submitted = 2
        RoyaltyReportStatus.AddParameter("@ReportStatusID", StatusCode);
        RoyaltyReportStatus.ExecuteNonQuery();
    }

    //method for sending messages and notifications 
    public static void NotifyMail(String To, String Subject, String Body)
    {
        String From = "Pbrower@newsham.com";

        MailMessage message = new MailMessage(From, To.ToString().Replace(';', ','), Subject, Body);
        SmtpClient SmtpMail = new SmtpClient("iis-scout");

        SmtpMail.Send(message);
    }

    
    
    //this goes through all the controls in the dynamic table and then updates the royaltycount table
    protected void SaveCount()
    {
        foreach (Control ctrl in PlaceHolder1.Controls)
        {
            if (ctrl.ID.Equals("CountTable"))
            {
                Table tbl = ((Table)ctrl);
                foreach (Control ctrl2 in tbl.Controls)
                {
                    if (ctrl2 is TableRow)
                    {
                        TableRow tblrow = ((TableRow)ctrl2);
                        foreach (Control ctrl3 in tblrow.Controls)
                        {
                            if (ctrl3 is TableCell)
                            {
                                TableCell tblcell = ((TableCell)ctrl3);
                                foreach (Control ctrl4 in tblcell.Controls)
                                {
                                    if (ctrl4 is TextBox)
                                    {
                                        TextBox tb = ((TextBox)ctrl4);
                                        DBAccess SaveCount = new DBAccess();
                                        SaveCount.CommandText = "SaveCount";
                                        SaveCount.AddParameter("@RoyaltyCountID", Convert.ToInt32(tb.ID.ToString()));
                                        SaveCount.AddParameter("@RoyaltyCount", Convert.ToDecimal(tb.Text));
                                        SaveCount.ExecuteNonQuery();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    protected void Button4_Click(object sender, EventArgs e)
    {
        Session["ReportStatus"] = null;
        Initialize();

    }

    #region file upload 

    public ArrayList files = new ArrayList();
    static public ArrayList hif = new ArrayList();
    public int filesUploaded = 0;

    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: This call is required by the ASP.NET Web Form Designer.
        //
        InitializeComponent();
        base.OnInit(e);
    }

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.AddFile.Click += new System.EventHandler(this.AddFile_Click);
        this.RemvFile.Click += new System.EventHandler(this.RemvFile_Click);
        this.Upload.ServerClick += new System.EventHandler(this.Upload_ServerClick);
        this.Load += new System.EventHandler(this.Page_Load);

    }

    /// <summary>
    /// AddFile will add the path of the client side file that is currently in the PostedFile
    /// property of the HttpInputFile control to the listbox.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void AddFile_Click(object sender, System.EventArgs e)
    {
        if (Page.IsPostBack)
        {
            hif.Add(FindFile);
            ListBox1.Items.Add(FindFile.PostedFile.FileName);

        }
        else
        {
        }
    }

    /// <summary>
    /// RemvFile will remove the currently selected file from the listbox.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void RemvFile_Click(object sender, EventArgs e)
    {
        if (ListBox1.Items.Count != 0)
        {

            hif.RemoveAt(ListBox1.SelectedIndex);
            ListBox1.Items.Remove(ListBox1.SelectedItem.Text);
        }

    }

    /// <summary>
    /// Upload_ServerClick is the server side script that will upload the files to the web server
    /// by looping through the files in the listbox.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    public void Upload_ServerClick(object sender, EventArgs e)
    {
        string status = "";

        if ((ListBox1.Items.Count == 0) && (filesUploaded == 0))
        {
            Label3.Text = "Error - a file name must be specified.";
            return;

        }
        else
        {
            foreach (HtmlInputFile HIF in hif)
            {
                try
                {
                    string fn = Path.GetFileName(HIF.PostedFile.FileName);
                    HIF.PostedFile.SaveAs(Server.MapPath("~/UploadedFiles/") + fn);
                    filesUploaded++;
                    status += fn + "<br>";
                    
                    //Insert filename to database
                    DBAccess AddFiles = new DBAccess();
                    AddFiles.CommandText = "AddFiles";
                    AddFiles.AddParameter("@RoyaltyReportID", Convert.ToInt32(Session["RoyaltyReportId"]));
                    AddFiles.AddParameter("@OriginalFileName", fn);
                    AddFiles.AddParameter("@NewFileName", fn);
                    AddFiles.AddParameter("@FileExtension", fn.Substring(fn.IndexOf(".")+1,3));
                    AddFiles.ExecuteNonQuery();
                    
                    //Update the listbox - get files
                    
                }
                catch (Exception err)
                {
                    Label3.Text = "Error saving file " + Server.MapPath("~/UploadedFiles/") + "<br>" + err.ToString();
                }
            }

            if (filesUploaded == hif.Count)
            {
                Label3.Text = "These " + filesUploaded + " file(s) were uploaded:<br>" + status;
            }

            GetFiles();
            hif.Clear();
            ListBox1.Items.Clear();
        }

    }
    
    //get the file info from the database
    protected void GetFiles()
    {
        DBAccess GetFiles = new DBAccess();

        GetFiles.CommandText = "GetFiles";
        GetFiles.AddParameter("@RoyaltyReportID", Convert.ToInt32(Session["RoyaltyReportId"]));

        DataTable dt = new DataTable();
        
        dt.Load(GetFiles.ExecuteReader(),LoadOption.OverwriteChanges);
       
        ListBox2.DataTextField = dt.Columns[2].ColumnName;
        ListBox2.DataValueField = dt.Columns[0].ColumnName;
        ListBox2.DataSource = dt;
        ListBox2.DataBind();
    }
    
    #endregion
    
    //Delete file routine
    protected void Button5_Click(object sender, EventArgs e)
    {
        if(ListBox2.Items.Count == 0)
        {
            Label4.Text = "There are no files to delete";
            return;
        }

        foreach (ListItem item in ListBox2.Items)
        {
            if(item.Selected)
            {
                //remove from database
                DBAccess DeleteFiles = new DBAccess();
                DeleteFiles.CommandText = "DeleteFiles";
                DeleteFiles.AddParameter("@FileID",item.Value);
                DeleteFiles.ExecuteNonQuery();
                ListBox2.Items.Remove(item.Text);

                //delete files from directory
                try
                {
                    FileInfo TheFile = new FileInfo(Server.MapPath("~/UploadedFiles/") + item.Text);
                    if (TheFile.Exists)
                    {
                        File.Delete(Server.MapPath("~/UploadedFiles/") + item.Text);
                    }
                    else
                    {
                        throw new FileNotFoundException();
                    }
                }
                catch (FileNotFoundException ex)
                {

                    Label4.Text += ex.Message;
                }
                catch (Exception ex)
                {
                    Label4.Text += ex.Message;
                }
            }
        }
        GetFiles();

    }
}
