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


<%@ Control Language="c#" %>
<%@ Import Namespace="simplestecommerce" %>
<script runat="server">
     


    
    
    
    
    
 void Page_PreRender()
 {

  
  simplestecommerce.Cart myCart = (simplestecommerce.Cart)Session["Cart"];



  int totquantity = myCart.getTotQuantita();



  if (totquantity > 0)
  {

   lblcartcontent.Text = totquantity.ToString() + "&nbsp;" + simplestecommerce.lingua.getforfrontendbypseudo("allpages.cartbox.label.items.in.your.cart");
   lblcartcontent.Text += "<br><b>" + simplestecommerce.lingua.getforfrontendbypseudo("allpages.cartbox.subtotal") + " " + simplestecommerce.currencies.tostrusercurrency(myCart.Subtotal) + "</b>";
   pholderemptycart.Visible = false;
   pholderfullcart.Visible = true;
  }
  

 }




      
</script>

      <asp:UpdatePanel ID="pannellodinamicoincarrelloascx" runat="server" UpdateMode="Conditional">
       <ContentTemplate>
<table cellspacing="0" cellpadding="0" width="100%" >
 <tr>
  <td class="box" width="100%">
   <div align="left" class="titoliboxsx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.cartbox.boxtitle") %></div>
  </td>
 </tr>
</table>



<table width="100%" class="contenutobox" cellpadding="0" cellspacing="0" style="margin-top:2px">
 <tr>
  <td width="100%">
   <div style="padding: 3px; width: 100%" align="center">
    <asp:PlaceHolder runat="server" ID="pholderfullcart" Visible="false">
     <asp:Label runat="server" ID="lblcartcontent" />
     <br />
     <a runat="server" href="~/shop/cart.aspx" style="text-decoration:underline"><%=(lingua.getforfrontendbypseudo("allpages.cartbox.show.or.buy"))%></a>
    </asp:PlaceHolder>
    <asp:PlaceHolder runat="server" ID="pholderemptycart" Visible="true">
     <%=lingua.getforfrontendbypseudo("allpages.cartbox.empty") %>
    </asp:placeholder>

   </div>
  </td>
 </tr>
</table>
        </ContentTemplate>
      </asp:UpdatePanel>
