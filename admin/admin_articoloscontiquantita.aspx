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

    protected int idArt;


    void bind () {

        IDataReader dr;

        dr = simplestecommerce.scontiQuantita.readAll (idArt);

        dGrid.DataSource= dr;

        dGrid.DataBind();


        dr.Close();


    }








    void buttCrea_click (object sender, EventArgs e) {

        bool valid=true;
        bool esisteQuantita;

        int quantitaDb=0;
        double scontoDb=0;

        try { quantitaDb = int.Parse (tBoxQuantita.Text);} catch {valid=false; lblerroresopra.Text+="<br>please insert an integer number in field QUANTITY"; }

        try { scontoDb = double.Parse(tBoxSconto.Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
        catch { valid = false; lblerroresopra.Text += "<br>please insert a number in field DISCOUNT"; }


        if (!valid) return;


        simplestecommerce.scontiQuantita.add (out esisteQuantita, idArt, quantitaDb, scontoDb);

        if (esisteQuantita) {
            lblerroresopra.Text+= "The breacket with this quantity already exists";
            return;
        }

        bind();
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

            double sconto;
            int idFascia;

            try { sconto = double.Parse(((TextBox)(e.Item.Cells[3].Controls[0])).Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
            catch {
                lblerroresopra.Text+= "please insert a number in field DISCOUNT";
                return;
            }

            idFascia = int.Parse ( e.Item.Cells[1].Text )  ;

            simplestecommerce.scontiQuantita.update (idFascia, sconto);
            dGrid.EditItemIndex=-1;
            bind();

    }

    void dGrid_delete (object sender, DataGridCommandEventArgs e) {
            int idFascia =  int.Parse ( e.Item.Cells[1].Text )  ;
            simplestecommerce.scontiQuantita.delete (idFascia);
            dGrid.EditItemIndex=-1;
            bind();

    }

















    void Page_Load() {

        lblerroresopra.Text = "";
        idArt = Convert.ToInt32 (Request.QueryString["idArt"]);

        if (!Page.IsPostBack)
        {
                ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>" +
                    " &raquo; " +
                    "<a href='admin_articoli.aspx'>products</a>" +
                    " &raquo; " +
                    "<a href='admin_articolo.aspx?idArt=" + idArt.ToString() + "'>product ID " + idArt.ToString() + "</a>" +
                    " &raquo; " +
                    " quantity discounts";



              bind();
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">










<form enctype="multipart/form-data" runat="server" >
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<div align=center style="font-size:13px; color:Red">
    <asp:Label ID="lblerroresopra" runat=server />
</div>

    <table width="100%" cellpadding="0" cellspacing="1">
        <tr class=admin_sfondodark>
            <td colspan=2 align=center><b>Add bracket</b></td>
        </tr>
        <tr class="admin_sfondo">
            <td>
                from quantity
            </td>
            <td>
                <asp:textbox size=5 enableviewstate="false" text="" cssclass=inputsmall id="tBoxQuantita" runat="server" /> <asp:label forecolor="red" enableviewstate="false" id="lblOpz" runat="server" />
            </td>
        </tr>
        <tr class="admin_sfondo">
            <td>
               quantity discount %
            </td>
            <td>
                <asp:textbox text="0" enableviewstate="false" size=5 cssclass=inputsmall id="tBoxSconto" runat="server" /><asp:label forecolor="red" enableviewstate="false" id="lblPrezzoOpz" runat="server" />
            </td>
        </tr>
        <tr class="admin_sfondo">
            <td colspan=2 align=center>
                <asp:button cssclass=bottone onClick="buttCrea_click" id="buttCrea" Text="ADD BRACKET" runat="server" />
            </td>
        </tr>
    </table>

    <br>
    <br>
    <br>
    <asp:datagrid  gridlines="None" cellspacing=1 onDeleteCommand="dGrid_delete" onCancelCommand="dGrid_cancel" onUpdateCommand="dGrid_update" onEditCommand="dGrid_edit" pagesize=3 cellpadding=4 id="dGrid" runat="server" width="100%" autogeneratecolumns="false">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <Columns>
                <asp:EditCommandColumn CancelText="cancel" UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" />
                <asp:boundcolumn readonly="true" datafield="s_id" HeaderText="<b>IDbracket</b>" />
                <asp:boundcolumn readonly="true" datafield="s_quantita" HeaderText="<b>from quantity</b>" />
                <asp:boundcolumn datafield="s_sconto" HeaderText="<b>quantity discount</b>" />
                <asp:buttoncolumn HeaderText="<b>delete bracket</b>" Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />
            </Columns>
    </asp:datagrid>


</form></asp:content>
