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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" ValidateRequest="true" %>
<%@ Register TagPrefix="simplestecommerce" TagName="cart" Src="uccart.ascx" %>
<%@ Register TagPrefix="simplestecommerce" TagName="incarrello" Src="ucincarrello.ascx" %>
<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<script runat="server">



      public simplestecommerce.Cart currentcart;
      public simplestecommerce.User currentuser;

      public void butt_procedi (object sender, EventArgs e) {

        Response.Redirect ("cartcollect.aspx");

      }



      void butt_indietro(object o, EventArgs e)
      {


       Response.Redirect("cartcollect.aspx?correctdata=true");

      }

      void showAndStoreSummary() {



          if (currentuser.Firstname == null) Response.Redirect("~/shop/cart.aspx");
          if (currentcart.Idcarrier == 0) Response.Redirect("~/shop/cart.aspx");
        if (currentuser.Subject == 1) { 
            pholdernameoffirm.Visible = true;
            lblnameoffirm.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Nameoffirm);
        }

          
        lblfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded( currentuser.Firstname );
        lblsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Secondname);
        lblemail.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Email);
        lbltelephone.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Telephone);
        if (currentuser.Fiscalcode != "")
        {
            lblfiscalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Fiscalcode);
            pholderfiscalcode.Visible = true;
        }
        else { 
            pholderfiscalcode.Visible = false; 
        }

        lbladdress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Address);
        lblpostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Postalcode);
        lblcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.City);
        
          lblstrregion.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(
            simplestecommerce.regioni.rowregionbyid(currentuser.Idregion)["r_nome"].ToString()
            );
          
        lblsubject.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(
            lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[currentuser.Subject])
            );

        lblmodeofpayment.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(
            lingua.getforfrontendfromdb(simplestecommerce.modeofpayment.nomeTipPagamById(currentcart.Idmodeofpayment))
            );

        lblcarrier.Text = simplestecommerce.sicurezza.xss.getreplacedencoded (
                    
                    simplestecommerce.lingua.getforfrontendfromdb ( simplestecommerce.corrieri.rowcarrierbyid( currentcart.Idcarrier )["c_nome"].ToString() )  
                );


        lblnote.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentcart.Note);
        // shipping 
        lblspfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spfirstname);
        lblspsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spsecondname);
        lblspaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spaddress);
        lblspcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spcity);
        lblsppostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Sppostalcode);
        lblspstrregion.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.regioni.rowregionbyid(currentuser.Spidregion)["r_nome"].ToString());
      }


      public void butt_ordina(object sender, EventArgs e)
      {

          if (!cBoxCondizioni.Checked)
          {
              lblErr.Text = simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.alert.you.must.accept.conditions");
              return;

          }

          if (!cBoxPrivacy.Checked && currentuser.Anonimo)
          {
              lblErr.Text = simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.alert.you.must.accept.privacy.terms");
              return;

          }



          Response.Redirect("cartconfirm.aspx");

      }



      void Page_Load()
      {
          currentcart = (simplestecommerce.Cart)Session["Cart"];
          currentuser = currentcart.User;
          
          
          if ((int)Application["config_registrazione"] > 0 && currentuser.Anonimo) Response.Redirect("login.aspx");
          

          buttOrd.Text = simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.button.order");
          buttInd.Text = "< " + simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.button.correct");

          if (currentuser.Anonimo)
          {
              pHolderPrivacy.Visible = true;

          }

        if (!Page.IsPostBack)
            showAndStoreSummary();

      }





















    

    
    
    
    
