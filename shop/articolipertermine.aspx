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


<%@ Page Language="C#" MasterPageFile="masterpage.master" ValidateRequest="true" %>

<%@ Import Namespace="simplestecommerce" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.Sql" %>
<script runat="server">

 int artPerPag;
 string termineIn;
 int pageIn;

 string searchCatValorizzata;

 void change(object o, EventArgs e)
 {
  datapager.SetPageProperties(0,datapager.PageSize, false);

  bindArticoli();
 }


 void ListView1_PagePropertiesChanging(object o, PagePropertiesChangingEventArgs e)
 {

  datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

  bindArticoli();
  
 }

 void listaarticoli_created(object sender,  ListViewItemEventArgs e)
 {
  if ( e.Item.ItemType == ListViewItemType.DataItem)
  {

   DataRowView drv = (DataRowView)(e.Item.DataItem);

   simplestecommerce.articolo art = new simplestecommerce.articolo(
                (int)drv["art_id"],
                ((simplestecommerce.Cart)Session["Cart"]).Listino.Id,
                ((simplestecommerce.Cart)Session["Cart"]).Listino.Sconto,
                ((simplestecommerce.Cart)Session["Cart"]).User.Sconto);


   Image img = (Image)e.Item.FindControl("articoloImgPreview");

   if (art.Preview == "")
    img.ImageUrl = "~/immagini/non_disponibile.gif";
   else
   {
    img.ImageUrl = art.Preview;
    img.Width = 52;
   }
   ((Label)e.Item.FindControl("lblmarca")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.articoli.strMarca(art.Marca));
   ((Label)e.Item.FindControl("lbldisp")).Text = simplestecommerce.sicurezza.xss.getreplacedencoded(lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoDisponibilita[art.Disponibilita]));
   ((HyperLink)e.Item.FindControl("linkartname")).NavigateUrl = ResolveUrl(art.Linkart);
   ((HtmlAnchor)e.Item.FindControl("linkartimg")).HRef = ((HyperLink)e.Item.FindControl("linkartname")).NavigateUrl;
   ((HyperLink)e.Item.FindControl("linkartname")).Text = simplestecommerce.lingua.getforfrontendfromdb(art.Name);

   Label lblPrezzoArticolo = ((Label)e.Item.FindControl("lblprezzo"));

   if (art.Prezzobase == art.Prezzodoposcontoprodottoutentelistino)
   {
    // non c'è sconto
    lblPrezzoArticolo.Text = currencies.tostrusercurrency(art.Prezzobase);

   }
   else
   {
    //c'è sconto
    lblPrezzoArticolo.Text = "<strike>"
    + currencies.tostrusercurrency(art.Prezzobase).Replace(" ", "&nbsp;")
    + "</strike>" +
    "<br><font color=red><b>"
    + currencies.tostrusercurrency(art.Prezzodoposcontoprodottoutentelistino) +
    "</b></font>";
   }
  }
 }

 string searchCat()
 {


  string result = "-1";


  string sql = "SELECT cat_id from tcategorie where " +
  " cat_nome LIKE @termine AND cat_nascondi=0";
  SqlParameter p1 = new SqlParameter("@termine", "%" + termineIn + "%");
  DataTable dtcat = helpDb.getDataTable(sql, p1);

  foreach (DataRow drcat in dtcat.Rows)
  {
   if (result != "") result += ",";
   result += drcat["cat_id"].ToString();

   foreach (Category cat in simplestecommerce.Category.getChildCats((int)drcat["cat_id"], null))
   {
    if (result != "") result += ",";
    result += cat.Id.ToString();
   }

   return result;
   
  }
 
  return result;


 }

 void bindArticoli()
 {






  SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();




  SqlCommand cmd;
  cmd = new SqlCommand("getpertermine", cnn);
  cmd.CommandType = CommandType.StoredProcedure;

  SqlParameter myParameter = new SqlParameter();
  myParameter.ParameterName = "@termine";
  myParameter.Value = "%" + termineIn + "%";
  cmd.Parameters.Add(myParameter);
  cmd.Parameters.Add(new SqlParameter("@listino", ((Cart)Session["Cart"]).Listino.Id ));
  cmd.Parameters.Add(new SqlParameter("@CommaSeparated", searchCatValorizzata));
  cmd.Parameters.Add(new SqlParameter("@ordine", dlistord.SelectedValue ));
  cmd.Parameters.Add(new SqlParameter("@marca", dlistmarca.SelectedValue));


  SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

  DataTable dt = new DataTable();
  dt.Load(reader);

  datapager.PageSize = (int)Application["config_artPerPag"];

  
  listaarticoli.DataSource = dt;
  listaarticoli.DataBind();



  reader.Close();
  cnn.Close();

 }


 void prepare()
 {


  dlistord.Items.Add(new ListItem(lingua.getforfrontendbypseudo("resultsearch.orderby.select"), ""));
  dlistord.Items.Add(new ListItem(lingua.getforfrontendbypseudo("resultsearch.orderby.brand"), "marca"));
  dlistord.Items.Add(new ListItem(lingua.getforfrontendbypseudo("resultsearch.orderby.price"), "prezzo"));
  dlistord.Attributes["onLoad"] = "focus.blur()";


  // elenco marche per termine
  SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
  cnn.Open();
  SqlCommand cmd;
  cmd = new SqlCommand("getmarchepertermine", cnn);
  cmd.CommandType = CommandType.StoredProcedure;
  SqlParameter myParameter = new SqlParameter();
  myParameter.ParameterName = "@termine";
  myParameter.Value = "%" + termineIn + "%";
  cmd.Parameters.Add(myParameter);
  cmd.Parameters.Add(new SqlParameter("@CommaSeparated", searchCatValorizzata));
  SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
  dlistmarca.Items.Add(new ListItem(lingua.getforfrontendbypseudo("resultsearch.filter.any.brand"), "-1"));
  while (reader.Read())
  {
   dlistmarca.Items.Add(new ListItem(reader["art_marca"].ToString(), reader["art_marca"].ToString()));
  }
  reader.Close();
  cnn.Close();






  



 }



 void Page_Load()
 {


  artPerPag = (int)Application["config_artPerPag"];


  if (Request.QueryString["termine"]==null || Request.QueryString["termine"]=="" || Request.QueryString["termine"].ToString().Length < 3)
  {
   lblerr.Text = simplestecommerce.lingua.getforfrontendbypseudo("resultsearch.warning.type.more.characters.to.find");
   pholdertitleandfilter.Visible = false;
   return;
  }

  termineIn = (string)Request.QueryString["termine"];
  lblTermineTop.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(termineIn);

  
  



  searchCatValorizzata = searchCat();

  if (!IsPostBack) { 
   prepare();

   bindArticoli();
  }
 }

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">








 <table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
   <td><asp:Label runat="server" ID="lblerr" /></td>
  </tr>


  <asp:PlaceHolder runat="server" ID="pholdertitleandfilter" EnableViewState="true" ViewStateMode="Enabled" Visible="true">

  <tr>
   <td>
    <div style="margin-top: 12px; margin-bottom: 6px; font-size: 16px;">
     <%=lingua.getforfrontendbypseudo ("resultsearch.label.you.searched.for")%> <b><i>'<asp:Label ID="lblTermineTop" runat="server" />'</i></b>
    </div>
   </td>
  </tr>
  <tr>
   <td>

    <div align="center">
     <table width="100%">
      <tr>
       <td width="20%">&nbsp;</td>
       <td width="33%" align="right">
        <asp:DropDownList                 
         EnableViewState="true" ViewStateMode="Enabled"
         runat="server" ID="dlistmarca" CssClass="input" AutoPostBack="true" OnSelectedIndexChanged="change" />
       </td>
       <td width="7%">&nbsp;</td>
       <td width="33%" align="left">&nbsp;
        <asp:DropDownList 
        EnableViewState="true" ViewStateMode="Enabled"         
         runat="server" ID="dlistord" CssClass="input" AutoPostBack="true" OnSelectedIndexChanged="change" /><br>
       </td>
       <td width="20%">&nbsp;</td>
      </tr>
     </table>



    </div>
    <img src="~/immagini/spazio.gif" height="3"><br>
   </td>
  </tr>

  </asp:placeholder>

  <tr>
   <td>
    <asp:listview ID="listaarticoli" OnItemCreated="listaarticoli_created" runat="server"
      OnPagePropertiesChanging="ListView1_PagePropertiesChanging"
     >

     <ItemTemplate>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
       <tr>

        <td colspan="4" align="center" height="2">&nbsp;
        </td>
       </tr>

       <tr>
        <td width="110" align="left" valign="middle">
         <div style="padding: 4px">
          <a id="linkartimg" runat="server">
           <asp:Image BorderColor="#4B7795" BorderStyle="dotted" BorderWidth="1" ID="articoloImgPreview" runat="server" />
          </a>
         </div>
        </td>

        <td width="2" align="center"></td>

        <td width="300" align="left" valign="middle">
         <b>
          <asp:HyperLink ID="linkartname" runat="server" Style="font-size: 16px" /></b>

         <br>
         <%=lingua.getforfrontendbypseudo("resultsearch.products.label.brand")%>:
                                    <asp:Label ID="lblmarca" runat="server" />
         <br>

         <%=lingua.getforfrontendbypseudo("resultsearch.products.label.availability")%>:
                                                <b>
                                                 <asp:Label ID="lbldisp" runat="server" /></b>
        </td>
        <td>
         <span style="font-size: 14px; font-weight: bold; color: #FF8000">
          <asp:Label ID="lblPrezzoArticolo" runat="server" />
          <asp:Label ID="lblprezzo" runat="server" />
         </span>
        </td>
       </tr>

      </table>
     </ItemTemplate>
    
    </asp:listview>
   </td>
  </tr>

 </table>

 <div align="right">
 <asp:DataPager ID="datapager" runat="server" PagedControlID="listaarticoli" >
            <Fields>
                <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="paging"  />
            </Fields>
        </asp:DataPager>

 </div>


 <!-- fine parte sinistra-->
</asp:Content>










