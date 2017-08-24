<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PasswordRecovery.aspx.cs" Inherits="PasswordRecovery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="StyleSheet.css" type="text/css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div align="center" class="main">
            <table Class="LoginControl" cellpadding="2" cellspacing="2" width="500px">
            <tr>
                <td valign="middle" align=left colspan=2 style="width: 494px">
                    <span style="font-family:Verdana;color:#025134;font-size:25px;"><img src="images/NCG-logo_sm.jpg" /><br /><br />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; Password Recovery<br />
                    </span>
                </td>
            </tr>
            <tr><td>
  <table border="0" cellpadding="1" class="LoginControl">
    <tr>
      <td>
        <table border="0" cellpadding="0">
          <tr>
            <td align="center" colspan="2">
              Forgot Your Password?</td>
          </tr>
          <tr>
            <td align="center" colspan="2">
              Enter your User Name to receive your password.</td>
          </tr>
          <tr>
            <td align="right">
              <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label></td>
            <td>
              <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
              <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="PasswordRecovery1">*</asp:RequiredFieldValidator>
            </td>
          </tr>
          <tr>
            <td align="center" colspan="2" style="color: red; height: 16px;">
              <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
            </td>
          </tr>
          <tr>
            <td align="right" colspan="2">
              <asp:Button ID="SubmitButton" runat="server" CommandName="Submit" Text="Submit" ValidationGroup="PasswordRecovery1" OnClick="SubmitButton_Click" />
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>

            </td>
            </tr>
            <tr>
                <td colspan=2 align=center><br />
                    &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <br /></td>
            </tr>
            </table>
    </div>
    </form>
</body>
</html>
