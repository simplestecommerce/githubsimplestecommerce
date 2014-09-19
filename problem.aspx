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


<%@ Page Language="C#" ValidateRequest="true" %>
<%@ Import Namespace="simplestecommerce" %>
<script runat="server">

    public bool done = false;

    void Page_PreInit()
    {

        if (Request.QueryString["strproblem"] != null)
        {
            lblmessage.Text = Server.HtmlEncode(Request.QueryString["strproblem"].ToString());
            done = true;
        }


    }

    void Page_Load()
    {
   //  Response.Write ( "-" + Session["strproblem"].ToString());
        if (!done)
        {



            if (Session["strproblem"] != null)
            {
                lblmessage.Text += Server.HtmlEncode(Session["strproblem"].ToString());
                Session["strproblem"] = null;
            }

            
            
            
            if (Session["linkreturn"] != null)
            {

                lblmessage.Text += ("<br><br><a href='" + Session["linkreturn"].ToString() + "'>back</a>");
                Session["linkreturn"] = null;
            }
            else lblmessage.Text += "<div align='center'><a href='#' onclick='history.back(1)'>back</a>";

        }
    }
    
</script>


<!DOCTYPE html>


<head>
 <title>SimplestEcommerce error page</title>
<style>

 body {font-size:22px; font-family:Calibri}
 fieldset > legend {font-size:22px;font-family:Calibri}

</style>

</head>
<body>




<div align="center">

 <fieldset style="width:1000px">

  <legend>

   <%=simplestecommerce.lingua.getforfrontendbypseudo("problem.label.error.has.occurred") %>

  </legend>


    <asp:Label ID="lblmessage" runat="server" />

  </fieldset>


</div>

 </body>







