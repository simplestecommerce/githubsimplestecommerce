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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" EnableViewState="true" ViewStateMode="Enabled" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>
<%@ import Namespace="simplestecommerce" %>

<script runat=server>



    void buttAccedi_click(object sender, EventArgs e)
    {

        if (!simplestecommerce.utenti.esisteUtenteByEmail(textBoxEmail.Text))
        {

            lblEsito.Text = lingua.getforfrontendbypseudo("passwordrecovery.warning.no.registration.with.this.email");
            lblEsito.ForeColor = System.Drawing.Color.Red;
            return;


        }
        else
        {

            string tutti = "abcdefghijklmnopqrstuwyz0123456789";
            string newPassword = "";
            
            Random r = new Random(DateTime.Now.Millisecond);
            
            for (int rip = 0; rip < 8; rip++)
            {

                
                newPassword += tutti.Substring(Convert.ToInt32(r.Next(0,33)), 1);
            }
            
            simplestecommerce.utenti.cambiaPassword(textBoxEmail.Text, newPassword);
            
            // invio email
            string from = Application["config_emailSito"].ToString();
            string to = (string)textBoxEmail.Text;
            string subject = simplestecommerce.lingua.getforfrontendbypseudo("passwordrecovery.email.subject.label.your.new.password") + " " + (string)Application["config_nomesito"];
            string body;
            body =
            "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("passwordrecovery.email.body.label.your.new.password") + ": " + newPassword + "<br><br>" +
            simplestecommerce.lingua.getforfrontendbypseudo("passwordrecovery.email.body.label.info.for.modifying.password");

            bool okSentEmail = true;
            
            try
            {
                simplestecommerce.email.send(from, to, subject, body, true);
                
            }
            catch
            {
                okSentEmail = false;
            }

            if (okSentEmail)
            {
                lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("passwordrecovery.message.new.password.sent.to.email");
                lblEsito.ForeColor = System.Drawing.Color.Blue;

            }
            else
            {
             lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("passwordrecovery.message.new.password.impossibile.to.delivery.email");
                lblEsito.ForeColor = System.Drawing.Color.Red;
            }
            
            
        }


    }


    void Page_Load()
    {

        buttAccedi.Text = lingua.getforfrontendbypseudo("passwordrecovery.button.reovery.password");
    }
    
    
    </script>

<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">



     <table  cellspacing="1" cellpadding="2" width="100%" border=0 class=modulo>

        <tr class=filledbold>
         <td colspan=2 colspan=2 height=26>
            &nbsp;<b><%Response.Write(lingua.getforfrontendbypseudo("passwordrecovery.label.password.recovery"));%></b>
         </td>
        </tr>


        <tr class=filled>
         <td >
         &nbsp;<%Response.Write(lingua.getforfrontendbypseudo("passwordrecovery.field.type.your.registration.email"));%>:
         </td>
         <td width=300 valign=middle><asp:textbox id="textBoxEmail" class="input" style="width:100%" runat="server" />
         </td>
        </tr>
    </table>
    <br>
    <div align=center>
        <asp:button class="input"  id="buttAccedi" runat="server" onclick="buttAccedi_click"/>
    </div>

    <div align=center>
        <br>
        <br>
        <br>
        <br>
        <b><asp:label forecolor="red" id="lblEsito" runat="server" /></b>
    </div>
</asp:Content>