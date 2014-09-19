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
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script runat="server">



    void bindFields()
    {

     cBoxLogin.Checked = (simplestecommerce.config.getCampoByDb("config_login").ToString() == "1");
    dListRegistrazione.SelectedValue = simplestecommerce.config.getCampoByDb("config_registrazione").ToString();
     dListListinoTarget.SelectedValue = simplestecommerce.config.getCampoByDb("config_listinotarget").ToString();
    }



    void buttAggiorna_click(object sender, EventArgs e)
    {

        SqlConnection cnn;
        SqlCommand cmd;
        string strSql;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();

        strSql = "UPDATE tconfig SET " +
         " config_registrazione=@registrazione" +
        ", config_login=@login" +
        ", config_listinotarget=@listinotarget";
        
         
        cmd = new SqlCommand(strSql, cnn);

        cmd.Parameters.Add(new SqlParameter("@registrazione", int.Parse(dListRegistrazione.SelectedValue) ));
        cmd.Parameters.Add(new SqlParameter("@login", cBoxLogin.Checked?1:0 ));
        cmd.Parameters.Add(new SqlParameter("@listinotarget", int.Parse (dListListinoTarget.SelectedValue)));

        cmd.ExecuteNonQuery();

        cnn.Close();
     
     
        simplestecommerce.config.storeConfig();
    
        lblerr.Text = "parameters saved";
     lblerr.ForeColor=System.Drawing.Color.Blue;
     bindFields();
    
    }
    

    void Page_Load()
    {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; registration preferences";

     if (!Page.IsPostBack) bindFields();
    }


         


</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
        <br />
        <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />

        <table align="center" cellspacing="1" width="100%">


            <tr class="admin_sfondodark">
                <td colspan="2" ><b>registration parameters</b></td>
            </tr>
            <tr class="admin_sfondo">
                <td>registration to e-commerce is&nbsp;&nbsp;</td>
                <td >
                    <asp:DropDownList runat="server" ID="dListRegistrazione" CssClass="input">
                        <asp:ListItem Value="0">optional</asp:ListItem>
                        <asp:ListItem Value="1">required in order to buy</asp:ListItem>
                        <asp:ListItem Value="2">required in order to see prices and buy</asp:ListItem>
                    </asp:DropDownList>
            </tr>

            <tr class="admin_sfondo">
                <td>registered users must wait manual activation from users menu </td>
                <td >
                    <asp:CheckBox runat="server" ID="cBoxLogin" CssClass="input" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>assign automatically registered user to price list</td>
                <td >
                    <asp:DropDownList ID="dListListinoTarget" runat="server" CssClass="input">
                        <asp:ListItem Value="0">0</asp:ListItem>
                        <asp:ListItem Value="1">1</asp:ListItem>
                        <asp:ListItem Value="2">2</asp:ListItem>
                        <asp:ListItem Value="3">3</asp:ListItem>
                        <asp:ListItem Value="4">4</asp:ListItem>
                        <asp:ListItem Value="5">5</asp:ListItem>
                        <asp:ListItem Value="6">6</asp:ListItem>
                        <asp:ListItem Value="7">7</asp:ListItem>
                        <asp:ListItem Value="8">8</asp:ListItem>
                        <asp:ListItem Value="9">9</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>




        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>






</form></asp:Content>
