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

<%@ MasterType VirtualPath="~/admin/admin_master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<script runat="server">

 int idArt;
 int qualeVar;
 double ivaPerCento;
 void savechangestovariationname_click(object o, EventArgs e)
 {
  string missingerror="";
  for (int rip = 0; rip < gridvar.Items.Count; rip++)
  {
   Panel p = ((Panel)gridvar.Items[rip].FindControl("panelvariationname"));
   TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
   foreach (TabPanel tb in mytabcontainer.Tabs)
   {
     TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
     if (tbox.Text == "")
     {
      missingerror+= "<br>insert variation name in " + tb.HeaderText + " for variation ID " + gridvar.Items[rip].Cells[1].Text;
     }
   }
  }

  if (missingerror.Length > 0)
  {

   lblerr.Text = missingerror;
   return;
  }
  
  for (int rip = 0; rip < gridvar.Items.Count; rip++)
  {
      string variationname = "";
      Panel p = ((Panel)gridvar.Items[rip].FindControl("panelvariationname"));
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      foreach (TabPanel tb in mytabcontainer.Tabs)
      {
       {
        TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
        if (variationname.Length > 0) variationname += "@@";
        variationname += tb.HeaderText + "." + tbox.Text;
       }
      }
   
      int id = int.Parse(gridvar.Items[rip].Cells[1].Text);

      simplestecommerce.helpDb.nonQuery("update tvarianti set nome=@nome where id=@id", new SqlParameter("nome", variationname), new SqlParameter("id", id));


  } // end for
  bindvarianti();

 }
 void gridvar_databound(object o, DataGridItemEventArgs e)
 {
  if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item) {

   DataRowView dr = (DataRowView)e.Item.DataItem;
   
   TabContainer mytabcontainer = new TabContainer();
    mytabcontainer.ID = "mytabcontainer";
    mytabcontainer.CssClass = "CustomTabStyle";


    ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
    for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
    {

     TextBox mytextbox = new TextBox();
     mytextbox.ID = "mytextbox" ;
     mytextbox.CssClass = "input";
     mytextbox.Attributes["style"] = "width:100%";
     if (dr != null) mytextbox.Text = simplestecommerce.lingua.getfromdbbylanguage( (string)arrfrontendlanguages[rip],  dr["nome"].ToString());
     mytextbox.ValidateRequestMode=System.Web.UI.ValidateRequestMode.Disabled;
     AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
     mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
     mytabpanel.ID = "mytabpanel" + rip.ToString();
     mytabpanel.Controls.Add(mytextbox);
     mytabcontainer.Tabs.Add(mytabpanel);

    }
    ((Panel)e.Item.FindControl("panelvariationname")).Controls.Add(mytabcontainer);

   
  }
 }
 void gridvar_update(object sender, DataGridCommandEventArgs e)
 {

   ViewState["idvar"] =   int.Parse(e.Item.Cells[1].Text);
   bindoptions();

 }


 void gridvar_edit(object sender, DataGridCommandEventArgs e)
 {

  gridvar.EditItemIndex = e.Item.ItemIndex;

  bindvarianti();

 }


 void gridvar_cancel(object sender, DataGridCommandEventArgs e)
 {

  gridvar.EditItemIndex = -1;
  bindvarianti();
 }


 void gridvar_delete(object sender, DataGridCommandEventArgs e)
 {
  int id = int.Parse(e.Item.Cells[1].Text);
  simplestecommerce.helpDb.nonQuery("delete from tvarianti where id=@id", new SqlParameter("id", id));
  gridvar.EditItemIndex = -1;
  bindvarianti();

 }



 void copiavar_click(object sender, EventArgs e)
 {
 }












 void buttnewvar_click(object sender, EventArgs e)
 {


  Panel p = panelnewvariation;
  TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
  
  string missingerror="";
   foreach (TabPanel tb in mytabcontainer.Tabs)
   {
     TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
     if (tbox.Text == "")
     {
      missingerror += "<br>insert variation name in " + tb.HeaderText +" for new variation";
     }
   }
  

  if (missingerror.Length > 0)
  {

   lblerr.Text = missingerror;
   return;
  }
  
  
      string variationname = "";
      foreach (TabPanel tb in mytabcontainer.Tabs)
      {
       {
        TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
        if (variationname.Length > 0) variationname += "@@";
        variationname += tb.HeaderText + "." + tbox.Text;
       }
      }
   
  simplestecommerce.helpDb.nonQuery(
      "insert into tvarianti (nome,idart) values(@nome,@idart)",
      new SqlParameter("nome", variationname),
      new SqlParameter("idart", idArt)
      );

  bindvarianti();


 }



 // opzioni *******************************************************************************************************************

 void gridopz_databound(object o,  DataGridItemEventArgs e)
 {
  if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem) { 
  DataRowView dr = (DataRowView)e.Item.DataItem;

  TabContainer mytabcontainer = new TabContainer();
  mytabcontainer.ID = "mytabcontainer";
  mytabcontainer.CssClass = "CustomTabStyle";


  ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
  for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
  {

   Label mytextbox = new Label();
   mytextbox.ID = "mytextbox";
   if (dr != null) mytextbox.Text = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], dr["testo"].ToString());
   mytextbox.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
   AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
   mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
   mytabpanel.ID = "mytabpanel" + rip.ToString();
   mytabpanel.Controls.Add(mytextbox);
   mytabcontainer.Tabs.Add(mytabpanel);

  }
  ((Panel)e.Item.FindControl("paneloption")).Controls.Add(mytabcontainer);

  }
  
  
 }
 void buttNewOpz_click(object sender, EventArgs e)
 {
  int idvar;
  if (ViewState["idvar"] == null) return;
  idvar = (int)ViewState["idvar"];

  
  Panel p = panelnewoption;
  TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);

  string missingerror = "";
  foreach (TabPanel tb in mytabcontainer.Tabs)
  {
   TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
   if (tbox.Text == "")
   {
    missingerror += "<br>insert option in " + tb.HeaderText + " for new option";
   }
  }


  if (missingerror.Length > 0)
  {

   lblerr.Text = missingerror;
   return;
  }


  string option = "";
  foreach (TabPanel tb in mytabcontainer.Tabs)
  {
   {
    TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
    if (option.Length > 0) option += "@@";
    option += tb.HeaderText + "." + tbox.Text;
   }
  }

  if (tBoxPrezzoOpzIns.Text.Length < 1)
  {
   lblerr.Text = "insert price for option";
   bindoptions();

   return;
  }
  
  simplestecommerce.helpDb.nonQuery(
  "insert into topzioni (idvar, testo, prezzo) VALUES (@idvar, @nome, @prezzo)",
  new SqlParameter("idvar", idvar),
  new SqlParameter("nome", option),
  new SqlParameter("prezzo", double.Parse(tBoxPrezzoOpzIns.Text, simplestecommerce.admin.localization.primarynumberformatinfo))
  );

  int idnewoption = (int)simplestecommerce.helpDb.getDataTable("select max(id) from topzioni").Rows[0][0];




  // ricava il nomefile del campione
  if (fileImg0.PostedFile.FileName != "")
  {
   int punto = fileImg0.PostedFile.FileName.LastIndexOf(".");
   string estensione = fileImg0.PostedFile.FileName.Remove(0, punto + 1);
   string nomeFile = (string)Application["upload"] + "/sampleoption" + idnewoption.ToString() + "." + estensione;
   string percorsoFile;
   percorsoFile = Server.MapPath(nomeFile);



   // esegue l'upload

   string strexc = "";
   try
   {
    fileImg0.PostedFile.SaveAs(percorsoFile);
   }
   catch (Exception exc)
   {
    strexc = exc.ToString();
   }

   if (strexc != "") lblErrFile0.Text = "<center><br>problem in upload image on the server:<br>" + strexc + "</center>";
   else
   {
    // aggiorna foto campione
    simplestecommerce.helpDb.nonQuery(
    "update topzioni set img=@img where id=@idopz",
    new SqlParameter("img", nomeFile),
    new SqlParameter("idopz", idnewoption)
    );


   }
  }

  tBoxPrezzoOpzIns.Text = "";

  bindoptions();
 }


 void gridopz_edit(object sender, DataGridCommandEventArgs e)
 {

  gridopz.EditItemIndex = e.Item.ItemIndex;

  bindoptions();

 }


 void gridopz_cancel(object sender, DataGridCommandEventArgs e)
 {

  gridopz.EditItemIndex = -1;
  bindoptions();
 }

 void gridopz_update(object sender, DataGridCommandEventArgs e)
 {

  //double prezzoInsDb;


  //try { prezzoInsDb = double.Parse(((TextBox)e.Item.FindControl("tBoxPrezzoIns")).Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
  //catch
  //{
  // lblerr.Text = "please insert a number in field PRICE";
  // return;
  //}



  //TextBox TBOXopzioneEn = (TextBox)(gridopz.Items[gridopz.EditItemIndex].Cells[2].Controls[1].Controls[0].FindControl("opzioneEn"));
  //TextBox TBOXopzioneIt = (TextBox)(gridopz.Items[gridopz.EditItemIndex].Cells[2].Controls[1].Controls[1].FindControl("opzioneIt"));

  //string opz = TBOXopzioneEn.Text + "@@" + TBOXopzioneIt.Text;

  //int idOpz = int.Parse(e.Item.Cells[1].Text);

  //double prezzoDb = prezzoInsDb;



  //simplestecommerce.helpDb.nonQuery("update topzioni set testo=@testo, prezzo=@prezzo where id=@idopz",
  //    new SqlParameter("testo", TBOXopzioneEn.Text + "@@" + TBOXopzioneIt.Text),
  //    new SqlParameter("prezzo", prezzoDb),
  //    new SqlParameter("idopz", idOpz)
  //    );
  //gridopz.EditItemIndex = -1;
  //bindoptions();

 }

 void gridopz_delete(object sender, DataGridCommandEventArgs e)
 {
  int idOpz = int.Parse(e.Item.Cells[0].Text);
  simplestecommerce.helpDb.nonQuery("delete from topzioni where id=@idopz", new SqlParameter("idopz", idOpz));
  gridopz.EditItemIndex = -1;
  bindoptions();

 }










 void bindvarianti()
 {

  
  

  DataTable dtvar = simplestecommerce.helpDb.getDataTable("select * from tvarianti where idart=@idart", new SqlParameter("idart", idArt));
  if (dtvar.Rows.Count > 0)
  {
   gridvar.Visible = true;
   gridvar.DataSource = dtvar;
   gridvar.DataBind();
  }
  else gridvar.Visible = false;

 }


 void bindoptions()
 {
  if (ViewState["idvar"] != null)
  {
   tBoxPrezzoOpzIns.Text = "0";
   pholderoptions.Visible = true;

   int idvar = (int)ViewState["idvar"];

   SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
   cnn.Open();


   string sql0 = "SELECT nome from tvarianti where id=@idvar";
   DataRow drvar = simplestecommerce.helpDb.getDataTableByOpenCnn(cnn, sql0, new SqlParameter("idvar", idvar)).Rows[0];
   lblnomevar.Text = simplestecommerce.lingua.getinadminlanguagefromdb(drvar["nome"].ToString());

   string sql = "SELECT * FROM topzioni where idvar=@idvar ORDER BY id";
   DataTable dtopz = simplestecommerce.helpDb.getDataTableByOpenCnn(cnn, sql, new SqlParameter("idvar", idvar));

   cnn.Close();

   if (dtopz.Rows.Count > 0)
   {

    gridopz.DataSource = dtopz;

    gridopz.DataBind();

    gridopz.Visible = true;

   }
   else gridopz.Visible = false;


  }
  else
  {
   pholderoptions.Visible = false;
  }


 }

 void Page_Init(){
  { 
  TabContainer mytabcontainer = new TabContainer();
  mytabcontainer.ID = "mytabcontainer";
  mytabcontainer.CssClass = "CustomTabStyle";


  ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
  for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
  {

   TextBox mytextbox = new TextBox();
   mytextbox.ID = "mytextbox";
   mytextbox.CssClass = "input";
   mytextbox.Attributes["style"] = "width:100%";
   mytextbox.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
   AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
   mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
   mytabpanel.ID = "mytabpanel" + rip.ToString();
   mytabpanel.Controls.Add(mytextbox);
   mytabcontainer.Tabs.Add(mytabpanel);

  }
 panelnewvariation.Controls.Add(mytabcontainer);
  }

  {
   TabContainer mytabcontainer = new TabContainer();
   mytabcontainer.ID = "mytabcontainernewoption";
   mytabcontainer.CssClass = "CustomTabStyle";


   ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
   for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
   {

    TextBox mytextbox = new TextBox();
    mytextbox.ID = "mytextbox";
    mytextbox.CssClass = "input";
    mytextbox.Attributes["style"] = "width:100%";
    mytextbox.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
    AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
    mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
    mytabpanel.ID = "mytabpanel" + rip.ToString();
    mytabpanel.Controls.Add(mytextbox);
    mytabcontainer.Tabs.Add(mytabpanel);

   }
   panelnewoption.Controls.Add(mytabcontainer);
  }
 
  
  
 }


 void Page_Load()
 {
  idArt = Convert.ToInt32(Request.QueryString["idArt"]);

  if (!Page.IsPostBack)
  {
   ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>" +
       " &raquo; " +
       "<a href='admin_articoli.aspx'>products</a>" +
       " &raquo; " +
       "<a href='admin_articolo.aspx?idArt=" + idArt.ToString() + "'>product ID " + idArt.ToString() + "</a>" +
       " &raquo; " +
       " variations";
  }




  qualeVar = Convert.ToInt32(Request.QueryString["qualeVar"]);



 // gridvar.DataBind();

  bindvarianti();

  if (!Page.IsPostBack)
  {
   if (ViewState["idvar"] != null) Response.Write("viewstate=" + ViewState["idvar"].ToString());
  


  }
 }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
 <style>
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">

 <form runat="server">

  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="false" />
  <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" />

  <!-- variations---------------------------------------------------------------------------------------------------------------->

  <fieldset>
   <legend>Variations for this article</legend>
   <table width="100%" cellpadding="0" cellspacing="0">
    <tr>
     <td>

      <asp:DataGrid
       ID="gridvar"
       CellSpacing="1"
       GridLines="none"
       OnUpdateCommand="gridvar_update"
       OnDeleteCommand="gridvar_delete"
       OnItemDataBound="gridvar_databound"
       AlternatingItemStyle-CssClass="admin_sfondobis"
       ItemStyle-CssClass="admin_sfondo"
       PageSize="3"
       runat="server"
       Width="100%"
       AutoGenerateColumns="false">
       <HeaderStyle CssClass="admin_sfondodark" />
       <Columns>


        <asp:ButtonColumn
         ItemStyle-Width="70"
         ItemStyle-HorizontalAlign="Center"
         HeaderStyle-HorizontalAlign="Center"
         HeaderText="<b>insert options</b>"
         Text="<center><img src=../immagini/edit.gif Border=0 ></center>"
         CommandName="Update" />
        <asp:BoundColumn ItemStyle-Width="70" ReadOnly="true" DataField="id" HeaderText="<b>ID variation</b>" HeaderStyle-HorizontalAlign="Center" />


        <asp:TemplateColumn>
         <HeaderTemplate>
          <b>
           <center>name of variation</center>
          </b>
         </HeaderTemplate>

         <ItemTemplate>
          <asp:Panel runat="server" ID="panelvariationname"></asp:Panel>
         </ItemTemplate>


        </asp:TemplateColumn>

        <asp:ButtonColumn
         ItemStyle-Width="70"
         ItemStyle-HorizontalAlign="Center"
         HeaderStyle-HorizontalAlign="Center"
         HeaderText="<b>delete variation</b>"
         Text="<center><img src=../immagini/delete.gif Border=0 ></center>"
         CommandName="Delete" />
       </Columns>
      </asp:DataGrid>
     </td>
    </tr>
    <tr class="admin_sfondo">
     <td>
      <center><asp:Button runat="server" Text="save changes" OnClick="savechangestovariationname_click" CssClass="bottone" /></center>
     </td>
    </tr>
   </table>



   <br>
   <fieldset>
    <legend>Add new variation<b><asp:Label runat="server" ID="Label1" /></b></legend>

    <table>
     <tr>
      <td valign="bottom">
       <asp:Panel runat="server" ID="panelnewvariation" />
      </td>
      <td valign="bottom">
       <asp:Button CssClass="input" runat="server" Text="add new variation" OnClick="buttnewvar_click" />
      </td>
     </tr>
    </table>
   </fieldset>
  </fieldset>
  <br />
  <!-- options----------------------------------------------------------------------------------------------------------------------------------------------------------------------->
  <asp:PlaceHolder ID="pholderoptions" Visible="false" runat="server">

   <fieldset>
    <legend>Options for variation <b>
     <asp:Label runat="server" ID="lblnomevar" /></b></legend>









    <asp:DataGrid
     ID="gridopz"
     GridLines="none"
     OnDeleteCommand="gridopz_delete"
     OnCancelCommand="gridopz_cancel"
     OnUpdateCommand="gridopz_update"
     OnEditCommand="gridopz_edit"
      OnItemDataBound="gridopz_databound"
     CellSpacing="1"
     PageSize="3" CellPadding="4" runat="server" Width="100%" AutoGenerateColumns="false">
     <HeaderStyle CssClass="admin_sfondodark" />
     <ItemStyle CssClass="admin_sfondo" />
     <Columns>
      <asp:BoundColumn
       ReadOnly="true"
       DataField="id"
       HeaderText="IDoption"
       HeaderStyle-HorizontalAlign="Center"
       HeaderStyle-Font-Bold="true" />

      <asp:TemplateColumn HeaderText="option">
       <HeaderStyle HorizontalAlign="Center" Font-Bold="true" />
       <ItemTemplate>
         <asp:Panel runat="server" ID="paneloption" />
        </ItemTemplate>
      </asp:TemplateColumn>

      <asp:TemplateColumn HeaderText="extra price">
       <HeaderStyle HorizontalAlign="Center" Font-Bold="true" />
       <ItemTemplate>
        <div align="center">
         <%#(Eval("prezzo").ToString())%>
        </div>
       </ItemTemplate>
       </asp:TemplateColumn>
      <asp:TemplateColumn HeaderText="sample photo">
       <HeaderStyle HorizontalAlign="Center" Font-Bold="true" />
       <ItemTemplate>
        <div align="center">
         <asp:Image ID="Image1"
          runat="server"
          ImageUrl='<%#DataBinder.Eval (Container.DataItem,"img") %>'
          Visible='<%#DataBinder.Eval (Container.DataItem,"img").ToString()==""? false:true %>'
          Height="20"
          Width="20" />
         <br />
         <%#Eval("img").ToString()%>
        </div>
       </ItemTemplate>
      </asp:TemplateColumn>
      <asp:ButtonColumn
       HeaderStyle-Font-Bold="true"
       HeaderStyle-HorizontalAlign="Center"
       HeaderText="delete option"
       Text="<center><img src=../immagini/delete.gif Border=0 ></center>"
       CommandName="Delete" />
     </Columns>
    </asp:DataGrid>
    <br />


    <!-- insert new option-->
    <fieldset>
     <legend>add new option</legend>

     <table cellpadding="2" cellspacing="1" border="0">
      <tr>
       <td valign="bottom" width="210">
