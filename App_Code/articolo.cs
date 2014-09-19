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




        public class articolo  {



        public int Listino { get; private set; }
        public double Scontolistino { get; private set; }
        public double Scontoutente { get; private set; }



        public int Idart {get; private set;}
        public int Idcat {get; private set;}
        public string Code {get; private set;}
        public string Name {get; private set;}
        public string Marca {get; private set;}
        public double Stock {get; private set;}
        public int Disponibilita {get; private set;}
        public string Predescrizione { get; private set; }
        public string Descrizione {get; private set;}
        public string Preview {get; private set;}
        public string Description {get; private set;}
        public string Keywords {get; private set;}
        public double Peso {get; private set;}
        public int Volume {get; private set;}
        public int Consegna {get; private set;}
        public string Caratteristiche {get; private set;}
        public double Prezzobase {get; private set;}
        public string Dataarrivo {get; private set;}
        public bool Usato {get; private set;}
        public string Linkart {get; private set;}
        
        public List<simplestecommerce.Variation> Variations {
            get
            {

                List<simplestecommerce.Variation> listavar = new List<simplestecommerce.Variation>();


                SqlConnection cnn = new SqlConnection (HttpContext.Current.Application["strcnn"].ToString() );
                cnn.Open();

                string sql;
                SqlCommand cmd;
                SqlDataAdapter da;
                DataSet ds = new DataSet();
                sql = "select * from tvarianti where idart=@idart";
                cmd = new SqlCommand (sql, cnn);
                cmd.Parameters.AddWithValue("idart", this.Idart);
                da = new SqlDataAdapter(cmd);
                da.Fill(ds, "varianti");
                
                foreach ( DataRow drvar in ds.Tables["varianti"].Rows){

                    sql = "select * from topzioni where idvar=@idvar";
                    cmd = new SqlCommand (sql, cnn);
                    cmd.Parameters.AddWithValue("idvar", (int)drvar["id"]);
                    da = new SqlDataAdapter(cmd);
                    DataTable dtopz = new DataTable();
                    da.Fill(dtopz);

                    List<simplestecommerce.Option> opzioni = new List<Option>();
                    

                    foreach ( DataRow dropz in dtopz.Rows){
                        opzioni.Add ( 
                            new simplestecommerce.Option (
                                (int)dropz["id"],
                                (string)dropz["testo"],  
                                (double)dropz["prezzo"],
                                (double)dropz["prezzo"] * (1 -this.Scontoprodottoutentelistino/100),
                                (string)dropz["img"]
                            )
                        );
                    }
                    listavar.Add(new simplestecommerce.Variation((int)drvar["id"], (string)drvar["nome"], opzioni));

                }
                
                
                cnn.Close();
                return listavar;

            }
        }



        public double Scontopercento {get; private set;}

        public double Scontoprodottoutentelistino {get; private set;}

        public double Prezzodoposcontoprodottoutentelistino {get; private set;}

        public articolo(int _idart, int _listino, double _scontolistino, double _scontoutente )
        {
            

            this.Idart = _idart;
            this.Listino = _listino;
            this.Scontolistino = _scontolistino;
            this.Scontoutente = _scontoutente;

            using (SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]))
            {

                SqlCommand cmd = new SqlCommand("getDatiArticolo", cnn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@idart", this.Idart));
                cmd.Parameters.Add(new SqlParameter("@listino", this.Listino ));

                cnn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                if (!dr.Read())
                {
                    dr.Close();
                    cnn.Close();
                    simplestecommerce.problema.redirect ("articolo non trovato!");


                }
                
                this.Idcat = (int)dr["art_idcat"];
                this.Code = dr["art_cod"].ToString();
                this.Name = dr["art_nome"].ToString();
                this.Predescrizione = simplestecommerce.lingua.getforfrontendfromdb(dr["art_predescrizione"].ToString());
                this.Marca = dr["art_marca"].ToString();
                this.Stock = (double)dr["art_stock"];
                this.Disponibilita = (int)dr["art_disponibilita"];
                this.Descrizione = simplestecommerce.lingua.getforfrontendfromdb(dr["art_descrizione"].ToString());
                this.Preview = dr["art_imgpreview"].ToString();
                this.Description = dr["art_description"].ToString();
                this.Keywords = dr["art_keywords"].ToString();
                this.Peso = (double)dr["art_peso"];
                this.Volume = (int)dr["art_volume"];
                this.Consegna = (int)dr["art_consegna"];
                this.Caratteristiche = simplestecommerce.lingua.getforfrontendfromdb(dr["art_caratteristiche"].ToString());
                this.Dataarrivo = dr["art_dataarrivo"].ToString();
                this.Usato = (bool)dr["art_usato"];

                
              this.Prezzobase = (double)dr["list_prezzobase"] ;
              if (this.Prezzobase < 0) this.Prezzobase = 0;
                                     
              this.Scontopercento = (double)dr["list_scontopercento"]; 

              this.Scontoprodottoutentelistino = this.Scontopercento + this.Scontolistino + this.Scontoutente;

              // this is the price showed in catalog
              this.Prezzodoposcontoprodottoutentelistino = this.Prezzobase * (1 - this.Scontoprodottoutentelistino/100);


              // link for url routing
              string _link = "";
              ArrayList arrPathCat = simplestecommerce.Category.getPathCat(this.Idcat, null);
              foreach (simplestecommerce.Category cat in arrPathCat)
              {

                  if (cat.Id > 0)
                  {
                      {
                          if (_link.Length > 0) _link += "--";
                          _link += simplestecommerce.routing.getonlyallowedchars(simplestecommerce.lingua.getinadminlanguagefromdb(cat.Name));

                      }

                  }
              }

              _link = HttpContext.Current.Server.UrlEncode(_link);

                this.Linkart = 
                    "~/catalog/" + 
                    _link + "/" + 
                    (
                    simplestecommerce.routing.getonlyallowedchars(simplestecommerce.lingua.getinadminlanguagefromdb(this.Name))==""?
                    "article"
                    :
                    simplestecommerce.routing.getonlyallowedchars(simplestecommerce.lingua.getinadminlanguagefromdb(this.Name))
                    ) +
                    "/" + this.Idcat + 
                    "/" + this.Idart; ;


              dr.Close();

              cnn.Close();







          }


        }



     




    }


}