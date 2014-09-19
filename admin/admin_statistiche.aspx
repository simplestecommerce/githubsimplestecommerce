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

    int pageIn;
    int quantiPerPag=20;
    string ord;
    string view;





    void bindPagerVisite () {

        int tot;
        
        if (view=="referrer")                     
            
                tot= simplestecommerce.statistiche.quantiReferrer() ;
                
                else tot= simplestecommerce.statistiche.quanteVisiteInElenco() ;
                if (tot>0) {

                    int restoZeroUno = (tot%quantiPerPag>0) ? 1 : 0;
                    lblPaging.Text="";

                    for (int a=1; a<=  (restoZeroUno + Math.Floor ((double)tot/quantiPerPag)); a++) {
                        if (pageIn==a){
                            lblPaging.Text += "<b>" + Convert.ToString(a) + "</b>&nbsp;";
                        }
                        else
                        {
                            lblPaging.Text += simplestecommerce.common.linkescaped (Convert.ToString(a),"admin_statistiche.aspx?page=" + a + "&view=" + view) + "&nbsp;" ;
                        }
                    }
                }

                lblPagingTop.Text = lblPaging.Text;
    }


    void bindGridVisite() {


        
        dGridVisite.DataSource =  simplestecommerce.statistiche.getElencoVisite(pageIn, quantiPerPag, ord);
        dGridVisite.DataBind();

    }


    void bindGridReferrer()
    {

        dGridVisite.DataSource = simplestecommerce.statistiche.getElencoReferrer(pageIn, quantiPerPag, ord);
        dGridVisite.DataBind();

    }



    void dGridVisiteAggr_PageIndexChanged(object source, DataGridPageChangedEventArgs e) {

        dGridVisiteAggr.CurrentPageIndex = e.NewPageIndex;
        dGridVisiteAggr.DataBind();
    }



    void bindGridVisiteAggr() {


        dGridVisiteAggr.DataSource =  simplestecommerce.statistiche.getElencoVisiteAggr ();
        dGridVisiteAggr.AllowPaging = true;
        dGridVisiteAggr.PagerStyle.Mode = PagerMode.NumericPages;
        dGridVisiteAggr.PagerStyle.PageButtonCount = 5;
        dGridVisiteAggr.PageSize = quantiPerPag;


        dGridVisiteAggr.DataBind();

    }


    void bindMenu() {

        selectMenu.Items.Add (new ListItem ("Elenco Visite per orario", "visite"));
        selectMenu.Items.Add (new ListItem ("Elenco Visite per IP", "visiteIp"));
        selectMenu.Items.Add (new ListItem ("Visite aggregate", "visiteAggr"));
        selectMenu.Items.Add(new ListItem("Elenco indirizzi di provenienza", "referrer"));
        selectMenu.Attributes["onChange"] = "location.href='admin_statistiche.aspx?view='+this.options[selectedIndex].value";

        foreach (ListItem li in selectMenu.Items) {

            if (li.Value == view) li.Selected=true;
        }


    }

    void Page_Init () {

        
        
        try { pageIn = int.Parse ( Request.QueryString["page"] ) ; }
        catch { pageIn=1; }


        view = Request.QueryString["view"];
    }


    void Page_Load() {


        switch (view) {

            case "visiteIp":
                ord = "ip";
                pHolderElencoVisite.Visible=true;
                bindGridVisite();
                bindPagerVisite();
                break;


            case "referrer":
                ord = "ip";
                pHolderElencoVisite.Visible = true;
                bindGridReferrer();
                bindPagerVisite();
                break;


            case "visiteAggr":
                pHolderVisiteAggr.Visible=true;
                bindGridVisiteAggr();
                break;

                
                
                
            default:
                ord = "orario";
                pHolderElencoVisite.Visible=true;
                bindGridVisite();
                bindPagerVisite();
                break;

        }


       bindMenu();

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />


    &nbsp;&nbsp;Seleziona visualizzazione: <select id="selectMenu" enableviewstate=false runat="server" class=input/>
    <br>
    <asp:placeholder visible=FALSE id="pHolderElencoVisite" runat="server" enableviewstate="false">
       <div align=right>
            <br><br>
            <asp:label id="lblPagingTop" runat="server" />&nbsp;&nbsp;
            <br>
       </div>
       <asp:datagrid border=1 bordercolor=#000000 align=center cellpadding=4 id="dGridVisite" runat="server" width="99%" autogeneratecolumns="false"  enableviewstate="false">
            <headerStyle cssClass=admin_sfondodark/>
            <ItemStyle cssClass="admin_sfondo"/>
            <alternatingItemStyle cssClass=admin_sfondobis/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:boundcolumn datafield="v_timestamp" readonly="false" HeaderText="<b>data</b>" />
                <asp:boundcolumn datafield="v_ip" readonly="false" HeaderText="<b>ip</b>" />
                <asp:templatecolumn  HeaderText="<b>pagina</b>" >
                    <itemtemplate>
                        <asp:hyperlink enableviewstate="false" id="hLinkPagina" Text=<%#DataBinder.Eval (Container.DataItem, "v_pagina")%> navigateurl=<%#DataBinder.Eval (Container.DataItem, "v_pagina")%>  target="_blank" runat="server" />
                    </itemtemplate>
                </asp:templatecolumn>


                <asp:templatecolumn  HeaderText="<b>referrer</b>" >
                    <itemtemplate>
                        <asp:hyperlink enableviewstate="false" id="hLinkReferrer" Text=<%#DataBinder.Eval (Container.DataItem, "v_referrer")%> navigateurl=<%#DataBinder.Eval (Container.DataItem, "v_referrer")%>  target="_blank" runat="server" />
                    </itemtemplate>
                </asp:templatecolumn>

            </Columns>
        </asp:datagrid>
        <div align=right>
            <br>
            <asp:label id="lblPaging" runat="server" />&nbsp;&nbsp;
            <br><br>
        </div>
        </asp:placeholder>











		<br />
    <asp:placeholder visible=FALSE  id="pHolderVisiteAggr" runat="server" enableviewstate="false">
       <asp:datagrid border=1 bordercolor="#000000"  align=center cellpadding=4 id="dGridVisiteAggr" onPageIndexChanged="dGridVisiteAggr_PageIndexChanged" runat="server" width="99%" autogeneratecolumns="false"  enableviewstate="false">
            <headerStyle cssClass=admin_sfondobis/>
            <ItemStyle cssClass="admin_sfondo"/>
            <EditItemStyle cssClass="small"/>
            <Columns>
                <asp:templatecolumn  HeaderText="<b>pagina</b>" >
                    <itemtemplate>
                        <asp:hyperlink enableviewstate="false" id="hLinkPagina" Text=<%#DataBinder.Eval (Container.DataItem, "v_pagina")%> navigateurl=<%#DataBinder.Eval (Container.DataItem, "v_pagina")%>  target="_blank" runat="server" />
                    </itemtemplate>
                </asp:templatecolumn>

                <asp:boundcolumn datafield="quanti" readonly="false" HeaderText="<b>N. Visite</b>" />
            </Columns>
        </asp:datagrid>
     </asp:placeholder>











</form></asp:content>