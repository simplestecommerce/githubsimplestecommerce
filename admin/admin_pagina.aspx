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
<%@ Import Namespace="System.Data.SqlClient" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<script runat="server">
 int posizione;
 int id;
 string title = "";

 void buttapri_click(object o, EventArgs e)
 {

  Response.Redirect("~/shop/pagina.aspx?id=" + id.ToString());

 }

 void bind()
 {



  IDataReader dr;
  dr = simplestecommerce.pagine.leggi(id);
  dr.Read();
  string title = dr["pa_nome"].ToString();
  string text = dr["pa_testo"].ToString();

  //bind title
  {
   ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

   Panel p = paneltitle;
   TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);



   for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
   {
    TabPanel tb = mytabcontainer.Tabs[rip];
    TextBox mytextbox = (TextBox)tb.FindControl("mytextbox");
    mytextbox.Text = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], title);
   }
  }


  // bind text
  {
   ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

   Panel p = paneltext;
   TabContainer mytabcontainer = (TabContainer)p.Controls[0];



   for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
   {
    TabPanel tb = mytabcontainer.Tabs[rip];
    HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
    mytextarea.InnerText = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], text);
   }
  }






  if (id != 0) ((Label)Master.FindControl("lbldove")).Text += " &raquo; " + simplestecommerce.lingua.getinadminlanguagefromdb(title);

  if (posizione == 0) pholderreserved.Visible = true; else pholderreserved.Visible = false;
  dListRiservato.SelectedValue = dr["pa_protezione"].ToString();
  dr.Close();


 }






 void buttAggiorna_click(object sender, EventArgs e)
 {

  int protezione = 0;



  // check for empty title 

  string errempty = "";
  {
   TabContainer tc = (TabContainer)paneltitle.Controls[0];
   foreach (TabPanel tb in tc.Tabs)
   {

    TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
    if (tbox.Text == "") errempty += "<br>insert page name in " + tb.HeaderText;
   }

   if (errempty != "")
   {
    lblerr.Text += "<br>" + errempty;
    return;
   }
  }

  // retrieve title 
  string title = "";
  {
   Panel p = paneltitle;
   TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
   foreach (TabPanel tb in mytabcontainer.Tabs)
   {
    {
     TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
     if (title.Length > 0) title += "@@";
     title += tb.HeaderText + "." + tbox.Text;
    }
   }
  }


  // retrieve text 
  string text = "";
  {
   Panel p = paneltext;
   TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
   foreach (TabPanel tb in mytabcontainer.Tabs)
   {
    {
     HtmlTextArea tarea = (HtmlTextArea)(tb.FindControl("mytextarea"));
     if (text.Length > 0) text += "@@";
     text += tb.HeaderText + "." + tarea.InnerText;
    }
   }
  }



  protezione = Convert.ToInt32(dListRiservato.SelectedValue);


  if (id == 0)
  {

   SqlConnection cnn;
   SqlCommand cmd;

   cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
   cnn.Open();
   string sql = "INSERT INTO tpagine" +
       " (pa_nome, pa_testo, pa_protezione,pa_posizione) VALUES (@nome,@testo,@protezione,@posizione)";

   SqlParameter p1 = new SqlParameter("nome", title);
   SqlParameter p2 = new SqlParameter("testo", text);
   SqlParameter p3 = new SqlParameter("protezione", protezione);
   SqlParameter p4 = new SqlParameter("posizione", posizione);

   simplestecommerce.helpDb.nonQueryByOpenCnn(cnn, sql, p1, p2, p3, p4);


   sql = "SELECT MAX(pa_id) FROM tpagine";
   cmd = new SqlCommand(sql, cnn);

   id = Convert.ToInt32(cmd.ExecuteScalar());
   cnn.Close();

   Response.Redirect("admin_pagine.aspx?posizione=" + posizione);
  }
  else
  {
   simplestecommerce.pagine.aggiorna(id, title, text, protezione);

   Response.Redirect("admin_pagine.aspx?posizione=" + posizione);
  }


 }

 void Page_Init()
 {

  posizione = Convert.ToInt32(Request.QueryString["posizione"]);

  id = Convert.ToInt32(Request.QueryString["id"]);

  // title
  {
   TabContainer mytabcontainer = new TabContainer();
   mytabcontainer.ID = "tabcontainertitle";
   mytabcontainer.CssClass = "CustomTabStyle";


   ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
   for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
   {

    TextBox tbox = new TextBox();
    tbox.ID = "mytextbox";
    tbox.CssClass = "input";
    tbox.Attributes["style"] = "width:100%";
    tbox.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
    AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
    mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
    mytabpanel.ID = "mytabpanel" + rip.ToString();
    mytabpanel.Controls.Add(tbox);
    mytabcontainer.Tabs.Add(mytabpanel);

   }
   paneltitle.Controls.Add(mytabcontainer);
  }

  // text
  {
   TabContainer mytabcontainer = new TabContainer();
   mytabcontainer.ID = "tabcontainertext";
   mytabcontainer.CssClass = "CustomTabStyle";


   ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
   for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
   {

    HtmlTextArea tarea = new HtmlTextArea();
    tarea.ID = "mytextarea";
    tarea.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
    AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
    mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
    mytabpanel.ID = "mytabpanel" + rip.ToString();
    mytabpanel.Controls.Add(tarea);
    mytabcontainer.Tabs.Add(mytabpanel);

   }
   paneltext.Controls.Add(mytabcontainer);
  }




 }



 void Page_PreRender()
 {


  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; ";
  ((Label)Master.FindControl("lbldove")).Text += "<a href='admin_pagine.aspx?posizione=" + posizione + "'>";
  if (posizione == 0) ((Label)Master.FindControl("lbldove")).Text += "pages in info box";
  else if (posizione == 1) ((Label)Master.FindControl("lbldove")).Text += "pages in menu bar";
  ((Label)Master.FindControl("lbldove")).Text += "</a>";
  if (id == 0) ((Label)Master.FindControl("lbldove")).Text += " &raquo; new page";

  if (!Page.IsPostBack)
  {

   if (posizione == 0) pholderreserved.Visible = true; else pholderreserved.Visible = false;
  }

  if (!Page.IsPostBack && id != 0)
  {
   bind();
   buttapri.Visible = true;
  }


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
    <td>page name
    </td>
    <td>
     <asp:Panel runat="server" ID="paneltitle" />
    </td>
   </tr>

   <asp:PlaceHolder runat="server" ID="pholderreserved" Visible="false">
    <tr class="admin_sfondo">
     <td>reserved to:
     </td>
     <td>
      <asp:DropDownList ID="dListRiservato" runat="server" CssClass="input" Width="100%">
       <asp:ListItem Value="0">all users</asp:ListItem>
       <asp:ListItem Value="1">only registered users</asp:ListItem>
       <asp:ListItem Value="2">only registered users which I have authorized from USERS MENU</asp:ListItem>
      </asp:DropDownList>
     </td>
    </tr>
   </asp:PlaceHolder>



   <tr class="admin_sfondo">
    <td width="300">text</td>
    <td>
     <asp:Panel runat="server" ID="paneltext" />


    </td>
   </tr>



  </table>

  <div align="right" style="padding: 18px">
   <br>
   <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
   &nbsp;
    <asp:LinkButton CssClass="bottone" OnClick="buttapri_click" ID="buttapri" runat="server" Text="OPEN PAGE" OnClientClick="window.document.forms[0].target='_blank';" />
  </div>


 </form>
</asp:Content>
