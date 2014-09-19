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
<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">

    int idNews;
    
    void dGrid_cancel(object sender, DataGridCommandEventArgs e)
    {
    }

    
    void dGrid_edit(object sender, DataGridCommandEventArgs e)
    {

        idNews = int.Parse(e.Item.Cells[2].Text);
        Response.Redirect("admin_news.aspx?idNews=" + idNews);

        
    }
    
    
    void dgridUt_update(object sender, DataGridCommandEventArgs e)
    {


    }
    
    
                
    void buttCrea_click(object sender, EventArgs e)
    {

     DateTime myDateTime = new DateTime();

     try
     {
      myDateTime = DateTime.Parse(tBoxData.Text);
     }
     catch
     {
      lblerr.Text += "<br>date is not valid";
      return;

     }

     string strDateTime = myDateTime.ToString("yyyyMMdd");

     
     // check for empty title 
     
     string errempty = "";
     {
      TabContainer tc = (TabContainer)paneltitle.Controls[0];
      foreach (TabPanel tb in tc.Tabs)
      {

       TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
       if (tbox.Text == "") errempty += "<br>insert title in " + tb.HeaderText;
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
        text += tb.HeaderText +"." + tarea.InnerText;
       }
      }
     }
     
     
     
     
     
     if (Request.QueryString["idNews"] != null)
     {

      string sql = "UPDATE tnews SET n_data=@data, n_testo=@testo, n_titolo=@titolo" +
          " WHERE n_id=@id";

      

      
      SqlParameter p1 = new SqlParameter("@data", strDateTime);
      SqlParameter p2 = new SqlParameter("@testo", text);
      SqlParameter p3 = new SqlParameter("@titolo", title);
      SqlParameter p4 = new SqlParameter("@id", int.Parse(Request.QueryString["idNews"]));
      simplestecommerce.helpDb.nonQuery(sql, p1, p2, p3, p4);
     }
     else
     {
      string sql = "INSERT INTO tnews (n_titolo, n_testo, n_data) " +
          " VALUES (@titolo,@testo,@data)";


      
      SqlParameter p1 = new SqlParameter("@titolo", title);
      SqlParameter p2 = new SqlParameter("@testo", text);
      SqlParameter p3 = new SqlParameter("@data", strDateTime);
      simplestecommerce.helpDb.nonQuery(sql, p1, p2, p3);
     }



     Response.Redirect("admin_news.aspx");

    }
    
    
    void bindData () {

        
        


        if (Request.QueryString["idNews"] != null)
        {
            
            DataTable dt = simplestecommerce.notizie.getNotizia(idNews);

            string strData = DateTime.Parse(dt.Rows[0]["n_data"].ToString()).ToString("yyyy-MM-dd");
            string titolo = dt.Rows[0]["n_titolo"].ToString();
            string testo = dt.Rows[0]["n_testo"].ToString();

            tBoxData.Text = strData;

         
         
     //bind title
     {
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

      Panel p = paneltitle;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);



      for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
      {
       TabPanel tb = mytabcontainer.Tabs[rip];
       TextBox mytextbox = (TextBox)tb.FindControl("mytextbox");
       mytextbox.Text = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], titolo);
      }
     }
         

// bind text
     {
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
      
      Panel p = paneltext;
      TabContainer mytabcontainer = (TabContainer)p.Controls[0];

      
      
      for (int rip=0; rip<mytabcontainer.Tabs.Count; rip++) {
       TabPanel tb = mytabcontainer.Tabs[rip];
       HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
         mytextarea.InnerText= simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip],testo);
      }
     }
                  
                  
         

        }

        
        
    }

    void dGridNews_itemCommand (object sender, DataGridCommandEventArgs e) {


        
        switch (e.CommandName) {

              
            case "delete":
                int idNews = int.Parse(e.Item.Cells[2].Text);           
            string sql = "delete  FROM tnews WHERE n_id=@id";
            SqlParameter p1 = new SqlParameter("@id", idNews);
            simplestecommerce.helpDb.nonQuery(sql, p1);
                bindData();
                break;
        }

    }

    void prepare()
    {

        if (Request.QueryString["idNews"] != null)
        {
            buttCrea.Text = "UPDATE NEWS";
        }
        else
        {
         tBoxData.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }
    }
    void Page_Init()
    {
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
 

    

    void Page_Load () {

        
        idNews = Convert.ToInt32(Request.QueryString["idNews"]);
        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; ";
        if (idNews > 0) ((Label)Master.FindControl("lbldove")).Text += "update news ID " + idNews.ToString();
        else ((Label)Master.FindControl("lbldove")).Text += "add news";


        if (idNews > 0) lblcreateorupdate.Text = "update news";
        else lblcreateorupdate.Text = "add news";
     
        if (!Page.IsPostBack) prepare();
        
        if (!Page.IsPostBack) {
            bindData();
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
 <legend><asp:Label runat="server" ID="lblcreateorupdate" /></legend>
  <table widthg="100%" cellpadding="0" cellspacing="1">

            <tr class="admin_sfondo">
                <td width="140" nowrap>
                    date (yyyy-mm-dd)
                </td>
                <td>
                    <asp:TextBox id="tBoxData" runat=server  CssClass=input/>
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td>
title
                </td>
                <td>
<asp:Panel runat="server" ID="paneltitle" />
                </td>
            </tr>
                        <tr class="admin_sfondo">
                <td>
text
                </td>
                <td>

<asp:Panel runat="server" ID="paneltext" />



                </td>
            </tr>
            <tr class="admin_sfondo">
                <td colspan="2" align="center">
                            <asp:Button runat=server ID="buttCrea" CssClass=bottone Text="CREATE NEWS" onclick="buttCrea_click"/>

                </td>
            </tr>
        </table>
</fieldset>       


    </form></asp:Content>