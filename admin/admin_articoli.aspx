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

    protected int artPerPag;
    string tipoIn;
    string termineIn;
    int repIn;
    int ordinamentoIn;
    string modeIn;
    int invisibile;
    int inOfferta;
    int inEvidenza;
    int inVetrina;
    int disp;
    int quantiArt;


    void selAll(object s, EventArgs e)
    {

        foreach (DataGridItem i in dGridArt.Items)
        {

            CheckBox c = (CheckBox)(i.FindControl("cBoxSel"));
            c.Checked = true;

        }


    }

    void unselAll(object s, EventArgs e)
    {

        foreach (DataGridItem i in dGridArt.Items)
        {

            CheckBox c = (CheckBox)(i.FindControl("cBoxSel"));
            c.Checked = false;

        }


    }
    
    private void void_cancella(Object Sender, EventArgs e)
    {

        if (((bool)simplestecommerce.config.getCampoByApplication("config_demo")))
        {
            lblErrore.Text = "Function disabled on demo";
            return;
        }                
        
        
        for (int rip = 0; rip < dGridArt.Items.Count; rip++)
        {
            CheckBox c = (CheckBox)dGridArt.Items[rip].Cells[7].Controls[1];
            int id = int.Parse(dGridArt.Items[rip].Cells[2].Text);
            
            //Response.Write(id + c.Checked.ToString());
            
            if (c.Checked)
            {


                
                
                simplestecommerce.admin.generale.deleteArticolo(id);
            }

        }
        dGridArt.CurrentPageIndex = 0;

        bindData();

    }


    void prepare()
    {

        ArrayList arrRep = simplestecommerce.admin.categorie.GetCategoriesTree(null,null,-1);
           dDListRep.Items.Add ( new ListItem ("any categories", "-1" ) );
           foreach (simplestecommerce.admin.Category cat in arrRep) {
               dDListRep.Items.Add ( new ListItem (cat.Name, cat.Id.ToString()) ) ;
           }

           // crea dropdownlist disponibilita

           dListDisp.Items.Add(new ListItem("any", "-1"));

           
           
           for (int rip = 0; rip <= simplestecommerce.common.arrPseudoDisponibilita.Length - 1; rip++)
           {
               dListDisp.Items.Add(new ListItem(simplestecommerce.lingua.getinadminlanguagefromdb(simplestecommerce.common.arrPseudoDisponibilita[rip]), rip.ToString()));
                  
           }

           foreach (ListItem li in dListDisp.Items)
           {
               li.Selected = false;
           }

        
           for (int rip = 1; rip<=200; rip++)
           {
               ListItem li = new ListItem(rip.ToString(), rip.ToString());
               if (rip == 20) li.Selected = true;
               dListArtPerPag.Items.Add(li);
           }

                   

           
       }

    private void item_Created(Object Sender, DataGridItemEventArgs e) {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
                ImageButton myButton = (ImageButton)e.Item.FindControl("lButtDelete");
                myButton.Attributes.Add("onclick", "return confirm_delete();");
        }

    }


    void buttFiltra_click (object sender, EventArgs e) {
        
        dGridArt.CurrentPageIndex = 0;
        bindData();
    }




    void bindData () {

        modeIn = (string)Request.QueryString["mode"];
        tipoIn = dDLTipoFiltro.SelectedValue;
        termineIn = tBoxSearch.Text;
        repIn = int.Parse(dDListRep.SelectedValue);
        ordinamentoIn = int.Parse(dDLOrdinamento.SelectedValue);
        inOfferta = cBoxOfferta.Checked ? 1 : 0;
        inEvidenza = 0; //  cBoxEvidenza.Checked ? 1 : 0;
        inVetrina = 0; //  cBoxVetrina.Checked ? 1 : 0;
        invisibile = cBoxInvisibile.Checked ? 1 : 0;
        disp = int.Parse(dListDisp.SelectedValue);

        /*
        Response.Write("mode=" + modeIn +
            "<br>tipo=" + tipoIn +
            "<br>termine=" + termineIn +
            "<br>rep=" + repIn +
            "<br>ordinamento=" + ordinamentoIn +
            "<br>inofferta=" + inOfferta +
            "<br>evid=" + inEvidenza +
            "<br>invetr=" + inVetrina +
            "<br>invis=" + invisibile +
            "<br>disp=" + disp
            );
            Response.Write ("<br>TOT:" + (simplestecommerce.admin.generale.getArticoli(tipoIn, termineIn, repIn, ordinamentoIn, modeIn, inOfferta, inVetrina, inEvidenza, invisibile, disp).Tables[0].Rows.Count));
            Response.End();
            */


        DataTable dtRicerca = simplestecommerce.admin.generale.getArticoli(tipoIn, termineIn, repIn, ordinamentoIn, modeIn, inOfferta, inVetrina, inEvidenza, invisibile, disp).Tables[0];
        int quanti = dtRicerca.Rows.Count;

        
        dGridArt.DataSource = dtRicerca;
        dGridArt.DataBind();

    }

    void dGridArt_itemCommand (object sender, DataGridCommandEventArgs e) {

        int idArt;

        switch (e.CommandName) {

            case "edit":
                   idArt =  int.Parse ( e.Item.Cells[2].Text )  ;
                Response.Redirect ("admin_articolo.aspx?idArt=" + idArt);
            break;


            case "delete":
                   idArt =  int.Parse ( e.Item.Cells[2].Text )  ;
                   
                if ( ((bool)simplestecommerce.config.getCampoByApplication("config_demo"))) 
                   {
                       lblErrore.Text = "Function disabled on demo";
                       return;
                   }                
                
                simplestecommerce.admin.generale.deleteArticolo (idArt);
                bindData();
                break;
        }

    }




      void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
      {
         dGridArt.CurrentPageIndex = e.NewPageIndex;

         bindData();

      }


    void Page_Init () {
    
    }





    void Page_Load () {

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>Administration menu</a> &raquo; Products"; 
        
        
        if (!Page.IsPostBack) {

            prepare();
            bindData();
            quantiArt = dGridArt.Items.Count;
        }
    }

