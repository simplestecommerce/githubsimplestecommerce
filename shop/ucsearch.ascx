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

<%@ Control Language="c#" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="simplestecommerce" %>
<script runat="server">

    bool flag = false;


    public void buttCerca_click(object sender,  EventArgs e)
    {

        Response.Redirect("~/shop/articolipertermine.aspx?termine=" + Server.UrlEncode(tBoxSearch.Text));

    }
    
    
    void bind() {
        tBoxSearch.DataBind();
        buttCerca.DataBind();




    }


    void Page_Init () {

        
    }

    void Page_Load() {

        if (!Page.IsPostBack) bind();

    }

</script>



<table cellspacing="0" cellpadding="0" width="100%" style="margin-top:2px">
 <tr>
  <td class="box" width="100%">
   <div align="left" class="titoliboxsx"><%=simplestecommerce.lingua.getforfrontendbypseudo("allpages.searchbox.boxtitle") %></div>
  </td>
 </tr>
</table>



    <div class=contenutobox style="margin-top:2px" >
       

                <asp:Panel ID="Panel1" runat=server  DefaultButton="buttCerca"  style="padding-top:3px">
                <div align=center style="padding:10px">
                <table cellpadding=0 cellspacing=0>
                <tr>
                <td valign=middle>
                <asp:TextBox  
                EnableViewState="true" ViewStateMode="Enabled"
                onFocus="this.value=''"
                autocomplete="off"
                id="tBoxSearch"
                width="122"
                runat="server"
                cssclass="form"
                    style="font-size:10px"
                text=<%#lingua.getforfrontendbypseudo("allpages.searchbox.type.word.to.search")%>
                /><ajaxToolkit:AutoCompleteExtender ID="autoComp1" runat="server" MinimumPrefixLength="3"  ServiceMethod="GetCountryInfo" ServicePath="WebService.asmx" TargetControlID="tBoxSearch"/>
                </td>
                    <td width="2">&nbsp;</td>
                <td valign=middle><asp:button  
                id="buttCerca"  
                ToolTip="Start search" 
                ImageUrl="~/immagini/vai.png" 
                onClick="buttCerca_click" 
                class=form style="width:35px; font-size:11px; background-color:#aaaaaa; border: solid 1px #888"
                runat="server"
                text=<%#lingua.getforfrontendbypseudo("allpages.searchbox.button.go")%>
                                 EnableViewState="true" ViewStateMode="Enabled"

                />
                </td>
                
                </tr>
                </table>
                </div>
                </asp:Panel>  


</div>
