<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="ChangePassword" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="StyleSheet.css" type="text/css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div align="center" class="main">
        <br />
            <asp:Panel ID="Panel1" runat="server">        
        <table Class="LoginControl" cellpadding="2" cellspacing="2" width="500px">
            <tr>
                <td valign="middle" align=left colspan=2 style="width: 494px">
                    <span style="font-family:Verdana;color:#025134;font-size:25px;"><img src="images/NCG-logo_sm.jpg" /><br /><br />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; Change Password</span><br />
                    <br />
                </td>
            </tr>
            <tr>
                <td align=center colspan=2 style="width: 494px">
                    <asp:ChangePassword ID="ChangePassword1" runat="server" CancelDestinationPageUrl="Login.aspx" OnChangedPassword="ChangePassword1_ChangedPassword" OnChangingPassword="ChangePassword1_ChangingPassword" PasswordLabelText="Old Password:">
                        
                    </asp:ChangePassword>
                </td>
            </tr>
        </table>
        </asp:Panel>
        </div>
    </form>
</body>
</html>
