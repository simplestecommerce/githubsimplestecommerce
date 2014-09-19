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


<%@ Page Language="C#"  MasterPageFile="~/shop/masterpage.master" %>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>


<script runat="server">

    
    void bind () {

     rep.DataSource = simplestecommerce.notizie.getNotizie();
     rep.DataBind();

    }


    void Page_Load () {

        
        if (!Page.IsPostBack) bind();

    }

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">




       <table cellspacing="0" cellpadding="0" width="100%"  >
       <tr >
       <td class="box" width="100%"><div class="titolibox"><%=simplestecommerce.lingua.getforfrontendbypseudo("news.title") %></div></td>
       </tr>
          
           <asp:Repeater runat=server id="rep" >
            
            <ItemTemplate>
             <tr><td style="font-size:4px">&nbsp;</td></tr>
<tr>
 <td style="border: dotted 1px #aaaaaa; padding:4px; text-align:left">
                <div style="color:red; font-weight:bold"><%#DateTime.Parse(Eval ("n_data").ToString()).ToString("yyyy-M-d")%>
                <%#simplestecommerce.lingua.getforfrontendfromdb(Eval ("n_titolo").ToString())%></div>
                <%#simplestecommerce.lingua.getforfrontendfromdb(Eval("n_testo").ToString())%>
  </td>
 </tr>

            </ItemTemplate>
            
            

        
        </asp:Repeater>

          
         
        </table>
</asp:Content>













