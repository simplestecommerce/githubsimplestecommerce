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


<%@ Control Language="c#" EnableViewState="false" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">


 void binding(object sender, DataListItemEventArgs e)
 {


  
  
  if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
  {
   simplestecommerce.articolo articolo = (simplestecommerce.articolo)e.Item.DataItem;
   
   ((HyperLink)e.Item.FindControl("hLinkArt")).Text = simplestecommerce.lingua.getforfrontendfromdb( articolo.Name);
   ((HyperLink)e.Item.FindControl("hLinkArt")).NavigateUrl = articolo.Linkart;

   ((HtmlAnchor)e.Item.FindControl("linkImage")).HRef = articolo.Linkart;


   Image img = (Image)e.Item.FindControl("imgArt");

   if (articolo.Preview == "")
    img.ImageUrl = "~/immagini/non_disponibile.gif";
   else img.ImageUrl = articolo.Preview;

   img.ToolTip = simplestecommerce.lingua.getforfrontendfromdb(articolo.Name);

   Label lblPrezzoArticolo = ((Label)e.Item.FindControl("lblPrezzoArticolo"));




   if (articolo.Prezzobase == articolo.Prezzodoposcontoprodottoutentelistino)
   {
    // non c'è sconto
    lblPrezzoArticolo.Text = currencies.tostrusercurrency(articolo.Prezzobase);

   }
   else
   {
    //c'è sconto
    lblPrezzoArticolo.Text = "<strike>"
    + currencies.tostrusercurrency(articolo.Prezzobase).Replace(" ", "&nbsp;")
    + "</strike>" +
    "<br><font color=red><b>"
    + currencies.tostrusercurrency(articolo.Prezzodoposcontoprodottoutentelistino) +
    "</b></font>";
   }


  }

 }


 void Page_Load()
 {



  List<articolo> coda = (List<articolo>)Session["coda"];

  if (coda.Count > 0)
  {

   pHolder.Visible = true;
   List<articolo> codaOrdinata = new List<articolo>();
   // ordine inverso
   for (int rip = coda.Count - 1; rip >= 0; rip--)
   {

    codaOrdinata.Add(coda[rip]);

   }

   lista.DataSource = codaOrdinata;
   lista.DataBind();
  }
 }

</script>
<asp:PlaceHolder runat="server" ID="pHolder" Visible="false">

 <table cellspacing="0" cellpadding="0" width="100%" id="tableseenproduct">
  <tr>
   <td class="box" width="100%">
    <div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("box.products.you.have.seen.boxtitle") %></div>
   </td>
  </tr>
  <tr>
   <td class="containertondosotto"></td>
  </tr>
  <tr>
   <td style="font-size: 0px; height: 2px">&nbsp;</td>
   <tr>
    <td class="tdseenproduct">




     <asp:DataList runat="server" ID="lista" OnItemDataBound="binding" RepeatDirection="Horizontal" RepeatColumns="3" >
      <ItemTemplate>
                        <table width="100%" border=0 cellpadding=0 cellspacing=0  >
                        <tr height="107">
                        <td  width="0" runat=server>&nbsp;</td>
                        
                        <td width="60" runat=server align=center valign="middle">
                            <a id="linkImage" runat="server" enableviewstate="false" ><asp:Image width="45" BorderWidth=1  BorderStyle=dotted bordercolor="#4B7795" id="imgArt" runat="server" enableviewstate="false" style="margin-left:0px" /></a>
                                                        
                        </td>
                        <td runat=server width="200" valign=middle align=left >

                            <asp:Hyperlink cssclass="artnameinlist" id="hLinkArt" runat="server" enableviewstate="false" /><br />
                            <span style="font-size:14px;font-weight:bold;color:#FF8000"><asp:label id="lblPrezzoArticolo" runat=server /></span>&nbsp;<asp:Label ID="lblSconto" runat=server  />
                          
                            
                         </td>
                        <td runat=server id="td1" width="10" style="" />
                        </tr>
                        
                        </table>
      </ItemTemplate>
      <SeparatorTemplate>
       <img src="~/immagini/space.gif" width="50" height="1" />
      </SeparatorTemplate>
     </asp:DataList>


    </td>
   </tr>
  </table>
</asp:PlaceHolder>
