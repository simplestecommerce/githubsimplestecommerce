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
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Data;
    using System.Data.Common;
    using System.Data.Sql;
    using System.Data.SqlClient;

    public partial class behindCartcollectAspx : Page
    {


        simplestecommerce.User currentuser;
        simplestecommerce.Cart currentcart;


        void showhidemandatoryfields()
        {



            // show hide vat number; 
            int soggetto = int.Parse(dlistsubject.SelectedValue);
            if (soggetto == 1)
            {
                int result;
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();
                SqlCommand cmd;
                cmd = new SqlCommand("gettaxtype", cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@idregionbilling", int.Parse(dlistregion.SelectedValue)));
                cmd.Parameters.Add(new SqlParameter("@idmerchantregion", simplestecommerce.config.getCampoByApplication("config_idmerchantregion")));

                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                reader.Read();
                result = (int)reader[0];
                reader.Close();
                cnn.Close();

                if (result == 1)
                {
                    pholdervatnumber.Visible = true;
                }
                else
                {
                    pholdervatnumber.Visible = false;
                }

            }
            else pholdervatnumber.Visible = false;


            // show hide fiscal code 
            if (pholdervatnumber.Visible)
            {

                pholderfiscalcode.Visible = true;
            }
            else
            {
                if ((bool)simplestecommerce.config.getCampoByApplication("config_askalwaysforfiscalcode"))
                {
                    pholderfiscalcode.Visible = true;
                }
                else pholderfiscalcode.Visible = false;
            }




            //  show hide name of firm
            if (soggetto == 1)
            {
                pholdernameoffirm.Visible = true;
            }
            else pholdernameoffirm.Visible = false;




            // show hide telefono
            if ((bool)simplestecommerce.config.getCampoByApplication("config_askfortelephone")) pholdertelephone.Visible = true;
            else pholdertelephone.Visible = false;









        

        }

        public void changed_subject(object o, EventArgs e)
        {

            showhidemandatoryfields();
        }


        public void region_changed(object o, EventArgs e)
        {
            dlistspregion.SelectedValue = dlistregion.SelectedValue;
            showhidemandatoryfields();
        }


        public void cambioSoggetto(object o, EventArgs e)
        {

            


        }

        public void buttConferma_click(object sender, EventArgs e)
        {

            // start validation

            bool inputValido = true;

            if (currentuser.Anonimo) { 
                // it's anonymous so let's validate billing data
                string email = tboxemail.Text;

                int chiocciola = email.IndexOf("@");
                int punto = email.LastIndexOf(".");
                if (chiocciola < 0 || punto < 0 || chiocciola > punto)
                {
                    lblerremail.ForeColor = System.Drawing.Color.Red;
                    lblerremail.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.invalid.email");
                    inputValido = false;
                }

                if (tboxfirstname.Text == "" || tboxfirstname.Text.Length > simplestecommerce.common.maxLenNominativo)
                {
                    lblerrfirstname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido=false;
                }

                if (tboxsecondname.Text == "" || tboxsecondname.Text.Length > simplestecommerce.common.maxLenNominativo)
                {
                    lblerrsecondname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }

                if (dlistsubject.SelectedValue=="1" &&  (tboxnameoffirm.Text == "" || tboxnameoffirm.Text.Length > simplestecommerce.common.maxLenNominativo))
                {
                    lblerrnameoffirm.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }


                if (tboxaddress.Text == "" || tboxaddress.Text.Length>simplestecommerce.common.maxLenIndirizzo)
                {
                    lblerraddress.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }
                if (tboxpostalcode.Text == "" || tboxpostalcode.Text.Length > simplestecommerce.common.maxLenCap)
                {
                    lblerrpostalcode.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }
                if (tboxcity.Text == "" || tboxcity.Text.Length > simplestecommerce.common.maxLenLocalita)
                {
                    lblerrcity.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }

                if (pholdertelephone.Visible && tboxtelephone.Text.Length < 1)
                {

                    lblerrtelephone.ForeColor = System.Drawing.Color.Red;
                    lblerrtelephone.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.mandatory.telephone");
                    inputValido = false;
                }

                if (pholderfiscalcode.Visible && tboxfiscalcode.Text.Length < 1)
                {

                    lblerrfiscalcode.ForeColor = System.Drawing.Color.Red;
                    lblerrfiscalcode.Text ="<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.mandatory.fiscal.code");
                    inputValido = false;
                }

                if (pholdervatnumber.Visible && tboxvatnumber.Text.Length < 1)
                {

                    lblerrvatnumber.ForeColor = System.Drawing.Color.Red;
                    lblerrvatnumber.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.mandatory.vat.number");
                    inputValido = false;
                }


            }

                // validation shipping data*************************************************************
                if (tboxspfirstname.Text == "" || tboxspfirstname.Text.Length > simplestecommerce.common.maxLenNominativo)
                {
                    lblerrspfirstname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }
                if (tboxspsecondname.Text == "" || tboxspsecondname.Text.Length > simplestecommerce.common.maxLenNominativo)
                {
                    lblerrspsecondname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }
                if (tboxspaddress.Text == "" || tboxspaddress.Text.Length > simplestecommerce.common.maxLenIndirizzo)
                {
                    lblerrspaddress.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }
                if (tboxspcity.Text == "" || tboxspcity.Text.Length > simplestecommerce.common.maxLenLocalita)
                {
                    lblerrspcity.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }
                if (tboxsppostalcode.Text == "" || tboxsppostalcode.Text.Length > simplestecommerce.common.maxLenCap)
                {
                    lblerrsppostalcode.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.fields.empty.or.too.many.chars");
                    inputValido = false;
                }

                //**************************************************************************************



                if (tboxcouponcode.Text != "")
                {
                    DataRow drenabledcoupon = simplestecommerce.coupon.rowenabledcouponbycouponcode (tboxcouponcode.Text);
                    if (drenabledcoupon==null) 
                    {
                        lblerrcouponcode.Text = simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.warning.invalid.coupon");
                        inputValido = false;

                    }
                    else
                    {
                        currentuser.Couponcode = tboxcouponcode.Text;
                    }

                }
  
              
                if (!inputValido)
                {
                 
                    return;
                }

            

            // end of validation

                    //billing data for guest and logged user
                    currentuser.Subject = Convert.ToInt32(dlistsubject.SelectedValue);
                    currentuser.Nameoffirm = tboxnameoffirm.Text;
                    currentuser.Firstname = tboxfirstname.Text;
                    currentuser.Secondname = tboxsecondname.Text;
                    currentuser.Email = tboxemail.Text;
                    currentuser.Telephone = tboxtelephone.Text;
                    currentuser.Fiscalcode = tboxfiscalcode.Text;
                    currentuser.Vatnumber = tboxvatnumber.Text;
                    currentuser.Address = tboxaddress.Text;
                    currentuser.Postalcode = tboxpostalcode.Text;
                    currentuser.City = tboxcity.Text;
                    currentuser.Idregion = int.Parse(dlistregion.SelectedValue);
                





              //shipping *******************************************************************
              currentuser.Spaddress = tboxspaddress.Text;
              currentuser.Spcity = tboxspcity.Text;
              currentuser.Spfirstname = tboxspfirstname.Text;
              currentuser.Sppostalcode = tboxsppostalcode.Text;
              currentuser.Spsecondname = tboxspsecondname.Text;
              currentuser.Spidregion = int.Parse(dlistspregion.SelectedValue.ToString());
              //*****************************************************************************        


              currentcart.Idmodeofpayment = Convert.ToInt32(dlistmodeofpayment.SelectedValue);
              currentcart.Idcarrier = Convert.ToInt32(dlistcarrier.SelectedValue);
              currentcart.Note = Server.HtmlEncode(tareanote.InnerText);







             Response.Redirect("cartsummary.aspx");


            



        }

        void disablefields()
        {

            dlistsubject.Enabled = false;
            tboxfirstname.Enabled = false;
            tboxsecondname.Enabled = false;
            tboxnameoffirm.Enabled = false;
            tboxemail.Enabled = false;
            tboxtelephone.Enabled = false;
            tboxfiscalcode.Enabled = false;
            tboxvatnumber.Enabled = false;
            tboxaddress.Enabled = false;
            tboxpostalcode.Enabled = false;
            tboxcity.Enabled = false;
            dlistregion.Enabled = false;

        }

        void bindControls()
        {
            buttConferma.Text = simplestecommerce.lingua.getforfrontendbypseudo("cartcollect.button.proceed") + " >";

            if ( Request.QueryString["correctdata"]!=null && Request.QueryString["correctdata"].ToString()=="true" )
            {

                if (!currentuser.Anonimo) disablefields();
                tboxfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Firstname);
                tboxsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Secondname);
                tboxnameoffirm.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Nameoffirm);
                tboxemail.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Email);
                tboxtelephone.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Telephone);
                tboxfiscalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Fiscalcode);
                tboxvatnumber.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Vatnumber);
                tboxaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Address);
                tboxpostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Postalcode);
                tboxcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.City);

                // shippin *********************************
                tboxspfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spfirstname);
                tboxspsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spsecondname);
                tboxspaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spaddress);
                tboxspcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Spcity);
                tboxsppostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(currentuser.Sppostalcode);
                // end shipping

                dlistregion.SelectedValue = currentuser.Idregion.ToString();
                dlistspregion.SelectedValue = currentuser.Spidregion.ToString();
                dlistsubject.SelectedValue = currentuser.Subject.ToString();

                try
                {
                    dlistcarrier.SelectedValue = currentcart.Idcarrier.ToString();
                }
                catch { }

                try
                {
                    dlistmodeofpayment.SelectedValue = currentcart.Idmodeofpayment.ToString();
                }
                catch { }
                
                tareanote.InnerText = simplestecommerce.sicurezza.xss.getreplacedencoded(currentcart.Note);


            }
            else
            {
                if (!currentuser.Anonimo)
                {
                    // it's logged user

                    disablefields();

                    SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
                    cnn.Open();


                    SqlCommand command = new SqlCommand("[getloggeduserdataforcartsummaryaspx]", cnn);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("userid", currentuser.Id));
                    SqlDataReader reader = command.ExecuteReader();
                    reader.Read();


                    tboxfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_firstname"].ToString());
                    tboxsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_secondname"].ToString());
                    tboxnameoffirm.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_nameoffirm"].ToString());
                    tboxemail.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_email"].ToString());
                    tboxtelephone.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_telephone"].ToString());
                    tboxfiscalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_fiscalcode"].ToString());
                    tboxvatnumber.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_vatnumber"].ToString());
                    tboxaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_address"].ToString());
                    tboxpostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_postalcode"].ToString());
                    tboxcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_city"].ToString());

                    // shippin *********************************
                    tboxspfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spfirstname"].ToString());
                    tboxspsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spsecondname"].ToString());
                    tboxspaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spaddress"].ToString());
                    tboxspcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spcity"].ToString());
                    tboxsppostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_postalcode"].ToString());
                    // end shipping

                    dlistregion.SelectedValue = reader["ut_idregion"].ToString();
                    dlistspregion.SelectedValue = reader["ut_spidregion"].ToString();


                    dlistsubject.SelectedValue = reader["ut_subject"].ToString();

                    cnn.Close();
                }









            }
        }

        

        void Page_Load()
        {

            currentcart = (Cart)Session["Cart"];
            currentuser = currentcart.User;
            
            if ((int)Application["config_registrazione"] > 0 && currentuser.Anonimo ) Response.Redirect("login.aspx");

            if ( currentuser.Anonimo)
            {
                pHolderVuoiRegistrati.Visible = true;

            }

            


            if (!Page.IsPostBack)
            {
                dlistsubject.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[0]), "0"));
                dlistsubject.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[1]), "1"));
                dlistsubject.Items[0].Selected = true;

                DataTable dtRegioniAccettate = simplestecommerce.regioni.getAll();
                dlistregion.DataSource = dtRegioniAccettate;
                dlistregion.DataTextField = "r_nome";
                dlistregion.DataValueField = "r_id";
                dlistregion.DataBind();

                dlistspregion.DataSource = dtRegioniAccettate;
                dlistspregion.DataTextField = "r_nome";
                dlistspregion.DataValueField = "r_id";
                dlistspregion.DataBind();


                DataTable dt = simplestecommerce.modeofpayment.tableTipPagam;
                foreach (DataRow dr in dt.Rows)
                {
                    if ((int)dr["attivo"] == 1)
                    {
                        double sovrapprezzo;
                        string strSovrapprezzo = "";


                        sovrapprezzo = simplestecommerce.spedizione.getSovrapprezzo((int)dr["id"], currentcart.Subtotal);
                        if (sovrapprezzo != 0) strSovrapprezzo = " +" + currencies.tostrusercurrency(sovrapprezzo);

                        dlistmodeofpayment.Items.Add(new ListItem(simplestecommerce.sicurezza.xss.getreplacedencoded(lingua.getforfrontendfromdb(dr["nome"].ToString()) + " " + strSovrapprezzo), dr["id"].ToString()));
                    }
                }

                // corriere
                {
                    DataTable dtCorrieri = simplestecommerce.corrieri.getenabledcarrier();
                    foreach (DataRow dr in dtCorrieri.Rows)
                    {
                        string strSovrapprezzo = "";
                        double sovrapprezzo;
                        sovrapprezzo = (double)dr["c_prezzo"];
                        if (sovrapprezzo != 0) strSovrapprezzo = " +" + currencies.tostrusercurrency(sovrapprezzo);
                        dlistcarrier.Items.Add(new ListItem(simplestecommerce.sicurezza.xss.getreplacedencoded(lingua.getforfrontendfromdb(dr["c_nome"].ToString()) + strSovrapprezzo), dr["c_id"].ToString()));
                    }
                }

                bindControls();
                showhidemandatoryfields();

            }



            

  

            
         
            
         
        
        }



    }

}
