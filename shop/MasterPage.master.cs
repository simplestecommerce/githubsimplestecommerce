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


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Data.SqlTypes;
using System.Collections;
using simplestecommerce;
using System.Threading;
using System.Globalization;
using System.IO;

public partial class MasterPageClass : System.Web.UI.MasterPage
{
    int user;
    public int withmenulink;    

    public void  dlistlanguages_changed(object sender, EventArgs e)
    {

        Session["currentfrontendlanguagename"] = dlistlanguages.SelectedValue.ToString();
        Response.Redirect(Request.Url.AbsoluteUri);
    }


    public void dlistcurrency_changed(object sender, EventArgs e)
    {

        Session["idcurrency"] = Convert.ToInt32(dlistcurrency.SelectedValue);
        CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
        Thread.CurrentThread.CurrentCulture = modified;
        modified.NumberFormat = simplestecommerce.localization.usernumberformatinfo;

        Response.Redirect(Request.Url.AbsoluteUri);

    }


    void showSelectCurrency()
    {


        DataTable dtcurrencies = (DataTable)Application["dtcurrenciesavailable"];
        
        foreach (DataRow drcurrency in dtcurrencies.Rows)
        {

            dlistcurrency.Items.Add(new ListItem(drcurrency["nome"].ToString(), drcurrency["id"].ToString()));
        }

        dlistcurrency.SelectedValue = ((int)Session["idcurrency"]).ToString();
    
    }


    void showlanguages()
    {
        DataTable dt = (DataTable)Application["dtlanguages"];
        foreach (DataColumn col in dt.Columns) 
        {
            if (col.ColumnName!="pseudo" )
            dlistlanguages.Items.Add(new ListItem( col.ColumnName.ToUpper(), col.ColumnName));
        }

        dlistlanguages.SelectedValue = (string)Session["currentfrontendlanguagename"];
    }



    // procedure navigator

    void showMolliche()
    {



        string nomeFile;

        string percorso;


        percorso = Request.Path;

        int slash = percorso.LastIndexOf("/");
        if (slash >= 0)
        {
            nomeFile = percorso.Remove(0, slash + 1);
        }
        else
        {
            nomeFile = "";
        }






        switch (nomeFile.ToLower())
        {



            case "login.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche" ) +
                    "&nbsp;&raquo;&nbsp;Login";
                break;


            case "updateprofile.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.updateprofile");
                break;