<asp:Panel runat="server" ID="panelnewoption" />
       </td>
       <td valign="bottom" style="width: 190px">extra price:&nbsp;<asp:TextBox
        Style="width: 60px"
        CssClass="input"
        ID="tBoxPrezzoOpzIns"
        runat="server" /><asp:Label ForeColor="red" EnableViewState="false" ID="lblPrezzoOpz" runat="server" />

       </td>
       <td valign="bottom" style="width: 250px">sample image&nbsp;<input
        class="input"
        style="width: 200px"
        runat="server"
        type="file"
        id="fileImg0"><asp:Label EnableViewState="false" ID="lblErrFile0" ForeColor="red" runat="server" />
       </td>
       <td style="width: 100px" valign="bottom">
        <asp:Button CssClass="input" OnClick="buttNewOpz_click" ID="buttNewVar" Text="add new option" runat="server" /></td>
      </tr>
     </table>
    </fieldset>




   </fieldset>
   <br />
   <br />
  </asp:PlaceHolder>

  <br />
  <br />

  <!--
    <fieldset>
        <legend>
            COPY VARIATION FROM ANOTHER ARTICLE
        </legend>
    
            

                <table width="100%" cellpadding="3" cellspacing="1" border="0" style="background-color: #000000">
                    <tr class="admin_sfondo">
                        <td align="center">product code
                        <asp:TextBox Style="width: 50" EnableViewState="false" Text="" CssClass="input" ID="tBoxCopiaCod" runat="server" />
                            &nbsp;&nbsp;
                variation N. 
                <asp:DropDownList ID="dListCopiaN" runat="server" CssClass="input">
                    <asp:ListItem Value="0">0</asp:ListItem>
                    <asp:ListItem Value="1">1</asp:ListItem>
                    <asp:ListItem Value="2">2</asp:ListItem>
                    <asp:ListItem Value="3">3</asp:ListItem>
                    <asp:ListItem Value="4">4</asp:ListItem>
                    <asp:ListItem Value="5">5</asp:ListItem>
                    <asp:ListItem Value="6">6</asp:ListItem>
                    <asp:ListItem Value="7">7</asp:ListItem>
                    <asp:ListItem Value="8">8</asp:ListItem>
                    <asp:ListItem Value="9">9</asp:ListItem>
                </asp:DropDownList>
                            &nbsp;&nbsp;
                <asp:Button ID="buttCopia" runat="server" Text="copy" CssClass="bottone" OnClick="copiavar_click" />
                        </td>



                    </tr>
                </table>
            </fieldset>
    -->

 </form>
</asp:Content>
