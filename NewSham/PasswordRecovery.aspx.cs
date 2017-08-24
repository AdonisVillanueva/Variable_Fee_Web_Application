using System;
using System.Data.SqlClient;
using System.Net.Mail;
using NVFRCommon.DataTools;
using NVFRCommon;

public partial class PasswordRecovery : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    //method for sending messages and notifications 
    public static void NotifyMail(String To, String Subject, String Body)
    {
        String From = "Pbrower@newsham.com";

        MailMessage message = new MailMessage(From, To.ToString().Replace(';', ','), Subject, Body);
        SmtpClient SmtpMail = new SmtpClient("iis-scout");

        SmtpMail.Send(message);
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        DBAccess RecoverPassword = new DBAccess();
        RecoverPassword.CommandText = "RecoverPassword";
        RecoverPassword.AddParameter("@UserName", UserName.Text);

        SqlDataReader DR = (SqlDataReader)RecoverPassword.ExecuteReader();
        
        if(DR.Read())
        {
            string EmailTo = (string) DR["Email"];
            string Subject = DR["FirstName"] + " " + DR["LastName"];
            string Body = "Password for user: " + DR["LoginName"] + " is " + PasswordUtils.decode(DR["Password"].ToString());

            NotifyMail(EmailTo, Subject, Body);
            FailureText.Text = "Your password information has been sent to the email we have on file.  Please check your email.";
        }
        else
        {
            FailureText.Text = "User " + UserName.Text.ToString() + " not found.  Please try again.";
        }
    }
}
