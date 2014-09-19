// articoli.aspx.cs

//Copyright (C) 2014 Maurizio Ferrera
 
//This file is part of SimplestEcommerce

//SimplestEcommerce is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//SimplestEcommerce is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with SimplestEcommerce.  If not, see <http://www.gnu.org/licenses/>.


namespace simplestecommerce {
    using System;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.HtmlControls;
    using System.Data;
    using System.Data.Common;
    using System.Data.OleDb;
    using System.Collections;
    using AjaxControlToolkit;
    using System.Collections.Generic;
    using System.Data.Sql;
    using System.Data.SqlClient;
    using System.Data.SqlTypes;
    using System.Web.Routing;

    public partial class behindArticoliAspx  : Page {
        
        public simplestecommerce.articolo articolo;
        

        public string nomeartcurrentfrontendlanguage;
        public int a = 0;
        public int c = 0;

        public string imgFacebook;
        int user;
        int idArt;
        double prezzoDopoSconto;
        

        public string title;
        public string description;
        public string keywords;

        DataTable dtscontiquantita;


        public void listvariations_databound(object sender, RepeaterItemEventArgs e)
        {
            
                    if ( e.Item.ItemType==ListItemType.AlternatingItem || e.Item.ItemType==ListItemType.Item) {
                       
                       simplestecommerce.Variation v = (simplestecommerce.Variation)e.Item.DataItem;
                       ((Label)e.Item.FindControl("lblnomevar")).Text = simplestecommerce.lingua.getforfrontendfromdb(v.Nome);
                       ((HiddenField)e.Item.FindControl("hiddenidvar")).Value = v.Id.ToString();


                       DropDownList d = (DropDownList)e.Item.FindControl("dlistoptions");



                           bool first = true;
                           foreach (simplestecommerce.Option o in v.Opzioni)
                           {

                               string segno;
                               string testo = "";
                               string valore;
                               double prezzo;

                               prezzo = o.Prezzodoposcontoprodottoutentelistino;

                               testo = simplestecommerce.lingua.getforfrontendfromdb(o.Testo);

                               if (prezzo != 0)
                               {

                                   segno = (prezzo > 0 ? "+" : "-");
                                   testo += "  " + segno + currencies.tostrusercurrency(prezzo);
                               }

                               valore = o.Id.ToString();

                               if (first)
                               {
                                   d.Items.Add(new ListItem(
                                        simplestecommerce.lingua.getforfrontendbypseudo("article.options.select.option"),
                                        "-1"));
                               }

                               d.Items.Add(new ListItem(testo, valore));

                               first = false;
                           }

                       }

            
        
        }

