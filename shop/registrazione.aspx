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

<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" CodeFile="registrazione.aspx.cs" Inherits="simplestecommerce.behindRegistrazioneAspx" ValidateRequest="true" %>

<%@ MasterType VirtualPath="~/shop/masterpage.master" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server" EnableViewState="true" ViewStateMode="Enabled">

 <asp:PlaceHolder ID="pHolderRegister" runat="server" Visible="true">

  <table cellspacing="0" cellpadding="0" width="100%" style="text-align:left" >
   <tr>
    <td class="box" width="100%" >
<%= simplestecommerce.lingua.getforfrontendbypseudo("register.title")%>    </td>
   </tr>
   <tr>
    <td>

     <table cellspacing="1" cellpadding="1" width="100%" border="0" style="margin-top:2px">


      <tr>
       <td class="filledbold" colspan="2" align="left" height="24">
        <b><%=lingua.getforfrontendbypseudo("register.label.billing.data")%>:</b>
       </td>
      </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.legal.subject")%>
       </td>
       <td class="filled">
        <asp:RadioButtonList ID="listaSoggetti" runat="server" AutoPostBack="true" OnSelectedIndexChanged="changedsubject" />

       </td>
      </tr>

      <asp:PlaceHolder runat="server" ID="pHolderRagSoc" Visible="false">
       <tr>
        <td class="filled"><%=(lingua.getforfrontendbypseudo("register.field.name.of.firm"))%>
            &nbsp;<asp:Label EnableViewState="false" ID="lblErrRagSoc" ForeColor="Red" runat="server" />
        </td>
        <td class="filled">
         <asp:TextBox ID="textBoxRagSoc" class="inputlargo" runat="server" />
        </td>
       </tr>
      </asp:PlaceHolder>



      <tr>
       <td width="38%" class="filled"><%=lingua.getforfrontendbypseudo("register.field.first.name")%>
            &nbsp;<asp:Label EnableViewState="false" ID="lblErrNome" ForeColor="Red" runat="server" />
       </td>
       <td width="62%" class="filled">
        <asp:TextBox ClientIDMode="Static" ID="textBoxNome" class="inputlargo" runat="server" onkeyup="document.getElementById('tboxspfirstname').value=this.value" />
       </td>
      </tr>



      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.second.name")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrCognome" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="textBoxCognome" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxspsecondname').value=this.value" />
       </td>
      </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.address")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrIndirizzo" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="textBoxIndirizzo" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxspaddress').value=this.value" />
       </td>
      </tr>


      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.postal.code")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrCap" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="textBoxCap" class="inputlargo" size="35" runat="server" onkeyup="document.getElementById('tboxsppostalcode').value=this.value" />
       </td>
      </tr>



      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.city")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrLoc" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="textBoxLocalita" class="inputlargo" runat="server" onkeyup="document.getElementById('tboxspcity').value=this.value" />
       </td>
      </tr>



      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.country")%>
       </td>
       <td class="filled">
        <asp:DropDownList ID="listaRegioni" class="inputlargo" runat="server" AutoPostBack="true" OnTextChanged="changedcountry_click" />
       </td>
      </tr>







      <asp:PlaceHolder runat="server" ID="pHolderTelefono" Visible="false">

       <tr>
        <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.telephone")%>
             &nbsp;<asp:Label ID="lblErrTel" runat="server" EnableViewState="false" ForeColor="Red" />
        </td>
        <td class="filled">
         <asp:TextBox ID="textBoxTelefono" class="inputlargo" size="35" runat="server" />
        </td>
       </tr>
      </asp:PlaceHolder>


      <asp:PlaceHolder runat="server" ID="pHolderCodiceFiscale" Visible="false">

       <tr>
        <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.fiscal.code")%>
             &nbsp;<asp:Label ID="lblErrCodFisc" runat="server" EnableViewState="false" ForeColor="Red" />
        </td>
        <td class="filled">
         <asp:TextBox ID="textBoxCodFisc" class="inputlargo" size="35" runat="server" />
        </td>
       </tr>
      </asp:PlaceHolder>

      <asp:PlaceHolder runat="server" ID="pholdervatnumber" Visible="false">

       <tr>
        <td class="filled"><%=lingua.getforfrontendbypseudo("register.field.vat.number")%>
             &nbsp;<asp:Label ID="lblerrvatnumber" runat="server" EnableViewState="false" ForeColor="Red" />
        </td>
        <td class="filled">
         <asp:TextBox ID="tboxvatnumber" class="inputlargo" size="35" runat="server" />
        </td>
       </tr>
      </asp:PlaceHolder>


      <!-- shipping data -->

      <tr>
       <td class="filledbold" colspan="2" align="left"  height="24">
        <b><%=lingua.getforfrontendbypseudo("register.label.shipping.data")%>:</b>
       </td>
      </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.shipping.field.first.name")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspfirstname" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="tboxspfirstname" class="inputlargo" size="35" runat="server" />
       </td>
      </tr>


      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.shipping.field.second.name")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspsecondname" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="tboxspsecondname" class="inputlargo" size="35" runat="server" />
       </td>
      </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.shipping.field.address")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspaddress" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="tboxspaddress" class="inputlargo" size="35" runat="server" />
       </td>
      </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.shipping.field.postal.code")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrsppostalcode" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="tboxsppostalcode" class="inputlargo" size="35" runat="server" />
       </td>
      </tr>



      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.shipping.field.city")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspcity" ForeColor="Red" runat="server" />
       </td>
       <td class="filled">
        <asp:TextBox ClientIDMode="Static" ID="tboxspcity" class="inputlargo" runat="server" />
       </td>
      </tr>



      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.shipping.field.country")%>
       </td>
       <td class="filled">
        <asp:DropDownList ID="dlistspidregion" class="inputlargo" runat="server" Enabled="false" />
       </td>
      </tr>







      <!-- end shipping data -->














      <asp:PlaceHolder runat="server" ID="pHolderNickPass"  >
       <tr>
        <td class="filledbold" colspan="2" align="left" height="24">
         <b><%=lingua.getforfrontendbypseudo("register.label.access.data")%>:</b>
        </td>
       </tr>

       <tr>
        <td class="filled"><%=simplestecommerce.lingua.getforfrontendbypseudo("register.access.data.field.email")%>&nbsp;
         (<%=simplestecommerce.lingua.getforfrontendbypseudo("register.access.data.field.email.label.this.will.be.username")%>)
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrEmail" ForeColor="Red" runat="server" />
        </td>
        <td class="filled">
         <asp:TextBox ID="textBoxEmail" class="inputlargo" size="35" runat="server" />
        </td>
       </tr>


       <tr>
        <td class="filled"><%=lingua.getforfrontendbypseudo("register.access.data.field.password")%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrPass" ForeColor="Red" runat="server" />
        </td>
        <td class="filled">
         <asp:TextBox ID="textBoxPass" TextMode="Password" class="inputlargo" size="35" runat="server" />
        </td>
       </tr>
      </asp:PlaceHolder>


      <tr>
       <td class="filledbold" colspan="2" align="left"  height="24">
        <b><%=lingua.getforfrontendbypseudo("register.label.newsletter")%>:</b>
       </td>
      </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("register.checkbox.newsletter")%>
             
       </td>
       <td class="filled">
        <asp:CheckBox ID="cBoxNewsletter" class="input" runat="server" />
       </td>
      </tr>
      <asp:PlaceHolder runat="server" ID="pHolderPrivacy">

       <tr>
        <td class="filledbold" colspan="2" align="left"  height="24">
         <b><%=lingua.getforfrontendbypseudo("register.label.privacy")%>:</b>
        </td>
       </tr>

       <tr>
        <td class="filled"><%=lingua.getforfrontendbypseudo("register.privacy.checkbox.i.accept")%>&nbsp;<a runat="server" target='_blank' style="text-decoration:underline" href="~/shop/pagina.aspx?id=8"><%=simplestecommerce.lingua.getforfrontendbypseudo("register.privacy.checbox.link.to.privacy.policy")%></a>
         <br />
         <asp:Label runat="server" ID="lblErrPrivacy" ForeColor="red" EnableViewState="false" />
        </td>
        <td class="filled">
         <asp:CheckBox ID="cBoxPrivacy" class="input" runat="server" />
        </td>
       </tr>


      </asp:PlaceHolder>


     </table>

    </td>
   </tr>
  </table>

  <br>


  <div align="center">
   <asp:Button ID="buttRegister" class="pulsante" Text='<%#lingua.getforfrontendbypseudo("register.button.register")%>' runat="server" />
  </div>

 </asp:PlaceHolder>


 <asp:PlaceHolder ID="pHolderEsito" runat="server" Visible="false">
  <div align="center">
   <table style="width: 400px; text-align: center; border: solid 1px #aaa; margin-top: 4px; background-color: #dde6e4; padding: 2px;">
    <tr>
     <td width="100%">

      <b>
       <asp:Label ID="lblEsito" runat="server" EnableViewState="false" /></b>

     </td>

    </tr>
   </table>
  </div>
 </asp:PlaceHolder>





</asp:Content>

