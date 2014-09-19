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
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
 string idsane;
 void bind()
 {

  DataTable dt = simplestecommerce.helpDb.getDataTable(
   "select * from tutenti where ut_id=@id",
   new SqlParameter("id", idsane)
   );

  if (dt.Rows.Count < 1)
  {

   lblerr.Text = "user not found";
   pholderut.Visible = false;
   return;
  }

  DataRow dr = dt.Rows[0];

  lblnameoffirm.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(dr["ut_nameoffirm"].ToString());
  lbladdress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded ( dr["ut_address"].ToString());
  lblcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded (dr["ut_city"].ToString());
  lblcountry.Text = simplestecommerce.regioni.rowregionbyid((int)dr["ut_idregion"])["r_nome"].ToString();
  lblfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded ( dr["ut_firstname"].ToString());
  lblnick.Text = simplestecommerce.sicurezza.xss.getreplacedencoded ( dr["ut_id"].ToString());
  lblpostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(dr["ut_postalcode"].ToString());
  lblsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(dr["ut_secondname"].ToString());
  lblsubject.Text = simplestecommerce.lingua.getinadminlanguagebypseudo ( simplestecommerce.common.arrPseudoLegalSubject[ (int)dr["ut_subject"]  ]);
  lblvatnumber.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(dr["ut_vatnumber"].ToString());
  lblfiscalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(dr["ut_fiscalcode"].ToString());
  lbltelephone.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(dr["ut_telephone"].ToString());

  cboxenabled.Checked = !(bool)dr["ut_bloccato"];
  dlistpricelist.SelectedValue = dr["ut_listino"].ToString();
  tboxdiscount.Text = simplestecommerce.sicurezza.xss.getreplacedencoded ( dr["ut_sconto"].ToString());
  cboxnewsletter.Checked = (bool)dr["ut_newsletter"];
  cboxreservedpage.Checked = ((int)dr["ut_protezione"] == 1 ? true : false);
 }


    void buttAggiorna_click(object sender, EventArgs e)
    {

        double sconto;
     
        try {
         
         sconto = double.Parse (tboxdiscount.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
         
        }
        catch {
         
         lblerr.Text = "discount number not valid";
         return;
        }

        SqlConnection cnn;
        SqlCommand cmd;
        string strSql;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();

        strSql = "UPDATE tutenti" +
         " set ut_bloccato=@bloccato, ut_listino=@listino, ut_sconto=@sconto, ut_newsletter=@newsletter, ut_protezione=@protezione" +
         " where ut_id=@id";
     cmd = new SqlCommand(strSql, cnn);

        cmd.Parameters.Add(new SqlParameter("bloccato", !cboxenabled.Checked));
        cmd.Parameters.Add(new SqlParameter("listino", int.Parse ( dlistpricelist.SelectedValue)));
        cmd.Parameters.Add(new SqlParameter("sconto", sconto));
        cmd.Parameters.Add ( new SqlParameter("newsletter", cboxnewsletter.Checked));
        cmd.Parameters.Add ( new SqlParameter("protezione", (cboxreservedpage.Checked?1:0) ));
        cmd.Parameters.Add(new SqlParameter("id", idsane));

        cmd.ExecuteNonQuery();

        lblerr.Text = "user data updated";
     lblerr.ForeColor= System.Drawing.Color.Blue;
     bind();
     
    }

    void Page_Load()
    {


     if (Request.QueryString["id"] == null) Response.Redirect("admin_utenti.aspx");

     idsane = simplestecommerce.sicurezza.xss.getreplacedencoded((string)Request.QueryString["id"]);
     
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; <a href='admin_utenti.aspx'>users</a>" +
 "&nbsp;&raquo;&nbsp;user " + idsane;

     
     if (!Page.IsPostBack)
     {
      bind();

     }
    }


         


</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />

 <asp:PlaceHolder runat="server" ID="pholderut">
        <table align="center" cellspacing="1" width="100%">
            <tr class="admin_sfondodark">
                <td colspan="2">Billing data</td>
            </tr>
            <tr class="admin_sfondo">
                <td width="322">email/nick</td>
                <td width="718">
                <asp:Label runat="server" ID="lblnick" /></td>
            </tr>

            <tr class="admin_sfondo">
                <td >subject</td>
                <td >
                 <asp:label ID="lblsubject" runat="server" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td >name of firm</td>
                <td >
                 <asp:label runat="server" ID="lblnameoffirm" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td >first name</td>
                <td >
                 <asp:label runat="server" ID="lblfirstname" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >second name</td>
                <td >
                 <asp:label runat="server" ID="lblsecondname" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >address</td>
                <td >
                 <asp:label runat="server" ID="lbladdress" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >postal code</td>
                <td >
                 <asp:label runat="server" ID="lblpostalcode" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >city</td>
                <td >
                 <asp:label runat="server" ID="lblcity" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >country</td>
                <td >
                 <asp:label runat="server" ID="lblcountry" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >VAT number</td>
                <td >
                 <asp:label runat="server" ID="lblvatnumber" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td >fiscal code</td>
                <td >
                 <asp:label runat="server" ID="lblfiscalcode" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td >telephone number</td>
                <td >
                 <asp:label runat="server" ID="lbltelephone" />
                </td>
            </tr>



            <tr class="admin_sfondodark">
                <td colspan="2">Other data</td>
            </tr>

            <tr class="admin_sfondo">
                <td >enabled</td>
                <td >
                 <asp:checkbox runat="server" ID="cboxenabled" cssclass="input"/>
                </td>
            </tr>

           <tr class="admin_sfondo">
                <td >price list</td>
                <td >
                 <asp:dropdownlist runat="server" ID="dlistpricelist"  CssClass="input">
                  <asp:ListItem Value="0">0</asp:ListItem>
                  <asp:ListItem Value="1">1</asp:ListItem>
                  <asp:ListItem Value="2">2</asp:ListItem>
                  <asp:ListItem Value="3">3</asp:ListItem>
                  <asp:ListItem Value="4">4</asp:ListItem>
                  <asp:ListItem Value="5">5</asp:ListItem>
                  <asp:ListItem Value="6">6</asp:ListItem>
                  <asp:ListItem Value="7">7</asp:ListItem>
                  <asp:ListItem Value="8">8</asp:ListItem>
                  <asp:ListItem Value="9">9</asp:ListItem>
                  </asp:dropdownlist>
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td >discount</td>
                <td >
                 <asp:textbox runat="server" ID="tboxdiscount" cssclass="input" width="50"/>%
                </td>
            </tr>
         
            <tr class="admin_sfondo">
                <td >newsletter subscription</td>
                <td >
                 <asp:checkbox runat="server" ID="cboxnewsletter" cssclass="input" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td >he can read reserved pages</td>
                <td >
                 <asp:checkbox runat="server" ID="cboxreservedpage" cssclass="input" />
                </td>
            </tr>


        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>


 </asp:PlaceHolder>



</form></asp:Content>
