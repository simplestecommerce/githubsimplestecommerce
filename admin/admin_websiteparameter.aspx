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


          tBoxEmailSito.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.config.getCampoByDb("config_emailsito").ToString());
          tBoxNomeSito.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.config.getCampoByDb("config_nomesito").ToString());
          tBoxUrlSito.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.config.getCampoByDb("config_urlsito").ToString());


         }


         void aggiorna_click(object sender, EventArgs e)
         {




          string sql = "update tconfig SET " +
           " config_nomeSito=@nomesito, config_emailSito=@emailsito, config_urlSito=@urlsito";
             simplestecommerce.helpDb.nonQuery(sql,
              new SqlParameter("nomeSito", tBoxNomeSito.Text ),
              new SqlParameter("emailsito", tBoxEmailSito.Text),
              new SqlParameter("urlsito", tBoxUrlSito.Text)
          );
                                                            
             simplestecommerce.config.storeConfig();

             lblerr.Text = "Parameters has been updated";
             lblerr.ForeColor = System.Drawing.Color.Blue;
             bindFields();
             
         }

         void Page_Load() {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; web site parameters"; 
    
             if (!Page.IsPostBack) {
            

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



 <table width="100%"  cellspacing="1" cellpadding="0">
            <tr class="admin_sfondo">
                <td>site name:&nbsp;&nbsp;</td>
                <td>
                    <asp:TextBox EnableViewState="false" ID="tBoxNomeSito" size="30" runat="server" class="inputlargo" />
            </tr>

            <tr class="admin_sfondo">
                <td>email:&nbsp;&nbsp;</td>
                <td>
                    <asp:TextBox EnableViewState="false" ID="tBoxEmailSito" size="30" runat="server" class="inputlargo" />

                </td>
            </tr>


            <tr class="admin_sfondo">
                <td>site url:&nbsp;&nbsp;</td>
                <td>
                    <asp:TextBox EnableViewState="false" ID="tBoxUrlSito" size="30" runat="server" class="inputlargo" />
            </tr>



</table>

         <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="aggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>




</form></asp:content>
