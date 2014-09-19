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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" %>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>

<script runat="server">

   


    void Page_Load()
    {

       
        
        if (Request.QueryString["azione"].ToString() == "iscrivi")
        {

            string email = Server.UrlDecode(Request.QueryString["email"].ToString());
            if (email.Length < 1 || email.IndexOf("@") == -1 || email.IndexOf(".") == -1)
            {
                lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.warning.email.not.valid");
                return;
            }

            bool esiste = false;


            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            strSql = "SELECT COUNT(*) FROM tmailing WHERE m_email=@email";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", email));

            esiste = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            if (esiste)
            {
                cnn.Close();
                lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.warning.you.already.registered");
                return;
            }

            string guid = Guid.NewGuid().ToString().Replace("-", "").Substring(0, 10);
            strSql = "INSERT INTO tmailing (m_email, m_guid) VALUES (@email, @guid)";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", email));
            cmd.Parameters.Add(new SqlParameter("@guid", guid));
            cmd.ExecuteNonQuery();
            cnn.Close();




            lblEsito.ForeColor = System.Drawing.Color.Blue;
            lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.message.confirm.registration");

            string from = Application["config_emailSito"].ToString();
            string to = email;
            string subject = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.email.subject.confirm.registration") + " " + (string)Application["config_nomesito"];
            string body;

            body = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.email.body.confirm.registration") + ":" +
                "<br><a href='" + Application["config_urlSito"].ToString() + "/shop/newsletter.aspx?azione=conferma&guid=" + guid.ToString() + "'>" +
                Application["config_urlSito"].ToString() + "/shop/newsletter.aspx?azione=conferma&guid=" + guid.ToString() +
                "</a>";

            simplestecommerce.email.send(from, to, subject, body, true);
        }
        else if (Request.QueryString["azione"].ToString() == "conferma")
        {
            string guid = Request.QueryString["guid"].ToString();
            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            strSql = "SELECT COUNT(*) FROM tmailing WHERE m_guid=@guid";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@guid",guid  ));

            bool esiste = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            if (!esiste)
            {
                cnn.Close();
                lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.warning.no.subscription.present.with.this.email");
                return;
            }

            
            strSql = "UPDATE tmailing SET m_confermato=1 WHERE m_guid=@guid";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@guid", guid));
            cmd.ExecuteNonQuery();
            cnn.Close();




            lblEsito.ForeColor = System.Drawing.Color.Blue;
            lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.message.successfull.subscribed");

        }
        else if (Request.QueryString["azione"].ToString() == "cancella")
        {
            string email = Server.UrlDecode(Request.QueryString["email"].ToString());
            bool esiste = false;

           

            simplestecommerce.mailing.cancellaEmail(out esiste, email);

            if (esiste)
            {
                lblEsito.Text += simplestecommerce.lingua.getforfrontendbypseudo("newsletter.message.successfull.unsubscribed");
                lblEsito.ForeColor = System.Drawing.Color.Blue;
            }
            else lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("newsletter.message.problem.unsubscription");


        }
    }
  

</script>

<asp:Content runat="server" ContentPlaceHolderID="parteCentrale">


          <div align="center">

                <div style="width:300px;text-align:center; padding:4px; border: solid 1px #808080">
                <asp:label runat=server id="lblEsito"  ForeColor="red"/>
                </div>
           </div>

</asp:Content>













