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

namespace simplestecommerce
{
    using System;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.HtmlControls;
    using System.Data;
    using System.Data.Common;
    using System.Collections;
    using System.Data.Sql;
    using System.Data.SqlClient;
    using System.Data.SqlTypes;



    public class behindOffertaAscx : UserControl
    {
        public TextBox tBoxSearch;
        public DataList dataListArt;
        DataTable dt;
        int l = 0;
        System.Collections.ArrayList arrOk = new System.Collections.ArrayList();


        public DataTable getArticoliOfferta()
        {



            string sql;
            sql = "SELECT art_id FROM tcategorie, tarticoli WHERE cat_id=art_idcat" +
                " AND art_visibile=1 AND cat_nascondi=0 AND art_inofferta=1";

            DataTable dt;

            dt = simplestecommerce.helpDb.getDataTable(sql);

            return dt;

        }






        void dataListCat_dataBound(object sender, DataListItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRowView drv = (DataRowView)e.Item.DataItem;

                
                simplestecommerce.Listino Currentlistino = ((simplestecommerce.Cart)Session["Cart"]).Listino;
                simplestecommerce.User Currentuser =( (simplestecommerce.Cart)Session["Cart"]).User;
                simplestecommerce.articolo articolo = new articolo((int)drv["art_id"], Currentlistino.Id, Currentlistino.Sconto, Currentuser.Sconto  );



                ((HyperLink)e.Item.FindControl("hLinkArt")).Text = simplestecommerce.lingua.getforfrontendfromdb( articolo.Name );
                ((HyperLink)e.Item.FindControl("hLinkArt")).NavigateUrl = articolo.Linkart;

                ((HtmlAnchor)e.Item.FindControl("linkImage")).HRef = articolo.Linkart;


                Image img = (Image)e.Item.FindControl("imgArt");

                if (articolo.Preview == "")
                    img.ImageUrl = "~/immagini/non_disponibile.gif";
                else img.ImageUrl = articolo.Preview;

                img.ToolTip = simplestecommerce.lingua.getforfrontendfromdb(articolo.Name);

                Label lblPrezzoArticolo = ((Label)e.Item.FindControl("lblPrezzoArticolo"));




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


                double sconto =
                (articolo.Prezzobase - articolo.Prezzodoposcontoprodottoutentelistino) / articolo.Prezzobase * 100;

                if (sconto > 0)
                    ((Label)e.Item.FindControl("lblSconto")).Text += "<br>- " + Math.Round(sconto, 2) + "%";



            }



        }



        void Page_Init()
        {

            dataListArt.ItemDataBound += new DataListItemEventHandler(dataListCat_dataBound);
        }



        void Page_Load()
        {

            dt = getArticoliOfferta();

            DataView dv = new DataView(dt);


            dataListArt.RepeatColumns = 3; //(int)Application["colonneReparti"];
            dataListArt.DataSource = dv;
            dataListArt.DataBind();






        }






    }
}