        public void listsamples_databound(object sender, RepeaterItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {

                simplestecommerce.Variation v = (simplestecommerce.Variation)e.Item.DataItem;

                Literal lblsamples = (Literal)e.Item.FindControl("lblsamples");

                bool hassamples = false;
                bool first = true;

                foreach (simplestecommerce.Option o in v.Opzioni)
                {
                    if (o.Img.Length > 0)
                    {

                        hassamples = true;


                        if (first) lblsamples.Text += "<fieldset><legend>" + lingua.getforfrontendfromdb(v.Nome) + "</legend><table cellpadding=0 cellspacing=0><tr>";

                        lblsamples.Text+= "<td valign=bottom align=left nowrap><img src='" + ResolveUrl(o.Img) + "' width='30' height='30'><br>" +
                            simplestecommerce.lingua.getforfrontendfromdb(o.Testo) + "</td><td width='10'>&nbsp;</td>"; 
                        

                        first = false;
                    }



                }

                if (hassamples) lblsamples.Text += "</tr></table></fieldset>";
            }

        }
        void showArticoloDettaglio () {




            btnInvia.Text = simplestecommerce.lingua.getforfrontendbypseudo("article.button.add.to.cart");



            if (articolo.Usato) PHOLDERusato.Visible = true;
            

            prezzoDopoSconto = articolo.Prezzodoposcontoprodottoutentelistino;

            

            //metatag
            title = Application["config_nomeSito"].ToString();
            description = articolo.Description;
            keywords = articolo.Keywords;





                // show hide placeholder addtocart and display availability
                if (articolo.Disponibilita== 0 )
                {

                    if (articolo.Stock < 1)
                    {
                        placeHolderAddToCart.Visible = false;
                        lblDispArticolo.Text = lingua.getforfrontendbypseudo("article.availability.label.not.in.stock");
                    }
                    else lblDispArticolo.Text = lingua.getforfrontendbypseudo(common.arrPseudoDisponibilita[articolo.Disponibilita]);

                }
                else if (articolo.Disponibilita == 1)
                {
                    
                        placeHolderAddToCart.Visible = false;
                        lblDispArticolo.Text = lingua.getforfrontendbypseudo(common.arrPseudoDisponibilita[articolo.Disponibilita]);
                }
                else if (articolo.Disponibilita == 2)
                {

                    lblDispArticolo.Text = lingua.getforfrontendbypseudo(common.arrPseudoDisponibilita[articolo.Disponibilita]);
                }
                //**************************************************************




                if (articolo.Consegna != -1)
                    lblDispArticolo.Text += ", " + 
                        String.Format ( simplestecommerce.lingua.getforfrontendbypseudo("article.label.availability.delivery.in.the.following.days"), articolo.Consegna.ToString());







                nomeartcurrentfrontendlanguage = simplestecommerce.lingua.getforfrontendfromdb( articolo.Name ); 
                if (articolo.Preview == "")
                    imgArticoloPreview.ImageUrl = "~/immagini/non_disponibile.gif";
                else
                {
                    imgArticoloPreview.ImageUrl = articolo.Preview;
                }


                if (articolo.Preview == "")
                    imgFacebook = Application["config_urlSito"] + "/shop/immagini/non_disponibile.gif";
                else imgFacebook = Application["config_urlSito"] + "/" + articolo.Preview;

                lblNomeArtBig.Text = nomeartcurrentfrontendlanguage;
                lblCodArticolo.Text= ( articolo.Code );
                lblMarcaArticolo.Text= simplestecommerce.articoli.strMarca( articolo.Marca );
                lblDescrizioneArticolo.Text=  ( articolo.Descrizione );
                lblCaratteristiche.Text = ( articolo.Caratteristiche);



                // visualizza varianti ***********************************
         listvariations.DataSource = articolo.Variations;
         listvariations.DataBind();

         listsamples.DataSource = articolo.Variations;
         listsamples.DataBind();
         // fine visualizza varianti ***********************************



         
         




                // ingrandimenti
               DataTable dtZoom = simplestecommerce.zoom.getIngrandimenti(articolo.Idart);
               if (dtZoom.Rows.Count > 0)
               {
                   pholderotherphoto.Visible = true;
                   listaZoom.DataSource = dtZoom;
                   listaZoom.DataBind();
               }
               else pholderotherphoto.Visible = false;




                



    
                
        }





            

        public void buttAdd_click(object sender, EventArgs e)
        {





            if ((int)Application["config_registrazione"] > 0 && ((simplestecommerce.Cart)Session["Cart"]).User.Anonimo) Response.Redirect("~/shop/login.aspx");





            int quantita;



            // ricava la quantita
            quantita = 0;

            if (!int.TryParse(tBoxQuantita.Text, out quantita) || quantita < 1)
            {
                string msg = simplestecommerce.lingua.getforfrontendbypseudo("alert.article.quantity.must.be.greater.than.0");
               simplestecommerce.common.alert(msg, this.Page);

                return;
            }
                



            string erroredisp = simplestecommerce.lingua.getforfrontendbypseudo ( Cart.pseudoerravailability(articolo.Idart, quantita) );
            if (erroredisp != "")
            {
                string msg = erroredisp;
               simplestecommerce.common.alert(msg, this.Page);
                return;
            }











            // recupero varianti
            List<Choosedvariation> Choosedvariations =    new List<Choosedvariation>();

            foreach (RepeaterItem r in listvariations.Items)
            {
                int idvar = -1;
                string nomevar = "";

                foreach (Control c in r.Controls)
                {

                    if (c.ToString() == "System.Web.UI.WebControls.Label")
                    {
                        Label l = (Label)c;
                        nomevar = l.Text;
                    }
                    if (c.ToString() == "System.Web.UI.WebControls.HiddenField")
                    {
                        HiddenField h = (HiddenField)c;
                        idvar = int.Parse(h.Value);
                    }

                    if (c.ToString() == "System.Web.UI.WebControls.DropDownList")
                    {
                        DropDownList d = (DropDownList)c;
                        if (d.SelectedIndex == 0)
                        {
                            string msg=
                              simplestecommerce.lingua.getforfrontendbypseudo("alert.article.select.an.option") + " " +nomevar; 
                            simplestecommerce.common.alert(msg, this.Page);
                            
                            return;
                        }
                        ListItem sellistitem = d.SelectedItem;



                        foreach (Variation v in articolo.Variations)
                        {
                            foreach (Option o in v.Opzioni)
                            {
                                if (o.Id.ToString() == d.SelectedItem.Value)
                                {

                                    Choosedvariations.Add(
                                        new Choosedvariation(v.Id, v.Nome, new Choosedoption(o.Id, o.Testo, o.Prezzobase, o.Prezzodoposcontoprodottoutentelistino))
                                                        );
                                }

                            }
                        }
                    }
                }
            }

            
            
            ((simplestecommerce.Cart)(Session["Cart"])).addToCart(new simplestecommerce.cartItem(articolo, quantita, Choosedvariations));

            string msgbis = String.Format( 
                simplestecommerce.lingua.getforfrontendbypseudo("article.alert.this.product.added.to.cart"), 
                simplestecommerce.lingua.getforfrontendfromdb( articolo.Name)
            );

            simplestecommerce.common.alert(msgbis, this.Page); 

            UserControl uc = (UserControl)Page.Master.FindControl("incarrello1");
            ((UpdatePanel)uc.FindControl("pannellodinamicoincarrelloascx")).Update();

        }



