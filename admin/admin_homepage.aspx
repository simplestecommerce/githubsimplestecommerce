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

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<script runat="server">

    void bind() {

        cboxfeatured.Checked = (int)(simplestecommerce.config.getCampoByApplication("config_showfeatured")) == 1 ? true : false;
        cBoxUsato.Checked = (bool)(simplestecommerce.config.getCampoByApplication("config_showboxusato")) ;

        {
         ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

         Panel p = panelwelcome;
         TabContainer mytabcontainer = (TabContainer)p.Controls[0];



         for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
         {
          TabPanel tb = mytabcontainer.Tabs[rip];
          HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
          mytextarea.InnerText = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], (string)simplestecommerce.config.getCampoByApplication("config_welcometext"));
         }
        }
     

    }

    void buttAggiorna_click (Object sender, EventArgs e) {

        int showfeatured = cboxfeatured.Checked ? 1 : 0;
        int showreparti = cBoxReparti.Checked? 1:0 ;
        int showusato = cBoxUsato.Checked ? 1 : 0;

        // retrieve welcome text 
        string text = "";
        {
         Panel p = panelwelcome;
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
     

        string strSql;
        SqlCommand cmd;
        SqlConnection cnn;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

        cnn.Open();

        strSql = "UPDATE tconfig SET" +
        " config_showfeatured=@showfeatured" +
        ",config_showboxusato=@usato" +
        ",config_welcometext=@welcometext";

        cmd = new SqlCommand(strSql, cnn);
        cmd.Parameters.Add(new SqlParameter("@showfeatured", showfeatured));
        cmd.Parameters.Add(new SqlParameter("@usato", showusato));
        cmd.Parameters.Add(new SqlParameter("@welcometext", text));
        cmd.ExecuteNonQuery();

        cnn.Close();

        simplestecommerce.config.storeConfig();







        Response.Redirect("admin_menu.aspx");

    }
    void Page_Init()
    {
     // welcome
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
    panelwelcome.Controls.Add(mytabcontainer);
     }




    }
 

    void Page_Load () {

     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; homepage";

        if (!Page.IsPostBack) {

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


      <table cellpadding="0" style="width:100%">
<!--
        <tr class="admin_sfondo">
            <td>Show categories box: </td>
            <td><asp:checkbox id="cBoxReparti" runat=server class=input /></td>
        </tr>

-->

          
        <tr class="admin_sfondo">
            <td>Show featured products box: </td>
            <td><asp:checkbox id="cboxfeatured" checked runat=server class=input /></td>
        </tr>


        <tr class="admin_sfondo">
            <td>show used products box: </td>
            <td><asp:checkbox id="cBoxUsato" runat=server class=input /></td>
        </tr>
        <tr class="admin_sfondo">
            <td>
                welcome message
            </td>
            <td>
<asp:Panel runat="server" ID="panelwelcome" />            </td>
        </tr>
				<tr class="admin_sfondo">
					<td align="center" colspan="2" style="padding-top:20px"><asp:button id="buttAggiorna" onClick="buttAggiorna_click" runat=server text="SAVE CHANGES" class=bottone/></td>
				</tr>
      </table>

			
</form></asp:content>


