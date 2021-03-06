USE [simplestecommerce]
GO
/****** Object:  Table [dbo].[terrorlog]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[terrorlog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[datetime] [datetime] NOT NULL,
	[text] [nvarchar](max) NULL,
 CONSTRAINT [PK_terrorlog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tcurrencies]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcurrencies](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cambio] [float] NOT NULL,
	[decimali] [int] NOT NULL,
	[decimalseparatorsymbol] [nvarchar](5) NOT NULL,
	[nome] [nchar](3) NOT NULL,
	[groupseparatorsymbol] [nvarchar](5) NOT NULL,
 CONSTRAINT [PK_valute] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_valute_1] ON [dbo].[tcurrencies] 
(
	[nome] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tcorrieri]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcorrieri](
	[c_id] [int] IDENTITY(1,1) NOT NULL,
	[c_nome] [nvarchar](max) NULL,
	[c_enabled] [bit] NOT NULL,
	[c_prezzo] [float] NOT NULL,
 CONSTRAINT [PK_tcorrieri] PRIMARY KEY CLUSTERED 
(
	[c_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tlistini]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tlistini](
	[lists_id] [int] NOT NULL,
	[lists_sconto] [float] NOT NULL,
 CONSTRAINT [PK_tlistini] PRIMARY KEY CLUSTERED 
(
	[lists_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipipagamento]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipipagamento](
	[id] [int] IDENTITY(0,1) NOT NULL,
	[nome] [nvarchar](max) NOT NULL,
	[attivo] [int] NULL,
	[prezzo] [float] NOT NULL,
	[modalita] [int] NOT NULL,
	[messaggio] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_tipipagamento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tnews]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tnews](
	[n_id] [int] IDENTITY(1,1) NOT NULL,
	[n_titolo] [nvarchar](max) NULL,
	[n_testo] [nvarchar](max) NULL,
	[n_data] [date] NULL,
 CONSTRAINT [PK_tnews] PRIMARY KEY CLUSTERED 
(
	[n_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmessaggi]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmessaggi](
	[m_id] [int] IDENTITY(1,1) NOT NULL,
	[m_data] [datetime] NULL,
	[m_autore] [nvarchar](50) NULL,
	[m_testo] [nvarchar](max) NULL,
 CONSTRAINT [PK_tmessaggi] PRIMARY KEY CLUSTERED 
(
	[m_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmessaggi] ON [dbo].[tmessaggi] 
(
	[m_data] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmailing]    Script Date: 09/15/2014 15:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmailing](
	[m_email] [nvarchar](50) NOT NULL,
	[m_guid] [varchar](10) NOT NULL,
	[m_confermato] [bit] NOT NULL,
 CONSTRAINT [PK_tmailing] PRIMARY KEY CLUSTERED 
(
	[m_email] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tconfig]    Script Date: 09/15/2014 15:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tconfig](
	[contatore] [int] IDENTITY(1,1) NOT NULL,
	[config_log] [nvarchar](max) NULL,
	[config_pwadmin] [binary](16) NULL,
	[config_nomesito] [nvarchar](max) NULL,
	[config_urlsito] [nvarchar](max) NULL,
	[config_emailsito] [nvarchar](max) NULL,
	[config_spSpedFisse] [float] NULL,
	[config_artPerPag] [int] NULL,
	[config_nvisite] [int] NULL,
	[config_maxArtVetrina] [int] NULL,
	[config_colonneReparti] [int] NULL,
	[config_colonneSottoreparti] [int] NULL,
	[config_showtaxincluded] [int] NULL,
	[config_tipiPagamento] [int] NULL,
	[config_metatagdescription] [nvarchar](max) NULL,
	[config_metatagkeywords] [nvarchar](max) NULL,
	[config_showReparti] [int] NULL,
	[config_showfeatured] [int] NULL,
	[config_smtp] [nvarchar](max) NULL,
	[config_guest] [int] NULL,
	[config_msgContrassegno] [nvarchar](max) NULL,
	[config_msgBonifico] [nvarchar](max) NULL,
	[config_msgCc] [nvarchar](max) NULL,
	[config_msgvaglia] [nvarchar](max) NULL,
	[config_msgpostepay] [nvarchar](max) NULL,
	[config_testataFattura] [nvarchar](max) NULL,
	[config_chisiamo] [nvarchar](max) NULL,
	[config_contatti] [nvarchar](max) NULL,
	[config_condizioni] [nvarchar](max) NULL,
	[config_openclose] [int] NULL,
	[config_msgchiusura] [nvarchar](max) NULL,
	[config_easynick] [nvarchar](max) NULL,
	[config_easypass] [binary](16) NULL,
	[config_easyimg] [int] NULL,
	[config_easypath] [nvarchar](max) NULL,
	[config_minOrd] [float] NULL,
	[config_maxord] [float] NULL,
	[config_login] [int] NULL,
	[config_registrazione] [int] NULL,
	[config_listinotarget] [int] NULL,
	[config_scorte] [int] NULL,
	[config_emailpaypal] [nvarchar](max) NULL,
	[config_bpw_idnegozio] [nvarchar](max) NULL,
	[config_bpw_avviomac] [nvarchar](max) NULL,
	[config_bpw_esitomac] [nvarchar](max) NULL,
	[config_bpw_urldone] [nvarchar](max) NULL,
	[config_bpw_urlback] [nvarchar](max) NULL,
	[config_bpw_urlms] [nvarchar](max) NULL,
	[config_bpw_cc] [nvarchar](max) NULL,
	[config_gestpaycodice] [nvarchar](max) NULL,
	[config_lastordergg] [int] NULL,
	[config_lastnordine] [int] NOT NULL,
	[config_maxArtOfferta] [int] NULL,
	[config_sogliaspedizioneomaggio] [float] NOT NULL,
	[config_banner1] [nvarchar](max) NOT NULL,
	[config_banner2] [nvarchar](max) NOT NULL,
	[config_banner1visibile] [int] NOT NULL,
	[config_banner2visibile] [int] NOT NULL,
	[config_banner1link] [nvarchar](max) NOT NULL,
	[config_banner2link] [nvarchar](max) NOT NULL,
	[config_conta] [bit] NOT NULL,
	[config_nimg] [int] NOT NULL,
	[config_privacy] [nvarchar](max) NOT NULL,
	[config_autenticazionesmtp] [nvarchar](50) NOT NULL,
	[config_autenticazioneemail] [nvarchar](50) NOT NULL,
	[config_autenticazionepass] [nvarchar](50) NOT NULL,
	[config_usaautenticazione] [bit] NOT NULL,
	[config_piede] [nvarchar](max) NOT NULL,
	[config_lastidfile] [int] NOT NULL,
	[config_categorieperriga] [int] NOT NULL,
	[config_idmastercurrency] [int] NOT NULL,
	[config_showboxusato] [bit] NOT NULL,
	[config_currencycodepaypal] [nvarchar](30) NOT NULL,
	[config_demo] [bit] NOT NULL,
	[config_applytaxonshipping] [bit] NOT NULL,
	[config_welcometext] [nvarchar](max) NOT NULL,
	[config_idmerchantregion] [int] NOT NULL,
	[config_showalwaysfiscalcode] [bit] NOT NULL,
	[config_askalwaysforfiscalcode] [bit] NOT NULL,
	[config_askfortelephone] [bit] NOT NULL,
	[config_posprimarylanguagetoken] [int] NOT NULL,
	[config_startingfrontendlanguagename] [nvarchar](50) NOT NULL,
	[config_adminlanguagename] [nvarchar](50) NOT NULL,
	[config_frontendlanguages] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_tconfig] PRIMARY KEY CLUSTERED 
(
	[contatore] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tcategorie]    Script Date: 09/15/2014 15:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcategorie](
	[cat_id] [int] IDENTITY(1,1) NOT NULL,
	[cat_livello] [int] NOT NULL,
	[cat_nome] [nvarchar](max) NOT NULL,
	[cat_idpadre] [int] NOT NULL,
	[cat_idantenato] [int] NOT NULL,
	[cat_img] [nvarchar](max) NULL,
	[cat_nascondi] [bit] NOT NULL,
 CONSTRAINT [PK_tcategorie] PRIMARY KEY CLUSTERED 
(
	[cat_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcategorie] ON [dbo].[tcategorie] 
(
	[cat_idpadre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcategorie_1] ON [dbo].[tcategorie] 
(
	[cat_livello] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcategorie_2] ON [dbo].[tcategorie] 
(
	[cat_idantenato] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcategorie_3] ON [dbo].[tcategorie] 
(
	[cat_nascondi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcategorie_4] ON [dbo].[tcategorie] 
(
	[cat_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbanner]    Script Date: 09/15/2014 15:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbanner](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[img] [nvarchar](max) NOT NULL,
	[link] [nvarchar](max) NOT NULL,
	[position] [int] NOT NULL,
 CONSTRAINT [PK_tbanner] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_posbanner] ON [dbo].[tbanner] 
(
	[position] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[SeparateValues]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[SeparateValues]
(
    @data VARCHAR(MAX),
    @delimiter VARCHAR(10) 
) 
    RETURNS @tbldata TABLE(col VARCHAR(10))
As
Begin
    DECLARE @pos INT
    DECLARE @prevpos INT

    SET @pos = 1 
    SET @prevpos = 0

    WHILE @pos > 0 
        BEGIN

        SET @pos = CHARINDEX(@delimiter, @data, @prevpos+1)

        if @pos > 0 
        INSERT INTO @tbldata(col) VALUES(LTRIM(RTRIM(SUBSTRING(@data, @prevpos+1, @pos-@prevpos-1))))

        else

        INSERT INTO @tbldata(col) VALUES(LTRIM(RTRIM(SUBSTRING(@data, @prevpos+1, len(@data)-@prevpos))))

        SET @prevpos = @pos 
    End

    RETURN

END
GO
/****** Object:  Table [dbo].[orderstatus]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orderstatus](
	[id] [int] IDENTITY(0,1) NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[enabled] [int] NULL,
 CONSTRAINT [PK_statilavorazione] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[coupon]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[coupon](
	[code] [varchar](50) NOT NULL,
	[discount] [float] NOT NULL,
	[ispercent] [bit] NOT NULL,
	[enabled] [bit] NOT NULL,
	[applyon] [int] NOT NULL,
 CONSTRAINT [PK_coupon] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[taxprofiles]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[taxprofiles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](max) NOT NULL,
	[basedonshipping] [bit] NOT NULL,
 CONSTRAINT [PK_taxprofiles] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tsovrapprezzi]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tsovrapprezzi](
	[so_indice] [int] NOT NULL,
	[so_prezzo] [float] NOT NULL,
	[so_modalita] [int] NOT NULL,
 CONSTRAINT [PK_tsovrapprezzi] PRIMARY KEY CLUSTERED 
(
	[so_indice] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tregioni]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tregioni](
	[r_nome] [varchar](300) NOT NULL,
	[r_zona] [int] NULL,
	[r_accettato] [bit] NOT NULL,
	[r_vatnumberforfirm] [bit] NOT NULL,
	[r_id] [int] IDENTITY(1,1) NOT NULL,
	[r_ue] [bit] NOT NULL,
 CONSTRAINT [PK_tregioni] PRIMARY KEY CLUSTERED 
(
	[r_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tregioni] ON [dbo].[tregioni] 
(
	[r_nome] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tpesi]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tpesi](
	[p_id] [int] IDENTITY(1,1) NOT NULL,
	[p_da] [int] NULL,
	[p_a] [int] NULL,
	[p_prezzo] [float] NULL,
 CONSTRAINT [PK_tpesi] PRIMARY KEY CLUSTERED 
(
	[p_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tpesi] ON [dbo].[tpesi] 
(
	[p_da] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tpagine]    Script Date: 09/15/2014 15:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tpagine](
	[pa_nome] [nvarchar](max) NULL,
	[pa_testo] [nvarchar](max) NULL,
	[pa_protezione] [int] NOT NULL,
	[pa_id] [int] IDENTITY(1,1) NOT NULL,
	[pa_posizione] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pa_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idxposizionepagine] ON [dbo].[tpagine] 
(
	[pa_posizione] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[copiatcartvariante]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[copiatcartvariante] ( @idcartvariante as int, @idordcartitem as int) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.



SET NOCOUNT ON;




declare @n as int =					    (select n from tcartvariante where tcartvariante.id=@idcartvariante);
declare @nome as nvarchar(max) =		(select nome from tcartvariante where tcartvariante.id=@idcartvariante);
declare @valore as nvarchar(max) =      (select valore from tcartvariante where tcartvariante.id=@idcartvariante);


insert into tordcartvariante 
(idordcartitem, n, nome, valore)
VALUES
(@idordcartitem, @n, @nome, @valore)




END
GO
/****** Object:  Table [dbo].[tzone]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tzone](
	[z_id] [int] NOT NULL,
	[z_importo] [float] NOT NULL,
 CONSTRAINT [PK_tzone] PRIMARY KEY CLUSTERED 
(
	[z_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tvolumi]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tvolumi](
	[p_id] [int] IDENTITY(1,1) NOT NULL,
	[p_da] [int] NOT NULL,
	[p_a] [int] NOT NULL,
	[p_prezzo] [float] NOT NULL,
 CONSTRAINT [PK_tvolumi] PRIMARY KEY CLUSTERED 
(
	[p_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tvisite]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tvisite](
	[v_id] [bigint] IDENTITY(1,1) NOT NULL,
	[v_timestamp] [datetime] NULL,
	[v_pagina] [nvarchar](max) NULL,
	[v_ip] [nvarchar](max) NULL,
	[v_referrer] [nvarchar](max) NULL,
 CONSTRAINT [PK_tvisite] PRIMARY KEY CLUSTERED 
(
	[v_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tvisite] ON [dbo].[tvisite] 
(
	[v_timestamp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tutenti]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tutenti](
	[ut_pass] [binary](16) NULL,
	[ut_listino] [int] NOT NULL,
	[ut_sconto] [float] NOT NULL,
	[ut_timestamp] [datetime] NULL,
	[ut_vatnumber] [nvarchar](50) NULL,
	[ut_protezione] [int] NOT NULL,
	[ut_newsletter] [bit] NOT NULL,
	[ut_subject] [int] NOT NULL,
	[ut_email] [varchar](40) NOT NULL,
	[ut_id] [varchar](40) NOT NULL,
	[ut_idregion] [int] NOT NULL,
	[ut_spaddress] [nvarchar](50) NOT NULL,
	[ut_sppostalcode] [nvarchar](50) NOT NULL,
	[ut_spcity] [nvarchar](50) NOT NULL,
	[ut_spidregion] [int] NOT NULL,
	[ut_spfirstname] [nvarchar](50) NOT NULL,
	[ut_spsecondname] [nvarchar](50) NOT NULL,
	[ut_secondname] [nvarchar](50) NOT NULL,
	[ut_firstname] [nvarchar](50) NOT NULL,
	[ut_city] [nvarchar](50) NOT NULL,
	[ut_postalcode] [nvarchar](50) NOT NULL,
	[ut_telephone] [nvarchar](50) NOT NULL,
	[ut_fiscalcode] [nvarchar](50) NOT NULL,
	[ut_address] [nvarchar](50) NOT NULL,
	[ut_nameoffirm] [nvarchar](50) NOT NULL,
	[ut_bloccato] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ut_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tutenti] ON [dbo].[tutenti] 
(
	[ut_email] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [myidx_ut_bloccato] ON [dbo].[tutenti] 
(
	[ut_bloccato] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tarticoli]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tarticoli](
	[art_id] [int] IDENTITY(1,1) NOT NULL,
	[art_idcat] [int] NOT NULL,
	[art_timestamp] [datetime] NOT NULL,
	[art_cod] [nvarchar](255) NULL,
	[art_visibile] [bit] NOT NULL,
	[art_nome] [nvarchar](max) NULL,
	[art_predescrizione] [nvarchar](max) NULL,
	[art_marca] [nvarchar](50) NULL,
	[art_stock] [float] NULL,
	[art_disponibilita] [int] NOT NULL,
	[art_descrizione] [nvarchar](max) NULL,
	[art_invetrina] [bit] NOT NULL,
	[art_usato] [bit] NOT NULL,
	[art_inofferta] [bit] NOT NULL,
	[art_imgpreview] [nvarchar](max) NULL,
	[art_imgpreviewwidth] [varchar](4) NULL,
	[art_imgpreviewheight] [varchar](4) NULL,
	[art_description] [nvarchar](max) NULL,
	[art_keywords] [nvarchar](max) NULL,
	[art_posizione] [int] NULL,
	[art_peso] [float] NULL,
	[art_volume] [int] NULL,
	[art_consegna] [int] NULL,
	[art_vendite] [int] NOT NULL,
	[art_caratteristiche] [nvarchar](max) NULL,
	[art_path] [nvarchar](max) NULL,
	[art_dataarrivo] [nvarchar](50) NULL,
	[art_idtaxprofile] [int] NOT NULL,
 CONSTRAINT [PK_tarticoli_1] PRIMARY KEY CLUSTERED 
(
	[art_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [indexidtaxprofile] ON [dbo].[tarticoli] 
(
	[art_idtaxprofile] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli] ON [dbo].[tarticoli] 
(
	[art_cod] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_1] ON [dbo].[tarticoli] 
(
	[art_usato] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_2] ON [dbo].[tarticoli] 
(
	[art_inofferta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_3] ON [dbo].[tarticoli] 
(
	[art_invetrina] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_4] ON [dbo].[tarticoli] 
(
	[art_visibile] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_5] ON [dbo].[tarticoli] 
(
	[art_idcat] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_6] ON [dbo].[tarticoli] 
(
	[art_marca] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_7] ON [dbo].[tarticoli] 
(
	[art_posizione] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tarticoli_8] ON [dbo].[tarticoli] 
(
	[art_vendite] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[getscontolistinoforlistinozero]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[getscontolistinoforlistinozero] 
AS
BEGIN


   select lists_sconto from tlistini where lists_id=0

   

END
GO
/****** Object:  StoredProcedure [dbo].[gettaxtype]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gettaxtype] ( 
@idregionbilling int,
@idmerchantregion int
 ) 

AS
BEGIN

SET NOCOUNT ON;


declare @uemerchant bit;
set @uemerchant= (select r_ue from tregioni where r_id=@idmerchantregion);  



SELECT
    CASE r_ue 
        WHEN 1 THEN (
			select case @uemerchant
			   when 1 then 1
			   when 0 THEN 0
			end)
		when 0 then 0
    END
FROM tregioni where r_id=@idregionbilling

END
GO
/****** Object:  Table [dbo].[taxrates]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[taxrates](
	[idtaxprofile] [int] NOT NULL,
	[idregion] [int] NOT NULL,
	[rate] [float] NOT NULL,
	[vatrateforfirm] [float] NOT NULL,
	[vatrateforprivate] [float] NOT NULL,
 CONSTRAINT [taxrates_pk] PRIMARY KEY CLUSTERED 
(
	[idtaxprofile] ASC,
	[idregion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[logexception]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[logexception] ( 
@howmanyrecordstokeep as int,
@errortext as nvarchar(MAX) 
)
AS
BEGIN

declare @howmanyrecords as int = (select count(*) from terrorlog);

declare @todelete as int = (@howmanyrecords-@howmanyrecordstokeep+1);

if @todelete>0
begin

	DELETE terrorlog WHERE id IN (SELECT TOP (@todelete) id FROM terrorlog ORDER BY id);

end

insert into terrorlog (text) values (@errortext);



END
GO
/****** Object:  Table [dbo].[tlistino]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tlistino](
	[list_idart] [int] NOT NULL,
	[list_n] [int] NOT NULL,
	[list_prezzobase] [float] NOT NULL,
	[list_scontopercento] [float] NOT NULL,
 CONSTRAINT [PK_tlistino_1] PRIMARY KEY CLUSTERED 
(
	[list_idart] ASC,
	[list_n] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlistino] ON [dbo].[tlistino] 
(
	[list_idart] ASC,
	[list_n] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tlistino_1] ON [dbo].[tlistino] 
(
	[list_n] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[test]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[test] 


AS
BEGIN

select * from tarticoli

END
GO
/****** Object:  Table [dbo].[tcorrelati]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcorrelati](
	[idart] [int] NOT NULL,
	[idartcorr] [int] NOT NULL,
 CONSTRAINT [PK_tcorrelati] PRIMARY KEY CLUSTERED 
(
	[idart] ASC,
	[idartcorr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcorrelati] ON [dbo].[tcorrelati] 
(
	[idart] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tcorrelati_1] ON [dbo].[tcorrelati] 
(
	[idartcorr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[getallmarche]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[getallmarche] 

AS
BEGIN


    
SELECT DISTINCT
		art_marca 
        FROM tarticoli, tcategorie
        WHERE 1=1
        AND art_idcat=cat_id 
        AND art_visibile=1 AND cat_nascondi=0
   
		ORDER BY art_marca
 
END
GO
/****** Object:  Table [dbo].[tcart]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tcart](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idcarrier] [int] NOT NULL,
	[idmodeofpayment] [int] NOT NULL,
	[note] [nvarchar](max) NOT NULL,
	[guestsubject] [int] NULL,
	[guestnameoffirm] [nvarchar](50) NULL,
	[guestfirstname] [nvarchar](50) NULL,
	[guestsecondname] [nvarchar](50) NULL,
	[guestemail] [nvarchar](50) NULL,
	[guesttelephone] [nvarchar](50) NULL,
	[guestfiscalcode] [nvarchar](50) NULL,
	[guestvatnumber] [nvarchar](50) NULL,
	[guestaddress] [nvarchar](50) NULL,
	[guestpostalcode] [nvarchar](50) NULL,
	[guestcity] [nvarchar](50) NULL,
	[guestidregion] [int] NULL,
	[spfirstname] [nvarchar](50) NOT NULL,
	[spsecondname] [nvarchar](50) NOT NULL,
	[spaddress] [nvarchar](50) NOT NULL,
	[sppostalcode] [nvarchar](50) NOT NULL,
	[spcity] [nvarchar](50) NOT NULL,
	[spidregion] [int] NOT NULL,
	[subtotal] [float] NOT NULL,
	[coupononsubtotal] [float] NOT NULL,
	[tax] [float] NOT NULL,
	[shippingcost] [float] NOT NULL,
	[taxonshippingcost] [float] NOT NULL,
	[couponaftertaxes] [float] NOT NULL,
	[tot] [float] NOT NULL,
	[idorderstatus] [int] NOT NULL,
	[data] [datetime2](0) NULL,
	[promemoria] [nvarchar](max) NOT NULL,
	[taxtype] [int] NOT NULL,
	[idloggeduser] [varchar](40) NULL,
	[userlanguage] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_tcart] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[marchericercaavanzata]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[marchericercaavanzata] (
@termine as nvarchar(100),
@CommaSeparated as nvarchar(4000) ,
@dimpag as int,
@numpag as int,
@ordine as varchar(30),
@inDescrizione as varchar(20),
@inCodice as varchar(20)
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.







    
SELECT DISTINCT art_marca 
        FROM tarticoli, tcategorie
        WHERE 1=1
        AND art_idcat=cat_id 
        AND art_visibile=1 AND cat_nascondi=0
        AND (
			art_nome LIKE @termine 
			OR
			(art_cod LIKE @termine AND @inCodice='si')
			OR
			(art_descrizione LIKE @termine AND @inDescrizione='si')
			)
			
		AND ( 
			art_idcat IN (	select col FROM [SeparateValues](@CommaSeparated, ',') ) 
			OR @CommaSeparated='-1'
			)
			        






END
GO
/****** Object:  StoredProcedure [dbo].[gettaxrate]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[gettaxrate] ( 
@idart int,
@idregionbilling int,
@subject int,
@idmerchantregion int
 ) 

AS
BEGIN

SET NOCOUNT ON;


declare @uemerchant bit;
set @uemerchant= (select r_ue from tregioni where r_id=@idmerchantregion);  


declare @uebilling bit;
set @uebilling= (select r_ue from tregioni where r_id=@idregionbilling);  

if (@uebilling=1 and @uemerchant=1) begin
	if (@subject=0)
	begin
		select vatrateforprivate from taxrates, taxprofiles, tarticoli where
		tarticoli.art_idtaxprofile=taxprofiles.id and taxprofiles.id=taxrates.idtaxprofile
		and art_id=@idart and taxrates.idregion=@idregionbilling
	end
	else
	begin
		select vatrateforfirm from taxrates, taxprofiles, tarticoli where
		tarticoli.art_idtaxprofile=taxprofiles.id and taxprofiles.id=taxrates.idtaxprofile
		and art_id=@idart and taxrates.idregion=@idregionbilling

	end
end
else
begin
	select rate from taxrates, taxprofiles, tarticoli where
	tarticoli.art_idtaxprofile=taxprofiles.id and taxprofiles.id=taxrates.idtaxprofile
	and art_id=@idart and taxrates.idregion=@idregionbilling
end


END
GO
/****** Object:  StoredProcedure [dbo].[getsomedataloggeduserforeverypage]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getsomedataloggeduserforeverypage] ( 
@userid as nvarchar(50) 
)
AS
BEGIN


                select ut_listino, ut_sconto, ut_protezione, ut_newsletter,lists_sconto 
				from tutenti inner join tlistini on tutenti.ut_listino=lists_id where ut_id=@userid and ut_bloccato=0








END
GO
/****** Object:  StoredProcedure [dbo].[getmarchepertermine]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getmarchepertermine] (
@termine as nvarchar(100),
@CommaSeparated as nvarchar(4000)
)

AS
BEGIN


    
SELECT DISTINCT
		art_marca 
        FROM tarticoli, tcategorie
        WHERE 1=1
        AND art_idcat=cat_id 
        AND art_visibile=1 AND cat_nascondi=0
        AND (
				(art_nome LIKE @termine OR art_cod LIKE @termine)
                OR
                (art_idcat IN (
								select col FROM [SeparateValues](@CommaSeparated, ',')
							  )
				)
            )


		ORDER BY art_marca
 
END
GO
/****** Object:  StoredProcedure [dbo].[getMarcheByIdCat]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getMarcheByIdCat] ( 
@idcat as int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.










      
SELECT DISTINCT 
		art_marca
		FROM tcategorie, tarticoli
		WHERE 1=1
		AND art_idcat=cat_id 
		AND cat_id=@idcat 
		AND art_visibile=1 
		AND cat_nascondi=0




ORDER BY art_marca

END
GO
/****** Object:  StoredProcedure [dbo].[getloggeduserdataforcartsummaryaspx]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[getloggeduserdataforcartsummaryaspx] ( 
@userid as nvarchar(50) 
)
AS
BEGIN


                select ut_email, ut_firstname, ut_secondname, ut_address, ut_postalcode, ut_city, ut_telephone, ut_fiscalcode, ut_vatnumber, ut_newsletter
                , ut_nameoffirm, ut_subject,  ut_idregion
                , ut_spfirstname, ut_spsecondname, ut_spaddress, ut_spcity, ut_sppostalcode, ut_spidregion
                from tutenti where ut_id=@userid and ut_bloccato=0








END
GO
/****** Object:  Table [dbo].[tzoom]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tzoom](
	[z_id] [int] IDENTITY(1,1) NOT NULL,
	[z_idart] [int] NOT NULL,
	[z_quale] [int] NULL,
	[z_percorso] [nvarchar](max) NULL,
	[z_width] [varchar](4) NULL,
	[z_height] [varchar](4) NULL,
 CONSTRAINT [PK_tzoom] PRIMARY KEY CLUSTERED 
(
	[z_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_tzoom] ON [dbo].[tzoom] 
(
	[z_idart] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tzoom_1] ON [dbo].[tzoom] 
(
	[z_quale] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tscontiquantita]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tscontiquantita](
	[s_id] [int] IDENTITY(1,1) NOT NULL,
	[s_idart] [int] NOT NULL,
	[s_quantita] [int] NOT NULL,
	[s_sconto] [float] NOT NULL,
 CONSTRAINT [PK_tscontiquantita] PRIMARY KEY CLUSTERED 
(
	[s_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tscontiquantita] ON [dbo].[tscontiquantita] 
(
	[s_idart] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tvarianti]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tvarianti](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](max) NULL,
	[idart] [int] NOT NULL,
	[n] [int] NOT NULL,
 CONSTRAINT [PK_tvarianti] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_n_idart] ON [dbo].[tvarianti] 
(
	[n] ASC,
	[idart] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tvarianti] ON [dbo].[tvarianti] 
(
	[idart] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[topzioni]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[topzioni](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idvar] [int] NOT NULL,
	[testo] [varchar](max) NOT NULL,
	[prezzo] [float] NOT NULL,
	[img] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_topzioni] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[getpertermine]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getpertermine] (
@termine as nvarchar(100),
@listino as int,
@CommaSeparated as nvarchar(4000) ,
@ordine as varchar(30),
@marca as nvarchar(max)
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.









    
SELECT * FROM
(

	SELECT TOP 100 PERCENT 


		art_id, 
		(list_prezzobase - list_prezzobase*list_scontoPerCento/100) as prezzoscontato,
		art_nome,
		art_marca
        FROM tarticoli, tcategorie, tlistino
        WHERE 1=1
        AND art_idcat=cat_id 
        AND art_id=list_idart 
        AND list_n=@listino
        AND art_visibile=1 AND cat_nascondi=0
        AND (
				(art_nome LIKE @termine OR art_cod LIKE @termine)
                OR
                (art_idcat IN (
								select col FROM [SeparateValues](@CommaSeparated, ',')
							  )
				)
            )
        AND (art_marca=@marca OR @marca='-1')

	) AS T


ORDER BY 
CASE WHEN @ordine = 'nome' THEN t.art_nome  END,
CASE WHEN @ordine = 'marca' THEN t.art_marca   END,
CASE WHEN @ordine = 'prezzo' THEN t.prezzoscontato END,
CASE WHEN @ordine = '-1' THEN t.art_id 
END




END
GO
/****** Object:  StoredProcedure [dbo].[getDatiArticolo]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getDatiArticolo] ( 
@idart as int, 
@listino as int
)
AS
BEGIN


SELECT 
list_prezzobase, 
list_scontopercento, 
tarticoli.*
FROM tarticoli, tcategorie, tlistino
WHERE 
art_idcat=cat_id AND art_id=list_idart 
AND list_n=@listino
AND art_id=@idart 
AND art_visibile=1 AND cat_nascondi=0







END
GO
/****** Object:  StoredProcedure [dbo].[getArticoliForFeed]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getArticoliForFeed]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @scontolistino as float = 
		(select lists_sconto from tlistini where lists_id=0)
    

    
    SELECT 
    art_id,
    art_path, 
    art_nome, 
    art_marca, 
    art_predescrizione,
    art_imgpreview,
    art_nIva,
    art_disponibilita,
    art_cod,
    art_ean,
    SUBSTRING ( art_descrizione ,1 , 300 ) as descrizioneparziale,
    case 
    when list_ivainc=0  then (list_prezzobase*(1-list_scontopercento/100-@scontolistino/100))*(1+ivapercento.ivapercento/100)
    else ((list_prezzobase/(1 + ivapercento.ivapercento / 100))*(1-list_scontopercento/100-@scontolistino/100))*(1+ivapercento.ivapercento/100)
    end 
    as prezzoscontatoivato
	from
	tarticoli, tcategorie, ivapercento, tlistino
	where
	1=1
	AND art_idcat=cat_id 
	AND ivapercento.id=art_niva
	AND art_id = list_idart
	AND list_n=0
	AND art_visibile=1
	AND cat_nascondi=0
	
END
GO
/****** Object:  StoredProcedure [dbo].[getArticoliByIdCat]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getArticoliByIdCat] ( 
@listino as int,
@idcat as int, 
@ordine as varchar(30),
@marca as nvarchar(max)

)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.




      
SELECT * FROM
(

	SELECT TOP 100 PERCENT 
		art_id,
		art_nome,
		art_marca, 
		(list_prezzobase - list_prezzobase*list_scontoPerCento/100) as prezzoscontato
		FROM tcategorie, tarticoli, tlistino
		WHERE 
		art_idcat=cat_id 
		AND art_id=list_idart 
		AND list_n=@listino 
		AND cat_id=@idcat 
		AND art_visibile=1 
		AND cat_nascondi=0
		AND (art_marca=@marca OR @marca='-1')

	) AS T

ORDER BY 
CASE WHEN @ordine = 'nome' THEN t.art_nome  END,
CASE WHEN @ordine = 'marca' THEN t.art_marca   END,
CASE WHEN @ordine = 'prezzo' THEN t.prezzoscontato END,
CASE WHEN @ordine = '-1' THEN t.art_id 
END

END
GO
/****** Object:  Table [dbo].[tcartitem]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcartitem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idcart] [int] NOT NULL,
	[idart] [int] NOT NULL,
	[code] [nvarchar](50) NOT NULL,
	[finalprice] [float] NOT NULL,
	[quantity] [int] NOT NULL,
	[preview] [nvarchar](max) NOT NULL,
	[peso] [float] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[totaldiscount] [float] NOT NULL,
 CONSTRAINT [PK_tcartitem] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tcartvariation]    Script Date: 09/15/2014 15:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcartvariation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idcartitem] [int] NOT NULL,
	[strvariation] [nvarchar](50) NOT NULL,
	[stroption] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tcartvariation] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Default [DF_errorlog_datetime]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[terrorlog] ADD  CONSTRAINT [DF_errorlog_datetime]  DEFAULT (getdate()) FOR [datetime]
GO
/****** Object:  Default [DF_valute_cambio]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcurrencies] ADD  CONSTRAINT [DF_valute_cambio]  DEFAULT ((1)) FOR [cambio]
GO
/****** Object:  Default [DF__tcurrenci__decim__5165187F]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcurrencies] ADD  DEFAULT ((2)) FOR [decimali]
GO
/****** Object:  Default [DF__tcurrenci__decim__52593CB8]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcurrencies] ADD  DEFAULT (',') FOR [decimalseparatorsymbol]
GO
/****** Object:  Default [DF__tcurrencie__nome__534D60F1]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcurrencies] ADD  DEFAULT ('') FOR [nome]
GO
/****** Object:  Default [DF__tcurrenci__group__5441852A]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcurrencies] ADD  DEFAULT ('.') FOR [groupseparatorsymbol]
GO
/****** Object:  Default [DF__tcorrieri__c_ena__3B40CD36]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcorrieri] ADD  CONSTRAINT [DF__tcorrieri__c_ena__3B40CD36]  DEFAULT ((1)) FOR [c_enabled]
GO
/****** Object:  Default [DF__tcorrieri__c_pre__3C34F16F]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tcorrieri] ADD  CONSTRAINT [DF__tcorrieri__c_pre__3C34F16F]  DEFAULT ((0)) FOR [c_prezzo]
GO
/****** Object:  Default [DF_tlistini_lists_id]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tlistini] ADD  CONSTRAINT [DF_tlistini_lists_id]  DEFAULT ((0)) FOR [lists_id]
GO
/****** Object:  Default [DF_tlistini_lists_sconto]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tlistini] ADD  CONSTRAINT [DF_tlistini_lists_sconto]  DEFAULT ((0)) FOR [lists_sconto]
GO
/****** Object:  Default [DF_statilavorazione_nome]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tipipagamento] ADD  CONSTRAINT [DF_statilavorazione_nome]  DEFAULT ('') FOR [nome]
GO
/****** Object:  Default [DF_tipipagamento_attivo]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tipipagamento] ADD  CONSTRAINT [DF_tipipagamento_attivo]  DEFAULT ((1)) FOR [attivo]
GO
/****** Object:  Default [DF_tipipagamento_prezzo]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tipipagamento] ADD  CONSTRAINT [DF_tipipagamento_prezzo]  DEFAULT ((0)) FOR [prezzo]
GO
/****** Object:  Default [DF_tipipagamento_modalita]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tipipagamento] ADD  CONSTRAINT [DF_tipipagamento_modalita]  DEFAULT ((0)) FOR [modalita]
GO
/****** Object:  Default [DF__tipipagam__messa__5CD6CB2B]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tipipagamento] ADD  DEFAULT ('') FOR [messaggio]
GO
/****** Object:  Default [DF__tmailing__m_guid__5DCAEF64]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tmailing] ADD  DEFAULT ('') FOR [m_guid]
GO
/****** Object:  Default [DF__tmailing__m_conf__5EBF139D]    Script Date: 09/15/2014 15:38:09 ******/
ALTER TABLE [dbo].[tmailing] ADD  DEFAULT ((0)) FOR [m_confermato]
GO
/****** Object:  Default [DF_tconfig_config_spSpedFisse]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_spSpedFisse]  DEFAULT ((0)) FOR [config_spSpedFisse]
GO
/****** Object:  Default [DF_tconfig_config_lastordergg]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_lastordergg]  DEFAULT ((1)) FOR [config_lastordergg]
GO
/****** Object:  Default [DF_tconfig_config_lastnordine]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_lastnordine]  DEFAULT ((0)) FOR [config_lastnordine]
GO
/****** Object:  Default [DF_tconfig_config_maxArtOfferta]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_maxArtOfferta]  DEFAULT ((12)) FOR [config_maxArtOfferta]
GO
/****** Object:  Default [DF_tconfig_config_sogliaspedizioneomaggio]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_sogliaspedizioneomaggio]  DEFAULT ((100000000)) FOR [config_sogliaspedizioneomaggio]
GO
/****** Object:  Default [DF_tconfig_config_banner1]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_banner1]  DEFAULT ('') FOR [config_banner1]
GO
/****** Object:  Default [DF_tconfig_config_banner2]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_banner2]  DEFAULT ('') FOR [config_banner2]
GO
/****** Object:  Default [DF_tconfig_config_banner1visibile]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_banner1visibile]  DEFAULT ((1)) FOR [config_banner1visibile]
GO
/****** Object:  Default [DF_tconfig_config_banner2visibile]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_banner2visibile]  DEFAULT ((1)) FOR [config_banner2visibile]
GO
/****** Object:  Default [DF_tconfig_config_banner1link]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_banner1link]  DEFAULT ('') FOR [config_banner1link]
GO
/****** Object:  Default [DF_tconfig_config_banner2link]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_banner2link]  DEFAULT ('') FOR [config_banner2link]
GO
/****** Object:  Default [DF_tconfig_config_conta]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_conta]  DEFAULT ((1)) FOR [config_conta]
GO
/****** Object:  Default [DF_tconfig_config_nimg]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_nimg]  DEFAULT ((0)) FOR [config_nimg]
GO
/****** Object:  Default [DF__tconfig__config___6C190EBB]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_privacy]
GO
/****** Object:  Default [DF__tconfig__config___6D0D32F4]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_autenticazionesmtp]
GO
/****** Object:  Default [DF__tconfig__config___6E01572D]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_autenticazioneemail]
GO
/****** Object:  Default [DF__tconfig__config___6EF57B66]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_autenticazionepass]
GO
/****** Object:  Default [DF_tconfig_config_autenticazione]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_autenticazione]  DEFAULT ((0)) FOR [config_usaautenticazione]
GO
/****** Object:  Default [DF__tconfig__config___70DDC3D8]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_piede]
GO
/****** Object:  Default [DF_tconfig_config_lastidfile]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  CONSTRAINT [DF_tconfig_config_lastidfile]  DEFAULT ((1)) FOR [config_lastidfile]
GO
/****** Object:  Default [DF__tconfig__config___72C60C4A]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((7)) FOR [config_categorieperriga]
GO
/****** Object:  Default [DF__tconfig__config___73BA3083]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((1)) FOR [config_idmastercurrency]
GO
/****** Object:  Default [DF__tconfig__config___74AE54BC]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((1)) FOR [config_showboxusato]
GO
/****** Object:  Default [DF__tconfig__config___75A278F5]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('EUR') FOR [config_currencycodepaypal]
GO
/****** Object:  Default [DF__tconfig__config___76969D2E]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((0)) FOR [config_demo]
GO
/****** Object:  Default [DF__tconfig__config___778AC167]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((0)) FOR [config_applytaxonshipping]
GO
/****** Object:  Default [DF__tconfig__config___787EE5A0]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_welcometext]
GO
/****** Object:  Default [DF__tconfig__config___797309D9]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((-1)) FOR [config_idmerchantregion]
GO
/****** Object:  Default [DF__tconfig__config___7A672E12]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((0)) FOR [config_showalwaysfiscalcode]
GO
/****** Object:  Default [DF__tconfig__config___7B5B524B]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((0)) FOR [config_askalwaysforfiscalcode]
GO
/****** Object:  Default [DF__tconfig__config___7C4F7684]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((0)) FOR [config_askfortelephone]
GO
/****** Object:  Default [DF__tconfig__config___7D439ABD]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ((0)) FOR [config_posprimarylanguagetoken]
GO
/****** Object:  Default [DF__tconfig__config___7E37BEF6]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_startingfrontendlanguagename]
GO
/****** Object:  Default [DF__tconfig__config___7F2BE32F]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('') FOR [config_adminlanguagename]
GO
/****** Object:  Default [DF__tconfig__config___00200768]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tconfig] ADD  DEFAULT ('english') FOR [config_frontendlanguages]
GO
/****** Object:  Default [DF_tcategorie_cat_livello]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tcategorie] ADD  CONSTRAINT [DF_tcategorie_cat_livello]  DEFAULT ((0)) FOR [cat_livello]
GO
/****** Object:  Default [DF_tcategorie_cat_nome]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tcategorie] ADD  CONSTRAINT [DF_tcategorie_cat_nome]  DEFAULT ('') FOR [cat_nome]
GO
/****** Object:  Default [DF_tcategorie_cat_idpadre]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tcategorie] ADD  CONSTRAINT [DF_tcategorie_cat_idpadre]  DEFAULT ((0)) FOR [cat_idpadre]
GO
/****** Object:  Default [DF_tcategorie_cat_idantenato]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tcategorie] ADD  CONSTRAINT [DF_tcategorie_cat_idantenato]  DEFAULT ((0)) FOR [cat_idantenato]
GO
/****** Object:  Default [DF_tcategorie_cat_nascondi]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tcategorie] ADD  CONSTRAINT [DF_tcategorie_cat_nascondi]  DEFAULT ((0)) FOR [cat_nascondi]
GO
/****** Object:  Default [DF__tbanner__positio__05D8E0BE]    Script Date: 09/15/2014 15:38:10 ******/
ALTER TABLE [dbo].[tbanner] ADD  DEFAULT ((0)) FOR [position]
GO
/****** Object:  Default [DF_statilavorazione_nome_1]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[orderstatus] ADD  CONSTRAINT [DF_statilavorazione_nome_1]  DEFAULT ('') FOR [name]
GO
/****** Object:  Default [DF_statilavorazione_attivo]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[orderstatus] ADD  CONSTRAINT [DF_statilavorazione_attivo]  DEFAULT ((1)) FOR [enabled]
GO
/****** Object:  Default [DF_coupon_code]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[coupon] ADD  CONSTRAINT [DF_coupon_code]  DEFAULT ('') FOR [code]
GO
/****** Object:  Default [DF_coupon_value]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[coupon] ADD  CONSTRAINT [DF_coupon_value]  DEFAULT ((0)) FOR [discount]
GO
/****** Object:  Default [DF_coupon_ispercent]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[coupon] ADD  CONSTRAINT [DF_coupon_ispercent]  DEFAULT ((1)) FOR [ispercent]
GO
/****** Object:  Default [DF_coupon_disabled]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[coupon] ADD  CONSTRAINT [DF_coupon_disabled]  DEFAULT ((1)) FOR [enabled]
GO
/****** Object:  Default [DF__coupon__applyon__0C85DE4D]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[coupon] ADD  DEFAULT ((0)) FOR [applyon]
GO
/****** Object:  Default [DF_taxprofiles_name]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[taxprofiles] ADD  CONSTRAINT [DF_taxprofiles_name]  DEFAULT ('') FOR [name]
GO
/****** Object:  Default [DF_taxprofiles_basedonshipping]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[taxprofiles] ADD  CONSTRAINT [DF_taxprofiles_basedonshipping]  DEFAULT ((0)) FOR [basedonshipping]
GO
/****** Object:  Default [DF_tsovrapprezzi_so_indice]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tsovrapprezzi] ADD  CONSTRAINT [DF_tsovrapprezzi_so_indice]  DEFAULT ((0)) FOR [so_indice]
GO
/****** Object:  Default [DF_tsovrapprezzi_so_prezzo]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tsovrapprezzi] ADD  CONSTRAINT [DF_tsovrapprezzi_so_prezzo]  DEFAULT ((0)) FOR [so_prezzo]
GO
/****** Object:  Default [DF_tsovrapprezzi_so_modalita]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tsovrapprezzi] ADD  CONSTRAINT [DF_tsovrapprezzi_so_modalita]  DEFAULT ((0)) FOR [so_modalita]
GO
/****** Object:  Default [DF_tregioni_r_accettato]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tregioni] ADD  CONSTRAINT [DF_tregioni_r_accettato]  DEFAULT ((1)) FOR [r_accettato]
GO
/****** Object:  Default [DF_tregioni_r_ivaseimpresa]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tregioni] ADD  CONSTRAINT [DF_tregioni_r_ivaseimpresa]  DEFAULT ((0)) FOR [r_vatnumberforfirm]
GO
/****** Object:  Default [DF__tregioni__r_ue__14270015]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tregioni] ADD  DEFAULT ((0)) FOR [r_ue]
GO
/****** Object:  Default [DF_tpesi_p_da]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tpesi] ADD  CONSTRAINT [DF_tpesi_p_da]  DEFAULT ((0)) FOR [p_da]
GO
/****** Object:  Default [DF_tpesi_p_a]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tpesi] ADD  CONSTRAINT [DF_tpesi_p_a]  DEFAULT ((0)) FOR [p_a]
GO
/****** Object:  Default [DF_tpesi_p_prezzo]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tpesi] ADD  CONSTRAINT [DF_tpesi_p_prezzo]  DEFAULT ((0)) FOR [p_prezzo]
GO
/****** Object:  Default [DF_tpaginie_pa_protezione]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tpagine] ADD  CONSTRAINT [DF_tpaginie_pa_protezione]  DEFAULT ((0)) FOR [pa_protezione]
GO
/****** Object:  Default [DF__tpagine__pa_posi__18EBB532]    Script Date: 09/15/2014 15:38:15 ******/
ALTER TABLE [dbo].[tpagine] ADD  DEFAULT ((0)) FOR [pa_posizione]
GO
/****** Object:  Default [DF_tzone_z_id]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tzone] ADD  CONSTRAINT [DF_tzone_z_id]  DEFAULT ((0)) FOR [z_id]
GO
/****** Object:  Default [DF_tzone_z_importo]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tzone] ADD  CONSTRAINT [DF_tzone_z_importo]  DEFAULT ((0)) FOR [z_importo]
GO
/****** Object:  Default [DF_tvolumi_p_da]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tvolumi] ADD  CONSTRAINT [DF_tvolumi_p_da]  DEFAULT ((0)) FOR [p_da]
GO
/****** Object:  Default [DF_tvolumi_p_a]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tvolumi] ADD  CONSTRAINT [DF_tvolumi_p_a]  DEFAULT ((0)) FOR [p_a]
GO
/****** Object:  Default [DF_tvolumi_p_prezzo]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tvolumi] ADD  CONSTRAINT [DF_tvolumi_p_prezzo]  DEFAULT ((0)) FOR [p_prezzo]
GO
/****** Object:  Default [DF_tutenti_ut_sconto]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  CONSTRAINT [DF_tutenti_ut_sconto]  DEFAULT ((0)) FOR [ut_sconto]
GO
/****** Object:  Default [DF_tutenti_ut_timestamp]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  CONSTRAINT [DF_tutenti_ut_timestamp]  DEFAULT (getdate()) FOR [ut_timestamp]
GO
/****** Object:  Default [DF_tutenti_ut_protezione]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  CONSTRAINT [DF_tutenti_ut_protezione]  DEFAULT ((0)) FOR [ut_protezione]
GO
/****** Object:  Default [DF_tutenti_ut_newsletter]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  CONSTRAINT [DF_tutenti_ut_newsletter]  DEFAULT ((0)) FOR [ut_newsletter]
GO
/****** Object:  Default [DF__tutenti__ut_subj__22751F6C]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ((0)) FOR [ut_subject]
GO
/****** Object:  Default [DF__tutenti__ut_emai__236943A5]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_email]
GO
/****** Object:  Default [DF__tutenti__ut_id__245D67DE]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_id]
GO
/****** Object:  Default [DF__tutenti__ut_idre__25518C17]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ((-1)) FOR [ut_idregion]
GO
/****** Object:  Default [DF__tutenti__ut_spad__2645B050]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_spaddress]
GO
/****** Object:  Default [DF__tutenti__ut_sppo__2739D489]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_sppostalcode]
GO
/****** Object:  Default [DF__tutenti__ut_spci__282DF8C2]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_spcity]
GO
/****** Object:  Default [DF__tutenti__ut_spid__29221CFB]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ((-1)) FOR [ut_spidregion]
GO
/****** Object:  Default [DF__tutenti__ut_spfi__2A164134]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_spfirstname]
GO
/****** Object:  Default [DF__tutenti__ut_spse__2B0A656D]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_spsecondname]
GO
/****** Object:  Default [DF__tutenti__ut_seco__2BFE89A6]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_secondname]
GO
/****** Object:  Default [DF__tutenti__ut_firs__2CF2ADDF]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_firstname]
GO
/****** Object:  Default [DF__tutenti__ut_city__2DE6D218]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_city]
GO
/****** Object:  Default [DF__tutenti__ut_post__2EDAF651]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_postalcode]
GO
/****** Object:  Default [DF__tutenti__ut_tele__2FCF1A8A]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_telephone]
GO
/****** Object:  Default [DF__tutenti__ut_fisc__30C33EC3]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_fiscalcode]
GO
/****** Object:  Default [DF__tutenti__ut_addr__31B762FC]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_address]
GO
/****** Object:  Default [DF__tutenti__ut_name__32AB8735]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ('') FOR [ut_nameoffirm]
GO
/****** Object:  Default [DF__tutenti__ut_bloc__339FAB6E]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti] ADD  DEFAULT ((0)) FOR [ut_bloccato]
GO
/****** Object:  Default [DF_tarticoli_art_timestamp]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_timestamp]  DEFAULT (getdate()) FOR [art_timestamp]
GO
/****** Object:  Default [DF_tarticoli_art_visibile]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_visibile]  DEFAULT ((1)) FOR [art_visibile]
GO
/****** Object:  Default [DF_tarticoli_art_stock]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_stock]  DEFAULT ((9999999)) FOR [art_stock]
GO
/****** Object:  Default [DF_tarticoli_art_disponibilita]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_disponibilita]  DEFAULT ((0)) FOR [art_disponibilita]
GO
/****** Object:  Default [DF_tarticoli_art_invetrina]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_invetrina]  DEFAULT ((0)) FOR [art_invetrina]
GO
/****** Object:  Default [DF_tarticoli_art_inevidenza]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_inevidenza]  DEFAULT ((0)) FOR [art_usato]
GO
/****** Object:  Default [DF_tarticoli_art_inofferta]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_inofferta]  DEFAULT ((0)) FOR [art_inofferta]
GO
/****** Object:  Default [DF_tarticoli_art_imgpreviewheight]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_imgpreviewheight]  DEFAULT ('75') FOR [art_imgpreviewheight]
GO
/****** Object:  Default [DF_tarticoli_art_posizione]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_posizione]  DEFAULT ((0)) FOR [art_posizione]
GO
/****** Object:  Default [DF_tarticoli_art_peso]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_peso]  DEFAULT ((0)) FOR [art_peso]
GO
/****** Object:  Default [DF_tarticoli_art_volume]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_volume]  DEFAULT ((0)) FOR [art_volume]
GO
/****** Object:  Default [DF_tarticoli_art_consegna]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_consegna]  DEFAULT ((-1)) FOR [art_consegna]
GO
/****** Object:  Default [DF_tarticoli_art_vendite]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  CONSTRAINT [DF_tarticoli_art_vendite]  DEFAULT ((0)) FOR [art_vendite]
GO
/****** Object:  Default [DF__tarticoli__art_i__40F9A68C]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli] ADD  DEFAULT ((1)) FOR [art_idtaxprofile]
GO
/****** Object:  Default [DF__taxrates__idtaxp__41EDCAC5]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates] ADD  DEFAULT ((-1)) FOR [idtaxprofile]
GO
/****** Object:  Default [DF__taxrates__idregi__42E1EEFE]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates] ADD  DEFAULT ((-1)) FOR [idregion]
GO
/****** Object:  Default [DF__taxrates__rate__43D61337]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates] ADD  DEFAULT ((0)) FOR [rate]
GO
/****** Object:  Default [DF__taxrates__vatrat__44CA3770]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates] ADD  DEFAULT ((0)) FOR [vatrateforfirm]
GO
/****** Object:  Default [DF__taxrates__vatrat__45BE5BA9]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates] ADD  DEFAULT ((0)) FOR [vatrateforprivate]
GO
/****** Object:  Default [DF_tlistino_idart]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tlistino] ADD  CONSTRAINT [DF_tlistino_idart]  DEFAULT ((-1)) FOR [list_idart]
GO
/****** Object:  Default [DF_tlistino_n]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tlistino] ADD  CONSTRAINT [DF_tlistino_n]  DEFAULT ((0)) FOR [list_n]
GO
/****** Object:  Default [DF_tlistino_prezzobase]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tlistino] ADD  CONSTRAINT [DF_tlistino_prezzobase]  DEFAULT ((0)) FOR [list_prezzobase]
GO
/****** Object:  Default [DF_tlistino_scontopercento]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tlistino] ADD  CONSTRAINT [DF_tlistino_scontopercento]  DEFAULT ((0)) FOR [list_scontopercento]
GO
/****** Object:  Default [DF_tcorrelati_idart]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcorrelati] ADD  CONSTRAINT [DF_tcorrelati_idart]  DEFAULT ((-1)) FOR [idart]
GO
/****** Object:  Default [DF_tcorrelati_idartcorr]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcorrelati] ADD  CONSTRAINT [DF_tcorrelati_idartcorr]  DEFAULT ((-1)) FOR [idartcorr]
GO
/****** Object:  Default [DF_tcart_carrier]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_carrier]  DEFAULT ((-1)) FOR [idcarrier]
GO
/****** Object:  Default [DF_tcart_modeofpayment]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_modeofpayment]  DEFAULT ((-1)) FOR [idmodeofpayment]
GO
/****** Object:  Default [DF_tcart_note]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_note]  DEFAULT ('') FOR [note]
GO
/****** Object:  Default [DF_tcart_spfirstname]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_spfirstname]  DEFAULT ('') FOR [spfirstname]
GO
/****** Object:  Default [DF_tcart_spsecondname]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_spsecondname]  DEFAULT ('') FOR [spsecondname]
GO
/****** Object:  Default [DF_tcart_spaddress]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_spaddress]  DEFAULT ('') FOR [spaddress]
GO
/****** Object:  Default [DF_tcart_sppostalcode]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_sppostalcode]  DEFAULT ('') FOR [sppostalcode]
GO
/****** Object:  Default [DF_tcart_spcity]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_spcity]  DEFAULT ('') FOR [spcity]
GO
/****** Object:  Default [DF_tcart_spidregion]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_spidregion]  DEFAULT ((-1)) FOR [spidregion]
GO
/****** Object:  Default [DF__tcart__subtotal__55009F39]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [subtotal]
GO
/****** Object:  Default [DF__tcart__couponons__55F4C372]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [coupononsubtotal]
GO
/****** Object:  Default [DF__tcart__tax__56E8E7AB]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [tax]
GO
/****** Object:  Default [DF__tcart__shippingc__57DD0BE4]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [shippingcost]
GO
/****** Object:  Default [DF__tcart__taxonship__58D1301D]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [taxonshippingcost]
GO
/****** Object:  Default [DF__tcart__couponaft__59C55456]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [couponaftertaxes]
GO
/****** Object:  Default [DF__tcart__tot__5AB9788F]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [tot]
GO
/****** Object:  Default [DF__tcart__idorderst__5BAD9CC8]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [idorderstatus]
GO
/****** Object:  Default [DF__tcart__promemori__5CA1C101]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ('') FOR [promemoria]
GO
/****** Object:  Default [DF__tcart__taxtype__5D95E53A]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  DEFAULT ((0)) FOR [taxtype]
GO
/****** Object:  Default [DF_tcart_userlanguage]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart] ADD  CONSTRAINT [DF_tcart_userlanguage]  DEFAULT ('') FOR [userlanguage]
GO
/****** Object:  Default [DF_tzoom_z_idart]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tzoom] ADD  CONSTRAINT [DF_tzoom_z_idart]  DEFAULT ((0)) FOR [z_idart]
GO
/****** Object:  Default [DF_tzoom_z_quale]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tzoom] ADD  CONSTRAINT [DF_tzoom_z_quale]  DEFAULT ((0)) FOR [z_quale]
GO
/****** Object:  Default [DF_tscontiquantita_s_idart]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tscontiquantita] ADD  CONSTRAINT [DF_tscontiquantita_s_idart]  DEFAULT ((0)) FOR [s_idart]
GO
/****** Object:  Default [DF_tscontiquantita_s_quantita]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tscontiquantita] ADD  CONSTRAINT [DF_tscontiquantita_s_quantita]  DEFAULT ((0)) FOR [s_quantita]
GO
/****** Object:  Default [DF_tscontiquantita_s_sconto]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tscontiquantita] ADD  CONSTRAINT [DF_tscontiquantita_s_sconto]  DEFAULT ((0)) FOR [s_sconto]
GO
/****** Object:  Default [DF__tvarianti__n__7755B73D]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tvarianti] ADD  CONSTRAINT [DF__tvarianti__n__7755B73D]  DEFAULT ((0)) FOR [n]
GO
/****** Object:  Default [DF_topzioni_prezzo]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[topzioni] ADD  CONSTRAINT [DF_topzioni_prezzo]  DEFAULT ((0)) FOR [prezzo]
GO
/****** Object:  Default [DF__topzioni__img__662B2B3B]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[topzioni] ADD  DEFAULT ('') FOR [img]
GO
/****** Object:  Default [DF_Table_1_code]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  CONSTRAINT [DF_Table_1_code]  DEFAULT ('') FOR [code]
GO
/****** Object:  Default [DF_Table_1_finalprice]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  CONSTRAINT [DF_Table_1_finalprice]  DEFAULT ((0)) FOR [finalprice]
GO
/****** Object:  Default [DF_tcartitem_quantity]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  CONSTRAINT [DF_tcartitem_quantity]  DEFAULT ((0)) FOR [quantity]
GO
/****** Object:  Default [DF_tcartitem_preview]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  CONSTRAINT [DF_tcartitem_preview]  DEFAULT ('') FOR [preview]
GO
/****** Object:  Default [DF_tcartitem_peso]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  CONSTRAINT [DF_tcartitem_peso]  DEFAULT ((0)) FOR [peso]
GO
/****** Object:  Default [DF__tcartitem__name__6BE40491]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  DEFAULT ('') FOR [name]
GO
/****** Object:  Default [DF_tcartitem_totaldiscount]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem] ADD  CONSTRAINT [DF_tcartitem_totaldiscount]  DEFAULT ((0)) FOR [totaldiscount]
GO
/****** Object:  Default [DF_tcartvariation_strvariation]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartvariation] ADD  CONSTRAINT [DF_tcartvariation_strvariation]  DEFAULT ('') FOR [strvariation]
GO
/****** Object:  Default [DF_tcartvariation_stroption]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartvariation] ADD  CONSTRAINT [DF_tcartvariation_stroption]  DEFAULT ('') FOR [stroption]
GO
/****** Object:  ForeignKey [FK_tutenti_tregioni]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti]  WITH CHECK ADD  CONSTRAINT [FK_tutenti_tregioni] FOREIGN KEY([ut_idregion])
REFERENCES [dbo].[tregioni] ([r_id])
GO
ALTER TABLE [dbo].[tutenti] CHECK CONSTRAINT [FK_tutenti_tregioni]
GO
/****** Object:  ForeignKey [FK_tutenti_tregioni1]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tutenti]  WITH CHECK ADD  CONSTRAINT [FK_tutenti_tregioni1] FOREIGN KEY([ut_spidregion])
REFERENCES [dbo].[tregioni] ([r_id])
GO
ALTER TABLE [dbo].[tutenti] CHECK CONSTRAINT [FK_tutenti_tregioni1]
GO
/****** Object:  ForeignKey [FK_tarticoli_taxprofiles]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli]  WITH CHECK ADD  CONSTRAINT [FK_tarticoli_taxprofiles] FOREIGN KEY([art_idtaxprofile])
REFERENCES [dbo].[taxprofiles] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tarticoli] CHECK CONSTRAINT [FK_tarticoli_taxprofiles]
GO
/****** Object:  ForeignKey [FK_tarticoli_tcategorie]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tarticoli]  WITH CHECK ADD  CONSTRAINT [FK_tarticoli_tcategorie] FOREIGN KEY([art_idcat])
REFERENCES [dbo].[tcategorie] ([cat_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tarticoli] CHECK CONSTRAINT [FK_tarticoli_tcategorie]
GO
/****** Object:  ForeignKey [FK_taxrates_taxprofiles]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates]  WITH CHECK ADD  CONSTRAINT [FK_taxrates_taxprofiles] FOREIGN KEY([idtaxprofile])
REFERENCES [dbo].[taxprofiles] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[taxrates] CHECK CONSTRAINT [FK_taxrates_taxprofiles]
GO
/****** Object:  ForeignKey [FK_taxrates_tregioni]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[taxrates]  WITH CHECK ADD  CONSTRAINT [FK_taxrates_tregioni] FOREIGN KEY([idregion])
REFERENCES [dbo].[tregioni] ([r_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[taxrates] CHECK CONSTRAINT [FK_taxrates_tregioni]
GO
/****** Object:  ForeignKey [FK_tlistino_tarticoli]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tlistino]  WITH CHECK ADD  CONSTRAINT [FK_tlistino_tarticoli] FOREIGN KEY([list_idart])
REFERENCES [dbo].[tarticoli] ([art_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tlistino] CHECK CONSTRAINT [FK_tlistino_tarticoli]
GO
/****** Object:  ForeignKey [FK_tcorrelati_tarticoli]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcorrelati]  WITH CHECK ADD  CONSTRAINT [FK_tcorrelati_tarticoli] FOREIGN KEY([idart])
REFERENCES [dbo].[tarticoli] ([art_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tcorrelati] CHECK CONSTRAINT [FK_tcorrelati_tarticoli]
GO
/****** Object:  ForeignKey [FK_tcart_orderstatus]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart]  WITH CHECK ADD  CONSTRAINT [FK_tcart_orderstatus] FOREIGN KEY([idorderstatus])
REFERENCES [dbo].[orderstatus] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tcart] CHECK CONSTRAINT [FK_tcart_orderstatus]
GO
/****** Object:  ForeignKey [FK_tcart_tcorrieri]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart]  WITH CHECK ADD  CONSTRAINT [FK_tcart_tcorrieri] FOREIGN KEY([idcarrier])
REFERENCES [dbo].[tcorrieri] ([c_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tcart] CHECK CONSTRAINT [FK_tcart_tcorrieri]
GO
/****** Object:  ForeignKey [FK_tcart_tipipagamento]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart]  WITH CHECK ADD  CONSTRAINT [FK_tcart_tipipagamento] FOREIGN KEY([idmodeofpayment])
REFERENCES [dbo].[tipipagamento] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tcart] CHECK CONSTRAINT [FK_tcart_tipipagamento]
GO
/****** Object:  ForeignKey [FK_tcart_tregioni]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart]  WITH CHECK ADD  CONSTRAINT [FK_tcart_tregioni] FOREIGN KEY([spidregion])
REFERENCES [dbo].[tregioni] ([r_id])
GO
ALTER TABLE [dbo].[tcart] CHECK CONSTRAINT [FK_tcart_tregioni]
GO
/****** Object:  ForeignKey [FK_tcart_tregioni1]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart]  WITH CHECK ADD  CONSTRAINT [FK_tcart_tregioni1] FOREIGN KEY([guestidregion])
REFERENCES [dbo].[tregioni] ([r_id])
GO
ALTER TABLE [dbo].[tcart] CHECK CONSTRAINT [FK_tcart_tregioni1]
GO
/****** Object:  ForeignKey [FK_tcart_tutenti]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcart]  WITH CHECK ADD  CONSTRAINT [FK_tcart_tutenti] FOREIGN KEY([idloggeduser])
REFERENCES [dbo].[tutenti] ([ut_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tcart] CHECK CONSTRAINT [FK_tcart_tutenti]
GO
/****** Object:  ForeignKey [FK_tzoom_tarticoli]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tzoom]  WITH CHECK ADD  CONSTRAINT [FK_tzoom_tarticoli] FOREIGN KEY([z_idart])
REFERENCES [dbo].[tarticoli] ([art_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tzoom] CHECK CONSTRAINT [FK_tzoom_tarticoli]
GO
/****** Object:  ForeignKey [FK_tscontiquantita_tarticoli]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tscontiquantita]  WITH CHECK ADD  CONSTRAINT [FK_tscontiquantita_tarticoli] FOREIGN KEY([s_idart])
REFERENCES [dbo].[tarticoli] ([art_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tscontiquantita] CHECK CONSTRAINT [FK_tscontiquantita_tarticoli]
GO
/****** Object:  ForeignKey [FK_tvarianti_tarticoli]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tvarianti]  WITH CHECK ADD  CONSTRAINT [FK_tvarianti_tarticoli] FOREIGN KEY([idart])
REFERENCES [dbo].[tarticoli] ([art_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tvarianti] CHECK CONSTRAINT [FK_tvarianti_tarticoli]
GO
/****** Object:  ForeignKey [FKmia_topzioni_tvarianti]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[topzioni]  WITH CHECK ADD  CONSTRAINT [FKmia_topzioni_tvarianti] FOREIGN KEY([idvar])
REFERENCES [dbo].[tvarianti] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[topzioni] CHECK CONSTRAINT [FKmia_topzioni_tvarianti]
GO
/****** Object:  ForeignKey [FK_tcartitem_tcart]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartitem]  WITH CHECK ADD  CONSTRAINT [FK_tcartitem_tcart] FOREIGN KEY([idcart])
REFERENCES [dbo].[tcart] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tcartitem] CHECK CONSTRAINT [FK_tcartitem_tcart]
GO
/****** Object:  ForeignKey [FK_tcartvariation_tcartitem]    Script Date: 09/15/2014 15:38:30 ******/
ALTER TABLE [dbo].[tcartvariation]  WITH CHECK ADD  CONSTRAINT [FK_tcartvariation_tcartitem] FOREIGN KEY([idcartitem])
REFERENCES [dbo].[tcartitem] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tcartvariation] CHECK CONSTRAINT [FK_tcartvariation_tcartitem]
GO
