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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" Trace="false" %>

<%@ Import Namespace="System.Data" %>


<script runat="server">


    
    
 void change_stock(object o, EventArgs e)
 {
  //simplestecommerce.admin.generale.updateConfigScorte(int.Parse(DLISTstock.SelectedValue));

  bind();
 }



 void change_lastOrders(object sender, EventArgs e)
 {

  //simplestecommerce.admin.generale.updateConfigLastOrder(int.Parse(dListLastOrder.SelectedValue));

  bind();
 }






 void bind()
 {


  //int quantiUltimiGg = 0;
  //quantiUltimiGg = Convert.ToInt32(simplestecommerce.config.getCampoByApplication("config_lastOrderGg"));
  //dListLastOrder.SelectedValue = quantiUltimiGg.ToString();
  //DataTable dt = simplestecommerce.admin.generale.getLastOrders(quantiUltimiGg);
  //repLastOrder.DataSource = dt;
  //repLastOrder.DataBind();


  //// scorte
  //DLISTstock.SelectedValue = simplestecommerce.config.getCampoByApplication("config_scorte").ToString();


 }

















 void buttPass_click(object sender, EventArgs e)
 {

  Response.Redirect("admin_pass.aspx");
 }



 void buttCategorie_click(object sender, EventArgs e)
 {

  Response.Redirect("admin_categorie.aspx");

 }


 void Page_Init()
 {



  ((Label)Master.FindControl("lblDove")).Text = "Administration menù";



  //if (!Page.IsPostBack)
  //{
  //    for (int rip = 1; rip <= 30; rip++)
  //    {
  //        dListLastOrder.Items.Add(new ListItem(rip.ToString(), rip.ToString()));

  //    }

  //    for (int rip = 1; rip <= 100; rip++)
  //    {
  //        DLISTstock.Items.Add(new ListItem(rip.ToString(), rip.ToString()));

  //    }


  //bind();

  //}


 }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">

 <form runat="server">

  <%--<TABLE width="100%"  id="tablevocimenu" cellpadding="0" cellspacing="0" border="0">
<TR>
<TD valign=top width="1000">

    <br>
    <fieldset >
    <legend ><img runat="server" src='~/icons/line-chart.gif' width='27' height='27' align='absmiddle'>&nbsp;situation&nbsp;</legend>
    
        

                    There are <a style="text-decoration:underline" href="admin_articoli.aspx?mode=scorte"><b><%Response.Write(simplestecommerce.articoli.scorte()); %></b></a> products below stock of&nbsp;<asp:DropDownList runat="server" id="DLISTstock" AutoPostBack=true CssClass="inputsmall" OnSelectedIndexChanged="change_stock" />
               
    
       
   <br /><br />
    
    <fieldset ><legend style="text-shadow: 0px 0px 0px #000; font-size:13px; ">Orders from last&nbsp;<asp:DropDownList runat=server ID="dListLastOrder" CssClass=inputsmall  AutoPostBack="true" OnSelectedIndexChanged="change_lastOrders"/>&nbsp;days</legend>
    
    <asp:datalist runat=server ID="repLastOrder" EnableViewState=false  RepeatColumns="2" RepeatDirection="Vertical" Width="100%" CellPadding="0" CellSpacing="0">
         
        <ItemTemplate>
            <table  width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                         <asp:linkbutton runat=server Text='<%#Eval("data") + " from " + Eval("guestfirstname").ToString() + " " + Eval ("guestsecondname").ToString()  + " " + ((double)Eval("tot")).ToString("C") + " " + simplestecommerce.lingua.getinadminlanguagefromdb(simplestecommerce.orderstatus.getAll().Rows.Find( Eval("id") )["name"].ToString()) %>'  
                          PostBackUrl='<%#"admin_ordine.aspx?id=" + Eval("id") %>'
                        />
                    </td>
                </tr>
                
            </table>
        </ItemTemplate>
    
    </asp:datalist>
        </fieldset>
    
    
   </fieldset>
