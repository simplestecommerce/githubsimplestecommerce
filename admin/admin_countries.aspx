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
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<script runat="server">

 DataSet ds;
 void merchantregionchange(object o, EventArgs e)
 {


  RadioButton mySender = (RadioButton)o;
  DataGridItem row = (DataGridItem)(mySender.NamingContainer);
  int id = int.Parse(row.Cells[1].Text);

  simplestecommerce.helpDb.nonQuery(
   "update tconfig set config_idmerchantregion=@idmerchantregion",
   new SqlParameter("idmerchantregion", id));

  simplestecommerce.config.storeConfig();


  bindData();

 }



 void comando(object sender, DataGridCommandEventArgs e)
 {
  if (e.CommandName == "elimina")
  {
   string idregion = e.CommandArgument.ToString();

   if (int.Parse(idregion) == (int)simplestecommerce.config.getCampoByApplication("config_idmerchantregion"))
   {
    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "alert('please set another country as your country and then delete this country')", true); // "document.getElementById('tBoxNewStato').focus()", true);
    return;

   }



   string sql =
    "delete from tutenti where ut_idregion=@idregion or ut_spidregion=@idregion;" +
    "delete from tcart where guestidregion=@idregion or spidregion=@idregion;" +
    "delete from tregioni where r_id=@idregion;";
   SqlParameter p1 = new SqlParameter("@idregion", idregion);
   simplestecommerce.helpDb.nonQuery(sql, p1);

   bindData();
  }
 }
 void buttNewReg_click(object sender, EventArgs e)
 {

  if (tBoxNewStato.Text.Length > simplestecommerce.common.maxLenRegione)
  {
   lblerr.Text += "<br>max length for COUNTRY is " + simplestecommerce.common.maxLenRegione + " chars";
   return;
  }


  string strSql;
  SqlCommand cmd;
  SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();
  strSql = "select count(*) from tregioni where r_nome=@nome";
  cmd = new SqlCommand(strSql, cnn);
  cmd.Parameters.Add(new SqlParameter("@nome", tBoxNewStato.Text));
  bool esiste = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

  if (esiste)
  {
   cnn.Close();
   lblerr.Text = "country already exists";

  }
  else
  {
   strSql = "INSERT INTO tregioni (r_nome,r_zona) " +
   " VALUES (@nome,0)";
   cmd = new SqlCommand(strSql, cnn);
   cmd.Parameters.Add(new SqlParameter("@nome", tBoxNewStato.Text));
   cmd.ExecuteNonQuery();


   strSql = "select distinct (idtaxprofile) from taxrates";
   cmd = new SqlCommand(strSql, cnn);
   DataTable dtidtaxprofile = simplestecommerce.helpDb.getDataTableByOpenCnn(cnn, strSql);
   foreach (DataRow dridtaxprofile in dtidtaxprofile.Rows)
   {
    string strsql = "insert into taxrates (idtaxprofile, idregion) values (@idtaxprofile, (SELECT MAX(r_id) from tregioni) )";
    cmd = new SqlCommand(strsql, cnn);
    cmd.Parameters.AddWithValue("idtaxprofile", (int)dridtaxprofile[0]);
    cmd.ExecuteNonQuery();
   }

   cnn.Close();
   bindData();
  }

 }


 void checkedChange(object sender, EventArgs e)
 {

  CheckBox mySender = (CheckBox)sender;
  string qualeControllo = mySender.ID;
  DataGridItem row = (DataGridItem)(mySender.NamingContainer);
  int id = int.Parse(row.Cells[1].Text);
  int valore = (((CheckBox)(row.FindControl(qualeControllo))).Checked ? 1 : 0);

  string sql = "";

  sql = "UPDATE tregioni set " + qualeControllo + "=@valore where r_id=@id";

  SqlParameter p1 = new SqlParameter("@valore", valore);
  SqlParameter p2 = new SqlParameter("@id", id);
  simplestecommerce.helpDb.nonQuery(sql, p1, p2);
  //Response.Write(valore + "/" + idDb);
  bindData();
 }



 void bindData()
 {

  ds = simplestecommerce.admin.regioni.getRegioni();
  lista.DataSource = ds.Tables["regioni"];
  lista.DataBind();



 }





 void dGridReg_update(object sender, DataGridCommandEventArgs e)
 {
  /*
  bool inputValido=true;
  if (  ((TextBox)e.Item.Cells[2].Controls[0]).Text.Length > simplestecommerce.common.maxLenRegione) { lblerr.Text+="<br>La lunghezza consentita per la regione è di " + simplestecommerce.common.maxLenRegione + " caratteri"; inputValido=false; }

  if (!inputValido) return;

  int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

  string nome =  ((TextBox)e.Item.Cells[2].Controls[0]).Text;
  int zona = int.Parse( ((DropDownList)(e.Item.Cells[3].Controls[1])).SelectedItem.Value  )  ;

  simplestecommerce.admin.generale.updateRegione (id, nome, zona) ;

  dGridReg.EditItemIndex=-1;
  bindData();*/
 }





 void Page_Load()
 {


  if (!Page.IsPostBack)
  {
   ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; countries"; 

   bindData();
  }
 }

 protected void lista_ItemCommand(object source, DataGridCommandEventArgs e)
 {

 }
