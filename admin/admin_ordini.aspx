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
<%@ import Namespace="System.Globalization" %>

<script runat="server">

    int ordPerPag = 25;
    string startin;
    string endin;
    string emailin;
    string firstnamein;
    string secondnamein;
    int orderstatusin;
    string useridin;
    DataTable dtorderstatus;

        void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
        {
             dGrid.CurrentPageIndex = e.NewPageIndex;
             bindData();

        }



    void buttFiltra_click (object sender, EventArgs e) {

            bool inputValido = true;

            if (!inputValido) return;

            bindData();
    }


    void bindData () {


        SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

        string strSql;
        strSql = "select name as orderstatusname, a.* from orderstatus inner join (select  id, data, note, promemoria, guestfirstname, guestsecondname, guestemail, idorderstatus, tot, idloggeduser, ut_firstname, ut_secondname, ut_email from tcart left join tutenti ON tcart.idloggeduser=tutenti.ut_id)  as a on orderstatus.id=a.idorderstatus" +
        " where data>=@startdate and data<@enddate";





        if (tboxiduser.Text != "")
        {
            strSql += " AND (idloggeduser LIKE @idloggeduser)";
        }

        
        if (tboxfirstname.Text != "")
        {
            strSql += " AND (guestfirstname LIKE @firstname OR ut_firstname LIKE @firstname)";
        }
        if (tboxsecondname.Text != "")
        {
            strSql += " AND (guestsecondname LIKE @secondname OR ut_secondname LIKE @secondname)";
        }
        if (tboxemail.Text != "")
        {
            strSql += " AND (guestemail LIKE @email OR ut_email LIKE @email)";
        }



        if (int.Parse(dListStato.SelectedValue) != -1) strSql += " AND idorderstatus=@idorderstatus";

        strSql += " ORDER BY a.id DESC";

        DataSet ds = new DataSet();

        SqlDataAdapter da = new SqlDataAdapter();
        SqlCommand cmd = new SqlCommand(strSql, cnn);


        
        cmd.Parameters.AddWithValue("startdate", calendarstart.SelectedDate.Date);
        cmd.Parameters.AddWithValue("enddate", calendarend.SelectedDate.Date.AddDays(1) );

        if (tboxiduser.Text != "")
        {
            cmd.Parameters.Add(new SqlParameter("@idloggeduser", tboxiduser.Text + "%"));
        }

        if (tboxfirstname.Text != "") cmd.Parameters.Add(new SqlParameter("@firstname", tboxfirstname.Text + "%"));
        if (tboxsecondname.Text != "") cmd.Parameters.Add(new SqlParameter("@secondname", tboxsecondname.Text + "%"));
        if (tboxemail.Text != "") cmd.Parameters.Add(new SqlParameter("@email", tboxemail.Text + "%"));

        if (int.Parse(dListStato.SelectedValue) != -1) cmd.Parameters.Add(new SqlParameter("@idorderstatus", int.Parse(dListStato.SelectedValue) ));

        da.SelectCommand = cmd;

        cnn.Open();
        da.Fill(ds, "ordini");



        cnn.Close();

        dGrid.DataSource = ds.Tables[0];
        dGrid.DataBind();


    }


    void dGridOrd_delete (object sender, DataGridCommandEventArgs e) {

            int id =  int.Parse ( ((HyperLink)e.Item.FindControl("hLinkIdOrd")).Text )  ;

            simplestecommerce.helpDb.nonQuery(
                "delete  FROM tcart WHERE id=@id",
                new SqlParameter("id", id));
            dGrid.CurrentPageIndex = 0;
            bindData();
    }

    void prepare()
    {
        dListStato.Items.Add(new ListItem("any", "-1"));

        DataTable dtstatus = simplestecommerce.orderstatus.getAll();

        foreach (DataRow drstatus in dtstatus.Rows)
        {

            dListStato.Items.Add(new ListItem( simplestecommerce.lingua.getinadminlanguagefromdb(drstatus["name"].ToString()), drstatus["id"].ToString()  ));            
        }


        
            calendarstart.SelectedDate = System.DateTime.Today.AddMonths(-1);
            calendarstart.VisibleDate = calendarstart.SelectedDate;

            calendarend.SelectedDate = System.DateTime.Today;
            calendarend.VisibleDate = calendarend.SelectedDate;
    
    
    }

    void Page_Load () {

        
        
        if (!Page.IsPostBack) {

            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>" +
            " &raquo; " +
            "orders";
            
            
            prepare();   
            bindData();
        }
    }

</script>


