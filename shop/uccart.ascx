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


<%@ Control Language="c#"  %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script runat="server">
    public int from; // riceve from dalla pagina contenitore

    simplestecommerce.Cart mycart;
    ArrayList arrQuantita;

    int riga = 0;

    void butterrore_click(object o, EventArgs e)
    {

        Response.Redirect("~/shop/cart.aspx");

    }

    public void textBoxQuantita_load(object sender, EventArgs e)
    {

        arrQuantita.Add(((TextBox)sender).Text);

    }


    void repCart_dataBound(object sender, RepeaterItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {


            //showhide
            if (from == 0)
            {
                ((Label)e.Item.FindControl("lblQuantita")).Visible = false;
            }
            else
            {
                ((TextBox)e.Item.FindControl("textBoxQuantita")).Visible = false;
                ((ImageButton)e.Item.FindControl("buttAggiornaQuantita")).Visible = false;
            }


            simplestecommerce.cartItem ripCartItem = (simplestecommerce.cartItem)(e.Item.DataItem);


            if (from == 0)
            {

                ((ImageButton)e.Item.FindControl("buttAggiornaQuantita")).CommandArgument = riga++.ToString();
                ((ImageButton)e.Item.FindControl("buttAggiornaQuantita")).ToolTip = simplestecommerce.lingua.getforfrontendbypseudo("cartbox.button.tooltip.update.quantity");

                ((TextBox)e.Item.FindControl("textBoxQuantita")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded( ripCartItem.Quantita.ToString());


            }

            ((Label)e.Item.FindControl("lblQuantita")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded(ripCartItem.Quantita.ToString());

            ((Label)e.Item.FindControl("lblCodArt")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded((ripCartItem.Articolo.Code));


            string immagine = ripCartItem.Articolo.Preview;
            if (immagine == "") ((Image)e.Item.FindControl("imgArt")).ImageUrl = "~/immagini/non_disponibile.gif";
            else ((Image)e.Item.FindControl("imgArt")).ImageUrl = immagine;

            ((HtmlAnchor)e.Item.FindControl("linkArt")).HRef = ripCartItem.Articolo.Linkart;



            ((Label)e.Item.FindControl("lblNomeArt")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(ripCartItem.Articolo.Name));

            foreach (simplestecommerce.Choosedvariation v in ripCartItem.Choosedvariations)
            {

                ((Label)e.Item.FindControl("lblNomeArt")).Text +=
                    "<br>" + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(v.Nome)) + "  " + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(v.Choosedoption.Testo));
            }





            ((Label)e.Item.FindControl("lblPrezzoArt")).Text = currencies.tostrusercurrency(ripCartItem.Articolo.Prezzobase + ripCartItem.Variationssum);
            ((Label)e.Item.FindControl("lbldiscountart")).Text = Math.Round(ripCartItem.Totaldiscount, 2).ToString() + "%";

            ((Label)e.Item.FindControl("lblPrezzo_QuantitaArt")).Text = currencies.tostrusercurrency(ripCartItem.Finalprice * ripCartItem.Quantita);


        }

    }





    void repCart_itemCommand(object sender, RepeaterCommandEventArgs e)
    {

        if (e.CommandName == "update")
        {

            int nItem;
            int newQuantita;

            nItem = Convert.ToInt32((e.CommandArgument));


            if (!Int32.TryParse(arrQuantita[nItem].ToString(), out newQuantita) || newQuantita < 0)
            {
             string msg = simplestecommerce.lingua.getforfrontendbypseudo("cartbox.alert.inappropriate.quantity");
             simplestecommerce.common.alert(msg, this.Page);
             return;
            }

            cartItem citobemodified = mycart.lista[nItem];

            if (newQuantita == 0)
            {
                mycart.lista.Remove(citobemodified);
                Response.Redirect("~/shop/cart.aspx");
            }
            else
            {
             
                // check stock and availability 
                string errDisp = simplestecommerce.lingua.getforfrontendbypseudo ( Cart.pseudoerravailability(citobemodified.Articolo.Idart, newQuantita) );
                if (errDisp != "")
                {
                    string msg= simplestecommerce.sicurezza.xss.getreplacedencoded( errDisp );
                    simplestecommerce.common.alert(msg, this.Page);   
                 return;
                }
                else
                {
                    mycart.lista[nItem].Quantita = newQuantita;
                    Response.Redirect("~/shop/cart.aspx");

                }
            }

        }

    }


    void bindCart()
    {
        // bind items
        repCart.DataSource = mycart.lista;
        repCart.DataBind();



        // bind parziali***********************
        lblquantitysum.Text = mycart.getTotQuantita().ToString();

        lblsubtotal.Text = "<b>" + currencies.tostrusercurrency(mycart.Subtotal) + "</b>";

        
        //************************************



        if (from == 1)
        {
            // bind total amounts

            lbltaxamount.Text = currencies.tostrusercurrency(mycart.Taxamount);
            lbltaxname.Text = simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrtaxnameinpseudo[mycart.Taxtype]);
            lbltaxnamebis.Text = lbltaxname.Text;

            lblshippingcosts.Text = currencies.tostrusercurrency(mycart.Shippingcosts);
            if ((bool)Application["config_applytaxonshipping"])
            {
                pholdertaxonshippingcosts.Visible = true;
                lbltaxonshippingcosts.Text = currencies.tostrusercurrency(mycart.Taxontransportcosts);
            }
            else pholdertaxonshippingcosts.Visible = false;

            if (mycart.Coupononsubtotal > 0)
            {

                pholdercoupondiscountonsubtotal.Visible = true;
                lblcoupondiscountonsubtotal.Text = currencies.tostrusercurrency(mycart.Coupononsubtotal);

            }
            
            
            
            if (mycart.Couponaftertaxes > 0)
            {

                pholdercoupondiscountaftertaxes.Visible = true;
                lblcoupondiscountaftertaxes.Text = currencies.tostrusercurrency(mycart.Couponaftertaxes);
                
            }
            
            lbltot.Text = currencies.tostrusercurrency(mycart.Tot);




        }
    }







    void Page_Load()
    {

        repCart.ItemDataBound += new RepeaterItemEventHandler(repCart_dataBound);
        repCart.ItemCommand += new RepeaterCommandEventHandler(repCart_itemCommand);

        arrQuantita = new ArrayList();

        mycart = (simplestecommerce.Cart)Session["Cart"];




        if (from == 0)
        {
            pholdertot.Visible = false;
        }
        if (!Page.IsPostBack) bindCart();



    }

