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
    using System.Web.Security;
    using System.Data;
    using System.Data.Common;
    using System.Data.SqlClient;
    using System.Collections;
    using System.Collections.Generic;




    public partial class behindCartConfirmAspx : Page
    {
         public string paypalbusiness;
         public string paypalitemname;
         public string paypalpamount;
         public string paypalcurrencycode;


        void sendMail(simplestecommerce.Cart emailcart, int emailnewidcart)
        {

            simplestecommerce.User emailuser = emailcart.User;

            string body;
            string subject;
            string from;
            string to;

            subject = String.Format( lingua.getforfrontendbypseudo("cartconfirm.order.email.subject") , emailnewidcart, (string)Application["config_nomeSito"]);


            body = "<html>" +
            "<head><style>" +
                "body { font-family:Calibri, Tahoma; font-size:13px}"+
                "td.headeruser {background-color:#6666ff; padding:3px; font-family:Calibri, Tahoma; font-size:13px; color:white}" +
                "td.user {background-color:#a5cbe5; padding:3px; font-family:Calibri, Tahoma; font-size:13px}"+
                "td.headercart {background-color:#6666ff; padding:3px; font-family:Calibri, Tahoma; font-size:13px; color:white}" +
                "td.cartdark {background-color:#a5cbe5; padding:3px; font-family:Calibri, Tahoma; font-size:13px}" +
                "td.cart {background-color:#b7d6eb; padding:3px; font-family:Calibri, Tahoma; font-size:13px}" +

                "</style>" +
                "</head>" +
                "<body>";



            DataRow drmodeofpayment = simplestecommerce.tipiPagamento.getById(emailcart.Idmodeofpayment);
            body += simplestecommerce.lingua.getforfrontendfromdb((string)drmodeofpayment["messaggio"]);

            body+="<table cellpadding=1 cellspacing=2>";

            body += "<tr><td class=headeruser colspan=2>" + simplestecommerce.lingua.getforfrontendbypseudo("cartconfirm.order.email.body.label.billing.data") + "</td>";

            if (!emailuser.Anonimo)
                body += "<tr><td class=user>USERNAME</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Id) + "</td></tr>";

            body += "<tr><td class=user width='150' >" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.legal.subject") + "</td><td class=user width='500'>" + simplestecommerce.sicurezza.xss.getreplacedencoded(lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[emailuser.Subject])) + "</td></tr>";

            body += "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.first.name") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Firstname) + "</td></tr>";

            body += "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.second.name") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Secondname) + "</td></tr>";
           
            if (emailuser.Subject == 1)
                body += "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.name.of.firm") + "</td><td class=user> " + simplestecommerce.sicurezza.xss.getreplacedencoded(emailcart.User.Nameoffirm) + "</td></tr>";

            body +=
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.email") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Email) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.telephone") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Telephone) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.fiscal.code") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Fiscalcode) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.vat.number") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Vatnumber) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.address") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Address) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.postal.code") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Postalcode) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.city") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.City) + "</td></tr>" +
                "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.country") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.regioni.rowregionbyid(emailuser.Idregion)["r_nome"].ToString()) + "</td></tr>";

            body += "<tr><td class=headeruser colspan=2>" + simplestecommerce.lingua.getforfrontendbypseudo("cartconfirm.order.email.body.label.shipping.data") + "</td>" +
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.shipping.first.name") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Spfirstname) + "</td></tr>"+
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.shipping.second.name") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Spsecondname) + "</td></tr>" +
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.shipping.address") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Spaddress) + "</td></tr>" +
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.shipping.postal.code") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Sppostalcode) + "</td></tr>" +
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.shipping.city") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailuser.Spcity) + "</td></tr>" +
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.shipping.country") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.regioni.rowregionbyid(emailuser.Spidregion)["r_nome"].ToString()) + "</td></tr>";

            body += "<tr><td class=headeruser colspan=2>" + simplestecommerce.lingua.getforfrontendbypseudo("cartconfirm.order.email.body.label.final.info") + "</td>";

            body += "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.carrier") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(simplestecommerce.corrieri.rowcarrierbyid(emailcart.Idcarrier)["c_nome"].ToString())) + "</td></tr>";

            body+=
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.mode.of.payment") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(lingua.getforfrontendfromdb(simplestecommerce.modeofpayment.nomeTipPagamById(emailcart.Idmodeofpayment))) + "</td></tr>" +
            "<tr><td class=user>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.notes") + "</td><td class=user>" + simplestecommerce.sicurezza.xss.getreplacedencoded(emailcart.Note) + "</td></tr>";

            body += "</table>";

            body+=
            "<br><br>" +
            "<table cellspacing=2 cellpadding=1 >" +
            "<tr>" +
            "<td width=183 class=headercart><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.product.code") + "</b></td>" +
            "<td width=183 class=headercart><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.product.name") + "</b></td>" +
            "<td width=80 class=headercart><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.price") + "</b></td>" +
            "<td width=40 class=headercart><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.discount") + "</b></td>" +
            "<td width=40 class=headercart><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.quantity") + "</b></td>" +
            "<td width=80 class=headercart><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.amount") + "</b></td>" +
            "</tr>";


            foreach (simplestecommerce.cartItem ripCartItem in emailcart.lista)
            {
                body+="<tr>";

                //art  code
                body +="<td class=cart>" + simplestecommerce.sicurezza.xss.getreplacedencoded(ripCartItem.Articolo.Code) + "</td>";

                //art name
                string artname = simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(ripCartItem.Articolo.Name));
                foreach (simplestecommerce.Choosedvariation v in ripCartItem.Choosedvariations)
                {

                  artname+="<br>" + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(v.Nome)) + "  " + simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getforfrontendfromdb(v.Choosedoption.Testo));
                }
                body += "<td class=cart>" + artname + "</td>";


                // price
                body += "<td class=cart>" + currencies.tostrusercurrency(ripCartItem.Articolo.Prezzobase + ripCartItem.Variationssum) + "</td>";
                body += "<td class=cart>" + Math.Round(ripCartItem.Totaldiscount, 2).ToString() + "%" + "</td>";
                body += "<td class=cart>" + simplestecommerce.sicurezza.xss.getreplacedencoded(ripCartItem.Quantita.ToString()) + "</td>";
                body += "<td class=cart>" + currencies.tostrusercurrency(ripCartItem.Finalprice * ripCartItem.Quantita) + "</td>";

            }

            body += "<tr>" +
            "<td class=cartdark>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.subtotal") + "</td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td  class=cartdark align=center><b>" + emailcart.getTotQuantita().ToString() + "</b></td>" +
            "<td class=cartdark><b>" + currencies.tostrusercurrency(emailcart.Subtotal) + "</b></td>" +
            "</tr>";

            if (emailcart.Coupononsubtotal > 0)
            {
                body+=
                "<td class=cart>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.coupon.discount") + "</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>" + currencies.tostrusercurrency(emailcart.Coupononsubtotal) + "</td>" +
                "</tr>";
            }

            body +=
            "<td class=cart>" + simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrtaxnameinpseudo[emailcart.Taxtype]) +"</td>" +
            "<td class=cart>&nbsp;</td>" +
            "<td class=cart>&nbsp;</td>" +
            "<td class=cart>&nbsp;</td>" +
            "<td class=cart>&nbsp;</td>" +
            "<td class=cart>" + currencies.tostrusercurrency(emailcart.Taxamount) + "</td>" +
            "</tr>";



                body+=
                "<td class=cart>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.label.shipping.costs.and.other") + "</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>" + currencies.tostrusercurrency(emailcart.Shippingcosts) + "</td>" +
                "</tr>";



            if ((bool)Application["config_applytaxonshipping"])
            {

                body +=
                "<td class=cart>" + simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrtaxnameinpseudo[emailcart.Taxtype]) + "&nbsp;" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.label.(tax.on).shipping.costs.and.other") + "</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>" + currencies.tostrusercurrency(emailcart.Taxontransportcosts) + "</td>" +
                "</tr>";
            }

            if (emailcart.Couponaftertaxes > 0)
            {
                body +=
                "<td class=cart>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.coupon.discount.after.taxes") + "</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>&nbsp;</td>" +
                "<td class=cart>" + currencies.tostrusercurrency(emailcart.Couponaftertaxes) + "</td>" +
                "</tr>";
            }

            body +=
            "<td class=cartdark><b>" + lingua.getforfrontendbypseudo("cartconfirm.order.email.body.cart.total") + "</b></td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td class=cartdark>&nbsp;</td>" +
            "<td class=cartdark><b>" + currencies.tostrusercurrency(emailcart.Tot) + "</b></td>" +
            "</tr>";


            body+="</table></body></html>";







         //  Response.Write(body);









            from = (string)Application["config_emailSito"];

            bool okNegoziante = true;

            // email al negoziante
            string eccezione1 = "";
            try
            {
                to = (string)Application["config_emailSito"];
                simplestecommerce.email.send(from, to, subject, body, true);

            }
            catch (Exception E)
            {
                okNegoziante = false;
                eccezione1 = E.ToString();
            }


            if (!okNegoziante)
            {
                lblEsito.Text += 
                    "<font color='red'>" + 
                    String.Format (
                        lingua.getforfrontendbypseudo("cartconfirm.order.warning.problem.in.sending.order.email.to.merchant"),
                        eccezione1.ToString()
                    ) + 
                    "</font>";
            }






            // email all'acquirente
            to = emailcart.User.Email;

            try
            {
                simplestecommerce.email.send(from, to, subject, body, true);
            }
            catch (Exception exc)
            {
            }

        }


        public void buttCc_click(object sender, EventArgs e)
        {

        }



        void Page_Load()
        {


            simplestecommerce.Cart currentcart = (simplestecommerce.Cart)Session["Cart"];
            simplestecommerce.User currentuser = currentcart.User;


            if ((int)Application["config_registrazione"] > 0 && currentuser.Anonimo) Response.Redirect("~/shop/login.aspx");




            if (currentuser.Firstname == null) Response.Redirect("~/shop/cart.aspx");
            if (currentcart.Idcarrier == 0) Response.Redirect("~/shop/cart.aspx");



            if (!Page.IsPostBack)
            {



                if (currentcart.isempty)
                {
                    lblEsito.Text = "<font color='red'>" + lingua.getforfrontendbypseudo("cartconfirm.warning.empty.cart") + "</font>";
                    return;
                }


                foreach (simplestecommerce.cartItem ci in currentcart.lista)
                {
                    //Response.Write("<br>-" + Cart.pseudoerravailability(ci.Articolo.Idart, ci.Quantita));
                    string err = simplestecommerce.lingua.getforfrontendbypseudo ( Cart.pseudoerravailability(ci.Articolo.Idart, ci.Quantita) );
                    if (err != "")
                    {
                        lblEsito.Text = err + "<br>" +
                            simplestecommerce.lingua.getforfrontendbypseudo("cartconfirm.warning.some.products.in.cart.not.available.anymore");
                            return;
                    }

                }

                int newidcart;
                currentcart.save(out newidcart);

                // update stock **********************************************************************
                List<cartItem> lista = currentcart.lista;
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();

                for (int a = 0; a < lista.Count; a++)
                {

                    int ripIdArt = lista[a].Articolo.Idart;
                    int ripQuant = lista[a].Quantita;

                    string strSql;
                    SqlCommand cmd;

                    strSql = "UPDATE tarticoli SET art_stock = art_stock - @quantOrd" +
                    " WHERE art_id=@idart";
                    cmd = new SqlCommand(strSql, cnn);
                    cmd.Parameters.Add(new SqlParameter("@quantOrd", ripQuant));
                    cmd.Parameters.Add(new SqlParameter("@idArt", ripIdArt));
                    cmd.ExecuteNonQuery();
                }
                cnn.Close();

                // end updatestock **************************************************************************************


                sendMail(currentcart, newidcart);


                lblEsito.Text = 
                    "<b>" + 
                    String.Format(
                        lingua.getforfrontendbypseudo("cartconfirm.order.sent.with.number"),
                        newidcart
                    ) +
                    "</b>";

                if (currentcart.Idmodeofpayment == 4)
                {

                    // is paypal
                    pholderpaypal.Visible = true;

                    paypalbusiness = simplestecommerce.config.getCampoByApplication("config_emailpaypal").ToString();
                    paypalitemname =
                        String.Format(
                        simplestecommerce.lingua.getforfrontendbypseudo("cartconfirm.paypalform.itemname"),
                        newidcart.ToString()
                        );
                    paypalpamount = (Math.Round(currentcart.Tot, 2)).ToString().Replace(",", ".");

                    DataTable dtcurrencies = simplestecommerce.currencies.getAvailable();
                    DataRow rowcurrencymaster = dtcurrencies.Rows.Find ( (int)simplestecommerce.config.getCampoByApplication("config_idmastercurrency"))  ;
                    if ( rowcurrencymaster==null) simplestecommerce.problema.redirect("master currency not found in table currencies");
                    paypalcurrencycode = rowcurrencymaster["nome"].ToString();
                    


                }
                else
                {

                 // ripristinareeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee!!  Session["Cart"] = new simplestecommerce.Cart();

                }
            }
        }
    }
}