<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="Label1" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />


        <asp:Panel runat="server" GroupingText="filter orders">
       <table width="100%" cellspacing=0 style="padding:8px; ">
       <tr >
       <td valign=middle align="center">
       <asp:Calendar ID = "calendarstart" 
                 runat = "server"
                 SelectionMode="Day"
                  Caption="starting date"
           >
        </asp:Calendar>
           </td>
           <td>
       <asp:Calendar ID = "calendarend" 
                 runat = "server"
                 SelectionMode="Day"
             Caption="ending date"
            >
        </asp:Calendar>
               </td>
           </tr>
           </table>
            <table width="100%">
           <tr >
               <td align="left"> 
                <table>
                 <tr>
                  <td>first name</td>
                  <td><asp:textbox id="tboxfirstname" runat="server" enableviewstate=false cssclass=input /></td>
                 </tr>
                 <tr>
                  <td>second name</td>
                  <td><asp:textbox id="tboxsecondname" runat="server" enableviewstate=false cssclass=input /></td>
                 </tr>
                 <tr>
                  <td>email</td>
                  <td><asp:textbox id="tboxemail" runat="server" enableviewstate=false cssclass=input /></td>
                 </tr>
                 <tr>
                  <td>
                   userid
                  </td>
                  <td><asp:textbox id="tboxiduser" runat="server" enableviewstate=false cssclass=input /></td>
                 </tr>
                 <tr>
                  <td>order status</td>
                 <td>
                  <asp:DropDownList runat=server ID="dListStato" CssClass=input />
                 </td>
                 </tr>
                </table>
       <asp:button id="buttFiltra" runat=server text="FILTER" class=bottone onclick="buttFiltra_click"/>

       <br />
       <asp:label id="lblErr" runat=server forecolor=red enableviewstate=false/>
       </td>
       </tr>
       </table>
</asp:Panel>
        <br>
        <br>

        <asp:datagrid
        cellspacing="1"
        OnDeleteCommand="dGridOrd_delete"
        cellpadding=4
        id="dGrid"
        runat="server"
        width="100%"
        autogeneratecolumns="false"
        AllowPaging="true"
        PagerStyle-Mode="NumericPages"
        pagesize=<%# ordPerPag%>
        OnPageIndexChanged="Grid_Change"

        >
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <Columns>
                <asp:templatecolumn HeaderText="<b>ID order</b>">
                    <itemtemplate >
                        <asp:hyperlink id="hLinkIdOrd" runat="server" text=<%#Eval ("id")%> NavigateUrl=<%#"~/admin/admin_ordine.aspx?idcart=" + DataBinder.Eval (Container.DataItem, "id")%>  />
                    </itemtemplate>
                </asp:templatecolumn>

                <asp:templatecolumn HeaderText="<b>delete</b>">
                <ItemTemplate>
                    <asp:linkbutton id="lButtDelete" HeaderText="<b>delete<br>order</b>" commandname="Delete" runat="server" Text="<img src='../immagini/delete.gif' Border=0 >"  />
                   <ajaxToolkit:ConfirmButtonExtender TargetControlID="lButtDelete" ConfirmText="Confirm?"  runat="server"/>
                     </ItemTemplate>
                </asp:templatecolumn>

             <asp:TemplateColumn>
              <HeaderTemplate><b>order date</b></HeaderTemplate>
              <ItemTemplate>
               <%#Eval("data")==System.DBNull.Value? "N/A": DateTime.Parse(Eval("data").ToString()).ToString("yyyy-M-d  HH:mm:ss") %>
              </ItemTemplate>
             </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <HeaderTemplate><b>userid</b></HeaderTemplate>
                    <ItemTemplate>
                        <%#( Eval("idloggeduser")==System.DBNull.Value? "": simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("idloggeduser").ToString()) ) %>
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <HeaderTemplate><b>first name<br /></b></HeaderTemplate>
                    <ItemTemplate>
                        <%#Eval("idloggeduser")==System.DBNull.Value? simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("guestfirstname").ToString()) : simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_firstname").ToString()) %>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn>
                    <HeaderTemplate><b>second name<br /></b></HeaderTemplate>
                    <ItemTemplate>
                        <%#Eval("idloggeduser")==System.DBNull.Value?  simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("guestsecondname").ToString()) : simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("ut_secondname").ToString()) %>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn>
                    <HeaderTemplate><b>total</b></HeaderTemplate>
                    <ItemTemplate>
                        <%#((double)Eval("tot")).ToString("C")%>
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <HeaderTemplate><b>note</b></HeaderTemplate>
                    <ItemTemplate>
                        <%#simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("note").ToString())%>
                    </ItemTemplate>
                </asp:TemplateColumn>

               <asp:TemplateColumn>
                    <HeaderTemplate><b>promemoria</b></HeaderTemplate>
                    <ItemTemplate>
                        <%#simplestecommerce.sicurezza.xss.getreplacedencoded(Eval("promemoria").ToString())%>
                    </ItemTemplate>
                </asp:TemplateColumn>





                <asp:TemplateColumn>
                    <HeaderTemplate><b>order status</b></HeaderTemplate>
                    <ItemTemplate>
                        <%# simplestecommerce.sicurezza.xss.getreplacedencoded(simplestecommerce.lingua.getinadminlanguagefromdb( Eval("orderstatusname").ToString()))  %>
                    </ItemTemplate>
                </asp:TemplateColumn>
            </Columns>
        </asp:datagrid>
        <div align=right>
            <asp:label id="lblPaging" runat="server" />&nbsp;&nbsp;
        </div>



    </form></asp:content>

