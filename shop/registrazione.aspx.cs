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



    public partial class behindRegistrazioneAspx : Page {

        void showhidemandatoryfields()
        {

            // show hide vat number; 
            int soggetto = int.Parse(listaSoggetti.SelectedValue);
            if (soggetto == 1)
            {
                int result;
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();
                SqlCommand cmd;
                cmd = new SqlCommand("gettaxtype", cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@idregionbilling", int.Parse(listaRegioni.SelectedValue)));
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
                else {
                    pholdervatnumber.Visible=false;
                }

            }
            else pholdervatnumber.Visible = false;



            
            // show hide fiscal code 
            if ( pholdervatnumber.Visible  ) {

                pHolderCodiceFiscale.Visible=true;
            }
            else
            {
                if ((bool)simplestecommerce.config.getCampoByApplication("config_askalwaysforfiscalcode")) {
                    pHolderCodiceFiscale.Visible=true;
                }
                else pHolderCodiceFiscale.Visible=false;
            }




           //  show hide name of firm
            if (soggetto == 1)
            {
                pHolderRagSoc.Visible = true;
            }
            else pHolderRagSoc.Visible = false;




            // show hide telefono
            if ((bool)simplestecommerce.config.getCampoByApplication("config_askfortelephone")) pHolderTelefono.Visible = true;
            else pHolderTelefono.Visible = false;





        }


        public void changedsubject(object o, EventArgs e)
        {
            showhidemandatoryfields();    
        }


       public void changedcountry_click(object o, EventArgs e)
        {
            dlistspidregion.SelectedValue = listaRegioni.SelectedValue;
            showhidemandatoryfields();

        }



        void inviaEmail()
        {


            string pass = textBoxPass.Text;


            string from = (string)Application["config_emailSito"];


            string to = (string)textBoxEmail.Text;

            string subject = simplestecommerce.lingua.getforfrontendbypseudo("register.reminder.email.subject") + " " + (string)Application["config_nomesito"];
            string body;
            body =
            "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("register.reminder.email.body.label.your.access.data") +
            "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("register.reminder.email.body.label.username") + ": " + simplestecommerce.sicurezza.xss.getreplacedencoded (textBoxEmail.Text) +
            "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("register.reminder.email.body.label.password") + ": " + simplestecommerce.sicurezza.xss.getreplacedencoded(pass);

            simplestecommerce.email.send(from, to, subject, body, true);

        }


    void fillFields () {




        listaRegioni.Enabled = false;



        

    }








        bool valida()
        {

            bool myValidation = true;




            if (pHolderTelefono.Visible && textBoxTelefono.Text.Length < 1)
            {

                lblErrTel.ForeColor = System.Drawing.Color.Red;
                lblErrTel.Text = "<br>" + lingua.getforfrontendbypseudo("registration.warning.telephone.mandatory");
                myValidation = false;
            }

            if (pHolderCodiceFiscale.Visible && textBoxCodFisc.Text.Length < 1)
            {

                lblErrCodFisc.ForeColor = System.Drawing.Color.Red;
                lblErrCodFisc.Text = "<br>" + lingua.getforfrontendbypseudo("registration.warning.fiscal.code.mandatory");
                myValidation = false;
            }

            if (pholdervatnumber.Visible && tboxvatnumber.Text.Length < 1)
            {

                lblerrvatnumber.ForeColor = System.Drawing.Color.Red;
                lblerrvatnumber.Text = "<br>" + lingua.getforfrontendbypseudo("registration.warning.vat.number.mandatory");
                myValidation = false;
            }



            string email = textBoxEmail.Text;
            int chiocciola = email.IndexOf("@");
            int punto = email.LastIndexOf(".");
            if (chiocciola < 0 || punto < 0 || chiocciola > punto)
            {
                lblErrEmail.ForeColor = System.Drawing.Color.Red;
                lblErrEmail.Text = "<br>" + lingua.getforfrontendbypseudo( "registration.warning.email.invalid");
                myValidation = false;
            }

            if (textBoxNome.Text == "" || textBoxNome.Text.Length > simplestecommerce.common.maxLenNominativo)
            {
                lblErrNome.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");
                myValidation = false;
            }

            if (textBoxCognome.Text == "" || textBoxCognome.Text.Length > simplestecommerce.common.maxLenNominativo)
            {
                lblErrCognome.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }

            if (listaSoggetti.SelectedValue == "1" && (textBoxRagSoc.Text == "" || textBoxRagSoc.Text.Length > simplestecommerce.common.maxLenNominativo))
            {
                lblErrRagSoc.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }


            if (textBoxIndirizzo.Text == "" || textBoxIndirizzo.Text.Length > simplestecommerce.common.maxLenIndirizzo)
            {
                lblErrIndirizzo.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }
            if (textBoxCap.Text == "" || textBoxCap.Text.Length > simplestecommerce.common.maxLenCap)
            {
                lblErrCap.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }
            if (textBoxLocalita.Text == "" || textBoxLocalita.Text.Length > simplestecommerce.common.maxLenLocalita)
            {
                lblErrLoc.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }

            // shipping validation *********************************************************************************************
            if (tboxspfirstname.Text == "" || tboxspfirstname.Text.Length > simplestecommerce.common.maxLenNome)
            {
                lblerrspfirstname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }
            if (tboxspsecondname.Text == "" || tboxspsecondname.Text.Length > simplestecommerce.common.maxLenNome)
            {
                lblerrspsecondname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }



            if ( tboxspaddress.Text == "" || tboxspaddress.Text.Length > simplestecommerce.common.maxLenIndirizzo)
            {
                lblerrspaddress.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }
            if (tboxsppostalcode.Text == "" || tboxsppostalcode.Text.Length > simplestecommerce.common.maxLenCap)
            {
                lblerrsppostalcode.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }
            if (tboxspcity.Text == "" || tboxspcity.Text.Length > simplestecommerce.common.maxLenLocalita)
            {
                lblerrspcity.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

                myValidation = false;
            }
            // end shipping validation *********************************************************************************************



            return myValidation;

        }


    void buttRegister_click (object sender, EventArgs e) {

        bool campiIdentificativiValidi = true;


        if (textBoxPass.Text == "" || textBoxPass.Text.Length > simplestecommerce.common.maxLenPass)
        {
            lblErrPass.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.fields.empty.field.or.too.much.chars");

            campiIdentificativiValidi = false;
        }

        if ( !cBoxPrivacy.Checked ) {

            lblErrPrivacy.Text = lingua.getforfrontendbypseudo("registration.warning.must.accept.privacy.conditions");
            campiIdentificativiValidi=false;
        }

        if ( !valida() || !campiIdentificativiValidi) return;





            

            string strSql;
            SqlCommand cmd;
            SqlConnection cnn;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            strSql = "SELECT COUNT(*) FROM tutenti WHERE ut_id=@email";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", textBoxEmail.Text));

            bool esisteemail = (Convert.ToInt32(cmd.ExecuteScalar())>0);

            if (esisteemail)  
            {
                cnn.Close();
                lblErrEmail.ForeColor = System.Drawing.Color.Red;
                lblErrEmail.Text = lingua.getforfrontendbypseudo("registration.warning.email.registration.already.exists"); ;
            }
            else {

                strSql = "INSERT INTO tutenti " +
                " (ut_id, ut_email, ut_pass, ut_firstname, ut_secondname, ut_nameoffirm, ut_address, ut_postalcode, ut_city" +
                ", ut_telephone, ut_fiscalcode, ut_vatnumber, ut_listino, ut_protezione, ut_bloccato, ut_newsletter, ut_subject, ut_idregion" +
                ", ut_spfirstname, ut_spsecondname,ut_spaddress, ut_sppostalcode, ut_spcity, ut_spidregion)" +
                " VALUES " +
                " (@id, @email, @pass, @firstname, @secondname, @nameoffirm, @address, @postalcode, @city, @telephone, @fiscalcode ,@vatnumber, @listinotarget ,0" +
                ", @bloccato, @newsletter, @subject, @idregion" +
                ", @spfirstname, @spsecondname, @spaddress, @sppostalcode, @spcity, @spidregion)";

            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", textBoxEmail.Text));
            cmd.Parameters.Add(new SqlParameter("@email", textBoxEmail.Text));
            cmd.Parameters.Add(new SqlParameter("@pass", simplestecommerce.sicurezza.crittmd5.encoda(textBoxPass.Text)));
            cmd.Parameters.Add(new SqlParameter("@firstname", textBoxNome.Text));
            cmd.Parameters.Add(new SqlParameter("@secondname", textBoxCognome.Text));
            cmd.Parameters.Add(new SqlParameter("@nameoffirm", textBoxRagSoc.Text));
            cmd.Parameters.Add(new SqlParameter("@address", textBoxIndirizzo.Text));
            cmd.Parameters.Add(new SqlParameter("@postalcode", textBoxCap.Text));
            cmd.Parameters.Add(new SqlParameter("@city", textBoxLocalita.Text));
            cmd.Parameters.Add(new SqlParameter("@telephone", textBoxTelefono.Text));
            cmd.Parameters.Add(new SqlParameter("@fiscalcode", textBoxCodFisc.Text));
            cmd.Parameters.Add(new SqlParameter("@vatnumber", tboxvatnumber.Text));
            cmd.Parameters.Add(new SqlParameter("@listinotarget", (int)HttpContext.Current.Application["config_listinoTarget"]));
            cmd.Parameters.Add(new SqlParameter("@bloccato", (int)HttpContext.Current.Application["config_login"]));
            cmd.Parameters.Add(new SqlParameter("@newsletter", cBoxNewsletter.Checked));
            cmd.Parameters.Add(new SqlParameter("@subject", int.Parse (listaSoggetti.SelectedValue)));
            cmd.Parameters.Add(new SqlParameter("@idregion", int.Parse(listaRegioni.SelectedValue) ));

            cmd.Parameters.Add(new SqlParameter("@spfirstname", tboxspfirstname.Text));
            cmd.Parameters.Add(new SqlParameter("@spsecondname", tboxspsecondname.Text));
            cmd.Parameters.Add(new SqlParameter("@spaddress", tboxspaddress.Text ));
            cmd.Parameters.Add(new SqlParameter("@sppostalcode", tboxsppostalcode.Text ));
            cmd.Parameters.Add(new SqlParameter("@spcity", tboxspcity.Text));
            cmd.Parameters.Add(new SqlParameter("@spidregion", int.Parse(dlistspidregion.SelectedValue) ));


            cmd.ExecuteNonQuery();

            cnn.Close();

            lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("registration.message.successfull.registration") + "<br>";


                    try {
                        inviaEmail ();
                        lblEsito.Text += simplestecommerce.lingua.getforfrontendbypseudo("registration.message.successfull.registration.reminder.email.sent");
                    } catch (Exception E) {
                        lblEsito.Text += lingua.getforfrontendbypseudo("registration.successfull.but.problem.delivering.reminder.email") +
                            "" + "<br>" + lingua.getforfrontendbypseudo("registration.successfull.but.problem.delivering.reminder.email.problem.detail") + "<br>" +
                            "" + "<font color=red>" +
                            "" + simplestecommerce.sicurezza.xss.getreplacedencoded (E.ToString()) +
                            "" + "</font>" +
                            lingua.getforfrontendbypseudo("<br><br><a href='login.aspx'>" + simplestecommerce.lingua.getforfrontendbypseudo("registration.completed.do.login.link") + "</a><br><br>");
                    }

                    pHolderRegister.Visible = false;
                    pHolderEsito.Visible = true;
           

            }
    }



    void Page_Init() {

        buttRegister.Click+= new EventHandler (buttRegister_click);


        buttRegister.DataBind();
    }


    void Page_Load () {

        simplestecommerce.User Currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;
        if ( !Currentuser.Anonimo)  Response.Redirect("~/shop/updateprofile.aspx");
            

        pHolderEsito.Visible = false;
        pHolderRegister.Visible = true;

        if (!Page.IsPostBack)
        {

                listaSoggetti.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[0]), "0"));
                listaSoggetti.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[1]), "1"));

                listaSoggetti.Items[0].Selected = true;

                DataTable dtRegioni = simplestecommerce.regioni.getAll();


                listaRegioni.DataSource = dtRegioni;
                listaRegioni.DataTextField = "r_nome";
                listaRegioni.DataValueField = "r_id";
                listaRegioni.DataBind();

                dlistspidregion.DataSource = dtRegioni;
                dlistspidregion.DataTextField = "r_nome";
                dlistspidregion.DataValueField = "r_id";
                dlistspidregion.DataBind();

                showhidemandatoryfields();
       }

            if (listaSoggetti.SelectedValue == "1")
            {
                pHolderRagSoc.Visible = true;

            }
            else
            {
                pHolderRagSoc.Visible = false;

            }

        
            
        }





        

    }


 }

