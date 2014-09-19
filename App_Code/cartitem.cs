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





    public class cartItem
    {

        
        public simplestecommerce.articolo Articolo {get;private set;}
        public List<Choosedvariation> Choosedvariations { get;  set; }
        public int Quantita { get; set; }


        public cartItem(simplestecommerce.articolo _articolo, int _quantita, List<simplestecommerce.Choosedvariation> _choosedvariations)
        {
            this.Articolo = _articolo;
            this.Quantita = _quantita;
            this.Choosedvariations = _choosedvariations;


        }

        // ok

        public double Variationssum
        {
            get
            {
                double result = 0;
                foreach (Choosedvariation v in this.Choosedvariations)
                {

                    result += v.Choosedoption.Prezzobase;
                }
                return result;

            }

        }

        public double Variationsumdoposcontoprodottoutentelistino {

            get
            {
                return this.Variationssum * (1 - this.Articolo.Scontoprodottoutentelistino/100);

            }

        }
        public double Quantitydiscount
        {

            get
            {
                double basisofquantitydiscount = this.Articolo.Prezzodoposcontoprodottoutentelistino + this.Variationsumdoposcontoprodottoutentelistino;
                    
                DataTable dtquantitydiscount = simplestecommerce.scontiQuantita.getSconti(this.Articolo.Idart);
                
                
                return simplestecommerce.articoli.getquantitydiscount(basisofquantitydiscount, this.Quantita, dtquantitydiscount);
                
            }
        }



        public double Finalprice

        {
            get
            {

                double result = (this.Articolo.Prezzodoposcontoprodottoutentelistino + this.Variationsumdoposcontoprodottoutentelistino)
                   * (1 - this.Quantitydiscount/100);

                return result;
            }
        }

        public double Totaldiscount
        {
            get
            {
                double before = this.Articolo.Prezzobase + this.Variationssum;
                double after = this.Finalprice;
                return (before-after) / before * 100;
                
            }

        }






    }
}