using System;
using System.Data;
using System.Data.SqlClient;
using NVFRCommon.DataTools;
using NVFRCommon;

public partial class ChangePassword : System.Web.UI.Page
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

        }
    }


    protected void ChangePassword1_ChangedPassword(object sender, EventArgs e)
    {
        
        
    }


    //protected void ChangePassword1_ChangingPassword(object sender, EventArgs e)
    //{
    //    DBAccess ChangePassword = new DBAccess();

    //    ChangePassword.CommandText = "ChangePassword";
    //    ChangePassword.AddParameter("@LoginID", Session["LoginID"]);
    //    ChangePassword.AddParameter("@LoginName", Session["LoginName"]);
    //    ChangePassword.AddParameter("@OldPassword", PasswordUtils.encode(ChangePassword1.CurrentPassword.ToString()));
    //    ChangePassword.AddParameter("@NewPassword", PasswordUtils.encode(ChangePassword1.NewPassword.ToString()));
        
    //    SqlParameter Exist = new SqlParameter();
    //    Exist.Direction = ParameterDirection.Output;
    //    Exist.SqlDbType = SqlDbType.Int;
    //    Exist.Size = 4;
    //    Exist.ParameterName = "@Exist";
    //    ChangePassword.AddParameter(Exist);
        
    //    ChangePassword.ExecuteNonQuery();

    //    if (Exist.Value.Equals(null) || Exist.Value.Equals(0))
    //        ChangePassword1.ChangePasswordFailureText = "Old Password is incorrect.  Please Try Again.";
    //    else
    //    {
    //        ChangePassword1.SuccessText = "Password Changed.";
    //        ChangePassword1.ChangePasswordFailureText = "Password Changed";
    //    }
            
    //    return;
        
    //}



    protected void ChangePassword1_ChangingPassword(object sender, EventArgs e)
    {
        if ((ChangePassword1.NewPassword.Length < 6) || (ChangePassword1.ConfirmNewPassword.Length < 6))
        {
            ChangePassword1.ChangePasswordFailureText = "Password must be at least 6 characters long.";
            return;
        }
        else
        {
            if (ChangePassword1.CurrentPassword == Session["OldPassword"].ToString())
            {
                DBAccess ChangePassword = new DBAccess();

                ChangePassword.CommandText = "ChangePassword";
                ChangePassword.AddParameter("@LoginID", Session["LoginID"]);
                ChangePassword.AddParameter("@LoginName", Session["LoginName"]);
                ChangePassword.AddParameter("@NewPassword", PasswordUtils.encode(ChangePassword1.NewPassword.ToString()));
                ChangePassword.ExecuteNonQuery();
                ChangePassword1.ChangePasswordFailureText = "Password Changed";
            }
            else
                ChangePassword1.ChangePasswordFailureText = "Old Password is Incorrect.  Try again.";
        }
        return;
     }
    
}
