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

        //***************************************************
        //	SHOWING DISABLED BUTTONS
        //***************************************************

        dDLOpenClose.SelectedValue = simplestecommerce.config.getCampoByApplication("config_openclose").ToString();
        tArea.InnerText = (string)simplestecommerce.config.getCampoByApplication("config_msgchiusura");



    }



    void buttAggiorna_click(object sender, EventArgs e)
    {



        int openClose = Convert.ToInt32(dDLOpenClose.SelectedValue);


        SqlConnection cnn;
        SqlCommand cmd;
        string strSql;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();

        strSql = "UPDATE tconfig SET config_openclose=@openclose , config_msgchiusura=@msgchiusura" ;
        cmd = new SqlCommand(strSql, cnn);

        cmd.Parameters.Add(new SqlParameter("@openclose", openClose));
        cmd.Parameters.Add(new SqlParameter("@msgchiusura", tArea.InnerText));
        cmd.ExecuteNonQuery();

        cnn.Close();
     
     
        simplestecommerce.config.storeConfig();
    
        lblerr.Text = "parameters saved";
     lblerr.ForeColor=System.Drawing.Color.Blue;
     bindFields();
    
    }
    

    void Page_Load()
    {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; open/close shop"; 


        if (!Page.IsPostBack)
        {
            //   simplestecommerce.config.storeConfig();

            bindFields();


        }
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
                <td colspan="2"><b>open/closed shop</b></td>
            </tr>
            <tr class="admin_sfondo">
                <td width="322">shop open/closed</td>
                <td width="718">
                    <asp:DropDownList runat="server" ID="dDLOpenClose" CssClass="input">
                        <asp:ListItem Value="0">open</asp:ListItem>
                        <asp:ListItem Value="1">closed</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>message for closed shop</td>
                <td >
                    <textarea runat="server" id="tArea" validaterequestmode="disabled"></textarea>

                </td>
            </tr>




        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>






</form></asp:Content>
