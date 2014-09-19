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


namespace simplestecommerce
{
    public class modeofpayment
    {
        public static DataTable tableTipPagam
        {
            get
            {
                string sql;
                sql = "SELECT * FROM tipipagamento";


                DataTable dt = simplestecommerce.helpDb.getDataTable(sql);

                return dt;
            }
        }

        public static DataRow rigaTipPagamById(int id)
        {

            return (tableTipPagam.Select("id=" + id))[0];
        }
        public static string nomeTipPagamById(int id)
        {
            return rigaTipPagamById(id)["nome"].ToString();

        }

    }
}