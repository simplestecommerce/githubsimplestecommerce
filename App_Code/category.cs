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


namespace simplestecommerce {

public class Category
    {
        public int Id;
        public string Name;
        //		public int Level;
        public int ParentId;
        public int ProductsCount;
        public string listInacc;


        public static string linkforrouting ( int idcat)
        {

            string _link = ""; 
            ArrayList arrPathCat = simplestecommerce.Category.getPathCat(idcat, null);
            foreach (simplestecommerce.Category cat in arrPathCat)
            {
                
                if (cat.Id > 0)
                {
                    {
                        if (_link.Length > 0) _link += "--";
                        _link += simplestecommerce.routing.getonlyallowedchars(simplestecommerce.lingua.getinadminlanguagefromdb(cat.Name));
                        
                    }
                   
                }
            }

            _link = HttpContext.Current.Server.UrlEncode(_link);

            string result = "~/catalog/" + _link + "/" + idcat;

            return System.Web.VirtualPathUtility.ToAbsolute(result);

        }


    // non ricorsiva
    public static int getAntenato(int idCat)
    {

        SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

        string strSql;
        strSql = "SELECT cat_idantenato FROM tcategorie WHERE cat_id=@idCat";

        SqlCommand cmd = new SqlCommand(strSql, cnn);
        cmd.Parameters.Add(new SqlParameter("@idcat", idCat));

        cnn.Open();
        int result = Convert.ToInt32(cmd.ExecuteScalar());
        cnn.Close();
        return result;
    }

    public static ArrayList getPathCat(int catId, ArrayList currentPath)
    {





        ArrayList arrPath;
        if (currentPath == null)
        {
            arrPath = new ArrayList();
        }
        else
            arrPath = currentPath;





        DataView dv = (DataView)HttpContext.Current.Application["dvvisiblecategoriesorderbyid"];

        if (dv == null)
        {


        }

        int indicefound = dv.Find(catId);
        DataRowView rigafound = dv[indicefound];

        Category cat = new Category();
        cat.Id = catId;
        cat.Name = rigafound["cat_nome"].ToString();
        cat.ParentId = Convert.ToInt32(rigafound["cat_idpadre"]);
        arrPath.Add(cat);
        if (cat.ParentId > 0)
        {
            getPathCat(cat.ParentId, arrPath);
        }
        


        ArrayList tmpPath = new ArrayList();
        Category root = new Category();
        root.Id = 0;
        tmpPath.Add(root);		// add root path
        for (int i = 0; i < arrPath.Count; i++)
        {
            tmpPath.Add(arrPath[arrPath.Count - 1 - i]);
        }

        arrPath = tmpPath;
        return arrPath;
    }













    // not used
    public static ArrayList getChildCats(int catId, ArrayList arrCurrentChilds)
    {

        DataView dv = (DataView)HttpContext.Current.Application["dvvisiblecategoriesorderbyparent"];

        ArrayList arrChilds;
        if (arrCurrentChilds == null)
        {
            arrChilds = new ArrayList();
        }
        else
            arrChilds = arrCurrentChilds;



        DataRowView [] foundrows = dv.FindRows(catId);




        ArrayList arrTmpChilds = new ArrayList();
        foreach (DataRowView row in foundrows)
        {
            Category cat = new Category();
            cat.Id = Convert.ToInt32(row["CAT_ID"].ToString());
            cat.Name = row["CAT_NOME"].ToString();
            cat.ParentId = catId;
            arrTmpChilds.Add(cat);
        }



        foreach (Category cat in arrTmpChilds)
        {
            arrChilds.Add(cat);
            getChildCats(cat.Id, arrChilds);
        }

        return arrChilds;
    }








}

}