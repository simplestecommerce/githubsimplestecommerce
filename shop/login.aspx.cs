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
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Data;
    using System.Web.Security;
    using simplestecommerce;

    public partial class behindLoginAspx : Page
    {



        public void buttAccedi_click(object sender, EventArgs e)
        {


            Page.Validate();

            if (Page.IsValid)
            {


                if (textBoxEmail.Text.Length > simplestecommerce.common.maxLenEmail || textBoxEmail.Text.Length == 0 || textBoxEmail.Text.LastIndexOf("@") == -1)
                {

                    lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("login.alert.inappropriate.email");
                }
                else if (textBoxPass.Text.Length > simplestecommerce.common.maxLenPass || textBoxPass.Text.Length == 0)
                {

                    lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("login.alert.inappropriate.password");
                }
                else if (!simplestecommerce.User.utenteChecked(textBoxEmail.Text, textBoxPass.Text))
                {

                    lblEsito.Text = "<font color='red'>" + lingua.getforfrontendbypseudo("login.alert.login.denied") + "</font>";

                }
                else
                {
                    ((simplestecommerce.Cart)Session["Cart"]).User.Id = textBoxEmail.Text;



                    Response.Redirect("default.aspx");


                }




            }
        }


    void Page_Load() {






    }


  }


