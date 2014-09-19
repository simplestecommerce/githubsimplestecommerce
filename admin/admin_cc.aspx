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
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.Data" %>



<script runat="server">




         void bindFields() {

           
             

             tBoxEmailPaypal.Text = simplestecommerce.config.getCampoByApplication("config_emailpaypal").ToString();


         }

         bool validaInput () {

             return true;

         }


         void buttAggiorna_click (object sender, EventArgs e) {



             if (((bool)simplestecommerce.config.getCampoByApplication("config_demo")))
             {
                 Label lbl = lblerr;
                 lbl.Text = "Function disabled on demo";
                 lbl.ForeColor = System.Drawing.Color.Red;
                 return;
             }
             
             
             //valida input
             if (! validaInput() ) return;

             string sql = "update tconfig SET "+
                 "config_emailpaypal=@emailpaypal";
             simplestecommerce.helpDb.nonQuery(
                 sql,
                 new SqlParameter("@emailpaypal", tBoxEmailPaypal.Text)
                 );
                                                       
             simplestecommerce.config.storeConfig();

             lblerr.Text = "Parameters has been updated";
             lblerr.ForeColor = System.Drawing.Color.Blue;
             bindFields();
             
         }

         void Page_Load() {

             
             if (!Page.IsPostBack) {
              ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; Paypal"; 

             bindFields();

         }

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />



 <table width="100%"  celspacing="1" cellpadding="0">
 <tr class="admin_sfondobis">
    <td width="380" >Type registration email of your Paypal account</td>
    <td >
        <asp:TextBox runat=server ID="tBoxEmailPaypal" CssClass=input style="width:100%"></asp:TextBox>
    </td>
    
 </tr>

</table>



<div align=right style="padding-right:20px">
    <asp:button class=bottone onClick="buttAggiorna_click" id="buttAggiorna" runat="server" text="UPDATE" />
</div>


</form></asp:content>
