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
    int id = 0;
    int position;
    string etichetta;
    void bindFields()
    {


    }

    void listaBannerCommand(object o, DataGridCommandEventArgs e)
    {

        if (e.CommandName == "edita")
        {

            Response.Redirect("admin_banner.aspx?position=" + position.ToString() + "&id=" + e.CommandArgument.ToString());

        }
        else if (e.CommandName == "elimina")
        {

         SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);

         cnn.Open();


         {
          SqlCommand cmd = new SqlCommand("select img from tbanner where id=@id", cnn);
          cmd.Parameters.AddWithValue("id", e.CommandArgument.ToString());
          string img = cmd.ExecuteScalar().ToString();
          try { System.IO.File.Delete(Server.MapPath(img)); }
          catch { };
         }
         
         
         {
          SqlCommand cmd = new SqlCommand("delete from tbanner where id=@id", cnn);
          cmd.Parameters.AddWithValue("id", e.CommandArgument.ToString());
          cmd.ExecuteNonQuery();
         }
         cnn.Close();



         Response.Redirect("admin_banner.aspx?position=" + position.ToString());

        }



    }
    void buttNewBanner_click(object sender, EventArgs e)
    {

        Response.Redirect("admin_banner.aspx?position=" + position.ToString());
    }
    void buttAggiorna_click(object sender, EventArgs e)
    {


            if (fileImg0.PostedFile.FileName == "")
            {

             lblNoBanner.Text = "no selected file";
                return;

            }
            else
            {
                SqlConnection cnn = new SqlConnection((string)HttpContext.Current.Application["strcnn"]);
                int newId = 0;
                {
                    cnn.Open();

                    SqlCommand cmd = new SqlCommand("select max(id) from tbanner", cnn);
                    object objmaxid = cmd.ExecuteScalar();
                    int maxid = 0;
                    if (objmaxid != System.DBNull.Value) maxid = Convert.ToInt32(objmaxid);
                    cnn.Close();
                    newId = maxid + 1;

                    cnn.Close();

                }

                int punto = fileImg0.PostedFile.FileName.LastIndexOf(".");
                string estensione = fileImg0.PostedFile.FileName.Remove(0, punto + 1);
                string nomeFile = (string)Application["upload"] + "/autonamebanner" + newId.ToString() +  etichetta + "." + estensione;
                string percorsoFile = Server.MapPath(nomeFile);

                bool errore = false;
                try { 
                System.IO.File.Delete(Server.MapPath(nomeFile));
                 }
                catch { }
             
                try
                {
                    fileImg0.PostedFile.SaveAs(percorsoFile);
                }
                catch (Exception exc)
                {
                    lblerr.Text = exc.ToString();
                    errore = true;
                    
                }

                if (!errore)
                {

                    cnn.Open();

                    SqlCommand cmd = new SqlCommand("insert into tbanner (img, link, position) VALUES (@img, @link, @position)", cnn);
                    cmd.Parameters.AddWithValue("img", nomeFile);
                    cmd.Parameters.AddWithValue("link", TBOXlink.Text);
                    cmd.Parameters.AddWithValue("position", position);

                    cmd.ExecuteNonQuery();
                    cnn.Close();
                    Response.Redirect("admin_banner.aspx?position=" + position.ToString());


                }
            }
        



        Response.Redirect("admin_banner.aspx?position=" + position.ToString());



    }

    void bind()
    {

        listaBanner.DataSource = simplestecommerce.helpDb.getDataTable("select * from tbanner where position=" + position.ToString());
        listaBanner.DataBind();


    }

    void Page_Load()
    {


        if (Request.QueryString["position"] == null) Response.Redirect("admin_menu.aspx");
        position = int.Parse(Request.QueryString["position"].ToString());
        if (position == 0) etichetta = "left";
        else etichetta = "right";

        if (Request.QueryString["id"] == null)
        {
            panelBanner.GroupingText = "new banner";

        }
        PHOLDERnewBanner.DataBind();

        if (!Page.IsPostBack)
        {
         ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>administration menu</a> &raquo; ";
         if (position == 0) ((Label)Master.FindControl("lbldove")).Text += "left";
         else ((Label)Master.FindControl("lbldove")).Text += "right";
         ((Label)Master.FindControl("lbldove")).Text += " banners";
         
            bind();
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
  <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />


      <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" />

        <asp:Panel ID="panelBanner" runat="server" Style="width: 100%">
            <table cellpadding="1" cellspacing="0" style="" width="100%" border="0">
                <tr>
                    <td nowrap>seleziona da hard-disk</td>
                    <td>
                        <input class="inputsmall" style="width: 300px" runat="server" type="file" id="fileImg0">
                                             <asp:Label runat="server" ID="lblpath" />

                    </td>
                </tr>
                <tr>
                    <td>link</td>
                    <td>
                        <asp:TextBox runat="server" ID="TBOXlink" Style="width: 600px" Text="http://" />
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <asp:Label runat="server" ID="lblNoBanner" ForeColor="red" />
                    </td>
                </tr>


            </table>

            <div align="right" style="padding-right: 18px">
                <br>
                <asp:Button OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" Text="SALVA" class="bottone" /><asp:PlaceHolder ID="PHOLDERnewBanner" runat="server" Visible='<%#Request.QueryString["id"]!=null %>'>&nbsp;oppure&nbsp;<asp:Button OnClick="buttNewBanner_click" runat="server" Text="CREA UN ALTRO BANNER" class="bottone" /></asp:PlaceHolder>
            </div>

        </asp:Panel>

  <br /><br />

        <asp:DataGrid runat="server" ID="listaBanner" AutoGenerateColumns="false" Width="100%" OnItemCommand="listaBannerCommand"
         gridlines="None" CellSpacing="1"
         >
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <AlternatingItemStyle CssClass="admin_sfondobis" />
            <Columns>
                <asp:BoundColumn HeaderText="id" DataField="id"></asp:BoundColumn>
                <asp:TemplateColumn HeaderText="<b>delete</b>">
                 <HeaderStyle Width="20" />
                    <ItemTemplate>
                        <asp:ImageButton ImageUrl="../immagini/delete.gif" runat="server" CommandName="elimina" CommandArgument='<%#Eval("id").ToString() %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="<b>image</b>">
                 <ItemStyle Width="84" />
                    <ItemTemplate>
                        <asp:Image runat="server" ImageUrl='<%#Page.ResolveUrl( Eval("img").ToString()) %>' Width="80" Height="80" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="<b>link</b>" DataField="link"></asp:BoundColumn>
                <asp:TemplateColumn HeaderText="<b>path on server</b>">
                    <ItemTemplate>
                        <asp:label runat="server" text='<%#Page.ResolveUrl( Eval("img").ToString()) %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>

            </Columns>

        </asp:DataGrid>



    </form>
 </asp:content>
 
