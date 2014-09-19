<%--  
    Copyright (C) 2014 Maurizio Ferrera
 
    This file is part of SimplestEcommerce

    SimplestEcommerce is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SimplestEcommerce is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with SimplestEcommerce.  If not, see <http://www.gnu.org/licenses/>.
--%>

<%@ Page Language="C#" ValidateRequest="true" Trace="false" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>

<script runat="server">

 void buttAccedi_click(object sender, EventArgs e)
 {

  if (System.Configuration.ConfigurationManager.AppSettings["isdemo"] == "true")
  {
   if (tBoxPw.Text == System.Configuration.ConfigurationManager.AppSettings["demopass"]) dologinandredirect();
   else
   {
    lblMsgInvalid.Text = "<br>Invalid demo password</b>";
    return;
   }
  }
  else
  {
   if (tBoxPw.Text.Length <= simplestecommerce.common.maxLenPass && simplestecommerce.admin.sicurezza.adminAutenticato(tBoxPw.Text)) dologinandredirect();
   else
   {
    lblMsgInvalid.Text = "<br>Invalid password</b>";
    return;
   }
  }

 
 }


 void dologinandredirect()
 {
     
          FormsAuthentication.SetAuthCookie("simplestecommerceadministrator", cboxremember.Checked);
          Response.Redirect("admin_menu.aspx");

 }
    


    
    void Page_Load()
    {
        if (Context.User.Identity.IsAuthenticated) Response.Redirect("admin_menu.aspx");
        if (System.Configuration.ConfigurationManager.AppSettings["isdemo"] == "true") lblDove.Text = "&nbsp;(demo status)";
    }
</script>

<html>
<head runat="server">
<meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)"/>
<title>SimplestEcommerce administrator access</title>
<link href="~/css/admin_struttura.css" type="text/css" rel="stylesheet"  runat="server"/>
</head>
<body>
<form runat="server">
<table cellpadding="0" cellspacing="0" align="center" id="tablecontaineradmin" border="0"><tr><td>

    <table id="tablemenubaradmin" cellpadding="0" cellspacing="0" >
        <tr id="trdove">
            <td width="100%" height="20" id="tddove">
                <asp:Label runat="server" ID="lblDove" />
            </td>
            <td  style="text-align:right;width:300px"><a href="admin_logout.aspx" class="top" >logout&nbsp;as&nbsp;administrator</a>&nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" runat="server" href="~/shop/default.aspx" class="top" style="color:yellow" >open&nbsp;store&nbsp;front&nbsp;window</a>&nbsp;</td>
        </tr>
        <tr><td colspan="2" style="background-color:#dedede;height:1px"></td></tr>
        <tr><td colspan="2" style="height:3px"></td></tr>
    </table>



        <asp:Panel ID="Panel1" DefaultButton="buttAccedi" runat="server">



                <br />
                <img runat="server" src="~/icons/key1.gif" align="absmiddle">&nbsp;&nbsp;<span class="adminSectionTitle">Administrator Access</span>
                <br>
                <br>



                    <table width="1000" align="center" style="background-color:#eeeeee; border:solid 1px #aaaaaa; padding:10px">
                        <tr>
                            <td width="250">&nbsp;</td>
                            <td>Administrator password:</td>
                            <td><asp:TextBox class="inputsmall" ID="tBoxPw" Width="150px" TextMode="password" runat="server"></asp:TextBox></td>
                            <td width="250">&nbsp;</td>
                        </tr>
                            <tr>
                                <td></td>
                                <td>Remember me next times</td>
                                <td><asp:CheckBox runat="server" ID="cboxremember" Checked="true" CssClass="input" /></td>
                                <td></td>
                            </tr>
                        <tr>
                            
                            <td colspan=4 align="center" style="padding-top: 10px">
                                <asp:Button OnClick="buttAccedi_click" class="bottone" ID="buttAccedi" runat="server" Text="LOGIN &raquo;" Width="120px"></asp:Button>
                                <br />
                                <asp:Label EnableViewState="false" ID="lblDemo" runat="server" />
                                <asp:Label EnableViewState="false" ID="lblMsgInvalid" runat="server"  ForeColor="Red" Font-Bold="true"/>
                            </td>
                        </tr>
                    </table>
              
    
    </asp:Panel>


</td></tr></table></form></body></html>
