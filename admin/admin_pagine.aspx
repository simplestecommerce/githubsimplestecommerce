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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">
    int posizione;
    DataSet ds;

    private void item_Created(Object Sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            LinkButton myButton = (LinkButton)e.Item.FindControl("lButtDelete");
            myButton.Attributes.Add("onclick", "return confirm_delete();");
        }

    }


    void dGrid_itemCommand(object sender, DataGridCommandEventArgs e)
    {

        int id = int.Parse(e.CommandArgument.ToString());
        
        switch (e.CommandName)
        {


            case "edit":
                Response.Redirect("admin_pagina.aspx?id=" + id + "&posizione="  + posizione.ToString() );
                break;

            case "delete":

                if (id == 8 || id == 23)
                {
                 lblerr.Text = "This page can't be deleted";
                 return;
                }
                simplestecommerce.pagine.delete(id);
                bind();
                break;
        }

    }

    
        
        
    void dGrid_edit(object sender, DataGridCommandEventArgs e)
    {
        int id = int.Parse(e.CommandArgument.ToString());
        Response.Redirect("admin_pagina.aspx?id=" + id + "&posizione=" + posizione ) ;

    }


    void bind()
    {

        dGrid.DataSource = simplestecommerce.helpDb.getDataTable(
            "select * from tpagine where pa_posizione=@posizione order by pa_id desc",
            new SqlParameter("posizione", posizione)
            );
        dGrid.DataBind();

    }


         void Page_Load () {

             posizione = Convert.ToInt32(Request.QueryString["posizione"]);       
             ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; ";
             if (posizione == 0) ((Label)Master.FindControl("lbldove")).Text += "pages in info box";
             else if (posizione==1) ((Label)Master.FindControl("lbldove")).Text += "pages in menu bar";

             
             if (!Page.IsPostBack) bind();

         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
<script>
    function confirm_delete() {
        if (confirm("confirm?") == true)
            return true;
        else
            return false;
    }
</script>

</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />



		
       <asp:datagrid 
           GridLines=none
           id="dGrid" 
           runat="server" 
           width="100%" 
           autogeneratecolumns="false"
           cellspacing="1" 
            AlternatingItemStyle-CssClass="admin_sfondo"
            ItemStyle-CssClass="admin_sfondobis"
       OnItemCommand="dGrid_itemCommand"
       OnItemCreated="item_Created"
       >
            <headerStyle cssClass=admin_sfondodark/>
            <Columns>

                <asp:templatecolumn>
                    <HeaderTemplate><center><b>delete</b></center></HeaderTemplate>
                    <ItemStyle width=40 HorizontalAlign="Center">
                    </ItemStyle>
                    <ItemTemplate>
                        <asp:linkbutton id="lButtDelete" commandargument=<%#Eval ("pa_id") %> commandname="delete" runat="server" Text="<img src=../immagini/delete.gif Border=0 >"  />
                    </ItemTemplate>
                </asp:templatecolumn>

                <asp:templatecolumn>
                    <HeaderTemplate><center><b>edit</b></center></HeaderTemplate>
                    <ItemStyle width=40 HorizontalAlign="Center">
                    </ItemStyle>
                    <ItemTemplate>
                        <asp:linkbutton commandname="edit" commandargument=<%#Eval ("pa_id") %> runat="server" Text="<img src=../immagini/edit.gif Border=0 >"  />
                    </ItemTemplate>
                </asp:templatecolumn>

             <asp:BoundColumn DataField="pa_id" HeaderText="<b>ID</b>" ItemStyle-Width="30" />

                <asp:templatecolumn>
                    <HeaderTemplate><center><b>page name</b></center></HeaderTemplate>
                    <ItemStyle width=400 HorizontalAlign="left">
                    </ItemStyle>
                    <ItemTemplate>
                        <asp:label runat="server" Text=<%#simplestecommerce.lingua.getinadminlanguagefromdb(Eval("pa_nome").ToString()) %>  />
                    </ItemTemplate>
                </asp:templatecolumn>

            </Columns>
        </asp:datagrid>

        
        <div align=right style="padding:6px">
        <input class=bottone type="submit" onclick="window.location.href='admin_pagina.aspx?posizione=<%=posizione%>'; return false;" value="NEW PAGE" />
        </div>
        

    </form></asp:Content>