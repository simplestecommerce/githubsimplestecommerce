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
<%@ import Namespace="estensioni" %>


<script runat="server">

    DataTable dttaxprofiles = new DataTable();

    bool merchantbelongtoue = false;
    
    // taxrates****************************************************************************
    bool changed = false;
    

    void changerate(object sender, EventArgs e)
    {
        int idtaxprofile;

        if (ViewState["idtaxprofile"] == null) return;

        idtaxprofile = (int)ViewState["idtaxprofile"];

        TextBox tbox = (TextBox)sender;
        double rate=0;
        try
        {
         rate = double.Parse(tbox.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
        }
        catch { return; }
     
         simplestecommerce.helpDb.nonQuery("update taxrates set rate=@rate" +
          " where idregion=@idregione and idtaxprofile=@idtaxprofile",
         new SqlParameter("rate", rate),
         new SqlParameter("idregione", tbox.ToolTip),
         new SqlParameter("idtaxprofile", idtaxprofile));
         
        changed = true;

    }
    void changevatrateforfirm(object sender, EventArgs e)
    {
     int idtaxprofile;

     if (ViewState["idtaxprofile"] == null) return;

     idtaxprofile = (int)ViewState["idtaxprofile"];

     TextBox tbox = (TextBox)sender;
     double rate = 0;
     try
     {
      rate = double.Parse(tbox.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
     }
     catch { return; }

     simplestecommerce.helpDb.nonQuery("update taxrates set vatrateforfirm=@rate" +
      " where idregion=@idregione and idtaxprofile=@idtaxprofile",
     new SqlParameter("rate", rate),
     new SqlParameter("idregione", tbox.ToolTip),
     new SqlParameter("idtaxprofile", idtaxprofile));

     changed = true;

    }
    void changevatrateforprivate(object sender, EventArgs e)
    {
     int idtaxprofile;

     if (ViewState["idtaxprofile"] == null) return;

     idtaxprofile = (int)ViewState["idtaxprofile"];

     TextBox tbox = (TextBox)sender;
     double rate = 0;
     try
     {
      rate = double.Parse(tbox.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
     }
     catch { return; }

     simplestecommerce.helpDb.nonQuery("update taxrates set vatrateforprivate=@rate" +
      " where idregion=@idregione and idtaxprofile=@idtaxprofile",
     new SqlParameter("rate", rate),
     new SqlParameter("idregione", tbox.ToolTip),
     new SqlParameter("idtaxprofile", idtaxprofile));

     changed = true;

    }





    void gridrates_update(object sender, DataGridCommandEventArgs e)
    {



        bool basedonshipping = ((DropDownList)e.Item.FindControl("dlistbasedon")).SelectedValue == "1";
        string nome = ((TextBox)e.Item.Cells[2].Controls[0]).Text;


        int id = Convert.ToInt32(e.Item.Cells[1].Text);

        simplestecommerce.helpDb.nonQuery(
            "update taxprofiles set name=@name where id=@id",
            new SqlParameter("name", nome),
            new SqlParameter("id", id)
            );

        gridrates.EditItemIndex = -1;
        bindrates();
    }


    void gridrates_edit(object sender, DataGridCommandEventArgs e)
    {

        gridrates.EditItemIndex = e.Item.ItemIndex;
        bindrates();

    }


    void gridrates_cancel(object sender, DataGridCommandEventArgs e)
    {

        gridrates.EditItemIndex = -1;
        bindrates();
    }


    void bindrates()
    {
        int idtaxprofile;

        if (ViewState["idtaxprofile"] == null) return;

        idtaxprofile = (int)ViewState["idtaxprofile"];
        
        SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
        cnn.Open();
        DataRow dr = (simplestecommerce.helpDb.getDataTableByOpenCnn(
         cnn,
         "select * from taxprofiles where id=@id",
          new SqlParameter("id", idtaxprofile))
          ).Rows[0];
        lbltaxprofilename.Text = "<b>" + dr["name"].ToString() + "</b>";


        DataTable dttaxprofile = simplestecommerce.helpDb.getDataTableByOpenCnn(
            cnn,
            "select r_id, r_nome, r_ue, taxprofiles.id as idtaxprofile, taxprofiles.name as nametaxprofile"+
            ", taxrates.rate as rate, taxrates.vatrateforfirm as vatrateforfirm, taxrates.vatrateforprivate as vatrateforprivate" +
            " from tregioni, taxprofiles, taxrates where r_id=taxrates.idregion and taxprofiles.id=taxrates.idtaxprofile" +
            " and taxprofiles.id=@id order by r_nome",
           new SqlParameter("id", idtaxprofile)
        );
        gridrates.DataSource = dttaxprofile;
        gridrates.DataBind();


        cnn.Close();
    }

   
    
    
    
    
    // taxprofiles **********************************************************************
    
    void grid_databound(Object Sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.EditItem)
        {
        }

    }

    
    
        void buttNew_click (object sender, EventArgs e) {

            if (TBOXnome.Text.Length == 0)
            {
                lblerr.Text = "type a name for tax profile";
                    return;
            }

            SqlConnection cnn;
            SqlCommand cmd;
            string sql;

            cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
            cnn.Open();

            sql = "INSERT INTO taxprofiles (name) VALUES (@name)" +
                "declare @lastidtaxprofile int ; set @lastidtaxprofile=(select max(id) from taxprofiles);" +
                "insert into taxrates (idregion, idtaxprofile) select r_id, @lastidtaxprofile from tregioni";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.Add(new SqlParameter("@name", TBOXnome.Text));
            cmd.ExecuteNonQuery();
            
            
            
            cnn.Close();
            bind();
        }




         void bind () {

             dttaxprofiles = simplestecommerce.helpDb.getDataTable("select * from taxprofiles");
             dGrid.DataSource = dttaxprofiles;
                dGrid.DataBind();

         }





         void dGrid_edit (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex = e.Item.ItemIndex;
            bind();

         }


         void dGrid_cancel (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex=-1;
            bind();
         }

         
         void update (object sender, DataGridCommandEventArgs e) {



             string nome = ((TextBox)e.Item.Cells[3].Controls[0]).Text;

             
             int id =  Convert.ToInt32 (e.Item.Cells[2].Text);

             simplestecommerce.helpDb.nonQuery(
                 "update taxprofiles set name=@name where id=@id",
                 new SqlParameter("name", nome),
                 new SqlParameter("id", id)
                 );
                    
             dGrid.EditItemIndex=-1;
             bind();
          }



         void grid_command(object o, DataGridCommandEventArgs e)
         {


             if (e.CommandName == "editrates")
             {

                 ViewState["idtaxprofile"] = int.Parse(e.CommandArgument.ToString());

                 pholderrates.Visible = true;
                 bindrates();
             }
         }


         void Page_Load()
         {

          SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
          cnn.Open();

          SqlCommand cmd = new SqlCommand("select r_ue from tregioni where r_id=@id", cnn);
          cmd.Parameters.AddWithValue("id", (int)simplestecommerce.config.getCampoByApplication("config_idmerchantregion"));
          merchantbelongtoue = (bool)cmd.ExecuteScalar();

          cnn.Close();
             if (!Page.IsPostBack)
             {
                 bind();
                 ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; tax profiles"; 

             }
         }
         void Page_PreRender()
         {
             if (changed)
             {
                 bindrates();
             }

         }

</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />




	<asp:panel GroupingText="tax profiles" Width="100%" runat="server" DefaultButton="buttNew" >		
  <table>
   <tr>
    <td width="100%" nowrap>
      name&nbsp;<asp:TextBox id="TBOXnome" style="width:100%" CssClass="input" runat="server" />
        &nbsp;&nbsp;<asp:button onclick="buttNew_click" runat=server class=bottone text="ADD NEW TAX PROFILE" ID="buttNew" />

    </td>
   </tr>
  </table>
	
        <br />

     <asp:DataGrid 
          ID="dGrid" 
         runat="server" 
         cellspacing="1"
         gridlines="none"
         Width="100%"
          AutoGenerateColumns="false"
          OnCancelCommand="dGrid_cancel" 
         OnEditCommand="dGrid_edit" 
         OnItemDataBound="grid_databound" 
         OnUpdateCommand="update"
          OnItemCommand="grid_command"
         >
      <HeaderStyle CssClass="admin_sfondodark" />
      <ItemStyle CssClass="admin_sfondo" />
      <AlternatingItemStyle CssClass="admin_sfondobis" />
      <EditItemStyle CssClass="small" />
      <Columns>
       <asp:EditCommandColumn CancelText="cancel" UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" />
          <asp:TemplateColumn>
              <ItemStyle HorizontalAlign="Center" />
              <ItemTemplate>
                  <asp:LinkButton runat="server" Text="EDIT RATES" CommandName="editrates"  CommandArgument=<%#Eval("id") %> />
              </ItemTemplate>
          </asp:TemplateColumn>

       <asp:BoundColumn DataField="id" ReadOnly="true" HeaderText="<b>ID</b>" />
       <asp:BoundColumn DataField="name" ReadOnly="false" HeaderText="<b>name</b>" />
      </Columns>
     </asp:DataGrid>
	</asp:panel>

        <br>
        <br>

        <asp:placeholder runat="server" ID="pholderrates" Visible="false">
        <fieldset>
            <legend>tax rates
                <asp:Label runat="server" ID="lbltaxprofilename" /></legend>
            <asp:DataGrid 
                ID="gridrates" 
                runat="server" 
                Width="100%"
                gridlines="None"
                cellspacing="1"
                AutoGenerateColumns="false" OnCancelCommand="gridrates_cancel" OnEditCommand="gridrates_edit" OnUpdateCommand="gridrates_update">
                <HeaderStyle CssClass="admin_sfondodark" />
                <ItemStyle CssClass="admin_sfondo" />
                <AlternatingItemStyle CssClass="admin_sfondobis" />
                <EditItemStyle CssClass="small" />
                <Columns>
                    <asp:BoundColumn DataField="r_id" ReadOnly="true" HeaderText="<b>ID</b>" />

                    <asp:BoundColumn DataField="r_nome" ReadOnly="true" HeaderText="<b>name</b>" />
                    
                    <asp:TemplateColumn HeaderText="<center>VAT rate %<br>for firms</center>">
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:TextBox 
                              Enabled=<%#((bool)Eval("r_ue") && merchantbelongtoue) %>
                              BackColor=<%#((bool)Eval("r_ue") && merchantbelongtoue) ?System.Drawing.Color.White:System.Drawing.Color.Silver  %>
                              runat="server" OnTextChanged="changevatrateforfirm" ToolTip='<%#Eval("r_id").ToString() %>' CssClass="inputsmall" AutoPostBack="false" Text='<%#Eval("vatrateforfirm").ToString() %>' />
                            %
                        </ItemTemplate>
                    </asp:TemplateColumn>
                 
        
                    <asp:TemplateColumn HeaderText="<center>VAT rate %<br>for privates</center>">
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:TextBox 
                              Enabled=<%#((bool)Eval("r_ue") && merchantbelongtoue) %>
                              BackColor=<%#((bool)Eval("r_ue")&&merchantbelongtoue)? System.Drawing.Color.White:System.Drawing.Color.Silver  %>
                              runat="server" OnTextChanged="changevatrateforprivate" ToolTip='<%#Eval("r_id").ToString() %>' CssClass="inputsmall" AutoPostBack="false" Text='<%#Eval("vatrateforprivate").ToString() %>' />
                            %
                        </ItemTemplate>
                    </asp:TemplateColumn>
                 
                          
                    <asp:TemplateColumn HeaderText="<center>tax rate % (non VAT)</center>">
                        <ItemStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:TextBox 
                              Enabled=<%#!((bool)Eval("r_ue") && merchantbelongtoue) %>
                              BackColor=<%#!((bool)Eval("r_ue") && merchantbelongtoue)? System.Drawing.Color.White:System.Drawing.Color.Silver  %>
                             runat="server" OnTextChanged="changerate"  ToolTip='<%#Eval("r_id").ToString() %>' CssClass="inputsmall" AutoPostBack="false" Text='<%#Eval("rate").ToString() %>' />
                            %
                        </ItemTemplate>
                    </asp:TemplateColumn>
                </Columns>
            </asp:DataGrid>
            <div align="right">
                <asp:Button Text="SAVE" CssClass="bottone" runat="server" /></div>
            <asp:Label runat="server" EnableViewState="false" Text='<%#""%>' ID="lbltest" />
        </fieldset>
        </asp:placeholder>









</form>
</asp:Content>