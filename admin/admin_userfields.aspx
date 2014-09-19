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
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">




    void buttAggiorna_click(object sender, EventArgs e)
    {



        SqlConnection cnn;
        SqlCommand cmd;
        string strSql;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();

        strSql = "UPDATE tconfig" +
        " SET config_askalwaysforfiscalcode=@config_askalwaysforfiscalcode, config_askfortelephone=@askfortelephone";
 
        cmd = new SqlCommand(strSql, cnn);

        cmd.Parameters.Add(new SqlParameter("@config_askalwaysforfiscalcode", cboxfiscalcode.Checked));
        cmd.Parameters.Add(new SqlParameter("@askfortelephone", cboxtelephone.Checked));

     
        cmd.ExecuteNonQuery();


        simplestecommerce.config.storeConfig();
        Response.Redirect("admin_menu.aspx");
    }

    void Page_Load()
    {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; user fields";


     if (!Page.IsPostBack)
     {

      cboxfiscalcode.Checked = (bool)simplestecommerce.config.getCampoByApplication("config_askalwaysforfiscalcode");
      cboxtelephone.Checked = (bool)simplestecommerce.config.getCampoByApplication("config_askfortelephone");

     }
    }


         


</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">

        <table align="center" cellspacing="1" width="100%">
            <tr class="admin_sfondo">
                <td width="322">ask for fiscalcode</td>
                <td width="718">
                     <asp:checkbox runat="server" ID="cboxfiscalcode" CssClass="input" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >ask for telephone number</td>
                <td >
                     <asp:checkbox runat="server" ID="cboxtelephone" CssClass="input" />
                </td>
            </tr>

        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>






</form></asp:Content>
