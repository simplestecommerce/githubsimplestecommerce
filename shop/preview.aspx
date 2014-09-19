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


<%@ Page Language="C#" MasterPageFile="masterpage.master" Inherits="simplestecommerce.behindPreviewAspx" CodeFile="preview.aspx.cs"
%>
<%@ Register TagPrefix="simplestecommerce" TagName="giavisti" Src="ucgiavisti.ascx" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>








<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">

      



  <asp:Panel ID="panelSottocategorie" runat="server" Visible="false"  >


       <table cellspacing="0" cellpadding="0" width="100%" id="tablecontainersottocat" >
       <tr >
       <td class="box" width="100%"><div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("preview.subcategoriesbox.boxtitle") %></div></td>
       </tr>
       <tr ><td class="containertondosotto"></td></tr>


        <tr >
        <td id="tdfeatured">

        <tr><td style="font-size:0px; height:2px; background-color:#fff">&nbsp;</td></tr>




            <asp:Repeater ID="dataListSottocat" runat="server" >
                <ItemTemplate>
                    <tr>
                        <td>
                            <table class="tablesottocat">
                                                          <tr><td colspan=2 height="2" style="font-size:0px">&nbsp;</td></tr>
                                <tr>

                                    <td valign="middle" width="110">
                                        <a runat="server" id="ancorImg">
                                            <asp:Image align="left" BorderColor="#bbbbbb" BorderStyle="dotted" BorderWidth="1" runat="server" ID="imgArt" /></a>
                                    </td>

                                    <td valign="middle" style="text-align:left">

                                        <asp:HyperLink Style="font-size: 14px; font-weight: bold;" ID="linkNomeSottocat" runat="server" />

                                    </td>
                                </tr>
                                                          <tr><td colspan=2 height="2" style="font-size:0px">&nbsp;</td></tr>

                            </table>

                        </td>
                    </tr>


                </ItemTemplate>
                <SeparatorTemplate>
                    <tr><td style="font-size:0px; height:1px; background-color:#fff">&nbsp;</td></tr>
                </SeparatorTemplate>
            </asp:Repeater>

            


        </table>
      </asp:Panel>
        


        <asp:Panel ID="panelArticoli"  runat="server" visible="true">


            <table cellspacing="0" cellpadding="0" width="100%" id="tableprodincat">
                <tr>
                    <td class="box" width="100%">
                     <table>
                      <tr>
                       <td>
                        <div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("preview.productsbox.boxtitle")%></div>
                       </td>
                       <td>&nbsp;</td>
                       <td align="right">



                <asp:PlaceHolder runat="server"  ID="pHolderFiltri" EnableViewState="true" ViewStateMode="Enabled">
                    
                        <asp:DropDownList runat="server" ID="dlistmarca" CssClass="input" AutoPostBack="true"  />
                            &nbsp;&nbsp;
                <asp:DropDownList class="input" ID="dlistord" runat="server" AutoPostBack="true" />&nbsp;          
                </asp:PlaceHolder>

                       </td>
                      </tr>
                     </table>
                        
                    </td>
                </tr>
                <tr>
                    <td class="containertondosotto" ></td>
                </tr>

                <tr>
                    <td style="font-size: 0px; height: 2px">&nbsp;</td>
                </tr>


                <tr>
                    <td style="font-size: 0px; height: 1px">&nbsp;</td>
                </tr>

             <tr><td><div runat="server" id="divnoarticles" style="text-align:left"><%=simplestecommerce.lingua.getforfrontendbypseudo("preview.productsbox.label.no.articles.in.this.category") %></div>
             </td></tr>

             <tr><td valign="middle">
                  <asp:listview ID="listaarticoli" runat="server"  OnItemDataBound="listaarticoli_databound"
      OnPagePropertiesChanging="listaarticoli_PagePropertiesChanging"
                   >
                    <ItemTemplate>

                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                 <tr>
                                     
                                     <td colspan="4" align="center" height="2">
                                            &nbsp;
                                        </td>
                                    </tr>

                                    <tr >
                                        <td width="110" align="left" valign="middle">
                                            <div style="padding: 4px">
                                                <a id="linkartimg" runat="server">
                                                    <asp:Image BorderColor="#4B7795" BorderStyle="dotted" BorderWidth="1" ID="articoloImgPreview" runat="server" />
                                                </a>
                                            </div>
                                        </td>

                                        <td width="2" align="center"></td>

                                        <td width="300" align="left" valign="middle">
                                            <b><asp:hyperlink ID="linkartname" runat="server"  style="font-size:16px"/></b>
                                         
                                            <br>
                                            <%Response.Write (lingua.getforfrontendbypseudo("preview.products.label.brand"));%>:
                                    <asp:Label  ID="lblMarca" runat="server" />
                                            <br>

                                            <%Response.Write (lingua.getforfrontendbypseudo("preview.products.label.availability"));%>:
                                                <b><asp:Label ID="lblDisp" runat="server" /></b>
                                         </td>
                                     <td>
                                    <span style="font-size:14px;font-weight:bold;color:#FF8000"><asp:label id="lblPrezzoArticolo" runat=server />
                                     <asp:Label ID="lblPrezzo" runat="server" />
                                     </span>
                                      <br />
                                            <asp:TextBox EnableViewState="true" ViewStateMode="Enabled" Text="1" runat="server" ID="tBoxQuantita" Style=" text-align:right; width: 28px" /><asp:Button EnableViewState="true" ViewStateMode="Enabled" runat="server" ID="buttAdd" Text='<%#lingua.getforfrontendbypseudo("preview.products.button.add.to.cart")%>' CssClass="pulsante" OnCommand="add" />
                                            <asp:Label EnableViewState="true" ViewStateMode="Enabled" ID="lblErrCart" runat="server" ForeColor="Red" Font-Bold="true" />
                                        
                                        </td>
                                    </tr>

                                </table>
                    </ItemTemplate>


                </asp:listview>
             </td></tr>
             
                <tr>
                    <td style="font-size: 0px; height: 1px; background-color: #fff"></td>
                </tr>
                <tr>
                    <td class="paging">
 <asp:DataPager ID="datapager" runat="server" PagedControlID="listaarticoli" >
            <Fields>
                <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="paging"  />
            </Fields>
        </asp:DataPager>

                    </td>
                </tr>

            </table>





        </asp:Panel>


        <simplestecommerce:giavisti runat="server" />
</asp:Content>
