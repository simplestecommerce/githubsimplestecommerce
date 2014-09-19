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


<%@ Page  Trace="false" Language="C#" MasterPageFile="~/shop/masterpage.master" CodeFile="~/shop/default.aspx.cs" Inherits="simplestecommerce.behindDefaultAspx"

%>
<%@ MasterType  virtualPath="~/shop/masterpage.master"%>
<%@ Register TagPrefix="simplestecommerce" TagName="offerta" Src="ucofferta.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="usato" Src="ucusato.ascx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">



       <table cellspacing="0" cellpadding="0" width="100%" class="box" >
       <tr >
       <td class="box" style="width:100%"><div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("homepage.welcomebox.boxtitle") %></div></td>
       </tr>


        <tr >
        <td >
          <%=simplestecommerce.lingua.getforfrontendfromdb(simplestecommerce.config.getCampoByApplication("config_welcometext").ToString()) %>
       </td>
         </tr>
        </table>


<simplestecommerce:offerta id="ucOfferta" runat="server" />
<simplestecommerce:usato id="ucUsato" runat="server" />

 <br />
 <br />

    


</asp:Content>

