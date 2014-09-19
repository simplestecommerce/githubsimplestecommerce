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

<%@ Page Language="C#" ValidateRequest="true" Trace="false" MasterPageFile="~/admin/admin_master.master"%>

<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="ICSharpCode.SharpZipLib.Zip" %>
<%@ Import Namespace="ICSharpCode.SharpZipLib.Core" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
 string directoryTempBackupAbsolute;

 string directoryBackupAbsolute;

 
 ArrayList arrtablenames;


 public void ExtractZipFile(string archiveFilenameIn, string password, string outFolder)
 {
  ZipFile zf = null;
  try
  {
   FileStream fs = File.OpenRead(archiveFilenameIn);
   zf = new ZipFile(fs);
   if (!String.IsNullOrEmpty(password))
   {
    zf.Password = password;     // AES encrypted entries are handled automatically
   }
   foreach (ZipEntry zipEntry in zf)
   {
    if (!zipEntry.IsFile)
    {
     continue;           // Ignore directories
    }
    String entryFileName = zipEntry.Name;
    // to remove the folder from the entry:- entryFileName = Path.GetFileName(entryFileName);
    // Optionally match entrynames against a selection list here to skip as desired.
    // The unpacked length is available in the zipEntry.Size property.

    byte[] buffer = new byte[4096];     // 4K is optimum
    Stream zipStream = zf.GetInputStream(zipEntry);

    // Manipulate the output filename here as desired.
    String fullZipToPath = Path.Combine(outFolder, entryFileName);
    string directoryName = Path.GetDirectoryName(fullZipToPath);
    if (directoryName.Length > 0)
     Directory.CreateDirectory(directoryName);

    // Unzip file in buffered chunks. This is just as fast as unpacking to a buffer the full size
    // of the file, but does not waste memory.
    // The "using" will close the stream even if an exception occurs.
    using (FileStream streamWriter = File.Create(fullZipToPath))
    {
     StreamUtils.Copy(zipStream, streamWriter, buffer);
    }
   }
  }
  finally
  {
   if (zf != null)
   {
    zf.IsStreamOwner = true; // Makes close also shut the underlying stream
    zf.Close(); // Ensure we release resources
   }
  }
 }
 
 
 void buttrestore_click(object sender, EventArgs e)
 {


  try
  {
   
  ExtractZipFile(radiobuttonlistbackuplist.SelectedValue , tboxpass.Text,  directoryTempBackupAbsolute); 
   
    
  
  
  
  string sql;
  SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
  cnn.Open();

  arrtablenames.Reverse();

  foreach (string tablename in arrtablenames)
  {

   sql = "delete " + tablename;
   simplestecommerce.helpDb.nonQueryByOpenCnn(cnn, sql);
  }


  arrtablenames.Reverse();


  foreach (string tablename in arrtablenames)
  {
   string datapath = directoryTempBackupAbsolute + "/data_" + tablename + ".xml";
   string schemapath = directoryTempBackupAbsolute + "/schema_" + tablename + ".xml";



   DataTable dt = new DataTable();
   dt.ReadXmlSchema(schemapath);
   dt.ReadXml(datapath);


   foreach (DataRow dr in dt.Rows)
   {
    SqlCommand cmd = new SqlCommand();

    sql="";
    if (tablename!="taxrates" && tablename!="tlistino" && tablename!="tlistini"
     &&tablename!="tcorrelati" &&tablename!="tsovrapprezzi"&&tablename!="tzone" &&tablename!="tutenti" && tablename!="tmailing")
      sql+= "SET IDENTITY_INSERT " + tablename + " ON; ";
    
    sql+=
     "insert into " + tablename + " (";


    bool first1 = true;
    foreach (DataColumn col in dt.Columns)
    {
     if (!first1) sql += ",";
     sql += col.ColumnName;

     first1 = false;
    }

    sql += ") values (";

    bool first2 = true;
    foreach (DataColumn col in dt.Columns)
    {
     if (!first2) sql += ",";
     sql += "@" + col.ColumnName;

     first2 = false;
    }
    sql += "); ";


    cmd.CommandText = sql;
    cmd.Connection = cnn;

    foreach (DataColumn col in dt.Columns)
    {

     cmd.Parameters.AddWithValue(col.ColumnName, dr[col]);

    }

    try
    {
     cmd.ExecuteNonQuery();
    }
    catch (Exception ex)
    {
     lblerr.Text += "<hr>" + ex.ToString();
     lblerr.ForeColor = System.Drawing.Color.Red;
    }
   }
  }  
   
   
  cnn.Close();




  lblerr.Text += "imported";
  lblerr.ForeColor = System.Drawing.Color.Blue;
   
     System.Web.HttpRuntime.UnloadAppDomain();

   
 }
   
  catch (Exception eccezione)
  {
   // catch exception on unzipping
   lblerr.Text = eccezione.ToString();
   lblerr.ForeColor = System.Drawing.Color.Red;
   
  }
  finally
  {
   FileInfo[] allfilesinfolder = new DirectoryInfo(directoryTempBackupAbsolute).GetFiles("*.*");
   foreach (FileInfo fi in allfilesinfolder)
   {
    File.Delete(fi.FullName);
   }

  }

}






 


 void Page_Load()
 {
  directoryTempBackupAbsolute = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/tempbackup"));
  if (!Directory.Exists(directoryTempBackupAbsolute))
   Directory.CreateDirectory(directoryTempBackupAbsolute);

  directoryBackupAbsolute = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/backup"));
  if (!Directory.Exists(directoryBackupAbsolute))
   Directory.CreateDirectory(directoryBackupAbsolute);

  arrtablenames = simplestecommerce.common.dbtables();
  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; restore data from xml";

  lblerr.Text = "";


  if (!IsPostBack) { 

  FileInfo[] allfilesinfolder = new DirectoryInfo(directoryBackupAbsolute).GetFiles("*.*");
  foreach (FileInfo fi in allfilesinfolder)
  {
   radiobuttonlistbackuplist.Items.Add(new ListItem(fi.FullName, fi.FullName));
  }

  if (radiobuttonlistbackuplist.Items.Count < 1)
  {

   lblerr.Text = "no backup files available ";
   panelbackpresent.Visible = false;
  }
  else radiobuttonlistbackuplist.SelectedIndex = 0;
  }
 }
</script>

<asp:content id="Content1" contentplaceholderid="partecentrale" runat="Server">
  <form runat="server">

<asp:Label runat="server" ID="lblerr" ForeColor="red" Font-Bold="true" Font-Size="Larger" />
     <asp:Panel runat="server" ID="panelbackpresent">


  <div align="left" >

   <br />
<asp:RadioButtonList runat="server"  ID="radiobuttonlistbackuplist"/>
   <br />

Archive password: <asp:TextBox runat="server" ID="tboxpass" TextMode="Password" CssClass="input" Width="300" EnableViewState="false" />  
<asp:Button runat="server" ID="butt_restore" OnClick="buttrestore_click" Text="restore" CssClass="bottone" />


  </div>
</asp:Panel>
   </form>
 </asp:content>