</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
  <br />


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
    <br>
    <asp:Panel ID="Panel1" runat="server" GroupingText="CREATE NEW COUNTRY" Width="520">
     country name
            <asp:TextBox runat="server" EnableViewState="false" Text="" ID="tBoxNewStato" class="input" Style="width: 300px" ClientIDMode="Static" />
     &nbsp;&nbsp;
        <asp:Button OnClick="buttNewReg_click" ID="buttNewReg" runat="server" class="bottone" Text="CREATE" />
    </asp:Panel>
    <br />
    <br />

    <asp:DataGrid GridLines="none" CellSpacing="1" ID="lista" runat="server" Width="100%" AutoGenerateColumns="false"
     OnItemCommand="comando">
     <HeaderStyle CssClass="admin_sfondodark" />
     <ItemStyle CssClass="admin_sfondo" />
     <AlternatingItemStyle CssClass="admin_sfondobis" />
     <EditItemStyle CssClass="small" />
     <Columns>

      <asp:TemplateColumn HeaderText="<center>delete</center>" ItemStyle-Width="80">
       <ItemTemplate>
        <asp:LinkButton ID="lButtDelete" HeaderText="Elimina" CommandArgument='<%#Eval("r_id") %>' CommandName="elimina" runat="server" Text="<center>delete</center>" />
        <ajaxToolkit:ConfirmButtonExtender runat="server" TargetControlID="lButtDelete" ConfirmText="This will delete also the orders and users associated to this country. Proceed?" />
       </ItemTemplate>
      </asp:TemplateColumn>

      <asp:BoundColumn ItemStyle-Width="30" DataField="r_id" HeaderText="ID" HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>

      <asp:BoundColumn DataField="r_nome" ReadOnly="true" HeaderText="country name" ItemStyle-Width="400" />


      <asp:TemplateColumn>
       <HeaderTemplate>
        <center>belongs to UE</center>
       </HeaderTemplate>
       <HeaderStyle Width="130" />
       <ItemTemplate>
        <asp:CheckBox runat="server" OnCheckedChanged="checkedChange" ID="r_ue" AutoPostBack="true" Checked='<%#(bool)Eval("r_ue") %>' />
       </ItemTemplate>
      </asp:TemplateColumn>


      <asp:TemplateColumn>
       <HeaderTemplate>
        <center>your country</center>
       </HeaderTemplate>
       <HeaderStyle Width="130" />
       <ItemTemplate>
        <asp:RadioButton runat="server" OnCheckedChanged="merchantregionchange" ID="radiobuttonmycountry" AutoPostBack="true" Checked='<%# (int)Eval("r_id")==(int)simplestecommerce.config.getCampoByApplication("config_idmerchantregion")  %>' />
       </ItemTemplate>
      </asp:TemplateColumn>


     </Columns>
    </asp:DataGrid>

   </ContentTemplate>
  </asp:UpdatePanel>

 </form>
</asp:Content>
