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
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script runat="server">

    protected int id;
    protected int livello;
    protected string strLivello;


    protected string nomeDb;
    protected string imgDb;
    protected string imgWidthDb;
    protected string imgHeightDb;
    protected int idPadreDb;
    string descrizioneDb;


    void changeVis(object o, EventArgs e)
    {
        if (id == 0) return;
        
        bool vis = cBoxVisibile.Checked;

        simplestecommerce.admin.categorie.changeVis(id, vis);
        simplestecommerce.caching.cachevisiblecategories("force");

    }
    
    void preparaLayout() {

        //visualizza Dovesei appropriato
        if (id==0){
				 	//lblDoveSei.Text = "Add " + strLivello;
					
				}
        else{
					//lblDoveSei.Text = "Modify " + strLivello + " N." + id;
					
				}


         //
         if (id==0) {
            buttAggiorna.Visible=false;
            buttFine.Visible=false;
            pHolderId.Visible=false;
            imgAttuale.Visible=false;

         }
         else {
            buttAggiungi.Visible=false;
         }


         if (id == 0 && livello == 0) pHolderCatPadre.Visible = false;

         dDListCatPadre.Items.Add (new ListItem ("NO PARENT CATEGORY", "0" ));
        
                      ArrayList arrCat = new ArrayList();
                       if(id==0 && livello==1){		// new subcat?
                           arrCat = simplestecommerce.admin.categorie.GetCategoriesTree(null,null,-1);
                       }
                       else{												// edit cat/subcat or new cat?
                           arrCat = simplestecommerce.admin.categorie.GetCategoriesTree(null, null, id);
                       }
                       foreach (simplestecommerce.admin.Category cat in arrCat)
                       {
                        
                           dDListCatPadre.Items.Add(new ListItem( cat.Name, cat.Id.ToString()));
                       }

    }

    void bindFields() {

        IDataReader dr;

        if (id != 0)
        {

            dr = simplestecommerce.admin.generale.getCatSottocat(id);

            if (!dr.Read())
            {
                dr.Close();
                simplestecommerce.problema.redirect("no category or subcategory with this ID", "admin_articoli.aspx");
            }

            lblId.Text = dr["cat_id"].ToString();


            {
             ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;

             Panel p = mypanel;
             TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
             for (int rip = 0; rip < mytabcontainer.Tabs.Count; rip++)
             {
              TabPanel tb = mytabcontainer.Tabs[rip];
              TextBox mytextbox = (TextBox)tb.FindControl("mytextbox");
              mytextbox.Text= 
               simplestecommerce.lingua.getfromdbbylanguage((string)arrfrontendlanguages[rip], dr["cat_nome"].ToString() );
             }
            }



            cBoxVisibile.Checked = !(bool)dr["cat_nascondi"];
            cBoxVisibile.Attributes["onclick"] = "alert('N.B. Also all the subcategories included in this category will be make ' + (this.checked?'visible':'invisible') )";

            if (dr["cat_img"].ToString() != "")
            {
                imgAttuale.ImageUrl = dr["cat_img"].ToString();
            }
            else
            {
                imgAttuale.ImageUrl = "~/immagini/non_disponibile.gif";
            }



            lblimg.Text = dr["cat_img"].ToString();





            foreach (ListItem li in dDListCatPadre.Items)
            {
                if (int.Parse(li.Value) == (int)dr["cat_idpadre"]) li.Selected = true;
            }





            dr.Close();
        }
        else cBoxVisibile.Attributes["onblur"] = "return false;";



    }



    string imgLogical () {

     string ext = System.IO.Path.GetExtension( fileImg.PostedFile.FileName);

     return (string)Application["upload"] + "/category" + id.ToString() + ext;
    }

    string imgFisical () {

     return Server.MapPath(imgLogical());
    }



    void uploadImg(int id, ref string excp0) {

            try {
                fileImg.PostedFile.SaveAs(imgFisical());
            }
            catch (Exception exc) {
                excp0 = exc.ToString();
            }
    }



    bool inputvalido()
    {
     bool result = true;
      Panel p = mypanel;
      TabContainer mytabcontainer = (TabContainer)(p.Controls[0]);
      foreach (TabPanel tb in mytabcontainer.Tabs)
      {
       {
        TextBox tbox= (TextBox)(tb.FindControl("mytextbox"));
        if (tbox.Text.Length < 1)
        {

         lblErr.Text += "<br>insert category name in " + tb.HeaderText;
         result = false;
        }
       }
      }

      return result;
      
     
    }


    void update (int id) {
        // la proc aggiorna la tab e poi esegue l'upload delle immagini


     if (!inputvalido()) return;

     
        idPadreDb = 0;
        foreach (ListItem li in dDListCatPadre.Items) {
            if (li.Selected) idPadreDb = int.Parse(li.Value);
        }

        descrizioneDb = tBoxDescr.Text;

        //retrive name
        string nomeDb = "";
        {
         Panel p = mypanel;
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

     

     
     
            
        
        //aggiorna campi immagine
        
        if (fileImg.PostedFile.FileName!="") {

            imgDb=imgLogical();
        }
        else {

            imgDb=lblimg.Text;
        }
        

        //aggiorna


         SqlConnection cnn;
         SqlCommand cmd;
         string strSql;

         cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
         cnn.Open();

         strSql = "UPDATE tcategorie" +
         " SET cat_idpadre=@idpadre, cat_livello=@livello, cat_nome=@nome" +
         ", cat_nascondi=@nascondi" +
         " WHERE cat_id=@id";
         cmd = new SqlCommand(strSql, cnn);
         cmd.Parameters.Add(new SqlParameter("@idpadre", idPadreDb));
         cmd.Parameters.Add(new SqlParameter("@livello", dDListCatPadre.SelectedValue=="0"?0:1 ));
         cmd.Parameters.Add(new SqlParameter("@nome", nomeDb));
         cmd.Parameters.Add(new SqlParameter("@nascondi", cBoxVisibile.Checked ? 0 : 1));
         cmd.Parameters.Add(new SqlParameter("@id", id));
         cmd.ExecuteNonQuery();


         int idAntenato;
         if (livello > 0)
         {


          ArrayList ar = simplestecommerce.admin.categorie.getPathCat(id, null);

          idAntenato = ((simplestecommerce.admin.Category)ar[1]).Id;
         }
         else idAntenato = id;

         strSql = "UPDATE tcategorie" +
         " SET cat_idantenato=@idantenato where cat_id=@idcat";
         cmd = new SqlCommand(strSql, cnn);
         cmd.Parameters.Add(new SqlParameter("@idantenato", idAntenato));
         cmd.Parameters.Add(new SqlParameter("@idcat", id));
         cmd.ExecuteNonQuery();




         cnn.Close();

         simplestecommerce.caching.cachevisiblecategories("force");

     
     
     
     
     
        bindFields();

        
        
        //esegue l'upload
        string excp0="";
        string excp1="";

        
        
        if (fileImg.PostedFile.FileName!="") {

            uploadImg(id, ref excp0);

        }

        if (fileImg.PostedFile.FileName!="") {

            uploadImg(id, ref excp1);

        }

        if (excp0!="" || excp1!="") simplestecommerce.problema.redirect (excp0 +  excp1, "admin_catsottocat.aspx?livello=" + livello + "&id=" + id);

        simplestecommerce.admin.generale.updateImgCat(id, imgDb);

        Response.Redirect("admin_categorie.aspx");
        
    }


    void buttAggiungi_click (object sender, EventArgs e) {

        
        //valida input

     if (!inputvalido()) return;
     
        int idNew;
        SqlConnection cnn;
        SqlCommand cmd;
        string strSql;

        cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();



        strSql = "INSERT INTO tcategorie" +
        " (cat_nome, cat_img,  cat_nascondi) " +
        " VALUES ('', '',  @nascondi)";

        cmd = new SqlCommand(strSql, cnn);
        cmd.Parameters.Add(new SqlParameter("@nascondi", (cBoxVisibile.Checked ? 0 : 1)));
        cmd.ExecuteNonQuery();


        strSql = "SELECT MAX(cat_id) FROM tcategorie";
        cmd = new SqlCommand(strSql, cnn);
        idNew = (int)cmd.ExecuteScalar();



        cnn.Close();


        update (idNew);

        //ridireziona
        Response.Redirect ("admin_categorie.aspx");



    }

    void buttAggiorna_click (object sender, EventArgs e) {

     if (!inputvalido()) return;

        update (id);

        if (id==0) {
            bindFields();
        }
        else {
            Response.Redirect ("admin_catsottocat.aspx?livello=" + livello + "&id=" + id + "&rnd=" + new Random().Next().ToString()  );
        }



    }



    void buttFine_click(object sender, EventArgs e) {

        Response.Redirect ("admin_categorie.aspx");

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

       TextBox mytextbox = new TextBox();
       mytextbox.ID = "mytextbox";
       mytextbox.Attributes["style"] = "width:100%";
       mytextbox.ValidateRequestMode = System.Web.UI.ValidateRequestMode.Disabled;
       AjaxControlToolkit.TabPanel mytabpanel = new AjaxControlToolkit.TabPanel();
       mytabpanel.HeaderText = arrfrontendlanguages[rip].ToString();
       mytabpanel.ID = "mytabpanel" + rip.ToString();
       mytabpanel.Controls.Add(mytextbox);
       mytabcontainer.Tabs.Add(mytabpanel);

      }
      mypanel.Controls.Add(mytabcontainer);
     }

    }
    void Page_Load() {

        
        id = Convert.ToInt32 (Request.QueryString["id"]);
        livello = Convert.ToInt32 (Request.QueryString["livello"]);
        strLivello = livello==0? "Category" : "Subcategory";


        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
         " &raquo; " +
         "<a href='" + ResolveUrl("~/admin/admin_categorie.aspx") + "'>categories</a>" +
        " &raquo; ";
         
        if (id > 0)
        {
         ((Label)Master.FindControl("lbldove")).Text +=
           "category ID " + id.ToString();
        }
        else ((Label)Master.FindControl("lbldove")).Text += "new category";
        if (!Page.IsPostBack) {
            preparaLayout();
            bindFields();
        }
     
     
     
     
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="Label1" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />




    <asp:label Text="" id="lblErr" runat="server" forecolor="red" enableviewstate="false" Font-Size="Large"/>

	<br><br>
    <asp:Label ForeColor="Red" runat="server" Font-Size="Large" id="lblErrDemo"/>

 <table width="100%" cellpadding=3 cellspacing=1 border=0 >

 <asp:placeholder id="pHolderId" runat="server" >

 <tr class="admin_sfondobis">
 <td >ID </td><td ><asp:label enableviewstate="TRUE" id="lblId" size=30 runat="server"  /> </td>
 </tr>

 </asp:placeholder>

 <asp:placeholder id="pHolderCatPadre" runat="server" >

 <tr class="admin_sfondobis">
 <td >parent category</td><td ><asp:dropdownlist enableviewstate="TRUE" id="dDListCatPadre" runat="server" class=input /> </td>
 </tr>

 </asp:placeholder>




 <tr class=admin_sfondobis>
 <td >name </td><td >
<asp:Panel runat="server" id="mypanel" />     </td>
 </tr>

 <tr class=admin_sfondobis>
 <td >visible</td><td ><asp:CheckBox runat=server ID="cBoxVisibile" Checked="true" 
   OnCheckedChanged="changeVis" AutoPostBack="true"/></td>
 </tr>






<!--
 <tr >
 <td class="admin_sfondo">Descrizione</td><td class=admin_sfondobis> <asp:textbox id="tBoxDescr" style="width:100%" runat="server" class=input /> </td>
 </tr>
-->






 <tr class=admin_sfondobis >
    <td >image:</td>
    <td >
        <asp:image id="imgAttuale" runat="server" />
        <br>
        Choose image from your hard-disk <input enableviewstate="TRUE" class=input runat="server" type="file" id="fileImg"><asp:label enableviewstate="false" id="lblErrFile1" forecolor="red" runat="server"/>
        <br>
        Current path: <asp:label enableviewstate="TRUE" runat="server" id="lblimg"/><br />
        <asp:label enableviewstate="false" id="lblErrImg" forecolor="red" runat="server"/>
        <br>
<!--
        Ridimensiona Larghezza: <asp:textbox enableviewstate="TRUE" size=4 cssclass=input id="lblimgWidth" runat="server" text="" /><asp:label enableviewstate="false" id="lblErrImgWidth" forecolor="red" runat="server"/>
        Ridimensiona Altezza: <asp:textbox enableviewstate="TRUE" size=4 cssclass=input id="lblimgHeight" runat="server" text="75" /><asp:label enableviewstate="false" id="lblErrImgHeight" forecolor="red" runat="server"/>
-->
    </td>
 </tr>

 </table>


    <div align=center>
    <br><br>
    <asp:button id="buttAggiungi" onClick="buttAggiungi_click" text=" CREATE " cssclass=bottone runat="server" />
    <asp:button id="buttAggiorna" onClick="buttAggiorna_click" text=" SAVE " cssclass=bottone runat="server" />
<!--    <asp:button id="buttFine" onClick="buttFine_click" text="FINE MODIFICHE" cssclass=bottone runat="server" />-->
    </div>

    <br><br>

    <asp:label visible=false id="lblNota" runat=server/>

</form></asp:content>




