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

<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="ICSharpCode.SharpZipLib.Zip" %>
<%@ Import Namespace="ICSharpCode.SharpZipLib.Core" %>


<script runat="server">
 string directoryTempBackupAbsolute;

 string directoryBackupAbsolute;
 
 

 ArrayList ar = new ArrayList();


 // Recurses down the folder structure
 //
 private void CompressFolder(string path, ZipOutputStream zipStream, int folderOffset)
 {

  string[] files = Directory.GetFiles(path);

  foreach (string filename in files)
  {

   FileInfo fi = new FileInfo(filename);

   string entryName = filename.Substring(folderOffset); // Makes the name in zip based on the folder
   entryName = ZipEntry.CleanName(entryName); // Removes drive from name and fixes slash direction
   ZipEntry newEntry = new ZipEntry(entryName);
   newEntry.DateTime = fi.LastWriteTime; // Note the zip format stores 2 second granularity

   // Specifying the AESKeySize triggers AES encryption. Allowable values are 0 (off), 128 or 256.
   // A password on the ZipOutputStream is required if using AES.
   //   newEntry.AESKeySize = 256;

   // To permit the zip to be unpacked by built-in extractor in WinXP and Server2003, WinZip 8, Java, and other older code,
   // you need to do one of the following: Specify UseZip64.Off, or set the Size.
   // If the file may be bigger than 4GB, or you do not need WinXP built-in compatibility, you do not need either,
   // but the zip will be in Zip64 format which not all utilities can understand.
   //   zipStream.UseZip64 = UseZip64.Off;
   newEntry.Size = fi.Length;

   zipStream.PutNextEntry(newEntry);

   // Zip the file in buffered chunks
   // the "using" will close the stream even if an exception occurs
   byte[] buffer = new byte[4096];
   using (FileStream streamReader = File.OpenRead(filename))
   {
    StreamUtils.Copy(streamReader, zipStream, buffer);
   }
   zipStream.CloseEntry();
  }
  string[] folders = Directory.GetDirectories(path);
  foreach (string folder in folders)
  {
   CompressFolder(folder, zipStream, folderOffset);
  }
 }
 
 void buttexport_click(object o, EventArgs e)
 {

  DirectoryInfo directorytempbackup = new DirectoryInfo(directoryTempBackupAbsolute);

  {
   FileInfo[] files = directorytempbackup.GetFiles("*.*");
   foreach (FileInfo fi in files)
   {
    File.Delete(fi.FullName);
   }

  }
  
  
  SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
  cnn.Open();

  DataSet ds = new DataSet();
  DataTable dt;

  foreach (string tablename in ar)
  {

   string datapath = directorytempbackup.FullName + "/" + "data_" + tablename + ".xml";
   string schemapath = directorytempbackup.FullName + "/" + "schema_" + tablename + ".xml";



   dt = simplestecommerce.helpDb.getDataTableByOpenCnn(cnn, "select * from " + tablename);

   dt.WriteXml(datapath);
   dt.WriteXmlSchema(schemapath);

  }

  cnn.Close();


  // start compressing 

  string folderName = directoryTempBackupAbsolute;

  string zipfilename = "backup_" + Guid.NewGuid().ToString().Replace("-", "").Substring(0, 5) + "_" + System.DateTime.Now.ToString("yyyy-MM-dd_HH.mm.ss") + ".zip";
  
  FileStream fsOut = File.Create(directoryBackupAbsolute + "/" + zipfilename);

  ZipOutputStream zipStream = new ZipOutputStream(fsOut);

  zipStream.SetLevel(9); //0-9, 9 being the highest level of compression

  zipStream.Password = tboxpass.Text;  // optional. Null is the same as not setting. Required if using AES.

  // This setting will strip the leading part of the folder path in the entries, to
  // make the entries relative to the starting folder.
  // To include the full path for each entry up to the drive root, assign folderOffset = 0.
  int folderOffset = folderName.Length + (folderName.EndsWith("\\") ? 0 : 1);

  CompressFolder(folderName, zipStream, folderOffset);

  zipStream.IsStreamOwner = true; // Makes the Close also Close the underlying stream
  zipStream.Close();


  {
   FileInfo[] files = directorytempbackup.GetFiles("*.*");
   foreach (FileInfo fi in files)
   {
    File.Delete(fi.FullName);
   }

  }

  lblerr.Text = "backup done, name of backup: " + zipfilename;
  lblerr.ForeColor = System.Drawing.Color.Blue;

 }

 void Page_Load()
 {

  directoryTempBackupAbsolute = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/tempbackup"));
  if (!Directory.Exists(directoryTempBackupAbsolute))
   Directory.CreateDirectory(directoryTempBackupAbsolute);

  directoryBackupAbsolute = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/backup"));
  if (!Directory.Exists(directoryBackupAbsolute))
   Directory.CreateDirectory(directoryBackupAbsolute);



  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; export db tables to xml";

  ar = simplestecommerce.common.dbtables();

 }
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">


 <form runat="server">

<asp:Label runat="server" ID="lblerr" ForeColor="red" Font-Bold="true" Font-Size="Larger" />


  <div align="left">
   <br />
   <br />
   choose a password for the backup: &nbsp;<asp:TextBox runat="server" ID="tboxpass" CssClass="input" Width="200" />
   <asp:Button Text="create backup in xml format" runat="server" OnClick="buttexport_click" Style="width: 100px" CssClass="input" />



  </div>


 </form>
</asp:Content>
