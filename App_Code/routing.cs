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

namespace simplestecommerce
{
    /// <summary>
    /// Descrizione di riepilogo per Class1
    /// </summary>
    public class routing
    {
        public static string getonlyallowedchars(string stringa)
        {
            stringa = stringa.Replace(" ", "-");

            string ammessi = "-01234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

            for (int rip = 0; rip < stringa.Length; rip++)
            {

                if (!ammessi.Contains(stringa.Substring(rip, 1)))
                {
                    string nonAmmesso = stringa.Substring(rip, 1);

                    stringa = stringa.Replace(nonAmmesso, "");

                }


            }

            return stringa;

        }
    }

}