        void listrelatedproucts_databound(object sender, DataListItemEventArgs e)
        {


            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                pholderrelatedproducts.Visible = true;

                DataRowView db = (DataRowView)(e.Item.DataItem);


                int idCorr = (int)db["idartcorr"];




                articolo artCorr = new simplestecommerce.articolo(
                        idCorr,
                        ((simplestecommerce.Cart)Session["Cart"]).Listino.Id,
                        ((simplestecommerce.Cart)Session["Cart"]).Listino.Sconto,
                        ((simplestecommerce.Cart)Session["Cart"]).User.Sconto);

                ((HyperLink)e.Item.FindControl("hLinkArt")).Text = simplestecommerce.lingua.getforfrontendfromdb(artCorr.Name);

                ((HyperLink)e.Item.FindControl("hLinkArt")).NavigateUrl = artCorr.Linkart;
                ((HtmlAnchor)e.Item.FindControl("linkImage")).HRef = ((HyperLink)e.Item.FindControl("hLinkArt")).NavigateUrl;


                    if (artCorr.Preview != "")
                        ((Image)e.Item.FindControl("imgArt")).ImageUrl = artCorr.Preview;
                    else ((Image)e.Item.FindControl("imgArt")).ImageUrl = "~/immagini/non_disponibile.gif";

                    ((Image)e.Item.FindControl("imgArt")).ToolTip = ((HyperLink)e.Item.FindControl("hLinkArt")).Text;

                    ((Label)e.Item.FindControl("lblPrezzoArticolo")).Text += currencies.tostrusercurrency(artCorr.Prezzodoposcontoprodottoutentelistino);
                    
                

            }
       }


