<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FileUpload.aspx.cs" Inherits="FileUpload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <LINK href="StyleSheet.css" rel="stylesheet">
</head>
<body>
		<form id="attachme" method="post" encType="multipart/form-data" runat="server">
			<INPUT class="bluebutton" id="FindFile" style="Z-INDEX: 101; LEFT: 36px; WIDTH: 274px; POSITION: absolute; TOP: 123px; HEIGHT: 22px" type="file" size="26" runat="server">
			<asp:listbox id="ListBox1" style="Z-INDEX: 102; LEFT: 36px; POSITION: absolute; TOP: 149px" runat="server" CssClass="txtbox" Height="100px" Width="274px" Font-Size="XX-Small"></asp:listbox>
			<asp:button id="AddFile" style="Z-INDEX: 103; LEFT: 34px; POSITION: absolute; TOP: 254px" runat="server" CssClass="bluebutton" Height="23px" Width="72px" Text="Add"></asp:button>
			<asp:button id="RemvFile" style="Z-INDEX: 104; LEFT: 119px; POSITION: absolute; TOP: 255px" runat="server" CssClass="bluebutton" Height="23px" Width="72px" Text="Remove"></asp:button>
			<INPUT class="bluebutton" id="Upload" style="Z-INDEX: 105; LEFT: 236px; WIDTH: 71px; POSITION: absolute; TOP: 254px; HEIGHT: 24px" type="submit" value="Upload" runat="server" onserverclick="Upload_ServerClick">
		</form>
		<asp:label id="Label1" style="Z-INDEX: 106; LEFT: 46px; POSITION: absolute; TOP: 326px" runat="server" Height="25px" Width="249px"></asp:label>

</body>
</html>
