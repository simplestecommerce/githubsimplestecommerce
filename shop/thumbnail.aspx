<%@ Page Language="C#" %>
<%@ import Namespace="System.Drawing" %>
<%@ import Namespace="System.Drawing.Imaging" %>
<%@ import Namespace="System.Text.RegularExpressions" %>
<script runat="server">

    void Page_Load(Object sender, EventArgs e) {

            int MaxWidth = 0; // Larghezza massima dopo il quale l'immagine viene ridimensionata
            int MaxHeight = 0;  // Altezza massima dopo il quale l'immagine viene ridimensionata
            int ScaleFactor = 100; // Fattore di scala per la miniatura
            System.Drawing.Image oldImage, newImage;


                if(Request.QueryString["w"]!=null)
                    if(Request.QueryString["w"].Length>0)
                        MaxWidth = Convert.ToInt32(Request.QueryString["w"]);
                if(Request.QueryString["h"]!=null)
                    if(Request.QueryString["h"].Length>0)
                        MaxHeight = Convert.ToInt32(Request.QueryString["h"]);


                if ( Request.QueryString["FileName"] != null ) {
                    string strFileName = Convert.ToString(Request.QueryString["FileName"]);
    //			if ( Request.QueryString["ScaleFactor"] != null && Convert.ToString(Request.QueryString["ScaleFactor"]) != "" && IsInteger(Convert.ToString(Request.QueryString["scalefactor"])) ) ScaleFactor = Convert.ToInt32(Request.QueryString["ScaleFactor"]);
                    if ( strFileName != "" ) {
                        try {
                            oldImage = System.Drawing.Image.FromFile( Server.MapPath(strFileName) );

                            if ( oldImage.Width > MaxWidth || oldImage.Height > MaxHeight ) {

                                // determina fattore di scala
                                if(oldImage.Width > MaxWidth && MaxWidth>0){
                                    ScaleFactor = ((MaxWidth*100)/oldImage.Width);
                                }else if(oldImage.Height > MaxHeight){
                                    ScaleFactor = ((MaxHeight*100)/oldImage.Height);
                                }
                                // Immagine troppo grande, visualizzo la miniatura
                                newImage = oldImage.GetThumbnailImage( (oldImage.Width*ScaleFactor/100), (oldImage.Height*ScaleFactor/100), null, IntPtr.Zero);
                                Response.ContentType = "image/jpeg";
                                newImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                                oldImage.Dispose();
                                newImage.Dispose();
                                oldImage = null;
                                newImage = null;
                            } else {
                                // Immagine piccola, non faccio nulla
                                Response.ContentType = "image/jpeg";
                                oldImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                                oldImage.Dispose();
                                oldImage = null;
                            }
                        } catch (Exception ex) {
                            Response.Write(ex.Message);
                        }
                    }
                }
            }

            private bool IsInteger(string strTmp) {
                Regex objNotIntPattern = new Regex("[^0-9-]");
                Regex objIntPattern = new Regex("^-[0-9]+$|^[0-9]+$");
                return !objNotIntPattern.IsMatch(strTmp) && objIntPattern.IsMatch(strTmp);
            }

</script>
