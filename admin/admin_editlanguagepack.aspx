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

<%@ Page Language="C#" ValidateRequest="true" Trace="false" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
 void grid_update(object sender, DataGridCommandEventArgs e)
 {

  string pseudoasid = e.Item.Cells[4].Text;
  
  string newpseudo = ((TextBox)e.Item.Cells[1].Controls[0]).Text;
  string neweng = ((TextBox)e.Item.Cells[2].Controls[0]).Text;
  string newita = ((TextBox)e.Item.Cells[3].Controls[0]).Text;



  string filename = Server.MapPath(ResolveUrl((string)Application["upload"] + "/languagepack.xml"));
  StreamReader reader = new StreamReader(filename);
  string testo = reader.ReadToEnd();
  reader.Close();

  string parolaIniziale0 = "<sentence pseudo=\"" + pseudoasid + "\">";
  string parolaFinale0 = "</sentence>";
  Match m0 = (Regex.Matches(testo, @"(" + parolaIniziale0 + "((.|\n)*?)" + parolaFinale0 + ")"))[0];
  string occorrenza = m0.Groups[1].Value;

  testo = testo.Replace(
   occorrenza,
 "<sentence pseudo=\"" + newpseudo + "\">" +
"\r\n" +
"<english>" + neweng+ "</english>" +
"\r\n" +
"<italian>" + newita+ "</italian>" +
"\r\n" +
"</sentence>"
   );


  StreamWriter writer = new StreamWriter(filename);
  writer.Write(testo);
  writer.Close();

  System.Web.HttpRuntime.UnloadAppDomain();

  grid.EditItemIndex = -1;
  
  bind();
 
    
  
 }
 
 
 void grid_edit(object sender, DataGridCommandEventArgs e)
 {
  

            grid.EditItemIndex = e.Item.ItemIndex;
            bind();
         

  
  
 }

    void button_click(object sender, EventArgs e)
    {
     if (tboxpseudo.Text == "" || tboxita.Text == "" || tboxeng.Text == "") return; 
     
     string filename = Server.MapPath(ResolveUrl((string)Application["upload"] + "/languagepack.xml"));
     StreamReader reader = new StreamReader(filename);
     string testo = reader.ReadToEnd();
     reader.Close();

     testo = testo.Substring(0, testo.IndexOf("</sentences>"));

     testo +=
      "\r\n" +
     "<sentence pseudo=\"" + tboxpseudo.Text + "\">" +
     "\r\n" +
     "<english>" + tboxeng.Text + "</english>" +
     "\r\n" +
     "<italian>" + tboxita.Text + "</italian>"+
     "\r\n"+
     "</sentence>"+
     "\r\n"+
     "</sentences>";
     
     StreamWriter writer = new StreamWriter(filename);
     writer.Write(testo);
     writer.Close();

     System.Web.HttpRuntime.UnloadAppDomain();

     bind();

     
    }

    void bind()
    {
     DataSet dslanguage = new DataSet();
     string filepath = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/languagepack.xml"));
     dslanguage.ReadXml(filepath, XmlReadMode.InferSchema);
     DataTable dtalllanguages = dslanguage.Tables[0];

     grid.DataSource = dtalllanguages;
     grid.DataBind();

     grid.Items[(grid.Items.Count) - 1].BackColor = System.Drawing.Color.Orange;
     tboxeng.Text = "";
     tboxita.Text = "";
     tboxpseudo.Text = "";
    }

    void Page_Load()
    {
 
     
     if (!IsPostBack) bind();
     
    }
    
</script>

<html>
 <head >
  
  <style >

   body {
    font-size:11px;
    font-family:Tahoma;
   }

   table tr td {

   font-size:11px;
   font-family:Tahoma;
 

   }
      table tr td input {

   font-size:11px;
   font-family:Tahoma;
 width:100%;

   }

      .pseudoasid {visibility:hidden;width:1px; font-size:0px}
  </style>
 </head>
 <body onload="document.getElementById('tboxpseudo').focus()">



  <form runat="server">
      <asp:datagrid runat="server" ID="grid"
        AutoGenerateColumns="false"
        OnEditCommand="grid_edit"
        OnUpdateCommand="grid_update"
       >
       <Columns>
        <asp:EditCommandColumn
         CancelText="cancel"  
         UpdateText="OK" 
         EditText="edit"
         />
         <asp:BoundColumn DataField="pseudo"   />
        <asp:BoundColumn DataField="english" />
        <asp:BoundColumn DataField="italian" />
        <asp:BoundColumn DataField="pseudo"     ItemStyle-CssClass="pseudoasid" ItemStyle-Width="1" FooterStyle-Width="1" HeaderStyle-Width="1"  ReadOnly="true"/>

       </Columns>
       </asp:datagrid>
   <br />
   <table width="100%">
    <tr>
     <td>pseudo</td>
     <td><asp:textbox width="100%" runat="server" id="tboxpseudo" ClientIDMode="Static" /></td>
    </tr>
    <tr>
     <td>english</td>
    <td><asp:textbox width="100%" runat="server" id="tboxeng"/></td>
    </tr>
    <tr>
     <td>italian</td>
     <td><asp:textbox width="100%" runat="server" id="tboxita"/></td>
    </tr>
<tr>
 <td colspan="2" align="center">
   <asp:Button Text="aggiungi" runat="server" OnClick="button_click"   style="width:100px"/>
 </td>
</tr>
   </table>
   
  </form>

 </body>
</html>