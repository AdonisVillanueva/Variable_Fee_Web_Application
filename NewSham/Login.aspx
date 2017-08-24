<%@ Page Language="C#" AutoEventWireup="true" EnableSessionState="true" CodeFile="Login.aspx.cs" Inherits="NVFRLogin" %>

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
        &nbsp;<asp:Panel ID="Panel1" runat="server">
        
        <table Class="LoginControl" cellpadding="2" cellspacing="2" width="500px">
            <tr>
                <td valign="middle" align=left colspan=2 style="width: 494px">
                    <span style="font-family:Verdana;color:#025134;font-size:25px;"><img src="images/NCG-logo_sm.jpg" /><br /><br />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; Customer Login</span><br />
                    <br />
                </td>
            </tr>
            <tr>
                <td align=center colspan=2 style="width: 494px">
                        <asp:Login ID="Login1" runat="server" CssClass="LoginControl" PasswordRecoveryUrl="PasswordRecovery.aspx" HelpPageText="Additional Help" InstructionText="Please enter your user name and password for login." OnAuthenticate="Login1_Authenticate" OnLoginError="Login1_Error" DisplayRememberMe=true EnableViewState="true">
            <TitleTextStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <LayoutTemplate>
                   <table border="0" cellpadding="4" cellspacing="2" width="300px" height="200px">
                    <tr>
                      <td>
                        <table border="0" cellpadding="3" cellspacing="2">
                          <tr>
                             <td align="left">
                              <asp:Label ID="UserNameLabel" runat="server" 
                              AssociatedControlID="UserName" Width="193px">User Name</asp:Label></td>
                          </tr>
                          <tr>               
                            <td>
                              <asp:TextBox ID="UserName" runat="server" Width="200px"></asp:TextBox>
                              <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" 
                               ControlToValidate="UserName" ErrorMessage="User Name is required." 
                               ToolTip="User Name is required." ValidationGroup="Login1">*
                               </asp:RequiredFieldValidator>
                            </td>
                          </tr>
                          <tr>
                            <td align="left">
                              <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">
                                Password</asp:Label></td>
                            
                          </tr>
                          <tr>
                           <td>
                              <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="200px"></asp:TextBox>
                              <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" 
                               ControlToValidate="Password" ErrorMessage="Password is required." 
                               ToolTip="Password is required." ValidationGroup="Login1">*
                              </asp:RequiredFieldValidator>
                            </td>
                          </tr>
                          <tr>
                            <td align="center" colspan="2" style="color: red">
                              <asp:Literal ID="FailureText" runat="server" EnableViewState="False">
                              </asp:Literal>
                            </td>
                          </tr>
                          <tr>
                            <td align="right" colspan="2"><br /><asp:CheckBox ID="RememberMe" runat="server" 
                                Text="Remember me"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:ImageButton ID="ImageButton1"
                                    runat="server" ImageUrl="~/images/loginbutton.jpg" CommandName="Login" ValidationGroup="Login1" CausesValidation=true  PostBackUrl="Login.aspx" />
                                &nbsp; &nbsp;&nbsp;
                            </td>
                          </tr>
                          <tr>
                            <td align="left">
                            <asp:CheckBox ID="ChangePass" runat="server" Text="Change Password" />                                
                            </td>
                          </tr>
                        </table>
                        </td>
                    </tr>
                  </table>
            </LayoutTemplate>
        </asp:Login>
                </td>
            </tr>
            <tr>
                <td colspan=2 align=center><span style="font-family:Verdana;color:#21759B;font-size:13px;">&nbsp;<asp:LinkButton runat=server ID="passwordreset" Text="Forgot Password"  ForeColor="#025134" OnClick="passwordreset_Click" /><br />
                </span><br />
                    <asp:Label ID="Label1" runat="server" Text="After 3 unsuccessful login attempts your account will be locked."></asp:Label><br />
                    <asp:Label ID="Label2" runat="server" Text="For assistance please <a href='mailto:email@mail.com?subject=Login Issues'>Contact Us</a>"></asp:Label>                    

            </tr>
        </table>
        

        
        </asp:Panel>
        &nbsp; &nbsp;
        <br />   </div>
    </form>
</body>
</html>
