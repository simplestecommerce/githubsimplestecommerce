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

    void Page_Load()
    {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; last occured errors";


     DataTable dt = simplestecommerce.helpDb.getDataTable("select * from terrorlog order by id desc");

     foreach (DataRow dr in dt.Rows)
     {

      lblerrors.Text += "<hr>" +
      "***" + Convert.ToDateTime(dr["datetime"]).ToString("yyyy-M-d  HH:mm:ss") + "***" +
      "<br>" +
      dr["text"].ToString();
      
      
     }
    
    
    }


         


</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <br />
     <asp:label runat="server" ID="lblerrors" />





</form></asp:Content>
