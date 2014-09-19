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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" ValidateRequest="true" CodeFile="cartcollect.aspx.cs"
 Inherits="simplestecommerce.behindCartcollectAspx" %>

<%@ Register TagPrefix="simplestecommerce" TagName="cart" Src="uccart.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="incarrello" Src="ucincarrello.ascx" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<%@ MasterType VirtualPath="~/shop/masterpage.master" %>
<asp:Content runat="server" ContentPlaceHolderID="headerpart">

 <script>


 </script>

</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="parteCentrale" EnableViewState="true" ViewStateMode="Enabled">


 <!--
               <asp:UpdatePanel ID="UpdatePanel1"  runat="server"  >
                <ContentTemplate>-->
 <asp:PlaceHolder runat="server" ID="pHolderVuoiRegistrati" Visible="false" >
  <div style="text-align:left" >
   <span class="big"><%=simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.label.purchas.without.registration")%></span>
  <br />
  <%=simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.label.if.prefer.registration")%>&nbsp;<a href='registrazione.aspx'><%=simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.label.if.prefer.registration.link.to.registration.page") %></a>
   <br />
  </div>
 </asp:PlaceHolder>

 <table cellspacing="1" cellpadding="3" width="100%" border="0" class="modulo" style="text-align:left">

  <tr>
   <td class="filledbolddark" colspan="2" align="left">
    <span class="titoletto">&nbsp;<b><%=lingua.getforfrontendbypseudo("cartcollect.label.data.collect")%></b></span>
   </td>
  </tr>

  <tr>
   <td class="filled" colspan="2" align="left">
    <b><%=(lingua.getforfrontendbypseudo("cartcollect.label.billing.data"))%>:</b>
   </td>
  </tr>
  <tr>
   <td width="38%" class="filled"><%=lingua.getforfrontendbypseudo("cartcollect.field.legal.subject")%>
   </td>
   <td width="62%" class="filled">
    <asp:RadioButtonList ID="dlistsubject" runat="server" CssClass="inputlargo" AutoPostBack="true" OnSelectedIndexChanged="changed_subject" />
   </td>
  </tr>

  <asp:PlaceHolder runat="server" ID="pholdernameoffirm" Visible="false">
   <tr>
    <td class="filled" width="38%"><%=(lingua.getforfrontendbypseudo("cartcollect.field.name.of.firm"))%>
          <asp:Label EnableViewState="false" ID="lblerrnameoffirm" ForeColor="Red" runat="server" />

    </td>
    <td class="filled" width="62%">

     <asp:TextBox ID="tboxnameoffirm" class="inputlargo" size="35" runat="server" />

    </td>
   </tr>
  </asp:PlaceHolder>


  <asp:PlaceHolder runat="server" ID="pholderfistnamesecondname">
   <tr>
    <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.first.name"))%>
     <asp:Label EnableViewState="false" ID="lblerrfirstname" ForeColor="Red" runat="server" />

    </td>
    <td class="filled">
     <asp:TextBox ID="tboxfirstname" ClientIDMode="Static" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxspfirstname').value=this.value" />
    </td>
   </tr>


   <tr>
    <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.second.name"))%>
     <asp:Label EnableViewState="false" ID="lblerrsecondname" ForeColor="Red" runat="server" />

    </td>
    <td class="filled">
     <asp:TextBox ClientIDMode="Static" ID="tboxsecondname" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxspsecondname').value=this.value" />
    </td>
   </tr>

  </asp:PlaceHolder>


  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.address"))%>
    <asp:Label EnableViewState="false" ID="lblerraddress" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ClientIDMode="Static" ID="tboxaddress" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxspaddress').value=this.value" />


   </td>
  </tr>


  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.postal.code"))%>
    <asp:Label EnableViewState="false" ID="lblerrpostalcode" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ClientIDMode="Static" ID="tboxpostalcode" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxsppostalcode').value=this.value" />

   </td>
  </tr>



  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.city"))%>
    <asp:Label EnableViewState="false" ID="lblerrcity" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <div>
     <asp:TextBox ClientIDMode="Static" ID="tboxcity" class="inputlargo" runat="server" onkeyup="document.getElementById('tboxspcity').value=this.value" />
    </div>

   </td>
  </tr>



  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.country"))%>
   </td>
   <td class="filled">
    <asp:DropDownList ID="dlistregion" class="inputlargo" runat="server" OnSelectedIndexChanged="region_changed" AutoPostBack="true" />

   </td>
  </tr>


  <tr>
   <td class="filled"><%=lingua.getforfrontendbypseudo("cartcollect.field.email") %>
            <asp:Label ID="lblerremail" runat="server" EnableViewState="false" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxemail" class="inputlargo" size="35" runat="server" />

   </td>
  </tr>


  <asp:PlaceHolder runat="server" ID="pholdertelephone" Visible="false">

   <tr>
    <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.telephone"))%>
     <asp:Label ID="lblerrtelephone" runat="server" EnableViewState="false" ForeColor="Red" />
    </td>
    <td class="filled">

     <asp:TextBox ID="tboxtelephone" class="inputlargo" runat="server" />

    </td>
   </tr>
  </asp:PlaceHolder>

  <asp:PlaceHolder runat="server" ID="pholderfiscalcode" Visible="false">

   <tr>
    <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.fiscal.code"))%>
     <asp:Label ID="lblerrfiscalcode" class="input" runat="server" ForeColor="red" EnableViewState="false" />
    </td>
    <td class="filled">
     <asp:TextBox ID="tboxfiscalcode" class="inputlargo" size="35" runat="server" />

    </td>
   </tr>
  </asp:PlaceHolder>


  <asp:PlaceHolder runat="server" ID="pholdervatnumber" Visible="false">

   <tr>
    <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.vat.number"))%>
     <asp:Label ID="lblerrvatnumber" class="input" runat="server" ForeColor="red" EnableViewState="false" />
    </td>
    <td class="filled">
     <asp:TextBox ID="tboxvatnumber" class="inputlargo" size="35" runat="server" />

    </td>
   </tr>
  </asp:PlaceHolder>
















  <!-- shipping data -->

  <tr class="filledbold">
   <td colspan="2"><b><%=(lingua.getforfrontendbypseudo("cartcollect.label.shipping.data"))%></b></td>
  </tr>

  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.shipping.field.first.name"))%>
    <asp:Label EnableViewState="false" ID="lblerrspfirstname" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxspfirstname" class="inputlargo" runat="server" ClientIDMode="Static" />
   </td>
  </tr>

  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.shipping.field.second.name"))%>
    <asp:Label EnableViewState="false" ID="lblerrspsecondname" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxspsecondname" class="inputlargo" runat="server" ClientIDMode="Static" />
   </td>
  </tr>


  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.shipping.field.address"))%>
    <asp:Label EnableViewState="false" ID="lblerrspaddress" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxspaddress" class="inputlargo" size="35" runat="server" ClientIDMode="Static" />
   </td>
  </tr>



  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.shipping.field.postal.code"))%>
    <asp:Label EnableViewState="false" ID="lblerrsppostalcode" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxsppostalcode" class="inputlargo" runat="server" ClientIDMode="Static" />
   </td>
  </tr>



  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.shipping.field.city"))%>
    <asp:Label EnableViewState="false" ID="lblerrspcity" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxspcity" class="inputlargo" runat="server" ClientIDMode="Static" />
   </td>
  </tr>



  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.shipping.field.country"))%>
   </td>
   <td class="filled">
    <asp:DropDownList ClientIDMode="Static" ID="dlistspregion" class="inputlargo" runat="server"  Enabled="false"/>
   </td>
  </tr>

  <!-- end shippin data -->

  <tr class="filledbold">
   <td colspan="2"><b><%=(lingua.getforfrontendbypseudo("cartcollect.label.carrier.and.method.of.payment"))%></b></td>
  </tr>



  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.carrier"))%>
   </td>
   <td class="filled">
    <asp:DropDownList ID="dlistcarrier" runat="server" CssClass="inputlargo" />

   </td>
  </tr>




  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.method.of.payment"))%>:
   </td>
   <td class="filled">
    <asp:DropDownList ID="dlistmodeofpayment" runat="server" CssClass="inputlargo">
    </asp:DropDownList>
   </td>
  </tr>

  <tr>
   <td class="filledbold" colspan="2"><b><%=(lingua.getforfrontendbypseudo("cartcollect.field.notes"))%>:</b></td>
  </tr>

  <tr>
   <td class="filled" colspan="2" align="center">
    <textarea rows="3" class="inputlargo" id="tareanote" runat="server"></textarea>
   </td>
  </tr>


  <tr>
   <td class="filled"><%=(lingua.getforfrontendbypseudo("cartcollect.field.coupon.code"))%>
    <asp:Label EnableViewState="false" ID="lblerrcouponcode" ForeColor="Red" runat="server" />
   </td>
   <td class="filled">
    <asp:TextBox ID="tboxcouponcode" class="inputlargo" runat="server" />
   </td>
  </tr>


 </table>

 <div align="right">
  <br>
  <asp:Button CssClass="pulsante" OnClick="buttConferma_click" ID="buttConferma" runat="server" />
 </div>

 <!--
        </ContentTemplate>
        </asp:UpdatePanel>
    -->

</asp:Content>
