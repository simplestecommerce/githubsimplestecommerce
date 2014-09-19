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

 int maxLenNome = 50; // nome corriere
 int riga = 0;


 void changeAttivo(object o, EventArgs e)
 {
  SqlConnection cnn;
  SqlCommand cmd;
  string sql;

  cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();

  for (int rip = 0; rip < dGrid.Items.Count; rip++)
  {
   int id = int.Parse(dGrid.Items[rip].Cells[0].Text);
   CheckBox cb = (CheckBox)((dGrid.Items[rip]).FindControl("cBoxAttivo"));


   sql = "UPDATE orderstatus set enabled=@enabled where id=@id";
   cmd = new SqlCommand(sql, cnn);
   cmd.Parameters.Add(new SqlParameter("@enabled", cb.Checked ? 1 : 0));
   cmd.Parameters.Add(new SqlParameter("@id", id));
   cmd.ExecuteNonQuery();



  }
  cnn.Close();
  bind();

 }

 void grid_databound(Object Sender, DataGridItemEventArgs e)
 {

  DataRowView dr = (DataRowView)e.Item.DataItem;

  if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
  {
   {
    TabContainer mytabcontainer = new TabContainer();
    mytabcontainer.ID = "tabcontainer";
    mytabcontainer.CssClass = "CustomTabStyle";


    ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
    for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
    {

     Label lbl = new Label();
     lbl.ID = "mylbl";
     if (dr != null)
     {
      lbl.Text = simplestecommerce.lingua.getfromdbbylanguage(arrfrontendlanguages[rip].ToString(), dr["name"].ToString());
     }
     AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
     mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
     mytabpanel.ID = "mytabpanel" + rip.ToString();
     mytabpanel.Controls.Add(lbl);
     mytabcontainer.Tabs.Add(mytabpanel);

    }
    ((Panel)(e.Item.FindControl("mypanel"))).Controls.Add(mytabcontainer);
   }
  }

 }



 void buttNewCorriere_click(object sender, EventArgs e)
 {
  string erremptyname = "";
  {
   TabContainer tc = (TabContainer)mypanel.Controls[0];
   foreach (TabPanel tb in tc.Tabs)
   {

    TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
    if (tbox.Text == "") erremptyname += "<br>insert mode of payment in " + tb.HeaderText;
   }

   if (erremptyname != "")
   {
    lblerr.Text += "<br>" + erremptyname;
    bind();
    return;
   }
  }
  
  
  string nome = "";

  {
   Panel p = mypanel;
   TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
   foreach (TabPanel tb in mytabcontainer.Tabs)
   {
    {
     TextBox mytextbox = (TextBox)(tb.FindControl("mytextbox"));
     if (nome.Length > 0) nome += "@@";
     nome += tb.HeaderText + "." + mytextbox.Text;
    }
   }
  }



  SqlConnection cnn;
  SqlCommand cmd;
  string sql;

  cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();

  sql = "INSERT INTO orderstatus (name) VALUES (@name)";
  cmd = new SqlCommand(sql, cnn);
  cmd.Parameters.Add(new SqlParameter("@name", nome));
  cmd.ExecuteNonQuery();

  cnn.Close();
  lblerr.Text = "data saved";
  lblerr.ForeColor = System.Drawing.Color.Blue;

  bind();
 }




 void bind()
 {

  DataTable dt = simplestecommerce.orderstatus.getAll();
  dGrid.DataSource = dt;
  dGrid.DataBind();

 }





 void dGrid_edit(object sender, DataGridCommandEventArgs e)
 {

  dGrid.EditItemIndex = e.Item.ItemIndex;
  bind();

 }


 void dGrid_cancel(object sender, DataGridCommandEventArgs e)
 {

  dGrid.EditItemIndex = -1;
  bind();
 }

 /*
 void dGrid_update (object sender, DataGridCommandEventArgs e) {

     bool inputValido=true;


     string nome="";

     nome = ((TextBox)e.Item.Cells[2].Controls[0]).Text ;

     int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

     simplestecommerce.orderstatus.update(id, nome);

     dGrid.EditItemIndex=-1;
     bind();
  }
  */



 void Page_Init()
 {

  {
   TabContainer mytabcontainer = new TabContainer();
   mytabcontainer.ID = "tabcontainer";
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
   mypanel.Controls.Add(mytabcontainer);
  }



 }


 void Page_Load()
 {



  if (!Page.IsPostBack)
  {
   ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; status of order";


   bind();

  }
 }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />


  <asp:UpdatePanel ID="PannelloDinamico" runat="server">
   <ContentTemplate>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1">
     <ProgressTemplate>
      <ajaxToolkit:AlwaysVisibleControlExtender
       ID="AlwaysVisibleControlExtender1"
       runat="server"
       TargetControlID="panelprogress"
       VerticalSide="Middle"
       HorizontalSide="Center">
      </ajaxToolkit:AlwaysVisibleControlExtender>
      <asp:Panel ID="panelprogress" runat="server">
       <img src="~/immagini/loading.gif" width="30" runat="server" />
      </asp:Panel>
     </ProgressTemplate>
    </asp:UpdateProgress>

        <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />


  <fieldset>
   <legend>new status of order
   </legend>



   <table width="100%" cellspacing="0" style="margin: 4px; padding: 4px;">
    <tr>
     <td align="left" valign="bottom">
<asp:panel runat="server" ID="mypanel" />
     </td>
     <td align="left" valign="bottom">
      <asp:Button OnClick="buttNewCorriere_click" ID="buttNewCorriere" runat="server" class="bottone" Text="ADD" />
     </td>


    </tr>
   </table>
  </fieldset>
  <br /><br />
  <asp:DataGrid
   GridLines="None"
   ID="dGrid"
   runat="server" Width="100%"
   AutoGenerateColumns="false"
   OnCancelCommand="dGrid_cancel"
   OnEditCommand="dGrid_edit"
   OnItemDataBound="grid_databound"
   ItemStyle-CssClass="admin_sfondo"
   AlternatingItemStyle-CssClass="admin_sfondobis"
   CellSpacing="1">
   <HeaderStyle CssClass="admin_sfondodark" />

   <Columns>

    <asp:BoundColumn DataField="id" ReadOnly="true" HeaderText="<b>ID</b>" />
    <asp:TemplateColumn HeaderText="<b>status of order</b>">
     <ItemTemplate>
      <asp:Panel runat="server" ID="mypanel" />
     </ItemTemplate>
    </asp:TemplateColumn>

    <asp:TemplateColumn HeaderText="<b>enabled</b>">
     <ItemTemplate>
      <center><asp:checkbox id="cBoxAttivo"   Checked=<%#((int)Eval("enabled"))==1%>   OnCheckedChanged="changeAttivo" AutoPostBack="true" runat="server" /></center>
     </ItemTemplate>
    </asp:TemplateColumn>


   </Columns>
  </asp:DataGrid>


    </ContentTemplate>
   </asp:UpdatePanel>

  <br>
  <br>
  <br>
 </form>
</asp:Content>
