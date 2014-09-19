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



    public class regioni {

        public static DataTable getAll()
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tregioni ORDER BY r_nome";

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "regioni");
            cnn.Close();

            ds.Tables["regioni"].PrimaryKey = new DataColumn[] { ds.Tables["regioni"].Columns["r_id"] };

            return ds.Tables[0];
        }

        public static DataRow rowregionbyid(int id)
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tregioni where r_id=@id";

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.AddWithValue("id", id);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "regioni");
            cnn.Close();


            return ds.Tables[0].Rows[0];
        }



    }











    public class email
    {



        




        public static void send(string from, string to, string subject, string body, bool formatoHtml)
        {




            SmtpClient emailClient;

            if (simplestecommerce.test.pass != "") { 

                emailClient = new SmtpClient("mail.simplestecommerce.com");

                System.Net.NetworkCredential credential = new System.Net.NetworkCredential 
                    (
                    "autenticazione@simplestecommerce.com",
                    simplestecommerce.test.pass
                    );

                emailClient.UseDefaultCredentials = false;

               emailClient.Credentials = credential;
            }
            else
            {

                if (!(bool)simplestecommerce.config.getCampoByApplication("config_usaautenticazione"))

                    emailClient = new SmtpClient(simplestecommerce.config.getCampoByApplication("config_smtp").ToString());

                else
                {

                    emailClient = new SmtpClient(simplestecommerce.config.getCampoByApplication("config_smtp").ToString());
                    System.Net.NetworkCredential SMTPUserInfo = new System.Net.NetworkCredential(simplestecommerce.config.getCampoByApplication("config_autenticazioneemail").ToString(), simplestecommerce.sicurezza.critt.Decode(simplestecommerce.config.getCampoByApplication("config_autenticazionepass").ToString()));
                    emailClient.UseDefaultCredentials = false;
                    emailClient.Credentials = SMTPUserInfo;


                }

            }


            //create the mail message
            MailMessage message = new MailMessage();

            //set the addresses
            message.From = new MailAddress(from);
            message.To.Add(to);

            //set the content
            message.Subject = subject;
            message.Body = body;
            message.IsBodyHtml = formatoHtml;


            emailClient.Send(message);





        }
    }








    public class currency : System.Web.UI.Page
    {
        private string regione;
        private double cambio;
        private string nome;
        private string separatore;
        private int decimali;
        public currency(string regione, double cambio, string nome, string separatore, int decimali)
        {
            this.regione = regione;
            this.cambio = cambio;
            this.nome = nome;
            this.separatore = separatore;
            this.decimali = decimali;
        }
        public string Regione
        {
            get
            {
                return regione;
            }
            set
            {
                regione = value;
            }
        }
        public double Cambio
        {
            get
            {
                return cambio;
            }
            set
            {
                cambio = value;
            }
        }
        public string Nome
        {
            get
            {
                return nome;
            }
            set
            {
                nome = value;
            }
        }
        public int Decimali
        {
            get
            {
                return decimali;
            }
            set
            {
                decimali=value;
            }
        }
        public string Separatore
        {
            get
            {
                return separatore;
            }
            set
            {
                separatore= value;
            }
        }

    }
















    public class problema
    {

        public static void redirect(string msgnotbypseudo)
        {

            HttpContext.Current.Session["strproblem"] = msgnotbypseudo;
            HttpContext.Current.Response.Redirect("~/problem.aspx");
        }
        public static void redirect(string msgnotbypseudo, string linkReturn)
        {

                HttpContext.Current.Session["strproblem"] = msgnotbypseudo;
                HttpContext.Current.Session["linkreturn"] = linkReturn;
                HttpContext.Current.Response.Redirect("~/problem.aspx");
        }

    }


    public class statistiche
    {


        public static void registraVisita(string pagina, string ip, string referrer)
        {



            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            strSql = "INSERT INTO tvisite (v_pagina, v_ip, v_referrer, v_timestamp)" +
            " VALUES (@pagina, @ip, @referrer,@now)";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@pagina", pagina));
            cmd.Parameters.Add(new SqlParameter("@ip", ip));
            cmd.Parameters.Add(new SqlParameter("@referrer", referrer));
            cmd.Parameters.Add(new SqlParameter("@now", System.DateTime.Now));
            cnn.Open();
            cmd.ExecuteNonQuery();

            cnn.Close();
        }


        public static DataView getElencoVisite(int page, int quantiPerPag, string ord)
        {

            int startRecord = (page - 1) * quantiPerPag;

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tvisite";
            switch (ord)
            {
                case "orario":
                    strSql += " ORDER BY v_id DESC";
                    break;
                case "ip":
                    strSql += " ORDER BY v_ip, v_id DESC";
                    break;
            }

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, startRecord, quantiPerPag, "visite");
            cnn.Close();

            return ds.Tables["visite"].DefaultView;
        }


        public static DataView getElencoReferrer(int page, int quantiPerPag, string ord)
        {

            int startRecord = (page - 1) * quantiPerPag;

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tvisite WHERE v_referrer<>''";
            switch (ord)
            {
                case "orario":
                    strSql += " ORDER BY v_id DESC";
                    break;
                case "ip":
                    strSql += " ORDER BY v_ip, v_id DESC";
                    break;
            }

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, startRecord, quantiPerPag, "visite");
            cnn.Close();

            return ds.Tables["visite"].DefaultView;
        }




        public static int quanteVisiteInElenco()
        {

            string strSql = "SELECT COUNT(*) FROM tvisite";

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            SqlCommand cmd = new SqlCommand(strSql, cnn);

            cnn.Open();
            int quanti = Convert.ToInt32(cmd.ExecuteScalar());
            cnn.Close();
            return quanti;
        }

        public static int quantiReferrer()
        {

            string strSql = "SELECT COUNT(*) FROM tvisite where not (v_referrer='')";

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            SqlCommand cmd = new SqlCommand(strSql, cnn);

            cnn.Open();
            int quanti = Convert.ToInt32(cmd.ExecuteScalar());
            cnn.Close();
            return quanti;
        }


        public static DataView getElencoVisiteAggr()
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT v_pagina, COUNT(*) AS quanti FROM tvisite GROUP BY v_pagina ORDER BY quanti DESC";

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "visiteAggr");
            cnn.Close();

            return ds.Tables["visiteAggr"].DefaultView;
        }


        public static void cutVisite()
        {

            string strSql;
            SqlCommand cmd;

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            strSql = "SELECT COUNT(*) FROM tvisite";
            cmd = new SqlCommand(strSql, cnn);
            int quanti = Convert.ToInt32(cmd.ExecuteScalar());

            int limite = (int)HttpContext.Current.Application["config_nVisite"];


            strSql =
               "DECLARE @quantirecord AS int;" +
               "DECLARE @todelete AS int;" +
               "SELECT @quantirecord = COUNT(*) from tvisite;" +
               "select @todelete = case when (@quantirecord-" + limite + ">0) then (@quantirecord-" + limite + ") else 0 END;" +
               "DELETE top ( @todelete ) from tvisite";
            cmd = new SqlCommand(strSql, cnn);
            cmd.ExecuteNonQuery();


            cnn.Close();

        }


        public static void registraVisita()
        {

            if (HttpContext.Current.Request.Cookies["isAdmin"] != null) return;
            string pathAndQuery = "";
            string referrer = "";
            string ip = "";

            pathAndQuery = HttpContext.Current.Request.Url.PathAndQuery;

            if (pathAndQuery.LastIndexOf("thumbnail.aspx") == -1 && pathAndQuery.LastIndexOf("ordinisimplestecommercexyx.aspx") == -1)
            {

                if (HttpContext.Current.Request.UrlReferrer != null)
                {
                    if (HttpContext.Current.Request.UrlReferrer.AbsoluteUri.IndexOf((string)HttpContext.Current.Application["config_urlSito"]) == -1)
                        referrer = HttpContext.Current.Request.UrlReferrer.AbsoluteUri;
                }

                string rawIp = HttpContext.Current.Request.UserHostAddress;

                ip = rawIp.Length>=4? (rawIp.Remove(0, rawIp.Length - 4)):rawIp;

                simplestecommerce.statistiche.registraVisita(pathAndQuery, ip, referrer);
            }

        }


    }






    



    public class helpDb
    {


        public static DataTable getDataTable(string sql, params SqlParameter[] list)
        {
            DataSet ds;
            SqlConnection cnn;
            SqlDataAdapter da;
            SqlCommand cmd;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            ds = new DataSet();
            da = new SqlDataAdapter();
            cmd = new SqlCommand(sql, cnn);

            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }


            da.SelectCommand = cmd;
            da.Fill(ds, "tabella");

            cnn.Close();

            return ds.Tables["tabella"];

        }


        public static DataTable getDataTableByCnn(string strCnn, string sql, params SqlParameter[] list)
        {
            DataSet ds;
            SqlConnection cnn;
            SqlDataAdapter da;
            SqlCommand cmd;

            cnn = new SqlConnection(strCnn);
            cnn.Open();

            ds = new DataSet();
            da = new SqlDataAdapter();
            cmd = new SqlCommand(sql, cnn);

            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }


            da.SelectCommand = cmd;
            da.Fill(ds, "tabella");

            cnn.Close();

            return ds.Tables["tabella"];

        }

        public static DataTable getDataTableByOpenCnn(SqlConnection cnn, string sql, params SqlParameter[] list)
        {
            DataSet ds;
            SqlDataAdapter da;
            SqlCommand cmd;


            ds = new DataSet();
            da = new SqlDataAdapter();
            cmd = new SqlCommand(sql, cnn);

            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }


            da.SelectCommand = cmd;
            da.Fill(ds, "tabella");


            return ds.Tables[0];

        }







        public static void nonQuery(string sql, params SqlParameter[] list)
        {

            SqlConnection cnn;
            SqlCommand cmd;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            cmd = new SqlCommand(sql, cnn);
            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }

            cmd.ExecuteNonQuery();

            cnn.Close();


        }

        public static void nonQueryByOpenCnn(SqlConnection c, string sql, params SqlParameter[] list)
        {


            SqlCommand cmd;

            cmd = new SqlCommand(sql, c);
            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }

            cmd.ExecuteNonQuery();




        }



        public static void nonQueryByCnn(string strCnn, string sql, params SqlParameter[] list)
        {

            SqlConnection cnn;
            SqlCommand cmd;

            cnn = new SqlConnection(strCnn);
            cnn.Open();

            cmd = new SqlCommand(sql, cnn);
            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }

            cmd.ExecuteNonQuery();

            cnn.Close();


        }








    }






    public class tipiPagamento
    {

        public static void salvaAttivo(int id, int attivo)
        {

            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "UPDATE tipipagamento set attivo=@attivo where id=@id";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@attivo", attivo));
            cmd.Parameters.Add(new SqlParameter("@id", id));
            cmd.ExecuteNonQuery();

            cnn.Close();


        }


        public static DataTable getParziali()
        {

            string sql;
            sql = "SELECT * FROM tipipagamento";

            DataTable dt = helpDb.getDataTable(sql);

            foreach (DataRow dr in dt.Rows)
            {
                if ((int)dr["attivo"] == 0) dr["nome"] = "";

            }

            return dt;
        }


        public static DataTable getAll()
        {

            string sql;
            sql = "SELECT * FROM tipipagamento";

            DataTable dt = helpDb.getDataTable(sql);


            return dt;
        }


        public static DataRow getById(int id)
        {

            string sql;
            sql = "SELECT * FROM tipipagamento where id=@id";
            SqlParameter p1 = new SqlParameter ("@id", id );
            DataRow dr = helpDb.getDataTable(sql,p1).Rows[0];


            return dr;
        }


    }



    public class orderstatus
    {

        public static string namebyid(int id)
        {

            SqlConnection cnn = new SqlConnection(HttpContext.Current.Application["strcnn"].ToString());
            cnn.Open();


            SqlCommand cmd = new SqlCommand("select name from orderstatus where id=@id", cnn);
            cmd.Parameters.AddWithValue("id", id);

            string result = cmd.ExecuteScalar().ToString();


            cnn.Close();

            return result;
        }

        public static DataTable getenabled()
        {

            string sql;
            sql = "SELECT * FROM orderstatus where enabled=1";

            DataTable dt = helpDb.getDataTable(sql);

            return dt;
        }


        public static DataTable getAll()
        {

            string sql;
            sql = "SELECT * FROM orderstatus";

            DataTable dt = helpDb.getDataTable(sql);
            dt.PrimaryKey = new DataColumn[] { dt.Columns["id"] };


            return dt;
        }




    }







    public class utenti
    {










        public static bool esisteUtenteByEmail(string email)
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            string strSql = "SELECT COUNT(*) FROM tutenti WHERE ut_email=@email AND ut_bloccato=0";
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", email));
            bool result = Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            cnn.Close();

            return result;
        }



        public static void cambiaPassword(string email, string pass)
        {


            MD5CryptoServiceProvider md5Hasher = new MD5CryptoServiceProvider();
            byte[] hashedDataBytes = null;
            UTF8Encoding encoder = new UTF8Encoding();
            hashedDataBytes = md5Hasher.ComputeHash(encoder.GetBytes(pass));



            SqlCommand cmd;
            SqlConnection cnn;
            SqlDataReader dr;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            strSql = "UPDATE tutenti set ut_pass=@pass where ut_email=@email AND ut_bloccato=0";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@pass", hashedDataBytes));
            cmd.Parameters.Add(new SqlParameter("@email", email));
            cnn.Open();
            cmd.ExecuteNonQuery();
            cnn.Close();

        }








    }

    public class ordini
    {
        // admin

        public static string adminGetDataInizio()
        {

            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;



            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            strSql = "select MIN(data) FROM tordcart";
            cmd = new SqlCommand(strSql, cnn);

            cnn.Open();

            DateTime result;

            object o = cmd.ExecuteScalar();

            if (o.ToString() == "")
                result = DateTime.Parse("2000/01/01");
            else
                result = DateTime.Parse(o.ToString());

            cnn.Close();

            return ( result.ToString("yyyy-M-d"));
        }

        public static string adminGetDataUltimo()
        {

            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            strSql = "select MAX(data) FROM tcart";
            cmd = new SqlCommand(strSql, cnn);

            cnn.Open();

            DateTime result;

            object o = cmd.ExecuteScalar();

            if (o.ToString() == "")
                result = DateTime.Parse("2100/01/01");
            else
                result = DateTime.Parse(o.ToString());

            cnn.Close();

            return (result.ToString("yyyy-M-d"));

        }





    }



    public class spedizione
    {

        public static DataSet getZone()
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tzone";

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "zone");
            cnn.Close();

            ds.Tables["zone"].PrimaryKey = new DataColumn[] { ds.Tables["zone"].Columns["z_id"] };

            return ds;
        }

        public static double getSpFisse()
        {

           
            double result = (double)simplestecommerce.config.getCampoByApplication("config_spspedfisse");
            

            return result;
        }





        public static DataSet adminGetPesi()
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tpesi ORDER BY p_da";

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "pesi");
            cnn.Close();

            ds.Tables["pesi"].PrimaryKey = new DataColumn[] { ds.Tables["pesi"].Columns["p_id"] };

            return ds;
        }

        public static DataSet getPesi()
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql = "SELECT * FROM tpesi ORDER BY p_da";

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "pesi");
            cnn.Close();

            ds.Tables["pesi"].PrimaryKey = new DataColumn[] { ds.Tables["pesi"].Columns["p_id"] };

            return ds;
        }

        public static void adminAddFasciaPeso(int da, int a, double prezzo)
        {

            string strSql;
            SqlCommand cmd;
            SqlConnection cnn;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            cnn.Open();

            strSql = "INSERT INTO tpesi (p_da, p_a, p_prezzo) VALUES (@da, @a, @prezzo)";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@da", da));
            cmd.Parameters.Add(new SqlParameter("@a", a));
            cmd.Parameters.Add(new SqlParameter("@prezzo", prezzo));
            cmd.ExecuteNonQuery();
            cnn.Close();
        }

        public static void adminDelFasciaPeso(int id)
        {

            string strSql;
            SqlCommand cmd;

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            cnn.Open();

            strSql = "delete  FROM tpesi" +
            " WHERE p_id=@id";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", id));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }


        public static void adminUpdateFascePrezzo(int id, int da, int a, double prezzo)
        {

            string strSql;
            SqlCommand cmd;

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            cnn.Open();

            strSql = "UPDATE tpesi SET " +
            " p_da=@da, p_a=@a, p_prezzo=@prezzo" +
            " WHERE p_id=@id";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@da", da));
            cmd.Parameters.Add(new SqlParameter("@a", a));
            cmd.Parameters.Add(new SqlParameter("@prezzo", prezzo));
            cmd.Parameters.Add(new SqlParameter("@id", id));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }





        public static void updateSovrappr(int id, double prezzo, int modalita)
        {
            string sql = "UPDATE tipipagamento SET" +
                " prezzo=@prezzo, modalita=@modalita WHERE id=@id";

            SqlParameter p1 = new SqlParameter("prezzo", prezzo);
            SqlParameter p2 = new SqlParameter("modalita", modalita);
            SqlParameter p3 = new SqlParameter("id", id);

            helpDb.nonQuery(sql, p1, p2, p3);
        }


        public static double getSovrapprezzo(int id, double sommaParziali)
        {

            SqlConnection cnn;
            SqlCommand cmd;
            SqlDataReader dr;
            string sql;

            int modalita = 0;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT * FROM tipipagamento WHERE id=@id";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", id));

            dr = cmd.ExecuteReader();

            double numero = 0;

            if (!dr.Read()){
                dr.Close();
                simplestecommerce.problema.redirect ("exception.mode.of.payment.no.longer.in.archive"); 
                return 0;
            }
            else
            {
                numero = (double)dr["prezzo"];
                modalita = (int)dr["modalita"];


                dr.Close();
                cnn.Close();

                if (modalita == 0)
                    return sommaParziali * numero / 100;
                else return numero;
            }

        }




    }










    public class pagine
    {


        public static DataTable getpagineinfobox()
        {
            string sql;
            sql = "SELECT * FROM tpagine  where pa_posizione=0 ORDER BY pa_id";

            return helpDb.getDataTable(sql);
        }
        public static DataTable getpaginemenubar()
        {
            string sql;
            sql = "SELECT * FROM tpagine  where pa_posizione=1 ORDER BY pa_id";

            return helpDb.getDataTable(sql);
        }




        public static DataTable getPagine()
        {
            string sql;
            sql = "SELECT * FROM tpagine ORDER BY pa_id";

            return helpDb.getDataTable(sql);
        }

        public static void delete(int id)
        {

            string sql = "delete  FROM tpagine WHERE pa_id=@id";

            SqlParameter p1 = new SqlParameter("id", id);
            helpDb.nonQuery(sql, p1);
        }


        public static SqlDataReader leggi(int id)
        {

            string strSql;

            strSql = "SELECT * FROM tpagine WHERE pa_id=@id";
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", id));
            cnn.Open();
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }


        public static void aggiorna(int id, string nome, string testo, int protezione)
        {
            string sql = "UPDATE tpagine SET" +
                " pa_nome=@nome, pa_testo=@testo, pa_protezione=@protezione" +
                " WHERE pa_id=@id";

            SqlParameter p1 = new SqlParameter("nome", nome);
            SqlParameter p2 = new SqlParameter("testo", testo);
            SqlParameter p3 = new SqlParameter("protezione", protezione);
            SqlParameter p4 = new SqlParameter("id", id);

            helpDb.nonQuery(sql, p1, p2, p3, p4);
        }





    }



    public class listini
    {

        public static SqlDataReader adminGetSconti()
        {

            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            strSql = "SELECT * FROM tlistini";
            cmd = new SqlCommand(strSql, cnn);

            cnn.Open();
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public static void adminUpdateSconto(int idList, double sconto)
        {

            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            strSql = "UPDATE tlistini SET lists_sconto=@sconto WHERE lists_id=@idlist";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@sconto", sconto));
            cmd.Parameters.Add(new SqlParameter("@idList", idList));
            cnn.Open();
            cmd.ExecuteNonQuery();
            cnn.Close();
        }


        public static double getSconto(int idList)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            strSql = "SELECT lists_sconto FROM tlistini WHERE lists_id=@idlist";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idList", idList));

            cnn.Open();
            double result = (double)cmd.ExecuteScalar();
            cnn.Close();

            return result;
        }


        public static void duplica(int source, int target, bool copiaSconti)
        {

            DataSet ds;
            string strSql;
            string strSqlBis;
            SqlConnection cnn;
            SqlDataAdapter da;
            SqlCommand cmd;
            SqlCommand cmdBis;


            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            ds = new DataSet();
            strSql = "SELECT * FROM tlistino where list_n=@source" ;
            da = new SqlDataAdapter();
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add ( new SqlParameter ("@source", source ));
            da.SelectCommand = cmd;
           
            da.Fill(ds, "listinoSource");

            foreach (DataRow drw in ds.Tables["listinoSource"].Rows)
            {
                strSqlBis = "UPDATE tlistino " +
                " SET list_ivaInc=@ivainc, list_prezzobase=@prezzobase";
                if (copiaSconti) strSqlBis += ", list_scontoPerCento=@scontopercento";
                strSqlBis += " WHERE list_n=@target AND list_idart=@idart";
                cmdBis = new SqlCommand(strSqlBis, cnn);

                cmdBis.Parameters.Add(new SqlParameter("@target", target));
                cmdBis.Parameters.Add(new SqlParameter("@ivaInc", (bool)drw["list_ivaInc"]));
                cmdBis.Parameters.Add(new SqlParameter("@prezzobase", (double)drw["list_prezzobase"]));
                if (copiaSconti) cmdBis.Parameters.Add(new SqlParameter("@scontopercento", (double)drw["list_scontoPerCento"]));
                cmdBis.Parameters.Add(new SqlParameter("@idart", (int)drw["list_idart"]));

                cmdBis.ExecuteNonQuery();
            }


            cnn.Close();

        }


    }





    public class mailing
    {





        public static void cancellaEmail(out bool esiste, string email)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            strSql = "SELECT COUNT(*) FROM tmailing WHERE m_email=@email";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", email));

            esiste = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            strSql = "delete  FROM tmailing WHERE m_email=@email";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", email));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }


        public static SqlDataReader getEmails(int target)
        {

            string strSql;

            if (target == 0)
            {
                strSql = "SELECT ut_email FROM tutenti where ut_newsletter=1";
            }
            else strSql = "SELECT m_email FROM tmailing where m_confermato=1";

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cnn.Open();
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }


        public static DataTable getEmailsNewsletter()
        {
            string sql;

            sql = "SELECT * FROM tmailing";

            return helpDb.getDataTable(sql);
        }



        public static void deleteEmail(string email)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();


            strSql = "delete  FROM tmailing WHERE m_email=@email";
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@email", email));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }









    }


    public class scontiQuantita
    {

        public static void add(out bool esisteQuantita, int idArt, int quantita, double sconto)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT COUNT(*) FROM tscontiquantita WHERE s_idart=@idart AND s_quantita=@quantita";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idArt", idArt));
            cmd.Parameters.Add(new SqlParameter("@quantita", quantita));
            esisteQuantita = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            if (esisteQuantita) return;

            sql = "INSERT INTO tscontiquantita (s_idart, s_quantita, s_sconto)" +
            " VALUES (@idart, @quantita, @sconto)";

            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idArt", idArt));
            cmd.Parameters.Add(new SqlParameter("@quantita", quantita));
            cmd.Parameters.Add(new SqlParameter("@sconto", sconto));

            cmd.ExecuteNonQuery();

            cnn.Close();


        }


        public static SqlDataReader readAll(int idArt)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT * FROM tscontiquantita WHERE s_idArt=@idart ORDER BY s_quantita";

            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idArt", idArt));

            return cmd.ExecuteReader(CommandBehavior.CloseConnection);

        }



        public static void update(int idFascia, double sconto)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "UPDATE tscontiquantita SET s_sconto=@sconto WHERE s_id=@idfascia";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@sconto", sconto));
            cmd.Parameters.Add(new SqlParameter("@idFascia", idFascia));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }

        public static void delete(int idFascia)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "delete  FROM tscontiquantita WHERE s_id=@idfascia";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idFascia", idFascia));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }

        public static DataTable getSconti(int idArt)
        {
            DataSet ds;
            string strSql;
            SqlConnection cnn;
            SqlDataAdapter da;
            SqlCommand cmd;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            ds = new DataSet();

            strSql = "SELECT * FROM tscontiquantita WHERE s_idart=@idart ORDER BY s_quantita DESC";
            da = new SqlDataAdapter();
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idArt", idArt));
            da.SelectCommand = cmd;
            da.Fill(ds, "sconti");

            cnn.Close();


            return ds.Tables["sconti"];

        }


        static public double getSconto(int idArt, int quantita)
        {
            double tmpResult = 0;

            DataTable scontiQuantita = getSconti(idArt);

            for (int rip = 0; rip < scontiQuantita.Rows.Count; rip++)
            {
                int inizioFascia = (int)scontiQuantita.Rows[rip]["s_quantita"];
                if (quantita >= inizioFascia)
                {
                    tmpResult = (double)scontiQuantita.Rows[rip]["s_sconto"];
                    rip = scontiQuantita.Rows.Count;
                }
            }

            return tmpResult;
        }

    }

    public class scontiImporto
    {

        public static void add(out bool esisteImporto, int importo, double sconto)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT COUNT(*) FROM tscontiimporto WHERE importo=@importo";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@importo", importo));
            esisteImporto = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            if (esisteImporto)
            {
                cnn.Close();
                return;
            }

            sql = "INSERT INTO tscontiimporto (importo, sconto)" +
            " VALUES (@importo, @sconto)";

            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@importo", importo));
            cmd.Parameters.Add(new SqlParameter("@sconto", sconto));

            cmd.ExecuteNonQuery();

            cnn.Close();


        }

        public static DataTable dtAllDescendant()
        {
            string sql = "SELECT * FROM tscontiimporto ORDER BY importo DESC";
            return (simplestecommerce.helpDb.getDataTable(sql));
        }


        public static SqlDataReader readAll()
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT * FROM tscontiimporto ORDER BY importo";

            cmd = new SqlCommand(sql, cnn);
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);

        }



        public static void update(int idFascia, double sconto)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "UPDATE tscontiimporto SET sconto=@sconto WHERE id=@idfascia";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@sconto", sconto));
            cmd.Parameters.Add(new SqlParameter("@idFascia", idFascia));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }

        public static void delete(int idFascia)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "delete  FROM tscontiimporto WHERE id=@idFascia";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idFascia", idFascia));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }

        public static DataTable getSconti(int idArt)
        {
            DataSet ds;
            string strSql;
            SqlConnection cnn;
            SqlDataAdapter da;
            SqlCommand cmd;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            ds = new DataSet();

            strSql = "SELECT * FROM tscontiquantita WHERE s_idart=@idart ORDER BY s_quantita DESC";
            da = new SqlDataAdapter();
            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idArt", idArt));
            da.SelectCommand = cmd;
            da.Fill(ds, "sconti");

            cnn.Close();


            return ds.Tables["sconti"];

        }


        static public double getSconto(int idArt, int quantita)
        {
            double tmpResult = 0;

            DataTable scontiQuantita = simplestecommerce.scontiQuantita.getSconti(idArt);

            for (int rip = 0; rip < scontiQuantita.Rows.Count; rip++)
            {
                int inizioFascia = (int)scontiQuantita.Rows[rip]["s_quantita"];
                if (quantita >= inizioFascia)
                {
                    tmpResult = (double)scontiQuantita.Rows[rip]["s_sconto"];
                    rip = scontiQuantita.Rows.Count;
                }
            }

            return tmpResult;
        }

    }





    public class notizie
    {

        public static DataTable getNotizia(int idNotizia)
        {

            string sql;
            sql = "SELECT * FROM tnews where n_id=@id";

            SqlParameter p1 = new SqlParameter("id", idNotizia);

            return helpDb.getDataTable(sql, p1);
        }



        public static DataSet getNotizie()
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            DataSet ds = new DataSet();

            string strSql0;

            strSql0 = "SELECT * FROM tnews ORDER BY n_data DESC,n_id DESC";


            SqlDataAdapter da0 = new SqlDataAdapter();
            SqlCommand cmd0 = new SqlCommand(strSql0, cnn);
            da0.SelectCommand = cmd0;


            da0.Fill(ds, "notizie");


            cnn.Close();

            return ds;

        }


        public static DataSet getLastNotizie()
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            DataSet ds = new DataSet();

            string strSql0;

            strSql0 = "SELECT * FROM tnews ORDER BY n_data DESC LIMIT 0,3 ";


            SqlDataAdapter da0 = new SqlDataAdapter();
            SqlCommand cmd0 = new SqlCommand(strSql0, cnn);
            da0.SelectCommand = cmd0;


            da0.Fill(ds, "notizie");


            cnn.Close();

            return ds;

        }




    }

    public class zoom
    {

        public static int lastQuale(int idArt)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT MAX(z_quale) FROM tzoom WHERE z_idart=@idart";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idArt", idArt));

            int result;
            if (cmd.ExecuteScalar() == System.DBNull.Value) result = 0;
            else result = Convert.ToInt32(cmd.ExecuteScalar());

            cnn.Close();

            return result;
        }

        public static void insert(int idArt, string nomeFile, int quale, string width, string height)
        {
            string sql = "INSERT INTO tzoom" +
                " (z_idArt, z_percorso, z_quale, z_width, z_height) VALUES" +
                " (@idart, @nomefile, @quale, @width, @height )";
            SqlParameter p1 = new SqlParameter("@idArt", idArt);
            SqlParameter p2 = new SqlParameter("@nomefile", nomeFile);
            SqlParameter p3 = new SqlParameter("@quale", quale);
            SqlParameter p4 = new SqlParameter("@width", width);
            SqlParameter p5 = new SqlParameter("@height", height);

            helpDb.nonQuery(sql, p1, p2, p3, p4, p5);



        }


        public static DataTable getIngrandimenti(int idArt)
        {
            string sql;
            sql = "SELECT * FROM tzoom WHERE z_idart=@idart ORDER BY z_id";

            SqlParameter p1 = new SqlParameter("@idArt", idArt);

            return helpDb.getDataTable(sql, p1);
        }

        public static void update(int id, string width, string height)
        {

            string sql = "UPDATE tzoom SET" +
                " z_width=@width, z_height=@height" +
                " WHERE z_id=@id";
            SqlParameter p1 = new SqlParameter("@width", width);
            SqlParameter p2 = new SqlParameter("@height", height);
            SqlParameter p3 = new SqlParameter("@id", id);

            helpDb.nonQuery(sql, p1, p2, p3);
        }

        public static void delete(int id)
        {

            string sql = "delete  FROM tzoom WHERE z_id=@id";
            SqlParameter p1 = new SqlParameter("@id", id);

            helpDb.nonQuery(sql, p1);
        }


    }






    public class banner
    {

        public static void updateImg(int n, string nome)
        {

            string sql;

            sql = "update tconfig set config_banner" + n + "=@nome";

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            SqlCommand cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@nome", nome));

            cnn.Open();
            cmd.ExecuteNonQuery();
            cnn.Close();
            simplestecommerce.config.storeConfig();

        }


        public static void salva(int n, bool visibile, string link)
        {

            string sql;

            sql = "update tconfig SET config_banner" + n + "visibile=@visibile" +
                ", config_banner" + n + "link=@link";

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            SqlCommand cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@visibile", visibile ? 1 : 0));
            cmd.Parameters.Add(new SqlParameter("@link", link));

            cnn.Open();
            cmd.ExecuteNonQuery();
            cnn.Close();
            simplestecommerce.config.storeConfig();

        }


    }








}
























