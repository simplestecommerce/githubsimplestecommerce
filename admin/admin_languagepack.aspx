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
<%@ Import Namespace="System.IO" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
void buttdownload_click(object sender, EventArgs e)
{

 string filelanguagepack;

 if (File.Exists(Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/languagepack.xml"))))
  filelanguagepack = ResolveUrl(Application["upload"].ToString() + "/logo.jpg");
 else filelanguagepack = ResolveUrl("~/languagepack.xml");
 
 
 
 Server.MapPath(ResolveUrl((string)Application["upload"] + "/languagepack.xml"));
 Response.Clear();
 Response.AddHeader(
     "content-disposition", 
     string.Format("attachment; filename={0}", "languagepack.xml")
 );

 Response.ContentType = "application/octet-stream";

 Response.WriteFile(filelanguagepack);
 Response.End();
}

void buttupload_click(object sender, EventArgs e)
{

 if (file0.PostedFile.FileName == "")
 {

  lblerr.Text = "choose the .xml file from your hard-disk";
  return;
 }
 

 string phisicalpath = Server.MapPath((string)Application["upload"] + "/languagepack.xml");

 bool errore = false;

 try
 {
  System.IO.File.Delete(phisicalpath);
  file0.PostedFile.SaveAs(phisicalpath);
 }
 catch (Exception exc)
 {
  lblerr.Text = exc.ToString();
  errore = true;

 }

 if (!errore)
 {
  lblerr.Text = "languagepack has been uploaded correctly";
  lblerr.ForeColor = System.Drawing.Color.Blue;

 }

 System.Web.HttpRuntime.UnloadAppDomain();

}


 








 void Page_Load()
 {


  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; download/upload language pack";

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
   <legend>language pack</legend>
   <table cellpadding="0" cellspacing="1" width="100%">
    <tr class="admin_sfondo">
     <td>download the .xml file of language pack</td>
     <td valign="middle" >
      <asp:Button runat="server" Text="download" OnClick="buttdownload_click" CssClass="bottone" />
     </td>
    </tr>
    <tr class="admin_sfondo">
     <td>upload the modified .xml file of language pack</td>
     <td valign="middle" >
    <input class=bottone  runat="server" type="file" id="file0">&nbsp;<asp:Button runat="server" Text="upload" CssClass="bottone" OnClick="buttupload_click" />
     </td>
    </tr>
   </table>

  </fieldset>










 </form>
</asp:Content>
