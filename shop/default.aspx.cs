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




    public partial class behindDefaultAspx : Page
    {



        void Page_Load()
        {


            if ((int)simplestecommerce.config.getCampoByApplication("config_showfeatured") == 1)
            {

               ucOfferta.Visible = true;
            }
            else ucOfferta.Visible = false;

            if ((bool)simplestecommerce.config.getCampoByApplication("config_showboxusato") )
            {

                ucUsato.Visible = true;
            }
            else ucUsato.Visible = false;

        }

    }
}
