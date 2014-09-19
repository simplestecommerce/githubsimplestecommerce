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



    public partial class behindRepartiAscx : UserControl
    {
  

        public DataTable getReparti()
        {



            string sql;
            sql = "SELECT cat_id, cat_img, cat_nome from tcategorie where cat_nascondi=0 and cat_livello=0 order by cat_nome";

            DataTable dt;

            dt = simplestecommerce.helpDb.getDataTable(sql);

            return dt;

        }






        void listaCat_dataBound(object sender, DataListItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRowView drv = (DataRowView)e.Item.DataItem;


                ((HyperLink)e.Item.FindControl("linkCat")).Text = drv["cat_nome"].ToString();
                ((HyperLink)e.Item.FindControl("linkCat")).NavigateUrl = simplestecommerce.Category.linkforrouting((int)drv["cat_id"]);

                ((HtmlAnchor)e.Item.FindControl("linkImage")).HRef = simplestecommerce.Category.linkforrouting((int)drv["cat_id"]);


                Image img = (Image)e.Item.FindControl("imgCat");

                if (drv["cat_img"].ToString()== "")
                    img.ImageUrl = "~/immagini/non_disponibile.gif";
                else img.ImageUrl = drv["cat_img"].ToString();

                img.ToolTip = simplestecommerce.lingua.getforfrontendbypseudo(drv["cat_nome"].ToString());



                


            }



        }



        void Page_Init()
        {

            listaCat.ItemDataBound += new DataListItemEventHandler(listaCat_dataBound);
        }



        void Page_Load()
        {



            listaCat.DataSource = getReparti();
            listaCat.DataBind();






        }






    }
}
