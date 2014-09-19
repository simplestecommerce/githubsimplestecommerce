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

    void buttDuplica_click (object sender, EventArgs e) {

        bool almenoUno = false;
        foreach ( ListItem li in lBoxTarget.Items) {
            if (li.Selected) almenoUno = true;
        }
        if (!almenoUno) lblErr.Text= "select at least one target list price";


        int source = Convert.ToInt32 ( dDLSource.SelectedValue );

        foreach (ListItem li in lBoxTarget.Items) {


            if (li.Selected) {
                simplestecommerce.listini.duplica (source, Convert.ToInt32 ( li.Value ) , cBoxSconti.Checked);
                lblMessage.Text = "Done.";
            }
        }



    }



    void bind() {




    }


    void Page_Init() {

        
        buttDuplica.Attributes.Add("onclick", "return confirm_delete();");

    }

    void Page_Load () {

        if (!Page.IsPostBack) bind();

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
<script>
    function confirm_delete() {
        if (confirm("target price lists will be replaced by this price list. Confirm?") == true)
            return true;
        else
            return false;
    }
</script>

</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="Label1" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />



						
            <table width="99%" width="100%" cellpadding=3 cellspacing=1 style="background-color:#000000">
            <tr>
            <td class="admin_sfondo" width="20%">
            select price list to copy:
            </td>
            <td class=admin_sfondobis>
            <asp:dropdownlist id="dDLSource" runat=server class=input >
                <asp:listitem selected  value="0">price list 0</asp:listitem>
                <asp:listitem value="1">price list 1</asp:listitem>
                <asp:listitem value="2">price list 2</asp:listitem>
                <asp:listitem value="3">price list 3</asp:listitem>
                <asp:listitem value="4">price list 4</asp:listitem>
                <asp:listitem value="5">price list 5</asp:listitem>
                <asp:listitem value="6">price list 6</asp:listitem>
                <asp:listitem value="7">price list 7</asp:listitem>
                <asp:listitem value="8">price list 8</asp:listitem>
                <asp:listitem value="9">price list 9</asp:listitem>
            </asp:dropdownlist>
            </td>
            </tr>
            <tr>
            <td class="admin_sfondo">select target price lists:</td>
            <td class=admin_sfondobis>
            <asp:listbox enableviewstate="TRUE" id="lBoxTarget" rows=10 selectionMode="multiple" runat="server" class=inputsmall >
                <asp:listitem value="0">price list 0</asp:listitem>
                <asp:listitem value="1">price list 1</asp:listitem>
                <asp:listitem value="2">price list 2</asp:listitem>
                <asp:listitem value="3">price list 3</asp:listitem>
                <asp:listitem value="4">price list 4</asp:listitem>
                <asp:listitem value="5">price list 5</asp:listitem>
                <asp:listitem value="6">price list 6</asp:listitem>
                <asp:listitem value="7">price list 7</asp:listitem>
                <asp:listitem value="8">price list 8</asp:listitem>
                <asp:listitem value="9">price list 9</asp:listitem>
            </asp:listbox>
            </td>
            </tr>
            <tr>
            <td class="admin_sfondo">copy also products discounts:</td>
            <td class=admin_sfondobis><asp:checkbox runat=server id="cBoxSconti" class=input />

            </table>
            <div align=right style="padding-right:18px">
                <br />
                <asp:button id="buttDuplica" onClick="buttDuplica_click" class=bottone runat=server text="DUPLICATE"  />
            </div>
            <br>
            <asp:label forecolor="red" id="lblErr" enableviewstate=false runat=server/>
            <br>
            <asp:label forecolor="blue" id="lblMessage" enableviewstate=false runat=server />
            </div>



    </form></asp:Content>