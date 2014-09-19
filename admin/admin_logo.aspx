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
<%@ import Namespace="System.Drawing" %>


<script runat="server">

    void bindFields() {


    }

    string img0Fisical()
    {

        return Server.MapPath((string)Application["upload"] + "/logo.jpg") ;
    }


    void buttAggiorna_click (object sender, EventArgs e) {

        if (((bool)simplestecommerce.config.getCampoByApplication("config_demo")))
        {
            lblErr.Text = "Function disabled on demo";
            return;
        }                
        
        
        bool errore = false;
        
        try
        {
            fileImg0.PostedFile.SaveAs(img0Fisical());
        }
        catch (Exception exc)
        {
            lblErr.Text = exc.ToString();
            errore = true;

        }

        if (!errore)
        {
            lblErr.Text = "Logo has been uploaded correctly";
            lblErr.ForeColor = System.Drawing.Color.Blue;

        }
    }

    void Page_Load() {
     ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; logo";

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
<ajaxToolkit:ToolkitScriptManager  ID="ScriptManager1" runat="server"  EnablePartialRendering="true"/> 
<br /><asp:label id="Label1" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />



<table width="100%" cellspacing=1  >


 <tr class=admin_sfondo>
 <td  width=300>Logo: </td>
 <td >
    <input class=input size=80 runat="server" type="file" id="fileImg0">
 </td>
 </tr>



</table>


<div align=right style="padding-right:18px">
    <br><asp:button onClick="buttAggiorna_click" id="buttAggiorna" runat="server" text="UPDATE" class=bottone />
</div>

<div align=center><br /><br /><asp:label enableviewstate="false" id="lblErr" forecolor="red" runat="server"/></div>





</form></asp:content>