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


<%@ Page Language="C#"  MasterPageFile="~/shop/masterpage.master" CodeFile="updateprofile.aspx.cs" Inherits="simplestecommerce.behindupdateprofileAspx"  ValidateRequest="true"%>
<%@ MasterType  virtualPath="~/shop/masterpage.master"%>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server" EnableViewState="true" ViewStateMode="Enabled">


    <ASP:placeholder id="pHolderModulo" runat="server">

     <table  cellspacing="1" cellpadding="1" width="100%" border=0 style="text-align:left">

        <tr  >
            <td class=box COLSPAN=2 align="left"  >
		                <%=simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.title")%>
            </td>
        </tr>

        <tr  >
            <td class=filledbold COLSPAN=2 align="left"  >
                <b><%=lingua.getforfrontendbypseudo("updateprofile.label.billing.data")%>:</b>
            </td>
        </tr>

      <tr>
       <td class="filled"><%=lingua.getforfrontendbypseudo("updateprofile.field.legal.subject")%>
       </td>
       <td class="filled">
        <asp:RadioButtonList ID="listaSoggetti" runat="server" AutoPostBack="true" />

       </td>
      </tr>

      <asp:PlaceHolder runat="server" ID="pHolderRagSoc" Visible="false">
      <tr>
       <td class="filled" ><%=lingua.getforfrontendbypseudo("updateprofile.field.name.of.firm")%>
            &nbsp;<asp:Label EnableViewState="false" ID="lblErrRagSoc" ForeColor="Red" runat="server" />
       </td>
       <td class="filled" >
        <asp:TextBox ID="textBoxRagSoc" class="inputlargo" runat="server" />
       </td>
      </tr>
      </asp:placeholder>



      <tr>
       <td width="38%" class="filled" ><%=(lingua.getforfrontendbypseudo("updateprofile.field.first.name"))%>
            &nbsp;<asp:Label EnableViewState="false" ID="lblErrNome" ForeColor="Red" runat="server" />
       </td>
       <td width="62%" class="filled" >
        <asp:TextBox ID="textBoxNome" class="inputlargo" runat="server" />
       </td>
      </tr>



 <tr>
  <td class="filled"><%=(lingua.getforfrontendbypseudo("updateprofile.field.second.name"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrCognome" ForeColor="Red" runat="server" />
  </td>
  <td class="filled">
   <asp:TextBox ID="textBoxCognome" class="inputlargo" size="35" runat="server" />
  </td>
 </tr>

 <tr>
  <td class="filled"><%=(lingua.getforfrontendbypseudo("updateprofile.field.address"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrIndirizzo" ForeColor="Red" runat="server" />
  </td>
  <td class="filled">
   <asp:TextBox ID="textBoxIndirizzo" class="inputlargo" size="35" runat="server" />
  </td>
 </tr>


        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.field.postal.code"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrCap"  ForeColor=Red runat="server"  />
         </td>
         <td class=filled >
            <asp:textbox id="textBoxCap" class="inputlargo" size=35 runat="server" />
         </td>
        </tr>



        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.field.city"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblErrLoc"  ForeColor=Red runat="server"  />
         </td>
         <td class=filled >
            <asp:textbox  id="textBoxLocalita" class="inputlargo" runat="server" />
         </td>
        </tr>



        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.field.country"))%>
         </td>
         <td class=filled >
            <asp:dropdownlist id="dlistregioni" class="inputlargo" runat="server"  Enabled="false"/>
         </td>
        </tr>






            <asp:PlaceHolder runat="server" ID="pHolderTelefono" Visible="false">

        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.field.telephone"))%>
             &nbsp;<asp:Label ID="lblErrTel" runat=server EnableViewState="false" ForeColor=Red />
         </td>
         <td class=filled >
            <asp:textbox id="textBoxTelefono" class="inputlargo" size=35 runat="server" />
         </td>
        </tr>
      </asp:placeholder>


      <asp:PlaceHolder runat="server" ID="pHolderCodiceFiscale" Visible="false">

        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.field.fiscal.code"))%>
             &nbsp;<asp:Label ID="lblErrCodFisc" runat=server EnableViewState="false" ForeColor=Red />            
         </td>
         <td class=filled >
            <asp:textbox id="textBoxCodFisc" class="inputlargo" size=35 runat="server" />
         </td>
        </tr>
</asp:placeholder>

      <asp:PlaceHolder runat="server" ID="pholdervatnumber" Visible="false">

        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.field.vat.number"))%>
             &nbsp;<asp:Label ID="lblerrvatnumber" runat=server EnableViewState="false" ForeColor=Red />            
         </td>
         <td class=filled >
            <asp:textbox id="tboxvatnumber" class="inputlargo" size=35 runat="server" />
         </td>
        </tr>
</asp:placeholder>


<!-- shipping data -->

        <tr  >
            <td class=filledbold COLSPAN=2 align="left"  >
                <b><%=(lingua.getforfrontendbypseudo("updateprofile.label.shipping.data"))%>:</b>
            </td>
        </tr>
 <tr>
  <td class="filled"><%=(lingua.getforfrontendbypseudo("updateprofile.shipping.field.first.name"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspfirstname" ForeColor="Red" runat="server" />
  </td>
  <td class="filled">
   <asp:TextBox ID="tboxspfirstname" class="inputlargo" size="35" runat="server" />
  </td>
 </tr>


 <tr>
  <td class="filled"><%=(lingua.getforfrontendbypseudo("updateprofile.shipping.field.second.name"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspsecondname" ForeColor="Red" runat="server" />
  </td>
  <td class="filled">
   <asp:TextBox ID="tboxspsecondname" class="inputlargo" size="35" runat="server" />
  </td>
 </tr>

 <tr>
  <td class="filled"><%=(lingua.getforfrontendbypseudo("updateprofile.shipping.field.address"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspaddress" ForeColor="Red" runat="server" />
  </td>
  <td class="filled">
   <asp:TextBox ID="tboxspaddress" class="inputlargo" size="35" runat="server" />
  </td>
 </tr>


        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.shipping.postal.code"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrsppostalcode"  ForeColor=Red runat="server"  />
         </td>
         <td class=filled >
            <asp:textbox id="tboxsppostalcode" class="inputlargo" size=35 runat="server" />
         </td>
        </tr>



        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.shipping.city"))%>
             &nbsp;<asp:Label EnableViewState="false" ID="lblerrspcity"  ForeColor=Red runat="server"  />
         </td>
         <td class=filled >
            <asp:textbox  id="tboxspcity" class="inputlargo" runat="server" />
         </td>
        </tr>



        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.shipping.country"))%>
         </td>
         <td class=filled >
            <asp:dropdownlist id="dlistspregion" class="inputlargo" runat="server" Enabled="false" />
         </td>
        </tr>







<!-- end shipping data -->





        <asp:placeholder runat=server id="pHolderPass" visible=false>
        <tr  >
            <td class=filledbold COLSPAN=2 align="left"  >
                <b><%=lingua.getforfrontendbypseudo("updateprofile.access.data.label")%>:</b>
            </td>
        </tr>

         <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.access.data.field.email"))%>
         </td>
         <td class=filled >
            <asp:label id="lblEmail" class="inputlargo"  runat="server" />
         </td>
        </tr>


        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.access.data.field.old.password"))%>
             &nbsp;<asp:Label  EnableViewState="false" ID="lblErrOldPass"  ForeColor=Red runat="server"  />
         </td>
         <td class=filled >
            <asp:textbox id="tBoxOldPass" TextMode="Password" type="password" class="inputlargo"  runat="server" />
         </td>
        </tr>

        <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.access.data.field.new.password"))%>
                      &nbsp;<asp:Label  EnableViewState="false" ID="lblErrNewPass"  ForeColor=Red runat="server"  />
         </td>
         <td class=filled >
            <asp:textbox id="tBoxNewPass" TextMode="Password" type="password" class="inputlargo"  runat="server" />
         </td>
        </tr>


        </asp:placeholder>
          <tr  >
            <td class=filledbold COLSPAN=2 align="left"  >
                <b><%=(lingua.getforfrontendbypseudo("updateprofile.label.newsletter"))%>:</b>
            </td>
        </tr>

         <tr >
         <td class=filled ><%=(lingua.getforfrontendbypseudo("updateprofile.checkbox.newsletter.subscription"))%>
             
         </td>
         <td class=filled >
            <asp:checkbox id="cBoxNewsletter" class="input" runat="server" />
         </td>
        </tr>


     </table>



    <br>


    <div align=center>
        <asp:button visible=false id="buttUpdate" class="pulsante" Text=<%#lingua.getforfrontendbypseudo("updateprofile.button.update")%> runat="server" />
    </div>

    </ASP:placeholder>

 <asp:PlaceHolder ID="pHolderEsito" Visible="false" runat="server">
  <div align="center">
   <table style="width: 400px; text-align: center; border: solid 1px #aaa; margin-top: 4px; background-color: #dde6e4; padding: 2px;">
   <tr>
    <td width="100%">

     <b><asp:Label ID="lblEsito" runat="server" EnableViewState="false" /></b>
 
    </td>

   </tr>
   </table>
  </div>
 </asp:PlaceHolder>





</asp:content>

