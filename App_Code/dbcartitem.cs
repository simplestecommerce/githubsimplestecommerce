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

    public class Dbcartitem
    {

        public string Artnameinuserlanguage { get; private set; }
        public string Artcode { get; private set; }
        public double Finalprice { get; private set; }
        public int Quantity {get; private set;}
        public double Totaldiscount { get; private set; }
        public string Preview {get; private set;}
        public List<simplestecommerce.Dbcartvariation> Dbcartvariations;

        public Dbcartitem (string _artnameinuserlanguage, string _artcode, double _finalprice, int _quantity, double _totaldiscount, string _preview, List<simplestecommerce.Dbcartvariation> _dbcartvariations)
        {
            this.Artcode = _artcode;
            this.Artnameinuserlanguage = _artnameinuserlanguage;
            this.Finalprice = _finalprice;
            this.Quantity = _quantity;
            this.Totaldiscount = _totaldiscount;
            this.Preview = _preview;
            this.Dbcartvariations = _dbcartvariations;

        }
    }
}