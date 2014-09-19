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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ Register TagPrefix="simplestecommerce" TagName="carrelloAdmin" Src="~/admin/admin_ucdbcart.ascx" %>
<script runat="server">

    
    simplestecommerce.Dbcart mydbcart;
    protected int idcart;


    


    
        
    void prepare () {

        dlistorderstatus.Items.Add(new ListItem("select new status", "-1"));
        
        DataTable dtstatusorder = simplestecommerce.orderstatus.getenabled();

        foreach (DataRow drstatusorder in dtstatusorder.Rows)
        {

            dlistorderstatus.Items.Add(new ListItem(simplestecommerce.lingua.getinadminlanguagefromdb(drstatusorder["name"].ToString()), drstatusorder["id"].ToString()));
            
        }
        
        
        
    }


     void bind () {

         mydbcart = new simplestecommerce.Dbcart(idcart);

         
         lblorderstatus.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getinadminlanguagefromdb(simplestecommerce.orderstatus.namebyid(mydbcart.Status)));
         tboxpromemoria.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Promemoria);
         if (mydbcart.Dbuser.Subject == 1)
         {
             pholdernameoffirm.Visible = true;
             lblnameoffirm.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Nameoffirm);
         }


         lblfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Firstname);
         lblsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Secondname);
         lblemail.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Email);
         lbltelephone.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Telephone);
         if (mydbcart.Dbuser.Fiscalcode != "")
         {
             lblfiscalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Fiscalcode);
             pholderfiscalcode.Visible = true;
         }
         else
         {
             pholderfiscalcode.Visible = false;
         }

         lbladdress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Address);
         lblpostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Postalcode);
         lblcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.City);

         lblstrregion.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(
           simplestecommerce.regioni.rowregionbyid(mydbcart.Dbuser.Idregion)["r_nome"].ToString()
           );

         lblsubject.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(
             simplestecommerce.lingua.getinadminlanguagebypseudo(simplestecommerce.common.arrPseudoLegalSubject[mydbcart.Dbuser.Subject])
             );

         lblmodeofpayment.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(
             simplestecommerce.lingua.getinadminlanguagefromdb(simplestecommerce.modeofpayment.nomeTipPagamById(mydbcart.Idmodeofpayment))
             );

         lblcarrier.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(

                     simplestecommerce.lingua.getinadminlanguagefromdb(simplestecommerce.corrieri.rowcarrierbyid(mydbcart.Idcarrier)["c_nome"].ToString())
                 );


         lblnote.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Note);

         // shipping 
         lblspfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Spfirstname);
         lblspsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Spsecondname);
         lblspaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Spaddress);
         lblspcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Spcity);
         lblsppostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(mydbcart.Dbuser.Sppostalcode);
         lblspstrregion.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.regioni.rowregionbyid(mydbcart.Dbuser.Spidregion)["r_nome"].ToString());

         lblorderdate.Text = mydbcart.Data.ToString("yyyy-M-d  HH:mm:ss");
         lblorderid.Text = mydbcart.Idcart.ToString();
         lbluserid.Text = simplestecommerce.sicurezza.xss.getreplacedencoded( mydbcart.Dbuser.Id);

         dlistorderstatus.SelectedValue = "-1";

       

     }














    void buttImposta_click (object sender, EventArgs e) {

        //bool inputValido = true;


        //if (dDLLavorazione.SelectedItem.Value != "-1") mydbcart.lavorazione = Convert.ToInt32(dDLLavorazione.SelectedItem.Value);

        string sql = "update tcart set promemoria=@promemoria";
        if (dlistorderstatus.SelectedValue != "-1") sql += ", idorderstatus=@idorderstatus";
        sql+=" where id=@id";
        SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
        cnn.Open();

        SqlCommand cmd = new SqlCommand(sql, cnn);
        cmd.Parameters.AddWithValue("promemoria", tboxpromemoria.Text);
        if (dlistorderstatus.SelectedValue != "-1") cmd.Parameters.AddWithValue("idorderstatus", int.Parse(dlistorderstatus.SelectedValue));
        cmd.Parameters.AddWithValue("id", idcart);
        cmd.ExecuteNonQuery();
        cnn.Close();

        lblerr.Text = "data saved";
        lblerr.ForeColor = System.Drawing.Color.Blue;
     
        bind();
        
        
    }







     void Page_Load () {

         idcart = Convert.ToInt32(Request.QueryString["idcart"]);
         

                 
        if (!Page.IsPostBack) {
            
   
        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>"+
        " &raquo; "+
        "<a href='admin_ordini.aspx'>orders</a>" +
        " &raquo; " +
        "order ID " + idcart.ToString();
            
            
            prepare ();
            bind();
        }
     }




