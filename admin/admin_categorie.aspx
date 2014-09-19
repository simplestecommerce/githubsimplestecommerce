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


 private void item_Created(Object Sender, DataGridItemEventArgs e)
 {

  if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
  {

   LinkButton myButton = (LinkButton)e.Item.FindControl("lButtDelete");
   myButton.Attributes.Add("onclick", "return confirm_delete();");



   simplestecommerce.admin.Category c = (simplestecommerce.admin.Category)e.Item.DataItem;

   Image myImg = (Image)e.Item.FindControl("img");
   if (c.img == null || c.img == "") myImg.ImageUrl = ResolveUrl("~/immagini/non_disponibile.gif");
   else myImg.ImageUrl = c.img;

   LinkButton linkButtModifica = (LinkButton)e.Item.FindControl("linkButtModifica");
   linkButtModifica.CommandName = c.Level.ToString();






   Label lblpathcat = (Label)(e.Item.FindControl("lblpathcat"));
   lblpathcat.Text = siglaCatPadre(c.Id);

   Label lblId = (Label)(e.Item.FindControl("lblId"));
   lblId.Text = c.Id.ToString();

   Label lblVisibile = (Label)(e.Item.FindControl("lblVisibile"));
   lblVisibile.Text = (c.visibile ? "visible" : "INVISIBLE");



  }

 }




 void bindData()
 {

  lista.DataSource = simplestecommerce.admin.categorie.getRamo(0, null);
  lista.DataBind();
 }



 string siglaCatPadre(int catId)
 {
  ArrayList arrPathCat = simplestecommerce.admin.categorie.getPathCat(catId, null);

  string catPadreName = "";

  for (int i = 0; i < arrPathCat.Count; i++)
  {
   if (catPadreName.Length > 0)
   {
    catPadreName += " --> ";
   }
   catPadreName += simplestecommerce.lingua.getinadminlanguagefromdb(((simplestecommerce.admin.Category)arrPathCat[i]).Name);
  }
  return catPadreName;
 }













 void comando(object sender, DataGridCommandEventArgs e)
 {

  if (e.CommandName != "delete")
  {

   string livello = e.CommandName.ToString();

   int idCat = int.Parse(((Label)(e.Item.FindControl("lblId"))).Text);

   Response.Redirect("admin_catsottocat.aspx?id=" + idCat + "&livello=" + livello);
  }
 }

 void dGridRep_delete(object sender, DataGridCommandEventArgs e)
 {

  if (((bool)simplestecommerce.config.getCampoByApplication("config_demo")))
  {
   Label lbl = lblEsito;
   lbl.Text = "Function disabled on demo";
   lbl.ForeColor = System.Drawing.Color.Red;
   return;
  }
  int idCat = int.Parse(((Label)(e.Item.FindControl("lblId"))).Text);

  SqlConnection cnn;
  SqlCommand cmd;
  string strSql;

  cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();


  ArrayList ar = simplestecommerce.admin.categorie.getRamo(idCat, null);

  foreach (simplestecommerce.admin.Category c in ar)
  {




   strSql = "delete  FROM tcategorie" +
   " WHERE cat_id=@idcat";
   cmd = new SqlCommand(strSql, cnn);
   cmd.Parameters.Add(new SqlParameter("@idCat", c.Id));
   cmd.ExecuteNonQuery();

  }

  strSql = "delete  FROM tcategorie" +
  " WHERE cat_id=@idcat";
  cmd = new SqlCommand(strSql, cnn);
  cmd.Parameters.Add(new SqlParameter("@idCat", idCat));
  cmd.ExecuteNonQuery();

  cnn.Close();





  simplestecommerce.caching.cachevisiblecategories("force");


  lblEsito.Text = "Category deleted";



  bindData();

 }





 void buttNewCat_click(object sender, EventArgs e)
 {


  Response.Redirect("admin_catsottocat.aspx?livello=0");


 }








 void lista_edit(object sender, DataGridCommandEventArgs e)
 {

  //            lista.EditItemIndex = e.Item.ItemIndex;
  //            bindData();

  int idSottocat = int.Parse(e.Item.Cells[1].Text);

  Response.Redirect("admin_catsottocat.aspx?livello=1&id=" + idSottocat);


 }



 void buttNewSottocat_click(object sender, EventArgs e)
 {


  Response.Redirect("admin_catsottocat.aspx?livello=1");



 }


 void Page_Init()
 {



 }

 void Page_Load() {


    ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; categories"; 

                    
                    
                       
                      if (!Page.IsPostBack) bindData();

                   }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">

 <script>
  function confirm_delete() {
   if (confirm("All the subcategories included in this category and all the products included in this category will be deleted. Confirm?") == true)
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
  <asp:Label ID="lblErr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />
  <div align="center">
   <asp:Label EnableViewState="false" ID="lblErrore" Font-Size="Large" ForeColor="Red" runat="server" /></div>
  <div align="center">
   <asp:Label EnableViewState="false" ID="lblEsito" Font-Size="Large" runat="server" CssClass="esito" /></div>

  <br>
  <br>
  <center>
        <!--<asp:button class="bottone" id="buttNewCat" onclick="buttNewCat_click" runat="server" text="CREA CATEGORIA"></asp:button>-->
        <asp:button class="bottone" id="buttNewSottocat" onclick="buttNewSottocat_click" runat="server" text="CREATE CATEGORY OR SUBCATEGORY"></asp:button>
        </center>
  <br />
  <br />
  <br />

  <asp:DataGrid GridLines="None" CellSpacing="1" ID="lista" runat="server" Width="100%"
   AutoGenerateColumns="false" OnDeleteCommand="dGridRep_delete" OnItemDataBound="item_Created" OnItemCommand="comando">
   <HeaderStyle CssClass="admin_sfondodark" />
   <ItemStyle CssClass="admin_sfondo" />
   <EditItemStyle CssClass="small" />
   <Columns>

    <asp:TemplateColumn HeaderText="<b>modify</b>">
     <ItemStyle Width="50" />
     <ItemTemplate>
      <center><asp:linkbutton ID="linkButtModifica" 
                    runat=server
                    Text="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" 
                    /></center>
     </ItemTemplate>
    </asp:TemplateColumn>

    <asp:TemplateColumn HeaderText="<b>ID category</b>">
     <ItemStyle Width="20" />
     <ItemTemplate>
      <center><asp:label id="lblId" runat="server"  /></center>
     </ItemTemplate>
    </asp:TemplateColumn>


    <asp:TemplateColumn HeaderText="<b>category image</b>">
     <ItemStyle Width="44" />
     <ItemTemplate>
      <center><asp:image id="img" width="45" Height="45"  runat="server"  style="margin:4px; border:solid 1 px #aaa" /></center>
     </ItemTemplate>
    </asp:TemplateColumn>


    <asp:TemplateColumn HeaderText="&nbsp;<b>name of category</b>">
     <ItemStyle Width="50%" />
     <ItemTemplate>
      <asp:Label ID="lblpathcat" runat="server" />
     </ItemTemplate>
    </asp:TemplateColumn>

    <asp:TemplateColumn HeaderText="<b>visible</b>">
     <ItemTemplate>
      <center><asp:label ID="lblVisibile" runat="server" /></center>
     </ItemTemplate>
    </asp:TemplateColumn>


    <asp:TemplateColumn>
     <HeaderTemplate><b>delete</b></HeaderTemplate>
     <ItemStyle Width="40"></ItemStyle>
     <ItemTemplate>
      <center><asp:linkbutton id="lButtDelete" commandname="delete" runat="server" Text="<img src=../immagini/delete.gif Border=0 >"  /></center>
     </ItemTemplate>
    </asp:TemplateColumn>
   </Columns>
  </asp:DataGrid>








 </form>
</asp:Content>
