/*
 
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
 
*/

using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;
using System.Collections;
using System.Net.Mail;
using System.Web.SessionState;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Web.Caching;
using System.Configuration;
using System.Net;
using System.IO;
using System.Collections.Specialized;
using System.Collections.Generic;
using simplestecommerce;
using System.Security.Cryptography;
using System.Text;


namespace simplestecommerce
{


    public class Dbcart
    {
        public int Idcart { get; private set; }

        public simplestecommerce.Dbuser Dbuser = new simplestecommerce.Dbuser();

        public double Subtotal { get; private set; }
        public double Coupononsubtotal { get; private set; }
        public double Tax { get; private set; }
        public double Shippingcost { get; private set; }
        public double Taxonshippingcost { get; private set; }
        public double Couponaftertax { get; private set; }
        public double Tot { get; private set; }
        public int Taxtype { get; private set; }
        public List<Dbcartitem> lista = new List<Dbcartitem>();
        public int Idmodeofpayment;
        public int Idcarrier;
        public string Note;

        public DateTime Data;
        public int Status;
        public string Promemoria;

        public string Userlanguage { get; private set; }

        public bool isempty
        {
            get
            {
                if (this.lista.Count == 0) return true; else return false;
            }

        }


        public Dbcart(int _idcart)
        {
            this.Idcart = _idcart;
            SqlConnection cnn = new SqlConnection(HttpContext.Current.Application["strCnn"].ToString());
            cnn.Open();

            string sql;

            sql = "select * from tcart where id=@id";

            DataTable dtcart = simplestecommerce.helpDb.getDataTableByOpenCnn(cnn,sql,new SqlParameter("id", _idcart));
            
            if ( dtcart.Rows.Count<1) {
                cnn.Close();
                simplestecommerce.problema.redirect("no order with this ID in database");
            }

            DataRow drcart = dtcart.Rows[0];

            this.Idcarrier = (int)drcart["idcarrier"];
            this.Status = (int)drcart["idorderstatus"];
            this.Data = DateTime.Parse(drcart["data"].ToString());
            this.Promemoria = drcart["promemoria"].ToString();
            this.Dbuser.Id = drcart["idloggeduser"].ToString();
            this.Note = drcart["note"].ToString();

            if (drcart["idloggeduser"] == System.DBNull.Value)
            {

                this.Dbuser.Address = drcart["guestaddress"].ToString();
                this.Dbuser.City = drcart["guestcity"].ToString();
                this.Dbuser.Email = drcart["guestemail"].ToString();
                this.Dbuser.Firstname = drcart["guestfirstname"].ToString();
                this.Dbuser.Fiscalcode = drcart["guestfiscalcode"].ToString();
                this.Dbuser.Idregion = (int)drcart["guestidregion"];
                this.Dbuser.Nameoffirm = drcart["guestnameoffirm"].ToString();
                this.Dbuser.Postalcode = drcart["guestpostalcode"].ToString();
                this.Dbuser.Secondname = drcart["guestsecondname"].ToString();
                this.Dbuser.Subject = (int)drcart["guestsubject"];
                this.Dbuser.Telephone = drcart["guesttelephone"].ToString();
                this.Dbuser.Vatnumber = drcart["guestvatnumber"].ToString();


            }
            else
            {
                DataTable dtloggeduser = simplestecommerce.helpDb.getDataTableByOpenCnn(
                    cnn,
                    "select * from tutenti where ut_id=@idloggeduser",
                    new SqlParameter("idloggeduser", (string)drcart["idloggeduser"])
                    );

                if (dtloggeduser.Rows.Count < 1)
                {
                    cnn.Close();
                    simplestecommerce.problema.redirect("user with ID " + simplestecommerce.sicurezza.xss.getreplacedencoded((string)drcart["idloggeduser"]) + " no longer exists in db");
                }

                DataRow drloggeduser = dtloggeduser.Rows[0];

                this.Dbuser.Address = drloggeduser["ut_address"].ToString();
                this.Dbuser.City = drloggeduser["ut_city"].ToString();
                this.Dbuser.Email = drloggeduser["ut_email"].ToString();
                this.Dbuser.Firstname = drloggeduser["ut_firstname"].ToString();
                this.Dbuser.Fiscalcode = drloggeduser["ut_fiscalcode"].ToString();
                this.Dbuser.Idregion = (int)drloggeduser["ut_idregion"];
                this.Dbuser.Nameoffirm = drloggeduser["ut_nameoffirm"].ToString();
                this.Dbuser.Postalcode = drloggeduser["ut_postalcode"].ToString();
                this.Dbuser.Secondname = drloggeduser["ut_secondname"].ToString();
                this.Dbuser.Subject = (int)drloggeduser["ut_subject"];
                this.Dbuser.Telephone = drloggeduser["ut_telephone"].ToString();
                this.Dbuser.Vatnumber = drloggeduser["ut_vatnumber"].ToString();


            }


            //shipping data
            this.Dbuser.Spaddress = drcart["spaddress"].ToString();
            this.Dbuser.Spcity = drcart["spcity"].ToString();
            this.Dbuser.Spfirstname = drcart["spfirstname"].ToString();
            this.Dbuser.Spidregion = (int)drcart["spidregion"];
            this.Dbuser.Sppostalcode = drcart["sppostalcode"].ToString();
            this.Dbuser.Spsecondname = drcart["spsecondname"].ToString();

            this.Subtotal = (double)drcart["subtotal"];
            this.Coupononsubtotal = (double)drcart["coupononsubtotal"];
            this.Tax = (double)drcart["tax"];
            this.Shippingcost = (double)drcart["shippingcost"];
            this.Taxonshippingcost = (double)drcart["taxonshippingcost"];
            this.Couponaftertax = (double)drcart["couponaftertaxes"];
            this.Tot = (double)drcart["tot"];
            this.Taxtype = (int)drcart["taxtype"];
            this.Userlanguage = drcart["userlanguage"].ToString();


            // cartitems

            DataTable dtcartitem = simplestecommerce.helpDb.getDataTableByOpenCnn(
                cnn,
                "select * from tcartitem where idcart=@idcart",
                new SqlParameter ("idcart", this.Idcart)
                );

            if (dtcartitem.Rows.Count<1) {
                cnn.Close();
                simplestecommerce.problema.redirect ("no cartitems in db with current idcart");
            }
            
            foreach ( DataRow rowcartitem in dtcartitem.Rows) {

                DataTable dtcartvariation = simplestecommerce.helpDb.getDataTableByOpenCnn(
                cnn,
                "select * from tcartvariation where idcartitem=@idcartitem",
                new SqlParameter ("idcartitem", (int)rowcartitem["id"])
                );


                List<Dbcartvariation> workcartvariations = new List<Dbcartvariation>();

                foreach ( DataRow rowcartvariation in dtcartvariation.Rows) {

                    Dbcartvariation workcartvariation = new Dbcartvariation(rowcartvariation["strvariation"].ToString(), rowcartvariation["stroption"].ToString());
                    workcartvariations.Add (workcartvariation);

                }
            
                lista.Add ( new simplestecommerce.Dbcartitem (
                rowcartitem["name"].ToString(),
                rowcartitem["code"].ToString(),
                (double)rowcartitem["finalprice"],
                (int)rowcartitem["quantity"],
                (double)rowcartitem["totaldiscount"],
                (string)rowcartitem["preview"],
                workcartvariations
                ));
                 
                
                
            
            
            }
            
            
            
            
            cnn.Close();


        }









    }




}