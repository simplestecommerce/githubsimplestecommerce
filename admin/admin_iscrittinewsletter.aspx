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


<script runat="server">

    int quantiPerPag=25;



        void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
        {
             dGridUt.CurrentPageIndex = e.NewPageIndex;
             bindData();

        }


         void bindData () {

                 DataTable dt = simplestecommerce.mailing.getEmailsNewsletter() ;

                 dGridUt.DataSource= dt;
                 dGridUt.DataBind();


         }




         void dGridUt_delete (object sender, DataGridCommandEventArgs e) {

            string email = e.Item.Cells[0].Text;



            simplestecommerce.mailing.deleteEmail (email);
            bindData();
        }





         void Page_Load () {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; subscribed to newsletter users"; 

            if (!Page.IsPostBack) bindData();



         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="Label1" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />


       <asp:datagrid
       cellspacing=1
        gridlines="None" id="dGridUt"
       runat="server"
       width="100%"
       autogeneratecolumns="false"
       onDeleteCommand="dGridUt_delete"
       AllowPaging="true"
       PagerStyle-Mode="NumericPages"
       pagesize=<%# quantiPerPag%>
       OnPageIndexChanged="Grid_Change"


       >
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:boundcolumn datafield="m_email" readonly="true" HeaderText="<b>EMAIL</b>" />
                <asp:boundcolumn datafield="m_confermato" readonly="true" HeaderText="<b>CONFIRMED</b>" />
                <asp:buttoncolumn HeaderText="<b>Elimina</b>" Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />

            </Columns>
        </asp:datagrid>
        <asp:label id="lblErr" runat="server" enableviewstate="false" forecolor="red"/>







    </form></asp:content>