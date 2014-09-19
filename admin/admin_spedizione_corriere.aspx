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



         void bind () {

                DataTable dt = simplestecommerce.corrieri.getenabledcarrier();
                dGrid.DataSource= dt;
                dGrid.DataBind();

         }





         void dGrid_edit (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex = e.Item.ItemIndex;
            bind();

         }


         void dGrid_cancel (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex=-1;
            bind();
         }


        void dGrid_update (object sender, DataGridCommandEventArgs e) {

            bool inputValido=true;

            double prezzo=0;

            try { prezzo = double.Parse(((TextBox)e.Item.Cells[3].Controls[0]).Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
            catch {
                lblerr.Text+= "<br>field PRICE must be a number";
                inputValido  = false;
            }


            if (!inputValido) return;

            int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

            simplestecommerce.helpDb.nonQuery(
                "update tcorrieri set c_prezzo=@prezzo where c_id=@id",
                new SqlParameter("prezzo", prezzo),
                new SqlParameter("id", id)
                );
            
            
            dGrid.EditItemIndex=-1;
            bind();
         }






         void Page_Load () {


          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; transport costs per carrier";

            if (!Page.IsPostBack) bind();

         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />

       <asp:datagrid  
            GridLines="None" 
           CellSpacing="1" 
           id="dGrid" 
           runat="server" 
           width="100%" 
           autogeneratecolumns="false" 
           onCancelCommand="dGrid_cancel" 
           onUpdateCommand="dGrid_update" 
           onEditCommand="dGrid_edit">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <Columns>
                <asp:EditCommandColumn CancelText="cancel"  UpdateText="OK" EditText="<img src='../immagini/edit.gif' Border=0 Width=12 Height=12>"/>
                <asp:boundcolumn datafield="c_id" readonly="true" HeaderText="<b>ID</b>" />
             <asp:TemplateColumn>
              <HeaderTemplate><center><b>carrier</b></center></HeaderTemplate>
              <ItemTemplate>
               <asp:Label runat="server" Text=<%#simplestecommerce.lingua.getinadminlanguagefromdb(Eval("c_nome").ToString()) %> />
              </ItemTemplate>
             </asp:TemplateColumn>  
             
                <asp:boundcolumn datafield="c_prezzo" readonly="false" HeaderText="<b>supplementary cost</b>" />
            </Columns>
        </asp:datagrid>

        <br>
        <br>
        <br>



    </form></asp:Content>