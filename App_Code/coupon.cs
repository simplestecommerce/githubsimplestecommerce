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
using System.Data.SqlClient;

namespace simplestecommerce
{
    public class coupon
    {
        public static DataRow rowenabledcouponbycouponcode (string couponcode)
        {
                string sql = "SELECT * FROM coupon where code=@code and enabled=1";
                SqlParameter p1 = new SqlParameter("@code", couponcode);
                DataTable dt = simplestecommerce.helpDb.getDataTable(sql, p1);

                if ( dt.Rows.Count==0) return null;
                else return dt.Rows[0];
        }
    }
}