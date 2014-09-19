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


<script runat="server">
void cambio (object o, EventArgs e) {

    bindFields();


}
    void bindFields() {

         
     DataRow dr = simplestecommerce.tipiPagamento.getById ( int.Parse (dListTipoPagam.SelectedValue) );

     {
      
      
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

      Panel p = panelmessagges;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
      {
       TabPanel tb = mytabcontainer.Tabs[rip];
       HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
       mytextarea.InnerText = 
        simplestecommerce.lingua.getfromdbbylanguage(
        (string)arrfrontendlanguages[rip], dr["messaggio"].ToString()
                
        );
      }
     }
     

        lblTipoPagam.Text = simplestecommerce.lingua.getinadminlanguagefromdb( dr["nome"].ToString() );
    }



    void buttAggiorna_click(object sender, EventArgs e)
    {


     
      //retrieve message
     string message = "";
      {
       Panel p = panelmessagges;
       TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
       foreach (TabPanel tb in mytabcontainer.Tabs)
       {
        {
         HtmlTextArea tarea = (HtmlTextArea)(tb.FindControl("mytextarea"));
         if (message.Length > 0) message += "@@";
         message += tb.HeaderText + "." + tarea.InnerText;
        }
       }
      }
     
     
      SqlConnection cnn;
      SqlCommand cmd;
      string strSql;

      cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

      strSql = "UPDATE tipipagamento set messaggio=@messaggio where id=@id";

      cmd = new SqlCommand(strSql, cnn);
      cmd.Parameters.Add(new SqlParameter("@messaggio", message));
      cmd.Parameters.Add(new SqlParameter("@id", int.Parse (  dListTipoPagam.SelectedValue ) ));

      cnn.Open();
      cmd.ExecuteNonQuery();
      cnn.Close();

     
     

      lblerr.Text = "message has been saved";
      lblerr.ForeColor = System.Drawing.Color.Blue;
      bindFields();
     
    }
    void prepare () {

        DataTable dt = simplestecommerce.tipiPagamento.getAll();
        foreach ( DataRow dr in dt.Rows) {

            dListTipoPagam.Items.Add ( new ListItem ( simplestecommerce.lingua.getinadminlanguagefromdb(dr["nome"].ToString()), dr["id"].ToString() ));
            
        }

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
     panelmessagges.Controls.Add(mytabcontainer);
     }

     

    }
    
    void Page_Load() {

        
             if (!Page.IsPostBack) {

              ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; order confirmation messages";

             prepare();
             
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





 
 <table width="100%" cellspacing=1 >

 <tr class="admin_sfondo">
 <td  width=300>select method of payment:</td>
 <td >
    <asp:DropDownList runat="server" ID="dListTipoPagam"  AutoPostBack="true"  OnSelectedIndexChanged="cambio"/>
 </td>
 </tr>


 <tr class="admin_sfondo">
 <td >message <asp:Label ID="lblTipoPagam" runat=server /> :</td>
 <td >

<asp:Panel runat="server" ID="panelmessagges" /> 

 </td>
 </tr>


</table>

<div align=right style="padding-right:18px">
    <br><asp:button onClick="buttAggiorna_click" id="buttAggiorna" runat="server" text="SAVE MESSAGE" class=bottone />
</div>



    </form></asp:Content>