            case "registrazione.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.registration");
                break;

            case "top.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.best.seller");
                break;

            case "news.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.news");
                break;

            case "cart.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.cart");
                break;

            case "cartcollect.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + common.linkescaped(lingua.getforfrontendbypseudo("allpages.you.are.here.cart"), "cart.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.data.collect");
                break;

            case "cartsummary.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + common.linkescaped(lingua.getforfrontendbypseudo("allpages.you.are.here.cart"), "cart.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + common.linkescaped(lingua.getforfrontendbypseudo("allpages.you.are.here.data.collect"), "cartcollect.aspx","molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.summary");
                break;


            case "cartconfirm.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + common.linkescaped(lingua.getforfrontendbypseudo("allpages.you.are.here.cart"), "cart.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + common.linkescaped(lingua.getforfrontendbypseudo("allpages.you.are.here.data.collect"), "cartcollect.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + common.linkescaped(lingua.getforfrontendbypseudo("allpages.you.are.here.summary"), "cartsummary.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.order.confirmation");
                break;


            case "articolipertermine.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.search");
                break;

            case "pagina.aspx": {
                if ( Request.QueryString["id"]!=null)  {
                    string custompagename = lingua.getforfrontendfromdb(
                        simplestecommerce.helpDb.getDataTable(
                        "select pa_nome  from tpagine where pa_id=@id",
                        new SqlParameter("id", Convert.ToInt32(Request.QueryString["id"]))
                        ).Rows[0][0].ToString());


                    lblMolliche.Text +=
                        common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                        "&nbsp;&raquo;&nbsp;" +
                      simplestecommerce.sicurezza.xss.getreplacedencoded(  custompagename );
                
                 }

                break;

            }

            case "newsletter.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.newsletter");
                break;

            case "password.aspx":
                lblMolliche.Text += common.linkescaped(simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home"), "default.aspx", "molliche") +
                    "&nbsp;&raquo;&nbsp;" + lingua.getforfrontendbypseudo("allpages.you.are.here.password.recovery");
                break;

            default:
                if (lblMolliche.Text == "") lblMolliche.Text = "&raquo; " + simplestecommerce.lingua.getforfrontendbypseudo("allpages.you.are.here.home");
                break;

        }

        
      Page.ClientScript.RegisterStartupScript(this.GetType(), "key", simplestecommerce.breadcrumbs.getposition.java(this.Page), true);


    }







    protected void Page_Init(object sender, EventArgs e)
    {


        if ( ((int)simplestecommerce.config.getCampoByApplication("config_openClose")) == 1)
        {

            Response.Write(Application["config_msgChiusura"].ToString());
            Response.End();
        }

        

        CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
        Thread.CurrentThread.CurrentCulture = modified;
        modified.NumberFormat = simplestecommerce.localization.usernumberformatinfo;




        simplestecommerce.Cart Currentcart = (simplestecommerce.Cart)(Session["Cart"]);

        simplestecommerce.User Currentuser = Currentcart.User;

        simplestecommerce.Listino Currentlistino = Currentcart.Listino;


        SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
        SqlCommand command;
        SqlDataReader reader;
        cnn.Open();


        if (! Currentuser.Anonimo)
        {
            command =  new SqlCommand("getsomedataloggeduserforeverypage", cnn);
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("userid", Currentuser.Id));
            reader = command.ExecuteReader();


            if (!reader.Read())
            {
                // user has been disabled or deleted during session
                reader.Close();
                cnn.Close();

                Session.Abandon();
                simplestecommerce.problema.redirect("");
            }
            else
            {


                Currentlistino.Sconto = (double)reader["lists_sconto"];
                Currentlistino.Id = (int)reader["ut_listino"];

                Currentuser.Protezione = (int)reader["ut_protezione"];
                Currentuser.Sconto = (double)reader["ut_sconto"];


                reader.Close();
            }



            
        }
        else
        {
            command = new SqlCommand("getscontolistinoforlistinozero", cnn);
            command.CommandType = CommandType.StoredProcedure;
            reader = command.ExecuteReader();
            reader.Read();
            Currentlistino.Sconto = (double)reader[0];
            reader.Close();
        }


        //
        
        List<cartItem> cartitemstoremove = new List<cartItem>();

        foreach (simplestecommerce.cartItem ci in Currentcart.lista)
        {
            bool hasvariations = false;
            foreach (simplestecommerce.Choosedvariation v in ci.Choosedvariations)
            {
                hasvariations = true;
                string sql = "select count(*) from tarticoli, tvarianti, topzioni, tcategorie where" +
                    " tarticoli.art_id=tvarianti.idart and topzioni.idvar=tvarianti.id and art_idcat=cat_id" +
                    " and tarticoli.art_id=@idart and tvarianti.id=@idvar and topzioni.id=@idopz" +
                    " and cat_nascondi=0 and art_visibile=1";

                SqlCommand cmd = new SqlCommand(sql, cnn);
                cmd.Parameters.AddWithValue("idart", ci.Articolo.Idart);
                cmd.Parameters.AddWithValue("idvar", v.Id);
                cmd.Parameters.AddWithValue("idopz", v.Choosedoption.Id);

                

                int quanti = Convert.ToInt32(cmd.ExecuteScalar());
                if (quanti < 1)
                {
                    cartitemstoremove.Add(ci);
                }
            }
            if (!hasvariations) {

                string sql = "select count(*) from tarticoli, tcategorie where art_idcat=cat_id"+
                    " and cat_nascondi=0 and art_visibile=1"+
                    " and art_id=@idart";
                SqlCommand cmd = new SqlCommand(sql, cnn);
                cmd.Parameters.AddWithValue("idart", ci.Articolo.Idart);
                int quanti = Convert.ToInt32(cmd.ExecuteScalar());
                if (quanti < 1)
                {
                    cartitemstoremove.Add(ci);
                }

            } 
        }
        cnn.Close();

        foreach ( simplestecommerce.cartItem ci in cartitemstoremove) {

            Currentcart.lista.Remove(ci);

            string msg = simplestecommerce.lingua.getforfrontendbypseudo("allpages.alert.one.or.more.products.no.more.available.automatically.removed.from.cart");
                
            simplestecommerce.common.alert(msg, this.Page);
            

        }

        
        

        

        

    }

    protected void Page_Load(object sender, EventArgs e)
    {



        Page.Title = simplestecommerce.config.getCampoByApplication("config_nomesito").ToString();
        Page.MetaDescription = simplestecommerce.config.getCampoByApplication("config_metatagdescription").ToString();
        Page.MetaKeywords = simplestecommerce.config.getCampoByApplication("config_metatagkeywords").ToString();
        inheadtag.Text =
            "<script src='" + ResolveUrl("~/js/jquery-1.11.0.min.js") + "'></script>" + "\n" +
            "<script src='" + ResolveUrl("~/js/lightbox.min.js") + "'></script>" + "\n" +
            "<link rel='stylesheet' href='" + ResolveUrl("~/css/struttura.css") + "' type='text/css' />" +
            "<link href='" + ResolveUrl("~/css/lightbox.css") + "' rel='stylesheet' />";

        string logopath;
        if (File.Exists(Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/logo.jpg"))))
            logopath = ResolveUrl(Application["upload"].ToString() + "/logo.jpg");
        else logopath = ResolveUrl("~/immagini/logo.jpg");
        logo.Src = logopath;
        logo.DataBind();

        if (!Page.IsPostBack)
        {
            DataTable dtPagine = simplestecommerce.pagine.getpaginemenubar();
            listmenubarpages.DataSource = dtPagine;
            listmenubarpages.DataBind();
            int totalwidth = 952;
            int npages = 5 + dtPagine.Rows.Count;
            withmenulink = (int)(Math.Round ( (decimal)totalwidth / npages  ,0));
        
        }

        DataTable dtbanners = simplestecommerce.helpDb.getDataTable("select * from tbanner");
        foreach (DataRow drbanner in dtbanners.Rows)
        {

            string strbanner="";
            if ( drbanner["link"].ToString()!="" && drbanner["link"].ToString()!="http://") strbanner="<a href='" + drbanner["link"].ToString() + "'>";
            strbanner+= "<img target='_blank' style='margin-top:2px; border: solid 1px #D1C9C9; width:180px' src='" + ResolveUrl(drbanner["img"].ToString()) + "'  />";
            if (drbanner["link"].ToString() != "") strbanner += "</a>";


            if ((int)drbanner["position"] == 0)
            {

                literalleftbanner.Text += strbanner;
            }
            else literalrightbanner.Text += strbanner;

        }

    }





    void Page_Prerender()
    {


        if (!Page.IsPostBack)
        {
            logo.DataBind(); // header

            showSelectCurrency(); // header

            showlanguages();

        }
        showMolliche();


        if (Request.Url.AbsoluteUri.IndexOf("cartconfirm.aspx") > -1)
        {
            Page.Form.Attributes["onsubmit"] = "document.forms[0].action=getaction(); document.forms[0].submit(); return false";
        }


    }



}