</td>
</tr>
</table>--%>
  <br />
  <table width="100%" border="0" id="tablemenuadmin">
   <tr>
    <td valign="top" width="492">

     <fieldset>
      <legend>
       <img runat="server" src='~/icons/line-chart.gif' width='27' height='27' align='absmiddle'>&nbsp;configuration&nbsp;</legend>



      &nbsp;  <a href="admin_pass.aspx">change administrator password</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

      &nbsp;  <a href="admin_openclose.aspx">open/close shop</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

      &nbsp;  <a href="admin_layout.aspx">layout</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_websiteparameter.aspx">web site site parameters</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_logo.aspx">logo</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_tipipagamento.aspx">modes of payment</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_messaggi.aspx">messages of order confirmation per modes of payment</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_orderstatus.aspx">status of order</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_carrier.aspx">carriers</a>

      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_userfields.aspx">user fields</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

      &nbsp;  <a href="admin_registrationpreferences.aspx">registration preferences</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

      &nbsp;  <a href="admin_metatag.aspx">meta tag</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_smtp.aspx">parameters for sending email from the site</a>


     </fieldset>

     <br />
     <fieldset>
      <legend>languages</legend>
      &nbsp;  <a href="admin_language.aspx">set web site languages</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_languagepack.aspx">download/upload language pack</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

     </fieldset>

     <br />
     <fieldset>
      <legend>
       <img runat="server" src='~/icons/icon_euro.png' width='28' height='28' align='absmiddle'>&nbsp;currencies</legend>



      &nbsp;  <a href="admin_currencies.aspx">currencies</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

     </fieldset>

     <br />

     <fieldset>
      <legend>
       <img runat="server" src="~/icons/percent.gif" width='27' height='27' align='absmiddle'>&nbsp;taxes</legend>
      &nbsp;  <a href="admin_countries.aspx">countries/states</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

      &nbsp;  <a href="admin_taxprofiles.aspx">tax profiles</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_taxonsupplementarycost.aspx">tax on supplementary costs</a>

     </fieldset>


     <br>
     <fieldset>
      <legend>
       <img runat="server" src='~/icons/address_book2.gif' width='27' height='27' align='absmiddle'>&nbsp;catalog</legend>

      &nbsp;  <a href="admin_categorie.aspx">categories and subcategories</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_articoli.aspx">products</a>
     </fieldset>

     <br />

     <fieldset>
      <legend>
       <img runat="server" src='~/icons/shoppingcart_full.gif' width='27' height='27' align='absmiddle'>&nbsp;orders</legend>
      &nbsp;  <a href="admin_ordini.aspx">orders</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_parametri_ordini.aspx">orders parameters</a>

     </fieldset>
     <br />
     <fieldset>
      <legend>
       <img runat="server" src='~/icons/users4.gif' width='27' height='27' align='absmiddle'>&nbsp;registered users</legend>
      &nbsp;  <a href="admin_utenti.aspx">registered users</a>
     </fieldset>

    </td>
    <td width="16">&nbsp;</td>
    <td valign="top" width="492">


     <fieldset>
      <legend>
       <img runat="server" src="~/icons/percent.gif" width='27' height='27' align='absmiddle'>&nbsp;discounts
      </legend>
      &nbsp;  <a href="admin_listini_sconti.aspx">discounts on price lists</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_coupon.aspx">coupon discounts</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />


     </fieldset>
     <br />
     <fieldset>
      <legend>
       <img runat="server" src='~/icons/package.gif' width='27' height='27' align='absmiddle'>&nbsp;supplementary costs
      </legend>


      &nbsp;  <a href="admin_spedizione_sovrapprezzo.aspx">supplementary costs per modes of payment</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_spedizione_omaggio.aspx">free transport costs</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_spedizione_fisse.aspx">fixed transport costs</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_spedizione_zone.aspx">transport costs per area</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_spedizione_peso.aspx">transport costs per total weight of goods</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_spedizione_corriere.aspx">transport costs per carrier</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />

     </fieldset>


     <br />

     <fieldset>
      <legend>
       <img runat="server" src='~/icons/creditcards.gif' width='27' height='27' align='absmiddle'>&nbsp;credit card
      </legend>
      &nbsp; <a href="admin_cc.aspx">paypal configuration</a>
     </fieldset>

     <br>


     <fieldset>
      <legend>
       <img runat="server" src='~/icons/mail.gif' width='27' height='27' align='absmiddle'>newsletter
      </legend>


      &nbsp;  <a href="admin_newsletter.aspx">newsletter</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_iscrittinewsletter.aspx">registered users to newsletter</a>
     </fieldset>


     <br />


     <fieldset>
      <legend>
       <img runat="server" src='~/icons/documents.gif' width='27' height='27' align='absmiddle'>&nbsp;pages
      </legend>

      &nbsp;  <a href="admin_homepage.aspx">homepage</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_pagine.aspx?posizione=1">extra pages from menu bar</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_pagine.aspx?posizione=0">extra pages from info box</a>

     </fieldset>

     <br />


     <fieldset>

      <legend>
       <img runat="server" src='~/icons/pens.gif' width='27' height='27' align='absmiddle'>others
      </legend>

      &nbsp;  <a href="admin_banner.aspx?position=0">left banners</a>
      <br />
      &nbsp;  <a href="admin_banner.aspx?position=1">right banners</a>
      <br />
      &nbsp;  <a href="admin_news.aspx">news</a>
      <br />
      &nbsp;  <a href="admin_svuota.aspx">empty web site</a>
      <br />
      &nbsp;  <a href="admin_showlasterrors.aspx">show errors log</a>

     </fieldset>


     <br />

          <fieldset>

      <legend>
       backup/restore
      </legend>
      &nbsp;  <a href="admin_backup.aspx">backup (export data to xml)</a>
      <br />
      &nbsp;  <a href="admin_restore.aspx">restore</a>
      <br />
           
           </fieldset>
     <br>


     <fieldset>
      <legend>
       <img runat="server" src='~/icons/chart.gif' width='27' height='27' align='absmiddle'>&nbsp;stats (beta)
      </legend>

      &nbsp;  <a href="admin_statistiche.aspx">Last accesses</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_statistiche.aspx?view=visiteIp.aspx">Accesses by IP</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_statistiche.aspx?view=visiteAggr">Visits grouped by pages</a>
      <br />
      <img src="~/immagini/space.gif" height="3" runat="server" /><br />
      &nbsp;  <a href="admin_statistiche.aspx?view=referrer">Referrer</a>
     </fieldset>


     <br />
     <br />


    </td>
   </tr>
  </table>
 </form>

</asp:Content>


