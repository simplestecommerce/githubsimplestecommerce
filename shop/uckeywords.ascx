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


<%@ Control Language="c#" %>
<%@ import Namespace="simplestecommerce" %>
<script runat="server">

    void bind() {

    }


    void Page_Load() {

        if (!Page.IsPostBack) bind();

    }

</script>
<TITLE><%Response.Write(Application["config_nomeSito"].ToString());%></TITLE>
<META name="robots" content="index,follow">
<META NAME="DESCRIPTION" CONTENT="<%Response.Write(Application["config_description"].ToString());%>">
<META NAME="KEYWORDS" CONTENT="<%Response.Write(Application["config_keywords"].ToString());%>">

