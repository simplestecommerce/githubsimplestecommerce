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


    public class Cart
    {
        public simplestecommerce.User User = new simplestecommerce.User();
        public simplestecommerce.Listino Listino = new simplestecommerce.Listino();

        public List<cartItem> lista = new List<cartItem>();
        public int nOrdine;


        public int Idmodeofpayment;
        public int Idcarrier;
        public string Note;

        public string Trackingnumber;
        public string Numerofattura;
        public DateTime Datafattura;
        public DateTime Data;
        public int Lavorazione;
        public string Promemoria;

        public bool isempty
        {
            get {
            if (this.lista.Count == 0) return true; else return false;
            }

        }

        public static string pseudoerravailability(int idArt, int quantita)
        {

            
            IDataReader dr = simplestecommerce.articoli.getArticoloDettaglio(idArt);
            if (!dr.Read())
            {
                dr.Close();
                return (simplestecommerce.lingua.getforfrontendbypseudo( "alert.article.with.this.code.is.not.present.anymore")) + simplestecommerce.sicurezza.xss.getreplacedencoded( dr["art_cod"].ToString()) ; 
            }
            int disp = (int)dr["art_disponibilita"];
            double quantDisp = (double)dr["art_stock"];
            dr.Close();


            if (disp == 2) return "";
            else if (disp == 1) return "alert.article.not.available";
            else
            {
                // is 0 index availability
                if (quantDisp >= Convert.ToDouble(quantita)) return "";
                else return "alert.article.quantity.not.in.stock";
            }
       }
 
 
      






        public void addToCart(cartItem CartItem)
        {


            this.lista.Add(CartItem);

        }

        public void remove(cartItem myCartItem)
        {
            this.lista.Remove(myCartItem);

        }


        // inizio calcoli **************************************************************************

        public double Subtotal
        {

            get
            {

                double result = 0;

                foreach (cartItem ripCartItem in this.lista)
                {
                    result += ripCartItem.Finalprice * ripCartItem.Quantita;
                }


                return result;
            }
        }

        public double Coupononsubtotal
        {
            
            get
            {

                if (this.User.Couponcode == null) return 0;
                else
                {
                    DataRow drenabledcouponbycouponcode = simplestecommerce.coupon.rowenabledcouponbycouponcode(this.User.Couponcode);
                    if (drenabledcouponbycouponcode == null)
                    {
                        simplestecommerce.problema.redirect("no more valid coupon");
                        return 0;
                    }
                    else
                    {
                        if (((int)drenabledcouponbycouponcode["applyon"]) != 0)
                        {
                            return 0;
                        }
                        else 
                        {
                            if ((bool)drenabledcouponbycouponcode["ispercent"])
                            {

                                return this.Subtotal * (double)drenabledcouponbycouponcode["discount"] / 100;
                            }
                            else return (double)drenabledcouponbycouponcode["discount"];
                        }
                        
                     }
                }
               
            }

        }

        // taaxtype, 1 is vat
        public int Taxtype
        {

            get
            {
                int result;
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();
                SqlCommand cmd;
                cmd = new SqlCommand("gettaxtype", cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@idregionbilling", this.User.Idregion));
                cmd.Parameters.Add(new SqlParameter("@idmerchantregion", simplestecommerce.config.getCampoByApplication("config_idmerchantregion")));

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                reader.Read();
                result = (int)reader[0];
                reader.Close();
                cnn.Close();

                return result;

            }

        }

        public double Averagetaxrate //  in percento
        {
            get
            {

                if (this.User.Idregion < 1 )
                {

                    simplestecommerce.problema.redirect("User.Idregion not valid");
                }

                double numeratore = 0;
                double mathweight = 0;


                foreach (cartItem ci in this.lista)
                {


                    double taxrate;

                    SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                    cnn.Open();
                    SqlCommand cmd;
                    cmd = new SqlCommand("gettaxrate", cnn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@idart", ci.Articolo.Idart));
                    cmd.Parameters.Add(new SqlParameter("@idregionbilling", this.User.Idregion));
                    cmd.Parameters.Add(new SqlParameter("@subject", this.User.Subject));
                    cmd.Parameters.Add(new SqlParameter("@idmerchantregion", simplestecommerce.config.getCampoByApplication("config_idmerchantregion") ));

                    SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                    reader.Read();
                    taxrate = (double)reader[0];
                    reader.Close();
                    cnn.Close();
                    //HttpContext.Current.Response.Write ("<br>finalprice:" + ci.Finalprice.ToString() );
                    numeratore += ci.Finalprice * ci.Quantita * taxrate / 100;
                    mathweight += ci.Finalprice * ci.Quantita;
                    
                }

                if (mathweight == 0) return 0;
                else return numeratore / mathweight*100;
            }
        }



        

        public double Taxamount
        {

            get
            {
                double basisoftaxation = this.Subtotal - this.Coupononsubtotal;
               return basisoftaxation * this.Averagetaxrate / 100;

            }

        }



        //ok
        public int getTotQuantita()
        {
            
            int quantiArticoli = 0;

            foreach (cartItem ripCartItem in this.lista)
            {


                quantiArticoli += (ripCartItem.Quantita);
            }

            return quantiArticoli;
        }

        // ok
        double getPesoTotale()
        {




            double result = 0;

            foreach (cartItem ripCartItem in this.lista)
            {


                result += ripCartItem.Articolo.Peso * ripCartItem.Quantita;
            }

            return result;


        }

        // ok
        public double Shippingcosts
        {

            get
            {

                if (this.User.Idregion < 1) simplestecommerce.problema.redirect("user.idregion not valid"); 

                    int zona;
                    double spSpedZona;
                    double tempResult;
                    double spCorriere;
                    double sovrapprezzo;
                    DataRow foundDataRow1;
                    DataRow foundDataRow2;

                    double pesoTotale;
                    double spSpedPeso;


                    // calcola spedizione per zona
                    foundDataRow1 = simplestecommerce.admin.regioni.getRegioni().Tables["regioni"].Rows.Find(this.User.Idregion.ToString());
                    if (foundDataRow1 == null)
                    {
                        simplestecommerce.problema.redirect("exception.country.no.more.in.archive");

                    }
                    zona = (int)foundDataRow1["r_zona"];
                    foundDataRow2 = simplestecommerce.spedizione.getZone().Tables["zone"].Rows.Find(zona);
                    if (foundDataRow2 == null)
                    {
                        simplestecommerce.problema.redirect("exception.zone.no.more.in.archive"); 

                    }


                    spSpedZona = (double)foundDataRow2["z_importo"];


                    // calcola spedizione per peso
                    spSpedPeso = 0;
                    pesoTotale = this.getPesoTotale();
                    DataTable dtPesi = simplestecommerce.spedizione.getPesi().Tables["pesi"];
                    for (int rip = 0; rip < dtPesi.Rows.Count; rip++)
                    {

                        if (pesoTotale >= (int)dtPesi.Rows[rip]["p_da"] && pesoTotale <= (int)dtPesi.Rows[rip]["p_a"])
                        {
                            spSpedPeso = (double)dtPesi.Rows[rip]["p_prezzo"];
                            rip = dtPesi.Rows.Count; // per uscire dal ciclo
                        }
                    }

                    // spese per corriere
                    DataRow rowenabledcarrier = simplestecommerce.corrieri.rowenabledcarrierbyid(this.Idcarrier);
                    if (rowenabledcarrier == null) {
                        simplestecommerce.problema.redirect("exception.courier.no.longer.in.archive");
                    }
                    spCorriere = (double)rowenabledcarrier["c_prezzo"];


                    // spese per sovrapprezzo modalita pagamento
                    sovrapprezzo = simplestecommerce.spedizione.getSovrapprezzo(this.Idmodeofpayment, this.Subtotal);





                    double sogliaOmaggio = (double)simplestecommerce.config.getCampoByApplication("config_sogliaspedizioneomaggio");


                    if (this.Subtotal >= sogliaOmaggio)
                    {
                        return (sovrapprezzo >= 0 ? sovrapprezzo : 0);
                    }

                    tempResult =
                           simplestecommerce.spedizione.getSpFisse() + spSpedZona + spSpedPeso + spCorriere + sovrapprezzo;

                    return (tempResult >= 0 ? tempResult : 0);
                }
            }
                
        


        public double Taxontransportcosts
        {
            get{

                    if (!(bool)HttpContext.Current.Application["config_applytaxonshipping"] ) return 0;
                    else return this.Shippingcosts * this.Averagetaxrate/100;
            }
        }





        public double Couponaftertaxes
        {

            get
            {

                if (this.User.Couponcode == null) return 0;
                else
                {
                    DataRow drenabledcouponbycouponcode = simplestecommerce.coupon.rowenabledcouponbycouponcode(this.User.Couponcode);
                    if (drenabledcouponbycouponcode == null)
                    {
                        simplestecommerce.problema.redirect("no more valid coupon");
                        return 0;
                    }
                    else
                    {
                        if (((int)drenabledcouponbycouponcode["applyon"]) != 1)
                        {
                            return 0;
                        }
                        else
                        {
                            if ((bool)drenabledcouponbycouponcode["ispercent"])
                            {


                                return this.Subtotal + this.Taxamount + this.Shippingcosts + Taxontransportcosts *
                                    (double)drenabledcouponbycouponcode["discount"] / 100;
                            }
                            else return (double)drenabledcouponbycouponcode["discount"];
                        }

                    }
                }

            }

        }

        public double Tot
        {

            get
            {


              return  this.Subtotal - this.Coupononsubtotal + this.Taxamount + this.Shippingcosts + Taxontransportcosts - this.Couponaftertaxes;
            }

        }

        public void svuota()
        {

            int quantiItem = this.lista.Count;

            for (int rip = 0; rip <= (quantiItem - 1); rip++)
            {

                this.lista.RemoveAt(0);

            }

        }



        public void save(out int newidcart)
        {

            SqlCommand cmd;
            SqlConnection cnn;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();


            if (this.User.Firstname == null || this.User.Firstname.Length < 1) simplestecommerce.problema.redirect("user firstname not valid");
            

                sql = "SET DATEFORMAT ymd; INSERT INTO tcart " +
                        "(idloggeduser"+
                        ",idcarrier" +
                        ",idmodeofpayment" +
                        ",note" +
                        ",data" +

                        ",guestsubject" +
                        ",guestnameoffirm" +
                        ",guestfirstname" +
                        ",guestsecondname" +
                        ",guestemail" +
                        ",guesttelephone" +
                        ",guestfiscalcode" +
                        ",guestvatnumber" +
                        ",guestaddress" +
                        ",guestpostalcode" +
                        ",guestcity" +
                        ",guestidregion" +


                        ",spfirstname" +
                        ",spsecondname" +
                        ",spaddress" +
                        ",sppostalcode" +
                        ",spcity" +
                        ",spidregion"+

                        ",subtotal, coupononsubtotal, tax, shippingcost, taxonshippingcost, couponaftertaxes, tot, taxtype, userlanguage" +
                        ")" +
                        " VALUES " +
                        "(@idloggeduser, @idcarrier, @idmodeofpayment, @note, @data" +
                        ",@guestsubject,@guestnameoffirm,@guestfirstname,@guestsecondname,@guestemail,@guesttelephone,@guestfiscalcode,@guestvatnumber,@guestaddress,@guestpostalcode,@guestcity,@guestidregion" +
                        ",@spfirstname, @spsecondname, @spaddress, @sppostalcode, @spcity, @spidregion"+
                        ",@subtotal, @coupononsubtotal, @tax, @shippingcost, @taxonshippingcost, @couponaftertaxes, @tot, @taxtype, @userlanguage" +
                        ")";

                cmd = new SqlCommand(sql, cnn);

                if (this.User.Anonimo) cmd.Parameters.AddWithValue("@idloggeduser", System.DBNull.Value);
                else cmd.Parameters.AddWithValue("@idloggeduser", this.User.Id);

                cmd.Parameters.AddWithValue("@idcarrier", this.Idcarrier);
                cmd.Parameters.AddWithValue("@idmodeofpayment", this.Idmodeofpayment);
                cmd.Parameters.AddWithValue("@note", this.Note);
                cmd.Parameters.AddWithValue("@data", DateTime.Now.ToString("yyyyMMdd HH:mm:ss").Replace(".", ":"));

              
                // guest user parameters ****************************************************************************************
                
                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestsubject", this.User.Subject);
                else cmd.Parameters.AddWithValue ("@guestsubject", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestnameoffirm", this.User.Nameoffirm);
                else cmd.Parameters.AddWithValue ("@guestnameoffirm", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestfirstname", this.User.Firstname);
                else cmd.Parameters.AddWithValue ("@guestfirstname", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestsecondname", this.User.Secondname);
                else cmd.Parameters.AddWithValue ("@guestsecondname", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestemail", this.User.Email);
                else cmd.Parameters.AddWithValue ("@guestemail", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guesttelephone", this.User.Telephone);
                else cmd.Parameters.AddWithValue ("@guesttelephone", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestfiscalcode", this.User.Fiscalcode);
                else cmd.Parameters.AddWithValue ("@guestfiscalcode", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestvatnumber", this.User.Vatnumber);
                else cmd.Parameters.AddWithValue ("@guestvatnumber", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestaddress", this.User.Address);
                else cmd.Parameters.AddWithValue ("@guestaddress", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestpostalcode", this.User.Postalcode);
                else cmd.Parameters.AddWithValue ("@guestpostalcode", System.DBNull.Value);
                
                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestcity", this.User.City);
                else cmd.Parameters.AddWithValue ("@guestcity", System.DBNull.Value);

                if ( this.User.Anonimo) cmd.Parameters.AddWithValue ("@guestidregion", this.User.Idregion);
                else cmd.Parameters.AddWithValue ("@guestidregion", System.DBNull.Value);


                


                // shipping parameters *********************************************************************************************
                cmd.Parameters.AddWithValue("@spfirstname", this.User.Spfirstname );
                cmd.Parameters.AddWithValue("@spsecondname", this.User.Spsecondname);
                cmd.Parameters.AddWithValue("@spaddress", this.User.Spaddress);
                cmd.Parameters.AddWithValue("@sppostalcode", this.User.Sppostalcode);
                cmd.Parameters.AddWithValue("@spcity", this.User.Spcity);
                cmd.Parameters.AddWithValue("@spidregion", this.User.Spidregion);

                // calcoli
                cmd.Parameters.AddWithValue("subtotal", this.Subtotal);
                cmd.Parameters.AddWithValue("coupononsubtotal", this.Coupononsubtotal);
                cmd.Parameters.AddWithValue("tax", this.Taxamount);
                cmd.Parameters.AddWithValue("shippingcost", this.Shippingcosts);
                cmd.Parameters.AddWithValue("taxonshippingcost", this.Taxontransportcosts);
                cmd.Parameters.AddWithValue("couponaftertaxes", this.Couponaftertaxes);
                cmd.Parameters.AddWithValue("tot", this.Tot);
                cmd.Parameters.AddWithValue("taxtype", this.Taxtype);
                cmd.Parameters.AddWithValue("userlanguage", HttpContext.Current.Session["currentfrontendlanguagename"].ToString());

                cmd.ExecuteNonQuery();
            


            sql = "SELECT MAX(id) FROM tcart";
            cmd = new SqlCommand(sql, cnn);
            int idCart = Convert.ToInt32(cmd.ExecuteScalar());

            newidcart = idCart;


            foreach (cartItem ci in this.lista)
            {

                if (ci.Quantita > 0)
                {

                    sql = "INSERT INTO tcartitem " +
                    " (idcart, idart, code, name,  finalprice, quantity, preview, peso, totaldiscount)" +
                    " VALUES (@idcart, @idart, @code, @name, @finalprice, @quantity, @preview, @peso, @totaldiscount)";
                    cmd = new SqlCommand(sql, cnn);
                    cmd.Parameters.Add(new SqlParameter("@idcart", idCart));
                    cmd.Parameters.Add(new SqlParameter("@idart", ci.Articolo.Idart));
                    cmd.Parameters.Add(new SqlParameter("@code", ci.Articolo.Code));
                    cmd.Parameters.Add(new SqlParameter("@name", simplestecommerce.lingua.getforfrontendfromdb (ci.Articolo.Name) ));
                    cmd.Parameters.Add(new SqlParameter("@finalprice", ci.Finalprice ));
                    cmd.Parameters.Add(new SqlParameter("@quantity", ci.Quantita));
                    cmd.Parameters.Add(new SqlParameter("@preview", ci.Articolo.Preview));
                    cmd.Parameters.Add(new SqlParameter("@peso", ci.Articolo.Peso));
                    cmd.Parameters.Add(new SqlParameter("@totaldiscount", ci.Totaldiscount));


                    cmd.ExecuteNonQuery();



                    sql = "SELECT MAX(id) FROM tcartitem";
                    cmd = new SqlCommand(sql, cnn);
                    int idCartItem = Convert.ToInt32(cmd.ExecuteScalar());



                    foreach (Choosedvariation v in ci.Choosedvariations)
                    {


                        sql = "INSERT INTO tcartvariation (idcartitem, strvariation, stroption) " +
                                  " VALUES (@idcartitem,@strvariation,@stroption)";
                            cmd = new SqlCommand(sql, cnn);
                            cmd.Parameters.Add(new SqlParameter("@idcartitem", idCartItem));
                            cmd.Parameters.Add(new SqlParameter("@strvariation", simplestecommerce.lingua.getforfrontendfromdb(v.Nome) ));
                            cmd.Parameters.Add(new SqlParameter("@stroption", simplestecommerce.lingua.getforfrontendfromdb(v.Choosedoption.Testo)));
                            cmd.ExecuteNonQuery();
                    }





                }


            }









            cnn.Close();


        }





    }








}