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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" %>


<script runat="server">

    void cambioPass_click (object sender, EventArgs e) {

        if ( !simplestecommerce.admin.sicurezza.adminAutenticato(tBoxOld.Text))        {

            lblEsito.Text = "wrong old password. The password cannot be modified";
            return;
        }
        
         if (tBoxPass.Text != tBoxRipetiPass.Text) {

             lblEsito.Text="PASSWORD and REPEAT PASSWORD not coincident. The password has not been modified";
         }
         else {
             if (((bool)simplestecommerce.config.getCampoByApplication("config_demo")))
             {
                 lblEsito.Text = "Function disabled on demo";
                 return;
             }                

						else{

             if (tBoxPass.Text.Length>simplestecommerce.common.maxLenPwAdmin) {
                lblEsito.Text = "max length is " + simplestecommerce.common.maxLenPwAdmin + " chars";
                return;
             }


             simplestecommerce.admin.sicurezza.cambioPass (tBoxPass.Text);
             lblEsito.Text="Password has been modified correctly";
						}
         }
    }

    void Page_Init()
    {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; change administrator password"; 


    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />
            
			
	<div style="border:1px solid #bbbbbb; background-color: #F4F4F4; padding:10px 5px 5px; " >
		<table align="center">

			<tr>
				<td>
        old password:
				</td>
				<td>
				<asp:textbox
	        enableviewstate="false"
	        id="tBoxOld"
	        cssClass="inputsmall"
            width="200px"
            textmode="password"
	        runat="server" />
				</td>
			</tr>
			<tr>
				<td>
        new password:
				</td>
				<td>
				<asp:textbox
	        enableviewstate="false"
	        id="tBoxPass"
	        cssClass="inputsmall"
					width="200px"
					textmode="password"
	        runat="server" />
				</td>
			</tr>
			<tr>
				<td>
        repeat password:
				</td>
				<td><asp:textbox
	        enableviewstate="false"
	        id="tBoxRipetiPass"
	        cssClass="inputsmall"
					width="200px"
					textmode="password"
	        runat="server" />
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center" style="padding-top:10px">
        <asp:button
        id="buttCambioPass"
        onClick="cambioPass_click"
        text="CHANGE PASSWORD"
        cssClass="bottone"
        runat="server" />
				</td>
			</tr>
		</table>
        <br>
        <b><asp:label enableviewstate="false" ForeColor="red" id="lblEsito" runat="server" /></b>
	</div>

</form></asp:Content>