</script>
<asp:Content runat="server" ContentPlaceHolderID="parteCentrale" EnableViewState="true" ViewStateMode="Enabled">



    <table cellspacing="1" cellpadding="3" width="100%" border="0" class="modulo">


        <tr>
            <td colspan="2" class="filledbolddark">&nbsp;<span class="titoletto"><%Response.Write(lingua.getforfrontendbypseudo("cartsummary.label.summary"));%></span></td>
        </tr>

        <tr class="filledbold">
            <td colspan="2"><b><%=lingua.getforfrontendbypseudo("cartsummary.label.billing.data")%></b></td>
        </tr>

        <tr class="filled">
            <td width="50%">&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.legal.subject")%>
            </td>
            <td width="50%">&nbsp;
            <asp:Label ID="lblsubject" class="input" runat="server" />
            </td>
        </tr>

        <asp:PlaceHolder runat="server" ID="pholdernameoffirm" Visible="false">
            <tr class="filled">
                <td ">&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.name.of.firm")%>
                </td>
                <td >&nbsp;
            <asp:Label ID="lblnameoffirm" class="input"  runat="server" />
                </td>
            </tr>
        </asp:PlaceHolder>


        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.first.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblfirstname" class="input"  runat="server" />
            </td>
        </tr>

        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.second.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblsecondname" class="input"  runat="server" />
            </td>
        </tr>


        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.second.email")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblemail" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.telephone")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lbltelephone" class="input"  runat="server" />
            </td>
        </tr>

<asp:PlaceHolder runat="server" ID="pholderfiscalcode">

        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.fiscal.code")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblfiscalcode" class="input"  runat="server" />
            </td>
        </tr>
</asp:PlaceHolder>

        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.address")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lbladdress" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.postal.code")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblpostalcode" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.city")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblcity" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.country")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblstrregion" class="input"  runat="server" />
            </td>
        </tr>


        <tr class="filledbold">
            <td colspan="2"><b><%=lingua.getforfrontendbypseudo("cartsummary.label.shipping.data")%></b></td>
        </tr>

        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.shipping.first.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspfirstname" class="input"  runat="server" />
            </td>
        </tr>

        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.shipping.second.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspsecondname" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.shipping.address")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspaddress" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.shipping.postal.code")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblsppostalcode" class="input"  runat="server" />
            </td>
        </tr>



        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.shipping.city")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspcity" class="input"  runat="server" />
            </td>
        </tr>



        <tr class=filled>
         <td >&nbsp;<%Response.Write (lingua.getforfrontendbypseudo("cartsummary.field.shipping.country"));%>
         </td>
         <td >&nbsp;
            <asp:label id="lblspstrregion" class="input" size=35 runat="server" />
         </td>
        </tr>

        <tr class="filledbold">
            <td colspan="2"><b><%=lingua.getforfrontendbypseudo("cartsummary.label.final.info")%></b></td>
        </tr>





        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.carrier")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblcarrier" class="input"  runat="server" />
            </td>
        </tr>


        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.mode.of.payment")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblmodeofpayment" class="input"  runat="server" />
            </td>
        </tr>

        <tr class="filled">
            <td >&nbsp;<%=lingua.getforfrontendbypseudo("cartsummary.field.notes")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblnote" class="input" runat="server" />
            </td>
        </tr>



    </table>
    <br>
    <simplestecommerce:cart from="1" ID="ucCart" runat="server" />

    <div align="center">
        <br />
        <%=simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.checkbox.i.agree.with.conditions")%>&nbsp; 
        <a runat="server" style='text-decoration:underline' target=_blank href='~/shop/pagina.aspx?id=23'><%=simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.checkbox.i.agree.with.conditions.condition.word")%></a>
        &nbsp;<asp:CheckBox ID="cBoxCondizioni" runat="server" CssClass="input" />
        <br />
        <asp:PlaceHolder runat="server" ID="pHolderPrivacy" Visible="false">
            <%=lingua.getforfrontendbypseudo("cartsummary.checkbox.i.agree.with.privacy")%>&nbsp;
            <a runat="server" style='text-decoration:underline' target='_blank' href='~/shop/pagina.aspx?id=8'><%=simplestecommerce.lingua.getforfrontendbypseudo("cartsummary.checkbox.i.agree.with.privacy.privacy.word")%></a>
         &nbsp;<asp:CheckBox ID="cBoxPrivacy" runat="server" CssClass="input" />
        </asp:PlaceHolder>

    </div>


    <div align="center">
        <br />
        <asp:Label ID="lblErr" runat="server" EnableViewState="false" ForeColor="red" />
    </div>


    <div align="center">
        <br>
        <br>
        <asp:Button CssClass="pulsante" OnClick="butt_indietro" ID="buttInd" runat="server" />
        <img src="~/immagini/space.gif" width="45" height="0" border="0">
        <asp:Button CssClass="pulsante" OnClick="butt_ordina" ID="buttOrd" runat="server" />
    </div>







</asp:Content>
