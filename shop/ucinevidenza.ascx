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


<%@ Control Language="c#" Src="ucinevidenza.ascx.cs" Inherits="simplestecommerce.behindInEvidenza" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="simplestecommerce" %>

    
    <div align=center style="margin-top:9px;">


    




    <table  cellpadding=0 cellspacing=0 border=0 width="690">

    <tr>
        <td align=left>
            <span style="font-size:23px;  font-weight:bold; color:#0033CC">Prodotti in Evidenza</span>
        </td>
    </tr>

    <tr>
            <td width="100%" >
            <table width="100%" style="border:1px solid #ffffff" align=center cellpadding=4 cellspacing=0>
            <tr class="">
            <td>
                <asp:Repeater id="repArt" enableviewstate="false" runat="server" >
                    <ItemTemplate>
                        <tr class="" height=22 >
                            <td width=40 valign=middle>
                            <asp:image id="img" runat=server height=40 Width=40/>
                            </td>
                            <td width="12"></td>
                            <td valign=middle>
                                <a runat=server id="linkArt" style="font-size:12px;color:#0033CC">
                                <asp:label id="lblMarca" runat="server" enableviewstate="false" />
                                <b><asp:label id="lblNome" runat="server" enableviewstate="false" /></b>
                                &nbsp;<asp:label id="lblPredescr"  runat="server" enableviewstate="false" />
                                &nbsp;&nbsp;
                                <span class=small><asp:label id="lblPrezzo" runat="server" enableviewstate="false" /></span>
                                </a>
                       </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
              </td>
              </tr>
              </table>
            </td>

        </tr>

</table>

</div>