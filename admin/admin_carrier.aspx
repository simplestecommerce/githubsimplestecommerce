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


<script runat="server">

 int maxLenNome = 50; // nome corriere

 void checkedchanged(object o, EventArgs e)
 {

  bool enabled = ((CheckBox)o).Checked;

  DataGridItem di = (DataGridItem)(((System.Web.UI.WebControls.CheckBox)o).Parent.Parent);
  int id = int.Parse(di.Cells[0].Text);

  simplestecommerce.helpDb.nonQuery(
      "update tcorrieri set c_enabled=@enabled where c_id=@id",
      new SqlParameter("enabled", enabled),
      new SqlParameter("id", id)
      );


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
      lbl.Text = simplestecommerce.lingua.getfromdbbylanguage(arrfrontendlanguages[rip].ToString(), dr["c_nome"].ToString());
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
    if (tbox.Text == "") erremptyname += "<br>insert carrier in " + tb.HeaderText;
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




  string sql = "INSERT INTO tcorrieri (c_nome) VALUES (@nome)";
  simplestecommerce.helpDb.nonQuery(sql, new SqlParameter("nome", nome));

  lblerr.Text = "data saved";
  lblerr.ForeColor = System.Drawing.Color.Blue;

  
  bind();
 }




 void bind()
 {

  DataTable dt = simplestecommerce.corrieri.getallcarrier();
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

  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; carriers";


  if (!Page.IsPostBack)
  {
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


    <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" />


    <fieldset>

     <legend>new carrier
     </legend>
     <table width="100%">
      <tr>
       <td valign="bottom">

<asp:Panel runat="server" ID="mypanel" />
       </td>
       <td valign="bottom">

        <asp:Button OnClick="buttNewCorriere_click" ID="buttNewCorriere" runat="server" class="bottone" Text="ADD CARRIER" />

       </td>

      </tr>

     </table>

    </fieldset>
    <br />
    <br />

    <asp:DataGrid
     ID="dGrid"
     GridLines="None"
     CellSpacing="1"
     runat="server"
     Width="100%"
     AutoGenerateColumns="false"
      OnItemDataBound="grid_databound"
     OnCancelCommand="dGrid_cancel"
     OnEditCommand="dGrid_edit">
     <HeaderStyle CssClass="admin_sfondodark" />
     <ItemStyle CssClass="admin_sfondo" />
     <AlternatingItemStyle CssClass="admin_sfondobis" />
     <EditItemStyle CssClass="small" />
     <Columns>
      <asp:BoundColumn DataField="c_id" ReadOnly="true" HeaderText="ID" />

      <asp:TemplateColumn>
       <HeaderStyle HorizontalAlign="Center" />
       <HeaderTemplate>name</HeaderTemplate>

       <ItemTemplate>

<asp:Panel runat="server" ID="mypanel" />

       </ItemTemplate>


      </asp:TemplateColumn>

      <asp:TemplateColumn>
       <HeaderStyle HorizontalAlign="Center" />
       <ItemStyle HorizontalAlign="Center" />
       <HeaderTemplate>enabled</HeaderTemplate>
       <ItemTemplate>


        <asp:CheckBox runat="server" ID="cboxenabled" Checked='<%#(bool)Eval("c_enabled") %>' AutoPostBack="true" OnCheckedChanged="checkedchanged" />

       </ItemTemplate>

      </asp:TemplateColumn>

     </Columns>
    </asp:DataGrid>



    </ContentTemplate></asp:UpdatePanel>
 </form>
</asp:Content>