</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />
    <fieldset>
    <asp:Panel runat="server" EnableViewState="true" ViewStateMode="Enabled">
    <table width="100%" cellpadding="0" cellspacing="1">
    <tr class="admin_sfondo">
        <td width="100">
            status:
        </td>
    <td nowrap>
        <asp:Label style="font-weight:bold" runat=server ID="lblorderstatus" />&nbsp;
        <asp:dropdownlist runat=server class=input id="dlistorderstatus"  />
             
    </td>
    </tr>
 
    
    <tr class="admin_sfondo">
        <td>
promemoria:
        </td>
    <td>
<asp:textbox style="width:100%" runat=server class=input id="tboxpromemoria" ></asp:textbox>
    </td>
    </tr>
    <tr class="admin_sfondo">
        <td colspan="2" align="center"><asp:button runat="server" Text="save" CssClass="bottone" OnClick="buttImposta_click" /></td>
    </tr>
</table>
</asp:Panel>
</fieldset>

<br /><br>

        <table cellspacing="1" cellpadding="3" width="100%" >


        <tr class="admin_sfondodark">
            <td colspan="2"><b><%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.order.data")%></b></td>
        </tr>

        <tr class="admin_sfondo">
            <td width="50%">&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.order.ID")%>
            </td>
            <td width="50%">&nbsp;
            <asp:Label ID="lblorderid"  runat="server" />
            </td>
        </tr>

       <tr class="admin_sfondo">
            <td width="50%">&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.order.date")%>
            </td>
            <td width="50%">&nbsp;
            <asp:Label ID="lblorderdate"  runat="server" />
            </td>
        </tr>

       <tr class="admin_sfondo">
            <td width="50%">&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.user.id")%>
            </td>
            <td width="50%">&nbsp;
            <asp:Label ID="lbluserid"  runat="server" />
            </td>
        </tr>


        <tr class="admin_sfondodark">
            <td colspan="2"><b><%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.billing.data")%></b></td>
        </tr>

        <tr class="admin_sfondo">
            <td width="50%">&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.legal.subject")%>
            </td>
            <td width="50%">&nbsp;
            <asp:Label ID="lblsubject"  runat="server" />
            </td>
        </tr>

        <asp:PlaceHolder runat="server" ID="pholdernameoffirm" Visible="false">
            <tr class="admin_sfondo">
                <td ">&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.name.of.firm")%>
                </td>
                <td >&nbsp;
            <asp:Label ID="lblnameoffirm"   runat="server" />
                </td>
            </tr>
        </asp:PlaceHolder>


        <tr class="admin_sfondo">
            <td >&nbsp;<%=(simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.first.name"))%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblfirstname"   runat="server" />
            </td>
        </tr>

        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.second.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblsecondname"   runat="server" />
            </td>
        </tr>


        <tr class="admin_sfondo">
            <td >&nbsp;Email
            </td>
            <td >&nbsp;
            <asp:Label ID="lblemail"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.telephone")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lbltelephone"   runat="server" />
            </td>
        </tr>

<asp:PlaceHolder runat="server" ID="pholderfiscalcode">

        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.fiscal.code")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblfiscalcode"   runat="server" />
            </td>
        </tr>
</asp:PlaceHolder>

        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.address")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lbladdress"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=(simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.postal.code"))%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblpostalcode"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.city")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblcity"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.country")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblstrregion"   runat="server" />
            </td>
        </tr>


        <tr class="admin_sfondodark">
            <td colspan="2"><b><%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.shipping.data")%></b></td>
        </tr>

        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.shipping.label.first.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspfirstname"   runat="server" />
            </td>
        </tr>

        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.shipping.label.second.name")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspsecondname"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.shipping.label.address")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspaddress"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.shipping.label.postal.code")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblsppostalcode"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.shipping.label.city")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblspcity"   runat="server" />
            </td>
        </tr>



        <tr class="admin_sfondo">
         <td >&nbsp;<%Response.Write(simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.shipping.label.country"));%>
         </td>
         <td >&nbsp;
            <asp:label id="lblspstrregion"  size=35 runat="server" />
         </td>
        </tr>

        <tr class="admin_sfondodark">
            <td colspan="2"><b><%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.final.info")%></b></td>
        </tr>





        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.carrier")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblcarrier"   runat="server" />
            </td>
        </tr>


        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.mode.of.payment")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblmodeofpayment"   runat="server" />
            </td>
        </tr>

        <tr class="admin_sfondo">
            <td >&nbsp;<%=simplestecommerce.lingua.getinadminlanguagebypseudo("admin.order.label.notes")%>
            </td>
            <td >&nbsp;
            <asp:Label ID="lblnote"  runat="server" />
            </td>
        </tr>



    </table>

<br>


<!--carrello -->
<simplestecommerce:carrelloAdmin runat="server" from="admin" />

   </form></asp:content>
