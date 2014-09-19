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
<%@ import Namespace="System.Globalization" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">

    
    void dGrid_edit(object sender, DataGridCommandEventArgs e)
    {

        int idNews = int.Parse(e.Item.Cells[2].Text);
        Response.Redirect("admin_onenews.aspx?idNews=" + idNews);

        
    }

    void buttCrea_click(object sender, EventArgs e)
    {

        Response.Redirect("admin_onenews.aspx");

        
    }

    
                
    
    void bindData () {

        
        
        
        
        dGridNews.DataSource = simplestecommerce.notizie.getNotizie();
        dGridNews.DataBind();




        
        
    }

    void dGridNews_itemCommand (object sender, DataGridCommandEventArgs e) {


        
        switch (e.CommandName) {

              
            case "delete":
                int idNews = int.Parse(e.Item.Cells[2].Text);           
            string sql = "delete  FROM tnews WHERE n_id=@id";
            SqlParameter p1 = new SqlParameter("@id", idNews);
            simplestecommerce.helpDb.nonQuery(sql, p1);
                bindData();
                break;
        }

    }


    

    void Page_Load () {

     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; news";


        
        if (!Page.IsPostBack) {
            bindData();
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />





        <asp:datagrid GridLines="None" CellSpacing="1" onEditCommand="dGrid_edit" OnItemCommand="dGridNews_itemCommand" onpagesize=3  id="dGridNews" runat="server" width="100%" autogeneratecolumns="false">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <Columns>
                <asp:EditCommandColumn HeaderStyle-Width="40" CancelText="cancel"  UpdateText="OK" EditText="<center><img src=../immagini/edit.gif Border=0 Width=12 Height=12></center>"/>
                <asp:templatecolumn  HeaderStyle-Width="40">
                    <HeaderTemplate><b>delete</b></HeaderTemplate>
                    <ItemStyle width=40>
                    </ItemStyle>
                    <ItemTemplate><center>
                        <asp:linkbutton commandname="delete" runat="server" Text="<img src=../immagini/delete.gif Border=0 >"  />
                    </center>
                     </ItemTemplate>
                </asp:templatecolumn>



                <asp:boundcolumn datafield="n_id"  ReadOnly=true HeaderText="<b>IDNews</b>"  HeaderStyle-Width="30"/>
                <asp:templatecolumn>
                    <HeaderTemplate><b>date</b></HeaderTemplate>
                    <ItemStyle width=80>
                    </ItemStyle>
                    <ItemTemplate>
                        <asp:Label runat=server Text=<%#DateTime.Parse((Eval("n_data").ToString())).ToString("yyyy-M-d")%> />
                    </ItemTemplate>
                </asp:templatecolumn>
                
             
                <asp:templatecolumn>
                    <HeaderTemplate><b>title</b></HeaderTemplate>
                    <ItemStyle width=400>
                    </ItemStyle>
                    <ItemTemplate>
                        <asp:Label runat=server Text=<%#simplestecommerce.lingua.getinadminlanguagefromdb(Eval("n_titolo").ToString()) %> />
                    </ItemTemplate>
                </asp:templatecolumn>



                
            </Columns>
        </asp:datagrid>

         <div align="center">
            <asp:Button runat=server ID="buttCrea" CssClass=bottone Text="CREATE NEWS" onclick="buttCrea_click"/>

         </div>                  


    </form></asp:Content>