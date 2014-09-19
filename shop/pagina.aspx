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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" Trace="false" %>
<%@ MasterType  virtualPath="~/shop/masterpage.master"%>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>
<script runat="server">

    int id;
    string nome = "";
    int protezione = 0;
    string testo= "";
        
    void bind () {

        IDataReader dr ;
        dr = simplestecommerce.pagine.leggi(id) ;
        dr.Read () ;
        protezione = (int)dr["pa_protezione"];
        testo = simplestecommerce.lingua.getforfrontendfromdb(dr["pa_testo"].ToString());
        nome = simplestecommerce.lingua.getforfrontendfromdb(dr["pa_nome"].ToString());
        dr.Close();
        simplestecommerce.User currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;

        if ((protezione == 0) || (protezione == 1 && !currentuser.Anonimo) || (protezione == 2 && !currentuser.Anonimo && currentuser.Protezione== 1))

        {
            lblContent.Text = testo;
            lblNome.Text = nome;
            pHolderContent.Visible = true;
            
        }
        else 
        {
            lblWarning.Text = simplestecommerce.lingua.getforfrontendbypseudo("extrapage.not.allowed.to.view");
            lblWarning.Visible = true;
        }


    }


    void Page_Load () {

        id = Convert.ToInt32(Request.QueryString["id"]);

        bind();

    }

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">





    <center><b><asp:Label ID="lblWarning"  EnableViewState=false runat=server visible=false /></b></center>
    <asp:PlaceHolder Visible=false ID="pHolderContent" runat=server>
     

       <table cellspacing="0" cellpadding="0" width="100%" id="tablecontainersottocat" >
       <tr >
       <td class="box" width="100%"><div class="titolibox"><asp:label runat="server" id="lblNome" /></div></td>
       </tr>
        <tr>
         <td>

  
                <div style="padding:4px; text-align:left">
                    <asp:label runat=server id="lblContent" />
                </div>


         </td>
        </tr>


</table>
     
     
          
</asp:PlaceHolder>


</asp:Content>