<%--  
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
--%>


<%@ Application Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Routing" %>
<script RunAt="server">
 
 
 private static void defineroutes(RouteCollection routes)
 {

  routes.MapPageRoute("prod",
     "catalog/{nomecategoria}/{nomeprodotto}/{idCatSelected}/{idArt}", "~/shop/articoli.aspx");
  routes.MapPageRoute("cat",
     "catalog/{nomecategoria}/{idCatSelected}", "~/shop/preview.aspx");

 }



 public void Application_Start(Object sender, EventArgs e)
 {

  defineroutes(RouteTable.Routes);



  // start configuration **************************************************************************************************

  Application["strcnn"] = "Data Source=MAURIZIO-TOSH\\SQLEXPRESS; Initial Catalog=simplestecommerce; User Id=sa; Password=Luigia-3333;";
  Application["upload"] = "~/upload";
  Application["serialnumber"] = ""; // serial number for Copyright label removal; contact us from the site http://www.simplestecommerce.com in order to receive the serial number.

  // end configuration ****************************************************************************************************


  string languagepackpath;

  if (File.Exists(Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/languagepack.xml"))))
   languagepackpath = Server.MapPath(VirtualPathUtility.ToAbsolute(Application["upload"].ToString() + "/languagepack.xml"));
  else languagepackpath = Server.MapPath(VirtualPathUtility.ToAbsolute("~/languagepack.xml"));

  DataSet dslanguage = new DataSet();
  dslanguage.ReadXml(languagepackpath, XmlReadMode.InferSchema);
  DataTable dtalllanguages = dslanguage.Tables[0];
  // here dtalllanguages contains all languages from xml file


  string adminlanguagename = (string)simplestecommerce.config.getCampoByDb("config_adminlanguagename");
  string strfrontendlanguages = (string)simplestecommerce.config.getCampoByDb("config_frontendlanguages");
  string[] delimiter = { "@@" };
  string[] frontendlanguages = strfrontendlanguages.Split(delimiter, System.StringSplitOptions.None);

  ArrayList arrcolname = new ArrayList();

  foreach (DataColumn col in dtalllanguages.Columns)
  {
   arrcolname.Add(col.ColumnName);
  }

  foreach (string colname in arrcolname)
  {
   if (colname != adminlanguagename && colname != "pseudo")
   {
    bool usedinfrontend = false;
    for (int rip = 0; rip < frontendlanguages.Length; rip++)
    {

     if (colname.ToLower() == frontendlanguages[rip].ToLower())
     {
      usedinfrontend = true;
      rip = frontendlanguages.Length;
     }
    }
    if (!usedinfrontend) dtalllanguages.Columns.Remove(colname);


   }

  }



  // here dtalllanguages contains languages desidered for front-end plus language desidered for admin
  dtalllanguages.PrimaryKey = new DataColumn[] { dtalllanguages.Columns["pseudo"] };
  Application["dtlanguages"] = dtalllanguages;

  simplestecommerce.caching.cachevisiblecategories("");


  System.Data.DataTable dtcurrencies = simplestecommerce.currencies.getAvailable();
  Application["dtcurrenciesavailable"] = dtcurrencies;

  simplestecommerce.config.storeConfig(); // setta variabili di applicazione



 }

 void Application_PreSendRequestContent(object o, EventArgs e)
 {


 }
 public void Application_PreRequestHandlerExecute(Object sender, EventArgs e)
 {

  simplestecommerce.statistiche.cutVisite();
  simplestecommerce.statistiche.registraVisita();




 }
 void Session_OnStart()
 {

  if (Request.QueryString["forcestartingfrontendlanguage"] != null)
     HttpContext.Current.Session["currentfrontendlanguagename"] = Request.QueryString["forcestartingfrontendlanguage"].ToString();
  else HttpContext.Current.Session["currentfrontendlanguagename"] = simplestecommerce.config.getCampoByApplication("config_startingfrontendlanguagename");

  HttpContext.Current.Session["idcurrency"] = (int)simplestecommerce.config.getCampoByApplication("config_idmastercurrency");

  HttpContext.Current.Session["coda"] = new System.Collections.Generic.List<simplestecommerce.articolo>();

  simplestecommerce.Cart Currentcart = new simplestecommerce.Cart();

  HttpContext.Current.Session["Cart"] = Currentcart;

  HttpContext context = HttpContext.Current;
  HttpCookieCollection cookies = context.Request.Cookies;
  if (cookies["starttime"] == null)
  {
   HttpCookie cookie = new HttpCookie("starttime", DateTime.Now.ToString());
   cookie.Path = "/";
   context.Response.Cookies.Add(cookie);
  }
  else
  {
   if (Request.Path.IndexOf("admin_") > 0 || Request.Path.IndexOf("admin.aspx") > 0) { }
   else context.Response.Redirect("~/shop/timeout.aspx");
  }


 }

 void Application_Error(object sender, EventArgs e)
 {
  if (!Request.IsLocal)
  {



   Exception ex = Server.GetLastError().GetBaseException();
   if (ex != null)
   {
    SqlCommand cmd;
    SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
    cnn.Open();

    cmd = new SqlCommand("logexception", cnn);
    cmd.CommandType = CommandType.StoredProcedure;
    cmd.Parameters.Add(new SqlParameter("@howmanyrecordstokeep", int.Parse("10")));
    cmd.Parameters.Add(new SqlParameter("@errortext", ex.ToString()));
    cmd.ExecuteNonQuery();


    cnn.Close();


   }

   Server.ClearError();

   Server.Transfer(VirtualPathUtility.ToAbsolute("~/error.aspx"));



  }
 }

</script>

