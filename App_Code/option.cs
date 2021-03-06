﻿/*
 
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


    public class Option
    {
        public int Id { get; set; }
        public string Testo {get;  set;}
        public double Prezzobase { get; set; }
        public double Prezzodoposcontoprodottoutentelistino { get; set; }
        public string Img;

        public Option(int _id, string _testo, double _prezzobase,  double _prezzodoposcontoprodottoutentelistino, string _img)
        {
            this.Id = _id;
            this.Testo = _testo;
            this.Prezzobase = _prezzobase;
            this.Prezzodoposcontoprodottoutentelistino = _prezzodoposcontoprodottoutentelistino;
            this.Img = _img;
        }
        public Option(string _testo, double _prezzobase, double _prezzodoposcontoprodottoutentelistino)
        {
            this.Testo = _testo;
            this.Prezzobase = _prezzobase;
            this.Prezzodoposcontoprodottoutentelistino = _prezzodoposcontoprodottoutentelistino;
        }

        public Option(string _testo, double _prezzodoposcontoprodottoutentelistino)
        {
            this.Testo = _testo;
            this.Prezzodoposcontoprodottoutentelistino = _prezzodoposcontoprodottoutentelistino;
        }

    }




}