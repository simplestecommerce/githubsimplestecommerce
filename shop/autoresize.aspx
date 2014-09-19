<%@ Page Language="VB" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Drawing" %>

<script runat="server">
    'Copyright (C) 2007 Daniele Iunco

    'This program is free software; you can redistribute it and/or modify
    'it under the terms of the GNU General Public License as published by
    'the Free Software Foundation; either version 2 of the License, or
    '(at your option) any later version.

    'This program is distributed in the hope that it will be useful,
    'but WITHOUT ANY WARRANTY; without even the implied warranty of
    'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    'GNU General Public License for more details.

    'You should have received a copy of the GNU General Public License along
    'with this program; if not, write to the Free Software Foundation, Inc.,
    '51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

    'advancedresizetool.aspx v1.0
    'Author: Daniele Iunco - http://www.gidinet.com
    'Date: 28th September 2007

    'Limite massimo per l'altezza in pixel
    Private Const MaxHeightSafe As Integer = 80

    'Limite massimo per la larghezza in pixel
    Private Const MaxWidthSafe As Integer = 40

    'Percorso dell'immagine su cui reindirizzare le richieste non valide
    Private Const ErrorImagePath As String = "/error.jpg"

    'Percorso in cui salvare le copie delle immagini, il percorso indicato deve avere i permessi in scrittura
    Private Const ImageCachePath As String = "../foto"

    'Salva su disco una copia riutilizzabile delle thumbnails create
    Private Const UseCache As Boolean = False

    'Di seguito sono riportati i valori predefiniti che verranno utilizzati quando non vengono specificati parametri
 Private Const DefaultHeight As Integer = 80
    Private Const DefaultWidth As Integer = 40
    Private Const DefaultResizeMode As ResizeMode = ResizeMode.AutoResize

    Private Const AllowCustomFormat As Boolean = False 'Impostare a False per ignorare il parametro del formato, True per utilizzarlo
    Private Const AllowCustomQuality As Boolean = False 'Impostare a False per ignorare il parametro della qualità, True per utilizzarlo
    Private Const MinQuality As Long = 10 'Qualità minima
    Private Const DefaultQuality As Long = 30 'Qualità predefinita
    Private Const MaxQuality As Long = 100 'Qualità massima

    Private Enum ResizeMode
        AutoResize = 0
        ManualResize = 1
    End Enum

    Private ReadOnly Property Mode() As ResizeMode
        Get
            Dim myReqMode As String = Request.QueryString("mode")
            If myReqMode Is Nothing OrElse Not IsNumeric(myReqMode) Then Return DefaultResizeMode
            If CInt(myReqMode) = 0 Then Return ResizeMode.AutoResize Else Return ResizeMode.ManualResize
        End Get
    End Property

    Private ReadOnly Property CustomQuality() As Long
        Get
            Dim myValue As String = Request.QueryString("quality")
            If myValue Is Nothing OrElse Not IsNumeric(myValue) Then Return DefaultQuality
            Dim myNumValue As Long = CLng(myValue)
            If myNumValue > MaxQuality OrElse myNumValue < MinQuality Then
                Return DefaultQuality
            Else
                Return myNumValue
            End If
        End Get
    End Property

    Private ReadOnly Property MaxHeight() As Integer
        Get
            Dim myValue As String = Request.QueryString("height")
            If myValue Is Nothing OrElse Not IsNumeric(myValue) Then Return DefaultHeight
            Dim myIntValue As Integer = CInt(myValue)
            If myIntValue < MaxHeightSafe Then
                Return myIntValue
            Else
                Return MaxHeightSafe
            End If
        End Get
    End Property

    Private ReadOnly Property MaxWidth() As Integer
        Get
            Dim myValue As String = Request.QueryString("width")
            If myValue Is Nothing OrElse Not IsNumeric(myValue) Then Return DefaultWidth
            Dim myIntValue As Integer = CInt(myValue)
            If myIntValue < MaxWidthSafe Then
                Return myIntValue
            Else
                Return MaxWidthSafe
            End If
        End Get
    End Property

    Private _ImagePath As String
    Private ReadOnly Property ImagePath() As String
        Get
            If Not _ImagePath Is Nothing Then Return _ImagePath
            Dim sRequestPath As String = Request.QueryString("path")

            If sRequestPath Is Nothing Then Return Nothing

            'Rimuovo le doppie / e i doppi . con le espressioni regolari
            sRequestPath = Regex.Replace(sRequestPath, "\/{2,}", "/")
            sRequestPath = Regex.Replace(sRequestPath, "\.{2,}", ".")

            If sRequestPath.Substring(0, 1) = "/" Then sRequestPath = sRequestPath.Substring(1)
            _ImagePath = sRequestPath

            Return _ImagePath
        End Get
    End Property

    Sub Page_Load(ByVal Sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim LocalImageFilePath As String
            Dim LocalThumbnailCacheFilePath As String

            LocalImageFilePath = Server.MapPath("/" & ImagePath)
            If Not File.Exists(LocalImageFilePath) Then
                Response.Redirect(ErrorImagePath)
                Exit Sub
            End If

            Dim myImageFormatString As String
            Dim myImageFormatClass As System.Drawing.Imaging.ImageFormat

            If AllowCustomFormat = False Then
                myImageFormatString = "jpeg"
                myImageFormatClass = System.Drawing.Imaging.ImageFormat.Jpeg
            Else
                Dim myType As String = Request.QueryString("format")
                If myType Is Nothing Then
                    myImageFormatClass = System.Drawing.Imaging.ImageFormat.Jpeg
                    myImageFormatString = "jpeg"
                Else
                    Select Case myType.Trim.ToLower
                        Case "jpeg"
                            myImageFormatClass = System.Drawing.Imaging.ImageFormat.Jpeg
                            myImageFormatString = "jpeg"
                        Case "png"
                            myImageFormatClass = System.Drawing.Imaging.ImageFormat.Png
                            myImageFormatString = "png"
                        Case Else
                            myImageFormatClass = System.Drawing.Imaging.ImageFormat.Jpeg
                            myImageFormatString = "jpeg"
                    End Select
                End If
            End If

            Dim ImageQuality As Long
            If AllowCustomQuality Then
                ImageQuality = CustomQuality
            Else
                ImageQuality = DefaultQuality
            End If

            Dim TempFilePath As String = Server.MapPath(ImageCachePath)
            LocalThumbnailCacheFilePath = Path.Combine(TempFilePath, ImagePath.Replace("/", "_")) & "_" & Int(Mode) & "_" & Int(MaxWidth) & "_" & Int(MaxWidth) & "_" & ImageQuality & "." & myImageFormatString & ".thumb"

            Dim mySourceFile As New System.IO.FileInfo(LocalImageFilePath)

            If UseCache Then
                If File.Exists(LocalThumbnailCacheFilePath) Then
                    Dim myDestFile As System.IO.FileInfo
                    myDestFile = New System.IO.FileInfo(LocalThumbnailCacheFilePath)
                    'Se il file della thumbnail è stato modificato nella stessa data oppure in seguito
                    'rispetto al file sorgente allora può essere utilizzato quello
                    If myDestFile.LastWriteTime.CompareTo(mySourceFile.LastWriteTime) >= 0 Then
                        'Il file esiste e va bene
                        Response.ContentType = "image/" & myImageFormatString
                        Response.WriteFile(myDestFile.FullName)
                        Exit Sub
                    Else
                        'Il file esiste ma è vecchio e va sostituito
                        myDestFile.Delete()
                    End If
                End If
            End If

            Dim orginalimg As System.Drawing.Image

            Try
                orginalimg = System.Drawing.Image.FromFile(mySourceFile.FullName)
            Catch
                Response.Redirect(ErrorImagePath)
                Exit Sub
            End Try

            Dim ThumbnailWidth, ThumbnailHeight As Integer
            Select Case Mode
                Case ResizeMode.AutoResize
                    ' ResizeMode.AutoResize: Ridimensiona l'immagine per restare nei limiti impostati, mantenendo le proporzioni
                    Dim myRatio As Double = orginalimg.Width / orginalimg.Height

                    If myRatio < 1 Then 'La larghezza è minore dell'altezza, quindi fisso l'altezza e calcolo il resto
                        ThumbnailHeight = MaxHeight
                        ThumbnailWidth = orginalimg.Width / orginalimg.Height * MaxHeight
                    ElseIf myRatio > 1 Then 'L'altezza è maggiore della larghezza, quindi fisso la larghezza e calcolo il resto
                        ThumbnailWidth = MaxWidth
                        ThumbnailHeight = orginalimg.Height / orginalimg.Width * MaxWidth
                    ElseIf myRatio = 1 Then 'Larghezza = Altezza
                        ThumbnailWidth = MaxWidth
                        ThumbnailHeight = MaxHeight
                    End If
                Case ResizeMode.ManualResize
                    ' ResizeMode.ManualResize: Ridimensiona con le misure indicate nei parametri
                    ThumbnailWidth = MaxWidth
                    ThumbnailHeight = MaxHeight
            End Select

            Response.ContentType = "image/" & myImageFormatString

            Dim panel As Bitmap

            panel = New Bitmap(ThumbnailWidth, ThumbnailHeight, Imaging.PixelFormat.Format24bppRgb)

            Dim g As Graphics = Graphics.FromImage(panel)
            g.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic
            g.SmoothingMode = Drawing2D.SmoothingMode.HighQuality
            g.PixelOffsetMode = Drawing2D.PixelOffsetMode.HighQuality
            g.CompositingQuality = Drawing2D.CompositingQuality.HighQuality
            g.DrawImage(orginalimg, 0, 0, ThumbnailWidth, ThumbnailHeight)

            Dim stream As System.IO.Stream = Response.OutputStream

            Dim MemStream As New System.IO.MemoryStream()

            If myImageFormatClass.Equals(System.Drawing.Imaging.ImageFormat.Jpeg) Then
                Dim Info() As System.Drawing.Imaging.ImageCodecInfo = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders
                Dim Params As New System.Drawing.Imaging.EncoderParameters(1)
                Params.Param(0) = New System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, ImageQuality)
                panel.Save(MemStream, Info(1), Params)
            Else
                panel.Save(MemStream, myImageFormatClass)
            End If

            g.Dispose()
            panel.Dispose()
            
            If UseCache Then
                Dim myS As New IO.FileStream(LocalThumbnailCacheFilePath, IO.FileMode.CreateNew)
                MemStream.WriteTo(myS)
                myS.Close()
                Response.WriteFile(LocalThumbnailCacheFilePath)
            Else
                MemStream.WriteTo(Response.OutputStream)
            End If
            orginalimg.Dispose()
            MemStream.Close()
            MemStream.Dispose()
        Catch ex As Exception
            Response.Write (ex.ToString())
        End Try
    End Sub

 </script>