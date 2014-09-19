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

<%@ Page Language="C#" CodeFile="articoli.aspx.cs" Inherits="simplestecommerce.behindArticoliAspx" MasterPageFile="~/shop/masterpage.master" %>

<%@ Register TagPrefix="simplestecommerce" TagName="categorie" Src="uccategorie.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="mailing" Src="ucmailing.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="offerta" Src="ucofferta.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="search" Src="ucsearch.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="keywords" Src="uckeywords.ascx" %>

<%@ Register TagPrefix="simplestecommerce" TagName="paypal" Src="paypal.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="pagine" Src="ucpagine.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="incarrello" Src="ucincarrello.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="formaccount" Src="ucformaccount.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="giavisti" Src="ucgiavisti.ascx" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>

<asp:Content runat="server" ContentPlaceHolderID="headerpart">
</asp:Content>


<asp:Content runat="server" ContentPlaceHolderID="parteCentrale" >

       <asp:UpdatePanel ID="PannelloDinamico" runat="server">
       <ContentTemplate>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1">
         <ProgressTemplate>
          <ajaxToolkit:AlwaysVisibleControlExtender
           ID="AlwaysVisibleControlExtender1"
           runat="server"
           TargetControlID="panelprogress"
           VerticalSide="Middle"
           HorizontalSide="Center">
          </ajaxToolkit:AlwaysVisibleControlExtender>
          <asp:Panel ID="panelprogress" runat="server">
           <img src="~/immagini/loading.gif" width="30" runat="server" />
          </asp:Panel>
         </ProgressTemplate>
        </asp:UpdateProgress>




 <asp:Label ID="lblMessaggio" runat="server"></asp:Label>
 <asp:PlaceHolder ID="placeHolderArticolo" runat="server">
 <table cellspacing="0" cellpadding="0" width="100%"  >
  <tr>
   <td class="box" width="100%">
    <asp:label runat=server id="lblNomeArtBig" />
   </td>
  </tr>
  </table>
  <table cellspacing="0" cellpadding="2" width="100%" border="0" style="margin-top: 6px" id="tableproduct">

   <tr>
    <td align="center" width="220">
     <br />

     <asp:Image ID="imgArticoloPreview" runat="server" BorderColor="silver" BorderStyle="solid" BorderWidth="0" Width="200" />
     <br />




    </td>
    <td width="30">&nbsp;</td>
    <td valign="middle" width="400" style="text-align:left">

     <div><br /></div>

     <table id="tableproductdetail">

      <tr>
       <td>
        <%=(lingua.getforfrontendbypseudo("article.artcode"))%>
       </td>
       <td>
        <asp:Label ID="lblCodArticolo" runat="server"></asp:Label></td>
      </tr>
      <asp:PlaceHolder runat="server" ID="PHOLDERusato" Visible="false">
       <tr>
        <td>
         <b><%=(lingua.getforfrontendbypseudo("article.used"))%></b>
        </td>
        <td>
         <b><%=simplestecommerce.lingua.getforfrontendbypseudo("article.used.yes") %></b>
        </td>
       </tr>
      </asp:PlaceHolder>


      <tr>
       <td>
        <%=(lingua.getforfrontendbypseudo("article.brand"))%>
       </td>
       <td>
        <asp:Label ID="lblMarcaArticolo" runat="server"></asp:Label></td>
      </tr>
      <tr>
       <td>
        <%=(lingua.getforfrontendbypseudo("article.availability"))%>
       </td>
       <td>
        <b>
         <asp:Label ID="lblDispArticolo" runat="server"></asp:Label></b></td>
      </tr>

      <asp:Repeater runat="server" ID="listvariations" OnItemDataBound="listvariations_databound">
       <ItemTemplate>
        <tr>
         <td>
          <asp:HiddenField ID="hiddenidvar" runat="server" />
          <asp:Label runat="server" ID="lblnomevar" CssClass="input" />
         </td>
         <td>
          <asp:DropDownList AutoPostBack="true" ID="dlistoptions" runat="server" CssClass="input" myvarid='<%#Eval("id").ToString() %>' />
         </td>
        </tr>
       </ItemTemplate>
      </asp:Repeater>







      <asp:PlaceHolder ID="placeHolderAddToCart" runat="server">
       <tr>
        <td>
         <%=lingua.getforfrontendbypseudo("article.quantitytobeaddedtocart") %>
        </td>
        <td nowrap>
         <asp:TextBox ID="tBoxQuantita" runat="server" size="1" value="1" name="quantitaArt" Width="25" Style="height: 14px"></asp:TextBox>&nbsp;<asp:Button ID="btnInvia" CssClass="pulsante" runat="server" OnClick="buttAdd_click" />
        </td>
       </tr>
      </asp:PlaceHolder>

      <tr>
       <td class="price" colspan="2" nowrap>
        <%=simplestecommerce.lingua.getforfrontendbypseudo("article.price") %>
                            &nbsp;<asp:Label ID="lblPrezzoArticolo" runat="server" />
       </td>
      </tr>



      <asp:PlaceHolder ID="pHolderScQuant" runat="server" Visible="false">
       <tr>
        <td colspan="2">
         <fieldset>
          <legend><%=lingua.getforfrontendbypseudo("article.quantity.discount")%></legend>



          <table style="margin: 5px;" cellpadding="3" cellspacing="1">
           <asp:Repeater ID="repScQuant" runat="server">
            <ItemTemplate>
             <tr>
              <td width="10">&nbsp;</td>
              <td width="150"><%=(simplestecommerce.lingua.getforfrontendbypseudo("article.quantity.discount.starting.from"))%>&nbsp;
               <asp:Label ID="lblStartScQuant" runat="server" />
               <%=(simplestecommerce.lingua.getforfrontendbypseudo("article.quantity.discount.starting.from.units"))%></td>
              <td width="10">&nbsp;</td>
              <td align="right" nowrap><%=(simplestecommerce.lingua.getforfrontendbypseudo("article.quantity.discount.unit.price"))%>
                                                        &nbsp;<asp:Label ID="lblPrezzoScQuant" runat="server" /></td>
              <td width="10">&nbsp;</td>
             </tr>
            </ItemTemplate>
           </asp:Repeater>
          </table>
         </fieldset>
        </td>
       </tr>
      </asp:PlaceHolder>



     </table>
    </td>
   </tr>
  </table>
  <br />


  <div align="left">

   <asp:placeholder runat="server" ID="pholderotherphoto" Visible="false">
   <fieldset>
    <legend><%=lingua.getforfrontendbypseudo("article.other.photos")%></legend>

        <asp:Repeater runat="server" ID="listaZoom" Visible="true" EnableViewState="true" ViewStateMode="Enabled">
         <ItemTemplate>
          <a runat="server" data-lightbox="roadtrip" href='<%#Eval("z_percorso") %>' title='<%#nomeartcurrentfrontendlanguage %>'>
           <asp:Image
            Visible='<%#Eval("z_percorso").ToString()!="" %>'
            ImageUrl='<%#Eval("z_percorso") %>'
            ID="zoom"
            runat="server"
            Height="45"
            Width="45"
            BorderColor="silver"
            BorderStyle="solid"
            BorderWidth="1" />
          </a>
         </ItemTemplate>
        </asp:Repeater>
   </fieldset>
   </asp:placeholder>


   <asp:Repeater runat="server" ID="listsamples" OnItemDataBound="listsamples_databound">


    <ItemTemplate>
     <asp:Literal runat="server" ID="lblsamples" />
    </ItemTemplate>

   </asp:Repeater>




  </div>

  <br />
  <table cellspacing="1" width="100%" align="center">

   <tr>
    <td colspan="2" style="text-align:left">


     <ajaxToolkit:TabContainer ID="TabContainer1" runat="server" Width="100%">
      <ajaxToolkit:TabPanel ID="TabPanel1" runat="server">
       <HeaderTemplate>
        <%=lingua.getforfrontendbypseudo ("article.description") %>
       </HeaderTemplate>
       <ContentTemplate>
        <asp:Label ID="lblDescrizioneArticolo" runat="server" />
       </ContentTemplate>
      </ajaxToolkit:TabPanel>
      <ajaxToolkit:TabPanel ID="TabPanel2" runat="server">
       <HeaderTemplate>
        <%=lingua.getforfrontendbypseudo ("article.technical.specifications") %>
       </HeaderTemplate>
       <ContentTemplate>
        <asp:Label ID="lblCaratteristiche" runat="server" />
       </ContentTemplate>
      </ajaxToolkit:TabPanel>



     </ajaxToolkit:TabContainer>







    </td>
   </tr>
  </table>

 </asp:PlaceHolder>





 <asp:PlaceHolder runat="server" ID="pholderrelatedproducts" Visible="false">

 <table cellspacing="0" cellpadding="0" width="100%"  style="margin-top:12px">
  <tr>
   <td class="box" width="100%">
    <div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("article.related.products") %></div>
   </td>
  </tr>
  <tr>
   <td class="containertondosotto"></td>
  </tr>
  <tr>
   <td style="font-size: 0px; height: 2px">&nbsp;</td>
   <tr>
    <td class="tdrelatedproduct">
     <asp:DataList runat="server" ID="listrelatedproucts" RepeatDirection="Horizontal" RepeatColumns="3">
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

 

 <div>
  <br />
  <br />
 </div>
 <simplestecommerce:giavisti runat="server" />

  </contenttemplate>
</asp:UpdatePanel>
</asp:Content>



