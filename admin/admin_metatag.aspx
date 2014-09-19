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

          tBoxDescription.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.config.getCampoByDb("config_metatagdescription").ToString());
          tBoxKeywords.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.config.getCampoByDb("config_metatagkeywords").ToString());
         }


         void aggiorna_click(object sender, EventArgs e)
         {




          string sql = "update tconfig SET " +
           " config_metatagdescription=@description, config_metatagkeywords=@keywords";  
           simplestecommerce.helpDb.nonQuery(sql,
              new SqlParameter("description", tBoxDescription.Text),
              new SqlParameter("keywords", tBoxKeywords.Text)
          );
                                                            
             simplestecommerce.config.storeConfig();

             lblerr.Text = "Parameters has been updated";
             lblerr.ForeColor = System.Drawing.Color.Blue;
             bindFields();
             
         }

         void Page_Load() {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; meta tag"; 
    
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
                <td>METATAG Description</td>
                <td >
                    <asp:TextBox ID="tBoxDescription" runat="server" class="inputlargo" Style="width: 100%" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>METATAG Keywords</td>
                <td >
                    <asp:TextBox ID="tBoxKeywords" runat="server" class="inputlargo" Style="width: 100%" />
                </td>
            </tr>



</table>

         <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="aggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>




</form></asp:content>
