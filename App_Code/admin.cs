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
using System.Collections.Generic;

using System.Text;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;
using System.Collections;
using System.Web.Mail;
using System.Web.SessionState;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Web.Caching;
using System.Configuration;
using System.Net;
using System.IO;
using System.Security.Cryptography;
using simplestecommerce;

namespace simplestecommerce
{

    namespace admin
    {




        
public class localization
{
    public static NumberFormatInfo primarynumberformatinfo {
        get {
            NumberFormatInfo worknumberformatinfo;

            DataRow rowprimarycurrency = ((DataTable)HttpContext.Current.Application["dtcurrenciesavailable"]).Rows.Find((int)simplestecommerce.config.getCampoByApplication("config_idmastercurrency"));
            CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
            worknumberformatinfo = modified.NumberFormat;
            worknumberformatinfo.CurrencySymbol = rowprimarycurrency["nome"].ToString();
            worknumberformatinfo.CurrencyDecimalDigits = (int)rowprimarycurrency["decimali"];
            worknumberformatinfo.CurrencyDecimalSeparator = (string)rowprimarycurrency["decimalseparatorsymbol"];
            worknumberformatinfo.CurrencyGroupSeparator = (string)rowprimarycurrency["groupseparatorsymbol"];



            worknumberformatinfo.NumberDecimalSeparator = (string)rowprimarycurrency["decimalseparatorsymbol"];
            worknumberformatinfo.NumberGroupSeparator = "";
            return worknumberformatinfo;
        }
      }
	
}








        public class listino
        {

            public double Prezzo;
            public double ScontoPerCento;
            public int IvaInc;

            public listino(double prezzo, double scontoPerCento)
            {

                this.Prezzo = prezzo;
                this.ScontoPerCento = scontoPerCento;
            }
        }

        public class sicurezza
        {

            public static bool adminAutenticato(string pass)
            {


                SqlConnection cnn;
                SqlCommand cmd;
                string sql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();

                sql = "SELECT COUNT(*) FROM tconfig where config_pwadmin=@pass";
                cmd = new SqlCommand(sql, cnn);
                cmd.Parameters.Add(new SqlParameter("@pass", simplestecommerce.sicurezza.crittmd5.encoda(pass)));
                int quanti = Convert.ToInt32(cmd.ExecuteScalar().ToString());
                cnn.Close();

                return quanti > 0;

            }


            public static void cambioPass(string pass)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;


                MD5CryptoServiceProvider md5Hasher = new MD5CryptoServiceProvider();
                byte[] hashedDataBytes = null;
                UTF8Encoding encoder = new UTF8Encoding();
                hashedDataBytes = md5Hasher.ComputeHash(encoder.GetBytes(pass));



                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "UPDATE tconfig SET config_pwadmin=@pass";

                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@pass", hashedDataBytes));

                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();
                simplestecommerce.config.storeConfig();
            }



        }


        

        public class regioni
        {


            // admin
            public static DataSet getRegioni()
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

                return ds;
            }


            //admin
            public static void updateRegione(int id, string nome, int zona)
            {

                string strSql;
                SqlCommand cmd;

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                cnn.Open();

                strSql = "UPDATE tregioni " +
                " SET r_nome=@nome, r_zona=@zona" +
                " WHERE r_id=@id";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@nome", nome));
                cmd.Parameters.Add(new SqlParameter("@zona", zona));
                cmd.Parameters.Add(new SqlParameter("@id", id));
                cmd.ExecuteNonQuery();

                cnn.Close();
            }

