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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" Trace="false" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="estensioni" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<script runat="server">





 void buttNewCorriere_click(object sender, EventArgs e)
 {



  double cambio =-1;

  try
  {
   cambio = double.Parse(tBoxCambio.Text, simplestecommerce.admin.localization.primarynumberformatinfo);

  }
  catch
  {
   lblerr.Text = "please insert a number for exchange rate";
   return;

  }

  int decimali;
  if (!int.TryParse(TBOXdecimali.Text, out decimali))
  {
   lblerr.Text = "please insert how many decimal digits you want to display";
   return;
  }

  if (TBOXnome.Text == "")
  {

   lblerr.Text = "please insert the name of currency";
   return;

  }

  if (tboxdecimalseparatorsymbol.Text == "")
  {

   lblerr.Text = "please insert the decimal separator symbol";
   return;

  }



  SqlConnection cnn;
  SqlCommand cmd;
  string sql;

  cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();

  sql = "INSERT INTO tcurrencies (cambio, nome, decimalseparatorsymbol, decimali, groupseparatorsymbol) VALUES (@cambio,@nome, @decimalseparatorsymbol, @decimali,@groupseparatorsymbol)";
  cmd = new SqlCommand(sql, cnn);
  cmd.Parameters.Add(new SqlParameter("@cambio", cambio));
  cmd.Parameters.Add(new SqlParameter("@nome", TBOXnome.Text.Substring(0, 3, true)));
  cmd.Parameters.Add(new SqlParameter("@decimalseparatorsymbol", tboxdecimalseparatorsymbol.Text));
  cmd.Parameters.Add(new SqlParameter("@decimali", int.Parse(TBOXdecimali.Text)));
  cmd.Parameters.Add(new SqlParameter("@groupseparatorsymbol", tboxgroupseparatorsymbol.Text.Substring(0,3,true)));
  cmd.ExecuteNonQuery();

  cnn.Close();


  System.Web.HttpRuntime.UnloadAppDomain();
  
  bind();
 }




 void bind()
 {

  string sql;
  sql = "SELECT * FROM tcurrencies order by nome";
  DataTable dt = simplestecommerce.helpDb.getDataTable(sql);



  dGrid.DataSource = dt;
  dGrid.DataBind();



 }



 void dGrid_delete(object sender, DataGridCommandEventArgs e)
 {
  if (int.Parse(e.CommandArgument.ToString()) == (int)simplestecommerce.config.getCampoByDb("config_idmastercurrency"))
  {
   lblerr.Text = "this currency can't be deleted; before deleting this currency please set another currency as master currency";
   return;

  }


  simplestecommerce.helpDb.nonQuery("DELETE FROM tcurrencies WHERE id=@id", new SqlParameter("id", int.Parse(e.CommandArgument.ToString())));

  System.Web.HttpRuntime.UnloadAppDomain();

  bind();

 }


 void dGrid_command(object sender, DataGridCommandEventArgs e)
 {
  if (e.CommandName.ToString() == "setmaster")
  {

   string sql;
   sql = "update tcurrencies set cambio=1 where id=@id";
   simplestecommerce.helpDb.nonQuery(sql, new SqlParameter("id", int.Parse(e.CommandArgument.ToString())));

   sql = "update tconfig set config_idmastercurrency=@id";
   SqlParameter p1 = new SqlParameter("id", int.Parse(e.CommandArgument.ToString()));
   simplestecommerce.helpDb.nonQuery(sql, p1);
   simplestecommerce.config.storeConfig();
   
   System.Web.HttpRuntime.UnloadAppDomain();

   
   bind();



  }

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


 void update(object sender, DataGridCommandEventArgs e)
 {

  double cambio ;


  int id = Convert.ToInt32(e.Item.Cells[1].Text);
  if (id == (int)simplestecommerce.config.getCampoByDb("config_idmastercurrency"))
  {

   cambio = 1;

  }
  else
  {

   try
   {
    cambio = double.Parse(((TextBox)e.Item.Cells[3].FindControl("tboxnewcambio")).Text, simplestecommerce.admin.localization.primarynumberformatinfo);

   }
   catch
   {

    cambio = -1;
   }
  }

  int decimali;
  if (!int.TryParse((((TextBox)e.Item.Cells[6].Controls[0]).Text), out decimali))
  {
   lblerr.Text = "please insert how many decimal digits you want";
   return;
  }
  decimali = int.Parse(((TextBox)e.Item.Cells[6].Controls[0]).Text);


  
  if ( e.Item.Cells[2].Text == "")
  {

   lblerr.Text = "please insert the name of currency";
   return;

  }
  string nome = e.Item.Cells[2].Text.Substring(0, 3, true);

  if (((TextBox)e.Item.Cells[4].Controls[0]).Text == "")
  {

   lblerr.Text = "please insert the decimal separator symbol";
   return;

  }
  string decimalseparatorsymbol = ((TextBox)e.Item.Cells[4].Controls[0]).Text.Substring(0, 5, true);
  string groupseparatorsymbol = ((TextBox)e.Item.Cells[5].Controls[0]).Text.Substring(0, 5, true);



  string sql = "UPDATE tcurrencies SET" +
    " cambio=@cambio, nome=@nome, decimalseparatorsymbol=@decimalseparatorsymbol, groupseparatorsymbol=@groupseparatorsymbol, decimali=@decimali" +
    " WHERE id=@id";

  SqlParameter p1 = new SqlParameter("@cambio", cambio);
  SqlParameter p2 = new SqlParameter("@nome", nome);
  SqlParameter p3 = new SqlParameter("@decimalseparatorsymbol", decimalseparatorsymbol);
  SqlParameter p3bis = new SqlParameter("@groupseparatorsymbol", groupseparatorsymbol);
  SqlParameter p4 = new SqlParameter("@decimali", decimali);
  SqlParameter p5 = new SqlParameter("@id", id);
  simplestecommerce.helpDb.nonQuery(sql, p1, p2, p3, p3bis, p4, p5);


  dGrid.EditItemIndex = -1;
  System.Web.HttpRuntime.UnloadAppDomain();

  bind();
 }






 void Page_Load()
 {


  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; currencies";


  if (!Page.IsPostBack) bind();

 }
         

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
  <br />
  <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />

    <asp:Panel GroupingText="ADD NEW CURRENCY" Width="100%" runat="server" DefaultButton="buttNewCorriere">


     <table>
    <tr>
     <td width="300">Currency code (<a target="_blank" href='http://en.wikipedia.org/wiki/ISO_4217#Active_codes'>3-character ISO-4217</a>)

     </td>
     <td>
      <asp:TextBox ID="TBOXnome" Style="width: 100%" CssClass="input" runat="server" /></td>
    </tr>
    <tr>
     <td >Decimal Separator symbol
     </td>
     <td>
      <asp:TextBox ID="tboxdecimalseparatorsymbol" Style="width: 50px" CssClass="input" runat="server" Text="," /></td>
    </tr>
    <tr>
     <td >Decimal Digits
     </td>
     <td>
      <asp:TextBox ID="TBOXdecimali" Style="width: 100px" CssClass="input" runat="server" Text="2" /></td>
    </tr>
    <tr>
     <td >Group separator symbol
     </td>
     <td>
      <asp:TextBox ID="tboxgroupseparatorsymbol" Style="width: 100px" CssClass="input" runat="server" Text="." /></td>
    </tr>

    <tr>
     <td>Exchange rate new currency/master currency
     </td>
     <td>
      <asp:TextBox Style="width: 100px" runat="server" EnableViewState="false" Text="" ID="tBoxCambio" class="input" />
     </td>
    </tr>
    <tr>
     <td colspan="2">
      <asp:Button OnClick="buttNewCorriere_click" ID="buttNewCorriere" runat="server" class="bottone" Text="ADD" />

     </td>
    </tr>
   </table>

  </asp:panel>

  <asp:Panel GroupingText="ALL SUPPORTED CURRENCIES" Width="100%" runat="server" DefaultButton="buttNewCorriere">

   <asp:DataGrid GridLines="None" CellSpacing="1" ID="dGrid" runat="server" Width="100%" AutoGenerateColumns="false"
     OnCancelCommand="dGrid_cancel" 
    OnEditCommand="dGrid_edit" 
     OnUpdateCommand="update" 
    OnDeleteCommand="dGrid_delete" 
    OnItemCommand="dGrid_command">
    <HeaderStyle CssClass="admin_sfondodark" />
    <ItemStyle CssClass="admin_sfondo" />
    <AlternatingItemStyle CssClass="admin_sfondobis" />
    <EditItemStyle CssClass="small" />
    <Columns>
     <asp:EditCommandColumn CancelText="cancel" UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" />
     <asp:BoundColumn DataField="id" ReadOnly="true" HeaderText="<b>ID</b>" />
     <asp:BoundColumn DataField="nome" ReadOnly="true" HeaderText="<b>currency</b>" />

     <asp:TemplateColumn>
      <HeaderTemplate><center><b>exchange rate<br />currency/master currency</b></center></HeaderTemplate>
      <ItemTemplate>
       <asp:Label runat="server" Text='<%#((double)Eval("cambio"))==-1? "N/A": Eval("cambio").ToString() %>' />
      </ItemTemplate>

      <EditItemTemplate>
       <asp:TextBox runat="server" ID="tboxnewcambio" Text='<%#((double)Eval("cambio"))==-1? "": Eval("cambio").ToString() %>' />
      </EditItemTemplate>
     </asp:TemplateColumn>

     <asp:BoundColumn DataField="decimalseparatorsymbol" ReadOnly="false" HeaderText="<b>decimal<br>separator symbol</b>" />
     <asp:BoundColumn DataField="groupseparatorsymbol" ReadOnly="false" HeaderText="<b>group<br>separator symbol</b>" />
     <asp:BoundColumn DataField="decimali" ReadOnly="false" HeaderText="<b>decimal<br>digits</b>" />
     <asp:TemplateColumn>
      <HeaderTemplate><b>delete</b></HeaderTemplate>
      <ItemTemplate>
       <center><asp:linkbutton text="delete" runat="server"  CommandName="delete" CommandArgument=<%#Eval("id") %> /></center>
      </ItemTemplate>
     </asp:TemplateColumn>
     <asp:TemplateColumn>
      <HeaderTemplate><b>set master currency</b></HeaderTemplate>
      <ItemTemplate>
       <center>
                   <asp:linkbutton visible=<%#(int)Eval("id")!=(int)simplestecommerce.config.getCampoByDb("config_idmastercurrency") %> text="set as master" runat="server"  CommandName="setmaster" CommandArgument=<%#Eval("id") %> />
                   <asp:Label runat="server" text="MASTER" visible=<%#(int)Eval("id")==(int)simplestecommerce.config.getCampoByDb("config_idmastercurrency") %> />
               </center>
      </ItemTemplate>
     </asp:TemplateColumn>


    </Columns>
   </asp:DataGrid>


  </asp:Panel>


 </form>
</asp:Content>
