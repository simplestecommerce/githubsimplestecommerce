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

    int idList=0;


    void dGrid_edit (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex = e.Item.ItemIndex;
            bind();

    }


    void dGrid_cancel (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex=-1;
            bind();
    }

    void dGrid_update (object sender, DataGridCommandEventArgs e) {

        int idList=  Convert.ToInt32(  ((Label)e.Item.Cells[1].Controls[1]).Text );

        bool inputValido=true;

        double sconto=0;

        try { sconto = double.Parse(((TextBox)e.Item.Cells[2].Controls[0]).Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
        catch { lblerr.Text = "please insert a number in field DISCOUNT"; inputValido=false ; }

        if (!inputValido) return;

        simplestecommerce.listini.adminUpdateSconto (idList, sconto);

        dGrid.EditItemIndex=-1;

        lblerr.Text = "data saved";
        lblerr.ForeColor = System.Drawing.Color.Blue;
     
        bind();
    }




    void bind() {

        dGrid.DataSource = simplestecommerce.listini.adminGetSconti();
        dGrid.DataBind();


    }


    void Page_Init() {


    }

    void Page_Load () {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; discounts on price lists";


        if (!Page.IsPostBack) bind();

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />


           <asp:datagrid  cellspacing="1" GridLines="none" id="dGrid" runat="server" width="100%" autogeneratecolumns="false"
            onCancelCommand="dGrid_cancel"
            onUpdateCommand="dGrid_update"
            onEditCommand = "dGrid_edit"
            >
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:EditCommandColumn CancelText="cancel"  UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>"/>

                <asp:templatecolumn  HeaderText="<b>price list</b>" >
                    <itemtemplate>
                        <asp:label id="lblIdCat"  Text=<%# DataBinder.Eval (Container.DataItem, "lists_id")  %>   runat="server" />
                    </itemtemplate>
                </asp:templatecolumn>
                <asp:boundcolumn datafield="lists_sconto" readonly="false" HeaderText="<b>price list discount(%)</b>" />

            </columns>
            </asp:datagrid>
            <br>
            <br>

    </form></asp:Content>