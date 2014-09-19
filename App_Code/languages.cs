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
using System.Data;
namespace simplestecommerce
{

    public class lingua
    {
        public static ArrayList arrfrontendlanguages
        {
            get
            {
                System.Collections.ArrayList result = new System.Collections.ArrayList();
                DataTable dtlanguages = (DataTable)HttpContext.Current.Application["dtlanguages"];
                for (int rip = 0; rip < dtlanguages.Columns.Count - 1; rip++)
                {
                    if (dtlanguages.Columns[rip].ColumnName != "pseudo") result.Add(dtlanguages.Columns[rip].ColumnName);


                }
                return result;
            }
        }
        public static string getfromdbbylanguage(string languagename, string stringa)
        {

            string[] words;

            string[] delimiter = { "@@" };


            words = stringa.Split(delimiter, System.StringSplitOptions.None);

            for (int rip = 0; rip < words.Length; rip++)
            {
                string word = words[rip];
                int pointposition = word.IndexOf(".");
                if (pointposition < 0) return "";
                if (word.Substring(0, pointposition) == languagename) return word.Substring(pointposition + 1);

            }
            return "";
        }

        public static string getinadminlanguagefromdb(string stringa)
        {
            if (stringa == "" || stringa == null) return "";
            string[] words;

            string[] delimiter = { "@@" };


            words = stringa.Split(delimiter, System.StringSplitOptions.None);

            for (int rip = 0; rip < words.Length; rip++)
            {
                string word = words[rip];
                int pointposition = word.IndexOf(".");
                if (pointposition < 0) return "";
                if (word.Substring(0, pointposition) == (string)simplestecommerce.config.getCampoByApplication("config_adminlanguagename")) return word.Substring(pointposition + 1);

            }
            return "";
        }
        public static string getinadminlanguagebypseudo(string stringa)
        {
            string result = "";
            DataTable dtlanguages = (DataTable)HttpContext.Current.Application["dtlanguages"];
            DataRow row = dtlanguages.Rows.Find(stringa);
            if (row != null)
            {
                for (int rip = 0; rip < dtlanguages.Columns.Count - 1; rip++)
                {
                    string currentlanguagename = (string)simplestecommerce.config.getCampoByApplication("config_adminlanguagename");
                    if (dtlanguages.Columns[rip].ColumnName == currentlanguagename)
                    {
                        result = row[rip].ToString();
                        rip = dtlanguages.Columns.Count;
                    }

                }
                return result;
            }
            else throw new Exception("pseudo " + stringa + " not in xml languagepack file");
        }

        public static string getforfrontendbypseudo(string stringa)
        {
            string result = "";
            DataTable dtlanguages = (DataTable)HttpContext.Current.Application["dtlanguages"];
            DataRow row = dtlanguages.Rows.Find(stringa);
            if (row != null)
            {
                for (int rip = 0; rip < dtlanguages.Columns.Count - 1; rip++)
                {
                    string currentlanguagename = HttpContext.Current.Session["currentfrontendlanguagename"].ToString();
                    if (dtlanguages.Columns[rip].ColumnName == currentlanguagename)
                    {
                        result = row[rip].ToString();
                        rip = dtlanguages.Columns.Count;
                    }

                }
                return result;
            }
            else throw new Exception("pseudo " + stringa + " not in xml languagepack file");


        }
        public static string getbylanguageandpseudo(string language, string stringa)
        {
            string result = "";
            DataTable dtlanguages = (DataTable)HttpContext.Current.Application["dtlanguages"];
            DataRow row = dtlanguages.Rows.Find(stringa);
            if (row != null)
            {
                for (int rip = 0; rip < dtlanguages.Columns.Count - 1; rip++)
                {
                    
                    if (dtlanguages.Columns[rip].ColumnName == language)
                    {
                        result = row[rip].ToString();
                        rip = dtlanguages.Columns.Count;
                    }

                }
                return result;
            }
            else throw new Exception("pseudo " + stringa + " not in xml languagepack file");


        }

        public static string getforfrontendfromdb(string stringa)
        {
            if (stringa == "" || stringa == null) return "";
            string[] words;

            string[] delimiter = { "@@" };


            words = stringa.Split(delimiter, System.StringSplitOptions.None);

            for (int rip = 0; rip < words.Length; rip++)
            {
                string word = words[rip];
                int pointposition = word.IndexOf(".");
                if (pointposition < 0) return "";
                if (word.Substring(0, pointposition) == (string)HttpContext.Current.Session["currentfrontendlanguagename"]) return word.Substring(pointposition + 1);

            }
            return "";


        }




    }






    

}