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


<%@ Control Language="c#" Inherits="simplestecommerce.behindOffertaAscx" Src="ucofferta.ascx.cs" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="simplestecommerce" %>






       


       
       
       <table cellspacing="0" cellpadding="0" width="100%" class="tablefeatured" >
       <tr >
       <td class="box" width="100%"><%=simplestecommerce.lingua.getforfrontendbypseudo("homepage.boxfeatured.boxtitle") %></td>
       </tr>
       <tr >
        <td >

       


                
                <asp:DataList   
                 RepeatDirection="Horizontal" 
                 id="dataListArt"  
                 enableviewstate="false" 
                 cellspacing=0 
                 CellPadding="0" 
                 runat="server" 
                 width="100%"
                 >
                    <ItemStyle ></ItemStyle>
                    <FooterStyle ></FooterStyle>
                    <HeaderStyle ></HeaderStyle>
                    <ItemTemplate>
                        <asp:placeholder id="pHolderArt" runat=server>
                        
                        <table width="100%" border=0 cellpadding=0 cellspacing=0  >
                        <tr height="107">
                        <td  width="0" >&nbsp;</td>
                        
                        <td width="60" align=center valign="middle">
                            <a id="linkImage" runat="server" enableviewstate="false" ><asp:Image width="45" BorderWidth=1  BorderStyle=dotted bordercolor="#4B7795" id="imgArt" runat="server" enableviewstate="false" style="margin-left:0px" /></a>
                                                        
                        </td>
                        <td width="200" valign=middle align=left >

                            <asp:Hyperlink cssclass="artnameinlist" id="hLinkArt" runat="server" enableviewstate="false" /><br />
                            <span style="font-size:14px;font-weight:bold;color:#FF8000"><asp:label id="lblPrezzoArticolo" runat=server /></span>&nbsp;<asp:Label ID="lblSconto" runat=server  />
                          
                            
                         </td>
                        <td runat=server id="td1" width="10" style="" />
                        </tr>
                        
                        </table>
                        
                        </asp:placeholder>
                    </ItemTemplate>
                </asp:DataList>


       </td>
       </tr>


       

       </table>


        
    


