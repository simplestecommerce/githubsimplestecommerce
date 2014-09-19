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
<%@ import Namespace="System.Data.Sql" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">

    DataSet ds;


    void changeTendina(object sender, EventArgs e)
    {

        DropDownList mySender = (DropDownList)sender;
        string qualeControllo = mySender.ID;
        DataGridItem row = (DataGridItem)(mySender.NamingContainer);
        int idDb = int.Parse(row.Cells[0].Text);
        int zona = int.Parse(((DropDownList)(row.FindControl("dDListZona"))).SelectedValue);

        string sql = "";

        sql = "UPDATE tregioni set r_zona=@zona where r_id=@id";

        SqlParameter p1 = new SqlParameter("@zona", zona);
        SqlParameter p2 = new SqlParameter("@id", idDb);
        simplestecommerce.helpDb.nonQuery(sql, p1, p2);
       // Response.Write(valore + "/" + idDb);
        bindStati();
    }


        void buttAggSp_click (object sender, EventArgs e) {

            try {
                double spesa0 = double.Parse(spZona0.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
                double spesa1 = double.Parse(spZona1.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
                double spesa2 = double.Parse(spZona2.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
                double spesa3 = double.Parse(spZona3.Text, simplestecommerce.admin.localization.primarynumberformatinfo);
            } catch {
                lblerr.Text = "not allowed character";
                return;
            }

            simplestecommerce.admin.generale.updateSpZona(0, Convert.ToDouble(spZona0.Text, simplestecommerce.admin.localization.primarynumberformatinfo));
            simplestecommerce.admin.generale.updateSpZona(1, Convert.ToDouble(spZona1.Text, simplestecommerce.admin.localization.primarynumberformatinfo));
            simplestecommerce.admin.generale.updateSpZona(2, Convert.ToDouble(spZona2.Text, simplestecommerce.admin.localization.primarynumberformatinfo));
            simplestecommerce.admin.generale.updateSpZona (3, Convert.ToDouble(spZona3.Text,simplestecommerce.admin.localization.primarynumberformatinfo));

            lblerr.ForeColor = System.Drawing.Color.Blue;
            lblerr.Text = "data saved";
         
         
            bindSpSped();
        }




        void bindSpSped()
        {

            spZona0.Text = simplestecommerce.admin.generale.spZona(0).ToString();
            spZona1.Text = simplestecommerce.admin.generale.spZona(1).ToString();
            spZona2.Text = simplestecommerce.admin.generale.spZona(2).ToString();
            spZona3.Text = simplestecommerce.admin.generale.spZona(3).ToString();
        }

        void bindStati()
        {

            ds = simplestecommerce.admin.regioni.getRegioni();
                dGridReg.DataSource= ds.Tables["regioni"];
                dGridReg.DataBind();





         }


         void dGridReg_edit (object sender, DataGridCommandEventArgs e) {

            dGridReg.EditItemIndex = e.Item.ItemIndex;
            bindStati();

         }

         void dGridReg_delete (object sender, DataGridCommandEventArgs e) {

            int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

            simplestecommerce.admin.regioni.delRegione(id);
            bindStati();
        }

         void dGridReg_cancel (object sender, DataGridCommandEventArgs e) {

            dGridReg.EditItemIndex=-1;
            bindStati();
         }


        void dGridReg_update (object sender, DataGridCommandEventArgs e) {

            bool inputValido=true;
            if (  ((TextBox)e.Item.Cells[2].Controls[0]).Text.Length > simplestecommerce.common.maxLenRegione) { lblerr.Text+="<br>max length for Area is " + simplestecommerce.common.maxLenRegione + " chars"; inputValido=false; }

            if (!inputValido) return;

            int id =  Convert.ToInt32 (e.Item.Cells[1].Text);

            string nome =  ((TextBox)e.Item.Cells[2].Controls[0]).Text;
            int zona = int.Parse( ((DropDownList)(e.Item.Cells[3].Controls[1])).SelectedItem.Value  )  ;

            simplestecommerce.admin.regioni.updateRegione (id, nome, zona) ;

            dGridReg.EditItemIndex=-1;
         
         
         
            bindStati();
         }





         void Page_Load () {


          ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a>" +
" &raquo; transport costs per area";

                          
             if (!Page.IsPostBack)
             {
                 bindStati();
                 bindSpSped();
             }
         }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />

		
		
        <asp:panel ID="Panel1" runat="server"   GroupingText="transport costs per area" Width="100%" DefaultButton="buttAggSp">
	
        <table width="100%">
        <tr>
        <td>
        Transport cost for Area 0 <asp:textbox id="spZona0" runat=server class=input size=4/>&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
            <td>
            Transport cost for Area 1 <asp:textbox id="spZona1" runat=server class=input size=4/>&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
            <td>
                Transport cost for Area 2 <asp:textbox id="spZona2" runat=server class=input size=4/>&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
            <td>
                Transport cost for Area 3 <asp:textbox id="spZona3" runat=server class=input size=4/>&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
        </tr>

        <tr>
        <td colspan="4" align="center">
            <asp:button runat=server id="buttAggSp" class=bottone text="UPDATE TRANSPORT COSTS PER AREA" onclick="buttAggSp_click" />
        </td>
        </tr>
        </table>
	</asp:panel>
	
       <br>
       <br>
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

       <asp:datagrid  id="dGridReg" runat="server" width="100%" 
        cellspacing="1"
        gridlines="none"
        autogeneratecolumns="false" onDeleteCommand="dGridReg_delete" onCancelCommand="dGridReg_cancel" onUpdateCommand="dGridReg_update" onEditCommand="dGridReg_edit">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:boundcolumn datafield="r_id" readonly="true" HeaderText="<b>country ID</b>"  HeaderStyle-Width="15" ItemStyle-Width="15"/>
                <asp:boundcolumn datafield="r_nome" readonly="true" HeaderText="<b>country</b>" />
                <asp:templatecolumn  HeaderText="<b>area</b>" >
                    <itemtemplate>
                        
                        <asp:dropdownlist id="dDListZona" runat="server" 
                            SelectedIndex='<%# Convert.ToInt32( (DataBinder.Eval(Container.DataItem, "r_zona")) ) %>'
                             OnSelectedIndexChanged="changeTendina"
                             AutoPostBack="true"
                             >
                            <asp:ListItem Value="0">0</asp:ListItem>
                            <asp:ListItem Value="1">1</asp:ListItem>
                            <asp:ListItem Value="2">2</asp:ListItem>
                            <asp:ListItem Value="3">3</asp:ListItem>
                        </asp:dropdownlist>
                    </itemtemplate>
                    <edititemtemplate>
      
                    </edititemtemplate>
                </asp:templatecolumn>

                <asp:buttoncolumn Visible="false" HeaderText="<b>delete</b>" Text="<center><img src=immagini/delete.gif Border=0 ></center>" CommandName="Delete" />

            </Columns>
        </asp:datagrid>


</ContentTemplate>
</asp:UpdatePanel>
</form>
</asp:content>