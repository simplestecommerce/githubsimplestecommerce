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
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.Data" %>



<script runat="server">

 void testemail_click(object sender, EventArgs e)
 {

  if (tboxtestemail.Text.Length < 1)
  {

   lblerr.Text = "type email for test";
   return;
  }
  
  string from = "bit_studio@libero.it";
  string subject = "test subject simplestecommerce mail";
  string body = "test body simplestecommerce mail";
  string to =  tboxtestemail.Text;
  bool ok = true;

  try
  {
   simplestecommerce.email.send(from, to, subject, body, false);
  }
  catch (Exception E)
  {

   lblesitotest.Text=
   "<i>" + E.ToString() + "</i>";
   ok = false;
  }

  if (ok)
  {
   lblesitotest.Text= "Test email sent succesfully";
  }
 }




         void bindFields() {
      tBoxSmtp.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.config.getCampoByApplication("config_smtp").ToString());

          tBoxAutenticazioneEmail.Text = simplestecommerce.sicurezza.xss.getreplacedencoded( simplestecommerce.config.getCampoByApplication("config_autenticazioneemail").ToString());
          tBoxAutenticazionePass.Attributes["value"] = "**********";
          cBoxUsaAutenticazione.Checked = (bool)simplestecommerce.config.getCampoByApplication("config_usaautenticazione");
     
         }


         void aggiorna_click(object sender, EventArgs e)
         {




          string sql = "update tconfig SET " +
        " config_smtp=@smtp" +
        ", config_usaAutenticazione=@usaautenticazione" +
        ", config_autenticazioneEmail=@autenticazioneEmail";
          
           simplestecommerce.helpDb.nonQuery(sql,
              new SqlParameter("smtp", tBoxSmtp.Text),
              new SqlParameter("usaautenticazione", (cBoxUsaAutenticazione.Checked ? 1 : 0)),
              new SqlParameter("autenticazioneEmail", tBoxAutenticazioneEmail.Text)
          );


           if (tBoxAutenticazionePass.Text != "**********")
           {

            string pass = tBoxAutenticazionePass.Text;
            simplestecommerce.helpDb.nonQuery(
             "UPDATE tconfig SET config_autenticazionepass=@pass",
             new SqlParameter ("@pass", simplestecommerce.sicurezza.critt.Encode(pass)));


           }
          
                                             
             simplestecommerce.config.storeConfig();

             lblerr.Text = "Parameters has been updated";
             lblerr.ForeColor = System.Drawing.Color.Blue;
             bindFields();
             
          
          
          
         }

         void Page_Load() {

          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; parameters for sending email from the e-commerce site"; 
    
             if (!Page.IsPostBack) {
            

             bindFields();
            }

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />



 <table width="100%"  cellspacing="1" cellpadding="0">

            <tr class="admin_sfondodark">
                <td colspan="2" ><b>parameters for sending email from e-commerce site</b></td>
            </tr>

            <tr class="admin_sfondo">
                <td>server SMTP</td>
                <td >
                    <asp:TextBox ID="tBoxSmtp" runat="server" class="inputlargo" size="30" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>use authentication</td>
                <td >
                    <asp:CheckBox ID="cBoxUsaAutenticazione" runat="server" class="inputlargo" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>e-mail for authentication</td>
                <td >
                    <asp:TextBox ID="tBoxAutenticazioneEmail" runat="server" class="inputlargo" size="30" />
                </td>
            </tr>


            <tr class="admin_sfondo">
                <td>password email for authentication
  &nbsp;<asp:Label ID="lblErrPassAuth" ForeColor="Red" EnableViewState="false" runat="server" />
                </td>

                <td >
                    <asp:TextBox ID="tBoxAutenticazionePass" runat="server" class="inputlargo" TextMode="Password" size="30" /></td>
            </tr>






</table>

         <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="aggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>


 <fieldset>
  <legend>test email delivery</legend>
  <asp:TextBox runat="server" CssClass="input" Width="300" ID="tboxtestemail" />&nbsp;&nbsp;<asp:Button runat="server" Text="SEND" CssClass="bottone" OnClick="testemail_click" />
<br /><br /><asp:label runat="server" ID="lblesitotest" ForeColor="red" />
 </fieldset>


</form></asp:content>
