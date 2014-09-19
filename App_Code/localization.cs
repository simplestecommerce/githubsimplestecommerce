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
    public class localization
    {
        public static NumberFormatInfo usernumberformatinfo
        {
            get
            {
                DataRow rowcurrentcurrency = ((DataTable)HttpContext.Current.Application["dtcurrenciesavailable"]).Rows.Find((int)HttpContext.Current.Session["idcurrency"]);
                CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
                Thread.CurrentThread.CurrentCulture = modified;
                NumberFormatInfo worknumberformatinfo = modified.NumberFormat;
                worknumberformatinfo.CurrencySymbol = rowcurrentcurrency["nome"].ToString() + " ";
                worknumberformatinfo.CurrencyDecimalDigits = (int)rowcurrentcurrency["decimali"];
                worknumberformatinfo.CurrencyDecimalSeparator = (string)rowcurrentcurrency["decimalseparatorsymbol"];
                worknumberformatinfo.CurrencyGroupSeparator = (string)rowcurrentcurrency["groupseparatorsymbol"];

                worknumberformatinfo.NumberDecimalSeparator = worknumberformatinfo.CurrencyDecimalSeparator;
                worknumberformatinfo.NumberGroupSeparator = worknumberformatinfo.CurrencyGroupSeparator;


                return worknumberformatinfo;
            }
        }
    }
}