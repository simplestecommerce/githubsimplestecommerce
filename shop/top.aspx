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


<%@ Page Language="C#" Inherits="simplestecommerce.behindTop" Src="top.aspx.cs" MasterPageFile="~/shop/masterpage.master" %>

<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">


 <table cellspacing="0" cellpadding="0" width="100%">
  <tr>
   <td class="box" width="100%">
    <div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("bestseller.title") %></div>
   </td>
  </tr>
  <tr>
   <td class="containertondosotto"></td>
  </tr>
  <tr>
   <td style="height: 1px; background-color: #fff"></td>
  </tr>

  <tr>
   <td width="100%">

    <table width="100%">


     <asp:Repeater ID="listaart"
      EnableViewState="false"
      runat="server"
>
      <ItemTemplate>

       <tr height="107">

        <td width="60" align="center" valign="middle">
         <a id="linkImage" runat="server" enableviewstate="false">
          <asp:Image Width="45" BorderWidth="1" BorderStyle="dotted" BorderColor="#4B7795" ID="imgArt" runat="server" EnableViewState="false" Style="margin-left: 0px" /></a>

        </td>
        <td>&nbsp;&nbsp;</td>
        <td valign="middle" align="left">

         <asp:HyperLink CssClass="artnameinlist" ID="hLinkArt" runat="server" EnableViewState="false" /><br />
         <span style="font-size: 14px; font-weight: bold; color: #FF8000">
          <asp:Label ID="lblPrezzoArticolo" runat="server" /></span>&nbsp;<asp:Label ID="lblSconto" runat="server" />


        </td>
       </tr>
       <tr>
        <td colspan="3">
         <div align="center" style="text-align: center; width: 100%; border-bottom: dotted 1px #bbbbbb">&nbsp;</div>
        </td>
       </tr>

      </ItemTemplate>
     </asp:Repeater>


    </table>
   </td>
  </tr>
 </table>
</asp:Content>
