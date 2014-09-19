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


<script runat="server">

 void buttInvia_click(object sender, EventArgs e)
 {

  int target;
  int inviate = 0;
  string from = tBoxFrom.Text;
  string subject = tBoxSubject.Text;
  string body = tareabody.InnerText;
  string to = "";


  target = Convert.ToInt32(ddLTarget.SelectedValue);
  IDataReader dr;
  dr = simplestecommerce.mailing.getEmails(target);

  while (dr.Read())
  {

   bool ok = true;

   to = dr[0].ToString();

   try
   {
    simplestecommerce.email.send(from, to, subject, body, cBoxHtml.Checked);
   }
   catch (Exception E)
   {

    lblesitowork.Text +=
         lblesitowork.Text += "<br>1 email UNSUCCESSFULLY sent to: " + to;
    ok = false;
   }

   if (ok)
   {
    inviate++;
    lblesitowork.Text += "<br>1 email succesfully sent to: " + to;
   }

  }

  dr.Close();
  buttInvia.Visible = false;
  lblesitowork.Text += "<br><br><b>TOTAL NUMBER EMAILS SENT SUCCESSFULLY: " + inviate;

 }

 void buttInviaProva_click(object sender, EventArgs e)
 {

  string from = tBoxFrom.Text;
  string subject = tBoxSubject.Text;
  string body = tareabody.InnerText;
  string to = tBoxEmailProva.Text;
  bool ok = true;

  if (to == "")
  {
   lblesitotest.Text = "type test email address";
   return;
  }
  
  try
  {
   simplestecommerce.email.send(from, to, subject, body, cBoxHtml.Checked);
  }
  catch (Exception E)
  {

   lblesitotest.Text=
   "<br>-----------------------------------------------------------------------------<br>" +
   "Problem sending email address:<b>" + to + "</b>" +
   "Problem description: " +
   "<i>" + E.ToString() + "</i>";

   ok = false;
  }

  if (ok)
  {
   lblesitotest.Text = "Test email sent succesfully";
  }
 }


 void Page_Load()
 {

  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; newsletter";

  if (!Page.IsPostBack) tBoxFrom.Text = Application["config_emailSito"].ToString();
 }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
  <br />
  <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />





  <table width="100%" cellspacing="1">

   <tr class="admin_sfondo">
    <td width="300">From:&nbsp;&nbsp;</td>
    <td class="admin_sfondobis">
     <asp:TextBox EnableViewState="TRUE" ID="tBoxFrom" size="50" runat="server" class="input" />
    </td>
   </tr>


   <tr class="admin_sfondo">
    <td width="300">Subject:&nbsp;&nbsp;</td>
    <td class="admin_sfondobis">
     <asp:TextBox Text="" EnableViewState="TRUE" ID="tBoxSubject" size="100" runat="server" class="input" />
    </td>
   </tr>

   <tr class="admin_sfondo">
    <td width="300">Body:&nbsp;&nbsp;</td>
    <td class="admin_sfondobis">
     <textarea runat="server" style="width: 100%" rows="20" id="tareabody" validaterequestmode="disabled"></textarea>


    </td>
   </tr>

   <tr class="admin_sfondo">
    <td width="300">Html format&nbsp;&nbsp;</td>
    <td class="admin_sfondobis">
     <asp:CheckBox ID="cBoxHtml" EnableViewState="TRUE" runat="server" Checked="true" /></td>
   </tr>



  </table>


  <br>
  <br>
  <fieldset>
   <legend>send email to a single address for test</legend>
  test email address <asp:TextBox ID="tBoxEmailProva" runat="server" CssClass="input" />&nbsp;&nbsp;<asp:Button OnClick="buttInviaProva_click" runat="server" ID="buttInviaProva" Text="send test newsletter" class="bottone" />
   <asp:Label runat="server" ForeColor="Red" ID="lblesitotest" />
  </fieldset>
  <br />

    <fieldset>
   <legend>
    send to users
   </legend>
         <asp:DropDownList runat="server" class="input" ID="ddLTarget">
      <asp:ListItem Value="0">Registered to e-commerce users</asp:ListItem>
      <asp:ListItem Value="1">Resistered to newsletter users</asp:ListItem>
     </asp:DropDownList>


   <asp:Button OnClick="buttInvia_click" runat="server" ID="buttInvia" Text="SEND NEWSLETTER TO USERS" class="bottone" />
     <br />
        <asp:Label runat="server" ForeColor="Red" ID="lblesitowork" />

  </fieldset>


 </form>
</asp:Content>



