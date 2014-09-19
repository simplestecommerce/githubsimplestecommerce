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
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script runat="server">



    void bindFields()
    {


     tboxartperpag.Text = simplestecommerce.config.getCampoByApplication("config_artperpag").ToString();

     //bottom
     {
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

      Panel p = panelbottom;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
      {
       TabPanel tb = mytabcontainer.Tabs[rip];
       HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
       mytextarea.InnerText = 
        simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], (string)simplestecommerce.config.getCampoByDb("config_piede") );
      }
     }



    
    }



    void buttAggiorna_click(object sender, EventArgs e)
    {
     //retrieve bottom
     string bottom = "";
     {
      Panel p = panelbottom;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      foreach (TabPanel tb in mytabcontainer.Tabs)
      {
       {
        HtmlTextArea tarea = (HtmlTextArea)(tb.FindControl("mytextarea"));
        if (bottom.Length > 0) bottom += "@@";
        bottom += tb.HeaderText + "." + tarea.InnerText;
       }
      }
     }

     
     
     int artperpag = -1;
     
     try
     {
      artperpag = int.Parse(tboxartperpag.Text);
      
     }
     catch
     {
      lblerr.Text = "insert a number for ARTICLES PER PAGE";
      return;
     }

        SqlConnection cnn;
        SqlCommand cmd;
        string strSql;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();

        strSql = "UPDATE tconfig SET config_artperpag=@artperpag, config_piede=@piede ";
        cmd = new SqlCommand(strSql, cnn);

        cmd.Parameters.Add(new SqlParameter("@artperpag", tboxartperpag.Text));
        cmd.Parameters.Add(new SqlParameter("@piede", bottom));
        cmd.ExecuteNonQuery();

        cnn.Close();
     
     
        simplestecommerce.config.storeConfig();
    
        lblerr.Text = "parameters saved";
     lblerr.ForeColor=System.Drawing.Color.Blue;
     bindFields();
    
    }

    void Page_Init()
    {
     {
      TabContainer mytabcontainer = new TabContainer();
      mytabcontainer.ID = "tabcontainer";
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
     panelbottom.Controls.Add(mytabcontainer);
     }

    }
    void Page_Load()
    {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; layout";


        if (!Page.IsPostBack)
        {
            //   simplestecommerce.config.storeConfig();

            bindFields();


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

        <table align="center" cellspacing="1" width="100%">

            <tr class="admin_sfondodark">
                <td colspan="2" ><b>layout</b></td>
            </tr>

            <tr class="admin_sfondo">
                <td width="322">articles per page<br />
                    in preview articles page&nbsp;&nbsp;</td>
                <td width="718">
                    <asp:TextBox EnableViewState="false" ID="tboxartperpag" Width="80" runat="server" class="input" />
            </tr>
            <tr class="admin_sfondo">
                <td>bottom</td>
                <td >    
<asp:Panel runat="server" ID="panelbottom" />

                </td>
            </tr>


        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
        </div>






</form></asp:Content>
