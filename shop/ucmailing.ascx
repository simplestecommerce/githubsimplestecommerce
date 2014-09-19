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


<%@ Control Language="c#"    %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="simplestecommerce" %>
<script runat="server">



    void bind() {

            }

    void buttEmail_click(object sender, EventArgs e)
    {

        Response.Redirect("newsletter.aspx?azione=iscrivi&email=" + Server.UrlEncode(tBoxEmail.Text));

    }


    void buttEmailCanc_click (object sender, EventArgs e) {
        Response.Redirect("newsletter.aspx?azione=cancella&email=" + Server.UrlEncode(tBoxEmail.Text));
     
    }

    void Page_Init () {

    }

    void Page_Load() {

        if (!Page.IsPostBack)
        {
            tBoxEmail.Attributes["onFocus"] = "this.value=''";
            buttEmail.Text = simplestecommerce.lingua.getforfrontendbypseudo("allpages.mailinglistbox.label.subscribe");
            buttEmailCanc.Text = simplestecommerce.lingua.getforfrontendbypseudo("allpages.mailinglistbox.label.unsubscribe");

        }
    }

</script>

<table cellspacing="0" cellpadding="0" width="100%" style="margin-top:2px">
 <tr>
  <td class="box" width="100%">
   <div align="left" class="titoliboxsx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.mailinglistbox.boxtitle") %></div>
  </td>
 </tr>
</table>
    

<div class=contenutobox  style="margin-top:2px">    
        <div align=center>
		<table width="180" border="0" cellpadding=0 cellspacing=0>
  			<tr>
			  <td align="center"><asp:textbox EnableViewState="true" ViewStateMode="Enabled" id="tBoxEmail" cssclass="form" style="width:165px; margin-top:6px;" runat=server text="email"  /></td>
			</tr>
  			<tr>
				<td align="center" style="color:#85B5E2">
			  	<asp:linkbutton runat=server id="buttEmail" onclick="buttEmail_click" style="text-decoration:underline;color:#333333" EnableViewState="true" ViewStateMode="Enabled" />
			  	|
				<asp:linkbutton runat=server id="buttEmailCanc" onclick="buttEmailCanc_click" style="text-decoration:underline;color:#333333" EnableViewState="true" ViewStateMode="Enabled"/>
				</td>
		  </tr>
  			<tr>
  			  <td height="10"></td>
		  </tr>		  
		</table>
         <asp:label runat=server id="lblEsito" EnableViewState="true" ViewStateMode="Enabled"/>
         </div>
</div>

