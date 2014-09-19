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

<%@ Control Language="c#"   %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="simplestecommerce" %>

<script runat="server">
int idcart;
    simplestecommerce.Dbcart mydbcart;




    void repCart_dataBound(object sender, RepeaterItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {


            simplestecommerce.Dbcartitem Dbcartitem = (simplestecommerce.Dbcartitem)(e.Item.DataItem);



            if (Dbcartitem.Preview == "") ((Image)e.Item.FindControl("imgArt")).ImageUrl= ResolveUrl("~/immagini/non_disponibile.gif");
            else ((Image)e.Item.FindControl("imgArt")).ImageUrl = ResolveUrl(Dbcartitem.Preview);




            ((Label)e.Item.FindControl("lblCodArt")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded((Dbcartitem.Artcode));


            //string immagine = Dbcartitem.Articolo.Preview;
            //if (immagine == "") ((Image)e.Item.FindControl("imgArt")).ImageUrl = "~/immagini/non_disponibile.gif";
            //else ((Image)e.Item.FindControl("imgArt")).ImageUrl = immagine;

           // ((HtmlAnchor)e.Item.FindControl("linkArt")).HRef = Dbcartitem.Articolo.Linkart;



            ((Label)e.Item.FindControl("lblNomeArt")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded( Dbcartitem.Artnameinuserlanguage);

            foreach (simplestecommerce.Dbcartvariation v in Dbcartitem.Dbcartvariations)
            {

                ((Label)e.Item.FindControl("lblNomeArt")).Text +=
                    "<br>" + simplestecommerce.sicurezza.xss.getreplacedencoded(v.Strvariationinuserlanguage) + "  " + simplestecommerce.sicurezza.xss.getreplacedencoded(v.Stroptioninuserlanguage);
            }





            ((Label)e.Item.FindControl("lblPrezzoArt")).Text = Dbcartitem.Finalprice.ToString("C");
            ((Label)e.Item.FindControl("lbldiscountart")).Text = Math.Round(Dbcartitem.Totaldiscount, 2).ToString() + "%";
            ((Label)e.Item.FindControl("lblquantity")).Text = Dbcartitem.Quantity.ToString();

            ((Label)e.Item.FindControl("lblPrezzo_QuantitaArt")).Text = (Dbcartitem.Finalprice * Dbcartitem.Quantity).ToString("C");


        }

    }








    void bindCart()
    {
        // bind items
        repCart.DataSource = mydbcart.lista;
        repCart.DataBind();



        // bind parziali***********************
        //lblquantitysum.Text = mydbcart.getTotQuantita().ToString();

        lblsubtotal.Text = "<b>" + currencies.tostrusercurrency(mydbcart.Subtotal) + "</b>";

        
        //************************************



            // bind total amounts

            lbltaxamount.Text = currencies.tostrusercurrency(mydbcart.Tax);
            lbltaxname.Text = simplestecommerce.lingua.getinadminlanguagebypseudo(simplestecommerce.common.arrtaxnameinpseudo[mydbcart.Taxtype]);
            lbltaxnamebis.Text = lbltaxname.Text;
            lblshippingcosts.Text = currencies.tostrusercurrency(mydbcart.Shippingcost);
            if ((bool)Application["config_applytaxonshipping"])
            {
                pholdertaxonshippingcosts.Visible = true;
                lbltaxonshippingcosts.Text = currencies.tostrusercurrency(mydbcart.Taxonshippingcost);
            }
            else pholdertaxonshippingcosts.Visible = false;

            if (mydbcart.Coupononsubtotal > 0)
            {

                pholdercoupondiscountonsubtotal.Visible = true;
                lblcoupondiscountonsubtotal.Text = currencies.tostrusercurrency(mydbcart.Coupononsubtotal);

            }
            
            
            
            if (mydbcart.Couponaftertax > 0)
            {

                pholdercoupondiscountaftertaxes.Visible = true;
                lblcoupondiscountaftertaxes.Text = currencies.tostrusercurrency(mydbcart.Couponaftertax);
                
            }
            
            lbltot.Text = currencies.tostrusercurrency(mydbcart.Tot);




    }







    void Page_Load()
    {

        idcart = Convert.ToInt32 ( Request.QueryString["idcart"]);
        
        repCart.ItemDataBound += new RepeaterItemEventHandler(repCart_dataBound);
        
        if (!Page.IsPostBack) {
            
        mydbcart = new Dbcart (idcart);
        bindCart();            
            
            
        }
        

        








    }

</script>

<table width="100%" cellpadding="2" cellspacing="1" >
    <tr class="admin_sfondodark">
        <td align="center" width="36"><span class="cartvoices"><%=lingua.getinadminlanguagebypseudo("admin.cartbox.photo") %></span></td>
        <td align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.art.code"));%></td>
        <td align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.art.name"));%></td>
        <td align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.price"));%></td>
        <td align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.discount"));%></td>
        <td align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.quantity"));%></td>
        <td align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.amount"));%></td>
    </tr>
    <asp:Repeater ID="repCart" runat="server" >

        <ItemTemplate>

            <input type="hidden" id="hiddenNItem" runat="server" />
            <tr class="admin_sfondo">
                <td align="center" height="56">
                    <a runat="server" id="linkArt">
                        <asp:Image ID="imgArt" Width="34" Height="34" runat="server" /></a>
                </td>

                <td align="center">
                    <asp:Label ID="lblCodArt" runat="server" />
                </td>
                <td align="center">
                    <asp:Label ID="lblNomeArt" runat="server" />
                </td>
                <td align="right">
                    <asp:Label ID="lblPrezzoArt" runat="server" />
                </td>

                <td align="right">
                    <asp:Label ID="lbldiscountart" runat="server" />
                </td>


                <td align="center" nowrap valign="middle">
                    <table>
                        <tr>
                            <td valign="middle">
                                <asp:Label ID="lblquantity" runat="server" Style="height:14px;"/>
                            </td>
                        </tr>
                    </table>



                </td>



                <td align="right">
                    <asp:Label ID="lblPrezzo_quantitaArt" runat="server" />&nbsp;&nbsp;
                </td>
            </tr>


        </ItemTemplate>
    </asp:Repeater>

    <tr class="admin_sfondodark">
        <td align="center" colspan="2"><b><span style="color: Red">
            <%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.subtotal"));%>
        &nbsp;<asp:Label ID="lblScontoImporto" runat="server" />
        </span></b></td>
        <td align="center"><b></b></td>
        <td align="center"><b></b></td>
        <td align="right"></td>
        <td align="center"><b><asp:Label ID="lblquantitysum" runat="server" /></b></td>
        <td align="right">
            <asp:Label ID="lblsubtotal" runat="server" />
        </td>
    </tr>

        <asp:PlaceHolder ID="pholdercoupondiscountonsubtotal" runat="server" Visible="false">
            <tr class="admin_sfondo">
                <td align="center" colspan="2"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.discount.coupon"));%></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td></td>
                <td align="right">
                    <asp:Label ID="lblcoupondiscountonsubtotal" runat="server" />&nbsp;&nbsp;
                </td>
            </tr>
        </asp:PlaceHolder>


    <asp:PlaceHolder ID="pholdertot" runat="server">
        <asp:PlaceHolder ID="pholdertax" runat="server">

            <tr class="admin_sfondo">
                <td align="center" colspan="2"><asp:Label runat="server" ID="lbltaxname" /></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td></td>
                <td align="right">
                    <asp:Label ID="lbltaxamount" runat="server" />&nbsp;&nbsp;
                </td>
            </tr>
        </asp:PlaceHolder>

        <tr class="admin_sfondo">
            <td align="center" colspan="2"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.shipping.costs.and.addition.fees"));%></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td></td>
            <td align="right">
                <asp:Label ID="lblshippingcosts" runat="server" />&nbsp;&nbsp;
            </td>
        </tr>

        <asp:PlaceHolder ID="pholdertaxonshippingcosts" runat="server" Visible="false">
            <tr class="admin_sfondo">
                <td colspan=2 align="center"><asp:Label runat="server" ID="lbltaxnamebis" />&nbsp;<%= lingua.getinadminlanguagebypseudo("admin.cartbox.label.on.shipping.costs.and.additional.fees")%></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td></td>
                <td align="right">
                    <asp:Label ID="lbltaxonshippingcosts" runat="server" />&nbsp;&nbsp;
                </td>
            </tr>
        </asp:PlaceHolder>

        <asp:PlaceHolder ID="pholdercoupondiscountaftertaxes" runat="server" Visible="false">
            <tr class="admin_sfondo">
                <td colspan=2 align="center"><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.discount.coupon"));%></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td></td>
                <td align="right">
                    <asp:Label ID="lblcoupondiscountaftertaxes" runat="server" />&nbsp;&nbsp;
                </td>
            </tr>
        </asp:PlaceHolder>


        <tr class="admin_sfondodark">
            <td colspan=2 align="center"><b><%Response.Write(lingua.getinadminlanguagebypseudo("admin.cartbox.total"));%></b></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td></td>
            <td class="admin_sfondodark" align="right"><b>
                <asp:Label ID="lbltot" runat="server" /></b>&nbsp;&nbsp;
            </td>
        </tr>

    </asp:PlaceHolder>

</table>
