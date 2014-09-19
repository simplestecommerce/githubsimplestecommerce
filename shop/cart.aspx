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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" ValidateRequest="true" %>
<%@ MasterType  virtualPath="~/shop/masterpage.master"%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register TagPrefix="simplestecommerce" TagName="carrello" Src="uccart.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="incarrello" Src="ucincarrello.ascx" %>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>

<script runat="server">

    
    
        
    
    void buttProc_click (object sender, EventArgs e) {
        //sane
        if (Math.Round(((simplestecommerce.Cart)Session["Cart"]).Subtotal, 2) < (double)Application["config_minOrd"])
        {
            string strAlert = simplestecommerce.lingua.getforfrontendbypseudo("cart.alert.min.order.is")+ " " + currencies.tostrusercurrency((double)Application["config_minOrd"]);

            simplestecommerce.common.alert(strAlert, this.Page);            
            return;

        }

        if (Math.Round(((simplestecommerce.Cart)Session["Cart"]).Subtotal, 2) > (double)Application["config_maxOrd"])
        {
            string strAlert = simplestecommerce.lingua.getforfrontendbypseudo("cart.alert.max.order.is") + " " + currencies.tostrusercurrency((double)Application["config_maxOrd"]);

            simplestecommerce.common.alert(strAlert, this.Page);

            return;

        }




        Response.Redirect("~/shop/cartcollect.aspx");
    }


    void buttShop_click (object sender, EventArgs e) {
        //sane
        if (Session["lastVisit"] != null)
        {
            Response.Redirect (Session["lastVisit"].ToString());

        }

        else Response.Redirect("~/shop/default.aspx");
    }


    void svuota(object sender, EventArgs e)
    {
        //sane
        ((simplestecommerce.Cart)Session["Cart"]).svuota();
        Response.Redirect("~/shop/cart.aspx");    
            

    }




    void showHide () {
        //sane
        if (((simplestecommerce.Cart)Session["Cart"]).isempty) buttProc.Visible = false;
    }

    void Page_Init () {
        //sane
        if ((int)Application["config_registrazione"] > 0 && ((simplestecommerce.Cart)Session["Cart"]).User.Anonimo) Response.Redirect("~/shop/login.aspx");




        buttShop.Text = "< " + simplestecommerce.lingua.getforfrontendbypseudo("cart.button.continue.shopping");
        buttProc.Text = simplestecommerce.lingua.getforfrontendbypseudo("cart.button.proceed") + " >";
        buttSvuota.Text = simplestecommerce.lingua.getforfrontendbypseudo("cart.button.clear.cart");


    }

    void Page_Load()
    {
        //sane

    }
    
    void Page_PreRender () {
        //sane
        
        showHide();

    }

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">

    <!-- sane -->

   <simplestecommerce:carrello id="uccarrello" from=0 runat="server"/>
   <div align=left>
       <br />
       <%=(lingua.getforfrontendbypseudo("cart.label.tip.to.delete.an.article"))%>
       <br><b><%=(lingua.getforfrontendbypseudo("cart.label.taxes.will.be.calculated.on.next.page"))%></b>

   </div>

   <table width="100%">
   <tr>
   <td>
       <asp:button cssclass=pulsante onClick="buttShop_click" id="buttShop" runat="server" />
   </td>
   <td align=center>
       <asp:button cssclass=pulsante onClick="svuota" id="buttSvuota" runat="server" />
   </td>
   <td align=right>
       <asp:button cssclass=pulsante onClick="buttProc_click" id="buttProc" runat="server" />
   </td>
   </tr>
   </table>

    <div align=center><asp:Label ID="lblMess" ForeColor="red" runat=server EnableViewState=false /></div>

 </asp:Content>