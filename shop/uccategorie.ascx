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


<%@ Control Language="c#"  EnableViewState="true" ViewStateMode="Enabled" %>
<%@ import Namespace="simplestecommerce" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.Common" %>
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.Data.SqlTypes" %>
<%@ import Namespace="System.Collections" %>
<script runat=server>
    
    int idAntenato = 0;
    int idCatSelected = 0;
    
    void lista_bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            DataRowView dr = (DataRowView)(e.Item.DataItem);
            ((Label)e.Item.FindControl("lblCat")).Text = simplestecommerce.lingua.getforfrontendfromdb(dr["cat_nome"].ToString());

            if (dr["cat_img"].ToString() == "" || dr["cat_img"]==System.DBNull.Value)
                ((Image)e.Item.FindControl("img")).ImageUrl = ResolveUrl( "~/immagini/non_disponibile.gif");
            else ((Image)e.Item.FindControl("img")).ImageUrl = dr["cat_img"].ToString();
            ((HtmlAnchor)e.Item.FindControl("linkImg")).HRef = simplestecommerce.Category.linkforrouting((int)dr["cat_id"]);


            int idAntenato=0;
            
            if ( idCatSelected>0) {
             idAntenato = simplestecommerce.Category.getAntenato(idCatSelected); 
            }
            if ( idAntenato == (int)dr["cat_id"])
            {
                
                ((Label)e.Item.FindControl("lblCatSelected")).Text = dr["cat_nome"].ToString();
                ((PlaceHolder)e.Item.FindControl("pHolderCatSelected")).Visible= true;
                ((PlaceHolder)e.Item.FindControl("pHolderCat")).Visible = false;
                ((HtmlAnchor)e.Item.FindControl("anchorSelected")).HRef = simplestecommerce.Category.linkforrouting((int)dr["cat_id"]);
                
            }
            else {
                ((HtmlAnchor)e.Item.FindControl("anchorCat")).HRef = simplestecommerce.Category.linkforrouting((int)dr["cat_id"]);
                ((Label)e.Item.FindControl("lblCat")).Text = simplestecommerce.lingua.getforfrontendfromdb(dr["cat_nome"].ToString());
                
            }
        }

    }

    void Page_Load()
    {
     
        idCatSelected = Convert.ToInt32(Request.QueryString["idCatSelected"]);

        DataView dv = (DataView)HttpContext.Current.Application["dvvisiblecategoriesorderbyparent"];
        DataRowView[] righe = dv.FindRows(idCatSelected);

            if (!Page.IsPostBack)
            {
                lista.DataSource = righe;
                lista.DataBind();

            }
        
            
    }
</script>

<table cellspacing="0" cellpadding="0" width="100%">
 <tr>
  <td class="box" width="100%">
   <div align="left" class="titoliboxsx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.boxcategories.boxtitle") %></div>
  </td>
 </tr>
</table>




<table width="195" cellpadding=0 cellspacing=0 class="contenutobox" style="margin-top:2px">        
        <asp:Repeater runat=server ID="lista" OnItemDataBound="lista_bound">
            <ItemTemplate>
            
            <tr>
            
            <td width="25" height="25" style="background-color:#dde6e4;" ><a runat=server id="linkImg"><asp:image runat="server" ID="img"  Width="20"  height="20" style=" vertical-align:middle; margin-left:4px; border:solid 1px #5e6ba5"/></a></td>
            <td style="background-color:#dde6e4; text-align:left" width="100%">
                <asp:PlaceHolder runat=server ID="pHolderCat">
                <a runat=server id="anchorCat" style="text-decoration:none; padding-left:3px"><asp:Label ID="lblCat" runat=server/></a>
                </asp:PlaceHolder>
                <asp:PlaceHolder runat=server ID="pHolderCatSelected" Visible=false>
                <!--<img src='immagini/versodestra.gif' id="freccia" runat=server visible=true>--><a runat=server id="anchorSelected" style="color:red;text-decoration:none;font-size:11px; font-weight:bold; padding-left:3px"><asp:Label ID="lblCatSelected" runat=server/></a></span>
                </asp:PlaceHolder>
            </td>
            </tr>
            </ItemTemplate>
            <SeparatorTemplate>
                <tr><td colspan=2 style="height:1px; font-size:0px; background-color:#fff">&nbsp;</td></tr>
            </SeparatorTemplate>

        </asp:Repeater>
        </table>

