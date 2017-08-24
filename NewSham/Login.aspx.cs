using System;
using System.Web;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using NVFRCommon.DataTools;
using NVFRCommon;

public partial class NVFRLogin : System.Web.UI.Page
{
    bool Authenticated;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            ViewState["LoginErrors"] = 0;

            if (Request.Cookies["userInfo"] != null)
            {
                Login1.UserName = Server.HtmlEncode(Request.Cookies["userInfo"]["userName"]);
         }

        }
    }

    /// <summary>
    /// Handle Login control errors and keep count how many login attempts.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected  void Login1_Error(object sender, EventArgs e)
    {
        if (ViewState["LoginErrors"] == null)
            ViewState["LoginErrors"] = 0;

        int ErrorCount = (int)(ViewState["LoginErrors"]) + 1;
        ViewState["LoginErrors"] = ErrorCount;
        
        if ((ErrorCount > 5) && (Login1.PasswordRecoveryUrl != String.Empty))
        Response.Redirect(Login1.PasswordRecoveryUrl);
    }

    /// <summary>
    /// Handle authentication.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
    {
        HttpContext.Current.Session.Clear();
        HttpContext.Current.User = null;
        
        NVFRAuth(Login1.UserName, Login1.Password);
        
        if (Authenticated)
        {
            //Set cookies to remember user login, will not store password information
            //user will have to enter password each time the page is visited
            CheckBox Remember = (CheckBox)Login1.FindControl("RememberMe");
         
            
            if (Remember.Checked)
            {
                HttpCookie aCookie = new HttpCookie("userInfo");
                aCookie.Values["UserName"] = Login1.UserName;
                aCookie.Expires = DateTime.Now.AddDays(10);
                Response.Cookies.Add(aCookie);
            }

            
            
            return;
        }
        e.Authenticated = false;
        
    }
        /// <summary>
        /// Authenticate users loggin in.  Uses PasswordUtils.
        /// </summary>
        /// <param name="UserName1"></param>
        /// <param name="Password1"></param>

        protected void NVFRAuth(string UserName1, string Password1)
        {
            //Create new Data access object
            DBAccess AuthData = new DBAccess();

            AuthData.CommandText = "dbo.UserSelect";
            AuthData.AddParameter("@Login",UserName1);
            
            SqlDataReader DR = (SqlDataReader)AuthData.ExecuteReader();
            
            //iterate through reader to find if user exists and password match.
            while(DR.Read())
            {
                if (Password1 == PasswordUtils.decode(DR["Password"].ToString()))
                {
                    CheckBox ChangePassW = (CheckBox)Login1.FindControl("ChangePass");
                    Authenticated = true;
                    //store session variable for current use
                    Session["CustomerID"] = (int)DR["Customer_ID"];
                    Session["Active"] = DR["Active"];
                    Session["LoginID"] = (int) DR["ID"];
                    Session["LoginName"] = Login1.UserName;
                    Session["Authenticated"] = Authenticated;
                    Session["Admin"] = DR["Admin"];
                    if (ChangePassW.Checked)
                    {
                        Session["OldPassword"] = Password1;
                        Server.Transfer("ChangePassword.aspx");
                    }
                    else 
                        Server.Transfer("VariableFee.aspx");
                    return;
                }
                    Authenticated = false;
                    DR.Close();
                    return;
            }
        }

   
    /// <summary>
    /// Take users to recorvery page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void passwordreset_Click(object sender, EventArgs e)
    {
        Server.Transfer("PasswordRecovery.aspx");
    }
    
    
    protected void Help_Click(object sender, EventArgs e)
    {
        Response.Redirect("Help.html");
    }
}
