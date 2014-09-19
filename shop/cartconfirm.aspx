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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" codefile="cartconfirm.aspx.cs" Inherits="simplestecommerce.behindCartConfirmAspx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="cart" Src="uccart.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="paypal" Src="paypal.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="incarrello" Src="ucincarrello.ascx" %>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>

<asp:Content runat="server" ContentPlaceHolderID="headerpart">

    <script>

        function getaction() {
            return ("https://www.paypal.com/cgi-bin/webscr");
        }
    </script>


</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="parteCentrale" EnableViewState="true" ViewStateMode="Enabled">


   <div align=center>
        <table width="100%" cellspacing=0 cellpadding=0 class=modulo>
        <tr>
        <td class=filled align=center>
            <br>
            <br>
            <asp:label id="lblEsito" runat=server  />
            <br>
            <br>
            <br>
        </td>
        </tr>
        </table>
   </div>


    <div align=center>
        <br><br>
        <asp:placeholder runat="server" id="pholderpaypal" visible=false ClientIDMode="Static">
                    <input type="hidden" name="cmd" value="_xclick">
                    <input type="hidden" name="business" value='<%=paypalbusiness%>'  >
                    <input type="hidden" name="item_name" value='<%=paypalitemname%>' >
                    <input type="hidden" name="currency_code" value='<%=paypalcurrencycode%>' >
                    <input  type="hidden" name="amount" value='<%=paypalpamount%>' >
                    <input type="hidden" name="cancel_return" value='<%=Application["config_urlSito"].ToString() %>' >
                    <asp:imagebutton ID="imgpaypal" runat="server" ImageUrl="http://www.paypal.com/it_IT/i/btn/x-click-but01.gif" name="submit" alt="Pay with Paypal"/>
        </asp:placeholder>

    </div>

</asp:Content>