</script>




<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
                <script>
                    function confirm_delete() {
                        if (confirm("Confirm?") == true)
                            return true;
                        else
                            return false;
                    }

</script>
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">








    <form runat="server">


    <ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 


       <br>
        <fieldset>
            <legend>Filter products</legend>

       <table width="100%" cellpadding=7 cellspacing=1 style="">
       <tr >
       <td>
       &nbsp;Search in:
       <asp:dropdownlist id="dDListRep" runat=server class=input />
       &nbsp;Term:
       <asp:textbox id="tBoxSearch" runat="server" enableviewstate=false cssclass=input />
       &nbsp;
       <asp:dropdownlist id="dDLTipoFiltro" runat=server class=inputbianco>
           <asp:listitem value="codice">in product code</asp:listitem>
           <asp:listitem value="nome">in product name</asp:listitem>
       </asp:dropdownlist>
       &nbsp;
       Order by: 
       <asp:DropDownList ID="dDLOrdinamento" runat=server class=input>
        <asp:ListItem value="0">ID product</asp:ListItem>
        <asp:ListItem value="1">Name</asp:ListItem>
       </asp:DropDownList>
       &nbsp;<asp:button id="buttFiltra" runat=server text="FILTER" class=input onclick="buttFiltra_click"/>
        <br />
        &nbsp;|&nbsp;
        Featured products<asp:CheckBox runat=server ID="cBoxOfferta" />
        &nbsp;|&nbsp;
        Invisible products<asp:CheckBox runat=server ID="cBoxInvisibile" />        
        &nbsp;|&nbsp;
        Availability&nbsp;<asp:DropDownList CssClass=input runat=server ID="dListDisp" />
                &nbsp;|&nbsp;
        Show <asp:DropDownList runat=server ID="dListArtPerPag" cssClass=input /> results per page
       </td>
       </tr>
       </table>
        </fieldset>
       <br>

       <br>



       <center><asp:label enableviewstate="false" id="lblErrore" forecolor="red" runat="server" style="font-size:18px"/></center>

        <fieldset>
            <legend>Products List</legend>


        <asp:datagrid
        GridLines="None"
        AllowPaging="true"
        PagerStyle-Mode="NumericPages"
        pagesize=<%# int.Parse(dListArtPerPag.SelectedValue)%>
        OnPageIndexChanged="Grid_Change"
        OnItemCommand="dGridArt_itemCommand"
        cellpadding=2
        cellspacing="1"
        id="dGridArt"
        runat="server"
        width="100%"
        autogeneratecolumns="false"
        OnItemCreated="item_Created"
         EnableViewState=true
        >
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <Columns>
                <asp:templatecolumn>
                    <HeaderTemplate ><b>modify</b></HeaderTemplate>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle width=40>
                    </ItemStyle>
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                       <asp:imagebutton commandname="edit" runat="server" ImageUrl="~/immagini/edit.gif" /> 
                    </ItemTemplate>
                </asp:templatecolumn>

                <asp:templatecolumn>
                    <HeaderTemplate><b>delete</b></HeaderTemplate>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemStyle width=40>
                    </ItemStyle>
                    <ItemTemplate>
                        <asp:imagebutton id="lButtDelete" commandname="delete" runat="server"   ImageUrl="~/immagini/delete.gif"   />
                    </ItemTemplate>
                </asp:templatecolumn>



                <asp:boundcolumn datafield="art_id" HeaderText="<b>IDproduct</b>"  HeaderStyle-HorizontalAlign="Center"/>
                <asp:boundcolumn datafield="art_cod" HeaderText="<b>art.code</b>" HeaderStyle-HorizontalAlign="Center"/>
                <asp:templatecolumn>
                    <HeaderStyle HorizontalAlign="Center" Height="28" />
                     <ItemStyle Width="410" />
                        <HeaderTemplate><b>Name</b></HeaderTemplate>
                        <ItemTemplate>
                        <asp:Label runat="server" Text=<%#simplestecommerce.lingua.getinadminlanguagefromdb(Eval("art_nome").ToString()) %> />
                    </ItemTemplate>
                </asp:templatecolumn> 
                <asp:boundcolumn datafield="art_stock" HeaderText="<b>stock</b>" ItemStyle-Width="30" HeaderStyle-HorizontalAlign="Center" itemstyle-HorizontalAlign="right"/>
                <asp:boundcolumn datafield="art_timestamp" HeaderText="<b>creation date</b>" ItemStyle-Width="130" HeaderStyle-HorizontalAlign="Center" itemstyle-HorizontalAlign="right"/>
                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <HeaderTemplate><b>select</b></HeaderTemplate>
                    <ItemStyle Width="45"  HorizontalAlign="Center"/>
                    <ItemTemplate>
                        <asp:CheckBox runat=server ID="cBoxSel" cssClass=input />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <HeaderTemplate><b>image</b></HeaderTemplate>
                    <ItemStyle Width="45" />
                    <ItemTemplate>
                        <center><asp:image runat="server" id="img" width="30" height="30" alt="" ImageUrl=<%#Eval("art_imgpreview").ToString()==""? "~/immagini/non_disponibile.gif": Eval("art_imgpreview") %> /></center>
                    </ItemTemplate>
                </asp:TemplateColumn>


            </Columns>
        </asp:datagrid>
                </fieldset>


        <div align=right style="padding-right:18px">
        <br />
        <input class=bottone type="submit" onclick="window.location.href='admin_articolo.aspx'; return false;" value="ADD PRODUCT" />
        </div>
        
        <div>
            <asp:button runat=server text="select all" cssclass=bottone onclick="selAll"    />
            <asp:button runat=server text="unselect all" cssclass=bottone onclick="unselAll"  />
            <asp:Button runat=server Text="delete selected" CssClass=bottone onclick="void_cancella" />
        </div>






</form>
</asp:Content>