            //admin
            public static void delRegione(int id)
            {

                string strSql;
                SqlCommand cmd;

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                cnn.Open();

                strSql = "delete  FROM tregioni" +
                " WHERE r_id=@id";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@id", id));
                cmd.ExecuteNonQuery();

                cnn.Close();
            }



        }

        public class generale
        {

            public static SqlDataReader getArticoloDettaglio(int idArt)
            {

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                SqlCommand cmd = new SqlCommand();
                string strSql;

                cnn.Open();

                strSql = "SELECT tarticoli.* FROM tcategorie, tarticoli" +
                " WHERE cat_id=art_idcat" +
                " AND art_id=@idart";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idart", idArt));

                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }

            public static object getCampo(string nomeCampo, int idArt)
            {


                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "SELECT " + nomeCampo + " FROM tarticoli WHERE art_id=@idart";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idart", idArt));
                cnn.Open();
                object result;
                result = cmd.ExecuteScalar();
                cnn.Close();

                return result;


            }




            // admin
            public static SqlDataReader getCatSottocat(int id)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "SELECT * FROM tcategorie WHERE cat_id=@id ORDER BY cat_nome";

                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@id", id));

                cnn.Open();
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }

            // admin
            public static SqlDataReader getCats()
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "SELECT * FROM tcategorie WHERE cat_livello=0";

                cmd = new SqlCommand(strSql, cnn);

                cnn.Open();
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);

            }









            public static void updateImgCat(int id, string img)
            {



                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();

                strSql = "UPDATE tcategorie" +
                " SET cat_img=@img" +
                " WHERE cat_id=@id";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@img", img));
                cmd.Parameters.Add(new SqlParameter("@id", id));
                cmd.ExecuteNonQuery();

                cnn.Close();
            }



































            // admin
            public static void updateSottocat(string nomeCat, int idCat, int idCatPadre)
            {


                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "UPDATE tcategorie SET cat_nome=@nomeCat, cat_idpadre=@idpadre WHERE cat_id=@idCat";

                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@nomeCat", nomeCat));
                cmd.Parameters.Add(new SqlParameter("@idpadre", idCatPadre));
                cmd.Parameters.Add(new SqlParameter("@idCat", idCat));

                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();
            }

            // admin
            public static void creaSottocat(string nomeCat, int idCatPadre)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "INSERT INTO tcategorie (cat_nome, cat_livello, cat_idpadre)" +
                " VALUES (@nomeCat,1,@cat_idpadre)";

                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@nomeCat", nomeCat));
                cmd.Parameters.Add(new SqlParameter("@cat_idpadre", idCatPadre));
                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();
            }

            // admin
            public static void deleteSottocat(int idCat)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "delete  FROM tcategorie WHERE cat_id=@idcat";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idCat", idCat));

                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();
            }


            // ------------------------ admin varianti --------------------------------------------------------

            public static void updateNomeVariante(int idArt, int nVariante, string nomeVariante)
            {

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                string strSql;
                strSql = "UPDATE tarticoli" +
                " SET art_nomevariante" + nVariante + "=@nomevariante" +
                " WHERE art_id=@idart";

                SqlCommand cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@nomeVariante", nomeVariante));
                cmd.Parameters.Add(new SqlParameter("@idart", idArt));
                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();
            }






            // admin
            public static DataSet getArticoli(string tipo, string termine, int rep, int ordinamento, string mode, int inOfferta, int inVetrina, int inEvidenza, int invisibile, int disp)
            {


                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                string strSql;
                strSql = "SELECT art_id, art_cod, art_nome, art_stock, art_timestamp, art_imgpreview" +
                    " FROM tarticoli" +
                    " WHERE 1=1";

                switch (tipo)
                {

                    case "nome":
                        strSql += " AND art_nome LIKE @termine";
                        break;

                    default:
                        strSql += " AND (art_cod LIKE @termine OR art_cod IS NULL)";
                        break;

                
                }

                if (rep != -1) strSql += " AND art_idcat=" + rep;

                if (mode == "scorte") strSql += " AND art_stock<@scorta";

                if (inOfferta == 1) strSql += " AND art_inofferta=1";

                if (inVetrina == 1) strSql += " AND art_invetrina=1";

                if (inEvidenza == 1) strSql += " AND art_inevidenza=1";

                if (invisibile == 1) strSql += " AND art_visibile=0";

                if (disp != -1) strSql += " AND art_disponibilita=" + disp;

                switch (ordinamento)
                {
                    case 1:
                        strSql += " ORDER BY art_nome";
                        break;
                    default:
                        strSql += " ORDER BY art_id";
                        break;
                }


                DataSet ds = new DataSet();

                SqlDataAdapter da = new SqlDataAdapter();
                SqlCommand cmd = new SqlCommand(strSql, cnn);

                SqlParameter myParameter = new SqlParameter();
                myParameter.ParameterName = "@termine";
                myParameter.Value = "%" + termine + "%";
                cmd.Parameters.Add(myParameter);


                if (mode == "scorte")
                {
                    SqlParameter myParameter2 = new SqlParameter();
                    myParameter2.ParameterName = "@scorta";
                    myParameter2.Value = (int)HttpContext.Current.Application["config_scorte"];
                    cmd.Parameters.Add(myParameter2);
                }

                da.SelectCommand = cmd;

                cnn.Open();
                da.Fill(ds, "articoli");
                cnn.Close();


                ds.Tables[0].PrimaryKey = new DataColumn[] { ds.Tables[0].Columns["art_id"] };

                return ds;

            }






            public static DataSet getAllArticoli()
            {


                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                string strSql;
                strSql = "SELECT art_id, art_cod, art_nome, art_stock, art_timestamp" +
                    " FROM tarticoli ORDER BY art_id";


                DataSet ds = new DataSet();

                SqlDataAdapter da = new SqlDataAdapter();
                SqlCommand cmd = new SqlCommand(strSql, cnn);
                da.SelectCommand = cmd;

                cnn.Open();
                da.Fill(ds, "articoli");
                cnn.Close();

                return ds;

            }





            // admin
            public static SqlDataReader getCatSottocatArt(int idArt)
            {

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                string strSql = "SELECT idcat FROM tart_cat WHERE idart=@idart";

                SqlCommand cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idArt", idArt));

                cnn.Open();

                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }

            // admin
            public static SqlDataReader getArtDettaglio(int idArt)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "SELECT * FROM tarticoli WHERE art_id=@idart";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idArt", idArt));

                cnn.Open();
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);

            }

            // admin
            public static SqlDataReader getListino(int idArt, int idListino)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "SELECT * FROM tlistino" +
                " WHERE list_idart=@idart AND list_n=@n";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idArt", idArt));
                cmd.Parameters.Add(new SqlParameter("@n", idListino));

                cnn.Open();
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);

            }

            // admin
            public static void deleteArticolo(int idArt)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();


                strSql = "delete  FROM tarticoli WHERE art_id=@1";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@1", idArt));
                cmd.ExecuteNonQuery();

                cnn.Close();


            }


            // admin 
           public static bool seEsisteCodArt(string codice)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();

                strSql = "SELECT COUNT(*) FROM tarticoli where art_cod=@1";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@1", codice));

                int quanti = Convert.ToInt32(cmd.ExecuteScalar());

                cnn.Close();

                return quanti > 0;

            }

            // admin
            public static void aggiungiArt(out int idArtNew)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();

                strSql = "INSERT INTO tarticoli (art_idcat, art_idtaxprofile, art_description, art_keywords, art_peso, art_volume)" +
                    " values " +
                    " ( (SELECT MIN(cat_id) from tcategorie where cat_nascondi=0 and cat_livello=0) , (SELECT MIN(id) from taxprofiles), '', '', 0, 0)";
                cmd = new SqlCommand(strSql, cnn);
                cmd.ExecuteNonQuery();

                strSql = "SELECT MAX(art_id) FROM tarticoli";
                cmd = new SqlCommand(strSql, cnn);
                idArtNew = (int)cmd.ExecuteScalar();


                // produce un codice articolo automatico diverso da tutti gli altri
                strSql = "SELECT COUNT(*) FROM tarticoli where art_cod=@cod";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("cod", idArtNew.ToString()));
                int quantiCodiciUgualiPresenti = Convert.ToInt32(cmd.ExecuteScalar());

                string codiceAutomatico = idArtNew.ToString();
                if (quantiCodiciUgualiPresenti > 0) codiceAutomatico += ("_" + (quantiCodiciUgualiPresenti + 1).ToString());

                strSql = "update tarticoli set art_cod=@cod, art_nome=@nome where art_id=@idart";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("cod", codiceAutomatico));
                cmd.Parameters.Add(new SqlParameter("idart", idArtNew.ToString()));
                string artname="";
                ArrayList arrfrontendlanguages = simplestecommerce.lingua.arrfrontendlanguages;
                for (int rip=0; rip<arrfrontendlanguages.Count;rip++){
                    if (artname.Length>0) artname+="@@";
                    artname+= arrfrontendlanguages[rip].ToString() + "." + codiceAutomatico.ToString();
                }
                cmd.Parameters.Add(new SqlParameter("nome", artname ));
                cmd.ExecuteNonQuery();
                // *******************************************************************


                for (int rip = 0; rip <= 9; rip++)
                {

                    strSql = "INSERT INTO tlistino (list_idart,list_n)  VALUES (@idart,@n)";
                    cmd = new SqlCommand(strSql, cnn);
                    cmd.Parameters.Add(new SqlParameter("@idart", idArtNew));
                    cmd.Parameters.Add(new SqlParameter("@n", rip));
                    cmd.ExecuteScalar();


                }



                cnn.Close();

            }

            



























            public static DataTable getLastOrders(int gg)
            {

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                string strSql;
                strSql = "SELECT * FROM tcart";




                DateTime start = DateTime.Now.AddDays(-1 * gg);

                strSql += " WHERE data>='" + start.ToString("yyyyMMdd") + "'";


                //HttpContext.Current.Response.Write(strSql.ToString());

                strSql += " ORDER BY data DESC";

                DataSet ds = new DataSet();

                SqlDataAdapter da = new SqlDataAdapter();
                SqlCommand cmd = new SqlCommand(strSql, cnn);


                da.SelectCommand = cmd;

                cnn.Open();
                da.Fill(ds, "ordini");
                cnn.Close();

                return ds.Tables[0];
            }














            public static void updateConfigLastOrder(int gg)
            {

                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                strSql = "UPDATE tconfig" +
                " SET config_lastordergg=@gg";

                cmd = new SqlCommand(strSql, cnn);

                cmd.Parameters.Add(new SqlParameter("@gg", gg));
                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();
                simplestecommerce.config.storeConfig();

            }






            //admin
            public static double spZona(int id)
            {

                string strSql;
                SqlCommand cmd;

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                cnn.Open();

                strSql = "SELECT z_importo FROM tzone" +
                " WHERE z_id=@id";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@id", id));
                double result = (double)cmd.ExecuteScalar();
                cnn.Close();
                return result;

            }


            //admin
            public static void updateSpZona(int id, double importo)
            {

                string strSql;
                SqlCommand cmd;

                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

                cnn.Open();

                strSql = "UPDATE tzone" +
                " SET z_importo=@importo" +
                " WHERE z_id=@id";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@importo", importo));
                cmd.Parameters.Add(new SqlParameter("@id", id));
                cmd.ExecuteNonQuery();

                cnn.Close();
            }








        }
















        public class Category
        {
            public int Id;
            public string Name;
            public int Level;
            public int ParentId;
            public int ProductsCount;
            public string img;
            public bool visibile;
            public int idAntenato;
        }










        public class categorie : System.Web.UI.Page
        {
            
            
            // non ricorsiva
            public static void changeVis(int idCat, bool vis)
            {





                SqlConnection cnn;
                SqlCommand cmd;
                string strSql;

                cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                cnn.Open();


                ArrayList ar = simplestecommerce.admin.categorie.getRamo(idCat, null);

                foreach (simplestecommerce.admin.Category c in ar)
                {




                    strSql = "update tcategorie set cat_nascondi=@nascondi" +
                    " WHERE cat_id=@idcat";
                    cmd = new SqlCommand(strSql, cnn);
                    cmd.Parameters.Add(new SqlParameter("@idCat", c.Id));
                    cmd.Parameters.Add(new SqlParameter("@nascondi", (vis ? 0 : 1)));
                    cmd.ExecuteNonQuery();

                }

                strSql = "update  tcategorie set cat_nascondi=@nascondi" +
                " WHERE cat_id=@idcat";
                cmd = new SqlCommand(strSql, cnn);
                cmd.Parameters.Add(new SqlParameter("@idCat", idCat));
                cmd.Parameters.Add(new SqlParameter("@nascondi", (vis ? 0 : 1)));
                cmd.ExecuteNonQuery();


                cnn.Close();

            }






          





 

           


         





            


          





            // ricorsiva
            public static ArrayList getRamo(int parentId, ArrayList arrCat)
            {
                
                                
                if ( arrCat==null) arrCat = new ArrayList();


                string sql = "select * from tcategorie where cat_idpadre=@idpadre";
                DataTable dt = simplestecommerce.helpDb.getDataTable(sql, new SqlParameter("idpadre", parentId));
                
                              

                foreach ( DataRow riga in dt.Rows) 
                {
                    Category cat = new Category();
                    cat.Id = Convert.ToInt32(riga["CAT_ID"].ToString());
                    cat.ParentId = parentId;
                    cat.Name = riga["CAT_NOME"].ToString();
                    cat.img = riga["cat_img"].ToString();
                    cat.Level = (parentId == 0 ? 0 : 1);
                    cat.visibile = !(bool)(riga["cat_nascondi"]);
                    arrCat.Add(cat);

                    getRamo(cat.Id, arrCat);
                }




                return arrCat;
            }






           




            






            



    public static ArrayList getPathCat(int catId, ArrayList currentPath)
    {


        ArrayList arrPath;
        if (currentPath == null)
        {
            arrPath = new ArrayList();
        }
        else
            arrPath = currentPath;



        string sql = "select * from tcategorie where cat_id=@idpadre";
        DataTable dt = simplestecommerce.helpDb.getDataTable(sql, new SqlParameter("idpadre", catId));
        DataRow dr = dt.Rows[0];


        Category cat = new Category();
        cat.Id = catId;
        cat.Name = dr["cat_nome"].ToString();
        cat.ParentId = Convert.ToInt32(dr["cat_idpadre"]);
        arrPath.Add(cat);
        if (cat.ParentId > 0)
        {
            getPathCat(cat.ParentId, arrPath);
        }
        


        ArrayList tmpPath = new ArrayList();
        Category root = new Category();
        root.Id = 0;
        tmpPath.Add(root);		// add root path
        for (int i = 0; i < arrPath.Count; i++)
        {
            tmpPath.Add(arrPath[arrPath.Count - 1 - i]);
        }

        arrPath = tmpPath;
        return arrPath;
    }
















            public static ArrayList GetCategoriesTree(Category cat, ArrayList arrCat, int excludedId)
            {


                if (arrCat==null) {
                    
                    arrCat = new ArrayList();
                }


                if (cat == null)
                {

                    cat = new Category();
                    cat.Id = 0;

                }


                string sql = "select * from tcategorie where cat_idpadre=@idcat and cat_id<>@excludedid order by cat_nome";
                DataTable dt = simplestecommerce.helpDb.getDataTable(
                    sql,
                    new SqlParameter("idcat", cat.Id),
                    new SqlParameter("excludedid", excludedId)
                    );
                
                
                foreach (DataRow riga in dt.Rows)
                {

                    Category c = new Category();

                    

                    c.Id = (int)riga["cat_id"]; ;







                    c.Name += cat.Name;

                    if (c.Name.Length > 0) c.Name += "-->";
                    
                    c.Name+=simplestecommerce.lingua.getinadminlanguagefromdb(riga["cat_nome"].ToString());

                    arrCat.Add(c);


                    
                    GetCategoriesTree(c, arrCat, excludedId);
                }
             




                return arrCat;
            }














        }

    }
}