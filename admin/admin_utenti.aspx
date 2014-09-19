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

 int quantiPerPag = 20;

 DataSet ds;





 private void itemdatabound(Object Sender, DataGridItemEventArgs e)
 {

  if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
  {
   LinkButton myButton = (LinkButton)e.Item.FindControl("lButtDelete");
   myButton.Attributes.Add("onclick", "return confirm_delete();");
  }

 }



 void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
 {
  grid.CurrentPageIndex = e.NewPageIndex;
  bindData();

 }


 void buttFiltra_click(object sender, EventArgs e)
 {

  bindData();
 }


 void bindData()
 {
  SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

  string strSql;
  strSql = "SELECT * FROM tutenti" +
  " WHERE ut_firstname LIKE @firstname AND ut_secondname like @secondname AND ut_email LIKE @email";


  DataSet ds = new DataSet();

  SqlDataAdapter da = new SqlDataAdapter();
  SqlCommand cmd = new SqlCommand(strSql, cnn);

  SqlParameter myParameter0 = new SqlParameter();
  myParameter0.ParameterName = "@firstname";
  myParameter0.Value = "%" + tboxfirstname.Text + "%";
  cmd.Parameters.Add(myParameter0);

  SqlParameter myParameter0bis = new SqlParameter();
  myParameter0bis.ParameterName = "@secondname";
  myParameter0bis.Value = "%" + tboxsecondname.Text + "%";
  cmd.Parameters.Add(myParameter0bis);

  SqlParameter myParameter1 = new SqlParameter();
  myParameter1.ParameterName = "@email";
  myParameter1.Value = "%" + tboxemail.Text + "%";
  cmd.Parameters.Add(myParameter1);



  da.SelectCommand = cmd;

  cnn.Open();
  da.Fill(ds, "utenti");
  cnn.Close();

  grid.DataSource = ds.Tables[0];
  grid.DataBind();

 }




 void grid_command(object sender, DataGridCommandEventArgs e)
 {

  
  
  
  string email = e.CommandArgument.ToString();

  if (e.CommandName == "delete")
  {




   string sql = "delete  FROM tutenti WHERE ut_email=@email";
   simplestecommerce.helpDb.nonQuery(sql, new SqlParameter("email", email));
   grid.CurrentPageIndex = 0;
   bindData();

  }
  else if (e.CommandName.ToString() == "edit")
  {
   Response.Redirect("~/admin/admin_user.aspx?id=" + Server.UrlEncode(e.CommandArgument.ToString()));
   
  }
  
  
 }




 void Page_Load()
 {



  ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; users";


  if (!Page.IsPostBack) bindData();



 }

</script>


<asp:Content ContentPlaceHolderID="headcontent" runat="server">
 <script>
  function confirm_delete() {
   if (confirm("All the orders of this user will also be deleted. Do you want to proceed?") == true)
    return true;
   else
    return false;
  }
 </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
  <br />
  <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />










  <fieldset>
   <legend>filter users</legend>

   <table width="100%">
    <tr>
     <td>&nbsp;first name:
       <asp:TextBox ID="tboxfirstname" runat="server" EnableViewState="false" CssClass="input" />
      &nbsp;second name:
       <asp:TextBox ID="tboxsecondname" runat="server" EnableViewState="false" CssClass="input" />
      &nbsp;nick/email:
       <asp:TextBox ID="tboxemail" runat="server" EnableViewState="false" CssClass="input" />
      &nbsp;<asp:Button ID="buttFiltra" runat="server" Text=" FILTER " class="bottone" OnClick="buttFiltra_click" />
     </td>
    </tr>
   </table>
  </fieldset>

  <br>

  <asp:DataGrid
   GridLines="None"
   CellSpacing="1"
   ID="grid"
   runat="server"
   Width="100%"
   AutoGenerateColumns="false"
   OnItemCommand="grid_command"
   AllowPaging="true"
   PagerStyle-Mode="NumericPages"
   PageSize="<%# quantiPerPag%>"
   OnPageIndexChanged="Grid_Change"
   OnItemDataBound="itemdatabound">
   <HeaderStyle CssClass="admin_sfondodark" />
   <ItemStyle CssClass="admin_sfondo" />
   <AlternatingItemStyle CssClass="admin_sfondobis" />
   <EditItemStyle CssClass="small" />
   <Columns>

    <asp:TemplateColumn>
     <ItemStyle HorizontalAlign="Center" />
     <HeaderStyle HorizontalAlign="Center" />
     <ItemTemplate>
      <asp:LinkButton CommandArgument=<%# simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_id").ToString()) %>  HeaderText="<center><b>edit</b></center>" CommandName="edit" runat="server" Text="<img src=../immagini/edit.gif Border=0 >" />
     </ItemTemplate>
    </asp:TemplateColumn>

    <asp:BoundColumn DataField="ut_email" ReadOnly="true" HeaderText="<b>nick/email</b>" />
    
    <asp:TemplateColumn HeaderText="<center><b>enabled</b></center>">
     <ItemStyle HorizontalAlign="center" />
     <ItemTemplate>
      <asp:Label ID="lblUtBloccato" Text='<%#((bool)Eval("ut_bloccato"))?"disabled":"enabled" %>' runat="server" />
     </ItemTemplate>
    </asp:TemplateColumn>

     <asp:TemplateColumn>
     <HeaderTemplate><center><b>first name</b></center></HeaderTemplate>
     <ItemStyle HorizontalAlign="left" />
     <ItemTemplate>
      <asp:label runat="server" Text=<%# simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_firstname").ToString()) %> />
     </ItemTemplate>
    </asp:TemplateColumn>

     <asp:TemplateColumn>
     <HeaderTemplate><center><b>second name</b></center></HeaderTemplate>
     <ItemStyle HorizontalAlign="left" />
     <ItemTemplate>
      <asp:label runat="server" Text=<%# simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_secondname").ToString()) %> />
     </ItemTemplate>
    </asp:TemplateColumn>


     <asp:TemplateColumn>
     <HeaderTemplate><center><b>city</b></center></HeaderTemplate>
     <ItemStyle HorizontalAlign="left" />
     <ItemTemplate>
      <asp:label runat="server" Text=<%# simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_city").ToString()) %> />
     </ItemTemplate>
    </asp:TemplateColumn>


    <asp:BoundColumn DataField="ut_timestamp" ReadOnly="true" HeaderText="<b>registration date</b>" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="right" />


    <asp:TemplateColumn>
     <ItemStyle HorizontalAlign="Center" />
     <HeaderStyle HorizontalAlign="Center" />
     <ItemTemplate>
      <asp:LinkButton ID="lButtDelete" CommandArgument=<%#simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_id").ToString()) %> CommandName="delete" runat="server" Text="<img src=../immagini/delete.gif Border=0 >" />
     </ItemTemplate>
    </asp:TemplateColumn>


   </Columns>
  </asp:DataGrid>





 </form>
</asp:Content>
