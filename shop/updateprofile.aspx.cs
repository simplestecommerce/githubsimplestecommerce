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



    public partial class behindupdateprofileAspx : Page
    {










        void prepare()
        {

            if (!Page.IsPostBack)
            {

                listaSoggetti.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[0]), "0"));
                listaSoggetti.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[1]), "1"));

                listaSoggetti.Items[0].Selected = true;

                DataTable dtRegioni = simplestecommerce.regioni.getAll();

                dlistregioni.DataSource = dtRegioni;
                dlistregioni.DataTextField = "r_nome";
                dlistregioni.DataValueField = "r_id";
                dlistregioni.DataBind();


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






        bool valida()
        {

            bool myValidation = true;




            if (pHolderTelefono.Visible && (textBoxTelefono.Text.Length < 1 || textBoxTelefono.Text.Length > simplestecommerce.common.maxLenTelefono))
            {

                lblErrTel.ForeColor = System.Drawing.Color.Red;
                lblErrTel.Text = "<br>" + lingua.getforfrontendbypseudo("updateprofile.warning.telephone.is.empty.or.too.long");
                myValidation = false;
            }

            if (pHolderCodiceFiscale.Visible && (textBoxCodFisc.Text.Length < 1 || textBoxCodFisc.Text.Length > simplestecommerce.common.maxLenCodFisc))
            {

                lblErrCodFisc.ForeColor = System.Drawing.Color.Red;
                lblErrCodFisc.Text = "<br>" + lingua.getforfrontendbypseudo("updateprofile.warning.fiscal.code.is.empty.or.too.long");
                myValidation = false;
            }

            if (pholdervatnumber.Visible && (tboxvatnumber.Text.Length < 1 || tboxvatnumber.Text.Length > simplestecommerce.common.maxLenPIva))
            {
                lblerrvatnumber.ForeColor = System.Drawing.Color.Red;
                lblerrvatnumber.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.vat.number.has.wrong.length");
                myValidation = false;
            }


            if (textBoxNome.Text == "" || textBoxNome.Text.Length > simplestecommerce.common.maxLenNominativo)
            {
                lblErrNome.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");
                myValidation = false;
            }

            if (textBoxCognome.Text == "" || textBoxCognome.Text.Length > simplestecommerce.common.maxLenNominativo)
            {
                lblErrCognome.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }

            if (listaSoggetti.SelectedValue == "1" && (textBoxRagSoc.Text == "" || textBoxRagSoc.Text.Length > simplestecommerce.common.maxLenNominativo))
            {
                lblErrRagSoc.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }


            if (textBoxIndirizzo.Text == "" || textBoxIndirizzo.Text.Length > simplestecommerce.common.maxLenIndirizzo)
            {
                lblErrIndirizzo.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }
            if (textBoxCap.Text == "" || textBoxCap.Text.Length > simplestecommerce.common.maxLenCap)
            {
                lblErrCap.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }
            if (textBoxLocalita.Text == "" || textBoxLocalita.Text.Length > simplestecommerce.common.maxLenLocalita)
            {
                lblErrLoc.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }


            // shipping validation *********************************************************************************************
            if (tboxspfirstname.Text == "" || tboxspfirstname.Text.Length > simplestecommerce.common.maxLenNome)
            {
                lblerrspfirstname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }
            if (tboxspsecondname.Text == "" || tboxspsecondname.Text.Length > simplestecommerce.common.maxLenNome)
            {
                lblerrspsecondname.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }


            if (tboxspaddress.Text == "" || tboxspaddress.Text.Length > simplestecommerce.common.maxLenIndirizzo)
            {
                lblerrspaddress.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }
            if (tboxsppostalcode.Text == "" || tboxsppostalcode.Text.Length > simplestecommerce.common.maxLenCap)
            {
                lblerrsppostalcode.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }
            if (tboxspcity.Text == "" || tboxspcity.Text.Length > simplestecommerce.common.maxLenLocalita)
            {
                lblerrspcity.Text = "<br>" + simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");

                myValidation = false;
            }
            // end shipping validation *********************************************************************************************



            return myValidation;

        }



        void buttUpdate_click(object sender, EventArgs e)
        {

            bool campiIdentificativiValidi = true;

            if (tBoxNewPass.Text == "" || tBoxNewPass.Text.Length > simplestecommerce.common.maxLenPass)
            {
                lblErrNewPass.Text = simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");
                campiIdentificativiValidi = false;
            }

            if (tBoxOldPass.Text == "" || tBoxOldPass.Text.Length > simplestecommerce.common.maxLenPass)
            {
                lblErrOldPass.Text = simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.empty.field.or.too.much.long");
                campiIdentificativiValidi = false;
            }


            if (!valida() || !campiIdentificativiValidi) return;






            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            SqlCommand cmd;
            string strSql;
            cnn.Open();


            // verifica vecchia password
            strSql = "SELECT COUNT(*) from tutenti where ut_id=@id AND ut_pass=@oldpass";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", ((simplestecommerce.Cart)Session["Cart"]).User.Id));
            cmd.Parameters.Add(new SqlParameter("@oldpass", simplestecommerce.sicurezza.crittmd5.encoda(tBoxOldPass.Text)));
            bool okOldPass = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            if (!okOldPass)
            {
                cnn.Close();
                lblErrOldPass.Text = simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.warning.wrong.old.password");
            }
            else
            {

                strSql = "UPDATE tutenti" +
                " SET ut_pass=@pass, ut_firstname=@firstname, ut_secondname=@secondname, ut_nameoffirm=@nameoffirm, ut_address=@address, ut_postalcode=@postalcode" +
                ",ut_city=@city,  ut_telephone=@telephone, ut_fiscalcode=@fiscalcode, ut_vatnumber=@vatnumber" +
                ",ut_newsletter=@newsletter, ut_idregion=@idregion" +
                ",ut_spfirstname=@spfirstname, ut_spsecondname=@spsecondname" +
                ",ut_spaddress=@spaddress, ut_sppostalcode=@sppostalcode, ut_spcity=@spcity, ut_spidregion=@spidregion" +
                " WHERE ut_id=@id";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@pass", simplestecommerce.sicurezza.crittmd5.encoda(tBoxNewPass.Text)));
                cmd.Parameters.Add(new SqlParameter("@firstname", textBoxNome.Text));
                cmd.Parameters.Add(new SqlParameter("@secondname", textBoxCognome.Text));
                cmd.Parameters.Add(new SqlParameter("@nameoffirm", textBoxRagSoc.Text));
                cmd.Parameters.Add(new SqlParameter("@address", textBoxIndirizzo.Text));
                cmd.Parameters.Add(new SqlParameter("@postalcode", textBoxCap.Text));
                cmd.Parameters.Add(new SqlParameter("@city", textBoxLocalita.Text));
                cmd.Parameters.Add(new SqlParameter("@telephone", textBoxTelefono.Text));
                cmd.Parameters.Add(new SqlParameter("@fiscalcode", textBoxCodFisc.Text));
                cmd.Parameters.Add(new SqlParameter("@vatnumber", tboxvatnumber.Text));

                cmd.Parameters.Add(new SqlParameter("@newsletter", cBoxNewsletter.Checked));
                cmd.Parameters.Add(new SqlParameter("@idregion", int.Parse(dlistregioni.SelectedValue)));



                cmd.Parameters.Add(new SqlParameter("@spfirstname", tboxspfirstname.Text));
                cmd.Parameters.Add(new SqlParameter("@spsecondname", tboxspsecondname.Text));
                cmd.Parameters.Add(new SqlParameter("@spaddress", tboxspaddress.Text));
                cmd.Parameters.Add(new SqlParameter("@sppostalcode", tboxsppostalcode.Text));
                cmd.Parameters.Add(new SqlParameter("@spcity", tboxspcity.Text));
                cmd.Parameters.Add(new SqlParameter("@spidregion", int.Parse(dlistspregion.SelectedValue)));


                cmd.Parameters.Add(new SqlParameter("@id", ((simplestecommerce.Cart)Session["Cart"]).User.Id));

                cmd.ExecuteNonQuery();

                cnn.Close();

                pHolderModulo.Visible = false;
                pHolderEsito.Visible = true;
                lblEsito.Text = simplestecommerce.lingua.getforfrontendbypseudo("updateprofile.profile.updated");
            }
        }

        void Page_Init()
        {

            buttUpdate.Click += new EventHandler(buttUpdate_click);


            buttUpdate.DataBind();
        }


        void Page_Load()
        {

            simplestecommerce.User Currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;
            if (Currentuser.Anonimo) Response.Redirect("~/shop/registrazione.aspx");







            if (!Page.IsPostBack)
            {


                string id = Currentuser.Id;


                // prepare **********************************************************************************************************
                listaSoggetti.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[0]), "0"));
                listaSoggetti.Items.Add(new ListItem(simplestecommerce.lingua.getforfrontendbypseudo(simplestecommerce.common.arrPseudoLegalSubject[1]), "1"));

                listaSoggetti.Items[0].Selected = true;

                DataTable dtRegioni = simplestecommerce.regioni.getAll();


                dlistregioni.DataSource = dtRegioni;
                dlistregioni.DataTextField = "r_nome";
                dlistregioni.DataValueField = "r_id";
                dlistregioni.DataBind();

                dlistspregion.DataSource = dtRegioni;
                dlistspregion.DataTextField = "r_nome";
                dlistspregion.DataValueField = "r_id";
                dlistspregion.DataBind();




                // fill fields *********************************************************************************************************
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();

                string strSql = "SELECT * FROM tutenti WHERE ut_id=@id AND ut_bloccato=0";
                SqlCommand cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@id", id));
                SqlDataReader reader = cmd.ExecuteReader();
                if (!reader.Read()) { reader.Close(); cnn.Close(); simplestecommerce.problema.redirect("no such user in db", "registrazione.aspx"); }

                listaSoggetti.SelectedValue = reader["ut_subject"].ToString();
                foreach (ListItem li in listaSoggetti.Items)
                {
                    li.Enabled = false;
                }


                textBoxNome.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_firstname"].ToString());

                textBoxCognome.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_secondname"].ToString());

                textBoxRagSoc.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_nameoffirm"].ToString());

                textBoxIndirizzo.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_address"].ToString());

                textBoxCap.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_postalcode"].ToString());

                textBoxLocalita.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_city"].ToString());

                dlistregioni.SelectedValue = reader["ut_idregion"].ToString();

                // shipping data

                tboxspfirstname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spfirstname"].ToString());
                tboxspsecondname.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spsecondname"].ToString());
                tboxspaddress.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spaddress"].ToString());
                tboxsppostalcode.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_sppostalcode"].ToString());
                tboxspcity.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_spcity"].ToString());
                dlistspregion.SelectedValue = reader["ut_spidregion"].ToString();

                // end shipping data


                lblEmail.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_email"].ToString());

                textBoxTelefono.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_telephone"].ToString());

                textBoxCodFisc.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_fiscalcode"].ToString());

                tboxvatnumber.Text = simplestecommerce.sicurezza.xss.getreplacedencoded(reader["ut_vatnumber"].ToString());

                cBoxNewsletter.Checked = (bool)reader["ut_newsletter"];

                reader.Close();
                cnn.Close();

            }


            // show / hide *******************************************************************
            buttUpdate.Visible = true;
            pHolderPass.Visible = true;


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
                cmd.Parameters.Add(new SqlParameter("@idregionbilling", int.Parse(dlistregioni.SelectedValue)));
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

                pHolderCodiceFiscale.Visible = true;
            }
            else
            {
                if ((bool)simplestecommerce.config.getCampoByApplication("config_askalwaysforfiscalcode"))
                {
                    pHolderCodiceFiscale.Visible = true;
                }
                else pHolderCodiceFiscale.Visible = false;
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

    }

}



