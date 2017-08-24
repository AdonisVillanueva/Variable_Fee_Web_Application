using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class FileUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public ArrayList files = new ArrayList();
    static public ArrayList hif = new ArrayList();
    public int filesUploaded = 0;


    #region Web Form Designer generated code
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
    #endregion

    /// <summary>
    /// AddFile will add the path of the client side file that is currently in the PostedFile
    /// property of the HttpInputFile control to the listbox.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void AddFile_Click(object sender, System.EventArgs e)
    {
        if (Page.IsPostBack == true)
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
    private void RemvFile_Click(object sender, System.EventArgs e)
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
    public void Upload_ServerClick(object sender, System.EventArgs e)
    {
        string baseLocation = "\\..\\UploadedFiles";
        string status = "";


        if ((ListBox1.Items.Count == 0) && (filesUploaded == 0))
        {
            Label1.Text = "Error - a file name must be specified.";
            return;

        }
        else
        {
            foreach (System.Web.UI.HtmlControls.HtmlInputFile HIF in hif)
            {
                try
                {
                    string fn = System.IO.Path.GetFileName(HIF.PostedFile.FileName);
                    HIF.PostedFile.SaveAs(Server.MapPath("~/UploadedFiles/") + fn);
                    filesUploaded++;
                    status += fn + "<br>";
                }
                catch (Exception err)
                {
                    Label1.Text = "Error saving file " + baseLocation + "<br>" + err.ToString();
                }
            }

            if (filesUploaded == hif.Count)
            {
                Label1.Text = "These " + filesUploaded + " file(s) were uploaded:<br>" + status;
            }
            hif.Clear();
            ListBox1.Items.Clear();
        }

    }
}
