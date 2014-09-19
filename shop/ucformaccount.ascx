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


<%@ Control Language="c#"   %>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Web.Security" %>

<script runat=server>


        

    void Page_Load()
    {
        simplestecommerce.User Currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;

        if (Currentuser.Anonimo)
        {

            panelLogged.Visible = false;
            lblMessageNotLogged.Text = simplestecommerce.lingua.getforfrontendbypseudo("allpages.boxlogin.notlogged");   
        }
        else
        {

            panelNotLogged.Visible = false;
            lblMessageLogged.Text = simplestecommerce.lingua.getforfrontendbypseudo("allpages.boxlogin.logged") + "<br><b>" + Server.HtmlEncode(Currentuser.Id) + "</b>";
        }



    }
         
    
</script>	
<table cellspacing="0" cellpadding="0" width="100%" style="margin-top:2px">
 <tr>
  <td class="box" width="100%">
   <div align="left" class="titoliboxsx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.boxlogin.boxtitle") %></div>
  </td>
 </tr>
</table>


<div class="contenutobox" style="margin-top:2px">


        <asp:Panel ID="panelLogged" runat=server Visible=true >
                    <div align=center>
                        <br /><asp:label id="lblMessageLogged" runat="server" />
                        <br />
                         <a runat="server" style="text-decoration:underline" href="~/shop/updateprofile.aspx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.boxlogin.update.profile")%></a><br /><%=lingua.getforfrontendbypseudo("allpages.boxlogin.update.profile.or")%><br />
                        <a href="~/shop/logout.aspx" style="text-decoration:underline" runat="server"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.boxlogin.do.logout")%></a>

                        <div><br /></div>
                    </div>
        </asp:Panel>

        <asp:Panel ID="panelNotLogged" runat=server Visible=true >
                    <div align=center>
                        <br /><asp:label id="lblMessageNotLogged" runat="server" />
                        <div><br /></div>
                    </div>
        </asp:Panel>

    </div>