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


<%@ Control Language="c#" Inherits="simplestecommerce.behindUsatoAscx" Src="ucusato.ascx.cs" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="simplestecommerce" %>












<table cellspacing="0" cellpadding="0" width="100%" id="tablefeatured">
 <tr>
  <td class="box" width="100%">
   <div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("homepage.boxusedproducts.boxtitle") %></div>
  </td>
 </tr>
 <tr>
  <td class="containertondosotto"></td>
 </tr>


 <tr>
  <td id="tdfeatured">



   <asp:DataList RepeatDirection="Horizontal" ID="dataListArt" EnableViewState="false" CellSpacing="0" CellPadding="0" runat="server" Width="100%">
    <ItemStyle></ItemStyle>
    <FooterStyle></FooterStyle>
    <HeaderStyle></HeaderStyle>
    <ItemTemplate>
     <asp:PlaceHolder ID="pHolderArt" runat="server">

      <table width="100%" border="0" cellpadding="0" cellspacing="0">
       <tr height="107">
        <td id="td0" width="0" runat="server">&nbsp;</td>

        <td width="60" id="td2" runat="server" align="center" valign="middle">
         <a id="linkImage" runat="server" enableviewstate="false">
          <asp:Image Width="45" BorderWidth="1" BorderStyle="dotted" BorderColor="#4B7795" ID="imgArt" runat="server" EnableViewState="false" Style="margin-left: 0px" /></a>

        </td>
        <td id="td3" runat="server" width="200" valign="middle" align="left">

         <asp:HyperLink cssclass="artnameinlist" ID="hLinkArt" runat="server" EnableViewState="false" /><br />
         <span style="font-size: 14px; font-weight: bold; color: #FF8000">
          <asp:Label ID="lblPrezzoArticolo" runat="server" />
         </span>
                            
        </td>
        <td runat="server" id="td1" width="10" style="" />
       </tr>

      </table>

     </asp:PlaceHolder>
    </ItemTemplate>
   </asp:DataList>


  </td>
 </tr>




</table>






