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

/// <summary>
/// Descrizione di riepilogo per config
/// </summary>
/// 

namespace simplestecommerce
{



    public class config
    {

        public static object getCampoByDb(string nomeCampo)
        {


            SqlConnection cnn;
            SqlCommand cmd;
            string strSql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            strSql = "SELECT TOP 1 " + nomeCampo + " FROM tconfig order by contatore desc";
            cmd = new SqlCommand(strSql, cnn);
            cnn.Open();
            object result;
            result = cmd.ExecuteScalar();
            cnn.Close();

            return result;


        }

        public static object getCampoByApplication(string nomeCampo)
        {


            return HttpContext.Current.Application[nomeCampo];


        }


        public static void storeConfig()
        {
            SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter();
            string sql = "SELECT * FROM tconfig";
            SqlCommand cmd = new SqlCommand(sql, cnn);
            da.SelectCommand = cmd;
            cnn.Open();
            da.Fill(ds, "config");
            cnn.Close();
            DataTable dt = ds.Tables[0];
            foreach (DataColumn col in dt.Columns)
            {

                HttpContext.Current.Application[col.ColumnName] = dt.Rows[0][col.ColumnName];
            }
            
            
        }

        public static DataTable dataTableConfig()
        {

            string strSql;
            strSql = "SELECT * FROM tconfig";

            return helpDb.getDataTable(strSql);
        }


        public static SqlDataReader getConfig()
        {

            string strSql;
            SqlCommand cmd;
            SqlDataReader dr;
            SqlConnection cnn;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

            strSql = "SELECT * FROM tconfig";
            cmd = new SqlCommand(strSql, cnn);
            cnn.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            return dr;
        }




    }








}