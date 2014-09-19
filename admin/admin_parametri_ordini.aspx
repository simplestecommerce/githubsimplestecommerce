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

             
             IDataReader dr;

             dr = simplestecommerce.config.getConfig();

             dr.Read();

             tBoxMinOrd.Text = simplestecommerce.config.getCampoByApplication("config_minOrd").ToString();
             tBoxMaxOrd.Text = simplestecommerce.config.getCampoByApplication("config_maxOrd").ToString();
             


             dr.Close();

         }

         bool validaInput () {

             bool inputValido=true;



             try
             {
                 double minOrd = double.Parse(tBoxMinOrd.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
             }
             catch
             {
                 lblerr.Text += "<br>MIN order amount is not a valid number";
                 inputValido=false;

             }

             try
             {
                 double maxOrd = double.Parse(tBoxMaxOrd.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
             }
             catch
             {
                 lblerr.Text += "<br>MAX order amount is not a valid number";
                 inputValido = false;

             }


             if (!inputValido) return false;

             if (double.Parse(tBoxMaxOrd.Text) < double.Parse(tBoxMinOrd.Text, simplestecommerce.admin.localization.primarynumberformatinfo))
             {

                 inputValido = false;
                 lblerr.Text += "MIN order amount is greater than MAX order amount";

             }
             
             return inputValido;
             

         }


         void buttAggiorna_click (object sender, EventArgs e) {

             //valida input
             if (! validaInput() ) return;

             double minOrd = double.Parse(tBoxMinOrd.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
             double maxOrd = double.Parse(tBoxMaxOrd.Text, simplestecommerce.admin.localization.primarynumberformatinfo);

             SqlConnection cnn;
             SqlCommand cmd;
             string strSql;

             cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
             strSql = "UPDATE tconfig" +
             " SET config_minord=@minord, config_maxOrd=@maxord";

             cmd = new SqlCommand(strSql, cnn);

             cmd.Parameters.Add(new SqlParameter("@minord", minOrd));
             cmd.Parameters.Add(new SqlParameter("@maxord", maxOrd));
             cnn.Open();
             cmd.ExecuteNonQuery();
             cnn.Close();

          simplestecommerce.config.storeConfig();

          lblerr.Text = "data saved";
          lblerr.ForeColor = System.Drawing.Color.Blue;

         }

         void Page_Load() {


             
             if (!Page.IsPostBack) {
              ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; orders parameters"; 

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





 <table width="100%" cellpadding="0" cellspacing="1">
 <tr class="admin_sfondo">
    <td width="30%" >minimum order amount</td>
    <td >
        <asp:TextBox runat=server CssClass=input width="200" ID="tBoxMinOrd"></asp:TextBox>
    </td>
 </tr>

 <tr class="admin_sfondo">
    <td >maximum order amount</td>
    <td >
        <asp:TextBox runat=server CssClass=input  width="200" ID="tBoxMaxOrd"></asp:TextBox>
    </td>
 </tr>


 

</table>





<div align=right style="padding:18px">
    <asp:button onClick="buttAggiorna_click" id="buttAggiorna" runat="server" text="UPDATE" class=bottone />
</div>



</form></asp:Content>