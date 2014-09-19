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
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">

void cambioCat (object s,EventArgs e) {

    if ( cBoxCat.Checked ) {
        cBoxProd.Checked=true;
        cBoxProd.Enabled=false;
        }
    else cBoxProd.Enabled=true;
}



void buttAggiorna_click (object o, EventArgs e)
{



    if (((bool)simplestecommerce.config.getCampoByApplication("config_demo")))
    {
        Label lbl = lblerr;
        lbl.Text = "Function disabled on demo";
        lbl.ForeColor = System.Drawing.Color.Red;
        return;
    }
    
    
    lblerr.Text="";
    string sql;
    if ( cBoxCat.Checked ) {

     
        sql = "DELETE FROM tcategorie";
        simplestecommerce.helpDb.nonQuery (sql);
        lblerr.Text += "<br>categories and products deleted";
        simplestecommerce.caching.cachevisiblecategories("");



     
    }

    if (cBoxProd.Checked && !cBoxCat.Checked)
    {

        sql = "DELETE FROM tarticoli";
        simplestecommerce.helpDb.nonQuery(sql);
        lblerr.Text += "<br>products deleted";

    }

    if (cBoxNews.Checked)
    {

        sql = "DELETE FROM tnews";
        simplestecommerce.helpDb.nonQuery(sql);
        lblerr.Text += "<br>news deleted";
    }

    if (cBoxPagine.Checked)
    {

        sql = "DELETE FROM tpagine";
        simplestecommerce.helpDb.nonQuery(sql);
        lblerr.Text += "<br>extra pages deleted";
    }

    if (cBoxOrdini.Checked)
    {

        sql = "DELETE FROM tcart";
        simplestecommerce.helpDb.nonQuery(sql);
        lblerr.Text += "<br>orders deleted";
    }


    if (cBoxUtenti.Checked)
    {


            sql = "DELETE FROM tutenti";
            simplestecommerce.helpDb.nonQuery(sql);

            

        



        
        lblerr.Text += "<br>registered users deleted";
    }



    if (cBoxMailing.Checked)
    {

        sql = "DELETE FROM tmailing";
        simplestecommerce.helpDb.nonQuery(sql);
        lblerr.Text += "<br>subscribed to newsletter by mailing list box users deleted";
    }






    if (lblerr.Text == "") lblerr.Text = "select an element to delete";
}

         void Page_Load() {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; empty web site"; 

             
         


         }

 

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
    <script>
        function confirm_delete() {
            if (confirm("Confirm?"))
                return true;
            else
                return false;
        }
        
</script>

</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />






 <table width="100%" cellpadding=3 cellspacing=1  >


 <tr class="admin_sfondo">
 <td width="80%" class="admin_sfondo">Delete categories</td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" id="cBoxCat" ClientIDMode="Static"  size=3 runat="server" class=inputsmall  onchange="if ( document.getElementById('cBoxCat').checked) alert('N.B. If you delete categories also all the products will be deleted.')"  /> </td>
 </tr>

 <tr class="admin_sfondo">
 <td class="admin_sfondo">Delete products</td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" id="cBoxProd" size=3 runat="server" class=inputsmall  /> </td>
 </tr>

 <tr class="admin_sfondo">
 <td class="admin_sfondo">Delete news</td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" id="cBoxNews" size=3 runat="server" class=inputsmall /> </td>
 </tr>

 <tr class="admin_sfondo">
 <td class="admin_sfondo">Delete extra pages</td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" id="cBoxPagine" size=3 runat="server" class=inputsmall /> </td>
 </tr>

 <tr class="admin_sfondo">
 <td class="admin_sfondo">Delete orders</td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" id="cBoxOrdini" size=3 runat="server" class=inputsmall /> </td>
 </tr>



 <tr class="admin_sfondo">
 <td class="admin_sfondo">Delete registered users</td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" ClientIDMode="Static" id="cBoxUtenti" size=3 runat="server" class=inputsmall  
  onchange="if ( document.getElementById('cBoxUtenti').checked) alert('N.B. If you delete registered users also all their orders will be deleted.') "
  /> </td>
 </tr>

 <tr class="admin_sfondo">
 <td class="admin_sfondo">Delete subscribed users to newsletter by mailing list box </td>
 <td class=admin_sfondobis><asp:checkbox enableviewstate="false" id="cBoxMailing" size=3 runat="server" class=inputsmall /> </td>
 </tr>


</table>





<div align=center style="padding-right:20px"><br /><br />
    <asp:button  OnClientClick="return confirm_delete();" class=bottone onClick="buttAggiorna_click" id="buttAggiorna" runat="server" text="DELETE SELECTED ITEMS" />
</div>







</form></asp:content>
