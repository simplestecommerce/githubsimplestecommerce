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

    void prepareFields() {

         }

         void bindFields() {

             

             tBoxSoglia.Text = simplestecommerce.config.getCampoByApplication("config_sogliaspedizioneomaggio").ToString();

         }

         bool validaInput () {

             bool inputValido=true;



             try
             {
                 double minOrd = double.Parse(tBoxSoglia.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
             }
             catch
             {
                 lblerr.Text += "<br>please insert a number";
                 inputValido=false;

             }

             return inputValido;
             

         }


         void buttAggiorna_click (object sender, EventArgs e) {

             //valida input
             if (! validaInput() ) return;

             double soglia = double.Parse(tBoxSoglia.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
             string strSql;
             SqlCommand cmd;
             SqlConnection cnn;

             cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

             cnn.Open();

             strSql = "UPDATE tconfig SET config_sogliaspedizioneomaggio=@soglia";
             cmd = new SqlCommand(strSql, cnn);
             cmd.Parameters.Add(new SqlParameter("@soglia", soglia));
             cmd.ExecuteNonQuery();
             cnn.Close();
             simplestecommerce.config.storeConfig();
             lblerr.ForeColor = System.Drawing.Color.Blue;
             lblerr.Text = "data saved";
             bindFields();
         }

         void Page_Load() {


          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; free transport costs";

             
             if (!Page.IsPostBack) {

             prepareFields();
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



 <table width="100%" cellspacing=1 >
 <tr class="admin_sfondo">
    <td height=25 width="30%" >transport costs will be free starting from subtotal</td>
    <td >
        <asp:TextBox runat=server CssClass=input style="width:200px" ID="tBoxSoglia"></asp:TextBox>
    </td>
 </tr>
 

</table>




<div align=right style="padding:18px">
    <asp:button onClick="buttAggiorna_click" id="buttAggiorna" runat="server" text="UPDATE" class=bottone />
</div>



</form></asp:content>
