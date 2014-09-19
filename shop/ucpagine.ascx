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


<%@ Control Language="c#"  %>

<%@ import Namespace="System.Data" %>
<%@ import Namespace="simplestecommerce" %>

<script runat=server>


    public void item_databound(Object Sender, DataListItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            PlaceHolder pholdpagina = (PlaceHolder)e.Item.FindControl("pholdpagina");

            int idPag = Convert.ToInt32(  ((DataRowView)e.Item.DataItem).Row["pa_id"] ) ;






            
            IDataReader dr;
            dr = simplestecommerce.pagine.leggi(idPag);
            dr.Read();
            int protezione = (int)dr["pa_protezione"];
            dr.Close();

            simplestecommerce.User Currentuser = ((simplestecommerce.Cart)Session["Cart"]).User;

            if ((protezione == 0) || (protezione == 1 && !Currentuser.Anonimo) || (protezione == 2 && !Currentuser.Anonimo && Currentuser.Protezione== 1))
            {
                pholdpagina.Visible = true; 
            }

            
            
            
            
            
            
            
            
            
            
            
            
        }

    }

    
    
         void bind() {

             DataTable dt = simplestecommerce.pagine.getpagineinfobox();

             dList.DataSource = dt;
             dList.DataBind();

             
             
             
             
             
         }

         void Page_Load() {
             bind();




                 
           
         }


</script>

<table cellspacing="0" cellpadding="0" width="100%" style="margin-top:2px">
 <tr>
  <td class="box" width="100%">
   <div align="left" class="titoliboxsx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.extrapagesbox.boxtitle") %></div>
  </td>
 </tr>
</table>


            

<div class="contenutobox" style="margin-top:2px">
            <asp:DataList  runat=server ID="dList"  CellSpacing="0" CellPadding="0" RepeatColumns=1  onItemDataBound="item_databound"  Width="100%" style="padding:0px; margin:0px">
            <ItemTemplate>
                <asp:PlaceHolder runat="server" ID="pholdpagina" Visible="false">
                <table width="100%" cellpadding=0 cellspacing=0>
                <tr>
                <td height=24 width="100%" align=left style="padding-left:5px; background-color:#dde6e4">
                <a runat=server href=<%#"pagina.aspx?id=" + Eval("pa_id") %>   
                style="text-decoration:underline; font-family:tahoma; color:#333333; font-size:11px; font-weight:normal;"><%#simplestecommerce.lingua.getforfrontendfromdb(Eval ("pa_nome").ToString())%></a>
                </td> 
                </tr>
                </table>
                    </asp:PlaceHolder>
            </ItemTemplate>
            </asp:DataList>
     </div>




