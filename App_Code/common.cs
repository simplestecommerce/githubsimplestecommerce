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
using System.Web;
using System;
namespace simplestecommerce
{


    public class common
    {

        public static string[] arrPseudoLegalSubject = new string[] { "common.legal.subject.private", "common.legal.subject.firm" };

        public static string[] arrtaxnameinpseudo = new string[] { "common.tax.name.generic.tax", "common.tax.name.vat" };



        public static string[] arrPseudoDisponibilita = new string[] { 
            "common.article.availability.yes",
            "common.article.availability.no",
            "common.article.availability.not.available.can.be.ordered"
        };


        public static ArrayList dbtables()
        {
            ArrayList result = new ArrayList();
            result.Add("tconfig");

            result.Add("tregioni");
            result.Add("tcurrencies");
            result.Add("tlistini");

            result.Add("tcategorie");
            result.Add("taxprofiles");
            result.Add("taxrates");
            result.Add("tarticoli");
            result.Add("tlistino");
            result.Add("tvarianti");
            result.Add("topzioni");

            result.Add("tzoom");

            result.Add("orderstatus");

            result.Add("tpesi");

            result.Add("tcorrelati");
            result.Add("tcorrieri");
            result.Add("tipipagamento");
            result.Add("coupon");

            result.Add("tscontiquantita");
            result.Add("tsovrapprezzi");
            result.Add("tutenti");
            result.Add("tvolumi");
            result.Add("tzone");
            result.Add("tmailing");
            result.Add("tmessaggi");
            result.Add("tnews");
            result.Add("tpagine");
            result.Add("tbanner");

            result.Add("tcart");
            result.Add("tcartitem");
            result.Add("tcartvariation");



            return result;


        }



        //articolo
        public static int maxLenCod = 255;
        public static int maxLenNome = 255;
        public static int maxLenMarca = 255;
        public static int maxLenImg0 = 255;
        public static int maxLenImg1 = 255;
        public static int maxLenNomeVar = 255;
        public static int maxLenPredescr = 255;

        //categorie
        public static int maxLenNomeCat = 50;
        public static int maxLenImgCat = 50;


        //registrazione utente
        public static int maxLenNominativo = 50;
        public static int maxLenIndirizzo = 50;
        public static int maxLenCap = 30;
        public static int maxLenLocalita = 50;
        public static int maxLenStato = 30;
        public static int maxLenEmail = 50;
        public static int maxLenTelefono = 30;
        public static int maxLenCodFisc = 50;

        public static int maxLenPass = 15;
        public static int maxLenPIva = 30;

        //configurazione
        public static int maxLenPwAdmin = 15;
        public static int maxLenNomeSito = 50;
        public static int maxLenEmailSito = 50;
        public static int maxLenUrlSito = 50;

        //zone
        public static int maxLenRegione = 80;


public static string linkescaped(string testo, string url)
        {
            return "<a href=\"" + url + "\">" + HttpContext.Current.Server.HtmlEncode(testo) + "</a>";
        }

        public static string linkescaped(string testo, string url, string classe)
        {
            return "<a href=\"" + url + "\" class=" + classe + ">" + HttpContext.Current.Server.HtmlEncode(testo) + "</a>";
        }




        public static void split(string stringa, ref string par0, ref string par1)
        {

            par0 = "";
            par1 = "";

            string[] words;

            char[] delimiter = "@@".ToCharArray();

            words = stringa.Split(delimiter, 2);

            par0 = words[0];

            if (words.Length > 1) par1 = words[2];



        }

        public static void alert(string msg, System.Web.UI.Page page)
        {
           System.Web.UI.ScriptManager.RegisterStartupScript(page, page.GetType(), "text", "alert('" + msg.Replace("'","") + "')", true); 

        }
    }



    

}