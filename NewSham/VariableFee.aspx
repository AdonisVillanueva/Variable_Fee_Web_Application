<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="VariableFee.aspx.cs" Inherits="VariableFee" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="StyleSheet.css" type="text/css" rel="Stylesheet" />
    
    <script>  
    function FilterNumeric()
    { 
        var re; 
        var ch=String.fromCharCode(event.keyCode);
        if (event.keyCode<32){return;};
        if( (event.keyCode<=57)&&(event.keyCode>=48))
            {if (!event.shiftKey){return;}}if ((ch=='-') ||(ch=='.'))
            {return;}event.returnValue=false;
    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
      <div align=center class="main">
            <asp:Panel ID="Panel1" runat="server">            
            <table Class="LoginControl" cellpadding="2" cellspacing="2" width="500px">
                <tr>
                    <td valign="middle" align=left colspan=2 style="width: 494px">
                        <span style="font-family:Verdana;color:#025134;font-size:25px;">
                            <asp:Image ID="Image1" runat="server" ImageUrl="images/NCG-logo_sm.jpg" /><br />
                            <br />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Variable Fee Reporting</span><br />
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" align="center" style="height: 48px">
                        <asp:Label ID="Label1" runat="server" Text="Month: "></asp:Label>
                        <asp:DropDownList ID="DDLMonth" runat="server">
                        </asp:DropDownList><br /><br />
                        &nbsp;
                        <asp:Label ID="Label2" runat="server" Text="Year:"></asp:Label>
                        <asp:DropDownList ID="DDLYear" runat="server">
                        </asp:DropDownList>
                        <br />
                        <br />
                        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Next" /></td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        &nbsp;</td>
                </tr>
            </table>  
            </asp:Panel>
            </div>
       <asp:Panel ID="Panel2" runat="server" Visible="false">
           <div style="vertical-align:top;" align="center"> 
           <br  />
           <br />
            <table Class="LoginControl" cellpadding="2" cellspacing="2">
                <tr>
                    <td align="left" colspan="2">
                        <asp:Image ID="Image2" runat="server" ImageUrl="images/NCG-logo_sm.jpg" /><br /><br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="Button2" runat="server" Text="Save For Later" OnClick="Button2_Click" /> &nbsp;&nbsp;&nbsp; <asp:Button ID="Button3" runat="server" Text="Save and Submit" OnClick="Button3_Click" />&nbsp;&nbsp;<asp:Button ID="Button4" runat="server" Text="Continue" Visible="false" OnClick="Button4_Click" /> <br /><br />
                    </td>
                </tr>
                <tr>
                    <td>
                    <asp:Panel id="Panel3" runat="server">
                        <table class="LoginControl">
                            <tr>
                                <td align="left">Files to add/upload</td>
                            </tr>
                            <tr>
                                <td><INPUT class="bluebutton" id="FindFile" type="file" size="26" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:listbox id="ListBox1" runat="server" Height="100px" Width="274px" Font-Size="Small"></asp:listbox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:button id="AddFile"  runat="server" Height="23px" Width="72px" Text="Add"></asp:button>
			                        <asp:button id="RemvFile" runat="server" Height="23px" Width="72px" Text="Remove"></asp:button>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">   
			                        <INPUT class="bluebutton" id="Upload" type="submit" value="Upload" runat="server" onserverclick="Upload_ServerClick" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label3" runat="server"></asp:Label>&nbsp;</td>
                            </tr>  
                        </table>
                        </asp:Panel>
                    </td>
                    <td>
                        <asp:Panel id="Panel4" runat="server">
                            <table class="LoginControl">
                                <tr>
                                    <td align="left">File(s) associated with report.</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:listbox id="ListBox2" runat="server" Height="169px" Width="274px" Font-Size="Small" SelectionMode="Multiple"></asp:listbox>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:button id="Button5" runat="server" Height="23px" Width="72px" Text="Delete" OnClick="Button5_Click"></asp:button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Height="25px" Width="249px"></asp:Label>
                                    </td>
                                </tr>
                            </table>                            
                       </asp:Panel>
                    </td>
                </tr>                              
            </table>            
            </div>    
        </asp:Panel>
    </form>
</body>
</html>
