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

    DataSet ds;


        void buttNewFascia_click (object sender, EventArgs e) {

            int da=0;
            int a=0;
            double prezzo = 0;
            bool inputValido = true;

            try { da = int.Parse (tBoxDaPeso.Text) ; }
            catch {
                lblerr.Text+= "<br>field FROM must be an integer number";
                inputValido  = false;
            }


            try { a = int.Parse (tBoxAPeso.Text) ; }
            catch {
             lblerr.Text += "<br>field TO must be an integer number";
                inputValido  = false;
            }


            try { prezzo = double.Parse(tBoxPrezzo.Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
            catch {
             lblerr.Text += "<br>field PRICE must be a number";
                inputValido  = false;
            }

            if (!inputValido) return;


            simplestecommerce.spedizione.adminAddFasciaPeso (da, a, prezzo);
            bindDataNCheck();
        }




         void bindDataNCheck () {

                ds = simplestecommerce.spedizione.adminGetPesi();
                dGridPeso.DataSource= ds.Tables["pesi"];
                dGridPeso.DataBind();

                if (ds.Tables["pesi"].Rows.Count>0 && (int)ds.Tables["pesi"].Rows[0]["p_da"] != 0 ) {

                    lblerr.Text+= "<br>ATTENTION! First bracket must start from 0 grams. Please modify it." ;

                }


                int lastId=0;
                int lastA=0;

                for (int rip=0; rip< ds.Tables["pesi"].Rows.Count; rip++) {

                    if (rip>0) {

                        if ( (int) ds.Tables["pesi"].Rows[rip]["p_da"] != lastA + 1 ) {

                            lblerr.Text+= "<br>ATTENTION! bracket with ID " + ds.Tables["pesi"].Rows[rip]["p_id"] + " is not contiguous to bracket with ID  " + lastId ;
                        }
                    }

                    lastId =  (int) ds.Tables["pesi"].Rows[rip]["p_id"] ;
                    lastA =  (int) ds.Tables["pesi"].Rows[rip]["p_a"] ;
                }


         }





         void dGridPeso_edit (object sender, DataGridCommandEventArgs e) {

            dGridPeso.EditItemIndex = e.Item.ItemIndex;
            bindDataNCheck();

         }

         void dGridPeso_delete (object sender, DataGridCommandEventArgs e) {

            int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

            simplestecommerce.spedizione.adminDelFasciaPeso(id);
            bindDataNCheck();
        }

         void dGridPeso_cancel (object sender, DataGridCommandEventArgs e) {

            dGridPeso.EditItemIndex=-1;
            bindDataNCheck();
         }


        void dGridPeso_update (object sender, DataGridCommandEventArgs e) {

            bool inputValido=true;
            int da=0;
            int a=0 ;
            double prezzo=0;


            try {
                da = int.Parse ( ((TextBox)e.Item.Cells[2].Controls[0]).Text ) ;
            } catch {
                lblerr.Text+="<br>field FROM must be an integer number" ;
                inputValido = false;
            }
            try {
                a = int.Parse ( ((TextBox)e.Item.Cells[3].Controls[0]).Text ) ;
            } catch {
                lblerr.Text+="<br>field TO must be an integer number" ;
                inputValido = false;
            }
            try {
                prezzo = double.Parse(((TextBox)e.Item.Cells[4].Controls[0]).Text, simplestecommerce.admin.localization.primarynumberformatinfo);
            } catch {
                lblerr.Text+="<br>field PRICE must be a number" ;
                inputValido = false;
            }


            if (!inputValido) return;

            int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

            simplestecommerce.spedizione.adminUpdateFascePrezzo (id, da, a, prezzo) ;

            dGridPeso.EditItemIndex=-1;
            bindDataNCheck();
         }






         void Page_Load () {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; transport costs per total weight of goods";


             
            if (!Page.IsPostBack) bindDataNCheck();

         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />

		<fieldset>
 <legend>new bracket</legend>

        <table>
         <tr>
          <td>from grams</td>
          <td><asp:textbox runat=server enableviewstate=false  text="" id="tBoxDaPeso" class=input /></td>
         </tr>
         <tr>
          <td>to grams</td>
         <td><asp:textbox runat=server enableviewstate=false  text="" id="tBoxAPeso" class=input /></td>
         </tr>
         <tr>
          <td>transport cost</td>
         <td><asp:textbox runat=server enableviewstate=false  text="" id="tBoxPrezzo" class=input /></td>
         </tr>
        </table>
        
 <asp:button onclick="buttNewFascia_click" id="buttNewFascia" runat=server class=bottone text="CREATE NEW BRACKET" />
</fieldset>

 <br />
       <asp:datagrid  GridLines="none" CellSpacing="1" id="dGridPeso" runat="server" width="100%" autogeneratecolumns="false" onDeleteCommand="dGridPeso_delete" onCancelCommand="dGridPeso_cancel" onUpdateCommand="dGridPeso_update" onEditCommand="dGridPeso_edit">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:EditCommandColumn CancelText="annulla modifiche"  UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>"/>
                <asp:boundcolumn datafield="p_id" readonly="true" HeaderText="<b>ID</b>" />
                <asp:boundcolumn datafield="p_da" readonly="false" HeaderText="<b>from grams</b>" />
                <asp:boundcolumn datafield="p_a" readonly="false" HeaderText="<b>to grams</b>" />
                <asp:boundcolumn datafield="p_prezzo" readonly="false" HeaderText="<b>transport cost</b>" />
                <asp:buttoncolumn HeaderText="<b>delete</b>" Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />
            </Columns>
        </asp:datagrid>

        <br>

	
    </form></asp:content>