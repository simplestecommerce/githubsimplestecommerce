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

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Sql" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.SqlTypes" %>

<script runat="server">

    int idart;
    string[] arrArtCorr;


    void checkedchange(object o, EventArgs e)
    {
     
     CheckBox cbox = ((CheckBox)o);
     
     int idcorr = int.Parse ( cbox.ToolTip );
     
     SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
     SqlCommand cmd;
     cnn.Open();
     
     if ( ((cbox.Checked))) {
      
             string sql =
           "declare @quanti as int = (SELECT COUNT(*) from tcorrelati where idart=@idart AND idartcorr=@idartcorr);" +
           "if (@quanti=0) insert into tcorrelati (idart, idartcorr) VALUES (@idart, @idartcorr)";
       cmd = new SqlCommand(sql, cnn);
       cmd.Parameters.Add(new SqlParameter("idart", idart));
       cmd.Parameters.Add(new SqlParameter("idartcorr", idcorr));
       cmd.ExecuteNonQuery();
     }

     else
     {

      string sql =
       "delete from tcorrelati where idart=@idart AND idartcorr=@idartcorr;";
       cmd = new SqlCommand(sql, cnn);
       cmd.Parameters.Add(new SqlParameter("idart", idart));
       cmd.Parameters.Add(new SqlParameter("idartcorr", idcorr));
       cmd.ExecuteNonQuery();

      
     }

      




     
     cnn.Close();
     bindData();
    }
    
    void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
    {
        dGridart.CurrentPageIndex = e.NewPageIndex;
        bindData();

    }

        

        
        
        
        
        
        
    

    private void databound(Object Sender, DataGridItemEventArgs e)
    {


     

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                CheckBox myCheckBox = (CheckBox)e.Item.FindControl("cBox");
                DataRowView drv = (DataRowView)(e.Item.DataItem);
                string id = drv["art_id"].ToString();


                
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                SqlCommand cmd;
                cnn.Open();                
                string sql = "select COUNT(*) From tcorrelati WHERE idart=@idart AND idartcorr=@idartcorr";
                cmd = new SqlCommand(sql, cnn);
                cmd.Parameters.Add(new SqlParameter("idart", idart));
                cmd.Parameters.Add(new SqlParameter("idartcorr", id));
                bool isCorrelato = Convert.ToInt32(cmd.ExecuteScalar())>0;

                myCheckBox.Checked = isCorrelato;
                
                cnn.Close();                                
            }

    }


    void bindData()
    {
        
        string sql;
        sql = "SELECT art_nome, art_id, art_cod FROM tarticoli  where art_id<>@idart ORDER BY art_id";
        SqlParameter p1 = new SqlParameter("idart", idart);
        dGridart.DataSource = simplestecommerce.helpDb.getDataTable(sql, p1);
        dGridart.DataBind();
        
    }



    void Page_Init () {


        
        idart = Convert.ToInt32(Request.QueryString["idart"]);
    }





    void Page_Load () {

        if (!Page.IsPostBack) {
         ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>" +
" &raquo; " +
"<a href='admin_articoli.aspx'>products</a>" +
" &raquo;" +
"<a href='admin_articolo.aspx?idart=" + idart.ToString() + "'>product ID " + idart.ToString() + "</a>" +
" &raquo; " +
"related products";
         

            bindData();
        }
    }

</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server">
 <script>
  function confirm_delete() {
   if (confirm("Confirm?") == true)
    return true;
   else
    return false;
  }
 </script>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnablePartialRendering="true" />
  <br />


  <asp:UpdatePanel ID="PannelloDinamico" runat="server">
   <ContentTemplate>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1">
     <ProgressTemplate>
      <ajaxToolkit:AlwaysVisibleControlExtender
       ID="AlwaysVisibleControlExtender1"
       runat="server"
       TargetControlID="panelprogress"
       VerticalSide="Middle"
       HorizontalSide="Center">
      </ajaxToolkit:AlwaysVisibleControlExtender>
      <asp:Panel ID="panelprogress" runat="server">
       <img src="~/immagini/loading.gif" width="30" runat="server" />
      </asp:Panel>
     </ProgressTemplate>
    </asp:UpdateProgress>


  <asp:Label ID="Label1" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />



  <asp:DataGrid
   EnableViewState="true"
   gridlines="none"
   CellSpacing="1"
   ID="dGridart"
   runat="server"
   Width="100%"
   AutoGenerateColumns="false"
   OnItemDataBound="databound"
   AllowPaging="true"
   PagerStyle-Mode="NumericPages"
   PageSize="20"
   OnPageIndexChanged="Grid_Change">
   <HeaderStyle CssClass="admin_sfondodark" />
   <ItemStyle CssClass="admin_sfondo" />
   <AlternatingItemStyle CssClass="admin_sfondobis" />
   <Columns>
    <asp:TemplateColumn>
     <HeaderTemplate><b>select</b></HeaderTemplate>
     <ItemStyle Width="40"></ItemStyle>
     <ItemTemplate>
      <asp:CheckBox runat="server" ID="cBox" OnCheckedChanged="checkedchange" ToolTip='<%#Eval("art_id").ToString() %>' AutoPostBack="true" />
     </ItemTemplate>
    </asp:TemplateColumn>




    <asp:BoundColumn DataField="art_id" HeaderText="<b>idarticle</b>" />
    <asp:BoundColumn DataField="art_cod" HeaderText="<b>Art.Code</b>" />
    <asp:TemplateColumn>
     <HeaderStyle HorizontalAlign="Center" />
     <HeaderTemplate><b>name</b></HeaderTemplate>
   <ItemTemplate>
    <asp:Label runat="server" Text=<%#simplestecommerce.lingua.getinadminlanguagefromdb(Eval("art_nome").ToString()) %> />
   </ItemTemplate>
      </asp:TemplateColumn>
   
   </Columns>
  </asp:DataGrid>

</ContentTemplate>
   </asp:UpdatePanel>

 </form>



</asp:Content>
