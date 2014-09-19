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





         void bind () {

                DataTable dt = simplestecommerce.tipiPagamento.getAll();
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

            int modalita;

            try { prezzo = double.Parse(((TextBox)e.Item.Cells[3].Controls[0]).Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
            catch {
                lblerr.Text+= "<br>field PRICE must be a number";
                inputValido  = false;
            }

            if (!inputValido) return;

            int indice =  Convert.ToInt32 (e.Item.Cells[1].Text);

            modalita = Convert.ToInt32(((DropDownList)e.Item.Cells[4].Controls[1]).Text);
            
            simplestecommerce.spedizione.updateSovrappr (indice, prezzo, modalita) ;

            dGrid.EditItemIndex=-1;
            bind();
         }






         void Page_Load () {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; extra charges per mode of payment";

             
             
            if (!Page.IsPostBack) bind();

         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />


       <asp:datagrid  border=1 bordercolor=#000000 cellpadding=4 id="dGrid" runat="server" width="100%" autogeneratecolumns="false" onCancelCommand="dGrid_cancel" onUpdateCommand="dGrid_update" onEditCommand="dGrid_edit">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:EditCommandColumn CancelText="cancel"  UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>"/>
                <asp:boundcolumn datafield="id" visible=false readonly="true" />
                <asp:templatecolumn  HeaderText="<b>mode of payment</b>" >
                    <ItemTemplate>
                       <asp:label runat=server text=<%#simplestecommerce.lingua.getinadminlanguagefromdb( simplestecommerce.modeofpayment.nomeTipPagamById ((int)DataBinder.Eval ( Container.DataItem, "id" )))%> />
                    </ItemTemplate>
                </asp:templatecolumn>
                <asp:boundcolumn datafield="prezzo" readonly="false" HeaderText="<b>extracharge</b>" />

                <asp:templatecolumn  HeaderText="<b>fixed or in percentage</b>" >
                    <ItemTemplate>
                        <asp:Label runat=server text='<%#(int)Eval ("modalita")==0? "percentage": "fixed" %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                       <asp:dropdownlist runat=server id="dDLTipoSovrapprezzo" >
                            <asp:listitem value="0">in percentage</asp:listitem>
                            <asp:listitem value="1">fixed</asp:listitem>
                        </asp:dropdownlist>
                    
                    </EditItemTemplate>
                </asp:templatecolumn>


            </Columns>
        </asp:datagrid>

        <br><br>


    </form></asp:content>