        void repScQuant_dataBound(object sender, RepeaterItemEventArgs e) {


            pHolderScQuant.Visible=true;

            double sumprezzodoposcontoprodottolistinoutenteoptions = 0;
            foreach (RepeaterItem r in listvariations.Items)
            {

                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    foreach (Control c in r.Controls)
                    {
                        if (c.ToString() == "System.Web.UI.WebControls.DropDownList")
                        {
                            DropDownList d = (DropDownList)c;
                            if (d.SelectedIndex > 0)
                            {
                                ListItem sellistitem = d.SelectedItem;
                                foreach (Variation v in articolo.Variations)
                                {
                                    foreach (Option o in v.Opzioni)
                                    {
                                        if (o.Id.ToString() == d.SelectedItem.Value)
                                        {
                                            sumprezzodoposcontoprodottolistinoutenteoptions += o.Prezzodoposcontoprodottoutentelistino;
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
                    DbDataRecord db = (DbDataRecord)(e.Item.DataItem);
                    ((Label)e.Item.FindControl("lblStartScQuant")).Text = db["s_quantita"].ToString();
                    
                    double tmpresult = articolo.Prezzodoposcontoprodottoutentelistino + sumprezzodoposcontoprodottolistinoutenteoptions;

                    tmpresult= tmpresult*(1-simplestecommerce.articoli.getquantitydiscount(tmpresult, (int)db["s_quantita"], dtscontiquantita)/100);
           
                    ((Label)e.Item.FindControl("lblPrezzoScQuant")).Text = simplestecommerce.currencies.tostrusercurrency(tmpresult);                    


                
            

       }

        void showArticoliCorrelati() {

                string sql = "SELECT idartcorr from tcorrelati,tarticoli,tcategorie where"+
                " art_id=idartcorr and art_idcat=cat_id" +
                " AND idart=@idart and art_visibile=1 and cat_nascondi=0";
                DataTable dt = simplestecommerce.helpDb.getDataTable(sql, new SqlParameter("idart", idArt));

                listrelatedproucts.DataSource = dt;
                listrelatedproucts.DataBind();

                
           
        }




        void showScQuant () {

            IDataReader dr;

            dr = simplestecommerce.scontiQuantita.readAll (idArt);

            repScQuant.DataSource = dr;
            repScQuant.DataBind();

            dr.Close();
        }





        void Page_Init() {





            listrelatedproucts.ItemDataBound += new   DataListItemEventHandler(listrelatedproucts_databound);
         repScQuant.ItemDataBound+= new RepeaterItemEventHandler (repScQuant_dataBound);


        
        }



        void Page_Load() {



            idArt = Convert.ToInt32(Page.RouteData.Values["idArt"]);
            //idArt = Convert.ToInt32(Request.QueryString["idArt"]);


            articolo = new articolo(
                idArt,
                ((simplestecommerce.Cart)Session["Cart"]).Listino.Id,
                ((simplestecommerce.Cart)Session["Cart"]).Listino.Sconto,
                ((simplestecommerce.Cart)Session["Cart"]).User.Sconto);


            Session["lastVisit"] = HttpContext.Current.Request.RawUrl;







            dtscontiquantita = simplestecommerce.scontiQuantita.getSconti(idArt);



                if (!Page.IsPostBack)
                {

                    showArticoloDettaglio();


                    

                    
                    // aggiunge articolo alla coda articoli gia visti
                    List<articolo> coda = (List<articolo>)Session["coda"];
                    foreach ( articolo a in coda) {
                        if ( a.Idart == idArt ) {
                            coda.Remove (a);
                            break;
                        }
                    }
                    coda.Add(
                        new simplestecommerce.articolo(
                            idArt,
                            ((simplestecommerce.Cart)Session["Cart"]).Listino.Id,
                            ((simplestecommerce.Cart)Session["Cart"]).Listino.Sconto,
                            ((simplestecommerce.Cart)Session["Cart"]).User.Sconto)
                            );
                    
                    if (coda.Count >= 9) coda.RemoveAt(0);
                    Session["coda"] = coda;
                    

                }
                showArticoliCorrelati();


        } // page load


        void Page_PreRender()
        {

            // valorizza molliche *********************************************



                         Page.Header.DataBind();
                         Label lblMollicheMaster = (Label)(Master.FindControl("lblMolliche"));
                         ArrayList arrPathCat = simplestecommerce.Category.getPathCat(articolo.Idcat, null);
                         lblMollicheMaster.Text = common.linkescaped("Home", ResolveUrl("~/shop/default.aspx"), "molliche");
                         foreach (simplestecommerce.Category cat in arrPathCat)
                         {
                             if (cat.Id > 0)
                             {
                                 lblMollicheMaster.Text += "&nbsp;&raquo;&nbsp;" + "<a class=molliche href='" + simplestecommerce.Category.linkforrouting(cat.Id) + "'>" + simplestecommerce.lingua.getforfrontendfromdb(cat.Name) + "</a>";
                             }
                         }
                         lblMollicheMaster.Text += "&nbsp;&raquo;&nbsp;" + simplestecommerce.lingua.getforfrontendbypseudo("article.you.are.here.product.detail");
                

            // show article price

                         double sumprezzobaseopz = 0;
                         double sumprezzodoposcontoprodottoutentelistino = 0;
                         if (Page.IsPostBack)
                         {
                             foreach (RepeaterItem r in listvariations.Items)
                             {

                                 foreach (Control c in r.Controls)
                                 {

                                     if (c.ToString() == "System.Web.UI.WebControls.DropDownList")
                                     {

                                         DropDownList d = (DropDownList)c;
                                         if (d.SelectedIndex > 0)
                                         {
                                             ListItem sellistitem = d.SelectedItem;

                                             foreach (Variation v in articolo.Variations)
                                             {
                                                 foreach (Option o in v.Opzioni)
                                                 {
                                                     if (o.Id.ToString() == d.SelectedItem.Value)
                                                     {
                                                         sumprezzobaseopz += o.Prezzobase;
                                                         sumprezzodoposcontoprodottoutentelistino += o.Prezzodoposcontoprodottoutentelistino;

                                                     }
                                                 }
                                             }
                                         }
                                     }
                                 }
                             }
                         }

                         bool discounted = (articolo.Prezzobase != articolo.Prezzodoposcontoprodottoutentelistino);

                         lblPrezzoArticolo.Text = "";
                         if (discounted) lblPrezzoArticolo.Text =
                                "<strike>" +
                                currencies.tostrusercurrency(articolo.Prezzobase + sumprezzobaseopz) +
                                "</strike>&nbsp;<font color=red>";

                         lblPrezzoArticolo.Text += currencies.tostrusercurrency(articolo.Prezzodoposcontoprodottoutentelistino + sumprezzodoposcontoprodottoutentelistino);

                         if (discounted) lblPrezzoArticolo.Text += "</font>";


                         showScQuant();

        }




    }

}


