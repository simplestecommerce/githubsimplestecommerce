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


<%@ Control Language="c#" Inherits="simplestecommerce.behindRepartiAscx" codefile="ucreparti.ascx.cs" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="simplestecommerce" %>






       


<table  cellpadding="0" cellspacing="0" border="0" width="100%">
 <tr>
    <td align="center" width="100%">

                   <asp:DataList  RepeatColumns="7" RepeatDirection="horizontal" id="listaCat"  enableviewstate="false" cellspacing=0 CellPadding="0" runat="server" width="100%" BorderStyle="Solid" BorderColor="Red" BorderWidth="0">
                    <ItemStyle ></ItemStyle>
                    <FooterStyle ></FooterStyle>
                    <HeaderStyle ></HeaderStyle>
                    <ItemTemplate>

                     <table border="0" style="width:100%; border: solid 0px #ffffff; background-color:#333333; margin-top:1px;">
                      <tr height="60">

                       <td width="100%" align="center">
                        <a id="linkImage" runat="server" enableviewstate="false"><asp:Image Width="88" Height="54" BorderWidth="1" BorderStyle="solid" BorderColor="#cccccc" ID="imgCat" runat="server" EnableViewState="false" /></a></td>

                      </tr>
                      <tr><td align="center"><div style="margin-bottom: 4px">
                         <asp:HyperLink ID="linkCat" runat="server" Style="color: #ffffff; font-size: 10px; font-weight:normal"  Font-Underline="false" />
                         </div></td></tr>
                     </table>

                    </ItemTemplate>
                    <SeparatorTemplate><img src="~/immagini/space.gif" width="1" height="0" /></SeparatorTemplate>
                </asp:DataList>



  </td>
 </tr>

</table>       
      
       


                

      
        
    


