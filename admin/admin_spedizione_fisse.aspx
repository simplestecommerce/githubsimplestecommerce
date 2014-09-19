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
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">



        void bindData() {

            tBoxSpFisse.Text = simplestecommerce.spedizione.getSpFisse().ToString();

        }




         void buttSpFisse_click (object sender, EventArgs e) {

            double spFisse;

            try {
                spFisse = double.Parse(tBoxSpFisse.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
            } catch {
                lblerr.Text = "character not allowed";
                return;
            }

            string strSql;
            SqlCommand cmd;
            SqlConnection cnn;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            cnn.Open();

            strSql = "UPDATE tconfig SET config_spSpedFisse=@spfisse";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@spFisse", spFisse));
            cmd.ExecuteNonQuery();
            cnn.Close();
            simplestecommerce.config.storeConfig();
            lblerr.ForeColor = System.Drawing.Color.Blue;
            lblerr.Text = "data saved";
            bindData();

         }



         void Page_Load () {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; fixed transport costs";

             
            if (!Page.IsPostBack) bindData();

         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />

  <table width="100%" cellspacing=1 >
 <tr class="admin_sfondo">
    <td height=25 width="30%" >   fixed shipment costs </td>
    <td >
          <asp:textbox id="tBoxSpFisse" runat=server class=input size="8" />

    </td>
 </tr>
 

</table>
 <div align="right"> 
        <asp:button id="buttSpFisse" onclick="buttSpFisse_click" runat=server text="UPDATE FIXED COSTS" class=bottone />
  </div>

		
	
    </form></asp:content>