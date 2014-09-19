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



    public class behindInEvidenza : UserControl {

        /*


    public Repeater repArt;


    void repArt_dataBound (object sender, RepeaterItemEventArgs e) {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

           DbDataRecord db = (DbDataRecord)(e.Item.DataItem);


           ((HtmlAnchor)e.Item.FindControl("linkArt")).HRef = Server.UrlEncode(simplestecommerce.encodeUrl.mioUrl(  simplestecommerce.lingua.getforfrontendbypseudo(db["art_nome"].ToString())) + "__art" + db["art_id"].ToString() + ".aspx");

           if (db["art_imgpreview"].ToString() == "") ((Image)e.Item.FindControl("img")).ImageUrl = "~/immagini/non_disponibile.gif";
           else
            ((Image)e.Item.FindControl("img")).ImageUrl = db["art_imgpreview"].ToString();


           if (db["art_marca"].ToString() != "")
               ((Label)e.Item.FindControl("lblMarca")).Text = simplestecommerce.articoli.strMarca(db["art_marca"].ToString()) + " ";

           ((Label)e.Item.FindControl("lblNome")).Text= simplestecommerce.lingua.getforfrontendbypseudo(db["art_nome"].ToString() );

           ((Label)e.Item.FindControl("lblPredescr")).Text = simplestecommerce.lingua.getforfrontendbypseudo(db["art_predescrizione"].ToString() );

//           ((Label)e.Item.FindControl("lblPrezzo")).Text = currencies.tostrusercurrency ( articoli.prezzoDopoSconto((double)db["list_prezzobase"],(double)db["list_scontoPerCento"]) ) ;


               if ( (double)articoli.prezzoBase((double)db["list_prezzobase"]) == (double)articoli.prezzoDopoSconto((double)db["list_prezzobase"],(double)db["list_scontoPerCento"])  )
               {

                    ((Label)e.Item.FindControl("lblPrezzo")).Text =  currencies.tostrusercurrency(articoli.ivareSiNo( articoli.prezzoDopoSconto((double)db["list_prezzobase"],(double)db["list_scontoPerCento"])  ,(int)db["art_nIva"]));
               } else {
                   ((Label)e.Item.FindControl("lblPrezzo")).Text = "<strike>" + simplestecommerce.currencies.tostrusercurrency(articoli.ivareSiNo( simplestecommerce.articoli.prezzoBase((double)db["list_prezzobase"])  ,(int)db["art_nIva"])) + "</strike>" +
                   "&nbsp;<font color=red>" + currencies.tostrusercurrency(articoli.ivareSiNo( articoli.prezzoDopoSconto((double)db["list_prezzobase"],(double)db["list_scontoPerCento"])  ,(int)db["art_nIva"])) + "</font>";
               }


        }

    }


    void Page_Init()
    {
     repArt.ItemDataBound += new RepeaterItemEventHandler (repArt_dataBound);
    }

    void Page_Load()
    {
             IDataReader dr = simplestecommerce.articoli.getInEvidenza();

             repArt.DataSource= dr;
             repArt.DataBind();

             dr.Close();

    }

        */

   }
}
