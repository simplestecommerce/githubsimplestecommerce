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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" CodeFile="login.aspx.cs" Inherits="behindLoginAspx" ValidateRequest="true" %>

<%@ MasterType VirtualPath="~/shop/masterpage.master" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>

<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server" EnableViewState="true" ViewStateMode="Enabled">

 <asp:Panel ID="Panel1" DefaultButton="buttAccedi" runat="server">



  <table cellspacing="0" cellpadding="0" width="100%" style="text-align:left">
   <tr>
    <td class="box" width="100%">
     <div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("login.title") %></div>
    </td>
   </tr>
  </table>

  <table cellspacing="1" cellpadding="2" width="100%" border="0"  style="margin-top:2px; text-align:left"">

   <tr class="filled">
    <td width="60%">&nbsp;<%=simplestecommerce.lingua.getforfrontendbypseudo("login.field.email") %>
    </td>
    <td width="40%">
     <asp:TextBox ID="textBoxEmail" class="inputlargo" runat="server" />
    </td>
   </tr>


   <tr class="filled">
    <td width="60%">&nbsp;<%=simplestecommerce.lingua.getforfrontendbypseudo("login.field.password") %>
    </td>
    <td width="40%">
     <asp:TextBox ID="textBoxPass" TextMode="Password" class="inputlargo" size="35" runat="server" />
    </td>
   </tr>





  </table>
  <br>
  <div align="center">
   <asp:Button class="input" Text="LOGIN" ID="buttAccedi" runat="server" OnClick="buttAccedi_click" />
  </div>

  <div align="center">
   <br />
   <asp:Label runat="server" ID="lblEsito" ForeColor="Red" Font-Size="Larger" /><br />
   <a href="~/shop/password.aspx" style="text-decoration:underline" runat="server"><%=simplestecommerce.lingua.getforfrontendbypseudo("login.link.forgot.password") %></a>
   </div>

 </asp:Panel>



</asp:Content>
