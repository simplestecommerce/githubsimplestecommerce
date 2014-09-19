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
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    void dgrid_update(object sender, DataGridCommandEventArgs e)
    {
        Label lblcode = (Label)e.Item.FindControl("lblcode"); // primary key

        TextBox tboxdiscount = (TextBox)e.Item.FindControl("tboxdiscount");

        DropDownList dlistispercent = (DropDownList)e.Item.FindControl("dlistispercent");
           
        DropDownList dlistapplyon = (DropDownList)e.Item.FindControl("dlistapplyon");

        DropDownList dlistenabled = (DropDownList)e.Item.FindControl("dlistenabled");





        try
        {
            double discount = double.Parse(tboxdiscount.Text, simplestecommerce.admin.localization.primarynumberformatinfo);

        }
        catch
        {
            lblerr.Text = "type a number in discount field";
            return;

        }

            SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
            cnn.Open();

            string sql;
            SqlCommand cmd;


            sql = "update coupon set discount=@discount, ispercent=@ispercent, enabled=@enabled, applyon=@applyon where code=@code";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.AddWithValue("discount", double.Parse(tboxdiscount.Text, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("ispercent", int.Parse(dlistispercent.SelectedValue, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("enabled", int.Parse(dlistenabled.SelectedValue, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("applyon", int.Parse(dlistapplyon.SelectedValue, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("code", lblcode.Text);
            cmd.ExecuteNonQuery();

            cnn.Close();

            lblerr.Text = "coupon updated";
            lblerr.ForeColor = System.Drawing.Color.Blue;
            grid.EditItemIndex = -1;

            bind();
        

    }

    void grid_cancel(object sender, DataGridCommandEventArgs e)
    {

        grid.EditItemIndex = -1;
        bind();
    }


    void grid_edit(object sender, DataGridCommandEventArgs e)
    {

        grid.EditItemIndex = e.Item.ItemIndex;
        bind();

    }

    void grid_databound(Object Sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.EditItem)
        {

            DropDownList d = (DropDownList)e.Item.FindControl("dlistenabled");
            bool enabled = (bool)((DataRowView)e.Item.DataItem)["enabled"];
            d.SelectedValue = (enabled?"1":"0");

            DropDownList dlistapplyon = (DropDownList)e.Item.FindControl("dlistapplyon");
            int applyon = (int)((DataRowView)e.Item.DataItem)["applyon"];
            dlistapplyon.SelectedValue = applyon.ToString();

            DropDownList dlistispercent= (DropDownList)e.Item.FindControl("dlistispercent");
            bool ispercent = (bool)((DataRowView)e.Item.DataItem)["ispercent"];
            dlistispercent.SelectedValue = (ispercent ? "1" : "0");

            
            TextBox tboxdiscount = (TextBox)e.Item.FindControl("tboxdiscount");
            tboxdiscount.Text = (((DataRowView)(e.Item.DataItem))["discount"]).ToString();

            

        }

    }
    void grid_command(object o, DataGridCommandEventArgs e)
    {



        if (e.CommandName == "delete")
        {

            string code = (e.CommandArgument.ToString());


            string sql = "delete from coupon where code=@code";
            simplestecommerce.helpDb.nonQuery(sql, new SqlParameter("code", code));

            lblerr.Text = "coupon cancellato";
            lblerr.ForeColor = System.Drawing.Color.Blue;

            bind();


        }
    }


    void buttnew_click(object sender, EventArgs e)
    {





        try
        {
            double discount = double.Parse(tboxdiscount.Text, simplestecommerce.admin.localization.primarynumberformatinfo);

        }
        catch
        {
            lblerr.Text = "type a number in discount field";
            return;

        }

        if (tboxcode.Text == "" || tboxcode.Text.Length > 50)
        {

            lblerr.Text = "not valid code length";
        }
        else
        {
            SqlConnection cnn = new SqlConnection(Application["strcnn"].ToString());
            cnn.Open();

            string sql;
            SqlCommand cmd;

            sql = "select count(*) from coupon where code=@code";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.AddWithValue("code", tboxcode.Text);
            int quanti = Convert.ToInt32(cmd.ExecuteScalar());
            if (quanti > 0)
            {
                lblerr.Text = "existing coupon code";
                cnn.Close();
                return;
            }

            sql = "insert into coupon (code, discount, ispercent, enabled, applyon) values (@code, @discount, @ispercent, @enabled, @applyon)";
            cmd = new SqlCommand(sql, cnn);
            cmd.Parameters.AddWithValue("code", tboxcode.Text);
            cmd.Parameters.AddWithValue("discount", double.Parse(tboxdiscount.Text, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("ispercent", int.Parse(dlistdiscounttype.SelectedValue, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("enabled", int.Parse("1", simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.Parameters.AddWithValue("applyon", int.Parse(dlistapplyon.SelectedValue, simplestecommerce.admin.localization.primarynumberformatinfo));
            cmd.ExecuteNonQuery();

            cnn.Close();

            lblerr.Text = "coupon created";
            lblerr.ForeColor = System.Drawing.Color.Blue;

            bind();
        }
    }




    void bind()
    {

        DataTable dt = simplestecommerce.helpDb.getDataTable("select * from coupon");


        grid.DataSource = dt;
        grid.DataBind();

    }








    void Page_Load()
    {


     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; coupon discount"; 

        if (!Page.IsPostBack) bind();

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
        <br />
        <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />

        <fieldset>
            <legend>new coupon</legend>

            <table cellpadding="1" cellspacing="1">
                <tr class="admin_sfondo">
                    <td width="250" nowrap>coupon code
                    </td>
                    <td width="100%">
                        <asp:TextBox Style="width: 100%" runat="server" EnableViewState="false" Text="" ID="tboxcode" class="input" />
                    </td>
                </tr>
                <tr class="admin_sfondo">
                    <td nowrap>discount
                    </td>
                    <td nowrap>
                        <asp:TextBox Style="width: 80px" runat="server" EnableViewState="false" Text="" ID="tboxdiscount" class="input" />
                        <asp:DropDownList runat="server" CssClass="input" ID="dlistdiscounttype">
                            <asp:ListItem Value="1">percent discount</asp:ListItem>
                            <asp:ListItem Value="0">fixed discount</asp:ListItem>
                        </asp:DropDownList>


                    </td>
                </tr>
                <tr class="admin_sfondo">
                    <td nowrap>apply on
                    </td>
                    <td nowrap>
                        <asp:DropDownList runat="server" CssClass="input" ID="dlistapplyon">
                            <asp:ListItem Value="0">subtotal (before taxes)</asp:ListItem>
                            <asp:ListItem Value="1">total (after taxes)</asp:ListItem>
                        </asp:DropDownList>


                    </td>
                </tr>

                <tr>
                    <td height="8" colspan="2"></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <asp:Button OnClick="buttnew_click" ID="buttnew" runat="server" class="bottone" Text="ADD NEW COUPON" />
                    </td>
                </tr>
            </table>


        </fieldset>

        <br />
        <br />

        <asp:DataGrid
            ID="grid"
            runat="server"
            Width="100%"
         gridlines="None"
         cellspacing="1"
            AutoGenerateColumns="false"
            OnEditCommand="grid_edit"
            OnItemDataBound="grid_databound"
             OnCancelCommand="grid_cancel"
             OnUpdateCommand="dgrid_update"
            OnItemCommand="grid_command">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <AlternatingItemStyle CssClass="admin_sfondobis" />
            <EditItemStyle CssClass="small" />
            <Columns>
                <asp:EditCommandColumn CancelText="cancel"  UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>"/>

                <asp:TemplateColumn HeaderText="<b>coupon code</b>"  >
                    <ItemTemplate>
                        <asp:Label runat="server" Text=<%#Eval("code").ToString() %> ID="lblcode" />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="<b>discount</b>">
                    <ItemTemplate>
                        <asp:Label runat="server" Text=<%#Eval("discount").ToString() %> id="lbldiscount" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Text=<%#Eval("discount").ToString() %> id="tboxdiscount" />
                    </EditItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="<b>discount type</b>">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%#((bool)Eval("ispercent"))? "percent":"fixed" %>' />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList runat="server" ID="dlistispercent" CssClass="input">
                            <asp:ListItem runat="server" Value="1">percent</asp:ListItem>
                            <asp:ListItem runat="server" Value="0">fixed</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn HeaderText="<b>apply on</b>">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%#((int)Eval("applyon"))==0? "subtotal":"total" %>' />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList runat="server" ID="dlistapplyon" CssClass="input">
                            <asp:ListItem runat="server" Value="0">subtotal</asp:ListItem>
                            <asp:ListItem runat="server" Value="1">total</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="<b>enabled</b>">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%#((bool)Eval("enabled"))? "enabled":"disabled" %>' />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList runat="server" ID="dlistenabled" CssClass="input">
                            <asp:ListItem runat="server" Value="1">enabled</asp:ListItem>
                            <asp:ListItem runat="server" Value="0">disabled</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn HeaderText="<b>delete</b>">
                    <ItemTemplate>
                        <asp:Button runat="server" Text="delete" CssClass="input" CommandName="delete" CommandArgument='<%#Eval("code").ToString() %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>


            </Columns>
        </asp:DataGrid>

        <br>
        <br>
        <br>
    </form>
</asp:Content>
