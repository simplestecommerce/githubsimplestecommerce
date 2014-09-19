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
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Collections.Generic" %>

<script runat="server" >
 void variations_click(object o, EventArgs e)
 {
     Response.Redirect("admin_articolovarianti.aspx?idart=" + idArtIn.ToString());
 }

 void quantitydiscount_click(object o, EventArgs e)
 {
     Response.Redirect("admin_articoloscontiquantita.aspx?idart=" + idArtIn.ToString());
 }


 void butzoom_click(object o, EventArgs e)
 {

  Response.Redirect("~/admin/admin_zoom.aspx?idArt=" + idArtIn.ToString()); ;
  
  
 }

 void buttrelated_click(object o, EventArgs e)
 {

  Response.Redirect("~/admin/admin_relatedarticles.aspx?idart=" + idArtIn.ToString()); ;


 }
  
    
    protected int idArtIn;

    
           

    System.Collections.ArrayList arrCatDb= new System.Collections.ArrayList();

    void fillFields()
    {


     int idCat = (int)(simplestecommerce.admin.generale.getCampo("art_idcat", idArtIn));
     dListCatSottocat.SelectedValue = idCat.ToString();

     IDataReader dr;
     dr = simplestecommerce.admin.generale.getArtDettaglio(idArtIn);



     if (!dr.Read())
     {
      dr.Close();
      simplestecommerce.problema.redirect("no product with this id", "admin_articoli.aspx");
     }


     cBoxVisibile.Checked = (bool)dr["art_visibile"];


     //product name
     {
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

      Panel p = panelname;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);



      for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
      {
       TabPanel tb = mytabcontainer.Tabs[rip];
       TextBox mytextbox = (TextBox)tb.FindControl("mytextbox");
       mytextbox.Text = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], dr["art_nome"].ToString());
      }
     }


     
     
     //description
     {
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
      
      Panel p = paneldescription;
      TabContainer mytabcontainer = (TabContainer)(paneldescription.Controls[0]);

      
      
      for (int rip=0; rip<mytabcontainer.Tabs.Count; rip++) {
       TabPanel tb = mytabcontainer.Tabs[rip];
       HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
         mytextarea.InnerText= simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], dr["art_descrizione"].ToString());
      }
     }
     //tech spec
     {
      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

      Panel p = paneltecspec;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);



      for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
      {
       TabPanel tb = mytabcontainer.Tabs[rip];
       HtmlTextArea mytextarea = (HtmlTextArea)tb.FindControl("mytextarea");
       mytextarea.InnerText = simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], dr["art_caratteristiche"].ToString());
      }
     }





     tBoxMarca.Text = dr["art_marca"].ToString();

     tBoxStock.Text = dr["art_stock"].ToString();

     tBoxDescription.Text = dr["art_description"].ToString();

     tBoxKeywords.Text = dr["art_keywords"].ToString();

     tBoxPeso.Text = dr["art_peso"].ToString();

     foreach (ListItem li in dDLDisp.Items)
     {
      if (int.Parse(li.Value) == (int)dr["art_disponibilita"]) li.Selected = true;
     }


     dlisttaxprofiles.SelectedValue = dr["art_idtaxprofile"].ToString();

     foreach (ListItem li in dListConsegna.Items)
     {
      if (int.Parse(li.Value) == (int)dr["art_consegna"]) li.Selected = true;
     }


     if (dr["art_imgpreview"].ToString() != "")
     {
      img0Attuale.ImageUrl = dr["art_imgpreview"].ToString();
      img0Attuale.Visible = true;
     }




     tBoxImg0.Text = dr["art_imgpreview"].ToString();
     tBoxImg0Width.Text = dr["art_imgpreviewwidth"].ToString();
     tBoxImg0Height.Text = dr["art_imgpreviewheight"].ToString();
     tBoxCod.Text = dr["art_cod"].ToString();
     cBoxInVetrina.Checked = Convert.ToInt32(dr["art_invetrina"]) == 1 ? true : false;
     cBoxInOfferta.Checked = Convert.ToInt32(dr["art_inOfferta"]) == 1 ? true : false;
     cBoxUsato.Checked = Convert.ToInt32(dr["art_usato"]) == 1 ? true : false;
     dr.Close();




     for (int rip = 0; rip <= 9; rip++)
     {

      dr = simplestecommerce.admin.generale.getListino(idArtIn, rip);
      dr.Read();
      ((TextBox)(TabContainer0.FindControl("TabPanel" + rip.ToString()).FindControl("tBoxPrezzoIns" + rip.ToString()))).Text = dr["list_prezzobase"].ToString();
      ((TextBox)(TabContainer0.FindControl("TabPanel" + rip.ToString()).FindControl("tBoxScontoList" + rip.ToString()))).Text = dr["list_scontopercento"].ToString();
      dr.Close();


     }




    }


    void preparaLayout()
    {

     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>" +
" &raquo; " +
"<a href='admin_articoli.aspx'>products</a>" +
" &raquo;" +
"product ID " + idArtIn;

     // visualizza boxCategorieSottocategorie

        ArrayList arrCat = simplestecommerce.admin.categorie.GetCategoriesTree(null,null,-1);
         int quanteCat = 0;
         foreach(simplestecommerce.admin.Category c in arrCat){
            dListCatSottocat.Items.Add(new ListItem(c.Name, c.Id.ToString()));
            quanteCat++;
         }

         if (quanteCat==0 && idArtIn==0) simplestecommerce.problema.redirect ("you must before create at least one category", "admin_articoli.aspx");


        // crea dropdownlist disponibilita
         for (int rip=0; rip<= simplestecommerce.common.arrPseudoDisponibilita.Length-1; rip++) {
            dDLDisp.Items.Add (new ListItem (simplestecommerce.lingua.getinadminlanguagebypseudo( simplestecommerce.common.arrPseudoDisponibilita[rip]), rip.ToString()) );
         }

        //crea dropwdownlist tax profiles
         DataTable dttaxprofiles = simplestecommerce.helpDb.getDataTable("select * from taxprofiles");
         foreach  (DataRow drtaxprofile in dttaxprofiles.Rows) {
             dlisttaxprofiles.Items.Add(new ListItem(drtaxprofile["name"].ToString(), drtaxprofile["id"].ToString()));
         }

        dListConsegna.Items.Add ( new ListItem ( "", "-1" ) ) ;
        for (int rip = 1; rip <= 40; rip++)
        {
            dListConsegna.Items.Add(new ListItem(rip + " days", rip.ToString()));
        }


     
        //settta stock
        tBoxStock.Text = 10000000.ToString();


        buttSfogliaServer.Attributes["onClick"] = "window.open('admin_browse.aspx?path=" + Application["upload"].ToString() + "','','width=400; resizable=yes,scrollbars=yes'); return false";
        
        if (idArtIn!=0) {
            buttAggiorna.Visible=true;
            fillFields();
            
         
      buttScheda.Attributes["onClick"] = "window.open('" +
      ResolveUrl ("~/catalog/tempcategory/tempartname/" + simplestecommerce.admin.generale.getCampo ("art_idcat", idArtIn).ToString() + "/" + idArtIn.ToString() ) +
              "','','resizable=yes,scrollbars=yes'); return false";
                        
         
          
        }
        else {
            
           
                
                 
        }



    }

    string img0Logical () {


     string ext = System.IO.Path.GetExtension(fileImg0.PostedFile.FileName);     
     
     return (string)Application["upload"] + "/product" + idArtIn.ToString() + ext; 
    }
    string img0Fisical () {

     return Server.MapPath(img0Logical());
     
    }
    void uploadImg0(int idArt, ref string excp0) {

            try {
                fileImg0.PostedFile.SaveAs(img0Fisical());
            }
            catch (Exception exc) {
                excp0 = exc.ToString();
            }
    }

    bool validaInput()
    {

     lblerr.Text = "";

     bool inputValido = true;




     SqlConnection cnn;
     SqlCommand cmd;
     string strSql;

     cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
     cnn.Open();

     strSql = "SELECT COUNT(*) FROM tarticoli where art_cod=@cod and art_id<>@idart";
     cmd = new SqlCommand(strSql, cnn);
     cmd.Parameters.Add(new SqlParameter("@cod", tBoxCod.Text));
     cmd.Parameters.Add(new SqlParameter("@idart", idArtIn));
     int quanti = Convert.ToInt32(cmd.ExecuteScalar());

     cnn.Close();

     if (quanti > 0)
     {
      lblErrCod.Text += "<br>A product with this code already exists!";
      inputValido = false;
     }


     string erremptyname = "";
     {
      TabContainer tc = (TabContainer)panelname.Controls[0];
      foreach (TabPanel tb in tc.Tabs)
      {

       TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
       if (tbox.Text == "") erremptyname += "<br>insert product name in " + tb.HeaderText;
      }

      if (erremptyname != "")
      {
       lblerr.Text += "<br>" + erremptyname;
       inputValido = false;

      }

     }
     if (tBoxCod.Text.Length > simplestecommerce.common.maxLenCod) { lblErrNome.Text = "Max length is  " + simplestecommerce.common.maxLenCod + " chars"; inputValido = false; }
     if (tBoxMarca.Text.Length > simplestecommerce.common.maxLenMarca) { lblErrMarca.Text = "Max length is  " + simplestecommerce.common.maxLenMarca + " chars"; inputValido = false; }



     for (int rip = 0; rip <= 9; rip++)
     {
      TextBox ControlPrezzo = ((TextBox)(TabContainer0.FindControl("TabPanel" + rip.ToString()).FindControl("tBoxPrezzoIns" + rip.ToString())));
      TextBox ControlSconto = ((TextBox)(TabContainer0.FindControl("TabPanel" + rip.ToString()).FindControl("tBoxScontoList" + rip.ToString())));

      try { double prezzo = double.Parse(ControlPrezzo.Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
      catch { lblerr.Text += "<br>please insert a number in field PRICE " + rip.ToString(); inputValido = false; }

      try { double sconto = double.Parse(ControlSconto.Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
      catch { lblerr.Text += "<br>please insert a number in field DISCOUNT " + rip.ToString(); inputValido = false; }

     }










     try { double stock = int.Parse(tBoxStock.Text); }
     catch { lblerr.Text += "<br>please insert an integer number in field STOCK"; inputValido = false; }


     try { double peso = double.Parse(tBoxPeso.Text, simplestecommerce.admin.localization.primarynumberformatinfo); }
     catch { lblerr.Text += "<br>please insert a number in field WEIGHT"; inputValido = false; }



     return inputValido;

    }


    void updateArt(int idArt)
    {
     // la proc aggiorna la tab articoli e poi esegue l'upload delle immagini




     // retrieve description
     string descrizioneDb ="";
     { 
     Panel p = paneldescription;
     TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
     foreach (TabPanel tb in mytabcontainer.Tabs)
     {
      {
       HtmlTextArea tarea = (HtmlTextArea)(tb.FindControl("mytextarea"));
       if (descrizioneDb.Length > 0) descrizioneDb += "@@";
       descrizioneDb += tb.HeaderText + "." + tarea.InnerText;
      }
     }
    }
     
     
     //retrieve name
     string nomeDb = "";
     {
      Panel p = panelname;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      foreach (TabPanel tb in mytabcontainer.Tabs)
      {
       {
        TextBox tbox = (TextBox)(tb.FindControl("mytextbox"));
        if (nomeDb.Length > 0) nomeDb += "@@";
        nomeDb += tb.HeaderText + "." + tbox.Text;
       }
      }
     }



     //retrieve tecnhinal spec
     string tecspec = "";
     {
      Panel p =  paneltecspec;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      foreach (TabPanel tb in mytabcontainer.Tabs)
      {
       {
        HtmlTextArea tarea = (HtmlTextArea)(tb.FindControl("mytextarea"));
        if (tecspec.Length > 0) tecspec += "@@";
        tecspec += tb.HeaderText + "." + tarea.InnerText;
       }
      }
     }



     string marcaDb = tBoxMarca.Text;
     int disponibilitaDb = int.Parse(dDLDisp.SelectedItem.Value);
     int stockDb = int.Parse(tBoxStock.Text);
     int consegnaDb = int.Parse(dListConsegna.SelectedValue);


     List<simplestecommerce.admin.listino> listaListini = new List<simplestecommerce.admin.listino>();

     for (int rip = 0; rip <= 9; rip++)
     {


      TextBox ControlPrezzo = ((TextBox)TabContainer0.FindControl("TabPanel" + rip.ToString()).FindControl("tBoxPrezzoIns" + rip.ToString()));
      TextBox ControlSconto = ((TextBox)TabContainer0.FindControl("TabPanel" + rip.ToString()).FindControl("tBoxScontoList" + rip.ToString()));

      double prezzo = double.Parse(ControlPrezzo.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
      double sconto = double.Parse(ControlSconto.Text, simplestecommerce.admin.localization.primarynumberformatinfo);


      listaListini.Add(new simplestecommerce.admin.listino(prezzo, sconto));

     }





     string img0Db;
     string img0WidthDb = tBoxImg0Width.Text;
     string img0HeightDb = tBoxImg0Height.Text;
     string codDb = tBoxCod.Text;
     int inVetrinaDb = cBoxInVetrina.Checked ? 1 : 0;
     int inOffertaDb = cBoxInOfferta.Checked ? 1 : 0;
     int usatoDb = cBoxUsato.Checked ? 1 : 0;

     string descriptionDb = tBoxDescription.Text;
     string keywordsDb = tBoxKeywords.Text;
     int visibileDb = cBoxVisibile.Checked ? 1 : 0;
     double pesoDb = double.Parse(tBoxPeso.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
     int catDb = int.Parse(dListCatSottocat.SelectedValue);

     if (fileImg0.PostedFile.FileName != "")
     {

      img0Db = img0Logical();
     }
     else img0Db = tBoxImg0.Text;






     
     SqlConnection cnn;
     SqlCommand cmd;
     string strSql;


     cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
     cnn.Open();

     strSql = "UPDATE tarticoli" +
     " SET  art_cod=@cod, art_idcat=@idcat, art_nome=@nome, art_predescrizione=@predescrizione, art_descrizione=@descrizione" +
     ", art_marca=@marca, art_disponibilita=@disponibilita" +
     ", art_inVetrina=@invetrina, art_inOfferta=@inofferta, art_usato=@usato" +
     ", art_imgPreview=@imgPreview, art_imgPreviewWidth=@imgPreviewWidth, art_imgPreviewHeight=@imgPreviewHeight" +
     ", art_stock=@stock" +
     ", art_description=@description, art_keywords=@keywords" +
     ", art_visibile=@visibile" +
     ", art_peso=@peso" +
     ", art_consegna=@consegna" +
     ", art_caratteristiche=@caratteristiche" +
     ", art_idtaxprofile=@idtaxprofile"+
     " WHERE art_id=@idart";

     cmd = new SqlCommand(strSql, cnn);
     cmd.Parameters.Add(new SqlParameter("@cod", codDb));
     cmd.Parameters.Add(new SqlParameter("@idcat", catDb));
     cmd.Parameters.Add(new SqlParameter("@nome", nomeDb));
     cmd.Parameters.Add(new SqlParameter("@predescrizione", ""));
     cmd.Parameters.Add(new SqlParameter("@descrizione", descrizioneDb));

     cmd.Parameters.Add(new SqlParameter("@marca", marcaDb));
     cmd.Parameters.Add(new SqlParameter("@disponibilita", disponibilitaDb));

     cmd.Parameters.Add(new SqlParameter("@inVetrina", inVetrinaDb));
     cmd.Parameters.Add(new SqlParameter("@inOfferta", inOffertaDb));
     cmd.Parameters.Add(new SqlParameter("@usato", usatoDb));


     cmd.Parameters.Add(new SqlParameter("@imgPreview", img0Db));
     cmd.Parameters.Add(new SqlParameter("@imgPreviewWidth", img0WidthDb));
     cmd.Parameters.Add(new SqlParameter("@imgPreviewHeight", img0HeightDb));

     cmd.Parameters.Add(new SqlParameter("@stock", stockDb));

     cmd.Parameters.Add(new SqlParameter("@description", descriptionDb));
     cmd.Parameters.Add(new SqlParameter("@keywords", keywordsDb));
     cmd.Parameters.Add(new SqlParameter("@visibile", visibileDb));
     cmd.Parameters.Add(new SqlParameter("@peso", pesoDb));
     cmd.Parameters.Add(new SqlParameter("@consegna", consegnaDb));
     cmd.Parameters.Add(new SqlParameter("@caratteristiche", tecspec));

     cmd.Parameters.Add(new SqlParameter("@idtaxprofile", int.Parse(dlisttaxprofiles.SelectedValue)));

     cmd.Parameters.Add(new SqlParameter("@idArt", idArt));

     cmd.ExecuteNonQuery();


     for (int rip = 0; rip <= 9; rip++)
     {


      strSql = "UPDATE tlistino" +
      " SET list_prezzobase=@prezzobase, list_scontoPerCento=@sconto" +
      " WHERE list_idart=@idart AND list_n=@n";
      cmd = new SqlCommand(strSql, cnn);
      cmd.Parameters.Add(new SqlParameter("@prezzobase", listaListini[rip].Prezzo));
      cmd.Parameters.Add(new SqlParameter("@sconto", listaListini[rip].ScontoPerCento));
      cmd.Parameters.Add(new SqlParameter("@idart", idArt));
      cmd.Parameters.Add(new SqlParameter("@n", rip));
      cmd.ExecuteScalar();
     }









     cnn.Close();


     
     


     //esegue l'upload
     string excp0 = "";

     if (fileImg0.PostedFile.FileName != "")
     {

      uploadImg0(idArt, ref excp0);

     }

     if (excp0 != "") simplestecommerce.problema.redirect("We couldn't upload photo on the server" + "<br>" + excp0, "admin_articolo.aspx?a=2&idArt=" + idArt);

    }





   


    





    void buttAggiorna_click (object sender, EventArgs e) {

        
        //valida input
        if (! validaInput() ) return;

        updateArt (idArtIn);



        Response.Redirect ("admin_articoli.aspx" );


    }

    void buttSalvaContinua_click(object sender, EventArgs e)
    {

        //valida input
        if (!validaInput()) return;




            updateArt(idArtIn);
            
            Response.Redirect("admin_articolo.aspx?idart=" + idArtIn);
        
        




    }


    void Page_Init() {

     { 
         TabContainer mytabcontainer = new TabContainer();
         mytabcontainer.ID = "tabcontainerdescription";
         mytabcontainer.CssClass = "CustomTabStyle";


         ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
         for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
         {

          HtmlTextArea tarea = new HtmlTextArea();
          tarea.ID = "mytextarea";
          tarea.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
          AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
          mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
          mytabpanel.ID = "mytabpanel" + rip.ToString();
          mytabpanel.Controls.Add(tarea);
          mytabcontainer.Tabs.Add(mytabpanel);

         }
         paneldescription.Controls.Add(mytabcontainer);
     }

     {
      TabContainer mytabcontainer = new TabContainer();
      mytabcontainer.ID = "tabcontainername";
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
      panelname.Controls.Add(mytabcontainer);
     }



     {
      TabContainer mytabcontainer = new TabContainer();
      mytabcontainer.ID = "tabcontainertecspec";
      mytabcontainer.CssClass = "CustomTabStyle";

      ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
      for (int rip = 0; rip < arrfrontendlanguages.Count; rip++)
      {

       HtmlTextArea tarea = new HtmlTextArea();
       tarea.ID = "mytextarea";
       tarea.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
       AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
       mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
       mytabpanel.ID = "mytabpanel" + rip.ToString();
       mytabpanel.Controls.Add(tarea);
       mytabcontainer.Tabs.Add(mytabpanel);

      }
  paneltecspec.Controls.Add(mytabcontainer);
     }
      
     
    }








    void Page_Load() {

        idArtIn = Convert.ToInt32 (Request.QueryString["idArt"]);

        if (idArtIn == 0)
        {

         // creo articolo


         SqlConnection cnn;
         SqlCommand cmd;
         string strSql;
         cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
         cnn.Open();

         strSql = "select count(*) from tcategorie";
         cmd = new SqlCommand(strSql, cnn);
         int quanteCat = Convert.ToInt32(cmd.ExecuteScalar());
         cnn.Close();
         if (quanteCat < 1)
         {
          simplestecommerce.problema.redirect("You must create at least one category");
          
         }
         
         
         int idArtNew;


         simplestecommerce.admin.generale.aggiungiArt(out idArtNew);

         //ridireziona
         Response.Redirect("admin_articolo.aspx?idArt=" + idArtNew.ToString());



        }
     
     
        
        if (!Page.IsPostBack) preparaLayout();
    }


</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">










<form enctype="multipart/form-data" runat="server" >
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 

    


    <div align=left style="font-size:15px; color:Red; font-weight:bold">
    <asp:Label ID="lblerr" runat=server />
    </div>



  <asp:Panel runat="server" ID="panel1" Visible="true" GroupingText="<span style='font-size:13px;'>PRODUCT DETAIL</span>" Width="100%">

 <table align=center cellpadding=3 cellspacing=1 border=0  width="100%" >
 

  <!-- here i define width of columns-->
  <tr class="admin_sfondo">
 <td  width="322"><b>Code</b>&nbsp;&nbsp;</td>
 <td  width="718"><asp:textbox enableviewstate="false" id="tBoxCod" size=30 runat="server" class=input /> <asp:label enableviewstate="false" id="lblErrCod" forecolor="red" runat="server"/></td>
 </tr>
<!-- end definition -->

<tr class="admin_sfondo">
 <td><b>Visible</b>&nbsp;&nbsp;</td>
 <td><asp:checkbox checked enableviewstate="false" id="cBoxVisibile" runat="server" class=input /> </td>
 </tr>
<tr class="admin_sfondo"> 
    <td ><b>Category</b></td>
    <td ><asp:dropdownlist cssclass=input id="dListCatSottocat" runat="server" enableviewstate="TRUE" />
		<asp:label class=input runat=server forecolor=red id="lblErrRep"  EnableViewState=false/>
    </td>
 </tr>


 <tr class="admin_sfondo">
 <td>
     <b>Name</b>:&nbsp;&nbsp;
     <asp:label enableviewstate="false" id="lblErrNome" forecolor="red" runat="server"/>
 </td>
     <td>
<asp:Panel runat="server" ID="panelname" />
         </td>
 </tr>
 

 <tr class="admin_sfondo">
    <td><b>Description</b></td>
    <td align="left">
     <asp:Panel runat="server" ID="paneldescription" />
    </td>
 </tr>

 <tr class="admin_sfondo">
    <td><b>Technical specifications</b></td>
    <td>
     <asp:Panel runat="server" ID="paneltecspec" />
    </td>
 </tr>



 <tr class="admin_sfondo">
    <td><b>Brand</b></td>
    <td ><asp:textbox  enableviewstate="false" id="tBoxMarca" size=30 runat="server" class=input /> <asp:label enableviewstate="false" id="lblErrMarca" forecolor="red" runat="server"/></td>
 </tr>
 <tr class="admin_sfondo">
    <td ><b>Tax Profile</b></td>
    <td >
        <asp:dropdownlist id="dlisttaxprofiles"  enableviewstate="TRUE" runat="server" cssClass=input />
    </td>
 </tr>
 <tr class="admin_sfondo">
    <td ><b>Availability</b></td>
    <td >
        <asp:dropdownlist enableviewstate="TRUE" id="dDLDisp" runat="server" cssClass=input />
        &nbsp;Delivery: <asp:dropdownlist enableviewstate="TRUE" id="dListConsegna" runat="server" cssClass=input />
        
        
        &nbsp; Stock: <asp:textbox runat=server id="tBoxStock" class=input size=13 />
        
        <asp:label enableviewstate="false" id="lblErrStock" forecolor="red" runat="server"/></td>
 </tr>

 <tr class="admin_sfondo">
 <td height="100" valign=middle><b>Prices and discounts<br /></b><span class="help">(price list 0 is the public price list)</span></td> 
 <td>
 <ajaxToolkit:TabContainer ID="TabContainer0" runat="server" Width="100%"  cssclass="CustomTabStyle">  
            <ajaxToolkit:TabPanel ID="TabPanel0" runat="server">  
                <HeaderTemplate>  
                    pricelist0
                </HeaderTemplate>  
                 
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns0" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList0" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList0" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList0" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  

            <ajaxToolkit:TabPanel ID="TabPanel1" runat="server">  
                <HeaderTemplate>  
                    pricelist1
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns1" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList1" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList1" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList1" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  




            <ajaxToolkit:TabPanel ID="TabPanel2" runat="server">  
                <HeaderTemplate>  
                    pricelist2
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns2" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList2" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList2" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList2" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  


            <ajaxToolkit:TabPanel ID="TabPanel3" runat="server">  
                <HeaderTemplate>  
                    pricelist3
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns3" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList3" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList3" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList3" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  


            <ajaxToolkit:TabPanel ID="TabPanel4" runat="server">  
                <HeaderTemplate>  
                    pricelist4
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns4" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList4" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList4" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList4" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  



            <ajaxToolkit:TabPanel ID="TabPanel5" runat="server">  
                <HeaderTemplate>  
                    pricelist5
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns5" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList5" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList5" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList5" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  


            <ajaxToolkit:TabPanel ID="TabPanel6" runat="server">  
                <HeaderTemplate>  
                    pricelist6
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns6" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList6" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList6" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList6" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  


            <ajaxToolkit:TabPanel ID="TabPanel7" runat="server">  
                <HeaderTemplate>  
                    pricelist7
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns7" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList7" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList7" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList7" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  



            <ajaxToolkit:TabPanel ID="TabPanel8" runat="server">  
                <HeaderTemplate>  
                    pricelist8
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns8" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList8" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList8" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList8" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  



            <ajaxToolkit:TabPanel ID="TabPanel9" runat="server">  
                <HeaderTemplate>  
                    pricelist9
                </HeaderTemplate>  
                <ContentTemplate>  
                    <div style="font-family:tahoma; font-size:10px">
                    price <asp:textbox enableviewstate="false" text="0" id="tBoxPrezzoIns9" class=input runat="server" />
                    &nbsp;&nbsp;
                    discount% <asp:textbox enableviewstate="false" text="0" id="tBoxScontoList9" size=2 class=input runat="server" /> 
                    <asp:label enableviewstate="false" id="lblErrScontoList9" forecolor="red" runat="server"/>
                    <asp:label enableviewstate="false" id="lblErrPrezzoList9" forecolor="red" runat="server"/>
                    </div>
                </ContentTemplate>  
            </ajaxToolkit:TabPanel>  




</ajaxToolkit:TabContainer>
 
 </td>
 </tr>

 



 <tr class="admin_sfondo">
    <td><b>Weight in grams</b></td>
    <td><asp:textbox enableviewstate="false" text="0" id="tBoxPeso" class=input runat="server" /> <asp:label enableviewstate="false" id="lblErrPeso" forecolor="red" runat="server"/></td>
 </tr>



 <!--
 <tr >
    <td class="admin_sfondo">In Vetrina</td><td class="admin_sfondobis"><asp:checkbox id="cBoxInVetrina" enableviewstate="false" class=input runat="server" /></td>
 </tr>
 -->


 <tr class="admin_sfondo">
    <td>
        <b>Feature product</b>
     </td>
     <td><asp:checkbox id="cBoxInOfferta" enableviewstate="false" class=input runat="server" /></td>
 </tr>

  
<tr class="admin_sfondo">
    <td>
    <b>Used product</b>
    <span class="help"><br /></span>   
    </td>
    <td><asp:checkbox id="cBoxUsato" enableviewstate="false" class=input runat="server" /></td>
 </tr>
  

<tr class="admin_sfondo">
    <td><b>METATAG Description</b>
    <br /><span class="help">This field is optional; in order to get a better indicization in search engines please insert a short description of the product</span>
    </td>
    <td><asp:textbox enableviewstate="false" id="tBoxDescription" class=input style="width:100%" runat="server" /> </td>
 </tr>

<tr class="admin_sfondo">
    <td><b>METATAG Keywords</b>
    <br /><span class="help">this field is optional; in order to get a better indicization in search engines insert some keywords relatives to the product seaprated by a space</span>
    
    </td>
    <td><asp:textbox enableviewstate="false" id="tBoxKeywords" class=input runat="server" style="width:100%"/> </td>
 </tr>


<tr class="admin_sfondo">
  <td><b>Product image</b><br />
  <td>
        <asp:image enableviewstate="false" id="img0Attuale" visible="false" runat="server" />
        <br>
        <input class=input runat="server" type="file" id="fileImg0" style="font-size:14px"><asp:label enableviewstate="false" id="lblErrFile0" forecolor="red" runat="server"/>
      
        <br />Path on the server: <asp:textbox cssclass=input size=80 runat="server" id="tBoxImg0"  Enabled=false/>
        <!--<input  type=submit class=bottone runat=server  style="height:18px" value="Sfoglia immagini sul server" ID="buttSfogliaServer" />-->
        <asp:label enableviewstate="false" id="lblErrImg0" forecolor="red" runat="server"/>
        <!--
        Ridimensiona Larghezza: <asp:textbox enableviewstate="true" size=4 cssclass=input id="tBoxImg0Width" runat="server" text="" /><asp:label enableviewstate="false" id="lblErrImg0Width" forecolor="red" runat="server"/>
        Ridimensiona Altezza: <asp:textbox enableviewstate="true" size=4 cssclass=input id="tBoxImg0Height" runat="server" text="75" /><asp:label enableviewstate="false" id="lblErrImg0Height" forecolor="red" runat="server"/>
        -->
    </td>
 </tr>
 </table>
   </asp:Panel>
 <br />
   
    <br><br>
    
    <asp:button visible=false id="buttAggiorna" onClick="buttAggiorna_click" text="  SAVE CHANGES  " cssclass=bottone runat="server" />
    <asp:button visible=true  id="buttSalvaContinua" onClick="buttSalvaContinua_click" text="  SAVE CHANGES AND CONTINUE " cssclass=bottone runat="server" />
    <asp:button runat="server" cssclass=bottone text="VARIATIONS"  onclick="variations_click" />
    <asp:button runat="server" onclick="buttrelated_click" id="buttrelated" cssclass=bottone text="RELATED PRODUCTS" />
    <asp:button runat="server" cssclass=bottone text="QUANTITY DISCOUNTS"  onclick="quantitydiscount_click" />
    <asp:button runat="server" onclick="butzoom_click" id="buttonZoom" cssclass=bottone text="PHOTO ENLARGEMENTS" />
    <input runat=server id="buttScheda" class=bottone type="submit" value="OPEN PRODUCT PAGE" runat="server" />
    
    <br><br>

    <asp:label Text="" id="debug" runat="server" forecolor="red" enableviewstate="false"/>



    
    <asp:label enableviewstate="false" id="lblErrore" forecolor="red" runat="server"/>

    
</form>
</asp:Content>