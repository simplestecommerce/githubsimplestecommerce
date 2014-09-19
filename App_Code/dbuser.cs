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



/// <summary>
/// Descrizione di riepilogo per utenti
/// </summary>
/// 
namespace simplestecommerce
{

    public class Dbuser
    {





        public string Id { get;  set; } // for registered user

        public string Firstname { get;  set; }
        public string Secondname { get;  set; }
        public string Nameoffirm { get;  set; }
        public string Email { get;  set; }
        public string Telephone { get;  set; }
        public string Fiscalcode { get;  set; }
        public string Vatnumber { get;  set; }
        public int Subject { get;  set; }
        public bool Newsletter { get;  set; }
        public int Idregion { get;  set; }
        public string Address { get;  set; }
        public string City { get;  set; }
        public string Postalcode { get;  set; } 


        // shipping data
        public string Spfirstname { get;  set; }
        public string Spsecondname { get;  set; }
        public int Spidregion { get;  set; }
        public string Spaddress { get;  set; }
        public string Spcity { get;  set; }
        public string Sppostalcode { get;  set; }

        public string Couponcode { get;  set; }




        public bool Anonimo
        {
            get
            {

                return (this.Id == null || this.Id.Length == 0);
            }
        }


    }
}