</script>
<asp:Panel runat="server" EnableViewState="true" ViewStateMode="Enabled">





<table width="100%" cellpadding="2" cellspacing="1" id="tablecart">
    <tr class="header">
        <td class="filledbolddark" align="center" width="36"><span class="cartvoices"><%=lingua.getforfrontendbypseudo("cartbox.label.photo") %></span></td>
        <td class="filledbolddark" align="center"><%=simplestecommerce.lingua.getforfrontendbypseudo("cartbox.label.product.code") %></td>
        <td class="filledbolddark" align="center"><%=(lingua.getforfrontendbypseudo("cartbox.label.product.name"))%></td>
        <td class="filledbolddark" align="center"><%=(lingua.getforfrontendbypseudo("cartbox.label.price"))%></td>
        <td class="filledbolddark" align="center"><%=(lingua.getforfrontendbypseudo("cartbox.label.discount"))%></td>
        <td class="filledbolddark" align="center"><%=(lingua.getforfrontendbypseudo("cartbox.label.quantity"))%></td>
        <td class="filledbolddark" align="center"><%=(lingua.getforfrontendbypseudo("cartbox.label.amount"))%></td>
    </tr>
    <asp:Repeater ID="repCart" runat="server" >

        <ItemTemplate>

            <input type="hidden" id="hiddenNItem" runat="server" />
            <tr class="filled">
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
                                <asp:Label ID="lblQuantita" runat="server" Style="height:14px;"/>
                                <asp:TextBox ID="textBoxQuantita" Style="height:14px; font-size:11px; width:28px; text-align: right" OnLoad="textBoxQuantita_load"  runat="server" />
                            </td>
                            <td valign="middle">
                                <asp:ImageButton CommandName="update" ID="buttAggiornaQuantita" runat="server" Width="17" Height="17" ImageUrl="~/immagini/updatecart.png" />
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

    <tr class="filledbold">
        <td align="center" colspan="2"><b><span style="color: Red">
            <%Response.Write(lingua.getforfrontendbypseudo("cartbox.label.subtotal"));%>
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
            <tr class="filled">
                <td align="center" colspan="2"><%Response.Write(lingua.getforfrontendbypseudo("cartbox.label.coupon.discount"));%></td>
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

            <tr class="filled">
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

        <tr class="filled">
            <td align="center" colspan="2"><%Response.Write(lingua.getforfrontendbypseudo("cartbox.label.shipping.costs.and.additional.fees"));%></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td></td>
            <td align="right">
                <asp:Label ID="lblshippingcosts" runat="server" />&nbsp;&nbsp;
            </td>
        </tr>

        <asp:PlaceHolder ID="pholdertaxonshippingcosts" runat="server" Visible="false">
            <tr class="filled">
                <td colspan=2 align="center"><asp:label runat=server id="lbltaxnamebis" />&nbsp;<%=simplestecommerce.lingua.getforfrontendbypseudo("cartbox.label.(tax).on.shipping.costs.and.additional.fees")%></td>
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
            <tr class="filled">
                <td colspan=2 align="center"><%Response.Write(lingua.getforfrontendbypseudo("cartbox.label.coupon.discount"));%></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td align="center"><b></b></td>
                <td></td>
                <td align="right">
                    <asp:Label ID="lblcoupondiscountaftertaxes" runat="server" />&nbsp;&nbsp;
                </td>
            </tr>
        </asp:PlaceHolder>


        <tr class="filled">
            <td colspan=2 align="center"><b><%Response.Write(lingua.getforfrontendbypseudo("cartbox.label.tot"));%></b></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td align="center"><b></b></td>
            <td></td>
            <td class="filledbold" align="right"><b>
                <asp:Label ID="lbltot" runat="server" /></b>&nbsp;&nbsp;
            </td>
        </tr>

    </asp:PlaceHolder>

</table>

</asp:Panel>