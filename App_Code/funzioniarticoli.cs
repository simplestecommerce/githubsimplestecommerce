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

// funzioni statiche per articoli


namespace simplestecommerce
{



    public class articoli : System.Web.UI.Page
    {




         public static double getquantitydiscount (double _price, int _quantity, DataTable _dtquantitydiscount){

             double tmpresult = 0; 
             
             for (int rip = 0; rip < _dtquantitydiscount.Rows.Count; rip++)
             {
                 int inizioFascia = (int)_dtquantitydiscount.Rows[rip]["s_quantita"];
                 if (_quantity >= inizioFascia)
                 {
                     tmpresult = (double)_dtquantitydiscount.Rows[rip]["s_sconto"] ;
                     rip = _dtquantitydiscount.Rows.Count;
                 }
             }

             return tmpresult;
        }




        public static bool esisteArt(int id)
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;

            strSql = "SELECT COUNT(*) FROM tarticoli WHERE art_id=@id";


            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", id));
            cnn.Open();

            int result = Convert.ToInt32(cmd.ExecuteScalar());

            cnn.Close();
            return result > 0;
        }


        public static string getImageByCod(string cod)
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;

            strSql = "SELECT art_imgpreview FROM tarticoli WHERE art_cod=@cod";


            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@cod", cod));
            cnn.Open();

            string result = cmd.ExecuteScalar().ToString();

            cnn.Close();
            return result;
        }

        public static string getImageById(int id)
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;

            strSql = "SELECT art_imgpreview FROM tarticoli WHERE art_id=@id";


            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@id", id));
            cnn.Open();

            string result = "";

            if (cmd.ExecuteScalar() == null) result = "";
            else result = cmd.ExecuteScalar().ToString();

            cnn.Close();
            return result;
        }

        public static DataTable dtRicercaParziale(string prefixText)
        {
            string sql = "Select TOP 50 cat_nome AS NOME from tcategorie Where cat_nome like @prefisso " +
                " UNION Select TOP 50 art_nome AS NOME from tarticoli where art_nome like @prefisso";
            SqlParameter p1 = new SqlParameter("@prefisso", prefixText + "%");
            return helpDb.getDataTable(sql, p1);

        }




        public static SqlDataReader getArtById(int idArt)
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;

            strSql = "SELECT tarticoli.* FROM tarticoli WHERE art_id=@idart ORDER BY art_id ";


            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idart", idArt));
            cnn.Open();

            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public static string getCodArtById(int idArt)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT art_cod FROM tarticoli where art_id=@idart";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idart", idArt));
            string ritorno = cmd.ExecuteScalar().ToString();


            cnn.Close();

            return ritorno;
        }

        public static int getIdArtByCod(string cod)
        {
            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "SELECT art_id FROM tarticoli where art_cod=@cod";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@cod", cod));
            int ritorno = Convert.ToInt32(cmd.ExecuteScalar());


            cnn.Close();

            return ritorno;
        }


        public static int scorte()
        {

            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            int scorte = (int)simplestecommerce.config.getCampoByApplication("config_scorte");


            sql = "SELECT COUNT(*) FROM tarticoli where art_stock<@scorte";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@scorte", scorte));
            int quanti = Convert.ToInt32(cmd.ExecuteScalar());


            cnn.Close();

            return quanti;

        }


        public static DataView getTopSeller(int quanti)
        {
           // ok in simplestecommerce facile
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;
            strSql = "SELECT TOP " + quanti + " art_id " +
            " FROM tarticoli, tcategorie"+ 
            " WHERE cat_id=art_idcat AND art_visibile=1 AND cat_nascondi=0" +
            " ORDER BY art_vendite DESC";


            DataSet ds = new DataSet();

            SqlDataAdapter da = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            da.SelectCommand = cmd;

            cnn.Open();
            da.Fill(ds, "articoli");
            cnn.Close();

            return ds.Tables["articoli"].DefaultView;

        }





      
           



   




        public static SqlDataReader getInEvidenza()
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;

            strSql = "SELECT DISTINCT art_id FROM tcategorie, tarticoli" +
                " WHERE cat_id=art_idcat" +
                " AND art_inevidenza=1 AND art_visibile=1 AND cat_nascondi=0 ORDER BY art_nome";

            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cnn.Open();

            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }






        public static string getNomeCatById(int idCat)
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;


            strSql = "SELECT cat_nome from tcategorie, tarticoli" +
             " WHERE art_idcat = cat_id" +
             " AND cat_nascondi=0" +
             " AND cat_id=@idcat";
            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idcat", idCat));


            cnn.Open();

            string result = cmd.ExecuteScalar().ToString();

            cnn.Close();

            return result;
        }







       








        public static SqlDataReader getArticoloDettaglio(int idArt)
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            SqlCommand cmd = new SqlCommand();
            string strSql;

            cnn.Open();

            strSql = "SELECT tarticoli.* FROM tcategorie, tarticoli"+
            " WHERE cat_id=art_idcat"+
            " AND art_id=@idart"+
            " AND art_visibile=1 AND cat_nascondi=0";

            cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idart", idArt));

            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }



        public static SqlDataReader getArticoloVariante(int nVariante, int idVar)
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;
            strSql = "SELECT * FROM tvariante" + nVariante +
            " WHERE var_id=@idvar";

            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idvar", idVar));

            cnn.Open();
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public static SqlDataReader getNomeVariante(int nVariante, int idArt)
        {

            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            string strSql;
            strSql = "SELECT art_nomevariante" + nVariante +
            " FROM tarticoli WHERE art_id=@idart";

            SqlCommand cmd = new SqlCommand(strSql, cnn);
            cmd.Parameters.Add(new SqlParameter("@idart", idArt));

            cnn.Open();
            return cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }


       






        








        static public string strMarca(string marca)
        {

            if (marca == "") return "N/A";
            else return marca;

        }


    }
}
