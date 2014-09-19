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
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Data;
    using System.Data.Common;
    using System.Collections;
    using System.Data.Sql;
    using System.Data.SqlClient;
    using System.Data.SqlTypes;
    using System.Configuration;
    using System.Collections.Generic;

        public partial class behindPreviewAspx: Page  {


        int n = 0;
        public int b = 0;
        public int a = 0;
        protected int idCatSelected;


       public void listaarticoli_PagePropertiesChanging(object o, PagePropertiesChangingEventArgs e)
        {

            datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

            //rebind List View
            showPreviewArticoli();

        }

        public void gocart_click(object o, EventArgs e)
        {

            Response.Redirect(ResolveUrl("~/shop/cart.aspx"));
        }


        public void proseguipaginaprodotto_click(object o, EventArgs e)
        {

            Response.Redirect(((Button)o).CommandArgument);
        }
        public void add(object sender, CommandEventArgs e)
        {
            // sane

            if ((int)Application["config_registrazione"] > 0 && ((simplestecommerce.Cart)Session["Cart"]).User.Anonimo) Response.Redirect("~/shop/login.aspx");

            int idArt = Convert.ToInt32(e.CommandArgument);

            simplestecommerce.Listino Currentlistino = ((simplestecommerce.Cart)Session["Cart"]).Listino;
            simplestecommerce.User Currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;
            simplestecommerce.articolo articolo = new articolo(idArt, Currentlistino.Id, Currentlistino.Sconto, Currentuser.Sconto);


            int riga = Convert.ToInt32(e.CommandName);
            TextBox txt = (TextBox)((listaarticoli.Items[riga]).FindControl("tBoxQuantita"));
            int quantita = 0;


            if (articolo.Variations.Count > 0)
            {

                string msg = simplestecommerce.lingua.getforfrontendbypseudo("preview.alert.this.article.has.variations");

                System.Web.UI.ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "alert('" + msg + "'); document.location='" + ResolveUrl(articolo.Linkart) + "';", true); 

                
                return;



            }
            else if (!Int32.TryParse(txt.Text, out quantita) || quantita<1){
                string msg = simplestecommerce.lingua.getforfrontendbypseudo("preview.alert.inappropriate.quantity");
                simplestecommerce.common.alert(msg, this.Page);

            }
            else
            {

                string errore = simplestecommerce.lingua.getforfrontendbypseudo ( Cart.pseudoerravailability(articolo.Idart  , quantita) );
                if (errore != "")
                {
                    string msg = simplestecommerce.sicurezza.xss.getreplacedencoded( errore ) ;
                    simplestecommerce.common.alert(msg, this.Page);        
                    return;
                }
 
                
                
                ((simplestecommerce.Cart)Session["cart"]).addToCart(new simplestecommerce.cartItem(articolo,quantita, new List<simplestecommerce.Choosedvariation>()));



                string msgbis= String.Format( 
                    simplestecommerce.lingua.getforfrontendbypseudo("preview.alert.product.added.to.cart"), 
                    simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(articolo.Name)));




                simplestecommerce.common.alert(msgbis, this.Page);

                

                

            }
                

                
                
        }






            void dataListSottocat_itemDataBound (object sender, RepeaterItemEventArgs e) {
                //sane
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRowView dr = (DataRowView)(e.Item.DataItem);

                ((HtmlAnchor)e.Item.FindControl("ancorImg")).HRef = simplestecommerce.Category.linkforrouting((int)dr["cat_id"]);



               Image img = (Image)e.Item.FindControl("imgArt");
               if (dr["cat_img"].ToString()=="") {
                   img.Visible=false;
               }
               else
               {
                   {
                       img.ImageUrl = dr["cat_img"].ToString();
                       img.Width = 52;
                   }
               }

               ((HyperLink)e.Item.FindControl("linkNomeSottocat")).Text = simplestecommerce.lingua.getforfrontendfromdb(dr["cat_nome"].ToString());
               ((HyperLink)e.Item.FindControl("linkNomeSottocat")).NavigateUrl = simplestecommerce.Category.linkforrouting((int)dr["cat_id"]);








            }
        }






            public void listaarticoli_databound(object sender, ListViewItemEventArgs e)
            {
                // sane
                b++;
                if (e.Item.ItemType == ListViewItemType.DataItem)
                {

                    DataRowView drv = (DataRowView)(e.Item.DataItem);

                ((Button)e.Item.FindControl("buttAdd")).CommandName = Server.HtmlEncode(n.ToString());
                ((Button)e.Item.FindControl("buttAdd")).CommandArgument = drv["art_id"].ToString();
                n++;



               int idArt = (int)drv["art_id"];


               simplestecommerce.Listino Currentlistino = ((simplestecommerce.Cart)Session["Cart"]).Listino;
               simplestecommerce.User Currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;
               simplestecommerce.articolo articolo = new articolo((int)drv["art_id"], Currentlistino.Id, Currentlistino.Sconto, Currentuser.Sconto);


               Image imgPreview = ((Image)e.Item.FindControl("articoloImgPreview"));
               if (articolo.Preview == "")
               {
                   imgPreview.ImageUrl = "~/immagini/non_disponibile.gif";
                   imgPreview.Width = 90;
               }
               else
               {
                   imgPreview.ImageUrl =
                     "autoresize.aspx?path=" + Server.UrlEncode(Page.ResolveUrl(articolo.Preview));
                   imgPreview.ImageUrl = ResolveUrl(articolo.Preview);
                   imgPreview.Width = 48;
               }
               imgPreview.ToolTip = String.Format( 
                   simplestecommerce.lingua.getforfrontendbypseudo("preview.products.tooltip.see.details"),
                   simplestecommerce.sicurezza.xss.getreplacedencoded ( simplestecommerce.lingua.getforfrontendfromdb(articolo.Name)))
                   
                   ;

               ((Label)e.Item.FindControl("lblMarca")).Text = simplestecommerce.articoli.strMarca ( articolo.Marca );
               Label lblDispArticolo = ((Label)e.Item.FindControl("lblDisp"));

               ((HtmlAnchor)e.Item.FindControl("linkartimg")).HRef = ResolveUrl(articolo.Linkart);

               ((HyperLink)e.Item.FindControl("linkartname")).Text = simplestecommerce.lingua.getforfrontendfromdb(articolo.Name);
               ((HyperLink)e.Item.FindControl("linkartname")).NavigateUrl = ResolveUrl(articolo.Linkart);
               ((HyperLink)e.Item.FindControl("linkartname")).ToolTip = String.Format(
                   simplestecommerce.lingua.getforfrontendbypseudo("preview.products.tooltip.see.details"),
                   simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(articolo.Name)));



               // sdisplay availability
               // show hide placeholder addtocart and display availability
               if (articolo.Disponibilita == 0)
               {

                   if (articolo.Stock < 1)
                   {
                       lblDispArticolo.Text = lingua.getforfrontendbypseudo("preview.products.label.not.in.stock");
                   }
                   else lblDispArticolo.Text = lingua.getforfrontendbypseudo(common.arrPseudoDisponibilita[articolo.Disponibilita]);

               }
               else if (articolo.Disponibilita == 1)
               {

                   lblDispArticolo.Text = lingua.getforfrontendbypseudo(common.arrPseudoDisponibilita[articolo.Disponibilita]);
               }
               else if (articolo.Disponibilita == 2)
               {

                   lblDispArticolo.Text = lingua.getforfrontendbypseudo(common.arrPseudoDisponibilita[articolo.Disponibilita]);
               }
               //**************************************************************




               if (articolo.Consegna != -1)
                   lblDispArticolo.Text += ", " +
                       String.Format(
                            simplestecommerce.lingua.getforfrontendbypseudo("preview.products.label.delivery.in.days"),
                            articolo.Consegna.ToString()); 




               Label lblPrezzoArticolo = ((Label)e.Item.FindControl("lblPrezzo"));



               if (articolo.Prezzobase == articolo.Prezzodoposcontoprodottoutentelistino)
               {
                   // non c'è sconto
                   lblPrezzoArticolo.Text = currencies.tostrusercurrency(articolo.Prezzobase);

               }
               else
               {
                   //c'è sconto
                   lblPrezzoArticolo.Text = "<strike>"
                   + currencies.tostrusercurrency(articolo.Prezzobase).Replace(" ", "&nbsp;")
                   + "</strike>" +
                   "<br><font color=red><b>"
                   + currencies.tostrusercurrency(articolo.Prezzodoposcontoprodottoutentelistino) +
                   "</b></font>";
               }



            }
        }



        void showSottocategorie () {
            // sane
            DataView dv = (DataView)HttpContext.Current.Application["dvvisiblecategoriesorderbyparent"];
            DataRowView[] righe = dv.FindRows(idCatSelected);

            if (righe.Length > 0)
                 {
                     dataListSottocat.DataSource = righe;
                     dataListSottocat.DataBind();
                     panelSottocategorie.Visible = true;
                 }
                    
       }







       void showPreviewArticoli () {

                     // sane   

            SqlCommand cmd;
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

           
            cmd = new SqlCommand("getArticoliByIdCat", cnn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@idCat", idCatSelected));
            cmd.Parameters.Add(new SqlParameter("@ordine", dlistord.SelectedValue));
            cmd.Parameters.Add(new SqlParameter("@marca", dlistmarca.SelectedValue));
            cmd.Parameters.Add(new SqlParameter("@listino",  ((simplestecommerce.Cart)Session["Cart"]).User.Listino));

            SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            DataTable dt = new DataTable();
            dt.Load(reader);
            cnn.Close();

            if (dt.Rows.Count >0) divnoarticles.Visible = false; 

            listaarticoli.DataSource = dt;
            listaarticoli.DataBind();



           


            
   



           
            
        

   




        


        }


    void bindLayout () {
        // sane
        datapager.PageSize = (int)Application["config_artPerPag"];

        dlistord.Items.Add(new ListItem(lingua.getforfrontendbypseudo("preview.products.orderbyselect.order.by"),""));
        dlistord.Items.Add(new ListItem(lingua.getforfrontendbypseudo("preview.products.orderbyselect.order.by.brand"), "marca"));
        dlistord.Items.Add(new ListItem(lingua.getforfrontendbypseudo("preview.products.orderbyselect.order.by.price"), "prezzo"));
        dlistord.Attributes["onLoad"] = "focus.blur()";
        

        // marche per idCatSelected

        SqlCommand cmd;
        SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
        cnn.Open();


        cmd = new SqlCommand("getMarcheByIdCat", cnn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.Add(new SqlParameter("@idcat", idCatSelected));
        SqlDataReader drProd = cmd.ExecuteReader(CommandBehavior.CloseConnection);



        dlistmarca.Items.Add(new ListItem(lingua.getforfrontendbypseudo("preview.products.brandfilter.filter.by.brand"), "-1"));
        while (drProd.Read())
        {
            dlistmarca.Items.Add(new ListItem(drProd["art_marca"].ToString(), drProd["art_marca"].ToString() ));

        }


        drProd.Close();
        cnn.Close();

    }







        void Page_Load() {

            dataListSottocat.ItemDataBound += new RepeaterItemEventHandler(dataListSottocat_itemDataBound);


            //if (!Int32.TryParse((string)Page.RouteData.Values["idCatSelected"], out idCatSelected)) 
            //   if ( !Int32.TryParse (Request.QueryString["idCatSelected"], out idCatSelected ) )
            //        throw new Exception(); //  simplestecommerce.problema.redirect("");

            if (!Int32.TryParse((string)Page.RouteData.Values["idCatselected"], out idCatSelected))
                    throw new Exception(); //  simplestecommerce.problema.redirect("");

                
               



            

            if (!Page.IsPostBack) bindLayout () ;

            if (idCatSelected!=0) showSottocategorie ();

            showPreviewArticoli ();

            Session["lastVisit"] = HttpContext.Current.Request.RawUrl;

       }



        void Page_PreRender()
        {


            

                ArrayList arrPathCat = simplestecommerce.Category.getPathCat(idCatSelected, null);

                Label lblMollicheMaster = (Label)(Master.FindControl("lblMolliche"));


                lblMollicheMaster.Text += common.linkescaped("Home", ResolveUrl("~/shop/default.aspx"), "molliche");


                foreach (simplestecommerce.Category cat in arrPathCat)
                {
                    if (cat.Id > 0)
                    {
                        if (cat.Id != ((simplestecommerce.Category)(arrPathCat[arrPathCat.Count - 1])).Id)
                        {
                            lblMollicheMaster.Text += "&nbsp;&raquo;&nbsp;" + common.linkescaped(simplestecommerce.lingua.getforfrontendfromdb(cat.Name), simplestecommerce.Category.linkforrouting(cat.Id),"molliche");
                        }
                        else
                        {
                            lblMollicheMaster.Text += "&nbsp;&raquo;&nbsp;" + simplestecommerce.lingua.getforfrontendfromdb(cat.Name);
                        }
                    }
                }



            



        }

    }
}



