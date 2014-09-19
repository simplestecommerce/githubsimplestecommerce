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
using System.Linq;
using System.Web;
using System.Data;
using System.Globalization;
using System.Threading;
namespace simplestecommerce
{
    public class currencies
    {





        public static DataTable getAvailable()
        {

            string sql;
            sql = "SELECT * FROM tcurrencies where cambio>0 order by nome";

            DataTable dt = helpDb.getDataTable(sql);
            dt.PrimaryKey = new DataColumn[] { dt.Columns["id"] };


            return dt;



        }

        public static double tousercurrency(double numero)
        {
            DataTable dtcurrencies = (DataTable)HttpContext.Current.Application["dtcurrenciesavailable"];
            DataRow rowcurrentcurrency = dtcurrencies.Rows.Find((int)HttpContext.Current.Session["idcurrency"]);
            return (numero * (double)rowcurrentcurrency["cambio"]);
        }

        public static string tostrusercurrency(double numero)
        {

            if (HttpContext.Current.Request.Path.IndexOf("admin_") < 0 &&
                (int)HttpContext.Current.Application["config_registrazione"] == 2 &&
                ((Cart)HttpContext.Current.Session["Cart"]).User.Anonimo)
            {
                return "";
            }
            else return (tousercurrency(numero).ToString("C"));
        }





    }

}
    
    
    
    