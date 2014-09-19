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
// this file allow to choose and save in tconfig the following parameters
// config_frontendlanguages
// config_startingfrontendlanguagename
// config_adminlanguagename
// retrieving the list of all supported languages from lanuagepack.xml  
 
string idsane;

 
 void listfrontend_changed(object o, EventArgs e)
 {

  preparestartingfrontendlanguagelist();

 }

 void preparestartingfrontendlanguagelist()
 {

  dliststartingfrontendlanguagename.Items.Clear();
  foreach (ListItem li in cboxlistfrontendlanguagename.Items)
  {
   if (li.Selected) dliststartingfrontendlanguagename.Items.Add(new ListItem(li.Value, li.Value));

  }

 }

 void prepare()
 {
  // retrieve all languages in xml languages package
  DataSet dslanguage = new DataSet();
  string filepath = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/languagepack.xml"));
  dslanguage.ReadXml(filepath, XmlReadMode.InferSchema);
  DataTable dtalllanguages = dslanguage.Tables[0];

  for (int rip = 0; rip < dtalllanguages.Columns.Count - 1; rip++)
  {
   dlistadminlanguagename.Items.Add(new ListItem(dtalllanguages.Columns[rip].ColumnName, dtalllanguages.Columns[rip].ColumnName));
   cboxlistfrontendlanguagename.Items.Add(new ListItem(dtalllanguages.Columns[rip].ColumnName, dtalllanguages.Columns[rip].ColumnName));
  }


 }
 void bind()
 {

  string strfrontendsupportedlanguages = simplestecommerce.config.getCampoByDb("config_frontendlanguages").ToString();

  string[] delimiter = { "@@" };

  string[] frontendsupportedlanguages = strfrontendsupportedlanguages.Split(delimiter, System.StringSplitOptions.None);

  for (int rip = 0; rip < frontendsupportedlanguages.Length; rip++)
  {
   foreach (ListItem li in cboxlistfrontendlanguagename.Items)
   {
    if (li.Value == frontendsupportedlanguages[rip]) li.Selected = true;
   }

  }
  preparestartingfrontendlanguagelist();

  dliststartingfrontendlanguagename.SelectedValue = simplestecommerce.config.getCampoByDb("config_startingfrontendlanguagename").ToString();

  dlistadminlanguagename.SelectedValue = simplestecommerce.config.getCampoByDb("config_adminlanguagename").ToString();

 }

 void buttAggiorna_click(object sender, EventArgs e)
 {
  bool atleastoneselected = false;
  foreach (ListItem li in cboxlistfrontendlanguagename.Items)
  {

   if (li.Selected) atleastoneselected = true;
  }

  if (!atleastoneselected)
  {
   lblerr.Text = "Choose at least one language for front-end";
   return;

  }
  ArrayList arfrontendsupportedlanguages = new ArrayList();
  foreach (ListItem li in cboxlistfrontendlanguagename.Items)
  {

   if (li.Selected) arfrontendsupportedlanguages.Add(li.Value);
  }




  string strfrontendsupportedlanguages = "";
  foreach (string a in arfrontendsupportedlanguages)
  {
   if (strfrontendsupportedlanguages.Length > 0) strfrontendsupportedlanguages += "@@";
   strfrontendsupportedlanguages += a;
  }




  SqlConnection cnn;
  SqlCommand cmd;
  string sql;

  cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();


  simplestecommerce.helpDb.nonQueryByOpenCnn(cnn, "update tconfig set config_frontendlanguages=@frontendsupportedlanguages",
   new SqlParameter("frontendsupportedlanguages", strfrontendsupportedlanguages)
   );

  simplestecommerce.helpDb.nonQueryByOpenCnn(cnn, "update tconfig set config_startingfrontendlanguagename=@config_startingfrontendlanguagename",
new SqlParameter("config_startingfrontendlanguagename", dliststartingfrontendlanguagename.SelectedValue)
);


  simplestecommerce.helpDb.nonQueryByOpenCnn(cnn, "update tconfig set config_adminlanguagename=@adminlanguagename",
new SqlParameter("adminlanguagename", dlistadminlanguagename.SelectedValue)
);


  cnn.Close();






  System.Web.HttpRuntime.UnloadAppDomain();


  Response.Redirect("~/admin/admin_menu.aspx");

 }

 void Page_Load()
 {


  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; set web site languages";

  if (!Page.IsPostBack)
  {
   prepare();
   bind();

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


  <fieldset>
   <legend>choose languages</legend>
   <table align="center" cellspacing="1" width="100%">
    <tr class="admin_sfondo">
     <td colspan="2">Front-end languages</td>
     <td>
      <asp:CheckBoxList runat="server" CssClass="input" ID="cboxlistfrontendlanguagename" OnSelectedIndexChanged="listfrontend_changed" AutoPostBack="true">
      </asp:CheckBoxList></td>
    </tr>
    <tr class="admin_sfondo">
     <td colspan="2">Starting Front-end language</td>
     <td>
      <asp:DropDownList runat="server" CssClass="input" ID="dliststartingfrontendlanguagename">
      </asp:DropDownList></td>
    </tr>

    <tr class="admin_sfondo">
     <td colspan="2">Admin language</td>
     <td>
      <asp:DropDownList runat="server" CssClass="input" ID="dlistadminlanguagename">
      </asp:DropDownList></td>
    </tr>

   </table>
   </fieldset>

   <br>


   <div align="right" style="padding-right: 20px">
    <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="UPDATE" />
   </div>





 </form>
</asp:Content>
