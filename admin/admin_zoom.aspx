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
<script runat="server">

    int idArt;
    string nomeFile;






    void bindGrids () {

        dGrid.DataSource = simplestecommerce.zoom.getIngrandimenti(idArt);
        dGrid.DataBind();

    }



    void buttNewZoom_click (object sender, EventArgs e) {
   
        string excp0 = "";
        bool inputValido = true;

        string width = "";
        string height = "";

        if (tBoxWidth.Text != "")
        {
            try
            {
                int workWidth = int.Parse(tBoxWidth.Text);
            }
            catch
            {
                lblerr.Text += "<br>Larghezza deve essere un numero";
                inputValido = false;
            }
        }
        if (tBoxHeight.Text != "")
        {
            try
            {
                int workHeight = int.Parse(tBoxHeight.Text);
            }
            catch
            {
                lblerr.Text += "<br>Altezza deve essere un numero";
                inputValido = false;
            }
        }
        
        if (!inputValido) return;

        width = tBoxWidth.Text;
        height = tBoxHeight.Text;        
        
        // ricava quale numero foto
        int quale = simplestecommerce.zoom.lastQuale(idArt) + 1 ;
        
        
        // ricava il nomefile
        if (fileImg0.PostedFile.FileName == "")
        {
            lblerr.Text += "<br>Type path of the file";
            return;
        }
        else
        {
            int punto = fileImg0.PostedFile.FileName.LastIndexOf(".");
            string estensione = fileImg0.PostedFile.FileName.Remove(0, punto + 1);
            nomeFile = (string)Application["upload"] + "/zoom" + idArt.ToString() + "quale" + quale + "." + estensione;
            string percorsoFile;
            percorsoFile = Server.MapPath(nomeFile);

            simplestecommerce.zoom.insert (idArt, nomeFile, quale, width, height);


            // esegue l'upload
            try
            {
                fileImg0.PostedFile.SaveAs(percorsoFile);
            }
            catch (Exception exc)
            {
                excp0 = exc.ToString();
            }

            if (excp0.ToString() != "") lblerr.Text = "<center><br>Problem in uploading the image on the server:<br>" + excp0 + "</center>";

        }
            
        bind();
    }


    void dGrid_edit (object sender, DataGridCommandEventArgs e) {

        dGrid.EditItemIndex = e.Item.ItemIndex;

        bindGrids();

    }


    void dGrid_cancel (object sender, DataGridCommandEventArgs e) {

            dGrid.EditItemIndex=-1;
            bindGrids();
    }

    void dGrid_update (object sender, DataGridCommandEventArgs e) {

            bool inputValido = true;

            if (((TextBox)e.Item.Cells[4].Controls[0]).Text != "")
            {
                try { int workWidth = int.Parse(((TextBox)e.Item.Cells[4].Controls[0]).Text); }
                catch
                {
                    lblerr.Text += "<br>Larghezza deve essere un numero";
                    inputValido = false;
                }
            }

            if (((TextBox)e.Item.Cells[5].Controls[0]).Text != "")
            {
                try { int workHeight = int.Parse(((TextBox)e.Item.Cells[5].Controls[0]).Text); }
                catch
                {
                    lblerr.Text += "<br>Altezza deve essere un numero";
                    inputValido = false;
                }
            }
            if (!inputValido) return;
        
            int id = int.Parse(e.Item.Cells[1].Text);

            string width =  ((TextBox)e.Item.Cells[4].Controls[0]).Text ;
            string height = ((TextBox)e.Item.Cells[5].Controls[0]).Text;
        
            simplestecommerce.zoom.update (id, width, height);

            dGrid.EditItemIndex=-1;
            bindGrids();

    }

    void dGrid_delete (object sender, DataGridCommandEventArgs e) {
            int id =  int.Parse ( e.Item.Cells[1].Text )  ;
            simplestecommerce.zoom.delete (id);

            dGrid.EditItemIndex=-1;
            bindGrids();

    }




    void bind() {

        bindGrids();
    }






    void Page_Load() {


        
        
        idArt = Convert.ToInt32 (Request.QueryString["idArt"]);


        if (!Page.IsPostBack) {
         ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a>" +
" &raquo; " +
"<a href='admin_articoli.aspx'>products</a>" +
" &raquo;" +
"<a href='admin_articolo.aspx?idArt=" + idArt.ToString() + "'>product ID " + idArt.ToString() + "</a>"+
" &raquo; " +
"photo enlargements";
         
         

          bind();

 
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />



 <fieldset>
  <legend>new zoom</legend>

    <table>
    <tr>
    <td>
    <input class=inputsmall style="width:100%" size=80 runat=server type="file" id="fileImg0">
    </td>
    <td>
    <asp:button cssclass=bottone onClick="buttNewZoom_click" id="buttNewZoom" Text="add zoom" runat="server" />            
    </td>
    </tr>
    </table>
 </fieldset>
                

        <!--
        <tr class="admin_sfondo">
            <td>Ridimensiona larghezza:</td>
            <td>
                <asp:TextBox runat=server ID="tBoxWidth" CssClass=input />
            </td>
        </tr>
        <tr class="admin_sfondo">
            <td>Ridimensiona altezza:</td>
            <td>
                <asp:TextBox runat=server ID="tBoxHeight" CssClass=input />
            </td>
        </tr>
        -->



    <br>
    <br>
    <br>
    <asp:datagrid GridLines="None" CellSpacing="1"
    onDeleteCommand="dGrid_delete" 
    onCancelCommand="dGrid_cancel" 
    onUpdateCommand="dGrid_update" 
    onEditCommand="dGrid_edit" 
    cellpadding=4 id="dGrid" runat="server" width="100%" autogeneratecolumns="false">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <Columns>
                <asp:EditCommandColumn CancelText="annulla modifiche" UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" />
                <asp:boundcolumn readonly="true" datafield="z_id" HeaderText="<b>IDPhoto</b>" />
                <asp:TemplateColumn HeaderText="<b>photo</b>">
                    <ItemTemplate >
                        <div align=center>
                            <asp:Image 
                            runat=server 
                            width=30 
                            ImageUrl=<%#DataBinder.Eval (Container.DataItem,"z_percorso") %> 
                            visible = <%#DataBinder.Eval (Container.DataItem,"z_percorso").ToString()==""? false:true %> 
                            />
                            <br />
                            <%#Eval("z_percorso").ToString()%>
                        </div>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:boundcolumn visible=false readonly="false" datafield="z_width" HeaderText="<b>larghezza</b>" />
                <asp:boundcolumn visible=false readonly="false" datafield="z_height" HeaderText="<b>altezza</b>" />
                <asp:buttoncolumn HeaderText="<b>delete photo</b>" Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />
            </Columns>
    </asp:datagrid>


</form>
</asp:Content>