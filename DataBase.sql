CREATE DATABASE [PrestigeCars]
GO

USE [PrestigeCars]
GO
/****** Object:  Schema [Data]    Script Date: 01/06/2018 08:48:39 ******/
CREATE SCHEMA [Data]
GO
/****** Object:  Schema [DataTransfer]    Script Date: 01/06/2018 08:48:39 ******/
CREATE SCHEMA [DataTransfer]
GO
/****** Object:  Schema [Output]    Script Date: 01/06/2018 08:48:39 ******/
CREATE SCHEMA [Output]
GO
/****** Object:  Schema [Reference]    Script Date: 01/06/2018 08:48:39 ******/
CREATE SCHEMA [Reference]
GO
/****** Object:  Schema [SourceData]    Script Date: 01/06/2018 08:48:39 ******/
CREATE SCHEMA [SourceData]
GO
/****** Object:  Table [Data].[Country]    Script Date: 01/06/2018 08:48:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[Country](
	[CountryName] [nvarchar](150) NULL,
	[CountryISO2] [nchar](10) NULL,
	[CountryISO3] [nchar](10) NULL,
	[SalesRegion] [nvarchar](20) NULL,
	[CountryFlag] [varbinary](max) NULL,
	[FlagFileName] [nvarchar](50) NULL,
	[FlagFileType] [nchar](3) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Data].[Customer]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[Customer](
	[CustomerID] [nvarchar](5) NOT NULL,
	[CustomerName] [nvarchar](150) NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[Town] [nvarchar](50) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Country] [nchar](10) NULL,
	[IsReseller] [bit] NULL,
	[IsCreditRisk] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Data].[Make]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[Make](
	[MakeID] [smallint] IDENTITY(1,1) NOT NULL,
	[MakeName] [nvarchar](100) NULL,
	[MakeCountry] [char](3) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Data].[Model]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[Model](
	[ModelID] [smallint] IDENTITY(1,1) NOT NULL,
	[MakeID] [smallint] NULL,
	[ModelName] [nvarchar](150) NULL,
	[ModelVariant] [nvarchar](150) NULL,
	[YearFirstProduced] [char](4) NULL,
	[YearLastProduced] [char](4) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Data].[SalesDetails]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[SalesDetails](
	[SalesDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[SalesID] [int] NULL,
	[LineItemNumber] [tinyint] NULL,
	[StockID] [nvarchar](50) NULL,
	[SalePrice] [numeric](18, 2) NULL,
	[LineItemDiscount] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Data].[Stock]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[Stock](
	[StockCode] [nvarchar](50) NULL,
	[ModelID] [smallint] NULL,
	[Cost] [money] NULL,
	[RepairsCost] [money] NULL,
	[PartsCost] [money] NULL,
	[TransportInCost] [money] NULL,
	[IsRHD] [bit] NULL,
	[Color] [nvarchar](50) NULL,
	[BuyerComments] [nvarchar](4000) NULL,
	[DateBought] [date] NULL,
	[TimeBought] [time](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Data].[Sales]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[Sales](
	[SalesID] [int] NOT NULL,
	[CustomerID] [nvarchar](5) NULL,
	[InvoiceNumber] [char](8) NULL,
	[TotalSalePrice] [numeric](18, 2) NULL,
	[SaleDate] [datetime] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [Data].[SalesByCountry]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [Data].[SalesByCountry]

AS

SELECT   
 CO.CountryName
,MK.MakeName
,MD.ModelName, ST.Cost
,ST.RepairsCost
,ST.PartsCost
,ST.TransportInCost
,ST.Color
,SD.SalePrice
,SD.LineItemDiscount
,SA.InvoiceNumber
,SA.SaleDate
,CS.CustomerName
,SD.SalesDetailsID

FROM     Data.Stock ST 
         INNER JOIN Data.Model MD ON ST.ModelID = MD.ModelID 
         INNER JOIN Data.Make MK ON MD.MakeID = MK.MakeID 
         INNER JOIN Data.SalesDetails SD ON ST.StockCode = SD.StockID 
         INNER JOIN Data.Sales SA ON SD.SalesID = SA.SalesID 
         INNER JOIN Data.Customer CS ON SA.CustomerID = CS.CustomerID 
         INNER JOIN Data.Country CO  ON CS.Country = CO.CountryISO2




GO
/****** Object:  Table [Data].[PivotTable]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Data].[PivotTable](
	[Color] [nvarchar](50) NULL,
	[2015] [numeric](38, 2) NULL,
	[2016] [numeric](38, 2) NULL,
	[2017] [numeric](38, 2) NULL,
	[2018] [numeric](38, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DataTransfer].[Sales2015]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataTransfer].[Sales2015](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[CustomerName] [nvarchar](150) NULL,
	[CountryName] [nvarchar](150) NULL,
	[Cost] [money] NULL,
	[RepairsCost] [money] NULL,
	[PartsCost] [money] NULL,
	[TransportInCost] [money] NULL,
	[SalePrice] [numeric](18, 2) NULL,
	[SaleDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DataTransfer].[Sales2016]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataTransfer].[Sales2016](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[CustomerName] [nvarchar](150) NULL,
	[CountryName] [nvarchar](150) NULL,
	[Cost] [money] NULL,
	[RepairsCost] [money] NULL,
	[PartsCost] [money] NULL,
	[TransportInCost] [money] NULL,
	[SalePrice] [numeric](18, 2) NULL,
	[SaleDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DataTransfer].[Sales2017]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataTransfer].[Sales2017](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[CustomerName] [nvarchar](150) NULL,
	[CountryName] [nvarchar](150) NULL,
	[Cost] [money] NULL,
	[RepairsCost] [money] NULL,
	[PartsCost] [money] NULL,
	[TransportInCost] [money] NULL,
	[SalePrice] [numeric](18, 2) NULL,
	[SaleDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DataTransfer].[Sales2018]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DataTransfer].[Sales2018](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[CustomerName] [nvarchar](150) NULL,
	[CountryName] [nvarchar](150) NULL,
	[Cost] [money] NULL,
	[RepairsCost] [money] NULL,
	[PartsCost] [money] NULL,
	[TransportInCost] [money] NULL,
	[SalePrice] [numeric](18, 2) NULL,
	[SaleDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Output].[StockPrices]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Output].[StockPrices](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[Cost] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[Budget]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[Budget](
	[BudgetKey] [int] IDENTITY(1,1) NOT NULL,
	[BudgetValue] [money] NULL,
	[Year] [int] NULL,
	[Month] [tinyint] NULL,
	[BudgetDetail] [nvarchar](50) NULL,
	[BudgetElement] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[Forex]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[Forex](
	[ExchangeDate] [date] NULL,
	[ISOCurrency] [char](3) NULL,
	[ExchangeRate] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[MarketingCategories]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[MarketingCategories](
	[MakeName] [nvarchar](100) NULL,
	[MarketingType] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[MarketingInformation]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[MarketingInformation](
	[CUST] [nvarchar](150) NULL,
	[Country] [nchar](10) NULL,
	[SpendCapacity] [varchar](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[SalesBudgets]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[SalesBudgets](
	[BudgetArea] [varchar](35) NULL,
	[BudgetAmount] [money] NULL,
	[BudgetYear] [int] NULL,
	[DateUpdated] [datetime] NULL,
	[Comments] [nvarchar](4000) NULL,
	[BudgetMonth] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[SalesCategory]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[SalesCategory](
	[LowerThreshold] [int] NULL,
	[UpperThreshold] [int] NULL,
	[CategoryDescription] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[Staff]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[Staff](
	[StaffID] [int] IDENTITY(1,1) NOT NULL,
	[StaffName] [nvarchar](50) NULL,
	[ManagerID] [int] NULL,
	[Department] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[StaffHierarchy]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[StaffHierarchy](
	[HierarchyReference] [hierarchyid] NULL,
	[StaffID] [int] IDENTITY(1,1) NOT NULL,
	[StaffName] [nvarchar](50) NULL,
	[ManagerID] [int] NULL,
	[Department] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Reference].[YearlySales]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reference].[YearlySales](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[CustomerName] [nvarchar](150) NULL,
	[CountryName] [nvarchar](150) NULL,
	[Cost] [money] NULL,
	[RepairsCost] [money] NULL,
	[PartsCost] [money] NULL,
	[TransportInCost] [money] NULL,
	[SalePrice] [numeric](18, 2) NULL,
	[SaleDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SourceData].[SalesInPounds]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SourceData].[SalesInPounds](
	[MakeName] [nvarchar](100) NULL,
	[ModelName] [nvarchar](150) NULL,
	[VehicleCost] [varchar](51) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SourceData].[SalesText]    Script Date: 01/06/2018 08:48:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SourceData].[SalesText](
	[CountryName] [nvarchar](150) NULL,
	[MakeName] [nvarchar](100) NULL,
	[Cost] [varchar](20) NULL,
	[SalePrice] [varchar](20) NULL
) ON [PRIMARY]
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'Belgium', N'BE        ', N'BEL       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'France', N'FR        ', N'FRA       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'Germany', N'DE        ', N'DEU       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'Italy', N'IT        ', N'ITA       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'Spain', N'ES        ', N'ESP       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'United Kingdom', N'GB        ', N'GBR       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'United States', N'US        ', N'USA       ', N'North America', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'China', N'CN        ', N'CHN       ', N'Asia', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'India', N'IN        ', N'IND       ', N'Asia', NULL, NULL, NULL)
GO
INSERT [Data].[Country] ([CountryName], [CountryISO2], [CountryISO3], [SalesRegion], [CountryFlag], [FlagFileName], [FlagFileType]) VALUES (N'Switzerland', N'CH        ', N'CHF       ', N'EMEA', NULL, NULL, NULL)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0001', N'Magic Motors', N'27, Handsworth Road', NULL, N'Birmingham', N'B1 7AZ', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0002', N'Snazzy Roadsters', N'102, Bleak Street', NULL, N'Birmingham', N'B3 5ST', N'GB        ', 1, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0003', N'Birmingham Executive Prestige Vehicles', N'96, Aardvark Avenue', NULL, N'Birmingham', N'B2 8UH', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0004', N'WunderKar', N'AlexanderPlatz 205', NULL, N'Berlin', NULL, N'DE        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0005', N'Casseroles Chromes', N'29, Rue Gigondas', NULL, N'Lyon', NULL, N'FR        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0006', N'Le Luxe en Motion', N'Avenue des Indes, 26', NULL, N'Geneva', N'CH-1201', N'CH        ', 1, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0007', N'Eat My Exhaust Ltd', N'29, Kop Hill', NULL, N'Liverpool', N'L1 8UY', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0008', N'M. Pierre Dubois', N'14, Rue De La Hutte', NULL, N'Marseille', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0009', N'Sondra Horowitz', N'10040 Great Western Road', NULL, N'Los Angeles', NULL, N'US        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0010', N'Wonderland Wheels', N'57, Grosvenor Estate Avenue', NULL, N'London', N'E7 4BR', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0011', N'London Executive Prestige Vehicles', N'199, Park Lane', NULL, N'London', N'NW1 0AK', N'GB        ', 1, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0012', N'Glittering Prize Cars Ltd', N'46, Golders Green Road', N'PO Box 27', N'London', N'E17 9IK', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0013', N'La Bagnole de Luxe', N'890 Place de la Concorde', N'Cedex 8', N'Paris', NULL, N'FR        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0014', N'Convertible Dreams', N'31, Archbishop Ave', NULL, N'London', N'SW2 6PL', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0015', N'Alexei Tolstoi', N'83, Abbey Road', NULL, N'London', N'N4 2CV', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0016', N'SuperSport S.A.R.L.', N'210 Place de la Republique', NULL, N'Paris', NULL, N'FR        ', 1, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0017', N'Theo Kowalski', N'1000 East 51st Street', NULL, N'New York', NULL, N'US        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0018', N'Peter McLuckie', N'73, Entwhistle Street', NULL, N'London', N'W10 BN', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0019', N'Posh Vehicles Ltd', N'82, Millar Close', NULL, N'Manchester', N'M4 5SD', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0020', N'Jason B. Wight', N'5300 Star Boulevard', NULL, N'Washington', NULL, N'US        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0021', N'Silver HubCaps', N'54, Didsbury Lane', NULL, N'Manchester', N'M1 7TH', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0022', N'Stan Collywobble', N'65, Townsend Road', NULL, N'Manchester', N'M1 5HJ', N'GB        ', 0, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0023', N'Glitz', N'FriedrichStrasse 579', NULL, N'Stuttgart', NULL, N'DE        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0024', N'Matterhorn Motors', N'1, Rue de la Colline', NULL, N'Lausanne', NULL, N'CH        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0025', N'King Leer Cars', N'87, Lindisfarne Road', NULL, N'Newcastle', N'NE1 4OX', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0026', N'Honest Pete Motors', N'76, Williams Street', NULL, N'Stoke', N'ST3 9XY', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0027', N'Peter Smith', N'82, Ell Pie Lane', NULL, N'Birmingham', N'B5 5SD', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0028', N'Vive La Vitesse', N'56, Rue Noiratre', NULL, N'Marseille', NULL, N'FR        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0029', N'Liverpool Executive Prestige Vehicles', N'8, Everton Avenue', NULL, N'Liverpool', N'L2 2RD', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0030', N'Mrs. Ivana Telford', N'52, Gerrard Mansions', NULL, N'Liverpool', N'L2 9RT', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0031', N'Kieran O''Harris', N'71, Askwith Ave', NULL, N'Liverpool', N'L7 6OP', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0032', N'Prestige Imports', N'Gran Via 26', NULL, N'Barcelona', N'08120', N'ES        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0033', N'Prestissimo!', N'Via Appia 239', NULL, N'Milan', NULL, N'IT        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0034', N'Diplomatic Cars', N'Rue Des Coteaux, 39', NULL, N'Brussels', NULL, N'BE        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0035', N'Laurent Saint Yves', N'49, Rue Quicampoix', NULL, N'Marseille', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0036', N'Screamin'' Wheels', N'1090 Reagan Road', NULL, N'Los Angeles', NULL, N'US        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0037', N'Screamin'' Wheels', N'4, Churchill Close', NULL, N'London', N'SE1 5RU', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0038', N'Executive Motor Delight', N'17, The Brambles', NULL, N'London', N'SE17 6AD', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0039', N'Alicia Almodovar', N'Palacia Del Sol', NULL, N'Barcelona', N'08400', N'ES        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0040', N'Ronaldo Bianco', N'Palazzo Medusa 2000', NULL, N'Milan', NULL, N'IT        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0041', N'Sport.Car', N'Via Barberini 59', NULL, N'Rome', N'00120', N'IT        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0042', N'Autos Sportivos', N'Paseo del Prado, 270', NULL, N'Madrid', NULL, N'ES        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0043', N'Le Luxe en Motion', N'32, Allee de la Paix', NULL, N'Paris', NULL, N'FR        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0044', N'Screamin'' Wheels Corp', N'50000 Fifth Avenue', NULL, N'New York', NULL, N'US        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0045', N'Pierre Blanc', N'52 Deirdre Lane', NULL, N'London', N'C1 3EJ', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0046', N'Capots Reluisants S.A.', N'567 rue Lafayette', NULL, N'Paris', NULL, N'FR        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0047', N'Stefano DiLonghi', N'Piazza Verona', NULL, N'Rome', N'00129', N'IT        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0048', N'Antonio Maura', N'Puerta del Sol, 45', NULL, N'Madrid', NULL, N'ES        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0049', N'Stefan Van Helsing', N'Nieuwstraat 5', NULL, N'Brussels', NULL, N'BE        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0050', N'Mme Anne Duport', N'90, Place de la Victoire 1945', NULL, N'Paris', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0051', N'Screamin'' Wheels', N'10500 The Potomac', NULL, N'Washington', NULL, N'US        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0052', N'Clubbing Cars', N'91, Acid Avenue', NULL, N'Manchester', N'M5 9RD', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0053', N'Jean-Yves Truffaut', N'87 Rue du Combat', NULL, N'Paris', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0054', N'Mr. Evan Telford', N'7, Godzilla Street', NULL, N'Manchester', N'M2 6KL', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0055', N'Ralph Obermann', N'BerolinaStrasse 210', NULL, N'Berlin', NULL, N'DE        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0056', N'ImpressTheNeighbours.Com', N'47, Edgbaston Row', NULL, N'Birmingham', N'B4 4RY', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0057', N'Wladimir Lacroix', N'3, Rue de la Vie en Rose', NULL, N'Lyon', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0058', N'Raimondo Delattre', N'9, Place de Chatelet', NULL, N'Geneva', N'CH-1211', N'CH        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0059', N'Boris Spry', N'53, Odeon Way', NULL, N'Birmingham', N'B1 4BZ', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0060', N'Andrea Tarbuck', N'2,Newcastle Lane', NULL, N'Birmingham', N'B4 8SG', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0061', N'Beltway Prestige Driving', N'1, Smithy Close', NULL, N'Liverpool', N'L1 WS', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0062', N'Bling Motors', N'2, Arndale Lane', NULL, N'Liverpool', N'L3 QS', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0063', N'Smooth Rocking Chrome', N'Via Stromboli 2', NULL, N'Milan', NULL, N'IT        ', 1, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0064', N'YO! Speed!', N'Plaza Mayor', NULL, N'Barcelona', N'08550', N'ES        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0065', N'Stephany Rousso', N'10180 Orange County Place', NULL, N'Los Angeles', NULL, N'US        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0066', N'My Shiny Sports Car Ltd.', N'1091, Cambride Street', NULL, N'London', N'W1 3GH', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0067', N'Flash Voitures', N'Place Anspach 85', NULL, N'Brussels', NULL, N'BE        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0068', N'Paul Blasio', N'50500 JFK Square', NULL, N'New York', NULL, N'US        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0069', N'Mary Blackhouse', N'260, Oxford Avenue', NULL, N'London', N'E1 9AP', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0070', N'Maurice Dujardin', N'10, Daltrey Lane', NULL, N'London', N'NW1 7YU', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0071', N'Leslie Whittington', N'17, Mercury Street', NULL, N'London', N'SE1 4AT', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0072', N'Mike Beeton', N'Green Plaza Place', NULL, N'London', N'SW13 7ED', N'GB        ', 0, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0073', N'Melissa Bertrand', N'7, Westlands Street', NULL, N'London', N'NW10 2SG', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0074', N'El Sport', N'Plaza San Andres', NULL, N'Madrid', NULL, N'ES        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0075', N'Bling Bling S.A.', N'7, Place de la Richesse', N'Z.I Les Arnaques', N'Paris', NULL, N'FR        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0076', N'Bravissima!', N'Via Rosso, 34', NULL, N'Rome', N'00175', N'IT        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0077', N'Jayden Jones', N'10500 Lincoln Square', NULL, N'Washington', NULL, N'US        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0078', N'Expensive Shine', N'89, Abbots Lane', NULL, N'Manchester', N'M17 3EF', N'GB        ', 1, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0079', N'Steve Docherty', N'5, Albermarle Avenue', NULL, N'Manchester', N'M7 9AS', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0080', N'Rodolph Legler', N'SingerStrasse 89', NULL, N'Stuttgart', NULL, N'DE        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0081', N'Pete Spring', N'53, Pimlico Square', NULL, N'Manchester', N'M3 4WR', N'GB        ', 0, 1)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0082', N'Khader El Ghannam', N'10, rue de Jemappes', N'4eme etage', N'Paris', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0083', N'Jacques Mitterand', N'1 Quai des Pertes', NULL, N'Paris', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0084', N'Francoise LeBrun', N'56, Rue Verte', NULL, N'Lausanne', NULL, N'CH        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0085', N'Alex McWhirter', N'89, Harlequin Road', NULL, N'Newcastle', N'NE1 7DH', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0086', N'Francois Chirac', N'2, Quai de l''Enfer', NULL, N'Paris', NULL, N'FR        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0087', N'Andy Cheshire', N'7, Wedgewood Steet', NULL, N'Stoke', N'ST4 2OZ', N'GB        ', 0, 0)
GO
INSERT [Data].[Customer] ([CustomerID], [CustomerName], [Address1], [Address2], [Town], [PostCode], [Country], [IsReseller], [IsCreditRisk]) VALUES (N'0088', N'Jimmy McFiddler', N'57, Smile Square', NULL, N'Glasgow', N'G15 1AA', N'GB        ', 1, 1)
GO
SET IDENTITY_INSERT [Data].[Make] ON 
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (1, N'Ferrari', N'ITA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (2, N'Porsche', N'GER')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (3, N'Lamborghini', N'ITA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (4, N'Aston Martin', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (5, N'Bentley', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (6, N'Rolls Royce', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (7, N'Maybach', N'GER')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (8, N'Mercedes', N'GER')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (9, N'Alfa Romeo', N'ITA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (10, N'Austin', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (11, N'BMW', N'GER')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (12, N'Bugatti', N'FRA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (13, N'Citroen', N'FRA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (14, N'Delahaye', N'FRA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (15, N'Delorean', N'USA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (16, N'Jaguar', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (17, N'Lagonda', N'ITA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (18, N'McLaren', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (19, N'Morgan', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (20, N'Noble', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (21, N'Triumph', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (22, N'Trabant', N'GER')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (23, N'Peugeot', N'GER')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (24, N'Reliant', N'FRA')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (25, N'Riley', N'GBR')
GO
INSERT [Data].[Make] ([MakeID], [MakeName], [MakeCountry]) VALUES (26, N'Cadillac', N'USA')
GO
SET IDENTITY_INSERT [Data].[Make] OFF
GO
SET IDENTITY_INSERT [Data].[Model] ON 
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (1, 1, N'Daytona', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (2, 1, N'Testarossa', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (3, 1, N'355', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (4, 1, N'308', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (5, 1, N'Dino', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (6, 1, N'Mondial', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (7, 1, N'F40', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (8, 1, N'F50', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (9, 1, N'360', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (10, 1, N'Enzo', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (11, 2, N'911', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (12, 2, N'924', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (13, 2, N'944', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (14, 2, N'959', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (15, 2, N'928', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (16, 2, N'Boxster', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (17, 3, N'Countach', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (18, 3, N'Diabolo', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (19, 3, N'Jarama', NULL, N'1970', N'1976')
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (20, 3, N'400GT', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (21, 4, N'DB2', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (22, 4, N'DB4', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (23, 4, N'DB5', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (24, 4, N'DB6', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (25, 4, N'DB9', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (26, 4, N'Virage', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (27, 4, N'Vantage', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (28, 4, N'Vanquish', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (29, 4, N'Rapide', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (30, 5, N'Mulsanne', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (31, 5, N'Continental', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (32, 5, N'Flying Spur', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (33, 5, N'Arnage', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (34, 5, N'Brooklands', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (35, 6, N'Phantom', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (36, 6, N'Ghost', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (37, 6, N'Wraith', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (38, 6, N'Silver Shadow', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (39, 6, N'Corniche', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (40, 6, N'Camargue', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (41, 6, N'Silver Seraph', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (42, 7, N'57', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (43, 7, N'62', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (44, 7, N'Exelero', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (45, 8, N'280SL', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (46, 8, N'350SL', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (47, 8, N'500SL', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (48, 8, N'250SL', N'Sports Pagoda', NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (49, 8, N'R107', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (50, 8, N'W107', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (51, 9, N'Giulia', N'Sprint', NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (52, 9, N'Spider', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (53, 9, N'1750', N'GTV', NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (54, 9, N'Giulietta', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (55, 10, N'Lichfield', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (56, 10, N'Princess', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (57, 10, N'Cambridge', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (58, 11, N'Isetta', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (59, 11, N'Alpina', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (60, 11, N'E30', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (61, 12, N'35', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (62, 12, N'Veyron', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (63, 12, N'57C', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (64, 13, N'Torpedo', N'', NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (65, 13, N'Rosalie', N'Coupe', NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (66, 13, N'Traaction Avant', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (67, 14, N'135', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (68, 14, N'145', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (69, 14, N'175', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (70, 15, N'DMC 12', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (71, 16, N'Mark V', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (72, 16, N'Mark X', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (73, 16, N'XJ12', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (74, 16, N'XK120', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (75, 16, N'XK150', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (76, 16, N'XJS', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (77, 16, N'E-Type', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (78, 17, N'V12', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (79, 17, N'3 Litre', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (80, 18, N'P1', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (81, 19, N'Plus 8', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (82, 19, N'Plus 4', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (83, 19, N'Supersport', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (84, 20, N'M14', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (85, 20, N'M600', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (86, 21, N'TR4', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (87, 21, N'TR5', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (88, 21, N'TR6', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (89, 21, N'TR7', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (90, 21, N'GT6', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (91, 21, N'Roadster', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (92, 21, N'Stag', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (93, 21, N'TR3A', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (94, 22, N'500', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (95, 22, N'600', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (96, 23, N'205', N'GTI', NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (97, 23, N'Type VA', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (98, 23, N'404', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (99, 23, N'203', NULL, NULL, NULL)
GO
INSERT [Data].[Model] ([ModelID], [MakeID], [ModelName], [ModelVariant], [YearFirstProduced], [YearLastProduced]) VALUES (100, 24, N'Robin', NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [Data].[Model] OFF
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Black', CAST(374490.00 AS Numeric(38, 2)), CAST(1251410.00 AS Numeric(38, 2)), CAST(3112550.00 AS Numeric(38, 2)), CAST(1983695.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Blue', CAST(284600.00 AS Numeric(38, 2)), CAST(423650.00 AS Numeric(38, 2)), CAST(708420.00 AS Numeric(38, 2)), CAST(1186400.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'British Racing Green', CAST(111500.00 AS Numeric(38, 2)), CAST(663250.00 AS Numeric(38, 2)), CAST(872340.00 AS Numeric(38, 2)), CAST(566385.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Canary Yellow', CAST(132000.00 AS Numeric(38, 2)), CAST(287070.00 AS Numeric(38, 2)), CAST(104750.00 AS Numeric(38, 2)), CAST(134045.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Dark Purple', NULL, CAST(283000.00 AS Numeric(38, 2)), CAST(219175.00 AS Numeric(38, 2)), CAST(662640.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Green', CAST(216600.00 AS Numeric(38, 2)), CAST(370750.00 AS Numeric(38, 2)), CAST(655090.00 AS Numeric(38, 2)), CAST(599540.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Night Blue', CAST(57990.00 AS Numeric(38, 2)), CAST(405500.00 AS Numeric(38, 2)), CAST(457500.00 AS Numeric(38, 2)), CAST(600830.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Pink', NULL, CAST(235950.00 AS Numeric(38, 2)), CAST(54700.00 AS Numeric(38, 2)), CAST(191600.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Red', CAST(154795.00 AS Numeric(38, 2)), CAST(442500.00 AS Numeric(38, 2)), CAST(659150.00 AS Numeric(38, 2)), CAST(932450.00 AS Numeric(38, 2)))
GO
INSERT [Data].[PivotTable] ([Color], [2015], [2016], [2017], [2018]) VALUES (N'Silver', CAST(89000.00 AS Numeric(38, 2)), CAST(542205.00 AS Numeric(38, 2)), CAST(1093900.00 AS Numeric(38, 2)), CAST(926030.00 AS Numeric(38, 2)))
GO
SET IDENTITY_INSERT [Data].[Sales] ON 
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (1, N'0001', N'GBPGB001', CAST(65000.00 AS Numeric(18, 2)), CAST(N'2015-01-02T08:00:00.000' AS DateTime), 1)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (2, N'0002', N'GBPGB002', CAST(220000.10 AS Numeric(18, 2)), CAST(N'2015-01-25T00:00:00.000' AS DateTime), 2)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (3, N'0003', N'GBPGB003', CAST(19500.00 AS Numeric(18, 2)), CAST(N'2015-02-03T10:00:00.000' AS DateTime), 3)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (4, N'0004', N'EURDE004', CAST(11500.00 AS Numeric(18, 2)), CAST(N'2015-02-16T08:00:00.000' AS DateTime), 4)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (5, N'0005', N'EURFR005', CAST(19900.00 AS Numeric(18, 2)), CAST(N'2015-01-02T10:33:00.000' AS DateTime), 5)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (6, N'0001', N'GBPGB006', CAST(29500.00 AS Numeric(18, 2)), CAST(N'2015-03-14T00:00:00.000' AS DateTime), 6)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (7, N'0003', N'GBPGB007', CAST(49500.20 AS Numeric(18, 2)), CAST(N'2015-03-24T00:00:00.000' AS DateTime), 7)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (8, N'0007', N'GBPGB008', CAST(76000.90 AS Numeric(18, 2)), CAST(N'2015-03-30T00:00:00.000' AS DateTime), 8)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (9, N'0008', N'EURFR009', CAST(19600.00 AS Numeric(18, 2)), CAST(N'2015-04-06T00:00:00.000' AS DateTime), 9)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (10, N'0009', N'USDUS010', CAST(36500.00 AS Numeric(18, 2)), CAST(N'2015-04-04T00:00:00.000' AS DateTime), 10)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (11, N'0010', N'GBPGB011', CAST(89000.00 AS Numeric(18, 2)), CAST(N'2015-04-30T00:00:00.000' AS DateTime), 11)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (12, N'0011', N'GBPGB012', CAST(169500.00 AS Numeric(18, 2)), CAST(N'2015-05-10T00:00:00.000' AS DateTime), 12)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (13, N'0008', N'EURFR013', CAST(8950.00 AS Numeric(18, 2)), CAST(N'2015-05-20T00:00:00.000' AS DateTime), 13)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (14, N'0012', N'GBPGB014', CAST(195000.00 AS Numeric(18, 2)), CAST(N'2015-05-28T00:00:00.000' AS DateTime), 14)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (15, N'0013', N'EURFR015', CAST(22950.00 AS Numeric(18, 2)), CAST(N'2015-06-04T16:37:00.000' AS DateTime), 15)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (16, N'0014', N'GBPGB016', CAST(8695.00 AS Numeric(18, 2)), CAST(N'2015-07-12T10:00:00.000' AS DateTime), 16)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (17, N'0015', N'GBPGB017', CAST(22990.00 AS Numeric(18, 2)), CAST(N'2015-07-15T00:00:00.000' AS DateTime), 17)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (18, N'0016', N'EURFR018', CAST(75500.00 AS Numeric(18, 2)), CAST(N'2015-07-25T00:00:00.000' AS DateTime), 18)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (19, N'0017', N'USDUS019', CAST(5500.00 AS Numeric(18, 2)), CAST(N'2015-08-02T08:00:00.000' AS DateTime), 19)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (20, N'0018', N'GBPGB020', CAST(12650.00 AS Numeric(18, 2)), CAST(N'2015-09-05T00:00:00.000' AS DateTime), 20)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (21, N'0019', N'GBPGB021', CAST(8950.00 AS Numeric(18, 2)), CAST(N'2015-09-15T10:00:00.000' AS DateTime), 21)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (22, N'0018', N'GBPGB022', CAST(15600.00 AS Numeric(18, 2)), CAST(N'2015-09-15T00:00:00.000' AS DateTime), 22)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (23, N'0015', N'GBPGB023', CAST(22600.00 AS Numeric(18, 2)), CAST(N'2015-10-30T00:00:00.000' AS DateTime), 23)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (24, N'0017', N'USDUS024', CAST(123590.00 AS Numeric(18, 2)), CAST(N'2015-10-30T00:00:00.000' AS DateTime), 24)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (25, N'0014', N'GBPGB025', CAST(22950.00 AS Numeric(18, 2)), CAST(N'2015-11-10T00:00:00.000' AS DateTime), 25)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (26, N'0015', N'GBPGB026', CAST(69500.00 AS Numeric(18, 2)), CAST(N'2015-12-01T08:00:00.000' AS DateTime), 26)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (27, N'0006', N'GBPCH027', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime), 27)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (28, N'0007', N'GBPGB028', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime), 28)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (29, N'0009', N'USDUS029', CAST(159500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime), 29)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (30, N'0010', N'GBPGB030', CAST(165000.00 AS Numeric(18, 2)), CAST(N'2016-01-01T08:00:00.000' AS DateTime), 30)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (31, N'0008', N'EURFR031', CAST(2550.00 AS Numeric(18, 2)), CAST(N'2016-01-07T00:00:00.000' AS DateTime), 31)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (32, N'0019', N'GBPGB032', CAST(29500.00 AS Numeric(18, 2)), CAST(N'2016-01-07T00:00:00.000' AS DateTime), 32)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (33, N'0020', N'USDUS033', CAST(12650.00 AS Numeric(18, 2)), CAST(N'2016-01-09T00:00:00.000' AS DateTime), 33)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (34, N'0021', N'GBPGB034', CAST(56950.00 AS Numeric(18, 2)), CAST(N'2016-01-22T00:00:00.000' AS DateTime), 34)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (35, N'0022', N'GBPGB035', CAST(56000.00 AS Numeric(18, 2)), CAST(N'2016-02-22T00:00:00.000' AS DateTime), 35)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (36, N'0023', N'EURDE036', CAST(71890.00 AS Numeric(18, 2)), CAST(N'2016-02-17T00:00:00.000' AS DateTime), 36)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (37, N'0016', N'EURFR037', CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-02-16T00:00:00.000' AS DateTime), 37)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (38, N'0001', N'GBPGB038', CAST(3650.00 AS Numeric(18, 2)), CAST(N'2016-02-28T10:10:00.000' AS DateTime), 38)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (39, N'0024', N'GBPCH039', CAST(220500.00 AS Numeric(18, 2)), CAST(N'2016-03-20T00:00:00.000' AS DateTime), 39)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (40, N'0025', N'GBPGB040', CAST(102950.00 AS Numeric(18, 2)), CAST(N'2016-04-05T00:00:00.000' AS DateTime), 40)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (41, N'0020', N'USDUS041', CAST(17500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime), 41)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (42, N'0021', N'GBPGB042', CAST(8800.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime), 42)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (43, N'0023', N'EURDE043', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime), 43)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (44, N'0021', N'GBPGB044', CAST(17500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T11:27:00.000' AS DateTime), 44)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (45, N'0010', N'GBPGB045', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime), 45)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (46, N'0015', N'GBPGB046', CAST(49450.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime), 46)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (47, N'0016', N'EURFR047', CAST(49580.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime), 47)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (48, N'0008', N'EURFR048', CAST(5500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime), 48)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (49, N'0026', N'GBPGB049', CAST(22150.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime), 49)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (50, N'0027', N'GBPGB050', CAST(35000.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime), 50)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (51, N'0028', N'EURFR051', CAST(174650.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime), 51)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (52, N'0029', N'GBPGB052', CAST(15650.00 AS Numeric(18, 2)), CAST(N'2016-07-01T08:00:00.000' AS DateTime), 52)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (53, N'0020', N'USDUS053', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-07-06T00:00:00.000' AS DateTime), 53)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (54, N'0030', N'GBPGB054', CAST(195000.00 AS Numeric(18, 2)), CAST(N'2016-07-25T10:00:00.000' AS DateTime), 54)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (55, N'0015', N'GBPGB055', CAST(205000.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime), 55)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (56, N'0014', N'GBPGB056', CAST(66500.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime), 56)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (57, N'0031', N'GBPGB057', CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime), 57)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (58, N'0032', N'EURES058', CAST(79500.00 AS Numeric(18, 2)), CAST(N'2016-07-26T00:00:00.000' AS DateTime), 58)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (59, N'0033', N'EURIT059', CAST(14590.00 AS Numeric(18, 2)), CAST(N'2016-07-26T10:00:00.000' AS DateTime), 59)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (60, N'0032', N'EURES060', CAST(12750.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime), 60)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (61, N'0022', N'GBPGB061', CAST(45600.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime), 61)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (62, N'0021', N'GBPGB062', CAST(6500.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime), 62)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (63, N'0015', N'GBPGB063', CAST(102500.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime), 63)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (64, N'0016', N'EURFR064', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-08-09T00:00:00.000' AS DateTime), 64)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (65, N'0014', N'GBPGB065', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-08-10T00:00:00.000' AS DateTime), 65)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (66, N'0004', N'EURDE066', CAST(61500.00 AS Numeric(18, 2)), CAST(N'2016-08-12T10:00:00.000' AS DateTime), 66)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (67, N'0006', N'GBPCH067', CAST(79500.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime), 67)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (68, N'0018', N'GBPGB068', CAST(50100.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime), 68)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (69, N'0005', N'EURFR069', CAST(66500.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime), 69)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (70, N'0033', N'EURIT070', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2016-08-19T00:00:00.000' AS DateTime), 70)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (71, N'0023', N'EURDE071', CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-08-19T00:00:00.000' AS DateTime), 71)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (72, N'0021', N'GBPGB072', CAST(76500.00 AS Numeric(18, 2)), CAST(N'2016-08-21T00:00:00.000' AS DateTime), 72)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (73, N'0014', N'GBPGB073', CAST(45900.00 AS Numeric(18, 2)), CAST(N'2016-08-22T08:00:00.000' AS DateTime), 73)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (74, N'0034', N'EURBE074', CAST(125000.00 AS Numeric(18, 2)), CAST(N'2016-08-23T00:00:00.000' AS DateTime), 74)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (75, N'0035', N'EURFR075', CAST(65500.00 AS Numeric(18, 2)), CAST(N'2016-08-24T00:00:00.000' AS DateTime), 75)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (76, N'0036', N'USDUS076', CAST(92150.00 AS Numeric(18, 2)), CAST(N'2016-08-25T00:00:00.000' AS DateTime), 76)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (77, N'0037', N'GBPGB077', CAST(9500.00 AS Numeric(18, 2)), CAST(N'2016-08-28T00:00:00.000' AS DateTime), 77)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (78, N'0033', N'EURIT078', CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-08-28T00:00:00.000' AS DateTime), 78)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (79, N'0025', N'GBPGB079', CAST(5680.00 AS Numeric(18, 2)), CAST(N'2016-08-29T00:00:00.000' AS DateTime), 79)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (80, N'0024', N'GBPCH080', CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-08-30T00:00:00.000' AS DateTime), 80)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (81, N'0015', N'GBPGB081', CAST(3500.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime), 81)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (82, N'0006', N'GBPCH082', CAST(3950.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime), 82)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (83, N'0019', N'GBPGB083', CAST(20950.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime), 83)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (84, N'0003', N'GBPGB084', CAST(7500.00 AS Numeric(18, 2)), CAST(N'2016-09-06T00:00:00.000' AS DateTime), 84)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (85, N'0002', N'GBPGB085', CAST(56500.00 AS Numeric(18, 2)), CAST(N'2016-09-07T00:00:00.000' AS DateTime), 85)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (86, N'0022', N'GBPGB086', CAST(49500.00 AS Numeric(18, 2)), CAST(N'2016-09-07T00:00:00.000' AS DateTime), 86)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (87, N'0032', N'EURES087', CAST(68900.00 AS Numeric(18, 2)), CAST(N'2016-09-11T00:00:00.000' AS DateTime), 87)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (88, N'0001', N'GBPGB088', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2016-09-11T00:00:00.000' AS DateTime), 88)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (89, N'0008', N'EURFR089', CAST(3575.00 AS Numeric(18, 2)), CAST(N'2016-09-14T00:00:00.000' AS DateTime), 89)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (90, N'0012', N'GBPGB090', CAST(35250.00 AS Numeric(18, 2)), CAST(N'2016-09-14T00:00:00.000' AS DateTime), 90)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (91, N'0013', N'EURFR091', CAST(47490.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime), 91)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (92, N'0015', N'GBPGB092', CAST(45950.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime), 92)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (93, N'0025', N'GBPGB093', CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-09-18T00:00:00.000' AS DateTime), 93)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (94, N'0026', N'GBPGB094', CAST(163050.00 AS Numeric(18, 2)), CAST(N'2016-09-19T00:00:00.000' AS DateTime), 94)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (95, N'0022', N'GBPGB095', CAST(76500.00 AS Numeric(18, 2)), CAST(N'2016-10-05T00:00:00.000' AS DateTime), 95)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (96, N'0032', N'EURES096', CAST(119600.00 AS Numeric(18, 2)), CAST(N'2016-10-05T10:00:00.000' AS DateTime), 96)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (97, N'0038', N'GBPGB097', CAST(95600.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime), 97)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (98, N'0039', N'EURES098', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime), 98)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (99, N'0040', N'EURIT099', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime), 99)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (100, N'0003', N'GBPGB100', CAST(56890.00 AS Numeric(18, 2)), CAST(N'2016-11-03T00:00:00.000' AS DateTime), 100)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (101, N'0012', N'GBPGB101', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2016-11-04T00:00:00.000' AS DateTime), 101)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (102, N'0026', N'GBPGB102', CAST(191490.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime), 102)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (103, N'0033', N'EURIT103', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime), 103)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (104, N'0013', N'EURFR104', CAST(60500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime), 104)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (105, N'0014', N'GBPGB105', CAST(123500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime), 105)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (106, N'0023', N'EURDE106', CAST(25000.00 AS Numeric(18, 2)), CAST(N'2016-12-08T00:00:00.000' AS DateTime), 106)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (107, N'0028', N'EURFR107', CAST(169500.00 AS Numeric(18, 2)), CAST(N'2016-12-20T00:00:00.000' AS DateTime), 107)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (108, N'0029', N'GBPGB108', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-12-28T00:00:00.000' AS DateTime), 108)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (109, N'0039', N'EURES109', CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-12-31T10:00:00.000' AS DateTime), 109)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (110, N'0028', N'EURFR110', CAST(22500.00 AS Numeric(18, 2)), CAST(N'2017-01-01T11:12:00.000' AS DateTime), 110)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (111, N'0027', N'GBPGB111', CAST(125000.00 AS Numeric(18, 2)), CAST(N'2017-01-05T11:55:00.000' AS DateTime), 111)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (112, N'0007', N'GBPGB112', CAST(85000.00 AS Numeric(18, 2)), CAST(N'2017-01-10T15:56:00.000' AS DateTime), 112)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (113, N'0013', N'EURFR113', CAST(1250.00 AS Numeric(18, 2)), CAST(N'2017-01-21T13:56:00.000' AS DateTime), 113)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (114, N'0006', N'GBPCH114', CAST(22500.00 AS Numeric(18, 2)), CAST(N'2017-01-11T17:52:00.000' AS DateTime), 114)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (115, N'0001', N'GBPGB115', CAST(125950.00 AS Numeric(18, 2)), CAST(N'2017-01-12T18:57:00.000' AS DateTime), 115)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (116, N'0006', N'GBPCH116', CAST(8850.00 AS Numeric(18, 2)), CAST(N'2017-01-13T19:58:00.000' AS DateTime), 116)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (117, N'0019', N'GBPGB117', CAST(9950.00 AS Numeric(18, 2)), CAST(N'2017-01-14T09:58:00.000' AS DateTime), 117)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (118, N'0028', N'EURFR118', CAST(56500.00 AS Numeric(18, 2)), CAST(N'2017-01-30T10:59:00.000' AS DateTime), 118)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (119, N'0037', N'GBPGB119', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2017-01-31T09:59:00.000' AS DateTime), 119)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (120, N'0026', N'GBPGB120', CAST(56950.00 AS Numeric(18, 2)), CAST(N'2017-01-31T12:00:00.000' AS DateTime), 120)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (121, N'0028', N'EURFR121', CAST(365000.00 AS Numeric(18, 2)), CAST(N'2017-02-07T20:00:00.000' AS DateTime), 121)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (122, N'0035', N'EURFR122', CAST(395000.00 AS Numeric(18, 2)), CAST(N'2017-02-08T13:01:00.000' AS DateTime), 122)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (123, N'0036', N'USDUS123', CAST(21500.00 AS Numeric(18, 2)), CAST(N'2017-02-09T17:01:00.000' AS DateTime), 123)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (124, N'0037', N'GBPGB124', CAST(6500.00 AS Numeric(18, 2)), CAST(N'2017-02-10T11:02:00.000' AS DateTime), 124)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (125, N'0034', N'EURBE125', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-02-12T16:02:00.000' AS DateTime), 125)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (126, N'0001', N'GBPGB126', CAST(2250.00 AS Numeric(18, 2)), CAST(N'2017-02-14T14:03:00.000' AS DateTime), 126)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (127, N'0011', N'GBPGB127', CAST(3500.00 AS Numeric(18, 2)), CAST(N'2017-03-05T18:03:00.000' AS DateTime), 127)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (128, N'0012', N'GBPGB128', CAST(5680.00 AS Numeric(18, 2)), CAST(N'2017-03-05T19:04:00.000' AS DateTime), 128)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (129, N'0016', N'EURFR129', CAST(8550.00 AS Numeric(18, 2)), CAST(N'2017-03-05T14:04:00.000' AS DateTime), 129)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (130, N'0026', N'GBPGB130', CAST(156500.00 AS Numeric(18, 2)), CAST(N'2017-03-10T20:05:00.000' AS DateTime), 130)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (131, N'0025', N'GBPGB131', CAST(56500.00 AS Numeric(18, 2)), CAST(N'2017-03-10T16:05:00.000' AS DateTime), 131)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (132, N'0034', N'EURBE132', CAST(86500.00 AS Numeric(18, 2)), CAST(N'2017-03-12T17:06:00.000' AS DateTime), 132)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (133, N'0001', N'GBPGB133', CAST(66500.00 AS Numeric(18, 2)), CAST(N'2017-03-12T20:06:00.000' AS DateTime), 133)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (134, N'0005', N'EURFR134', CAST(55600.00 AS Numeric(18, 2)), CAST(N'2017-03-25T10:07:00.000' AS DateTime), 134)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (135, N'0023', N'EURDE135', CAST(305000.00 AS Numeric(18, 2)), CAST(N'2017-03-30T13:07:00.000' AS DateTime), 135)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (136, N'0028', N'EURFR136', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-03-31T13:08:00.000' AS DateTime), 136)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (137, N'0029', N'GBPGB137', CAST(225000.00 AS Numeric(18, 2)), CAST(N'2017-03-31T16:08:00.000' AS DateTime), 137)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (138, N'0037', N'GBPGB138', CAST(42950.00 AS Numeric(18, 2)), CAST(N'2017-03-31T18:09:00.000' AS DateTime), 138)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (139, N'0031', N'GBPGB139', CAST(990.00 AS Numeric(18, 2)), CAST(N'2017-03-31T14:09:00.000' AS DateTime), 139)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (140, N'0032', N'EURES140', CAST(29500.00 AS Numeric(18, 2)), CAST(N'2017-04-05T20:10:00.000' AS DateTime), 140)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (141, N'0035', N'EURFR141', CAST(139500.00 AS Numeric(18, 2)), CAST(N'2017-04-06T19:10:00.000' AS DateTime), 141)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (142, N'0026', N'GBPGB142', CAST(295000.00 AS Numeric(18, 2)), CAST(N'2017-04-07T12:11:00.000' AS DateTime), 142)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (143, N'0028', N'EURFR143', CAST(220500.00 AS Numeric(18, 2)), CAST(N'2017-04-07T12:11:00.000' AS DateTime), 143)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (144, N'0029', N'GBPGB144', CAST(79500.00 AS Numeric(18, 2)), CAST(N'2017-05-01T17:12:00.000' AS DateTime), 144)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (145, N'0027', N'GBPGB145', CAST(162500.00 AS Numeric(18, 2)), CAST(N'2017-05-01T10:12:00.000' AS DateTime), 145)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (146, N'0041', N'EURIT146', CAST(79500.00 AS Numeric(18, 2)), CAST(N'2017-05-09T18:13:00.000' AS DateTime), 146)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (147, N'0042', N'EURES147', CAST(65890.00 AS Numeric(18, 2)), CAST(N'2017-05-09T12:13:00.000' AS DateTime), 147)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (148, N'0040', N'EURIT148', CAST(61500.00 AS Numeric(18, 2)), CAST(N'2017-05-10T20:14:00.000' AS DateTime), 148)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (149, N'0039', N'EURES149', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-05-10T16:14:00.000' AS DateTime), 149)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (150, N'0001', N'GBPGB150', CAST(255000.00 AS Numeric(18, 2)), CAST(N'2017-05-10T11:15:00.000' AS DateTime), 150)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (151, N'0043', N'EURFR151', CAST(255950.00 AS Numeric(18, 2)), CAST(N'2017-05-12T13:15:00.000' AS DateTime), 151)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (152, N'0044', N'USDUS152', CAST(250000.00 AS Numeric(18, 2)), CAST(N'2017-05-13T20:16:00.000' AS DateTime), 152)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (153, N'0033', N'EURIT153', CAST(6500.00 AS Numeric(18, 2)), CAST(N'2017-05-16T16:16:00.000' AS DateTime), 153)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (154, N'0022', N'GBPGB154', CAST(9250.00 AS Numeric(18, 2)), CAST(N'2017-05-19T21:17:00.000' AS DateTime), 154)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (155, N'0011', N'GBPGB155', CAST(950.00 AS Numeric(18, 2)), CAST(N'2017-05-20T14:17:00.000' AS DateTime), 155)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (156, N'0008', N'EURFR156', CAST(295000.00 AS Numeric(18, 2)), CAST(N'2017-05-21T16:18:00.000' AS DateTime), 156)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (157, N'0045', N'GBPGB157', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2017-05-22T11:18:00.000' AS DateTime), 157)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (158, N'0046', N'EURFR158', CAST(33500.00 AS Numeric(18, 2)), CAST(N'2017-05-23T09:19:00.000' AS DateTime), 158)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (159, N'0023', N'EURDE159', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-05-24T17:19:00.000' AS DateTime), 159)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (160, N'0035', N'EURFR160', CAST(114000.00 AS Numeric(18, 2)), CAST(N'2017-05-26T10:20:00.000' AS DateTime), 160)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (161, N'0024', N'GBPCH161', CAST(2350.00 AS Numeric(18, 2)), CAST(N'2017-05-27T21:20:00.000' AS DateTime), 161)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (162, N'0011', N'GBPGB162', CAST(32500.00 AS Numeric(18, 2)), CAST(N'2017-06-01T20:21:00.000' AS DateTime), 162)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (163, N'0019', N'GBPGB163', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-06-01T12:21:00.000' AS DateTime), 163)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (164, N'0006', N'GBPCH164', CAST(8500.00 AS Numeric(18, 2)), CAST(N'2017-06-15T21:22:00.000' AS DateTime), 164)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (165, N'0004', N'EURDE165', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2017-06-15T20:22:00.000' AS DateTime), 165)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (166, N'0047', N'EURIT166', CAST(25000.00 AS Numeric(18, 2)), CAST(N'2017-06-15T16:23:00.000' AS DateTime), 166)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (167, N'0033', N'EURIT167', CAST(19500.00 AS Numeric(18, 2)), CAST(N'2017-06-15T10:23:00.000' AS DateTime), 167)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (168, N'0048', N'EURES168', CAST(12950.00 AS Numeric(18, 2)), CAST(N'2017-06-15T18:24:00.000' AS DateTime), 168)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (169, N'0025', N'GBPGB169', CAST(5650.00 AS Numeric(18, 2)), CAST(N'2017-06-22T18:24:00.000' AS DateTime), 169)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (170, N'0016', N'EURFR170', CAST(29500.00 AS Numeric(18, 2)), CAST(N'2017-06-24T09:25:00.000' AS DateTime), 170)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (171, N'0049', N'EURBE171', CAST(45950.00 AS Numeric(18, 2)), CAST(N'2017-07-01T10:25:00.000' AS DateTime), 171)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (172, N'0050', N'EURFR172', CAST(99950.00 AS Numeric(18, 2)), CAST(N'2017-07-01T18:26:00.000' AS DateTime), 172)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (173, N'0003', N'GBPGB173', CAST(335000.00 AS Numeric(18, 2)), CAST(N'2017-07-03T19:26:00.000' AS DateTime), 173)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (174, N'0008', N'EURFR174', CAST(56500.00 AS Numeric(18, 2)), CAST(N'2017-07-31T20:27:00.000' AS DateTime), 174)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (175, N'0011', N'GBPGB175', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2017-07-31T19:27:00.000' AS DateTime), 175)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (176, N'0016', N'EURFR176', CAST(135000.00 AS Numeric(18, 2)), CAST(N'2017-07-31T17:28:00.000' AS DateTime), 176)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (177, N'0025', N'GBPGB177', CAST(89500.00 AS Numeric(18, 2)), CAST(N'2017-07-31T17:28:00.000' AS DateTime), 177)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (178, N'0024', N'GBPCH178', CAST(165000.00 AS Numeric(18, 2)), CAST(N'2017-08-04T21:29:00.000' AS DateTime), 178)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (179, N'0036', N'USDUS179', CAST(22600.00 AS Numeric(18, 2)), CAST(N'2017-08-04T11:29:00.000' AS DateTime), 179)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (180, N'0046', N'EURFR180', CAST(32675.00 AS Numeric(18, 2)), CAST(N'2017-08-06T14:30:00.000' AS DateTime), 180)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (181, N'0028', N'EURFR181', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-08-07T13:30:00.000' AS DateTime), 181)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (182, N'0021', N'GBPGB182', CAST(5500.00 AS Numeric(18, 2)), CAST(N'2017-08-27T13:31:00.000' AS DateTime), 182)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (183, N'0007', N'GBPGB183', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2017-08-30T19:31:00.000' AS DateTime), 183)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (184, N'0009', N'USDUS184', CAST(49500.00 AS Numeric(18, 2)), CAST(N'2017-09-20T14:32:00.000' AS DateTime), 184)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (185, N'0039', N'EURES185', CAST(250000.00 AS Numeric(18, 2)), CAST(N'2017-09-20T12:32:00.000' AS DateTime), 185)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (186, N'0028', N'EURFR186', CAST(155000.00 AS Numeric(18, 2)), CAST(N'2017-09-20T16:33:00.000' AS DateTime), 186)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (187, N'0017', N'USDUS187', CAST(15750.00 AS Numeric(18, 2)), CAST(N'2017-09-26T10:33:00.000' AS DateTime), 187)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (188, N'0026', N'GBPGB188', CAST(19500.00 AS Numeric(18, 2)), CAST(N'2017-10-15T16:34:00.000' AS DateTime), 188)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (189, N'0035', N'EURFR189', CAST(235000.00 AS Numeric(18, 2)), CAST(N'2017-10-15T18:34:00.000' AS DateTime), 189)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (190, N'0014', N'GBPGB190', CAST(25000.00 AS Numeric(18, 2)), CAST(N'2017-11-01T19:35:00.000' AS DateTime), 190)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (191, N'0047', N'EURIT191', CAST(245000.00 AS Numeric(18, 2)), CAST(N'2017-11-01T12:35:00.000' AS DateTime), 191)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (192, N'0048', N'EURES192', CAST(89000.00 AS Numeric(18, 2)), CAST(N'2017-11-01T17:36:00.000' AS DateTime), 192)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (193, N'0049', N'EURBE193', CAST(34000.00 AS Numeric(18, 2)), CAST(N'2017-11-06T21:36:00.000' AS DateTime), 193)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (194, N'0050', N'EURFR194', CAST(62700.00 AS Numeric(18, 2)), CAST(N'2017-11-12T11:37:00.000' AS DateTime), 194)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (195, N'0002', N'GBPGB195', CAST(45950.00 AS Numeric(18, 2)), CAST(N'2017-12-01T17:37:00.000' AS DateTime), 195)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (196, N'0012', N'GBPGB196', CAST(21600.00 AS Numeric(18, 2)), CAST(N'2017-12-01T21:38:00.000' AS DateTime), 196)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (197, N'0022', N'GBPGB197', CAST(25000.00 AS Numeric(18, 2)), CAST(N'2017-12-05T12:38:00.000' AS DateTime), 197)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (198, N'0023', N'EURDE198', CAST(23600.00 AS Numeric(18, 2)), CAST(N'2017-12-05T11:39:00.000' AS DateTime), 198)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (199, N'0032', N'EURES199', CAST(99950.00 AS Numeric(18, 2)), CAST(N'2017-12-10T10:39:00.000' AS DateTime), 199)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (200, N'0041', N'EURIT200', CAST(46900.00 AS Numeric(18, 2)), CAST(N'2017-12-10T16:40:00.000' AS DateTime), 200)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (201, N'0045', N'GBPGB201', CAST(45950.00 AS Numeric(18, 2)), CAST(N'2017-12-10T17:40:00.000' AS DateTime), 201)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (202, N'0046', N'EURFR202', CAST(7550.00 AS Numeric(18, 2)), CAST(N'2017-12-10T12:41:00.000' AS DateTime), 202)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (203, N'0048', N'EURES203', CAST(11990.00 AS Numeric(18, 2)), CAST(N'2017-12-12T14:41:00.000' AS DateTime), 203)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (204, N'0036', N'USDUS204', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-12-27T17:42:00.000' AS DateTime), 204)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (205, N'0037', N'GBPGB205', CAST(7500.00 AS Numeric(18, 2)), CAST(N'2017-12-27T12:42:00.000' AS DateTime), 205)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (206, N'0025', N'GBPGB206', CAST(56850.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime), 206)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (207, N'0021', N'GBPGB207', CAST(62500.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime), 207)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (208, N'0026', N'GBPGB208', CAST(42500.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime), 208)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (209, N'0051', N'USDUS209', CAST(65450.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime), 209)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (210, N'0052', N'GBPGB210', CAST(56950.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime), 210)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (211, N'0053', N'EURFR211', CAST(1950.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime), 211)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (212, N'0054', N'GBPGB212', CAST(1150.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime), 212)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (213, N'0055', N'EURDE213', CAST(11550.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime), 213)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (214, N'0045', N'GBPGB214', CAST(12570.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime), 214)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (215, N'0046', N'EURFR215', CAST(9890.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime), 215)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (216, N'0012', N'GBPGB216', CAST(56950.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime), 216)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (217, N'0032', N'EURES217', CAST(45950.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime), 217)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (218, N'0049', N'EURBE218', CAST(950.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime), 218)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (219, N'0035', N'EURFR219', CAST(21550.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime), 219)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (220, N'0021', N'GBPGB220', CAST(5950.00 AS Numeric(18, 2)), CAST(N'2018-01-15T00:00:00.000' AS DateTime), 220)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (221, N'0013', N'EURFR221', CAST(355000.00 AS Numeric(18, 2)), CAST(N'2018-01-15T00:00:00.000' AS DateTime), 221)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (222, N'0008', N'EURFR222', CAST(120000.00 AS Numeric(18, 2)), CAST(N'2018-02-10T00:00:00.000' AS DateTime), 222)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (223, N'0006', N'GBPCH223', CAST(121500.00 AS Numeric(18, 2)), CAST(N'2018-02-11T00:00:00.000' AS DateTime), 223)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (224, N'0009', N'USDUS224', CAST(182500.00 AS Numeric(18, 2)), CAST(N'2018-02-12T00:00:00.000' AS DateTime), 224)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (225, N'0056', N'GBPGB225', CAST(22500.00 AS Numeric(18, 2)), CAST(N'2018-02-13T00:00:00.000' AS DateTime), 225)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (226, N'0057', N'EURFR226', CAST(21500.00 AS Numeric(18, 2)), CAST(N'2018-02-14T00:00:00.000' AS DateTime), 226)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (227, N'0046', N'EURFR227', CAST(189500.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime), 227)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (228, N'0058', N'GBPCH228', CAST(55450.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime), 228)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (229, N'0059', N'GBPGB229', CAST(98950.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime), 229)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (230, N'0060', N'GBPGB230', CAST(355000.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime), 230)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (231, N'0028', N'EURFR231', CAST(6000.00 AS Numeric(18, 2)), CAST(N'2018-03-05T00:00:00.000' AS DateTime), 231)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (232, N'0039', N'EURES232', CAST(5690.00 AS Numeric(18, 2)), CAST(N'2018-03-05T00:00:00.000' AS DateTime), 232)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (233, N'0017', N'USDUS233', CAST(56900.00 AS Numeric(18, 2)), CAST(N'2018-03-08T00:00:00.000' AS DateTime), 233)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (234, N'0048', N'EURES234', CAST(368000.00 AS Numeric(18, 2)), CAST(N'2018-03-08T00:00:00.000' AS DateTime), 234)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (235, N'0046', N'EURFR235', CAST(310000.00 AS Numeric(18, 2)), CAST(N'2018-03-15T00:00:00.000' AS DateTime), 235)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (236, N'0045', N'GBPGB236', CAST(9800.00 AS Numeric(18, 2)), CAST(N'2018-03-19T00:00:00.000' AS DateTime), 236)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (237, N'0039', N'EURES237', CAST(15950.00 AS Numeric(18, 2)), CAST(N'2018-04-02T00:00:00.000' AS DateTime), 237)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (238, N'0031', N'GBPGB238', CAST(267950.00 AS Numeric(18, 2)), CAST(N'2018-04-09T00:00:00.000' AS DateTime), 238)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (239, N'0025', N'GBPGB239', CAST(155000.00 AS Numeric(18, 2)), CAST(N'2018-04-10T00:00:00.000' AS DateTime), 239)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (240, N'0036', N'USDUS240', CAST(2500.00 AS Numeric(18, 2)), CAST(N'2018-04-11T00:00:00.000' AS DateTime), 240)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (241, N'0028', N'EURFR241', CAST(9950.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime), 241)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (242, N'0036', N'USDUS242', CAST(39500.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime), 242)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (243, N'0038', N'GBPGB243', CAST(23500.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime), 243)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (244, N'0039', N'EURES244', CAST(45950.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime), 244)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (245, N'0051', N'USDUS245', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime), 245)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (246, N'0056', N'GBPGB246', CAST(100000.00 AS Numeric(18, 2)), CAST(N'2018-04-20T00:00:00.000' AS DateTime), 246)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (247, N'0061', N'GBPGB247', CAST(44885.00 AS Numeric(18, 2)), CAST(N'2018-04-20T00:00:00.000' AS DateTime), 247)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (248, N'0062', N'GBPGB248', CAST(61500.00 AS Numeric(18, 2)), CAST(N'2018-04-22T00:00:00.000' AS DateTime), 248)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (249, N'0052', N'GBPGB249', CAST(950.00 AS Numeric(18, 2)), CAST(N'2018-04-23T00:00:00.000' AS DateTime), 249)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (250, N'0063', N'EURIT250', CAST(195000.00 AS Numeric(18, 2)), CAST(N'2018-04-24T00:00:00.000' AS DateTime), 250)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (251, N'0064', N'EURES251', CAST(52500.00 AS Numeric(18, 2)), CAST(N'2018-04-29T00:00:00.000' AS DateTime), 251)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (252, N'0003', N'GBPGB252', CAST(1350.00 AS Numeric(18, 2)), CAST(N'2018-05-03T00:00:00.000' AS DateTime), 252)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (253, N'0021', N'GBPGB253', CAST(2495.00 AS Numeric(18, 2)), CAST(N'2018-05-03T00:00:00.000' AS DateTime), 253)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (254, N'0035', N'EURFR254', CAST(269500.00 AS Numeric(18, 2)), CAST(N'2018-05-15T00:00:00.000' AS DateTime), 254)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (255, N'0065', N'USDUS255', CAST(195000.00 AS Numeric(18, 2)), CAST(N'2018-05-15T00:00:00.000' AS DateTime), 255)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (256, N'0066', N'GBPGB256', CAST(25950.00 AS Numeric(18, 2)), CAST(N'2018-05-23T00:00:00.000' AS DateTime), 256)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (257, N'0061', N'GBPGB257', CAST(9990.00 AS Numeric(18, 2)), CAST(N'2018-05-23T00:00:00.000' AS DateTime), 257)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (258, N'0063', N'EURIT258', CAST(135000.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime), 258)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (259, N'0062', N'GBPGB259', CAST(1250.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime), 259)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (260, N'0066', N'GBPGB260', CAST(6590.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime), 260)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (261, N'0035', N'EURFR261', CAST(89500.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime), 261)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (262, N'0031', N'GBPGB262', CAST(18500.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime), 262)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (263, N'0024', N'GBPCH263', CAST(3575.00 AS Numeric(18, 2)), CAST(N'2018-06-03T00:00:00.000' AS DateTime), 263)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (264, N'0067', N'EURBE264', CAST(6950.00 AS Numeric(18, 2)), CAST(N'2018-06-03T00:00:00.000' AS DateTime), 264)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (265, N'0002', N'GBPGB265', CAST(26500.00 AS Numeric(18, 2)), CAST(N'2018-06-16T00:00:00.000' AS DateTime), 265)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (266, N'0068', N'USDUS266', CAST(33500.00 AS Numeric(18, 2)), CAST(N'2018-06-18T00:00:00.000' AS DateTime), 266)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (267, N'0012', N'GBPGB267', CAST(24500.00 AS Numeric(18, 2)), CAST(N'2018-06-22T00:00:00.000' AS DateTime), 267)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (268, N'0025', N'GBPGB268', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-06-23T00:00:00.000' AS DateTime), 268)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (269, N'0038', N'GBPGB269', CAST(99990.00 AS Numeric(18, 2)), CAST(N'2018-07-05T00:00:00.000' AS DateTime), 269)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (270, N'0069', N'GBPGB270', CAST(6950.00 AS Numeric(18, 2)), CAST(N'2018-07-10T00:00:00.000' AS DateTime), 270)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (271, N'0070', N'GBPGB271', CAST(10500.00 AS Numeric(18, 2)), CAST(N'2018-07-15T00:00:00.000' AS DateTime), 271)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (272, N'0062', N'GBPGB272', CAST(33450.00 AS Numeric(18, 2)), CAST(N'2018-07-25T00:00:00.000' AS DateTime), 272)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (273, N'0054', N'GBPGB273', CAST(72500.00 AS Numeric(18, 2)), CAST(N'2018-07-25T00:00:00.000' AS DateTime), 273)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (274, N'0071', N'GBPGB274', CAST(2400.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime), 274)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (275, N'0072', N'GBPGB275', CAST(68500.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime), 275)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (276, N'0006', N'GBPCH276', CAST(2350.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime), 276)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (277, N'0056', N'GBPGB277', CAST(18500.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime), 277)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (278, N'0073', N'GBPGB278', CAST(5500.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime), 278)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (279, N'0074', N'EURES279', CAST(128500.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime), 279)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (280, N'0065', N'USDUS280', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime), 280)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (281, N'0063', N'EURIT281', CAST(1250.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime), 281)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (282, N'0075', N'EURFR282', CAST(345000.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime), 282)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (283, N'0076', N'EURIT283', CAST(82590.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime), 283)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (284, N'0077', N'USDUS284', CAST(113590.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime), 284)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (285, N'0065', N'USDUS285', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime), 285)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (286, N'0064', N'EURES286', CAST(57600.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime), 286)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (287, N'0045', N'GBPGB287', CAST(102500.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime), 287)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (288, N'0054', N'GBPGB288', CAST(39500.00 AS Numeric(18, 2)), CAST(N'2018-08-10T00:00:00.000' AS DateTime), 288)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (289, N'0078', N'GBPGB289', CAST(61550.00 AS Numeric(18, 2)), CAST(N'2018-08-11T00:00:00.000' AS DateTime), 289)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (290, N'0079', N'GBPGB290', CAST(55000.00 AS Numeric(18, 2)), CAST(N'2018-08-15T00:00:00.000' AS DateTime), 290)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (291, N'0080', N'EURDE291', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-08-16T00:00:00.000' AS DateTime), 291)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (292, N'0006', N'GBPCH292', CAST(56800.00 AS Numeric(18, 2)), CAST(N'2018-08-18T00:00:00.000' AS DateTime), 292)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (293, N'0036', N'USDUS293', CAST(89500.00 AS Numeric(18, 2)), CAST(N'2018-09-01T00:00:00.000' AS DateTime), 293)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (294, N'0016', N'EURFR294', CAST(72500.00 AS Numeric(18, 2)), CAST(N'2018-09-01T00:00:00.000' AS DateTime), 294)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (295, N'0014', N'GBPGB295', CAST(56950.00 AS Numeric(18, 2)), CAST(N'2018-09-01T00:00:00.000' AS DateTime), 295)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (296, N'0056', N'GBPGB296', CAST(62500.00 AS Numeric(18, 2)), CAST(N'2018-09-04T00:00:00.000' AS DateTime), 296)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (297, N'0048', N'EURES297', CAST(56890.00 AS Numeric(18, 2)), CAST(N'2018-09-04T00:00:00.000' AS DateTime), 297)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (298, N'0057', N'EURFR298', CAST(33600.00 AS Numeric(18, 2)), CAST(N'2018-09-08T00:00:00.000' AS DateTime), 298)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (299, N'0081', N'GBPGB299', CAST(30500.00 AS Numeric(18, 2)), CAST(N'2018-09-08T00:00:00.000' AS DateTime), 299)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (300, N'0082', N'EURFR300', CAST(50500.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime), 300)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (301, N'0078', N'GBPGB301', CAST(39500.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime), 301)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (302, N'0076', N'EURIT302', CAST(12500.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime), 302)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (303, N'0069', N'GBPGB303', CAST(5600.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime), 303)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (304, N'0083', N'EURFR304', CAST(69500.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime), 304)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (305, N'0084', N'GBPCH305', CAST(45000.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime), 305)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (306, N'0065', N'USDUS306', CAST(56990.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 306)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (307, N'0077', N'USDUS307', CAST(86500.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 307)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (308, N'0085', N'GBPGB308', CAST(17850.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 308)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (309, N'0086', N'EURFR309', CAST(25950.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 309)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (310, N'0087', N'GBPGB310', CAST(29500.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 310)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (311, N'0005', N'EURFR311', CAST(59000.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 311)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (312, N'0065', N'USDUS312', CAST(9500.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime), 312)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (313, N'0035', N'EURFR313', CAST(8900.00 AS Numeric(18, 2)), CAST(N'2018-11-02T00:00:00.000' AS DateTime), 313)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (314, N'0024', N'GBPCH314', CAST(11590.00 AS Numeric(18, 2)), CAST(N'2018-11-15T00:00:00.000' AS DateTime), 314)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (315, N'0019', N'GBPGB315', CAST(8500.00 AS Numeric(18, 2)), CAST(N'2018-11-22T00:00:00.000' AS DateTime), 315)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (316, N'0020', N'USDUS316', CAST(59500.00 AS Numeric(18, 2)), CAST(N'2018-12-05T00:00:00.000' AS DateTime), 316)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (317, N'0040', N'EURIT317', CAST(123500.00 AS Numeric(18, 2)), CAST(N'2018-12-05T00:00:00.000' AS DateTime), 317)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (318, N'0060', N'GBPGB318', CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-12-08T00:00:00.000' AS DateTime), 318)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (319, N'0059', N'GBPGB319', CAST(56090.00 AS Numeric(18, 2)), CAST(N'2018-12-08T00:00:00.000' AS DateTime), 319)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (320, N'0048', N'EURES320', CAST(11500.00 AS Numeric(18, 2)), CAST(N'2018-12-16T00:00:00.000' AS DateTime), 320)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (321, N'0036', N'USDUS321', CAST(17950.00 AS Numeric(18, 2)), CAST(N'2018-12-17T00:00:00.000' AS DateTime), 321)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (322, N'0035', N'EURFR322', CAST(5500.00 AS Numeric(18, 2)), CAST(N'2018-12-31T00:00:00.000' AS DateTime), 322)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (323, N'0030', N'GBPGB323', CAST(950.00 AS Numeric(18, 2)), CAST(N'2018-12-31T00:00:00.000' AS DateTime), 323)
GO
INSERT [Data].[Sales] ([SalesID], [CustomerID], [InvoiceNumber], [TotalSalePrice], [SaleDate], [ID]) VALUES (324, N'0087', N'GBPGB324', CAST(145000.00 AS Numeric(18, 2)), CAST(N'2018-12-31T00:00:00.000' AS DateTime), 324)
GO
SET IDENTITY_INSERT [Data].[Sales] OFF
GO
SET IDENTITY_INSERT [Data].[SalesDetails] ON 
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (1, 1, 1, N'B1C3B95E-3005-4840-8CE3-A7BC5F9CFB3F', CAST(65000.00 AS Numeric(18, 2)), CAST(2700.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (2, 2, 1, N'A2C3B95E-3005-4840-8CE3-A7BC5F9CFB5F', CAST(220000.00 AS Numeric(18, 2)), CAST(60000.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (3, 3, 1, N'558620F5-B9E8-4FFF-8F73-A83FA9559C41', CAST(19500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (4, 4, 1, N'72443561-FAC4-4C25-B8FF-0C47361DDE2D', CAST(11500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (5, 5, 1, N'2189D556-D1C4-4BC1-B0C8-4053319E8E9D', CAST(19950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (6, 6, 1, N'C1459308-7EA5-4A2D-82BC-38079BB4049B', CAST(29500.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (7, 7, 1, N'E6E6270A-60B0-4817-AA57-17F26B2B8DAF', CAST(49500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (8, 8, 1, N'CEDFB8D2-BD98-4A08-BC46-406D23940527', CAST(76000.00 AS Numeric(18, 2)), CAST(5500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (9, 9, 1, N'6081DBE7-9AD6-4C64-A676-61D919E64979', CAST(19600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (10, 10, 1, N'D63C8CC9-DB19-4B9C-9C8E-6C6370812041', CAST(36500.00 AS Numeric(18, 2)), CAST(2500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (11, 11, 1, N'F3A2712D-20CA-495D-9F6A-8A4CA195248D', CAST(8500.00 AS Numeric(18, 2)), CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (12, 11, 2, N'4C57F13A-E21B-4AAC-9E9D-A219D4C691C6', CAST(80500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (13, 12, 1, N'98C1E31A-4258-4F78-95D4-2365167E6F3F', CAST(169500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (14, 13, 1, N'951195C4-7B69-418B-9AC2-61CCB7FE7C09', CAST(8950.00 AS Numeric(18, 2)), CAST(25.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (15, 14, 1, N'91CF8133-EF19-4C92-BEFB-6A24FD85EF3A', CAST(195000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (16, 15, 1, N'BCCB9C13-AEDA-4467-A014-48F0C7A0D6A4', CAST(22950.00 AS Numeric(18, 2)), CAST(950.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (17, 16, 1, N'94FF5451-471C-4F17-BE27-BA55D3ECF5DC', CAST(8695.00 AS Numeric(18, 2)), CAST(95.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (18, 17, 1, N'325F4D73-D44A-44BD-B109-AD25D924D38F', CAST(22990.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (19, 18, 1, N'FDCDF3F0-F0AD-4E7F-8793-8B146700D035', CAST(19500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (20, 18, 2, N'34CEE6C8-985B-4005-AB2F-AD3235C6A16D', CAST(56000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (21, 19, 1, N'BEECAE2C-0A38-473D-893F-7C8917A779C2', CAST(5500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (22, 20, 1, N'5672C4AF-78E1-4BA4-B1D1-19383DCBE43C', CAST(12650.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (23, 21, 1, N'F95052DB-3E09-4070-ADA4-5114CCAD96C0', CAST(8950.00 AS Numeric(18, 2)), CAST(950.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (24, 22, 1, N'646C802F-C868-40F0-AF81-1BF387AFB82B', CAST(15600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (25, 23, 1, N'1BB4B941-79F4-4E98-9E13-46875CA7EB67', CAST(22600.00 AS Numeric(18, 2)), CAST(600.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (26, 24, 1, N'18E980AB-452D-42EF-8728-12822AD20C60', CAST(123590.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (27, 25, 1, N'F2DE934E-62C3-45F6-AFA8-2FFA963F5360', CAST(22950.00 AS Numeric(18, 2)), CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (28, 26, 1, N'0CC75388-9A95-4F14-8D9A-8373E3B44D8A', CAST(69500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (29, 27, 1, N'5CCF4F6B-43B3-4C7F-B674-6CAFD056E52A', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (30, 28, 1, N'E264504D-3451-4670-AAB8-E4C66F2387B0', CAST(12500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (31, 29, 1, N'A926BB6C-FC26-4EBB-997E-2DF7EDC48E92', CAST(159500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (32, 30, 1, N'202B3C90-188F-413E-A44A-B99F16F03464', CAST(165000.00 AS Numeric(18, 2)), CAST(5000.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (33, 31, 1, N'486C65E8-5CB9-4A33-9507-E2E5E3CB91CC', CAST(2550.00 AS Numeric(18, 2)), CAST(50.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (34, 32, 1, N'3F3BED8D-1203-4D3E-8AC0-3ACAC73BDE17', CAST(29500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (35, 33, 1, N'281946B6-D061-455A-801B-A0EDF3E37530', CAST(12650.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (36, 34, 1, N'98A92DA3-2B99-4625-998B-2BB2FBB8F167', CAST(56950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (37, 35, 1, N'A9D335E7-2389-4DE1-9484-DC4EC6BA81D4', CAST(56000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (38, 36, 1, N'53C088BA-6E14-4758-826A-56FC57D3EEDA', CAST(65890.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (39, 36, 2, N'6C76FDEC-683F-45E1-B027-20ACFD2F501C', CAST(6000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (40, 37, 1, N'A7A80CA3-06D6-40AF-A558-09146A650340', CAST(39500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (41, 38, 1, N'A2112C27-FE1F-48C5-A3BE-A019EE17DDD6', CAST(3650.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (42, 39, 1, N'88AFBF67-13A6-4BC5-AE50-8C64F0F25453', CAST(220500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (43, 40, 1, N'11790E1E-859C-4E05-B6B3-6D72DDCC8DAE', CAST(102950.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (44, 41, 1, N'B165CAEF-FF77-4E63-98C1-59D97F97E7C9', CAST(17500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (45, 42, 1, N'CE0A56A6-8218-4F4C-A0E2-63F3DC9E4AE6', CAST(8800.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (46, 43, 1, N'23E7F9FA-67D4-47C1-8D66-F1CFBC33540F', CAST(99500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (47, 44, 1, N'07F0D746-085B-4FB9-9F82-6CEAC851FBC3', CAST(17500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (48, 45, 1, N'7BABE805-CE07-4C06-AAF1-6B5D83645CD8', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (49, 46, 1, N'D7BF8DD9-1841-4FDE-8469-66B09FA30A74', CAST(9950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (50, 46, 2, N'8F278478-CA0B-4CDB-8F02-1A054AAE88A9', CAST(39500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (51, 47, 1, N'4FFB74AD-C031-4BD9-9589-A87F462E6842', CAST(49580.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (52, 48, 1, N'055F7639-30EA-4975-A8CB-29F5C1C1C48E', CAST(5500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (53, 49, 1, N'518125AE-9A67-45A6-B3FD-557C785796FC', CAST(22150.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (54, 50, 1, N'65F89D52-9B2D-4363-8A07-4A5CE90197DB', CAST(35000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (55, 51, 1, N'54A66D7C-9E0B-40E9-B1B1-CA655F060CDE', CAST(29650.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (56, 51, 2, N'D93AF620-4F69-475A-98ED-829E0F8A3A40', CAST(45500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (57, 51, 3, N'0BE222D6-9254-4FC8-892D-76563CA81F9B', CAST(99500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (58, 52, 1, N'521659A4-8FF2-441A-8D2E-C584D561301F', CAST(15650.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (59, 53, 1, N'66CCEBEA-00EA-44B3-BBFE-AC5EC2DE456D', CAST(12500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (60, 54, 1, N'B36188E4-3684-4337-91FE-84BB33736476', CAST(195000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (61, 55, 1, N'66C9034C-23A3-44F1-B946-2DDA65E684D8', CAST(205000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (62, 56, 1, N'E00D10E9-7F7F-49A9-BDC0-4C2611580B4E', CAST(66500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (63, 57, 1, N'AAF61ECC-0BAC-4EAF-9E50-01749253329A', CAST(19500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (64, 58, 1, N'A1A4180E-B929-467D-91A6-73D2D0F34C65', CAST(79500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (65, 59, 1, N'B5E7DD25-9D69-464C-9327-A8C5E706F534', CAST(14590.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (66, 60, 1, N'0B0E0FC2-E72B-4BD4-9C46-1AF98F17BEC4', CAST(12750.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (67, 61, 1, N'356EE84B-F4FD-4923-9423-D58E2863E9A1', CAST(45600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (68, 62, 1, N'92D7DE8E-0BA7-4221-B2B1-A01F7FAFDD3E', CAST(6500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (69, 63, 1, N'5BE0098D-511F-4CF1-B87C-2CE2532F1B31', CAST(102500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (70, 64, 1, N'BDC5E621-D976-478D-A620-A0751FCBEF96', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (71, 65, 1, N'72EF5AA5-997C-4AC0-A32E-591D1E009818', CAST(12500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (72, 66, 1, N'4BFD3782-0B79-4F4E-981A-96CEF827497F', CAST(61500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (73, 67, 1, N'E6E23C74-39AF-4A44-BAAE-7CD48B0F6161', CAST(79500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (74, 68, 1, N'420701D6-5F66-4885-8A72-8B54541965A6', CAST(16500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (75, 68, 2, N'870C2B0A-A6AE-4F84-91EF-806C985A02E5', CAST(33600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (76, 69, 1, N'6BF8C577-E615-4667-A48C-25E8D825AAC6', CAST(66500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (77, 70, 1, N'98C3863B-7A70-4FAD-B3C7-2B5702956E18', CAST(45000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (78, 71, 1, N'8C1E8506-711C-442A-89A4-EDA28EB5B788', CAST(19500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (79, 72, 1, N'BC4D491E-764B-48AE-BEDC-07DE123B7200', CAST(76500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (80, 73, 1, N'4C00023A-47C5-4F98-A9B1-F222EDE2F563', CAST(45900.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (81, 74, 1, N'170FAF32-4223-4806-B483-D89F4D38AC16', CAST(125000.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (82, 75, 1, N'9CFAF367-ED4B-4A3E-8CB2-394F1F7A58C1', CAST(65500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (83, 76, 1, N'126C36BB-9C33-4BC5-9127-F941731DD0C8', CAST(92150.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (84, 77, 1, N'98B3C1C2-7AE2-4A88-A3C9-484483C6EC66', CAST(9500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (85, 78, 1, N'4A40B2AA-A76B-4C08-A59B-19CDE0ED868C', CAST(9950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (86, 79, 1, N'100EE806-DFE5-4C5E-9AB4-8F881615F8BD', CAST(5680.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (87, 80, 1, N'00DDC5C0-E266-49E4-A785-E4F8BC3C9B24', CAST(19500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (88, 81, 1, N'97AFC7D5-91BF-47E3-8568-01B704E956C2', CAST(3500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (89, 82, 1, N'6A2699A6-ED27-42A9-B811-06D19EB5FA3C', CAST(3950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (90, 83, 1, N'70C9BE5C-3CCA-4FB2-B4DE-E5F0A61BB84D', CAST(20950.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (91, 84, 1, N'B76D6985-E106-4213-AACC-288088795C92', CAST(7500.00 AS Numeric(18, 2)), CAST(75.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (92, 85, 1, N'955E8BC5-C31B-4EE5-A48D-76517063C334', CAST(56500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (93, 86, 1, N'2FCD3EBC-CBA7-4B3C-B6A0-A3A011D3A47B', CAST(49500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (94, 87, 1, N'155E940E-7AA7-47EA-B83F-B3521F0B5718', CAST(68900.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (95, 88, 1, N'B25CB659-C0A2-451E-AADB-7A006414D6E1', CAST(55000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (96, 89, 1, N'19D1000C-178F-4BBA-9B19-C93804D047AC', CAST(3575.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (97, 90, 1, N'DD6A0129-40CF-449F-8427-1C97BF14B2BD', CAST(35250.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (98, 91, 1, N'66D70810-1EE2-4BCA-B1B4-1E5B86C75002', CAST(19600.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (99, 91, 2, N'384778FF-C28D-4FE6-9BEF-D787EFDC23CF', CAST(27890.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (100, 92, 1, N'B760CF74-6468-4A0D-9485-36C7F7710EB0', CAST(45950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (101, 93, 1, N'E1350CBE-B916-4F18-B5BF-F7D53A31205A', CAST(9950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (102, 94, 1, N'9D74A1A9-7342-4FEA-9C21-6AC4EFE92018', CAST(6550.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (103, 94, 2, N'C001858B-0B5D-4648-8F0D-80269964C921', CAST(156500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (104, 95, 1, N'BB4B9483-7AE3-47B4-A788-7EB5D12A7516', CAST(76500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (105, 96, 1, N'6120D922-6703-4267-969B-A9A9D3CAE787', CAST(119600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (106, 97, 1, N'30DC26F7-E98B-4FE8-B834-D625EC7E12F3', CAST(85650.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (107, 97, 2, N'34A69512-CDC3-4BEB-ADCB-AAE360CA7CF4', CAST(9950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (108, 98, 1, N'3EDC8773-9603-4D38-9DC9-64E1C4768F7D', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (109, 99, 1, N'9FF62C70-89E4-4815-912F-C5DFBF8BDF0F', CAST(12500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (110, 100, 1, N'EC25FA02-2692-42E1-85A0-71F0775C8F8A', CAST(56890.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (111, 101, 1, N'E368D03E-239C-499F-A41A-CC4D2AE1AFF8', CAST(55000.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (112, 102, 1, N'4C1762AE-F7FD-4F2C-875B-CAC022B0DF63', CAST(9990.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (113, 102, 2, N'DB8869B2-1EC0-48D5-9DA6-FDF1665155F0', CAST(46500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (114, 102, 3, N'DD651733-FE5C-46B9-AC97-727F8CD170A6', CAST(9500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (115, 102, 4, N'F810FAB0-6BAE-4AC0-BDBC-F14A71AC35B9', CAST(125500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (116, 103, 1, N'3CF2C0F8-21E1-4ADE-AE72-AB9DFE3790DD', CAST(99500.00 AS Numeric(18, 2)), CAST(5000.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (117, 104, 1, N'A017241D-3A92-4EA7-A3EE-22FC119542F8', CAST(60500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (118, 105, 1, N'4537B83B-2444-4389-B2DE-F30E15608163', CAST(123500.00 AS Numeric(18, 2)), CAST(5000.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (119, 106, 1, N'7CEA62B1-9CBE-4E13-BECC-54E7EED128EF', CAST(25000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (120, 107, 1, N'102A734C-3212-4708-85A5-A96FE8E14641', CAST(169500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (121, 108, 1, N'9B8B87E1-7770-4136-8EB4-B7173C8783A6', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (122, 109, 1, N'C0E2E06D-AE60-4223-9E7C-B8387F2A4335', CAST(39500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (123, 110, 1, N'3EEC687A-759C-4D8A-8776-E257E8230376', CAST(22500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (124, 111, 1, N'09FA3947-726D-4987-B9DD-2F4CF7CD7C45', CAST(125000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (125, 112, 1, N'52CE8210-53B8-4C09-B821-6389A09733C5', CAST(85000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (126, 113, 1, N'DE44149E-1225-4B7C-97E5-8089A4F21C1C', CAST(1250.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (127, 114, 1, N'CF9A23D7-6F8A-4CA6-A037-95EA7385B539', CAST(22500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (128, 115, 1, N'98299E86-0B98-42D8-A549-37D89435B4E3', CAST(125950.00 AS Numeric(18, 2)), CAST(12500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (129, 116, 1, N'DD8D9340-29B0-4E0D-89B3-BD33B70E087D', CAST(8850.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (130, 117, 1, N'BBDFB7CF-FBA6-4463-BC1E-FE79522431EE', CAST(9950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (131, 118, 1, N'47077B33-09BC-4FF2-B71B-58E243952BAA', CAST(56500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (132, 119, 1, N'A48E5430-ACA4-41FD-BC6F-446BE2B46DF8', CAST(55000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (133, 120, 1, N'E869D5E4-CAC0-48ED-8961-03D0405EA2FD', CAST(56950.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (134, 121, 1, N'74DD8FE1-B205-4400-A951-1E54E7C22E40', CAST(365000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (135, 122, 1, N'7392B5F6-783C-4D4B-B687-74A98411A7CB', CAST(395000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (136, 123, 1, N'01B087C6-00D1-40B2-808F-B4B5BC1E344D', CAST(21500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (137, 124, 1, N'11BCE306-33ED-4C8D-9198-2A4B653D9F8A', CAST(6500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (138, 125, 1, N'6943ADF3-01A4-4281-B0CE-93384FE60418', CAST(12500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (139, 126, 1, N'A08FCF25-5B27-4215-BF50-E94D0F7C8CD6', CAST(2250.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (140, 127, 1, N'8F100F91-FE3C-4338-AA52-7BF61A540199', CAST(3500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (141, 128, 1, N'84BE4607-F8D7-49DA-8C27-D87FE529DF96', CAST(5680.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (142, 129, 1, N'EB59DB36-5E67-4AF1-AE8A-46E8999EEF45', CAST(8550.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (143, 130, 1, N'7372D1C7-800F-4DE4-B3BC-FFA46CE77099', CAST(156500.00 AS Numeric(18, 2)), CAST(10000.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (144, 131, 1, N'E267042F-449B-4CA9-8BDE-5C197DC8A647', CAST(56500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (145, 132, 1, N'2C377634-90F1-4BC1-A366-0F0EBD26910D', CAST(86500.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (146, 133, 1, N'49D19AE8-FBBF-496C-BC1E-9450544DD193', CAST(66500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (147, 134, 1, N'0B3AEBF5-0997-447D-B0E8-B399B7343742', CAST(55600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (148, 135, 1, N'643800B3-AD63-4B67-8ACF-672B91F04C57', CAST(305000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (149, 136, 1, N'EDCCE461-5DA8-4E2E-8F08-798431841575', CAST(45000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (150, 137, 1, N'7F08368D-B6EA-4DFC-A1EC-B1A1B0221F04', CAST(225000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (151, 138, 1, N'0588AA57-B6B5-47F5-910F-5A1099B0476D', CAST(42950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (152, 139, 1, N'32C41EC9-CB3C-4D0F-9C85-2500CE2E4813', CAST(990.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (153, 140, 1, N'1909CD9B-9C06-4CFB-B8AD-292967E55E2F', CAST(29500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (154, 141, 1, N'1B77D0BA-45C9-4C76-952E-B2FA2859B7AB', CAST(139500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (155, 142, 1, N'CD06C0DF-D3A2-4593-BF40-7DAE6B73F58C', CAST(295000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (156, 143, 1, N'08B3555E-47A2-4365-AED8-2DF054FF73E2', CAST(220500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (157, 144, 1, N'C1A812F1-5FA1-48BA-8787-16F2F0A704BC', CAST(79500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (158, 145, 1, N'05AB94D5-2F8D-4B06-878D-615956C94EC2', CAST(162500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (159, 146, 1, N'B607E8E1-5ECA-4DE2-BC46-909DBF9371D3', CAST(79500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (160, 147, 1, N'7A12CA8A-DC67-4A4F-B6F4-8B150873523A', CAST(65890.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (161, 148, 1, N'4A4A1D5E-1682-4ACA-A60D-0072693FE190', CAST(61500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (162, 149, 1, N'C4ACB04E-C8D4-465E-8D66-8BA033443D61', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (163, 150, 1, N'5D11974B-326C-44C5-BA1D-57968CAB0DEE', CAST(255000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (164, 151, 1, N'F8B48177-FB78-4245-935F-FB6FBCE8D870', CAST(255950.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (165, 152, 1, N'6AEAC4F1-4C81-4FAA-A97C-3DCC0E6CB5DE', CAST(250000.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (166, 153, 1, N'A5BDB4E0-1544-449F-8596-D63D70548675', CAST(6500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (167, 154, 1, N'06FD2864-8415-44A5-B022-B98BEFB7E490', CAST(9250.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (168, 155, 1, N'ECC534C7-B2DD-425C-98D3-98D2332B373C', CAST(950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (169, 156, 1, N'589E8DB1-B2D4-4921-A11B-9A2A80EA73D9', CAST(295000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (170, 157, 1, N'BD15948E-42F0-41BC-920C-343E0816B0AB', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (171, 158, 1, N'E0760EF4-3939-4063-821F-5923EF8760B4', CAST(33500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (172, 159, 1, N'D3C15454-EF60-415F-860D-99D41F0A485F', CAST(45000.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (173, 160, 1, N'DF5411FC-24C5-4CAB-89DF-54741054D8DD', CAST(36500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (174, 160, 2, N'8BB5BBD3-E03C-457C-86E2-67199FCB302A', CAST(77500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (175, 161, 1, N'3A0070F8-C340-4B6F-9F36-4A1CBDB39FE9', CAST(2350.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (176, 162, 1, N'638FCDD5-AFFF-4DCA-AAEC-17F527FB9D02', CAST(32500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (177, 163, 1, N'0C3EBD09-B9DF-414D-AD00-90F5819812D0', CAST(45000.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (178, 164, 1, N'8BB7FF86-2D80-40B7-B216-254C16843529', CAST(8500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (179, 165, 1, N'57E2BA34-6397-448F-8A8C-1306CC922231', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (180, 166, 1, N'2EE943CB-2473-4333-8626-FC94FCD0947E', CAST(25000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (181, 167, 1, N'1A80A54C-D98D-41D6-87EE-8F67F3B06FA8', CAST(19500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (182, 168, 1, N'D32D55B7-3546-4CCA-B4C0-DBA976572CA2', CAST(12950.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (183, 169, 1, N'D05D6642-FABF-4F56-8A7E-D8C47A8AAB70', CAST(5650.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (184, 170, 1, N'658F0B06-2357-4DAA-803C-4DD7F569F270', CAST(29500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (185, 171, 1, N'760F5558-3C9E-4B70-A412-0448B90B0D89', CAST(3950.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (186, 171, 2, N'B09E4DDD-C2DD-45BE-B5F1-19FBF5970352', CAST(29500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (187, 171, 3, N'B4CC6E9A-8473-4A84-A811-73EABAFDC582', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (188, 172, 1, N'2595D5C0-5002-464B-8F2B-C873FB29B4F9', CAST(99950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (189, 173, 1, N'D69ABA72-1B0D-4073-8B7D-D6CA65C4DDF7', CAST(335000.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (190, 174, 1, N'332CE8D2-E19F-4656-BCC6-E3E45AD09D85', CAST(56500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (191, 175, 1, N'306507B9-D2E1-4C5D-8F01-C93C90C93B6E', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (192, 176, 1, N'2B0FC8E5-82CB-4804-8691-0586F2255E9E', CAST(135000.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (193, 177, 1, N'ACB85DBA-4914-4222-8D24-6D87B0DAE10A', CAST(89500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (194, 178, 1, N'23E43063-5402-4946-8830-0723F6B3CE1C', CAST(165000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (195, 179, 1, N'E59BFE04-E70B-4BAC-9269-ADC311ED0032', CAST(22600.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (196, 180, 1, N'8979136A-B34A-4CD3-B119-A6B158D15FFF', CAST(32675.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (197, 181, 1, N'34A4BB21-60B3-4B0D-8DDB-8189C471A581', CAST(45000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (198, 182, 1, N'AFAF5C3E-80C9-4C5A-9D2A-CDD238E40264', CAST(5500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (199, 183, 1, N'7FCABEE5-E116-4AE3-B7B1-483C2F0D18CA', CAST(55000.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (200, 184, 1, N'B84575EE-2E61-482C-8B72-5A6A90ADC3FE', CAST(49500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (201, 185, 1, N'DB2AF439-6293-4925-B905-1A57A0118B1A', CAST(250000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (202, 186, 1, N'15108517-AD0C-4FF2-A7D4-57679C374A68', CAST(155000.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (203, 187, 1, N'10AD713C-C997-48BB-A5FB-F0B5FD26479B', CAST(15750.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (204, 188, 1, N'C1C9D15D-9E57-4D22-8997-D1333EEC6B13', CAST(19500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (205, 189, 1, N'8A275CE2-D116-49F7-8571-FD91F21ADAAA', CAST(235000.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (206, 190, 1, N'009A5323-23E5-48BE-95DB-BA94E1897419', CAST(25000.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (207, 191, 1, N'EBE7AD85-117F-4781-A5E5-13920EE2B546', CAST(245000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (208, 192, 1, N'B822FA7C-5FA5-4F17-A3A6-7199CB00F7F8', CAST(39500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (209, 192, 2, N'1A210C04-C981-4EA4-83B9-A6E76B5B9BDB', CAST(49500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (210, 193, 1, N'ECD53BA8-3C63-4938-92C4-C955AEA6C4BC', CAST(23500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (211, 193, 2, N'26199C63-95B5-419B-A827-C0EEAF594A5B', CAST(10500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (212, 194, 1, N'C9D8FCFE-4A88-479C-A2CA-E2474AF4D8DF', CAST(11500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (213, 194, 2, N'05D4115C-3F27-4059-BDC8-C0C3FFC85E8B', CAST(51200.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (214, 195, 1, N'B503DD91-24FA-4F4A-AF49-1EB15347A33D', CAST(45950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (215, 196, 1, N'896B39D5-8040-4947-94D0-0234B4E78B23', CAST(21600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (216, 197, 1, N'38264675-F235-412B-9B67-8F8CD86CF40D', CAST(25000.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (217, 198, 1, N'2657F22B-5D29-4A7A-B3F9-3A04C14D7C93', CAST(23600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (218, 199, 1, N'9BFDC1FA-8416-4F58-BE6C-3CCFA7A51860', CAST(99950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (219, 200, 1, N'A88F114F-3808-4B2D-92BE-BD43EEA71742', CAST(46900.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (220, 201, 1, N'1860F37A-EBC7-42E9-B339-3F6D6048322F', CAST(45950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (221, 202, 1, N'00E07EB4-4A3A-434F-B3FC-76A312BEEF5D', CAST(7550.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (222, 203, 1, N'C72ABA1C-D1FA-4A4B-9E16-9FE066D509BA', CAST(11990.00 AS Numeric(18, 2)), CAST(900.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (223, 204, 1, N'B8F3827A-5689-42B9-A1DE-26AFE7E2343E', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (224, 205, 1, N'A21CAFB1-7242-42D1-80AC-E5D26941E2BE', CAST(7500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (225, 206, 1, N'76D2E902-DF33-4BE5-8181-B9DA01869131', CAST(56850.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (226, 207, 1, N'61B73BA2-9EA0-4DB9-8D89-6E8D2A5D32DA', CAST(62500.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (227, 208, 1, N'8BED3FBE-29EA-48AF-A8CE-7770F51A548F', CAST(42500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (228, 209, 1, N'B0559A26-5CE0-4C70-89EC-C73C0837B1E8', CAST(65450.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (229, 210, 1, N'2CE57C5E-98DE-402F-884A-A6227FD7FB5F', CAST(56950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (230, 211, 1, N'99DF9E69-9DAF-4D81-8334-D7058F1030E2', CAST(1950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (231, 212, 1, N'D231E90A-140A-4623-AA79-16970966DDF3', CAST(1150.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (232, 213, 1, N'26122425-FE14-4318-8713-15C8F9EED630', CAST(11550.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (233, 214, 1, N'80B21E0F-66E3-4582-838A-D7EC560C7C0B', CAST(12570.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (234, 215, 1, N'8D9BF815-FAE4-47CE-ADBB-33339D382319', CAST(9890.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (235, 216, 1, N'F6C384B6-B768-4031-AC12-81C8CE37049E', CAST(56950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (236, 217, 1, N'F9EF8BCC-5744-4EBC-91AD-739775C597D9', CAST(45950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (237, 218, 1, N'457046F9-68AC-468E-9C5E-9C1B957FE9B9', CAST(950.00 AS Numeric(18, 2)), CAST(25.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (238, 219, 1, N'3DCFE242-5286-404C-A37E-5207E6F51BB1', CAST(21550.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (239, 220, 1, N'BF9128E0-D61A-4214-8128-44A9880E20C2', CAST(5950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (240, 221, 1, N'808F1237-9F5C-484F-8E14-63FF713A864D', CAST(365000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (241, 222, 1, N'790E96BC-2F59-4B8F-9DE2-6BB65F92216B', CAST(120000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (242, 223, 1, N'88975E00-70FD-44B6-9A1F-9E3B9CCE4382', CAST(17850.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (243, 223, 2, N'6218BE0E-185B-4B12-8696-AA976EA81B29', CAST(103650.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (244, 224, 1, N'03AC7842-CA66-4AC0-92AD-F538494D1FAE', CAST(182500.00 AS Numeric(18, 2)), CAST(17500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (245, 225, 1, N'7FF88424-96A2-4149-ABF3-21AC9FBCDD4C', CAST(22500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (246, 226, 1, N'48437CA9-988E-42EA-94F8-DC2D6DA48BA7', CAST(21500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (247, 227, 1, N'2319EA77-F4D9-4E34-9771-C42DCA3E210C', CAST(189500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (248, 228, 1, N'A6FCB276-6311-4B3E-9C99-23F197952F1C', CAST(55450.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (249, 229, 1, N'89C3293F-F665-4E93-9929-315CBA3DD498', CAST(98950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (250, 230, 1, N'59650ADF-0886-43B4-B360-3A79E0CA327E', CAST(355000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (251, 231, 1, N'4BA7F44F-422D-4AD2-84B3-2AE4F0028DB8', CAST(6000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (252, 232, 1, N'1DDF23D7-3CB8-49C7-A19B-2A9C5AB23ADF', CAST(5690.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (253, 233, 1, N'A2201698-CA26-428A-988F-ABB4A8893E21', CAST(56900.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (254, 234, 1, N'F556C096-7EFE-4827-9AFF-2FD0416B1C9B', CAST(145000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (255, 234, 2, N'9868BF47-F113-4721-BF95-26FEF8DD51D2', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (256, 234, 3, N'C7086D43-16DA-444F-A461-76DA9C479425', CAST(123500.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (257, 235, 1, N'20041639-9549-415A-AEC2-7159352E8CB7', CAST(310000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (258, 236, 1, N'AF51E444-D0BE-477F-8834-615824E0A89C', CAST(9800.00 AS Numeric(18, 2)), CAST(35.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (259, 237, 1, N'FAB39B43-A811-4410-A69A-707C35C767E7', CAST(15950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (260, 238, 1, N'A23F2E70-66D3-44A1-982C-ADE1ECA9CC30', CAST(255000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (261, 238, 2, N'BFC6861C-8D2E-40C8-A4F7-07F9E41056DC', CAST(12950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (262, 239, 1, N'07E4BA14-7B78-4B11-9A11-1520460A5631', CAST(155000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (263, 240, 1, N'9E98DDEF-D2A3-4BEC-99DD-BEFEFC11E5EE', CAST(2500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (264, 241, 1, N'43195E1A-46B2-4554-B1A9-C849B1C0B53B', CAST(9950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (265, 242, 1, N'7808CA65-E449-4280-A128-F5B581F47B8F', CAST(39500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (266, 243, 1, N'B2D76C72-FA30-40AE-9AB9-DFB47560348C', CAST(23500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (267, 244, 1, N'C19B3F44-9EA7-49FF-953A-86BF48B55615', CAST(45950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (268, 245, 1, N'A0F4D013-88EB-4692-B5EE-6BA800593036', CAST(55000.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (269, 246, 1, N'9CD9439F-E15F-4469-BE82-7A4041633A50', CAST(100000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (270, 247, 1, N'87A6B5EF-1E2B-49CA-85D7-263BC7E32189', CAST(44885.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (271, 248, 1, N'361E0EFF-56B8-4E0A-A1DD-41D4A51BF704', CAST(61500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (272, 249, 1, N'B89AF48B-4BB9-409B-876B-941E51D19381', CAST(950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (273, 250, 1, N'A326183E-7D45-4CF2-A353-7177A3EAB71F', CAST(195000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (274, 251, 1, N'266404D4-FBC5-4DC6-BB7C-A2ED7246D6D7', CAST(52500.00 AS Numeric(18, 2)), CAST(1575.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (275, 252, 1, N'798C76AF-985B-4B9F-B24A-4B4311AE2A08', CAST(1350.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (276, 253, 1, N'71C9EDC5-7897-4CCE-9B2F-5B04BEDC36D0', CAST(2495.00 AS Numeric(18, 2)), CAST(45.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (277, 254, 1, N'61F8CF9A-F53C-4386-9BF8-578F54547CD2', CAST(269500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (278, 255, 1, N'FF62897D-E06C-4BC1-B5EA-E6BE415B0CD1', CAST(195000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (279, 256, 1, N'9555FF33-EE29-4A81-854A-69F6485BB216', CAST(25950.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (280, 257, 1, N'EA1B19C6-631A-4683-9E29-1BC601FC850E', CAST(9990.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (281, 258, 1, N'27C180A1-7C39-4E88-B5DE-ACD0C9594F3C', CAST(135000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (282, 259, 1, N'A0098927-0C7D-4CC8-8022-57A24433EF61', CAST(1250.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (283, 260, 1, N'9743A284-D059-4EEB-98AB-ACDE88C1E9F5', CAST(6590.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (284, 261, 1, N'BEC34DF7-3E37-4322-A406-04BB5DF2A0FE', CAST(89500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (285, 262, 1, N'F075AC9E-1124-4194-A05F-683F9D553335', CAST(18500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (286, 263, 1, N'05F6C06A-9CD8-448B-9F67-FDBC0A7CEDCE', CAST(3575.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (287, 264, 1, N'B1ABF9BD-1FBC-4E9A-BCCC-0B9AFEE5CFF1', CAST(6950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (288, 265, 1, N'607CA291-F642-4CBD-967B-7A36DF45D150', CAST(26500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (289, 266, 1, N'695E6D94-12E6-49BC-8E23-29AC3EB38D93', CAST(33500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (290, 267, 1, N'614ED49B-6DA9-4BFE-9560-3DB52A6593CD', CAST(24500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (291, 268, 1, N'740A7CB4-BF3F-46FD-98F3-D85748E5B9BA', CAST(99500.00 AS Numeric(18, 2)), CAST(500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (292, 269, 1, N'D0B8D738-B33D-4F7F-BA25-46EC06DEB8E2', CAST(99990.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (293, 270, 1, N'23FDFA0D-C905-41A6-B95A-D5A3517293D8', CAST(6950.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (294, 271, 1, N'6A140D65-C354-48F6-A92E-40FF36CF1216', CAST(10500.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (295, 272, 1, N'4AFC6EDF-49EA-4D57-85AF-D60734328922', CAST(33450.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (296, 273, 1, N'EF8621F7-41EB-4C2D-ADBD-D4287083D41F', CAST(72500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (297, 274, 1, N'E66B3E09-F02D-484A-8B9F-A8CD7833CD6B', CAST(2400.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (298, 275, 1, N'13F9FBD7-9342-4A2D-A249-E3AD6AE9A9CB', CAST(68500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (299, 276, 1, N'E68BB825-0487-44CA-AE6C-7C650F81E22B', CAST(2350.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (300, 277, 1, N'519C0ED1-7611-4CDC-8153-5C4B81A7FD0F', CAST(18500.00 AS Numeric(18, 2)), CAST(1950.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (301, 278, 1, N'3CD0AFE8-9909-4A5D-BA9F-5C1F71B0DEE3', CAST(5500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (302, 279, 1, N'114760E3-FC54-4C31-B323-BC4B83AB80D0', CAST(128500.00 AS Numeric(18, 2)), CAST(12500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (303, 280, 1, N'757E7DB7-3688-41FD-AFB6-E49CC56BCCD8', CAST(55000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (304, 281, 1, N'BA123B46-B5DF-439B-9326-82174419FC14', CAST(1250.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (305, 282, 1, N'FCB80D65-7D65-41E4-9081-6C92D0C7F1F5', CAST(345000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (306, 283, 1, N'0318C525-58CA-438E-A5A5-BA854855A664', CAST(82590.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (307, 284, 1, N'17FA511D-1C85-4F74-A164-B4EE39F48565', CAST(113590.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (308, 285, 1, N'4B47A26E-2723-4E06-A661-21271A6759D0', CAST(45000.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (309, 286, 1, N'47572651-C884-4C1D-A433-E8641A1A1172', CAST(57600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (310, 287, 1, N'2A27FF01-DC3C-4FE2-AC8C-9145C29F651C', CAST(102500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (311, 288, 1, N'F4443E46-3EAC-4C10-902C-71257DEEE229', CAST(39500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (312, 289, 1, N'4EE854BF-A9DD-453B-815E-E0692A75A969', CAST(61550.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (313, 290, 1, N'3D2E9AD0-972B-4A09-895F-1833655CFB21', CAST(55000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (314, 291, 1, N'480D88A9-B1E5-4A79-9D2C-C1050C6DA00A', CAST(99500.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (315, 292, 1, N'EE92EE4A-977E-4BC6-BEFF-512CC468944C', CAST(56800.00 AS Numeric(18, 2)), CAST(750.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (316, 293, 1, N'B8498BEE-D1C5-4D93-981F-640031A3AE6C', CAST(89500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (317, 294, 1, N'A44EE0A0-B924-4B29-9C05-BA4BFADE084B', CAST(72500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (318, 295, 1, N'C8C871B4-F08D-445A-BCD1-ACFEC616A113', CAST(56950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (319, 296, 1, N'47693731-F213-4E60-97D6-115A7BD83259', CAST(62500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (320, 297, 1, N'73FB2744-5AD9-42DC-A29C-B9B2FEF8353C', CAST(56890.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (321, 298, 1, N'DB742D0B-E562-41F4-AC94-8C58C2B0B69C', CAST(33600.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (322, 299, 1, N'51784E0D-09DB-4A40-8E92-CB09A0DE4444', CAST(30500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (323, 300, 1, N'1A861C29-F198-4D34-BDAF-B35E8080320A', CAST(25000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (324, 300, 2, N'D0F51768-8924-4EF5-A3E9-B31AC7129BFB', CAST(25500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (325, 301, 1, N'E8FF8444-2B18-45A0-84AC-F776755E06ED', CAST(39500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (326, 302, 1, N'A3E788F8-889C-45E1-A610-881983869F6B', CAST(12500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (327, 303, 1, N'C8F49B5E-EDDB-42D0-BE0F-8C4181A6C81D', CAST(1150.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (328, 303, 2, N'1D5C9493-4BA2-415A-B4D6-7079278CA2DC', CAST(1950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (329, 303, 3, N'0A059F54-46DE-4A25-8B5D-D7373AEE6F91', CAST(2500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (330, 304, 1, N'6AE8BA09-AE75-4CA4-81EE-6CD2B3947120', CAST(69500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (331, 305, 1, N'3BDD9316-9359-464B-B98E-308494AD3056', CAST(45000.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (332, 306, 1, N'3C17F01C-25FF-463B-86AA-1A34FEA02FF2', CAST(56990.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (333, 307, 1, N'0E2AECED-5A41-412A-9414-DE7217C0B6EB', CAST(86500.00 AS Numeric(18, 2)), CAST(2450.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (334, 308, 1, N'91B4067A-EBDE-4C1E-9370-3E894FD2FD7D', CAST(17850.00 AS Numeric(18, 2)), CAST(1250.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (335, 309, 1, N'436E43FB-E015-48E4-B549-33F4A0EE8D3F', CAST(25950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (336, 310, 1, N'E166158C-F3BA-47DE-A499-A703210CF128', CAST(29500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (337, 311, 1, N'1C9E6944-A890-4D7B-8F98-32B7276A78B3', CAST(59000.00 AS Numeric(18, 2)), CAST(4500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (338, 312, 1, N'7461FB42-ECE2-4C8C-BDBB-EF26AF3069F9', CAST(9500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (339, 313, 1, N'98828061-0C7A-42C2-95D0-3095AD2EF0E4', CAST(8900.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (340, 314, 1, N'E519F3CF-BE4B-44CF-98D5-80EC33EC6CE1', CAST(11590.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (341, 315, 1, N'E6923E8C-C07A-430F-B80D-7D5F329055AB', CAST(8500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (342, 316, 1, N'0487C263-79B7-4F2B-8D0E-B0BAA41D7F24', CAST(59500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (343, 317, 1, N'92FDF39E-6565-4B68-80BA-02ED30F00A7E', CAST(123500.00 AS Numeric(18, 2)), CAST(3500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (344, 318, 1, N'5D7C9AA9-F0C7-4F8E-8524-6481BE3CC62E', CAST(99500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (345, 319, 1, N'CD2E20D3-1A10-4460-AC3B-FAC658F5F6F4', CAST(54500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (346, 319, 2, N'3C384AE3-7F59-4CD6-BAFE-5E6EFFD25FAD', CAST(1590.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (347, 320, 1, N'6556A473-CE18-428F-8F33-955E80FBA888', CAST(11500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (348, 321, 1, N'F166C930-3101-42E9-8AE8-189F47FA0014', CAST(17950.00 AS Numeric(18, 2)), CAST(1500.00 AS Numeric(18, 2)))
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (349, 322, 1, N'2E0E8003-F9CC-486D-9D08-D4DAC688C800', CAST(5500.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (350, 323, 1, N'C2623FF4-88AA-40E9-AF3B-8D009C25027B', CAST(950.00 AS Numeric(18, 2)), NULL)
GO
INSERT [Data].[SalesDetails] ([SalesDetailsID], [SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount]) VALUES (351, 324, 1, N'C7569243-BDDB-4250-901E-EA6034824106', CAST(145000.00 AS Numeric(18, 2)), CAST(5000.00 AS Numeric(18, 2)))
GO
SET IDENTITY_INSERT [Data].[SalesDetails] OFF
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B1C3B95E-3005-4840-8CE3-A7BC5F9CFB3F', 2, 52000.0000, 2175.0000, 1500.0000, 750.0000, 1, N'Red', N'Superb Car! Wish I could afford a second one!', CAST(N'2015-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A2C3B95E-3005-4840-8CE3-A7BC5F9CFB5F', 3, 176000.0000, 5500.0000, 2200.0000, 1950.0000, 1, N'Blue', NULL, CAST(N'2015-01-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'558620F5-B9E8-4FFF-8F73-A83FA9559C41', 11, 15600.0000, 660.0000, 0.0000, 150.0000, 1, N'British Racing Green', N'An absolute example of the pinnacle of British engineering. This is a wonderful piece of kit.', CAST(N'2015-01-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'72443561-FAC4-4C25-B8FF-0C47361DDE2D', 12, 9200.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2015-02-14' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2189D556-D1C4-4BC1-B0C8-4053319E8E9D', 13, 15960.0000, 1360.0000, 500.0000, 150.0000, 1, N'Red', NULL, CAST(N'2015-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DE3096AD-76F9-4AAF-B2E1-49FA8E2C377F', 2, 176000.0000, 1000.0000, 3150.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2015-03-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C1459308-7EA5-4A2D-82BC-38079BB4049B', 22, 23600.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2015-03-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E6E6270A-60B0-4817-AA57-17F26B2B8DAF', 23, 39600.0000, 2500.0000, 1500.0000, 550.0000, 1, N'Black', N'FAbulous motor!', CAST(N'2015-03-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CEDFB8D2-BD98-4A08-BC46-406D23940527', 24, 60800.0000, 3250.0000, 750.0000, 750.0000, 0, N'Canary Yellow', NULL, CAST(N'2015-03-26' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8BD326B3-8DE8-4DC9-9F96-FD132C5E1BF2', 2, 172000.0000, 750.0000, 150.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2015-04-04' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6081DBE7-9AD6-4C64-A676-61D919E64979', 11, 15680.0000, 890.0000, 500.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2015-04-04' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D63C8CC9-DB19-4B9C-9C8E-6C6370812041', 23, 29200.0000, 1950.0000, 500.0000, 550.0000, 1, N'Blue', NULL, CAST(N'2015-04-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F3A2712D-20CA-495D-9F6A-8A4CA195248D', 13, 6800.0000, 250.0000, 225.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2015-04-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EDCCE461-5DA8-4E2E-8F08-798431841575', 24, 36000.0000, 1250.0000, 750.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2015-04-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4C57F13A-E21B-4AAC-9E9D-A219D4C691C6', 32, 64400.0000, 500.0000, 750.0000, 750.0000, 1, N'British Racing Green', NULL, CAST(N'2015-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'98C1E31A-4258-4F78-95D4-2365167E6F3F', 3, 135600.0000, 5500.0000, 2200.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2015-05-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'951195C4-7B69-418B-9AC2-61CCB7FE7C09', 13, 7160.0000, 500.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2015-05-26' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'91CF8133-EF19-4C92-BEFB-6A24FD85EF3A', 2, 156000.0000, 6000.0000, 1500.0000, 1950.0000, 1, N'Green', NULL, CAST(N'2015-06-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BCCB9C13-AEDA-4467-A014-48F0C7A0D6A4', 45, 18360.0000, 550.0000, 500.0000, 150.0000, 1, N'Red', NULL, CAST(N'2015-06-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'94FF5451-471C-4F17-BE27-BA55D3ECF5DC', 51, 6956.0000, 400.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2015-07-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'325F4D73-D44A-44BD-B109-AD25D924D38F', 75, 18392.0000, 390.0000, 150.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2015-07-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'FDCDF3F0-F0AD-4E7F-8793-8B146700D035', 76, 15600.0000, 290.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2015-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'34CEE6C8-985B-4005-AB2F-AD3235C6A16D', 24, 44800.0000, 1785.0000, 500.0000, 550.0000, 1, N'Canary Yellow', NULL, CAST(N'2015-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CE0A56A6-8218-4F4C-A0E2-63F3DC9E4AE6', 13, 7040.0000, 140.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2015-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BEECAE2C-0A38-473D-893F-7C8917A779C2', 86, 4400.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2015-08-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'5672C4AF-78E1-4BA4-B1D1-19383DCBE43C', 87, 10120.0000, 320.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2015-08-24' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C001858B-0B5D-4648-8F0D-80269964C921', 3, 125200.0000, 2200.0000, 3150.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2015-09-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F95052DB-3E09-4070-ADA4-5114CCAD96C0', 12, 7160.0000, 360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2015-09-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A6FCB276-6311-4B3E-9C99-23F197952F1C', 32, 44360.0000, 490.0000, 225.0000, 550.0000, 1, N'Red', NULL, CAST(N'2015-09-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'646C802F-C868-40F0-AF81-1BF387AFB82B', 74, 12480.0000, 1100.0000, 500.0000, 150.0000, 1, N'Red', NULL, CAST(N'2015-10-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1BB4B941-79F4-4E98-9E13-46875CA7EB67', 76, 18080.0000, 660.0000, 750.0000, 150.0000, 0, N'Red', NULL, CAST(N'2015-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'86450D0C-EAA5-4B83-A9DA-55D742E9C2D8', 86, 9352.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2015-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'26A3D067-DCEA-4FF1-9A97-E7AEE0D2BC14', 24, 43000.0000, 2000.0000, 750.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2015-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'18E980AB-452D-42EF-8728-12822AD20C60', 26, 98872.0000, 2175.0000, 2200.0000, 750.0000, 1, N'Black', NULL, CAST(N'2015-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F2DE934E-62C3-45F6-AFA8-2FFA963F5360', 11, 18360.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2015-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0CC75388-9A95-4F14-8D9A-8373E3B44D8A', 24, 55600.0000, 1490.0000, 1500.0000, 750.0000, 1, N'Silver', NULL, CAST(N'2015-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'5CCF4F6B-43B3-4C7F-B674-6CAFD056E52A', 86, 10000.0000, 500.0000, 225.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2015-12-22' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E264504D-3451-4670-AAB8-E4C66F2387B0', 13, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2015-12-23' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A926BB6C-FC26-4EBB-997E-2DF7EDC48E92', 3, 127600.0000, 2000.0000, 3150.0000, 1950.0000, 1, N'Silver', NULL, CAST(N'2015-12-24' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'202B3C90-188F-413E-A44A-B99F16F03464', 2, 132000.0000, 3950.0000, 2200.0000, 1950.0000, 1, N'Night Blue', NULL, CAST(N'2015-12-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'486C65E8-5CB9-4A33-9507-E2E5E3CB91CC', 51, 2040.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3F3BED8D-1203-4D3E-8AC0-3ACAC73BDE17', 11, 23600.0000, 1360.0000, 500.0000, 150.0000, 0, N'Black', NULL, CAST(N'2016-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'281946B6-D061-455A-801B-A0EDF3E37530', 13, 10120.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'98A92DA3-2B99-4625-998B-2BB2FBB8F167', 31, 45560.0000, 2000.0000, 750.0000, 550.0000, 0, N'Pink', NULL, CAST(N'2016-01-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A9D335E7-2389-4DE1-9484-DC4EC6BA81D4', 24, 44800.0000, 1360.0000, 500.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2016-01-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'53C088BA-6E14-4758-826A-56FC57D3EEDA', 32, 52712.0000, 1490.0000, 1500.0000, 750.0000, 1, N'Canary Yellow', NULL, CAST(N'2016-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6C76FDEC-683F-45E1-B027-20ACFD2F501C', 51, 4800.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-02-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'373B7D39-B5A3-4018-883C-AC81EF3B5D8F', 24, 38280.0000, 660.0000, 750.0000, 550.0000, 1, N'Red', NULL, CAST(N'2016-02-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C82D133F-3442-464B-A16A-D5419A9E1CDF', 3, 125560.0000, 2000.0000, 750.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2016-02-27' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A7A80CA3-06D6-40AF-A558-09146A650340', 12, 31600.0000, 500.0000, 1500.0000, 550.0000, 1, N'Green', NULL, CAST(N'2016-03-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A2112C27-FE1F-48C5-A3BE-A019EE17DDD6', 17, 2920.0000, 500.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2016-03-19' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'88AFBF67-13A6-4BC5-AE50-8C64F0F25453', 18, 176400.0000, 5500.0000, 3150.0000, 1950.0000, 0, N'Blue', NULL, CAST(N'2016-04-17' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'11790E1E-859C-4E05-B6B3-6D72DDCC8DAE', 6, 82360.0000, 2175.0000, 2200.0000, 750.0000, 1, N'Black', NULL, CAST(N'2016-04-26' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B165CAEF-FF77-4E63-98C1-59D97F97E7C9', 11, 14000.0000, 2000.0000, 500.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-04-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'23E7F9FA-67D4-47C1-8D66-F1CFBC33540F', 9, 79600.0000, 500.0000, 750.0000, 750.0000, 1, N'Black', NULL, CAST(N'2016-05-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'07F0D746-085B-4FB9-9F82-6CEAC851FBC3', 51, 14000.0000, 1360.0000, 225.0000, 150.0000, 0, N'Green', NULL, CAST(N'2016-05-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7BABE805-CE07-4C06-AAF1-6B5D83645CD8', 52, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-05-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D7BF8DD9-1841-4FDE-8469-66B09FA30A74', 76, 7960.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2016-05-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8F278478-CA0B-4CDB-8F02-1A054AAE88A9', 77, 31600.0000, 2000.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2016-05-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4FFB74AD-C031-4BD9-9589-A87F462E6842', 24, 39664.0000, 660.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2016-05-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'055F7639-30EA-4975-A8CB-29F5C1C1C48E', 86, 4400.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-05-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'518125AE-9A67-45A6-B3FD-557C785796FC', 11, 17720.0000, 1360.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-05-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'18974E49-6B03-4C6E-BA0C-D564CFF868E0', 31, 62000.0000, 2000.0000, 1500.0000, 750.0000, 1, N'Dark Purple', NULL, CAST(N'2016-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'65F89D52-9B2D-4363-8A07-4A5CE90197DB', 74, 28000.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2016-06-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'54A66D7C-9E0B-40E9-B1B1-CA655F060CDE', 75, 23720.0000, 660.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2016-06-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D93AF620-4F69-475A-98ED-829E0F8A3A40', 24, 36400.0000, 500.0000, 750.0000, 550.0000, 1, N'Red', NULL, CAST(N'2016-06-04' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'62611547-0F2D-41B1-BA32-E34AB67E10A3', 21, 26800.0000, 1360.0000, 750.0000, 550.0000, 0, N'Canary Yellow', NULL, CAST(N'2016-06-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0BE222D6-9254-4FC8-892D-76563CA81F9B', 32, 79600.0000, 2175.0000, 750.0000, 750.0000, 1, N'Silver', NULL, CAST(N'2016-06-06' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'521659A4-8FF2-441A-8D2E-C584D561301F', 13, 12520.0000, 500.0000, 225.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-06-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1A210C04-C981-4EA4-83B9-A6E76B5B9BDB', 11, 39600.0000, 500.0000, 500.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2016-07-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'66CCEBEA-00EA-44B3-BBFE-AC5EC2DE456D', 51, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-07-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B36188E4-3684-4337-91FE-84BB33736476', 2, 156000.0000, 3950.0000, 3150.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2016-07-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'66C9034C-23A3-44F1-B946-2DDA65E684D8', 3, 164000.0000, 9250.0000, 750.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2016-07-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E00D10E9-7F7F-49A9-BDC0-4C2611580B4E', 14, 53200.0000, 1490.0000, 750.0000, 750.0000, 1, N'Black', NULL, CAST(N'2016-07-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'AAF61ECC-0BAC-4EAF-9E50-01749253329A', 15, 15600.0000, 1360.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-07-09' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A1A4180E-B929-467D-91A6-73D2D0F34C65', 32, 63600.0000, 2000.0000, 1500.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2016-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B5E7DD25-9D69-464C-9327-A8C5E706F534', 86, 11672.0000, 500.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2016-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0B0E0FC2-E72B-4BD4-9C46-1AF98F17BEC4', 87, 10200.0000, 970.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2016-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7F08368D-B6EA-4DFC-A1EC-B1A1B0221F04', 24, 180000.0000, 5500.0000, 3150.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2016-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'356EE84B-F4FD-4923-9423-D58E2863E9A1', 25, 36480.0000, 500.0000, 500.0000, 550.0000, 1, N'Dark Purple', NULL, CAST(N'2016-07-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'92D7DE8E-0BA7-4221-B2B1-A01F7FAFDD3E', 88, 5200.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-07-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'5BE0098D-511F-4CF1-B87C-2CE2532F1B31', 26, 82000.0000, 2175.0000, 1500.0000, 750.0000, 1, N'Pink', NULL, CAST(N'2016-07-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F0235F1B-636C-4E8B-8617-927F45DA97DB', 76, 20400.0000, 660.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-08-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BDC5E621-D976-478D-A620-A0751FCBEF96', 74, 79600.0000, 2000.0000, 750.0000, 750.0000, 1, N'Canary Yellow', NULL, CAST(N'2016-08-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'72EF5AA5-997C-4AC0-A32E-591D1E009818', 28, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Dark Purple', NULL, CAST(N'2016-08-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4BFD3782-0B79-4F4E-981A-96CEF827497F', 29, 49200.0000, 1360.0000, 750.0000, 550.0000, 1, N'Red', NULL, CAST(N'2016-08-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E6E23C74-39AF-4A44-BAAE-7CD48B0F6161', 25, 63600.0000, 1490.0000, 750.0000, 750.0000, 1, N'Red', NULL, CAST(N'2016-08-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'420701D6-5F66-4885-8A72-8B54541965A6', 12, 13200.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-08-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'870C2B0A-A6AE-4F84-91EF-806C985A02E5', 11, 26880.0000, 500.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2016-08-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6BF8C577-E615-4667-A48C-25E8D825AAC6', 11, 53200.0000, 2175.0000, 1500.0000, 750.0000, 1, N'British Racing Green', NULL, CAST(N'2016-08-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'74F717DA-B4DA-44F2-857A-F062AC60052E', 13, 15600.0000, 660.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-08-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'98C3863B-7A70-4FAD-B3C7-2B5702956E18', 23, 36000.0000, 500.0000, 150.0000, 550.0000, 1, N'Red', NULL, CAST(N'2016-08-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8C1E8506-711C-442A-89A4-EDA28EB5B788', 13, 15600.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-08-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BC4D491E-764B-48AE-BEDC-07DE123B7200', 32, 61200.0000, 2000.0000, 750.0000, 750.0000, 1, N'Pink', NULL, CAST(N'2016-08-20' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4C00023A-47C5-4F98-A9B1-F222EDE2F563', 26, 36720.0000, 500.0000, 500.0000, 550.0000, 0, N'Red', NULL, CAST(N'2016-08-20' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'170FAF32-4223-4806-B483-D89F4D38AC16', 27, 100000.0000, 500.0000, 2200.0000, 750.0000, 1, N'Green', NULL, CAST(N'2016-08-22' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9CFAF367-ED4B-4A3E-8CB2-394F1F7A58C1', 28, 52400.0000, 500.0000, 750.0000, 750.0000, 1, N'Green', NULL, CAST(N'2016-08-22' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'126C36BB-9C33-4BC5-9127-F941731DD0C8', 32, 73720.0000, 2175.0000, 225.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2016-08-22' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'98B3C1C2-7AE2-4A88-A3C9-484483C6EC66', 15, 7600.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-08-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4A40B2AA-A76B-4C08-A59B-19CDE0ED868C', 88, 7960.0000, 500.0000, 225.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2016-08-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'100EE806-DFE5-4C5E-9AB4-8F881615F8BD', 87, 4544.0000, 500.0000, 150.0000, 150.0000, 1, N'Canary Yellow', NULL, CAST(N'2016-08-26' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'00DDC5C0-E266-49E4-A785-E4F8BC3C9B24', 89, 15600.0000, 2000.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-08-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'97AFC7D5-91BF-47E3-8568-01B704E956C2', 90, 2800.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-09-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6A2699A6-ED27-42A9-B811-06D19EB5FA3C', 89, 3160.0000, 500.0000, 150.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-09-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'70C9BE5C-3CCA-4FB2-B4DE-E5F0A61BB84D', 11, 16760.0000, 1360.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-09-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B76D6985-E106-4213-AACC-288088795C92', 13, 6000.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2016-09-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'955E8BC5-C31B-4EE5-A48D-76517063C334', 26, 45200.0000, 500.0000, 1500.0000, 550.0000, 1, N'Dark Purple', NULL, CAST(N'2016-09-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2FCD3EBC-CBA7-4B3C-B6A0-A3A011D3A47B', 27, 39600.0000, 660.0000, 500.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2016-09-06' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'155E940E-7AA7-47EA-B83F-B3521F0B5718', 11, 55120.0000, 500.0000, 750.0000, 750.0000, 1, N'Dark Purple', NULL, CAST(N'2016-09-09' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B25CB659-C0A2-451E-AADB-7A006414D6E1', 28, 44000.0000, 500.0000, 150.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2016-09-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'19D1000C-178F-4BBA-9B19-C93804D047AC', 73, 2860.0000, 500.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2016-09-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DD6A0129-40CF-449F-8427-1C97BF14B2BD', 73, 28200.0000, 500.0000, 750.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2016-09-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'66D70810-1EE2-4BCA-B1B4-1E5B86C75002', 74, 15680.0000, 1360.0000, 150.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-09-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'384778FF-C28D-4FE6-9BEF-D787EFDC23CF', 74, 22312.0000, 970.0000, 500.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-09-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B760CF74-6468-4A0D-9485-36C7F7710EB0', 11, 36760.0000, 970.0000, 750.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2016-09-16' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E1350CBE-B916-4F18-B5BF-F7D53A31205A', 12, 7960.0000, 500.0000, 150.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-09-17' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9D74A1A9-7342-4FEA-9C21-6AC4EFE92018', 87, 5240.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-09-18' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6943ADF3-01A4-4281-B0CE-93384FE60418', 88, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2016-10-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BB4B9483-7AE3-47B4-A788-7EB5D12A7516', 33, 61200.0000, 2175.0000, 750.0000, 750.0000, 1, N'Canary Yellow', NULL, CAST(N'2016-10-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2319EA77-F4D9-4E34-9771-C42DCA3E210C', 34, 151600.0000, 500.0000, 1500.0000, 1950.0000, 1, N'Blue', NULL, CAST(N'2016-10-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6120D922-6703-4267-969B-A9A9D3CAE787', 35, 95680.0000, 1490.0000, 2200.0000, 750.0000, 0, N'Green', NULL, CAST(N'2016-10-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'30DC26F7-E98B-4FE8-B834-D625EC7E12F3', 33, 68520.0000, 2175.0000, 750.0000, 750.0000, 0, N'Silver', NULL, CAST(N'2016-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3D993E95-26AF-416D-B89E-688873C03AA7', 88, 12760.0000, 660.0000, 750.0000, 150.0000, 0, N'Blue', NULL, CAST(N'2016-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'34A69512-CDC3-4BEB-ADCB-AAE360CA7CF4', 89, 7960.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3EDC8773-9603-4D38-9DC9-64E1C4768F7D', 88, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9FF62C70-89E4-4815-912F-C5DFBF8BDF0F', 22, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EC25FA02-2692-42E1-85A0-71F0775C8F8A', 23, 45512.0000, 2000.0000, 750.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2016-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E368D03E-239C-499F-A41A-CC4D2AE1AFF8', 24, 44000.0000, 660.0000, 500.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2016-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4C1762AE-F7FD-4F2C-875B-CAC022B0DF63', 88, 7992.0000, 500.0000, 750.0000, 150.0000, 0, N'Black', NULL, CAST(N'2016-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DB8869B2-1EC0-48D5-9DA6-FDF1665155F0', 25, 37200.0000, 2000.0000, 750.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2016-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DD651733-FE5C-46B9-AC97-727F8CD170A6', 89, 7600.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2016-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F810FAB0-6BAE-4AC0-BDBC-F14A71AC35B9', 26, 100400.0000, 3950.0000, 1500.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2016-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3CF2C0F8-21E1-4ADE-AE72-AB9DFE3790DD', 35, 79600.0000, 1490.0000, 750.0000, 750.0000, 1, N'Dark Purple', NULL, CAST(N'2016-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A017241D-3A92-4EA7-A3EE-22FC119542F8', 36, 48400.0000, 500.0000, 1500.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2016-12-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4537B83B-2444-4389-B2DE-F30E15608163', 17, 98800.0000, 2000.0000, 750.0000, 750.0000, 0, N'Black', NULL, CAST(N'2016-12-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7CEA62B1-9CBE-4E13-BECC-54E7EED128EF', 18, 20000.0000, 1360.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2016-12-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'102A734C-3212-4708-85A5-A96FE8E14641', 18, 135600.0000, 9250.0000, 1500.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2016-12-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9B8B87E1-7770-4136-8EB4-B7173C8783A6', 34, 79600.0000, 2175.0000, 750.0000, 750.0000, 1, N'Black', NULL, CAST(N'2016-12-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C0E2E06D-AE60-4223-9E7C-B8387F2A4335', 14, 31600.0000, 500.0000, 500.0000, 550.0000, 1, N'Canary Yellow', NULL, CAST(N'2016-12-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3EEC687A-759C-4D8A-8776-E257E8230376', 16, 18000.0000, 1360.0000, 750.0000, 150.0000, 1, N'Pink', NULL, CAST(N'2016-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'09FA3947-726D-4987-B9DD-2F4CF7CD7C45', 26, 100000.0000, 500.0000, 1500.0000, 750.0000, 1, N'Green', NULL, CAST(N'2016-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'52CE8210-53B8-4C09-B821-6389A09733C5', 38, 68000.0000, 1490.0000, 1500.0000, 750.0000, 1, N'Black', NULL, CAST(N'2016-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DE44149E-1225-4B7C-97E5-8089A4F21C1C', 99, 1000.0000, 500.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CF9A23D7-6F8A-4CA6-A037-95EA7385B539', 45, 18000.0000, 500.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E9FE6FE1-1957-4BD4-8643-D8326BC43255', 46, 18760.0000, 500.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'98299E86-0B98-42D8-A549-37D89435B4E3', 3, 100760.0000, 9250.0000, 2200.0000, 1950.0000, 0, N'Black', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F187F74F-3909-4291-A15B-F793AB88DE3B', 5, 156000.0000, 5500.0000, 1500.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DD8D9340-29B0-4E0D-89B3-BD33B70E087D', 89, 7080.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BBDFB7CF-FBA6-4463-BC1E-FE79522431EE', 87, 7960.0000, 500.0000, 750.0000, 150.0000, 1, N'Pink', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'837C835A-5341-46C7-A282-14612449DDB0', 46, 18800.0000, 2000.0000, 500.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-01-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'47077B33-09BC-4FF2-B71B-58E243952BAA', 28, 45200.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-01-20' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A48E5430-ACA4-41FD-BC6F-446BE2B46DF8', 29, 44000.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-01-21' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'AB327B58-DD8E-46F9-BF23-DE6D1C0F7AD8', 28, 62800.0000, 500.0000, 750.0000, 750.0000, 1, N'Red', NULL, CAST(N'2017-01-21' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E869D5E4-CAC0-48ED-8961-03D0405EA2FD', 28, 45560.0000, 1360.0000, 750.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2017-01-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'74DD8FE1-B205-4400-A951-1E54E7C22E40', 10, 292000.0000, 3950.0000, 750.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'579AD98F-B7A5-456A-8F17-5B77A5479767', 9, 125200.0000, 9250.0000, 1500.0000, 1950.0000, 0, N'Night Blue', NULL, CAST(N'2017-02-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7392B5F6-783C-4D4B-B687-74A98411A7CB', 10, 316000.0000, 9250.0000, 2200.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2017-02-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'01B087C6-00D1-40B2-808F-B4B5BC1E344D', 54, 17200.0000, 500.0000, 500.0000, 150.0000, 1, N'Dark Purple', NULL, CAST(N'2017-02-04' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'11BCE306-33ED-4C8D-9198-2A4B653D9F8A', 55, 5200.0000, 500.0000, 750.0000, 150.0000, 1, N'Pink', NULL, CAST(N'2017-02-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A08FCF25-5B27-4215-BF50-E94D0F7C8CD6', 56, 1800.0000, 500.0000, 750.0000, 150.0000, 1, N'Canary Yellow', NULL, CAST(N'2017-02-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8F100F91-FE3C-4338-AA52-7BF61A540199', 98, 2800.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-02-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'84BE4607-F8D7-49DA-8C27-D87FE529DF96', 89, 4544.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-02-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EB59DB36-5E67-4AF1-AE8A-46E8999EEF45', 87, 6840.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-02-28' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7372D1C7-800F-4DE4-B3BC-FFA46CE77099', 78, 125200.0000, 2000.0000, 1500.0000, 1950.0000, 1, N'Blue', NULL, CAST(N'2017-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E267042F-449B-4CA9-8BDE-5C197DC8A647', 25, 45200.0000, 660.0000, 750.0000, 550.0000, 0, N'Silver', NULL, CAST(N'2017-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2C377634-90F1-4BC1-A366-0F0EBD26910D', 29, 69200.0000, 2000.0000, 1500.0000, 750.0000, 1, N'Silver', NULL, CAST(N'2017-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'49D19AE8-FBBF-496C-BC1E-9450544DD193', 27, 53200.0000, 2175.0000, 1500.0000, 750.0000, 0, N'Black', NULL, CAST(N'2017-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0B3AEBF5-0997-447D-B0E8-B399B7343742', 14, 44480.0000, 660.0000, 750.0000, 550.0000, 1, N'Green', NULL, CAST(N'2017-03-12' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'643800B3-AD63-4B67-8ACF-672B91F04C57', 19, 244000.0000, 3950.0000, 3150.0000, 1950.0000, 0, N'Green', NULL, CAST(N'2017-03-12' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'5F898C04-BDFB-437B-A640-AE520F14031E', 91, 23200.0000, 500.0000, 750.0000, 150.0000, 1, N'Dark Purple', NULL, CAST(N'2017-03-12' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4831A9DA-09BD-4AC3-8984-947F284CD4A8', 22, 43992.0000, 970.0000, 500.0000, 550.0000, 1, N'Green', NULL, CAST(N'2017-03-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0588AA57-B6B5-47F5-910F-5A1099B0476D', 23, 34360.0000, 970.0000, 750.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2017-03-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'32C41EC9-CB3C-4D0F-9C85-2500CE2E4813', 65, 792.0000, 500.0000, 150.0000, 150.0000, 0, N'British Racing Green', NULL, CAST(N'2017-03-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1909CD9B-9C06-4CFB-B8AD-292967E55E2F', 68, 23600.0000, 970.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1B77D0BA-45C9-4C76-952E-B2FA2859B7AB', 41, 111600.0000, 9250.0000, 2200.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2017-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CD06C0DF-D3A2-4593-BF40-7DAE6B73F58C', 63, 236000.0000, 5500.0000, 750.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'08B3555E-47A2-4365-AED8-2DF054FF73E2', 62, 176400.0000, 9250.0000, 2200.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2017-04-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C1A812F1-5FA1-48BA-8787-16F2F0A704BC', 35, 63600.0000, 500.0000, 750.0000, 750.0000, 1, N'Red', NULL, CAST(N'2017-04-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3A8161E3-C69D-4CC0-83DA-18EDE07CC83A', 36, 45592.0000, 970.0000, 750.0000, 550.0000, 1, N'Red', NULL, CAST(N'2017-04-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'05AB94D5-2F8D-4B06-878D-615956C94EC2', 37, 130000.0000, 3950.0000, 3150.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2017-04-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B607E8E1-5ECA-4DE2-BC46-909DBF9371D3', 75, 63600.0000, 2175.0000, 750.0000, 750.0000, 0, N'Black', NULL, CAST(N'2017-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'57137FAF-3144-4CB7-BAAB-BA533A710E72', 74, 29200.0000, 500.0000, 500.0000, 550.0000, 1, N'Canary Yellow', NULL, CAST(N'2017-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7A12CA8A-DC67-4A4F-B6F4-8B150873523A', 64, 52712.0000, 500.0000, 750.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2017-05-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4A4A1D5E-1682-4ACA-A60D-0072693FE190', 21, 49200.0000, 1360.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-05-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C4ACB04E-C8D4-465E-8D66-8BA033443D61', 12, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-05-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'5D11974B-326C-44C5-BA1D-57968CAB0DEE', 10, 204000.0000, 9250.0000, 1500.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-05-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F8B48177-FB78-4245-935F-FB6FBCE8D870', 8, 204760.0000, 5500.0000, 750.0000, 1950.0000, 1, N'Blue', NULL, CAST(N'2017-05-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6AEAC4F1-4C81-4FAA-A97C-3DCC0E6CB5DE', 7, 200000.0000, 3950.0000, 3150.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-05-12' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A5BDB4E0-1544-449F-8596-D63D70548675', 54, 5200.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-05-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'06FD2864-8415-44A5-B022-B98BEFB7E490', 90, 7400.0000, 500.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2017-05-18' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'ECC534C7-B2DD-425C-98D3-98D2332B373C', 100, 760.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-05-19' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'589E8DB1-B2D4-4921-A11B-9A2A80EA73D9', 80, 236000.0000, 9250.0000, 3150.0000, 1950.0000, 1, N'Silver', NULL, CAST(N'2017-05-20' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BD15948E-42F0-41BC-920C-343E0816B0AB', 70, 79600.0000, 1490.0000, 750.0000, 750.0000, 1, N'Night Blue', NULL, CAST(N'2017-05-21' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E0760EF4-3939-4063-821F-5923EF8760B4', 60, 26800.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-05-22' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D3C15454-EF60-415F-860D-99D41F0A485F', 21, 36000.0000, 500.0000, 750.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2017-05-23' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DF5411FC-24C5-4CAB-89DF-54741054D8DD', 22, 29200.0000, 500.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-05-24' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8BB5BBD3-E03C-457C-86E2-67199FCB302A', 25, 62000.0000, 1490.0000, 1500.0000, 750.0000, 1, N'Canary Yellow', NULL, CAST(N'2017-05-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3A0070F8-C340-4B6F-9F36-4A1CBDB39FE9', 65, 1880.0000, 500.0000, 225.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2017-05-26' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'638FCDD5-AFFF-4DCA-AAEC-17F527FB9D02', 45, 26000.0000, 1360.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-05-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0C3EBD09-B9DF-414D-AD00-90F5819812D0', 85, 36000.0000, 500.0000, 750.0000, 550.0000, 1, N'Blue', NULL, CAST(N'2017-05-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A0098927-0C7D-4CC8-8022-57A24433EF61', 95, 1000.0000, 500.0000, 225.0000, 150.0000, 1, N'Red', NULL, CAST(N'2017-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8BB7FF86-2D80-40B7-B216-254C16843529', 87, 6800.0000, 500.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2017-06-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9743A284-D059-4EEB-98AB-ACDE88C1E9F5', 86, 5272.0000, 500.0000, 750.0000, 150.0000, 1, N'Dark Purple', NULL, CAST(N'2017-06-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'57E2BA34-6397-448F-8A8C-1306CC922231', 25, 79600.0000, 2175.0000, 750.0000, 750.0000, 1, N'Green', NULL, CAST(N'2017-06-09' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2EE943CB-2473-4333-8626-FC94FCD0947E', 458, 20000.0000, 500.0000, 150.0000, 150.0000, 1, N'Canary Yellow', NULL, CAST(N'2017-06-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1A80A54C-D98D-41D6-87EE-8F67F3B06FA8', 985, 15600.0000, 1360.0000, 500.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-06-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D32D55B7-3546-4CCA-B4C0-DBA976572CA2', 91, 10360.0000, 1360.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-06-12' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D05D6642-FABF-4F56-8A7E-D8C47A8AAB70', 52, 4520.0000, 500.0000, 150.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-06-21' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'658F0B06-2357-4DAA-803C-4DD7F569F270', 75, 23600.0000, 500.0000, 150.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-06-22' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2866BF16-7A79-4DB7-8657-30958E4035A9', 74, 45512.0000, 500.0000, 500.0000, 550.0000, 1, N'Red', NULL, CAST(N'2017-06-23' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'760F5558-3C9E-4B70-A412-0448B90B0D89', 96, 3160.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-06-23' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B09E4DDD-C2DD-45BE-B5F1-19FBF5970352', 85, 23600.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-06-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B4CC6E9A-8473-4A84-A811-73EABAFDC582', 52, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-06-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2595D5C0-5002-464B-8F2B-C873FB29B4F9', 41, 79960.0000, 1490.0000, 750.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2017-06-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D69ABA72-1B0D-4073-8B7D-D6CA65C4DDF7', 63, 268000.0000, 2000.0000, 2200.0000, 1950.0000, 0, N'Silver', NULL, CAST(N'2017-07-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'332CE8D2-E19F-4656-BCC6-E3E45AD09D85', 25, 45200.0000, 500.0000, 750.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2017-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'306507B9-D2E1-4C5D-8F01-C93C90C93B6E', 29, 79600.0000, 2175.0000, 750.0000, 750.0000, 1, N'Night Blue', NULL, CAST(N'2017-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2B0FC8E5-82CB-4804-8691-0586F2255E9E', 38, 108000.0000, 2000.0000, 1500.0000, 1950.0000, 1, N'Silver', NULL, CAST(N'2017-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'ACB85DBA-4914-4222-8D24-6D87B0DAE10A', 39, 71600.0000, 500.0000, 750.0000, 750.0000, 1, N'British Racing Green', NULL, CAST(N'2017-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'23E43063-5402-4946-8830-0723F6B3CE1C', 37, 132000.0000, 9250.0000, 3150.0000, 1950.0000, 1, N'Dark Purple', NULL, CAST(N'2017-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E59BFE04-E70B-4BAC-9269-ADC311ED0032', 48, 18080.0000, 1360.0000, 500.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8979136A-B34A-4CD3-B119-A6B158D15FFF', 46, 26140.0000, 660.0000, 500.0000, 550.0000, 1, N'Dark Purple', NULL, CAST(N'2017-08-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'34A4BB21-60B3-4B0D-8DDB-8189C471A581', 47, 36000.0000, 2000.0000, 500.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2017-08-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'AFAF5C3E-80C9-4C5A-9D2A-CDD238E40264', 58, 4400.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-08-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7FCABEE5-E116-4AE3-B7B1-483C2F0D18CA', 85, 44000.0000, 500.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-08-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B84575EE-2E61-482C-8B72-5A6A90ADC3FE', 21, 39600.0000, 1360.0000, 500.0000, 550.0000, 1, N'Green', NULL, CAST(N'2017-08-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DB2AF439-6293-4925-B905-1A57A0118B1A', 2, 200000.0000, 500.0000, 2200.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-09-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'15108517-AD0C-4FF2-A7D4-57679C374A68', 3, 124000.0000, 9250.0000, 750.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2017-09-03' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'10AD713C-C997-48BB-A5FB-F0B5FD26479B', 13, 12600.0000, 1360.0000, 750.0000, 150.0000, 1, N'Pink', NULL, CAST(N'2017-09-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C1C9D15D-9E57-4D22-8997-D1333EEC6B13', 15, 15600.0000, 1360.0000, 750.0000, 150.0000, 0, N'Black', NULL, CAST(N'2017-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8A275CE2-D116-49F7-8571-FD91F21ADAAA', 18, 188000.0000, 500.0000, 1500.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2017-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'009A5323-23E5-48BE-95DB-BA94E1897419', 51, 20000.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EBE7AD85-117F-4781-A5E5-13920EE2B546', 19, 196000.0000, 500.0000, 3150.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2017-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B822FA7C-5FA5-4F17-A3A6-7199CB00F7F8', 93, 31600.0000, 970.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F1997A16-CB98-4D67-BCA3-DD22D990D1D2', 92, 1800.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2017-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'ECD53BA8-3C63-4938-92C4-C955AEA6C4BC', 91, 18800.0000, 1360.0000, 500.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'26199C63-95B5-419B-A827-C0EEAF594A5B', 51, 8400.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C9D8FCFE-4A88-479C-A2CA-E2474AF4D8DF', 52, 9200.0000, 500.0000, 150.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'43195E1A-46B2-4554-B1A9-C849B1C0B53B', 53, 7960.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'05D4115C-3F27-4059-BDC8-C0C3FFC85E8B', 11, 40960.0000, 1360.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-11-11' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B503DD91-24FA-4F4A-AF49-1EB15347A33D', 21, 36760.0000, 500.0000, 150.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-11-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'896B39D5-8040-4947-94D0-0234B4E78B23', 12, 17280.0000, 1360.0000, 750.0000, 150.0000, 0, N'Red', NULL, CAST(N'2017-11-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BCA945A6-8F87-4A00-93ED-6F2A08F8F923', 94, 1276.0000, 500.0000, 225.0000, 150.0000, 0, N'Red', NULL, CAST(N'2017-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'38264675-F235-412B-9B67-8F8CD86CF40D', 939, 20000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2657F22B-5D29-4A7A-B3F9-3A04C14D7C93', 55, 18880.0000, 1360.0000, 750.0000, 150.0000, 0, N'Night Blue', NULL, CAST(N'2017-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7005E3EC-5DBF-4409-8545-AC401CF204DB', 44, 340000.0000, 2000.0000, 2200.0000, 1950.0000, 1, N'Canary Yellow', NULL, CAST(N'2017-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9BFDC1FA-8416-4F58-BE6C-3CCFA7A51860', 33, 79960.0000, 1490.0000, 750.0000, 750.0000, 1, N'Black', NULL, CAST(N'2017-12-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A88F114F-3808-4B2D-92BE-BD43EEA71742', 22, 37520.0000, 500.0000, 1500.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2017-12-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1860F37A-EBC7-42E9-B339-3F6D6048322F', 11, 36760.0000, 2000.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-12-09' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'00E07EB4-4A3A-434F-B3FC-76A312BEEF5D', 12, 6040.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2017-12-09' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C72ABA1C-D1FA-4A4B-9E16-9FE066D509BA', 12, 9592.0000, 500.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2017-12-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B8F3827A-5689-42B9-A1DE-26AFE7E2343E', 13, 10000.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2017-12-19' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A21CAFB1-7242-42D1-80AC-E5D26941E2BE', 13, 6000.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2017-12-20' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'76D2E902-DF33-4BE5-8181-B9DA01869131', 22, 45480.0000, 500.0000, 1500.0000, 550.0000, 1, N'Canary Yellow', NULL, CAST(N'2017-12-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2309FF52-564A-4A2C-B6EB-D94AA321D687', 23, 31600.0000, 1360.0000, 500.0000, 550.0000, 0, N'Black', NULL, CAST(N'2017-12-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2CE57C5E-98DE-402F-884A-A6227FD7FB5F', 22, 45560.0000, 500.0000, 1500.0000, 550.0000, 1, N'Pink', NULL, CAST(N'2017-12-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'61B73BA2-9EA0-4DB9-8D89-6E8D2A5D32DA', 21, 50000.0000, 500.0000, 750.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2017-12-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8BED3FBE-29EA-48AF-A8CE-7770F51A548F', 22, 34000.0000, 2000.0000, 150.0000, 550.0000, 1, N'Black', NULL, CAST(N'2017-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B0559A26-5CE0-4C70-89EC-C73C0837B1E8', 25, 52360.0000, 500.0000, 1500.0000, 750.0000, 1, N'Black', NULL, CAST(N'2017-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'99DF9E69-9DAF-4D81-8334-D7058F1030E2', 99, 1560.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D231E90A-140A-4623-AA79-16970966DDF3', 56, 920.0000, 500.0000, 750.0000, 150.0000, 0, N'Black', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'26122425-FE14-4318-8713-15C8F9EED630', 54, 9240.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'80B21E0F-66E3-4582-838A-D7EC560C7C0B', 87, 10056.0000, 2000.0000, 500.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'8D9BF815-FAE4-47CE-ADBB-33339D382319', 89, 7912.0000, 500.0000, 225.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F6C384B6-B768-4031-AC12-81C8CE37049E', 32, 45560.0000, 2000.0000, 500.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F9EF8BCC-5744-4EBC-91AD-739775C597D9', 85, 36760.0000, 660.0000, 1500.0000, 550.0000, 1, N'Dark Purple', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'457046F9-68AC-468E-9C5E-9C1B957FE9B9', 96, 760.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3DCFE242-5286-404C-A37E-5207E6F51BB1', 74, 17240.0000, 970.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BF9128E0-D61A-4214-8128-44A9880E20C2', 52, 4760.0000, 500.0000, 225.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'808F1237-9F5C-484F-8E14-63FF713A864D', 63, 284000.0000, 9250.0000, 7500.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2018-01-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'790E96BC-2F59-4B8F-9DE2-6BB65F92216B', 41, 96000.0000, 2175.0000, 750.0000, 750.0000, 1, N'Black', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'88975E00-70FD-44B6-9A1F-9E3B9CCE4382', 15, 14280.0000, 1360.0000, 150.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6218BE0E-185B-4B12-8696-AA976EA81B29', 26, 82920.0000, 1490.0000, 750.0000, 750.0000, 1, N'Pink', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'03AC7842-CA66-4AC0-92AD-F538494D1FAE', 35, 146000.0000, 5500.0000, 1500.0000, 1950.0000, 1, N'Green', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7FF88424-96A2-4149-ABF3-21AC9FBCDD4C', 57, 18000.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'48437CA9-988E-42EA-94F8-DC2D6DA48BA7', 59, 17200.0000, 500.0000, 750.0000, 150.0000, 0, N'Black', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CDF97188-5367-4CCF-94DF-AC41093B9A48', 89, 6000.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-02-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E010830C-E636-49F7-ABA6-2DFDF502A587', 96, 1800.0000, 500.0000, 750.0000, 150.0000, 0, N'Canary Yellow', NULL, CAST(N'2018-02-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F5F70D13-C9BD-48E6-A903-ABC5F289A758', 69, 18120.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2018-02-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'89C3293F-F665-4E93-9929-315CBA3DD498', 36, 79160.0000, 1490.0000, 750.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2018-02-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'59650ADF-0886-43B4-B360-3A79E0CA327E', 63, 284000.0000, 9250.0000, 2200.0000, 1950.0000, 1, N'Blue', NULL, CAST(N'2018-02-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4BA7F44F-422D-4AD2-84B3-2AE4F0028DB8', 56, 4800.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-03-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1DDF23D7-3CB8-49C7-A19B-2A9C5AB23ADF', 54, 4552.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2018-03-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A2201698-CA26-428A-988F-ABB4A8893E21', 25, 45520.0000, 1360.0000, 500.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2018-03-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F556C096-7EFE-4827-9AFF-2FD0416B1C9B', 20, 116000.0000, 9250.0000, 1500.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2018-03-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9868BF47-F113-4721-BF95-26FEF8DD51D2', 1, 79600.0000, 500.0000, 1500.0000, 750.0000, 1, N'Silver', NULL, CAST(N'2018-03-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C7086D43-16DA-444F-A461-76DA9C479425', 5, 98800.0000, 2175.0000, 1500.0000, 750.0000, 1, N'Dark Purple', NULL, CAST(N'2018-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'20041639-9549-415A-AEC2-7159352E8CB7', 8, 248000.0000, 9250.0000, 7900.0000, 1950.0000, 0, N'Silver', NULL, CAST(N'2018-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'AF51E444-D0BE-477F-8834-615824E0A89C', 13, 7840.0000, 500.0000, 750.0000, 150.0000, 1, N'Canary Yellow', NULL, CAST(N'2018-03-08' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'FAB39B43-A811-4410-A69A-707C35C767E7', 15, 12760.0000, 500.0000, 500.0000, 150.0000, 0, N'Silver', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A23F2E70-66D3-44A1-982C-ADE1ECA9CC30', 18, 204000.0000, 2000.0000, 150.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1D997989-769F-4879-B7E1-837015CEEFC5', 85, 19600.0000, 660.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BFC6861C-8D2E-40C8-A4F7-07F9E41056DC', 48, 10360.0000, 1360.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'07E4BA14-7B78-4B11-9A11-1520460A5631', 6, 124000.0000, 3950.0000, 3150.0000, 1950.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9E98DDEF-D2A3-4BEC-99DD-BEFEFC11E5EE', 56, 2000.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A4A2F089-526E-4C69-AACC-F58488B2E1C7', 25, 36400.0000, 500.0000, 750.0000, 550.0000, 0, N'Green', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7808CA65-E449-4280-A128-F5B581F47B8F', 45, 31600.0000, 500.0000, 750.0000, 550.0000, 1, N'Green', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B2D76C72-FA30-40AE-9AB9-DFB47560348C', 46, 18800.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C19B3F44-9EA7-49FF-953A-86BF48B55615', 24, 36760.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A0F4D013-88EB-4692-B5EE-6BA800593036', 25, 44000.0000, 500.0000, 750.0000, 550.0000, 1, N'Blue', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9CD9439F-E15F-4469-BE82-7A4041633A50', 26, 80000.0000, 500.0000, 750.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'87A6B5EF-1E2B-49CA-85D7-263BC7E32189', 24, 35908.0000, 2000.0000, 750.0000, 550.0000, 1, N'British Racing Green', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'361E0EFF-56B8-4E0A-A1DD-41D4A51BF704', 78, 49200.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B89AF48B-4BB9-409B-876B-941E51D19381', 98, 760.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'15A09123-FE51-47D2-A7B0-600CB300F826', 100, 1200.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'FBF39066-2C13-469D-B913-EBCF22CCFD63', 4, 156000.0000, 2000.0000, 2200.0000, 1950.0000, 0, N'Black', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A326183E-7D45-4CF2-A353-7177A3EAB71F', 5, 156000.0000, 9250.0000, 750.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'266404D4-FBC5-4DC6-BB7C-A2ED7246D6D7', 21, 42000.0000, 500.0000, 750.0000, 550.0000, 0, N'Green', NULL, CAST(N'2018-04-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'798C76AF-985B-4B9F-B24A-4B4311AE2A08', 65, 1080.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'71C9EDC5-7897-4CCE-9B2F-5B04BEDC36D0', 98, 1996.0000, 500.0000, 750.0000, 150.0000, 1, N'Canary Yellow', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'61F8CF9A-F53C-4386-9BF8-578F54547CD2', 7, 215600.0000, 5500.0000, 1500.0000, 1950.0000, 1, N'Dark Purple', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'FF62897D-E06C-4BC1-B5EA-E6BE415B0CD1', 8, 156000.0000, 3950.0000, 1500.0000, 1950.0000, 1, N'Green', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'9555FF33-EE29-4A81-854A-69F6485BB216', 85, 20760.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EA1B19C6-631A-4683-9E29-1BC601FC850E', 86, 7992.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'27C180A1-7C39-4E88-B5DE-ACD0C9594F3C', 9, 108000.0000, 5500.0000, 5600.0000, 1950.0000, 1, N'British Racing Green', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'52F665EA-2D6D-4ECA-8A14-553522A45B04', 13, 12760.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BEC34DF7-3E37-4322-A406-04BB5DF2A0FE', 14, 71600.0000, 1490.0000, 750.0000, 750.0000, 1, N'Black', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F075AC9E-1124-4194-A05F-683F9D553335', 54, 14800.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2018-05-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'39CEB089-BC4F-4724-A47B-CDB0E2401714', 52, 12440.0000, 1360.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'05F6C06A-9CD8-448B-9F67-FDBC0A7CEDCE', 53, 2860.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B1ABF9BD-1FBC-4E9A-BCCC-0B9AFEE5CFF1', 86, 5560.0000, 500.0000, 457.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3D2907ED-A866-4E81-B7CB-723EA2254718', 84, 12480.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'607CA291-F642-4CBD-967B-7A36DF45D150', 75, 21200.0000, 500.0000, 750.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'695E6D94-12E6-49BC-8E23-29AC3EB38D93', 71, 26800.0000, 2000.0000, 750.0000, 550.0000, 0, N'Black', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'614ED49B-6DA9-4BFE-9560-3DB52A6593CD', 72, 19600.0000, 1360.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'532B985F-94AC-45DF-AE17-431FBCC66D0C', 21, 39600.0000, 970.0000, 750.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'740A7CB4-BF3F-46FD-98F3-D85748E5B9BA', 31, 79600.0000, 500.0000, 1050.0000, 750.0000, 1, N'Night Blue', NULL, CAST(N'2018-06-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D0B8D738-B33D-4F7F-BA25-46EC06DEB8E2', 21, 79992.0000, 2000.0000, 750.0000, 750.0000, 1, N'Silver', NULL, CAST(N'2018-07-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'23FDFA0D-C905-41A6-B95A-D5A3517293D8', 51, 5560.0000, 500.0000, 1050.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-07-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6A140D65-C354-48F6-A92E-40FF36CF1216', 54, 8400.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-07-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4AFC6EDF-49EA-4D57-85AF-D60734328922', 45, 26760.0000, 1360.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-07-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EF8621F7-41EB-4C2D-ADBD-D4287083D41F', 26, 58000.0000, 2175.0000, 1500.0000, 750.0000, 1, N'Night Blue', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E66B3E09-F02D-484A-8B9F-A8CD7833CD6B', 98, 1920.0000, 500.0000, 750.0000, 150.0000, 1, N'Canary Yellow', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'13F9FBD7-9342-4A2D-A249-E3AD6AE9A9CB', 74, 54800.0000, 500.0000, 1500.0000, 750.0000, 1, N'Dark Purple', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E68BB825-0487-44CA-AE6C-7C650F81E22B', 98, 1880.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'519C0ED1-7611-4CDC-8153-5C4B81A7FD0F', 82, 14800.0000, 970.0000, 1050.0000, 150.0000, 1, N'Pink', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3CD0AFE8-9909-4A5D-BA9F-5C1F71B0DEE3', 84, 4400.0000, 500.0000, 750.0000, 150.0000, 0, N'Blue', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'114760E3-FC54-4C31-B323-BC4B83AB80D0', 9, 102800.0000, 3950.0000, 2200.0000, 1950.0000, 1, N'Blue', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'757E7DB7-3688-41FD-AFB6-E49CC56BCCD8', 25, 44000.0000, 1360.0000, 1500.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'BA123B46-B5DF-439B-9326-82174419FC14', 98, 1000.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'FCB80D65-7D65-41E4-9081-6C92D0C7F1F5', 63, 276000.0000, 5500.0000, 457.0000, 1950.0000, 1, N'Red', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'51451AC8-A35F-4597-B4BC-94E92C150C3D', 21, 37520.0000, 2000.0000, 750.0000, 550.0000, 1, N'Red', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B56F7C8F-0452-49C2-BEE2-C4C53BF38AD8', 25, 28760.0000, 500.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0318C525-58CA-438E-A5A5-BA854855A664', 24, 66072.0000, 1490.0000, 457.0000, 750.0000, 1, N'Green', NULL, CAST(N'2018-07-25' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'17FA511D-1C85-4F74-A164-B4EE39F48565', 24, 90872.0000, 500.0000, 225.0000, 750.0000, 1, N'Night Blue', NULL, CAST(N'2018-07-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4B47A26E-2723-4E06-A661-21271A6759D0', 26, 36000.0000, 1360.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-07-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'47572651-C884-4C1D-A433-E8641A1A1172', 28, 46080.0000, 2000.0000, 1500.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2018-07-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2A27FF01-DC3C-4FE2-AC8C-9145C29F651C', 27, 82000.0000, 2175.0000, 1500.0000, 750.0000, 1, N'Black', NULL, CAST(N'2018-08-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F4443E46-3EAC-4C10-902C-71257DEEE229', 21, 31600.0000, 970.0000, 750.0000, 550.0000, 1, N'Blue', NULL, CAST(N'2018-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'4EE854BF-A9DD-453B-815E-E0692A75A969', 25, 49240.0000, 660.0000, 750.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3D2E9AD0-972B-4A09-895F-1833655CFB21', 26, 44000.0000, 1360.0000, 1500.0000, 550.0000, 1, N'Blue', NULL, CAST(N'2018-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'480D88A9-B1E5-4A79-9D2C-C1050C6DA00A', 30, 79600.0000, 2000.0000, 750.0000, 750.0000, 1, N'Silver', NULL, CAST(N'2018-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'EE92EE4A-977E-4BC6-BEFF-512CC468944C', 33, 45440.0000, 500.0000, 750.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2018-08-02' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B8498BEE-D1C5-4D93-981F-640031A3AE6C', 31, 71600.0000, 1490.0000, 750.0000, 750.0000, 1, N'Dark Purple', NULL, CAST(N'2018-08-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A44EE0A0-B924-4B29-9C05-BA4BFADE084B', 32, 58000.0000, 1490.0000, 225.0000, 750.0000, 1, N'British Racing Green', NULL, CAST(N'2018-08-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C8C871B4-F08D-445A-BCD1-ACFEC616A113', 30, 45560.0000, 970.0000, 750.0000, 550.0000, 0, N'Red', NULL, CAST(N'2018-08-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'47693731-F213-4E60-97D6-115A7BD83259', 45, 50000.0000, 500.0000, 225.0000, 550.0000, 1, N'Canary Yellow', NULL, CAST(N'2018-09-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'73FB2744-5AD9-42DC-A29C-B9B2FEF8353C', 45, 45512.0000, 1360.0000, 750.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2018-09-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'DB742D0B-E562-41F4-AC94-8C58C2B0B69C', 46, 26880.0000, 2000.0000, 457.0000, 550.0000, 1, N'Dark Purple', NULL, CAST(N'2018-09-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'51784E0D-09DB-4A40-8E92-CB09A0DE4444', 47, 24400.0000, 1360.0000, 750.0000, 150.0000, 1, N'Silver', NULL, CAST(N'2018-09-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1A861C29-F198-4D34-BDAF-B35E8080320A', 66, 20000.0000, 1360.0000, 457.0000, 150.0000, 1, N'Green', NULL, CAST(N'2018-09-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'D0F51768-8924-4EF5-A3E9-B31AC7129BFB', 67, 20400.0000, 1360.0000, 750.0000, 150.0000, 1, N'Dark Purple', NULL, CAST(N'2018-09-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E8FF8444-2B18-45A0-84AC-F776755E06ED', 68, 31600.0000, 970.0000, 750.0000, 550.0000, 1, N'Night Blue', NULL, CAST(N'2018-09-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'A3E788F8-889C-45E1-A610-881983869F6B', 69, 10000.0000, 500.0000, 457.0000, 150.0000, 1, N'Pink', NULL, CAST(N'2018-09-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C8F49B5E-EDDB-42D0-BE0F-8C4181A6C81D', 94, 920.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-09-30' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1D5C9493-4BA2-415A-B4D6-7079278CA2DC', 95, 1560.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-10-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0A059F54-46DE-4A25-8B5D-D7373AEE6F91', 94, 2000.0000, 500.0000, 750.0000, 150.0000, 1, N'Blue', NULL, CAST(N'2018-10-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6AE8BA09-AE75-4CA4-81EE-6CD2B3947120', 23, 55600.0000, 2000.0000, 457.0000, 750.0000, 1, N'Blue', NULL, CAST(N'2018-10-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3BDD9316-9359-464B-B98E-308494AD3056', 25, 36000.0000, 500.0000, 750.0000, 550.0000, 1, N'Silver', NULL, CAST(N'2018-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3C17F01C-25FF-463B-86AA-1A34FEA02FF2', 28, 45592.0000, 970.0000, 457.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6FF2BEFA-53A6-40CB-A427-ECD8197D0CC5', 71, 24400.0000, 1360.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-10-10' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'30EC553A-ADEA-4503-B748-C908A979EC45', 71, 17880.0000, 970.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2D512849-C35D-4B54-BDC8-C5523C1ABF86', 72, 44000.0000, 500.0000, 457.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0E2AECED-5A41-412A-9414-DE7217C0B6EB', 72, 69200.0000, 2175.0000, 750.0000, 750.0000, 1, N'Red', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'91B4067A-EBDE-4C1E-9370-3E894FD2FD7D', 73, 14280.0000, 970.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'436E43FB-E015-48E4-B549-33F4A0EE8D3F', 71, 20760.0000, 1360.0000, 457.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E166158C-F3BA-47DE-A499-A703210CF128', 75, 23600.0000, 660.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'1C9E6944-A890-4D7B-8F98-32B7276A78B3', 74, 47200.0000, 2000.0000, 750.0000, 550.0000, 0, N'Blue', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CF66838B-8A21-4084-9771-07A82CDBEBD8', 86, 7160.0000, 500.0000, 228.0000, 150.0000, 1, N'Dark Purple', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'7461FB42-ECE2-4C8C-BDBB-EF26AF3069F9', 87, 7600.0000, 500.0000, 750.0000, 150.0000, 1, N'Green', NULL, CAST(N'2018-10-29' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F287EE1D-48C6-4E75-9595-E0AE235FBEA8', 86, 7600.0000, 500.0000, 330.0000, 150.0000, 1, N'Green', NULL, CAST(N'2018-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'98828061-0C7A-42C2-95D0-3095AD2EF0E4', 87, 7120.0000, 500.0000, 750.0000, 150.0000, 1, N'British Racing Green', NULL, CAST(N'2018-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E519F3CF-BE4B-44CF-98D5-80EC33EC6CE1', 86, 9272.0000, 500.0000, 250.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'E6923E8C-C07A-430F-B80D-7D5F329055AB', 86, 6800.0000, 500.0000, 750.0000, 150.0000, 1, N'Red', NULL, CAST(N'2018-11-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'0487C263-79B7-4F2B-8D0E-B0BAA41D7F24', 25, 47600.0000, 500.0000, 500.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'92FDF39E-6565-4B68-80BA-02ED30F00A7E', 26, 98800.0000, 2000.0000, 3150.0000, 750.0000, 1, N'Black', NULL, CAST(N'2018-12-01' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'5D7C9AA9-F0C7-4F8E-8524-6481BE3CC62E', 25, 79600.0000, 1490.0000, 750.0000, 750.0000, 1, N'Night Blue', NULL, CAST(N'2018-12-05' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'CD2E20D3-1A10-4460-AC3B-FAC658F5F6F4', 24, 43600.0000, 970.0000, 289.0000, 550.0000, 1, N'Black', NULL, CAST(N'2018-12-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'3C384AE3-7F59-4CD6-BAFE-5E6EFFD25FAD', 95, 1272.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-12-07' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'6556A473-CE18-428F-8F33-955E80FBA888', 87, 9200.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-12-15' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'F166C930-3101-42E9-8AE8-189F47FA0014', 54, 14360.0000, 2000.0000, 1050.0000, 150.0000, 1, N'Night Blue', NULL, CAST(N'2018-12-16' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'2E0E8003-F9CC-486D-9D08-D4DAC688C800', 65, 4400.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C2623FF4-88AA-40E9-AF3B-8D009C25027B', 100, 760.0000, 500.0000, 750.0000, 150.0000, 1, N'Black', NULL, CAST(N'2018-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'C7569243-BDDB-4250-901E-EA6034824106', 1, 116000.0000, 3950.0000, NULL, 1950.0000, 1, N'Black', NULL, CAST(N'2018-12-31' AS Date), CAST(N'12:55:00' AS Time))
GO
INSERT [Data].[Stock] ([StockCode], [ModelID], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [IsRHD], [Color], [BuyerComments], [DateBought], [TimeBought]) VALUES (N'B9F1708F-3396-4755-A8C0-288FBE4EAF9C', NULL, NULL, NULL, 500.0000, NULL, 1, NULL, NULL, NULL, NULL)
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Magic Motors', N'United Kingdom', 52000.0000, 2175.0000, 1500.0000, 750.0000, CAST(65000.00 AS Numeric(18, 2)), CAST(N'2015-01-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Snazzy Roadsters', N'United Kingdom', 176000.0000, 5500.0000, 2200.0000, 1950.0000, CAST(220000.00 AS Numeric(18, 2)), CAST(N'2015-01-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'London Executive Prestige Vehicles', N'United Kingdom', 135600.0000, 5500.0000, 2200.0000, 1950.0000, CAST(169500.00 AS Numeric(18, 2)), CAST(N'2015-05-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Glittering Prize Cars Ltd', N'United Kingdom', 156000.0000, 6000.0000, 1500.0000, 1950.0000, CAST(195000.00 AS Numeric(18, 2)), CAST(N'2015-05-28T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Casseroles Chromes', N'France', 15960.0000, 1360.0000, 500.0000, 150.0000, CAST(19950.00 AS Numeric(18, 2)), CAST(N'2015-02-28T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'M. Pierre Dubois', N'France', 15680.0000, 890.0000, 500.0000, 150.0000, CAST(19600.00 AS Numeric(18, 2)), CAST(N'2015-04-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'M. Pierre Dubois', N'France', 7160.0000, 500.0000, 750.0000, 150.0000, CAST(8950.00 AS Numeric(18, 2)), CAST(N'2015-05-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'WunderKar', N'Germany', 9200.0000, 500.0000, 750.0000, 150.0000, CAST(11500.00 AS Numeric(18, 2)), CAST(N'2015-02-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 15600.0000, 660.0000, 500.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2015-02-03T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Posh Vehicles Ltd', N'United Kingdom', 7160.0000, 360.0000, 750.0000, 150.0000, CAST(8950.00 AS Numeric(18, 2)), CAST(N'2015-09-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Wonderland Wheels', N'United Kingdom', 6800.0000, 250.0000, 750.0000, 150.0000, CAST(8500.00 AS Numeric(18, 2)), CAST(N'2015-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Convertible Dreams', N'United Kingdom', 18360.0000, 500.0000, 750.0000, 150.0000, CAST(22950.00 AS Numeric(18, 2)), CAST(N'2015-11-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'SuperSport S.A.R.L.', N'France', 44800.0000, 1785.0000, 500.0000, 550.0000, CAST(56000.00 AS Numeric(18, 2)), CAST(N'2015-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Magic Motors', N'United Kingdom', 23600.0000, 500.0000, 750.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2015-03-14T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 39600.0000, 2500.0000, 1500.0000, 550.0000, CAST(49500.00 AS Numeric(18, 2)), CAST(N'2015-03-24T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Eat My Exhaust Ltd', N'United Kingdom', 60800.0000, 3250.0000, 750.0000, 750.0000, CAST(76000.00 AS Numeric(18, 2)), CAST(N'2015-03-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Alexei Tolstoi', N'United Kingdom', 55600.0000, 1490.0000, 1500.0000, 750.0000, CAST(69500.00 AS Numeric(18, 2)), CAST(N'2015-12-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Sondra Horowitz', N'United States', 29200.0000, 1950.0000, 500.0000, 550.0000, CAST(36500.00 AS Numeric(18, 2)), CAST(N'2015-04-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Theo Kowalski', N'United States', 98872.0000, 2175.0000, 2200.0000, 750.0000, CAST(123590.00 AS Numeric(18, 2)), CAST(N'2015-10-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Wonderland Wheels', N'United Kingdom', 64400.0000, 500.0000, 750.0000, 750.0000, CAST(80500.00 AS Numeric(18, 2)), CAST(N'2015-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'La Bagnole de Luxe', N'France', 18360.0000, 550.0000, 500.0000, 150.0000, CAST(22950.00 AS Numeric(18, 2)), CAST(N'2015-06-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Convertible Dreams', N'United Kingdom', 6956.0000, 400.0000, 750.0000, 150.0000, CAST(8695.00 AS Numeric(18, 2)), CAST(N'2015-07-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJS', N'SuperSport S.A.R.L.', N'France', 15600.0000, 290.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2015-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Alexei Tolstoi', N'United Kingdom', 18392.0000, 390.0000, 750.0000, 150.0000, CAST(22990.00 AS Numeric(18, 2)), CAST(N'2015-07-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJS', N'Alexei Tolstoi', N'United Kingdom', 18080.0000, 660.0000, 750.0000, 150.0000, CAST(22600.00 AS Numeric(18, 2)), CAST(N'2015-10-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Peter McLuckie', N'United Kingdom', 12480.0000, 1100.0000, 500.0000, 150.0000, CAST(15600.00 AS Numeric(18, 2)), CAST(N'2015-09-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Peter McLuckie', N'United Kingdom', 10120.0000, 320.0000, 750.0000, 150.0000, CAST(12650.00 AS Numeric(18, 2)), CAST(N'2015-09-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2015] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Theo Kowalski', N'United States', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2015-08-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'360', N'Glitz', N'Germany', 79600.0000, 500.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Mrs. Ivana Telford', N'United Kingdom', 156000.0000, 3950.0000, 3150.0000, 1950.0000, CAST(195000.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Honest Pete Motors', N'United Kingdom', 125200.0000, 2200.0000, 3150.0000, 1950.0000, CAST(156500.00 AS Numeric(18, 2)), CAST(N'2016-09-19T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Mondial', N'King Leer Cars', N'United Kingdom', 82360.0000, 2175.0000, 2200.0000, 750.0000, CAST(102950.00 AS Numeric(18, 2)), CAST(N'2016-04-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Alexei Tolstoi', N'United Kingdom', 164000.0000, 9250.0000, 750.0000, 1950.0000, CAST(205000.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Wonderland Wheels', N'United Kingdom', 132000.0000, 3950.0000, 2200.0000, 1950.0000, CAST(165000.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Sondra Horowitz', N'United States', 127600.0000, 2000.0000, 3150.0000, 1950.0000, CAST(159500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Casseroles Chromes', N'France', 53200.0000, 2175.0000, 1500.0000, 750.0000, CAST(66500.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'SuperSport S.A.R.L.', N'France', 31600.0000, 500.0000, 1500.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-02-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Glitz', N'Germany', 15600.0000, 500.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-08-19T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Prestige Imports', N'Spain', 55120.0000, 500.0000, 750.0000, 750.0000, CAST(68900.00 AS Numeric(18, 2)), CAST(N'2016-09-11T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'959', N'Alicia Almodovar', N'Spain', 31600.0000, 500.0000, 500.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-12-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 6000.0000, 500.0000, 750.0000, 150.0000, CAST(7500.00 AS Numeric(18, 2)), CAST(N'2016-09-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'959', N'Convertible Dreams', N'United Kingdom', 53200.0000, 1490.0000, 750.0000, 750.0000, CAST(66500.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Jason B. Wight', N'United States', 14000.0000, 2000.0000, 500.0000, 150.0000, CAST(17500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Jason B. Wight', N'United States', 10120.0000, 500.0000, 750.0000, 150.0000, CAST(12650.00 AS Numeric(18, 2)), CAST(N'2016-01-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Silver HubCaps', N'United Kingdom', 7040.0000, 140.0000, 750.0000, 150.0000, CAST(8800.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Peter McLuckie', N'United Kingdom', 26880.0000, 500.0000, 500.0000, 550.0000, CAST(33600.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Peter McLuckie', N'United Kingdom', 13200.0000, 500.0000, 750.0000, 150.0000, CAST(16500.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Posh Vehicles Ltd', N'United Kingdom', 23600.0000, 1360.0000, 500.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2016-01-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Posh Vehicles Ltd', N'United Kingdom', 16760.0000, 1360.0000, 750.0000, 150.0000, CAST(20950.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Alexei Tolstoi', N'United Kingdom', 36760.0000, 970.0000, 750.0000, 550.0000, CAST(45950.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Eat My Exhaust Ltd', N'United Kingdom', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'928', N'Screamin'' Wheels', N'United Kingdom', 7600.0000, 500.0000, 750.0000, 150.0000, CAST(9500.00 AS Numeric(18, 2)), CAST(N'2016-08-28T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Liverpool Executive Prestige Vehicles', N'United Kingdom', 12520.0000, 500.0000, 750.0000, 150.0000, CAST(15650.00 AS Numeric(18, 2)), CAST(N'2016-07-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'928', N'Kieran O''Harris', N'United Kingdom', 15600.0000, 1360.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Honest Pete Motors', N'United Kingdom', 17720.0000, 1360.0000, 750.0000, 150.0000, CAST(22150.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'King Leer Cars', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-09-18T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Diabolo', N'Vive La Vitesse', N'France', 135600.0000, 9250.0000, 1500.0000, 1950.0000, CAST(169500.00 AS Numeric(18, 2)), CAST(N'2016-12-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Diabolo', N'Glitz', N'Germany', 20000.0000, 1360.0000, 750.0000, 150.0000, CAST(25000.00 AS Numeric(18, 2)), CAST(N'2016-12-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Countach', N'Magic Motors', N'United Kingdom', 2920.0000, 500.0000, 750.0000, 150.0000, CAST(3650.00 AS Numeric(18, 2)), CAST(N'2016-02-28T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Countach', N'Convertible Dreams', N'United Kingdom', 98800.0000, 2000.0000, 750.0000, 750.0000, CAST(123500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vantage', N'Diplomatic Cars', N'Belgium', 100000.0000, 500.0000, 2200.0000, 750.0000, CAST(125000.00 AS Numeric(18, 2)), CAST(N'2016-08-23T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Laurent Saint Yves', N'France', 52400.0000, 500.0000, 750.0000, 750.0000, CAST(65500.00 AS Numeric(18, 2)), CAST(N'2016-08-24T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'SuperSport S.A.R.L.', N'France', 39664.0000, 660.0000, 500.0000, 550.0000, CAST(49580.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Vive La Vitesse', N'France', 36400.0000, 500.0000, 750.0000, 550.0000, CAST(45500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Rapide', N'WunderKar', N'Germany', 49200.0000, 1360.0000, 750.0000, 550.0000, CAST(61500.00 AS Numeric(18, 2)), CAST(N'2016-08-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Prestissimo!', N'Italy', 36000.0000, 500.0000, 750.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2016-08-19T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Glittering Prize Cars Ltd', N'United Kingdom', 44000.0000, 660.0000, 500.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2016-11-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Stan Collywobble', N'United Kingdom', 36480.0000, 500.0000, 500.0000, 550.0000, CAST(45600.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vantage', N'Stan Collywobble', N'United Kingdom', 39600.0000, 660.0000, 500.0000, 550.0000, CAST(49500.00 AS Numeric(18, 2)), CAST(N'2016-09-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Stan Collywobble', N'United Kingdom', 44800.0000, 1360.0000, 500.0000, 550.0000, CAST(56000.00 AS Numeric(18, 2)), CAST(N'2016-02-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Convertible Dreams', N'United Kingdom', 36720.0000, 500.0000, 500.0000, 550.0000, CAST(45900.00 AS Numeric(18, 2)), CAST(N'2016-08-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Convertible Dreams', N'United Kingdom', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-08-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Alexei Tolstoi', N'United Kingdom', 82000.0000, 2175.0000, 1500.0000, 750.0000, CAST(102500.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Ronaldo Bianco', N'Italy', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Magic Motors', N'United Kingdom', 44000.0000, 500.0000, 750.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2016-09-11T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Snazzy Roadsters', N'United Kingdom', 45200.0000, 500.0000, 1500.0000, 550.0000, CAST(56500.00 AS Numeric(18, 2)), CAST(N'2016-09-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 45512.0000, 2000.0000, 750.0000, 550.0000, CAST(56890.00 AS Numeric(18, 2)), CAST(N'2016-11-03T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Honest Pete Motors', N'United Kingdom', 37200.0000, 2000.0000, 750.0000, 550.0000, CAST(46500.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Honest Pete Motors', N'United Kingdom', 100400.0000, 3950.0000, 1500.0000, 1950.0000, CAST(125500.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Vive La Vitesse', N'France', 79600.0000, 2175.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Glitz', N'Germany', 52712.0000, 1490.0000, 1500.0000, 750.0000, CAST(65890.00 AS Numeric(18, 2)), CAST(N'2016-02-17T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Prestige Imports', N'Spain', 63600.0000, 2000.0000, 1500.0000, 750.0000, CAST(79500.00 AS Numeric(18, 2)), CAST(N'2016-07-26T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Arnage', N'Executive Motor Delight', N'United Kingdom', 68520.0000, 2175.0000, 750.0000, 750.0000, CAST(85650.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Brooklands', N'Liverpool Executive Prestige Vehicles', N'United Kingdom', 79600.0000, 2175.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-12-28T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Arnage', N'Stan Collywobble', N'United Kingdom', 61200.0000, 2175.0000, 750.0000, 750.0000, CAST(76500.00 AS Numeric(18, 2)), CAST(N'2016-10-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Continental', N'Silver HubCaps', N'United Kingdom', 45560.0000, 2000.0000, 750.0000, 550.0000, CAST(56950.00 AS Numeric(18, 2)), CAST(N'2016-01-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Silver HubCaps', N'United Kingdom', 61200.0000, 2000.0000, 750.0000, 750.0000, CAST(76500.00 AS Numeric(18, 2)), CAST(N'2016-08-21T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Screamin'' Wheels', N'United States', 73720.0000, 2175.0000, 750.0000, 750.0000, CAST(92150.00 AS Numeric(18, 2)), CAST(N'2016-08-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Ghost', N'La Bagnole de Luxe', N'France', 48400.0000, 500.0000, 1500.0000, 550.0000, CAST(60500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Phantom', N'Prestissimo!', N'Italy', 79600.0000, 1490.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Phantom', N'Prestige Imports', N'Spain', 95680.0000, 1490.0000, 2200.0000, 750.0000, CAST(119600.00 AS Numeric(18, 2)), CAST(N'2016-10-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'M. Pierre Dubois', N'France', 2040.0000, 500.0000, 750.0000, 150.0000, CAST(2550.00 AS Numeric(18, 2)), CAST(N'2016-01-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Glitz', N'Germany', 4800.0000, 500.0000, 750.0000, 150.0000, CAST(6000.00 AS Numeric(18, 2)), CAST(N'2016-02-17T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Silver HubCaps', N'United Kingdom', 14000.0000, 1360.0000, 750.0000, 150.0000, CAST(17500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Spider', N'Wonderland Wheels', N'United Kingdom', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Jason B. Wight', N'United States', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-07-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJ12', N'M. Pierre Dubois', N'France', 2860.0000, 500.0000, 750.0000, 150.0000, CAST(3575.00 AS Numeric(18, 2)), CAST(N'2016-09-14T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'La Bagnole de Luxe', N'France', 15680.0000, 1360.0000, 750.0000, 150.0000, CAST(19600.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Vive La Vitesse', N'France', 23720.0000, 660.0000, 750.0000, 150.0000, CAST(29650.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'La Bagnole de Luxe', N'France', 22312.0000, 970.0000, 500.0000, 150.0000, CAST(27890.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'SuperSport S.A.R.L.', N'France', 79600.0000, 2000.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-08-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Peter Smith', N'United Kingdom', 28000.0000, 500.0000, 750.0000, 550.0000, CAST(35000.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'E-Type', N'Alexei Tolstoi', N'United Kingdom', 31600.0000, 2000.0000, 750.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJS', N'Alexei Tolstoi', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJ12', N'Glittering Prize Cars Ltd', N'United Kingdom', 28200.0000, 500.0000, 750.0000, 550.0000, CAST(35250.00 AS Numeric(18, 2)), CAST(N'2016-09-14T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'M. Pierre Dubois', N'France', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Prestissimo!', N'Italy', 11672.0000, 500.0000, 750.0000, 150.0000, CAST(14590.00 AS Numeric(18, 2)), CAST(N'2016-07-26T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Prestissimo!', N'Italy', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-08-28T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Prestige Imports', N'Spain', 10200.0000, 970.0000, 750.0000, 150.0000, CAST(12750.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Alicia Almodovar', N'Spain', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR7', N'Executive Motor Delight', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR7', N'Honest Pete Motors', N'United Kingdom', 7600.0000, 500.0000, 750.0000, 150.0000, CAST(9500.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Honest Pete Motors', N'United Kingdom', 5240.0000, 500.0000, 750.0000, 150.0000, CAST(6550.00 AS Numeric(18, 2)), CAST(N'2016-09-19T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Honest Pete Motors', N'United Kingdom', 7992.0000, 500.0000, 750.0000, 150.0000, CAST(9990.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'King Leer Cars', N'United Kingdom', 4544.0000, 500.0000, 750.0000, 150.0000, CAST(5680.00 AS Numeric(18, 2)), CAST(N'2016-08-29T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Silver HubCaps', N'United Kingdom', 5200.0000, 500.0000, 750.0000, 150.0000, CAST(6500.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2016] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'GT6', N'Alexei Tolstoi', N'United Kingdom', 2800.0000, 500.0000, 750.0000, 150.0000, CAST(3500.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'F50', N'Le Luxe en Motion', N'France', 204760.0000, 5500.0000, 750.0000, 1950.0000, CAST(255950.00 AS Numeric(18, 2)), CAST(N'2017-05-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Enzo', N'Laurent Saint Yves', N'France', 316000.0000, 9250.0000, 2200.0000, 1950.0000, CAST(395000.00 AS Numeric(18, 2)), CAST(N'2017-02-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Vive La Vitesse', N'France', 124000.0000, 9250.0000, 750.0000, 1950.0000, CAST(155000.00 AS Numeric(18, 2)), CAST(N'2017-09-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Enzo', N'Vive La Vitesse', N'France', 292000.0000, 3950.0000, 750.0000, 1950.0000, CAST(365000.00 AS Numeric(18, 2)), CAST(N'2017-02-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Alicia Almodovar', N'Spain', 200000.0000, 500.0000, 2200.0000, 1950.0000, CAST(250000.00 AS Numeric(18, 2)), CAST(N'2017-09-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Magic Motors', N'United Kingdom', 100760.0000, 9250.0000, 2200.0000, 1950.0000, CAST(125950.00 AS Numeric(18, 2)), CAST(N'2017-01-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Enzo', N'Magic Motors', N'United Kingdom', 204000.0000, 9250.0000, 1500.0000, 1950.0000, CAST(255000.00 AS Numeric(18, 2)), CAST(N'2017-05-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'F40', N'Screamin'' Wheels Corp', N'United States', 200000.0000, 3950.0000, 3150.0000, 1950.0000, CAST(250000.00 AS Numeric(18, 2)), CAST(N'2017-05-13T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'959', N'Casseroles Chromes', N'France', 44480.0000, 660.0000, 750.0000, 550.0000, CAST(55600.00 AS Numeric(18, 2)), CAST(N'2017-03-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Capots Reluisants S.A.', N'France', 6040.0000, 500.0000, 750.0000, 150.0000, CAST(7550.00 AS Numeric(18, 2)), CAST(N'2017-12-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Mme Anne Duport', N'France', 40960.0000, 1360.0000, 500.0000, 550.0000, CAST(51200.00 AS Numeric(18, 2)), CAST(N'2017-11-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'Boxster', N'Vive La Vitesse', N'France', 18000.0000, 1360.0000, 750.0000, 150.0000, CAST(22500.00 AS Numeric(18, 2)), CAST(N'2017-01-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Alicia Almodovar', N'Spain', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-05-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Antonio Maura', N'Spain', 39600.0000, 500.0000, 500.0000, 550.0000, CAST(49500.00 AS Numeric(18, 2)), CAST(N'2017-11-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Screamin'' Wheels', N'United States', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-12-27T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Antonio Maura', N'Spain', 9592.0000, 500.0000, 750.0000, 150.0000, CAST(11990.00 AS Numeric(18, 2)), CAST(N'2017-12-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Screamin'' Wheels', N'United Kingdom', 6000.0000, 500.0000, 750.0000, 150.0000, CAST(7500.00 AS Numeric(18, 2)), CAST(N'2017-12-27T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Pierre Blanc', N'United Kingdom', 36760.0000, 2000.0000, 500.0000, 550.0000, CAST(45950.00 AS Numeric(18, 2)), CAST(N'2017-12-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'928', N'Honest Pete Motors', N'United Kingdom', 15600.0000, 1360.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2017-10-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Glittering Prize Cars Ltd', N'United Kingdom', 17280.0000, 1360.0000, 750.0000, 150.0000, CAST(21600.00 AS Numeric(18, 2)), CAST(N'2017-12-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Theo Kowalski', N'United States', 12600.0000, 1360.0000, 750.0000, 150.0000, CAST(15750.00 AS Numeric(18, 2)), CAST(N'2017-09-26T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Diabolo', N'Laurent Saint Yves', N'France', 188000.0000, 500.0000, 1500.0000, 1950.0000, CAST(235000.00 AS Numeric(18, 2)), CAST(N'2017-10-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Jarama', N'Glitz', N'Germany', 244000.0000, 3950.0000, 3150.0000, 1950.0000, CAST(305000.00 AS Numeric(18, 2)), CAST(N'2017-03-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Jarama', N'Stefano DiLonghi', N'Italy', 196000.0000, 500.0000, 3150.0000, 1950.0000, CAST(245000.00 AS Numeric(18, 2)), CAST(N'2017-11-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Rapide', N'Diplomatic Cars', N'Belgium', 69200.0000, 2000.0000, 1500.0000, 750.0000, CAST(86500.00 AS Numeric(18, 2)), CAST(N'2017-03-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'M. Pierre Dubois', N'France', 45200.0000, 500.0000, 750.0000, 550.0000, CAST(56500.00 AS Numeric(18, 2)), CAST(N'2017-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Laurent Saint Yves', N'France', 29200.0000, 500.0000, 500.0000, 550.0000, CAST(36500.00 AS Numeric(18, 2)), CAST(N'2017-05-26T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Laurent Saint Yves', N'France', 62000.0000, 1490.0000, 1500.0000, 750.0000, CAST(77500.00 AS Numeric(18, 2)), CAST(N'2017-05-26T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Vive La Vitesse', N'France', 36000.0000, 1250.0000, 750.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-03-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Vive La Vitesse', N'France', 45200.0000, 500.0000, 750.0000, 550.0000, CAST(56500.00 AS Numeric(18, 2)), CAST(N'2017-01-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Rapide', N'London Executive Prestige Vehicles', N'United Kingdom', 79600.0000, 2175.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2017-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Sondra Horowitz', N'United States', 39600.0000, 1360.0000, 500.0000, 550.0000, CAST(49500.00 AS Numeric(18, 2)), CAST(N'2017-09-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Screamin'' Wheels', N'United Kingdom', 34360.0000, 970.0000, 750.0000, 550.0000, CAST(42950.00 AS Numeric(18, 2)), CAST(N'2017-03-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Rapide', N'Screamin'' Wheels', N'United Kingdom', 44000.0000, 500.0000, 750.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2017-01-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Peter Smith', N'United Kingdom', 100000.0000, 500.0000, 1500.0000, 750.0000, CAST(125000.00 AS Numeric(18, 2)), CAST(N'2017-01-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Liverpool Executive Prestige Vehicles', N'United Kingdom', 180000.0000, 5500.0000, 3150.0000, 1950.0000, CAST(225000.00 AS Numeric(18, 2)), CAST(N'2017-03-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'King Leer Cars', N'United Kingdom', 45200.0000, 660.0000, 750.0000, 550.0000, CAST(56500.00 AS Numeric(18, 2)), CAST(N'2017-03-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Honest Pete Motors', N'United Kingdom', 45560.0000, 1360.0000, 750.0000, 550.0000, CAST(56950.00 AS Numeric(18, 2)), CAST(N'2017-01-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'WunderKar', N'Germany', 79600.0000, 2175.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2017-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Glitz', N'Germany', 36000.0000, 500.0000, 750.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-05-24T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Ronaldo Bianco', N'Italy', 49200.0000, 1360.0000, 750.0000, 550.0000, CAST(61500.00 AS Numeric(18, 2)), CAST(N'2017-05-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Sport.Car', N'Italy', 37520.0000, 500.0000, 1500.0000, 550.0000, CAST(46900.00 AS Numeric(18, 2)), CAST(N'2017-12-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vantage', N'Magic Motors', N'United Kingdom', 53200.0000, 2175.0000, 1500.0000, 750.0000, CAST(66500.00 AS Numeric(18, 2)), CAST(N'2017-03-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Snazzy Roadsters', N'United Kingdom', 36760.0000, 500.0000, 750.0000, 550.0000, CAST(45950.00 AS Numeric(18, 2)), CAST(N'2017-12-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Arnage', N'Prestige Imports', N'Spain', 79960.0000, 1490.0000, 750.0000, 750.0000, CAST(99950.00 AS Numeric(18, 2)), CAST(N'2017-12-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Silver Shadow', N'SuperSport S.A.R.L.', N'France', 108000.0000, 2000.0000, 1500.0000, 1950.0000, CAST(135000.00 AS Numeric(18, 2)), CAST(N'2017-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Silver Seraph', N'Mme Anne Duport', N'France', 79960.0000, 1490.0000, 750.0000, 750.0000, CAST(99950.00 AS Numeric(18, 2)), CAST(N'2017-07-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Silver Seraph', N'Laurent Saint Yves', N'France', 111600.0000, 9250.0000, 2200.0000, 1950.0000, CAST(139500.00 AS Numeric(18, 2)), CAST(N'2017-04-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Wraith', N'Peter Smith', N'United Kingdom', 130000.0000, 3950.0000, 3150.0000, 1950.0000, CAST(162500.00 AS Numeric(18, 2)), CAST(N'2017-05-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Phantom', N'Liverpool Executive Prestige Vehicles', N'United Kingdom', 63600.0000, 500.0000, 750.0000, 750.0000, CAST(79500.00 AS Numeric(18, 2)), CAST(N'2017-05-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Corniche', N'King Leer Cars', N'United Kingdom', 71600.0000, 500.0000, 750.0000, 750.0000, CAST(89500.00 AS Numeric(18, 2)), CAST(N'2017-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Silver Shadow', N'Eat My Exhaust Ltd', N'United Kingdom', 68000.0000, 1490.0000, 1500.0000, 750.0000, CAST(85000.00 AS Numeric(18, 2)), CAST(N'2017-01-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'350SL', N'Capots Reluisants S.A.', N'France', 26140.0000, 660.0000, 500.0000, 550.0000, CAST(32675.00 AS Numeric(18, 2)), CAST(N'2017-08-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'500SL', N'Vive La Vitesse', N'France', 36000.0000, 2000.0000, 500.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-08-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'London Executive Prestige Vehicles', N'United Kingdom', 26000.0000, 1360.0000, 750.0000, 550.0000, CAST(32500.00 AS Numeric(18, 2)), CAST(N'2017-06-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'250SL', N'Screamin'' Wheels', N'United States', 18080.0000, 1360.0000, 500.0000, 150.0000, CAST(22600.00 AS Numeric(18, 2)), CAST(N'2017-08-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Stefan Van Helsing', N'Belgium', 8400.0000, 500.0000, 750.0000, 150.0000, CAST(10500.00 AS Numeric(18, 2)), CAST(N'2017-11-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Spider', N'Stefan Van Helsing', N'Belgium', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-07-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Spider', N'Mme Anne Duport', N'France', 9200.0000, 500.0000, 750.0000, 150.0000, CAST(11500.00 AS Numeric(18, 2)), CAST(N'2017-11-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Prestissimo!', N'Italy', 5200.0000, 500.0000, 750.0000, 150.0000, CAST(6500.00 AS Numeric(18, 2)), CAST(N'2017-05-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Spider', N'King Leer Cars', N'United Kingdom', 4520.0000, 500.0000, 750.0000, 150.0000, CAST(5650.00 AS Numeric(18, 2)), CAST(N'2017-06-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Convertible Dreams', N'United Kingdom', 20000.0000, 1360.0000, 750.0000, 150.0000, CAST(25000.00 AS Numeric(18, 2)), CAST(N'2017-11-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Screamin'' Wheels', N'United States', 17200.0000, 500.0000, 500.0000, 150.0000, CAST(21500.00 AS Numeric(18, 2)), CAST(N'2017-02-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Lichfield', N'Glitz', N'Germany', 18880.0000, 1360.0000, 750.0000, 150.0000, CAST(23600.00 AS Numeric(18, 2)), CAST(N'2017-12-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Princess', N'Magic Motors', N'United Kingdom', 1800.0000, 500.0000, 750.0000, 150.0000, CAST(2250.00 AS Numeric(18, 2)), CAST(N'2017-02-14T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Lichfield', N'Screamin'' Wheels', N'United Kingdom', 5200.0000, 500.0000, 750.0000, 150.0000, CAST(6500.00 AS Numeric(18, 2)), CAST(N'2017-02-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'BMW', N'E30', N'Capots Reluisants S.A.', N'France', 26800.0000, 500.0000, 750.0000, 550.0000, CAST(33500.00 AS Numeric(18, 2)), CAST(N'2017-05-23T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'BMW', N'Isetta', N'Silver HubCaps', N'United Kingdom', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2017-08-27T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bugatti', N'Veyron', N'Vive La Vitesse', N'France', 176400.0000, 9250.0000, 2200.0000, 1950.0000, CAST(220500.00 AS Numeric(18, 2)), CAST(N'2017-04-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bugatti', N'57C', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 268000.0000, 2000.0000, 2200.0000, 1950.0000, CAST(335000.00 AS Numeric(18, 2)), CAST(N'2017-07-03T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bugatti', N'57C', N'Honest Pete Motors', N'United Kingdom', 236000.0000, 5500.0000, 750.0000, 1950.0000, CAST(295000.00 AS Numeric(18, 2)), CAST(N'2017-04-07T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Citroen', N'Torpedo', N'Autos Sportivos', N'Spain', 52712.0000, 500.0000, 750.0000, 750.0000, CAST(65890.00 AS Numeric(18, 2)), CAST(N'2017-05-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Citroen', N'Rosalie', N'Kieran O''Harris', N'United Kingdom', 792.0000, 500.0000, 750.0000, 150.0000, CAST(990.00 AS Numeric(18, 2)), CAST(N'2017-03-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Delahaye', N'145', N'Prestige Imports', N'Spain', 23600.0000, 970.0000, 750.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2017-04-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Delorean', N'DMC 12', N'Pierre Blanc', N'United Kingdom', 79600.0000, 1490.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2017-05-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'SuperSport S.A.R.L.', N'France', 23600.0000, 500.0000, 750.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2017-06-24T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Sport.Car', N'Italy', 63600.0000, 2175.0000, 750.0000, 750.0000, CAST(79500.00 AS Numeric(18, 2)), CAST(N'2017-05-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lagonda', N'V12', N'Honest Pete Motors', N'United Kingdom', 125200.0000, 2000.0000, 1500.0000, 1950.0000, CAST(156500.00 AS Numeric(18, 2)), CAST(N'2017-03-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'McLaren', N'P1', N'M. Pierre Dubois', N'France', 236000.0000, 9250.0000, 3150.0000, 1950.0000, CAST(295000.00 AS Numeric(18, 2)), CAST(N'2017-05-21T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Noble', N'M600', N'Stefan Van Helsing', N'Belgium', 23600.0000, 1360.0000, 750.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2017-07-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Noble', N'M600', N'Posh Vehicles Ltd', N'United Kingdom', 36000.0000, 500.0000, 750.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2017-06-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Noble', N'M600', N'Eat My Exhaust Ltd', N'United Kingdom', 44000.0000, 500.0000, 500.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2017-08-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Diplomatic Cars', N'Belgium', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2017-02-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'Roadster', N'Stefan Van Helsing', N'Belgium', 18800.0000, 1360.0000, 500.0000, 150.0000, CAST(23500.00 AS Numeric(18, 2)), CAST(N'2017-11-06T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'SuperSport S.A.R.L.', N'France', 6840.0000, 500.0000, 750.0000, 150.0000, CAST(8550.00 AS Numeric(18, 2)), CAST(N'2017-03-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'Roadster', N'Antonio Maura', N'Spain', 10360.0000, 1360.0000, 750.0000, 150.0000, CAST(12950.00 AS Numeric(18, 2)), CAST(N'2017-06-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR3A', N'Antonio Maura', N'Spain', 31600.0000, 970.0000, 500.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2017-11-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'GT6', N'Stan Collywobble', N'United Kingdom', 7400.0000, 500.0000, 750.0000, 150.0000, CAST(9250.00 AS Numeric(18, 2)), CAST(N'2017-05-19T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR7', N'Glittering Prize Cars Ltd', N'United Kingdom', 4544.0000, 500.0000, 750.0000, 150.0000, CAST(5680.00 AS Numeric(18, 2)), CAST(N'2017-03-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Posh Vehicles Ltd', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2017-01-14T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'205', N'Stefan Van Helsing', N'Belgium', 3160.0000, 500.0000, 750.0000, 150.0000, CAST(3950.00 AS Numeric(18, 2)), CAST(N'2017-07-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'203', N'La Bagnole de Luxe', N'France', 1000.0000, 500.0000, 750.0000, 150.0000, CAST(1250.00 AS Numeric(18, 2)), CAST(N'2017-01-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'404', N'London Executive Prestige Vehicles', N'United Kingdom', 2800.0000, 500.0000, 750.0000, 150.0000, CAST(3500.00 AS Numeric(18, 2)), CAST(N'2017-03-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2017] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Reliant', N'Robin', N'London Executive Prestige Vehicles', N'United Kingdom', 760.0000, 500.0000, 750.0000, 150.0000, CAST(950.00 AS Numeric(18, 2)), CAST(N'2017-05-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'F40', N'Laurent Saint Yves', N'France', 215600.0000, 5500.0000, 1500.0000, 1950.0000, CAST(269500.00 AS Numeric(18, 2)), CAST(N'2018-05-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'F50', N'Capots Reluisants S.A.', N'France', 248000.0000, 9250.0000, 7900.0000, 1950.0000, CAST(310000.00 AS Numeric(18, 2)), CAST(N'2018-03-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Dino', N'Smooth Rocking Chrome', N'Italy', 156000.0000, 9250.0000, 750.0000, 1950.0000, CAST(195000.00 AS Numeric(18, 2)), CAST(N'2018-04-24T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'360', N'Smooth Rocking Chrome', N'Italy', 108000.0000, 5500.0000, 5600.0000, 1950.0000, CAST(135000.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Daytona', N'Antonio Maura', N'Spain', 79600.0000, 500.0000, 1500.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-03-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Dino', N'Antonio Maura', N'Spain', 98800.0000, 2175.0000, 1500.0000, 750.0000, CAST(123500.00 AS Numeric(18, 2)), CAST(N'2018-03-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'360', N'El Sport', N'Spain', 102800.0000, 3950.0000, 2200.0000, 1950.0000, CAST(128500.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Daytona', N'Andy Cheshire', N'United Kingdom', 116000.0000, 3950.0000, 2200.0000, 1950.0000, CAST(145000.00 AS Numeric(18, 2)), CAST(N'2018-12-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Mondial', N'King Leer Cars', N'United Kingdom', 124000.0000, 3950.0000, 3150.0000, 1950.0000, CAST(155000.00 AS Numeric(18, 2)), CAST(N'2018-04-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'F50', N'Stephany Rousso', N'United States', 156000.0000, 3950.0000, 1500.0000, 1950.0000, CAST(195000.00 AS Numeric(18, 2)), CAST(N'2018-05-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'959', N'Laurent Saint Yves', N'France', 71600.0000, 1490.0000, 750.0000, 750.0000, CAST(89500.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'928', N'Alicia Almodovar', N'Spain', 12760.0000, 500.0000, 500.0000, 150.0000, CAST(15950.00 AS Numeric(18, 2)), CAST(N'2018-04-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Pierre Blanc', N'United Kingdom', 7840.0000, 500.0000, 750.0000, 150.0000, CAST(9800.00 AS Numeric(18, 2)), CAST(N'2018-03-19T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'400GT', N'Antonio Maura', N'Spain', 116000.0000, 9250.0000, 1500.0000, 1950.0000, CAST(145000.00 AS Numeric(18, 2)), CAST(N'2018-03-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Diabolo', N'Kieran O''Harris', N'United Kingdom', 204000.0000, 2000.0000, 750.0000, 1950.0000, CAST(255000.00 AS Numeric(18, 2)), CAST(N'2018-04-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Jacques Mitterand', N'France', 55600.0000, 2000.0000, 750.0000, 750.0000, CAST(69500.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Ronaldo Bianco', N'Italy', 98800.0000, 2000.0000, 3150.0000, 750.0000, CAST(123500.00 AS Numeric(18, 2)), CAST(N'2018-12-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Bravissima!', N'Italy', 66072.0000, 1490.0000, 750.0000, 750.0000, CAST(82590.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Alicia Almodovar', N'Spain', 36760.0000, 500.0000, 750.0000, 550.0000, CAST(45950.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'YO! Speed!', N'Spain', 42000.0000, 500.0000, 750.0000, 550.0000, CAST(52500.00 AS Numeric(18, 2)), CAST(N'2018-04-29T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'YO! Speed!', N'Spain', 46080.0000, 2000.0000, 1500.0000, 550.0000, CAST(57600.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Screamin'' Wheels', N'United States', 52360.0000, 500.0000, 1500.0000, 750.0000, CAST(65450.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Screamin'' Wheels', N'United States', 44000.0000, 500.0000, 750.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Stephany Rousso', N'United States', 44000.0000, 1360.0000, 1500.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Stephany Rousso', N'United States', 36000.0000, 1360.0000, 750.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Silver HubCaps', N'United Kingdom', 50000.0000, 500.0000, 750.0000, 550.0000, CAST(62500.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'King Leer Cars', N'United Kingdom', 45480.0000, 500.0000, 1500.0000, 550.0000, CAST(56850.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Theo Kowalski', N'United States', 45520.0000, 1360.0000, 500.0000, 550.0000, CAST(56900.00 AS Numeric(18, 2)), CAST(N'2018-03-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Jason B. Wight', N'United States', 47600.0000, 500.0000, 500.0000, 550.0000, CAST(59500.00 AS Numeric(18, 2)), CAST(N'2018-12-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Stephany Rousso', N'United States', 45592.0000, 970.0000, 750.0000, 550.0000, CAST(56990.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Jayden Jones', N'United States', 90872.0000, 500.0000, 750.0000, 750.0000, CAST(113590.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Mr. Evan Telford', N'United Kingdom', 58000.0000, 2175.0000, 1500.0000, 750.0000, CAST(72500.00 AS Numeric(18, 2)), CAST(N'2018-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'ImpressTheNeighbours.Com', N'United Kingdom', 80000.0000, 500.0000, 750.0000, 750.0000, CAST(100000.00 AS Numeric(18, 2)), CAST(N'2018-04-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vantage', N'Pierre Blanc', N'United Kingdom', 82000.0000, 2175.0000, 1500.0000, 750.0000, CAST(102500.00 AS Numeric(18, 2)), CAST(N'2018-08-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Clubbing Cars', N'United Kingdom', 45560.0000, 500.0000, 1500.0000, 550.0000, CAST(56950.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Honest Pete Motors', N'United Kingdom', 34000.0000, 2000.0000, 750.0000, 550.0000, CAST(42500.00 AS Numeric(18, 2)), CAST(N'2018-01-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Executive Motor Delight', N'United Kingdom', 79992.0000, 2000.0000, 750.0000, 750.0000, CAST(99990.00 AS Numeric(18, 2)), CAST(N'2018-07-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Expensive Shine', N'United Kingdom', 49240.0000, 660.0000, 750.0000, 550.0000, CAST(61550.00 AS Numeric(18, 2)), CAST(N'2018-08-11T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Steve Docherty', N'United Kingdom', 44000.0000, 1360.0000, 1500.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2018-08-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Beltway Prestige Driving', N'United Kingdom', 35908.0000, 2000.0000, 750.0000, 550.0000, CAST(44885.00 AS Numeric(18, 2)), CAST(N'2018-04-20T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Boris Spry', N'United Kingdom', 43600.0000, 970.0000, 750.0000, 550.0000, CAST(54500.00 AS Numeric(18, 2)), CAST(N'2018-12-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Andrea Tarbuck', N'United Kingdom', 79600.0000, 1490.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-12-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB2', N'Mr. Evan Telford', N'United Kingdom', 31600.0000, 970.0000, 750.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2018-08-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'SuperSport S.A.R.L.', N'France', 58000.0000, 1490.0000, 750.0000, 750.0000, CAST(72500.00 AS Numeric(18, 2)), CAST(N'2018-09-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Brooklands', N'Capots Reluisants S.A.', N'France', 151600.0000, 500.0000, 1500.0000, 1950.0000, CAST(189500.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Mulsanne', N'Rodolph Legler', N'Germany', 79600.0000, 2000.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-08-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Glittering Prize Cars Ltd', N'United Kingdom', 45560.0000, 2000.0000, 500.0000, 550.0000, CAST(56950.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Mulsanne', N'Convertible Dreams', N'United Kingdom', 45560.0000, 970.0000, 750.0000, 550.0000, CAST(56950.00 AS Numeric(18, 2)), CAST(N'2018-09-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Continental', N'King Leer Cars', N'United Kingdom', 79600.0000, 500.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2018-06-23T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Continental', N'Screamin'' Wheels', N'United States', 71600.0000, 1490.0000, 750.0000, 750.0000, CAST(89500.00 AS Numeric(18, 2)), CAST(N'2018-09-01T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Silver Seraph', N'M. Pierre Dubois', N'France', 96000.0000, 2175.0000, 750.0000, 750.0000, CAST(120000.00 AS Numeric(18, 2)), CAST(N'2018-02-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Ghost', N'Boris Spry', N'United Kingdom', 79160.0000, 1490.0000, 750.0000, 750.0000, CAST(98950.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Phantom', N'Sondra Horowitz', N'United States', 146000.0000, 5500.0000, 1500.0000, 1950.0000, CAST(182500.00 AS Numeric(18, 2)), CAST(N'2018-02-12T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'350SL', N'Wladimir Lacroix', N'France', 26880.0000, 2000.0000, 750.0000, 550.0000, CAST(33600.00 AS Numeric(18, 2)), CAST(N'2018-09-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'Antonio Maura', N'Spain', 45512.0000, 1360.0000, 750.0000, 550.0000, CAST(56890.00 AS Numeric(18, 2)), CAST(N'2018-09-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'500SL', N'Pete Spring', N'United Kingdom', 24400.0000, 1360.0000, 750.0000, 150.0000, CAST(30500.00 AS Numeric(18, 2)), CAST(N'2018-09-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'Bling Motors', N'United Kingdom', 26760.0000, 1360.0000, 750.0000, 550.0000, CAST(33450.00 AS Numeric(18, 2)), CAST(N'2018-07-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'ImpressTheNeighbours.Com', N'United Kingdom', 50000.0000, 500.0000, 750.0000, 550.0000, CAST(62500.00 AS Numeric(18, 2)), CAST(N'2018-09-04T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'350SL', N'Executive Motor Delight', N'United Kingdom', 18800.0000, 1360.0000, 750.0000, 150.0000, CAST(23500.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'250SL', N'Kieran O''Harris', N'United Kingdom', 10360.0000, 1360.0000, 750.0000, 150.0000, CAST(12950.00 AS Numeric(18, 2)), CAST(N'2018-04-09T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'Screamin'' Wheels', N'United States', 31600.0000, 500.0000, 750.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'1750', N'Vive La Vitesse', N'France', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2018-04-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Ralph Obermann', N'Germany', 9240.0000, 500.0000, 750.0000, 150.0000, CAST(11550.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Alicia Almodovar', N'Spain', 4552.0000, 500.0000, 750.0000, 150.0000, CAST(5690.00 AS Numeric(18, 2)), CAST(N'2018-03-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Mary Blackhouse', N'United Kingdom', 5560.0000, 500.0000, 750.0000, 150.0000, CAST(6950.00 AS Numeric(18, 2)), CAST(N'2018-07-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Maurice Dujardin', N'United Kingdom', 8400.0000, 500.0000, 750.0000, 150.0000, CAST(10500.00 AS Numeric(18, 2)), CAST(N'2018-07-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Kieran O''Harris', N'United Kingdom', 14800.0000, 500.0000, 750.0000, 150.0000, CAST(18500.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Spider', N'Silver HubCaps', N'United Kingdom', 4760.0000, 500.0000, 750.0000, 150.0000, CAST(5950.00 AS Numeric(18, 2)), CAST(N'2018-01-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulietta', N'Screamin'' Wheels', N'United States', 14360.0000, 2000.0000, 750.0000, 150.0000, CAST(17950.00 AS Numeric(18, 2)), CAST(N'2018-12-17T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Princess', N'Vive La Vitesse', N'France', 4800.0000, 500.0000, 750.0000, 150.0000, CAST(6000.00 AS Numeric(18, 2)), CAST(N'2018-03-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Princess', N'Mr. Evan Telford', N'United Kingdom', 920.0000, 500.0000, 750.0000, 150.0000, CAST(1150.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Cambridge', N'ImpressTheNeighbours.Com', N'United Kingdom', 18000.0000, 1360.0000, 750.0000, 150.0000, CAST(22500.00 AS Numeric(18, 2)), CAST(N'2018-02-13T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Austin', N'Princess', N'Screamin'' Wheels', N'United States', 2000.0000, 500.0000, 750.0000, 150.0000, CAST(2500.00 AS Numeric(18, 2)), CAST(N'2018-04-11T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'BMW', N'Alpina', N'Wladimir Lacroix', N'France', 17200.0000, 500.0000, 750.0000, 150.0000, CAST(21500.00 AS Numeric(18, 2)), CAST(N'2018-02-14T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bugatti', N'57C', N'La Bagnole de Luxe', N'France', 284000.0000, 9250.0000, 7500.0000, 1950.0000, CAST(355000.00 AS Numeric(18, 2)), CAST(N'2018-01-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bugatti', N'57C', N'Bling Bling S.A.', N'France', 276000.0000, 5500.0000, 750.0000, 1950.0000, CAST(345000.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bugatti', N'57C', N'Andrea Tarbuck', N'United Kingdom', 284000.0000, 9250.0000, 2200.0000, 1950.0000, CAST(355000.00 AS Numeric(18, 2)), CAST(N'2018-02-17T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Citroen', N'Traaction Avant', N'Khader El Ghannam', N'France', 20000.0000, 1360.0000, 750.0000, 150.0000, CAST(25000.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Citroen', N'Rosalie', N'Laurent Saint Yves', N'France', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2018-12-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Citroen', N'Rosalie', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 1080.0000, 500.0000, 750.0000, 150.0000, CAST(1350.00 AS Numeric(18, 2)), CAST(N'2018-05-03T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Delahaye', N'135', N'Khader El Ghannam', N'France', 20400.0000, 1360.0000, 750.0000, 150.0000, CAST(25500.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Delahaye', N'175', N'Bravissima!', N'Italy', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Delahaye', N'145', N'Expensive Shine', N'United Kingdom', 31600.0000, 970.0000, 750.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2018-09-15T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Casseroles Chromes', N'France', 47200.0000, 2000.0000, 750.0000, 550.0000, CAST(59000.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'Mark V', N'Francois Chirac', N'France', 20760.0000, 1360.0000, 750.0000, 150.0000, CAST(25950.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Laurent Saint Yves', N'France', 17240.0000, 970.0000, 750.0000, 150.0000, CAST(21550.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Snazzy Roadsters', N'United Kingdom', 21200.0000, 500.0000, 750.0000, 150.0000, CAST(26500.00 AS Numeric(18, 2)), CAST(N'2018-06-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'Mark X', N'Glittering Prize Cars Ltd', N'United Kingdom', 19600.0000, 1360.0000, 750.0000, 150.0000, CAST(24500.00 AS Numeric(18, 2)), CAST(N'2018-06-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJ12', N'Alex McWhirter', N'United Kingdom', 14280.0000, 970.0000, 750.0000, 150.0000, CAST(17850.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Andy Cheshire', N'United Kingdom', 23600.0000, 660.0000, 750.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Mike Beeton', N'United Kingdom', 54800.0000, 500.0000, 1500.0000, 750.0000, CAST(68500.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'Mark V', N'Paul Blasio', N'United States', 26800.0000, 2000.0000, 750.0000, 550.0000, CAST(33500.00 AS Numeric(18, 2)), CAST(N'2018-06-18T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'Mark X', N'Jayden Jones', N'United States', 69200.0000, 2175.0000, 750.0000, 750.0000, CAST(86500.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lagonda', N'V12', N'Bling Motors', N'United Kingdom', 49200.0000, 500.0000, 750.0000, 550.0000, CAST(61500.00 AS Numeric(18, 2)), CAST(N'2018-04-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Morgan', N'Plus 4', N'ImpressTheNeighbours.Com', N'United Kingdom', 14800.0000, 970.0000, 750.0000, 150.0000, CAST(18500.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Noble', N'M600', N'Prestige Imports', N'Spain', 36760.0000, 660.0000, 1500.0000, 550.0000, CAST(45950.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Noble', N'M14', N'Melissa Bertrand', N'United Kingdom', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Noble', N'M600', N'My Shiny Sports Car Ltd.', N'United Kingdom', 20760.0000, 1360.0000, 750.0000, 150.0000, CAST(25950.00 AS Numeric(18, 2)), CAST(N'2018-05-23T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Flash Voitures', N'Belgium', 5560.0000, 500.0000, 750.0000, 150.0000, CAST(6950.00 AS Numeric(18, 2)), CAST(N'2018-06-03T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR7', N'Capots Reluisants S.A.', N'France', 7912.0000, 500.0000, 750.0000, 150.0000, CAST(9890.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Laurent Saint Yves', N'France', 7120.0000, 500.0000, 750.0000, 150.0000, CAST(8900.00 AS Numeric(18, 2)), CAST(N'2018-11-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Antonio Maura', N'Spain', 9200.0000, 500.0000, 750.0000, 150.0000, CAST(11500.00 AS Numeric(18, 2)), CAST(N'2018-12-16T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Posh Vehicles Ltd', N'United Kingdom', 6800.0000, 500.0000, 750.0000, 150.0000, CAST(8500.00 AS Numeric(18, 2)), CAST(N'2018-11-22T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'My Shiny Sports Car Ltd.', N'United Kingdom', 5272.0000, 500.0000, 750.0000, 150.0000, CAST(6590.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Beltway Prestige Driving', N'United Kingdom', 7992.0000, 500.0000, 750.0000, 150.0000, CAST(9990.00 AS Numeric(18, 2)), CAST(N'2018-05-23T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Pierre Blanc', N'United Kingdom', 10056.0000, 2000.0000, 500.0000, 150.0000, CAST(12570.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Stephany Rousso', N'United States', 7600.0000, 500.0000, 750.0000, 150.0000, CAST(9500.00 AS Numeric(18, 2)), CAST(N'2018-10-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Trabant', N'500', N'Mary Blackhouse', N'United Kingdom', 920.0000, 500.0000, 750.0000, 150.0000, CAST(1150.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Trabant', N'500', N'Mary Blackhouse', N'United Kingdom', 2000.0000, 500.0000, 750.0000, 150.0000, CAST(2500.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Trabant', N'600', N'Mary Blackhouse', N'United Kingdom', 1560.0000, 500.0000, 750.0000, 150.0000, CAST(1950.00 AS Numeric(18, 2)), CAST(N'2018-10-02T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Trabant', N'600', N'Bling Motors', N'United Kingdom', 1000.0000, 500.0000, 750.0000, 150.0000, CAST(1250.00 AS Numeric(18, 2)), CAST(N'2018-05-25T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Trabant', N'600', N'Boris Spry', N'United Kingdom', 1272.0000, 500.0000, 750.0000, 150.0000, CAST(1590.00 AS Numeric(18, 2)), CAST(N'2018-12-08T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'205', N'Stefan Van Helsing', N'Belgium', 760.0000, 500.0000, 750.0000, 150.0000, CAST(950.00 AS Numeric(18, 2)), CAST(N'2018-01-10T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'203', N'Jean-Yves Truffaut', N'France', 1560.0000, 500.0000, 750.0000, 150.0000, CAST(1950.00 AS Numeric(18, 2)), CAST(N'2018-01-05T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'404', N'Smooth Rocking Chrome', N'Italy', 1000.0000, 500.0000, 750.0000, 150.0000, CAST(1250.00 AS Numeric(18, 2)), CAST(N'2018-07-31T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'404', N'Leslie Whittington', N'United Kingdom', 1920.0000, 500.0000, 750.0000, 150.0000, CAST(2400.00 AS Numeric(18, 2)), CAST(N'2018-07-30T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'404', N'Clubbing Cars', N'United Kingdom', 760.0000, 500.0000, 750.0000, 150.0000, CAST(950.00 AS Numeric(18, 2)), CAST(N'2018-04-23T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Peugeot', N'404', N'Silver HubCaps', N'United Kingdom', 1996.0000, 500.0000, 750.0000, 150.0000, CAST(2495.00 AS Numeric(18, 2)), CAST(N'2018-05-03T00:00:00.000' AS DateTime))
GO
INSERT [DataTransfer].[Sales2018] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Reliant', N'Robin', N'Mrs. Ivana Telford', N'United Kingdom', 760.0000, 500.0000, 750.0000, 150.0000, CAST(950.00 AS Numeric(18, 2)), CAST(N'2018-12-31T00:00:00.000' AS DateTime))
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 52000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 176000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 15600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 9200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 15960.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 176000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 23600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 39600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 60800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 172000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 15680.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 29200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 6800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 36000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 135600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 7160.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 156000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 44800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 7040.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 125200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 7160.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 43000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 98872.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 18360.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 55600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 10000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 127600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 132000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 23600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 10120.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 44800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 38280.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 125560.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 31600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lagonda', N'Countach', 2920.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'McLaren', N'Diabolo', 176400.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Rolls Royce', N'Mondial', 82360.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 14000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Alfa Romeo', N'360', 79600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 39664.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 17720.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 36400.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 26800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 12520.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 39600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 156000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 164000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delahaye', N'959', 53200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delorean', N'928', 15600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 180000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 36480.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 82000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 63600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 13200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 26880.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 53200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 15600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 36000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 15600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 36720.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delorean', N'928', 7600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 16760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 6000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 45200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 55120.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 36760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 7960.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 10000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 45512.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 44000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 37200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 100400.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lagonda', N'Countach', 98800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'McLaren', N'Diabolo', 20000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'McLaren', N'Diabolo', 135600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delahaye', N'959', 31600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Jaguar', N'Boxster', 18000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 100000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 100760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bentley', N'Dino', 156000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Austin', N'Enzo', 292000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Alfa Romeo', N'360', 125200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Austin', N'Enzo', 316000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 45200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delahaye', N'959', 44480.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Morgan', N'Jarama', 244000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 43992.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 34360.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 49200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 10000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Austin', N'Enzo', 204000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Mercedes', N'F50', 204760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Maybach', N'F40', 200000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 36000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 29200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 62000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 79600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 45200.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 39600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Porsche', N'Testarossa', 200000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Lamborghini', N'355', 124000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 12600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delorean', N'928', 15600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'McLaren', N'Diabolo', 188000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Morgan', N'Jarama', 196000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 40960.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 36760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 17280.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 37520.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'BMW', N'911', 36760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 6040.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bugatti', N'924', 9592.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 10000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 6000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 45480.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 31600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 45560.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 50000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Trabant', N'DB4', 34000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 52360.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delorean', N'928', 14280.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 82920.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 45520.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Noble', N'400GT', 116000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Ferrari', N'Daytona', 79600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bentley', N'Dino', 98800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Mercedes', N'F50', 248000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 7840.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delorean', N'928', 12760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'McLaren', N'Diabolo', 204000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Rolls Royce', N'Mondial', 124000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 36400.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 36760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 44000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 80000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 35908.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Aston Martin', N'308', 156000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Bentley', N'Dino', 156000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 42000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Maybach', N'F40', 215600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Mercedes', N'F50', 156000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Alfa Romeo', N'360', 108000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Citroen', N'944', 12760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Delahaye', N'959', 71600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 39600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 79992.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 58000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Alfa Romeo', N'360', 102800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 44000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 37520.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 28760.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 66072.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 90872.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 36000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Triumph', N'DB2', 31600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 49240.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 44000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Peugeot', N'DB5', 55600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 36000.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 47600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Cadillac', N'Virage', 98800.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Riley', N'DB9', 79600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Reliant', N'DB6', 43600.0000)
GO
INSERT [Output].[StockPrices] ([MakeName], [ModelName], [Cost]) VALUES (N'Ferrari', N'Daytona', 116000.0000)
GO
SET IDENTITY_INSERT [Reference].[Budget] ON 
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (1, 100000.0000, 2015, 1, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (2, 100000.0000, 2015, 2, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (3, 125000.0000, 2015, 3, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (4, 125000.0000, 2015, 4, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (5, 200000.0000, 2015, 5, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (6, 150000.0000, 2015, 6, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (7, 10000.0000, 2015, 7, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (8, 50000.0000, 2015, 8, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (9, 50000.0000, 2015, 9, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (10, 50000.0000, 2015, 10, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (11, 50000.0000, 2015, 11, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (12, 50000.0000, 2015, 12, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (13, 200000.0000, 2016, 1, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (14, 200000.0000, 2016, 2, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (15, 200000.0000, 2016, 4, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (16, 200000.0000, 2016, 5, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (17, 200000.0000, 2016, 6, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (18, 300000.0000, 2016, 7, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (19, 300000.0000, 2016, 8, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (20, 300000.0000, 2016, 9, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (21, 300000.0000, 2016, 10, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (22, 300000.0000, 2016, 11, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (23, 450000.0000, 2016, 12, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (24, 450000.0000, 2017, 1, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (25, 450000.0000, 2017, 2, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (26, 600000.0000, 2017, 3, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (27, 600000.0000, 2017, 4, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (28, 1000000.0000, 2017, 5, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (29, 600000.0000, 2017, 6, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (30, 600000.0000, 2017, 7, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (31, 150000.0000, 2017, 8, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (32, 450000.0000, 2017, 9, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (33, 250000.0000, 2017, 10, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (34, 600000.0000, 2017, 11, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (35, 300000.0000, 2017, 12, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (36, 450000.0000, 2018, 1, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (37, 450000.0000, 2018, 2, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (38, 450000.0000, 2018, 3, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (39, 500000.0000, 2018, 4, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (40, 500000.0000, 2018, 5, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (41, 500000.0000, 2018, 6, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (42, 500000.0000, 2018, 7, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (43, 500000.0000, 2018, 8, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (44, 500000.0000, 2018, 9, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (45, 700000.0000, 2018, 10, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (46, 250000.0000, 2018, 11, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (47, 500000.0000, 2018, 12, N'TotalSales', N'Sales')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (48, 250000.0000, 2015, NULL, N'Black', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (49, 250000.0000, 2015, NULL, N'Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (50, 111500.0000, 2015, NULL, N'British Racing Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (51, 132000.0000, 2015, NULL, N'Canary Yellow', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (52, 250000.0000, 2015, NULL, N'Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (53, 50000.0000, 2015, NULL, N'Night Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (54, 250000.0000, 2015, NULL, N'Red', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (55, 50000.0000, 2015, NULL, N'Silver', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (56, 250000.0000, 2016, NULL, N'Black', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (57, 250000.0000, 2016, NULL, N'Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (58, 50000.0000, 2016, NULL, N'British Racing Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (59, 50000.0000, 2016, NULL, N'Canary Yellow', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (60, 50000.0000, 2016, NULL, N'Dark Purple', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (61, 250000.0000, 2016, NULL, N'Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (62, 400000.0000, 2016, NULL, N'Night Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (63, 50000.0000, 2016, NULL, N'Pink', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (64, 500000.0000, 2016, NULL, N'Red', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (65, 450000.0000, 2016, NULL, N'Silver', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (66, 500000.0000, 2017, NULL, N'Black', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (67, 500000.0000, 2017, NULL, N'Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (68, 869990.0000, 2017, NULL, N'British Racing Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (69, 50000.0000, 2017, NULL, N'Canary Yellow', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (70, 50000.0000, 2017, NULL, N'Dark Purple', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (71, 500000.0000, 2017, NULL, N'Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (72, 500000.0000, 2017, NULL, N'Night Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (73, 50000.0000, 2017, NULL, N'Pink', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (74, 500000.0000, 2017, NULL, N'Red', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (75, 800000.0000, 2017, NULL, N'Silver', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (76, 500000.0000, 2018, NULL, N'Black', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (77, 500000.0000, 2018, NULL, N'Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (78, 500000.0000, 2018, NULL, N'British Racing Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (79, 50000.0000, 2018, NULL, N'Canary Yellow', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (80, 500000.0000, 2018, NULL, N'Dark Purple', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (81, 500000.0000, 2018, NULL, N'Green', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (82, 500000.0000, 2018, NULL, N'Night Blue', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (83, 50000.0000, 2018, NULL, N'Pink', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (84, 50000.0000, 2018, NULL, N'Red', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (85, 50000.0000, 2018, NULL, N'Silver', N'Color')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (86, 100000.0000, 2016, 8, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (87, 15500.0000, 2017, 2, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (88, 100000.0000, 2017, 3, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (89, 45950.0000, 2017, 7, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (90, 34000.0000, 2017, 11, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (91, 950.0000, 2018, 1, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (92, 6950.0000, 2018, 6, N'Belgium', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (93, 19950.0000, 2015, 2, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (94, 19600.0000, 2015, 4, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (95, 8950.0000, 2015, 5, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (96, 22950.0000, 2015, 6, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (97, 75500.0000, 2015, 7, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (98, 2550.0000, 2016, 1, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (99, 39500.0000, 2016, 2, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (100, 49580.0000, 2016, 5, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (101, 180150.0000, 2016, 6, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (102, 231500.0000, 2016, 8, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (103, 51065.0000, 2016, 9, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (104, 100000.0000, 2016, 12, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (105, 80250.0000, 2017, 1, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (106, 100000.0000, 2017, 2, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (107, 109150.0000, 2017, 3, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (108, 360000.0000, 2017, 4, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (109, 698450.0000, 2017, 5, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (110, 29500.0000, 2017, 6, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (111, 291450.0000, 2017, 7, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (112, 77675.0000, 2017, 8, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (113, 100000.0000, 2017, 9, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (114, 100000.0000, 2017, 10, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (115, 62700.0000, 2017, 11, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (116, 7550.0000, 2017, 12, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (117, 250000.0000, 2018, 1, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (118, 250000.0000, 2018, 2, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (119, 250000.0000, 2018, 3, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (120, 9950.0000, 2018, 4, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (121, 359000.0000, 2018, 5, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (122, 345000.0000, 2018, 7, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (123, 250000.0000, 2018, 9, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (124, 154450.0000, 2018, 10, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (125, 8900.0000, 2018, 11, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (126, 5500.0000, 2018, 12, N'France', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (127, 11500.0000, 2015, 2, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (128, 71890.0000, 2016, 2, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (129, 99500.0000, 2016, 4, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (130, 81000.0000, 2016, 8, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (131, 25000.0000, 2016, 12, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (132, 250000.0000, 2017, 3, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (133, 45000.0000, 2017, 5, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (134, 99500.0000, 2017, 6, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (135, 23600.0000, 2017, 12, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (136, 11550.0000, 2018, 1, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (137, 99500.0000, 2018, 8, N'Germany', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (138, 14590.0000, 2016, 7, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (139, 54950.0000, 2016, 8, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (140, 12500.0000, 2016, 10, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (141, 99500.0000, 2016, 12, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (142, 147500.0000, 2017, 5, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (143, 44500.0000, 2017, 6, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (144, 250000.0000, 2017, 11, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (145, 46900.0000, 2017, 12, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (146, 195000.0000, 2018, 4, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (147, 135000.0000, 2018, 5, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (148, 100000.0000, 2018, 7, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (149, 12500.0000, 2018, 9, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (150, 123500.0000, 2018, 12, N'Italy', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (151, 79500.0000, 2016, 7, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (152, 12750.0000, 2016, 8, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (153, 68900.0000, 2016, 9, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (154, 132100.0000, 2016, 10, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (155, 39500.0000, 2016, 12, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (156, 29500.0000, 2017, 4, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (157, 78390.0000, 2017, 5, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (158, 12950.0000, 2017, 6, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (159, 250000.0000, 2017, 9, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (160, 89000.0000, 2017, 11, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (161, 111940.0000, 2017, 12, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (162, 45950.0000, 2018, 1, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (163, 373690.0000, 2018, 3, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (164, 114400.0000, 2018, 4, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (165, 128500.0000, 2018, 7, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (166, 57600.0000, 2018, 8, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (167, 56890.0000, 2018, 9, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (168, 11500.0000, 2018, 12, N'Spain', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (169, 285000.0000, 2015, 1, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (170, 19500.0000, 2015, 2, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (171, 155000.0000, 2015, 3, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (172, 89000.0000, 2015, 4, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (173, 364500.0000, 2015, 5, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (174, 31685.0000, 2015, 7, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (175, 37200.0000, 2015, 9, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (176, 22600.0000, 2015, 10, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (177, 22950.0000, 2015, 11, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (178, 69500.0000, 2015, 12, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (179, 263950.0000, 2016, 1, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (180, 59650.0000, 2016, 2, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (181, 141750.0000, 2016, 4, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (182, 49450.0000, 2016, 5, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (183, 57150.0000, 2016, 6, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (184, 501650.0000, 2016, 7, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (185, 354780.0000, 2016, 8, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (186, 447150.0000, 2016, 9, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (187, 172100.0000, 2016, 10, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (188, 111890.0000, 2016, 11, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (189, 414490.0000, 2016, 12, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (190, 457850.0000, 2017, 1, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (191, 8750.0000, 2017, 2, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (192, 557620.0000, 2017, 3, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (193, 295000.0000, 2017, 4, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (194, 606700.0000, 2017, 5, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (195, 83150.0000, 2017, 6, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (196, 524000.0000, 2017, 7, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (197, 60500.0000, 2017, 8, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (198, 19500.0000, 2017, 10, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (199, 25000.0000, 2017, 11, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (200, 146000.0000, 2017, 12, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (201, 295420.0000, 2018, 1, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (202, 476450.0000, 2018, 2, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (203, 9800.0000, 2018, 3, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (204, 653785.0000, 2018, 4, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (205, 66125.0000, 2018, 5, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (206, 150500.0000, 2018, 6, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (207, 318290.0000, 2018, 7, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (208, 258550.0000, 2018, 8, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (209, 189450.0000, 2018, 9, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (210, 52950.0000, 2018, 10, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (211, 8500.0000, 2018, 11, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (212, 301540.0000, 2018, 12, N'United Kingdom', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (213, 36500.0000, 2015, 4, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (214, 5500.0000, 2015, 8, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (215, 123590.0000, 2015, 10, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (216, 172150.0000, 2016, 1, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (217, 17500.0000, 2016, 4, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (218, 12500.0000, 2016, 7, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (219, 92150.0000, 2016, 8, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (220, 21500.0000, 2017, 2, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (221, 250000.0000, 2017, 5, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (222, 22600.0000, 2017, 8, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (223, 65250.0000, 2017, 9, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (224, 12500.0000, 2017, 12, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (225, 65450.0000, 2018, 1, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (226, 182500.0000, 2018, 2, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (227, 56900.0000, 2018, 3, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (228, 97000.0000, 2018, 4, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (229, 195000.0000, 2018, 5, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (230, 33500.0000, 2018, 6, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (231, 55000.0000, 2018, 7, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (232, 158590.0000, 2018, 8, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (233, 89500.0000, 2018, 9, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (234, 152990.0000, 2018, 10, N'United States', N'Country')
GO
INSERT [Reference].[Budget] ([BudgetKey], [BudgetValue], [Year], [Month], [BudgetDetail], [BudgetElement]) VALUES (235, 77450.0000, 2018, 12, N'United States', N'Country')
GO
SET IDENTITY_INSERT [Reference].[Budget] OFF
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-01-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-02-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-03-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-04-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-05-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-06-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-07-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-08-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-09-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-10-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-11-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2015-12-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-01-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-02-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-03-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-04-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-05-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-06-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-07-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-08-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-09-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-10-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-11-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2016-12-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-01-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-02-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-03-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-04-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-05-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-06-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-07-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-08-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-09-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-10-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-11-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2017-12-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-01-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-02-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-03-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-04-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-05-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-06-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-07-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-08-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-09-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-10-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-11-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-01' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-02' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-03' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-04' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-05' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-06' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-07' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-08' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-09' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-10' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-11' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-12' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-13' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-14' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-15' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-16' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-17' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-18' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-19' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-20' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-21' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-22' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-23' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-24' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-25' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-26' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-27' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-28' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-29' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-30' AS Date), NULL, NULL)
GO
INSERT [Reference].[Forex] ([ExchangeDate], [ISOCurrency], [ExchangeRate]) VALUES (CAST(N'2018-12-31' AS Date), NULL, NULL)
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Ferrari', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Porsche', N'Sports,Tourer')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Lamborghini', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Aston Martin', N'Sports,Tourer')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Bentley', N'Tourer,Chauffer,Prestige')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Rolls Royce', N'Chauffer,Prestige')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Maybach', N'Chauffer,Prestige')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Mercedes', N'Tourer,Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Alfa Romeo', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Austin', N'Relic')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'BMW', N'Sports,Tourer')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Bugatti', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Citroen', N'Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Delahaye', N'Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Delorean', N'Sports,Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Jaguar', N'Sports,Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Lagonda', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'McLaren', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Morgan', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Noble', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Triumph', N'Sports')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Trabant', N'Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Peugeot', N'Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Reliant', N'Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Riley', N'Family')
GO
INSERT [Reference].[MarketingCategories] ([MakeName], [MarketingType]) VALUES (N'Cadillac', N'Family')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Magic Motors', N'GB        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Snazzy Roadsters', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Birmingham Executive Prestige Vehicles', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'WunderKar', N'DE        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Casseroles Chromes', N'FR        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Le Luxe en Motion', N'CH        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Eat My Exhaust Ltd', N'GB        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'M. Pierre Dubois', N'FR        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Sondra Horowitz', N'US        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Wonderland Wheels', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'London Executive Prestige Vehicles', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Glittering Prize Cars Ltd', N'GB        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'La Bagnole de Luxe', N'FR        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Convertible Dreams', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Alexei Tolstoi', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'SuperSport S.A.R.L.', N'FR        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Theo Kowalski', N'US        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Peter McLuckie', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Posh Vehicles Ltd', N'GB        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Jason B. Wight', N'US        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Silver HubCaps', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Stan Collywobble', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Glitz', N'DE        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Matterhorn Motors', N'CH        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'King Leer Cars', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Honest Pete Motors', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Peter Smith', N'GB        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Vive La Vitesse', N'FR        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Liverpool Executive Prestige Vehicles', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Mrs. Ivana Telford', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Kieran O''Harris', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Prestige Imports', N'ES        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Prestissimo!', N'IT        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Diplomatic Cars', N'BE        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Laurent Saint Yves', N'FR        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Screamin'' Wheels', N'US        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Screamin'' Wheels', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Executive Motor Delight', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Alicia Almodovar', N'ES        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Ronaldo Bianco', N'IT        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Sport.Car', N'IT        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Autos Sportivos', N'ES        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Le Luxe en Motion', N'FR        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Screamin'' Wheels Corp', N'US        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Pierre Blanc', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Capots Reluisants S.A.', N'FR        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Stefano DiLonghi', N'IT        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Antonio Maura', N'ES        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Stefan Van Helsing', N'BE        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Mme Anne Duport', N'FR        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Screamin'' Wheels', N'US        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Clubbing Cars', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Jean-Yves Truffaut', N'FR        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Mr. Evan Telford', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Ralph Obermann', N'DE        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'ImpressTheNeighbours.Com', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Wladimir Lacroix', N'FR        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Raimondo Delattre', N'CH        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Boris Spry', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Andrea Tarbuck', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Beltway Prestige Driving', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Bling Motors', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Smooth Rocking Chrome', N'IT        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'YO! Speed!', N'ES        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Stephany Rousso', N'US        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'My Shiny Sports Car Ltd.', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Flash Voitures', N'BE        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Paul Blasio', N'US        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Mary Blackhouse', N'GB        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Maurice Dujardin', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Leslie Whittington', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Mike Beeton', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Melissa Bertrand', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'El Sport', N'ES        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Bling Bling S.A.', N'FR        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Bravissima!', N'IT        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Jayden Jones', N'US        ', N'Some')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Expensive Shine', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Steve Docherty', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Rodolph Legler', N'DE        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Pete Spring', N'GB        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Khader El Ghannam', N'FR        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Jacques Mitterand', N'FR        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Francoise LeBrun', N'CH        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Alex McWhirter', N'GB        ', N'None')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Francois Chirac', N'FR        ', N'Immense')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Andy Cheshire', N'GB        ', N'Lots')
GO
INSERT [Reference].[MarketingInformation] ([CUST], [Country], [SpendCapacity]) VALUES (N'Jimmy McFiddler', N'GB        ', N'Lots')
GO
INSERT [Reference].[SalesBudgets] ([BudgetArea], [BudgetAmount], [BudgetYear], [DateUpdated], [Comments], [BudgetMonth]) VALUES (N'USA', 250000.0000, 2017, CAST(N'2016-10-05T00:00:00.000' AS DateTime), N'Forgot to add this!', 3)
GO
INSERT [Reference].[SalesBudgets] ([BudgetArea], [BudgetAmount], [BudgetYear], [DateUpdated], [Comments], [BudgetMonth]) VALUES (N'Europe', 1149500.0000, 2017, CAST(N'2016-11-05T00:00:00.000' AS DateTime), N'Required too', 3)
GO
INSERT [Reference].[SalesBudgets] ([BudgetArea], [BudgetAmount], [BudgetYear], [DateUpdated], [Comments], [BudgetMonth]) VALUES (N'Rest of world', 50000.0000, 2017, CAST(N'2016-10-05T00:00:00.000' AS DateTime), N'Effort required', 3)
GO
INSERT [Reference].[SalesCategory] ([LowerThreshold], [UpperThreshold], [CategoryDescription]) VALUES (10000, 25000, N'Very Low')
GO
INSERT [Reference].[SalesCategory] ([LowerThreshold], [UpperThreshold], [CategoryDescription]) VALUES (25001, 50000, N'Low')
GO
INSERT [Reference].[SalesCategory] ([LowerThreshold], [UpperThreshold], [CategoryDescription]) VALUES (50001, 75000, N'Medium')
GO
INSERT [Reference].[SalesCategory] ([LowerThreshold], [UpperThreshold], [CategoryDescription]) VALUES (75001, 100000, N'High')
GO
INSERT [Reference].[SalesCategory] ([LowerThreshold], [UpperThreshold], [CategoryDescription]) VALUES (100001, 150000, N'Very High')
GO
INSERT [Reference].[SalesCategory] ([LowerThreshold], [UpperThreshold], [CategoryDescription]) VALUES (150001, 250000, N'Exceptional')
GO
SET IDENTITY_INSERT [Reference].[Staff] ON 
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (1, N'Amelia', NULL, NULL)
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (2, N'Gerard', 1, N'Finance')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (3, N'Chloe', 1, N'Marketing')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (4, N'Susan', 1, N'Sales')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (5, N'Andy', 4, N'Sales')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (6, N'Steve', 4, N'Sales')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (7, N'Stan', 4, N'Sales')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (8, N'Nathan', 4, N'Sales')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (9, N'Maggie', 4, N'Sales')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (10, N'Jenny', 2, N'Finance')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (11, N'Chris', 2, N'Finance')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (12, N'Megan', 3, N'Marketing')
GO
INSERT [Reference].[Staff] ([StaffID], [StaffName], [ManagerID], [Department]) VALUES (13, N'Sandy', 11, N'Finance')
GO
SET IDENTITY_INSERT [Reference].[Staff] OFF
GO
SET IDENTITY_INSERT [Reference].[StaffHierarchy] ON 
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/', 1, N'Amelia', NULL, NULL)
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/1/', 2, N'Gerard', 1, N'Finance')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/2/', 3, N'Chloe', 1, N'Marketing')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/3/', 4, N'Susan', 1, N'Sales')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/3/1/', 5, N'Andy', 4, N'Sales')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/3/2/', 6, N'Steve', 4, N'Sales')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/3/3/', 7, N'Stan', 4, N'Sales')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/3/4/', 8, N'Nathan', 4, N'Sales')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/3/5/', 9, N'Maggie', 4, N'Sales')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/1/1/', 10, N'Jenny', 2, N'Finance')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/1/2/', 11, N'Chris', 2, N'Finance')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/2/1/', 12, N'Megan', 3, N'Marketing')
GO
INSERT [Reference].[StaffHierarchy] ([HierarchyReference], [StaffID], [StaffName], [ManagerID], [Department]) VALUES (N'/1/1/2/1/', 13, N'Sandy', 11, N'Finance')
GO
SET IDENTITY_INSERT [Reference].[StaffHierarchy] OFF
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Magic Motors', N'United Kingdom', 52000.0000, 2175.0000, 1500.0000, 750.0000, CAST(65000.00 AS Numeric(18, 2)), CAST(N'2015-01-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Snazzy Roadsters', N'United Kingdom', 176000.0000, 5500.0000, 2200.0000, 1950.0000, CAST(220000.00 AS Numeric(18, 2)), CAST(N'2015-01-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'London Executive Prestige Vehicles', N'United Kingdom', 135600.0000, 5500.0000, 2200.0000, 1950.0000, CAST(169500.00 AS Numeric(18, 2)), CAST(N'2015-05-10T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Glittering Prize Cars Ltd', N'United Kingdom', 156000.0000, 6000.0000, 1500.0000, 1950.0000, CAST(195000.00 AS Numeric(18, 2)), CAST(N'2015-05-28T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Casseroles Chromes', N'France', 15960.0000, 1360.0000, 500.0000, 150.0000, CAST(19950.00 AS Numeric(18, 2)), CAST(N'2015-02-28T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'M. Pierre Dubois', N'France', 15680.0000, 890.0000, 500.0000, 150.0000, CAST(19600.00 AS Numeric(18, 2)), CAST(N'2015-04-06T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'M. Pierre Dubois', N'France', 7160.0000, 500.0000, 750.0000, 150.0000, CAST(8950.00 AS Numeric(18, 2)), CAST(N'2015-05-20T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'WunderKar', N'Germany', 9200.0000, 500.0000, 750.0000, 150.0000, CAST(11500.00 AS Numeric(18, 2)), CAST(N'2015-02-16T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 15600.0000, 660.0000, 500.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2015-02-03T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Posh Vehicles Ltd', N'United Kingdom', 7160.0000, 360.0000, 750.0000, 150.0000, CAST(8950.00 AS Numeric(18, 2)), CAST(N'2015-09-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Wonderland Wheels', N'United Kingdom', 6800.0000, 250.0000, 750.0000, 150.0000, CAST(8500.00 AS Numeric(18, 2)), CAST(N'2015-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Convertible Dreams', N'United Kingdom', 18360.0000, 500.0000, 750.0000, 150.0000, CAST(22950.00 AS Numeric(18, 2)), CAST(N'2015-11-10T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'SuperSport S.A.R.L.', N'France', 44800.0000, 1785.0000, 500.0000, 550.0000, CAST(56000.00 AS Numeric(18, 2)), CAST(N'2015-07-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Magic Motors', N'United Kingdom', 23600.0000, 500.0000, 750.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2015-03-14T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 39600.0000, 2500.0000, 1500.0000, 550.0000, CAST(49500.00 AS Numeric(18, 2)), CAST(N'2015-03-24T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Eat My Exhaust Ltd', N'United Kingdom', 60800.0000, 3250.0000, 750.0000, 750.0000, CAST(76000.00 AS Numeric(18, 2)), CAST(N'2015-03-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Alexei Tolstoi', N'United Kingdom', 55600.0000, 1490.0000, 1500.0000, 750.0000, CAST(69500.00 AS Numeric(18, 2)), CAST(N'2015-12-01T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Sondra Horowitz', N'United States', 29200.0000, 1950.0000, 500.0000, 550.0000, CAST(36500.00 AS Numeric(18, 2)), CAST(N'2015-04-04T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Theo Kowalski', N'United States', 98872.0000, 2175.0000, 2200.0000, 750.0000, CAST(123590.00 AS Numeric(18, 2)), CAST(N'2015-10-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Wonderland Wheels', N'United Kingdom', 64400.0000, 500.0000, 750.0000, 750.0000, CAST(80500.00 AS Numeric(18, 2)), CAST(N'2015-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Mercedes', N'280SL', N'La Bagnole de Luxe', N'France', 18360.0000, 550.0000, 500.0000, 150.0000, CAST(22950.00 AS Numeric(18, 2)), CAST(N'2015-06-04T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Convertible Dreams', N'United Kingdom', 6956.0000, 400.0000, 750.0000, 150.0000, CAST(8695.00 AS Numeric(18, 2)), CAST(N'2015-07-12T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJS', N'SuperSport S.A.R.L.', N'France', 15600.0000, 290.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2015-07-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Alexei Tolstoi', N'United Kingdom', 18392.0000, 390.0000, 750.0000, 150.0000, CAST(22990.00 AS Numeric(18, 2)), CAST(N'2015-07-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJS', N'Alexei Tolstoi', N'United Kingdom', 18080.0000, 660.0000, 750.0000, 150.0000, CAST(22600.00 AS Numeric(18, 2)), CAST(N'2015-10-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Peter McLuckie', N'United Kingdom', 12480.0000, 1100.0000, 500.0000, 150.0000, CAST(15600.00 AS Numeric(18, 2)), CAST(N'2015-09-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Peter McLuckie', N'United Kingdom', 10120.0000, 320.0000, 750.0000, 150.0000, CAST(12650.00 AS Numeric(18, 2)), CAST(N'2015-09-05T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Theo Kowalski', N'United States', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2015-08-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'360', N'Glitz', N'Germany', 79600.0000, 500.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Mrs. Ivana Telford', N'United Kingdom', 156000.0000, 3950.0000, 3150.0000, 1950.0000, CAST(195000.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Honest Pete Motors', N'United Kingdom', 125200.0000, 2200.0000, 3150.0000, 1950.0000, CAST(156500.00 AS Numeric(18, 2)), CAST(N'2016-09-19T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Mondial', N'King Leer Cars', N'United Kingdom', 82360.0000, 2175.0000, 2200.0000, 750.0000, CAST(102950.00 AS Numeric(18, 2)), CAST(N'2016-04-05T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Alexei Tolstoi', N'United Kingdom', 164000.0000, 9250.0000, 750.0000, 1950.0000, CAST(205000.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'Testarossa', N'Wonderland Wheels', N'United Kingdom', 132000.0000, 3950.0000, 2200.0000, 1950.0000, CAST(165000.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Ferrari', N'355', N'Sondra Horowitz', N'United States', 127600.0000, 2000.0000, 3150.0000, 1950.0000, CAST(159500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Casseroles Chromes', N'France', 53200.0000, 2175.0000, 1500.0000, 750.0000, CAST(66500.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'SuperSport S.A.R.L.', N'France', 31600.0000, 500.0000, 1500.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-02-16T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Glitz', N'Germany', 15600.0000, 500.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-08-19T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Prestige Imports', N'Spain', 55120.0000, 500.0000, 750.0000, 750.0000, CAST(68900.00 AS Numeric(18, 2)), CAST(N'2016-09-11T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'959', N'Alicia Almodovar', N'Spain', 31600.0000, 500.0000, 500.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-12-31T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 6000.0000, 500.0000, 750.0000, 150.0000, CAST(7500.00 AS Numeric(18, 2)), CAST(N'2016-09-06T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'959', N'Convertible Dreams', N'United Kingdom', 53200.0000, 1490.0000, 750.0000, 750.0000, CAST(66500.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Jason B. Wight', N'United States', 14000.0000, 2000.0000, 500.0000, 150.0000, CAST(17500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Jason B. Wight', N'United States', 10120.0000, 500.0000, 750.0000, 150.0000, CAST(12650.00 AS Numeric(18, 2)), CAST(N'2016-01-09T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Silver HubCaps', N'United Kingdom', 7040.0000, 140.0000, 750.0000, 150.0000, CAST(8800.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Peter McLuckie', N'United Kingdom', 26880.0000, 500.0000, 500.0000, 550.0000, CAST(33600.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'Peter McLuckie', N'United Kingdom', 13200.0000, 500.0000, 750.0000, 150.0000, CAST(16500.00 AS Numeric(18, 2)), CAST(N'2016-08-13T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Posh Vehicles Ltd', N'United Kingdom', 23600.0000, 1360.0000, 500.0000, 150.0000, CAST(29500.00 AS Numeric(18, 2)), CAST(N'2016-01-07T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Posh Vehicles Ltd', N'United Kingdom', 16760.0000, 1360.0000, 750.0000, 150.0000, CAST(20950.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Alexei Tolstoi', N'United Kingdom', 36760.0000, 970.0000, 750.0000, 550.0000, CAST(45950.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Eat My Exhaust Ltd', N'United Kingdom', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'928', N'Screamin'' Wheels', N'United Kingdom', 7600.0000, 500.0000, 750.0000, 150.0000, CAST(9500.00 AS Numeric(18, 2)), CAST(N'2016-08-28T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'944', N'Liverpool Executive Prestige Vehicles', N'United Kingdom', 12520.0000, 500.0000, 750.0000, 150.0000, CAST(15650.00 AS Numeric(18, 2)), CAST(N'2016-07-01T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'928', N'Kieran O''Harris', N'United Kingdom', 15600.0000, 1360.0000, 750.0000, 150.0000, CAST(19500.00 AS Numeric(18, 2)), CAST(N'2016-07-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'911', N'Honest Pete Motors', N'United Kingdom', 17720.0000, 1360.0000, 750.0000, 150.0000, CAST(22150.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Porsche', N'924', N'King Leer Cars', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-09-18T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Diabolo', N'Vive La Vitesse', N'France', 135600.0000, 9250.0000, 1500.0000, 1950.0000, CAST(169500.00 AS Numeric(18, 2)), CAST(N'2016-12-20T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Diabolo', N'Glitz', N'Germany', 20000.0000, 1360.0000, 750.0000, 150.0000, CAST(25000.00 AS Numeric(18, 2)), CAST(N'2016-12-08T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Countach', N'Magic Motors', N'United Kingdom', 2920.0000, 500.0000, 750.0000, 150.0000, CAST(3650.00 AS Numeric(18, 2)), CAST(N'2016-02-28T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Lamborghini', N'Countach', N'Convertible Dreams', N'United Kingdom', 98800.0000, 2000.0000, 750.0000, 750.0000, CAST(123500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vantage', N'Diplomatic Cars', N'Belgium', 100000.0000, 500.0000, 2200.0000, 750.0000, CAST(125000.00 AS Numeric(18, 2)), CAST(N'2016-08-23T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Laurent Saint Yves', N'France', 52400.0000, 500.0000, 750.0000, 750.0000, CAST(65500.00 AS Numeric(18, 2)), CAST(N'2016-08-24T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'SuperSport S.A.R.L.', N'France', 39664.0000, 660.0000, 500.0000, 550.0000, CAST(49580.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Vive La Vitesse', N'France', 36400.0000, 500.0000, 750.0000, 550.0000, CAST(45500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Rapide', N'WunderKar', N'Germany', 49200.0000, 1360.0000, 750.0000, 550.0000, CAST(61500.00 AS Numeric(18, 2)), CAST(N'2016-08-12T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Prestissimo!', N'Italy', 36000.0000, 500.0000, 750.0000, 550.0000, CAST(45000.00 AS Numeric(18, 2)), CAST(N'2016-08-19T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Glittering Prize Cars Ltd', N'United Kingdom', 44000.0000, 660.0000, 500.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2016-11-04T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Stan Collywobble', N'United Kingdom', 36480.0000, 500.0000, 500.0000, 550.0000, CAST(45600.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vantage', N'Stan Collywobble', N'United Kingdom', 39600.0000, 660.0000, 500.0000, 550.0000, CAST(49500.00 AS Numeric(18, 2)), CAST(N'2016-09-07T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB6', N'Stan Collywobble', N'United Kingdom', 44800.0000, 1360.0000, 500.0000, 550.0000, CAST(56000.00 AS Numeric(18, 2)), CAST(N'2016-02-22T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Convertible Dreams', N'United Kingdom', 36720.0000, 500.0000, 500.0000, 550.0000, CAST(45900.00 AS Numeric(18, 2)), CAST(N'2016-08-22T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Convertible Dreams', N'United Kingdom', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-08-10T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Alexei Tolstoi', N'United Kingdom', 82000.0000, 2175.0000, 1500.0000, 750.0000, CAST(102500.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB4', N'Ronaldo Bianco', N'Italy', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Vanquish', N'Magic Motors', N'United Kingdom', 44000.0000, 500.0000, 750.0000, 550.0000, CAST(55000.00 AS Numeric(18, 2)), CAST(N'2016-09-11T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Snazzy Roadsters', N'United Kingdom', 45200.0000, 500.0000, 1500.0000, 550.0000, CAST(56500.00 AS Numeric(18, 2)), CAST(N'2016-09-07T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB5', N'Birmingham Executive Prestige Vehicles', N'United Kingdom', 45512.0000, 2000.0000, 750.0000, 550.0000, CAST(56890.00 AS Numeric(18, 2)), CAST(N'2016-11-03T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'DB9', N'Honest Pete Motors', N'United Kingdom', 37200.0000, 2000.0000, 750.0000, 550.0000, CAST(46500.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Aston Martin', N'Virage', N'Honest Pete Motors', N'United Kingdom', 100400.0000, 3950.0000, 1500.0000, 1950.0000, CAST(125500.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Vive La Vitesse', N'France', 79600.0000, 2175.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Glitz', N'Germany', 52712.0000, 1490.0000, 1500.0000, 750.0000, CAST(65890.00 AS Numeric(18, 2)), CAST(N'2016-02-17T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Prestige Imports', N'Spain', 63600.0000, 2000.0000, 1500.0000, 750.0000, CAST(79500.00 AS Numeric(18, 2)), CAST(N'2016-07-26T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Arnage', N'Executive Motor Delight', N'United Kingdom', 68520.0000, 2175.0000, 750.0000, 750.0000, CAST(85650.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Brooklands', N'Liverpool Executive Prestige Vehicles', N'United Kingdom', 79600.0000, 2175.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-12-28T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Arnage', N'Stan Collywobble', N'United Kingdom', 61200.0000, 2175.0000, 750.0000, 750.0000, CAST(76500.00 AS Numeric(18, 2)), CAST(N'2016-10-05T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Continental', N'Silver HubCaps', N'United Kingdom', 45560.0000, 2000.0000, 750.0000, 550.0000, CAST(56950.00 AS Numeric(18, 2)), CAST(N'2016-01-22T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Silver HubCaps', N'United Kingdom', 61200.0000, 2000.0000, 750.0000, 750.0000, CAST(76500.00 AS Numeric(18, 2)), CAST(N'2016-08-21T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Bentley', N'Flying Spur', N'Screamin'' Wheels', N'United States', 73720.0000, 2175.0000, 750.0000, 750.0000, CAST(92150.00 AS Numeric(18, 2)), CAST(N'2016-08-25T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Ghost', N'La Bagnole de Luxe', N'France', 48400.0000, 500.0000, 1500.0000, 550.0000, CAST(60500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Phantom', N'Prestissimo!', N'Italy', 79600.0000, 1490.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-12-06T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Rolls Royce', N'Phantom', N'Prestige Imports', N'Spain', 95680.0000, 1490.0000, 2200.0000, 750.0000, CAST(119600.00 AS Numeric(18, 2)), CAST(N'2016-10-05T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'M. Pierre Dubois', N'France', 2040.0000, 500.0000, 750.0000, 150.0000, CAST(2550.00 AS Numeric(18, 2)), CAST(N'2016-01-07T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Glitz', N'Germany', 4800.0000, 500.0000, 750.0000, 150.0000, CAST(6000.00 AS Numeric(18, 2)), CAST(N'2016-02-17T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Silver HubCaps', N'United Kingdom', 14000.0000, 1360.0000, 750.0000, 150.0000, CAST(17500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Spider', N'Wonderland Wheels', N'United Kingdom', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-04-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Alfa Romeo', N'Giulia', N'Jason B. Wight', N'United States', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-07-06T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJ12', N'M. Pierre Dubois', N'France', 2860.0000, 500.0000, 750.0000, 150.0000, CAST(3575.00 AS Numeric(18, 2)), CAST(N'2016-09-14T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'La Bagnole de Luxe', N'France', 15680.0000, 1360.0000, 750.0000, 150.0000, CAST(19600.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK150', N'Vive La Vitesse', N'France', 23720.0000, 660.0000, 750.0000, 150.0000, CAST(29650.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'La Bagnole de Luxe', N'France', 22312.0000, 970.0000, 500.0000, 150.0000, CAST(27890.00 AS Numeric(18, 2)), CAST(N'2016-09-16T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'SuperSport S.A.R.L.', N'France', 79600.0000, 2000.0000, 750.0000, 750.0000, CAST(99500.00 AS Numeric(18, 2)), CAST(N'2016-08-09T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XK120', N'Peter Smith', N'United Kingdom', 28000.0000, 500.0000, 750.0000, 550.0000, CAST(35000.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'E-Type', N'Alexei Tolstoi', N'United Kingdom', 31600.0000, 2000.0000, 750.0000, 550.0000, CAST(39500.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJS', N'Alexei Tolstoi', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-05-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Jaguar', N'XJ12', N'Glittering Prize Cars Ltd', N'United Kingdom', 28200.0000, 500.0000, 750.0000, 550.0000, CAST(35250.00 AS Numeric(18, 2)), CAST(N'2016-09-14T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'M. Pierre Dubois', N'France', 4400.0000, 500.0000, 750.0000, 150.0000, CAST(5500.00 AS Numeric(18, 2)), CAST(N'2016-06-15T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR4', N'Prestissimo!', N'Italy', 11672.0000, 500.0000, 750.0000, 150.0000, CAST(14590.00 AS Numeric(18, 2)), CAST(N'2016-07-26T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Prestissimo!', N'Italy', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-08-28T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Prestige Imports', N'Spain', 10200.0000, 970.0000, 750.0000, 150.0000, CAST(12750.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Alicia Almodovar', N'Spain', 10000.0000, 500.0000, 750.0000, 150.0000, CAST(12500.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR7', N'Executive Motor Delight', N'United Kingdom', 7960.0000, 500.0000, 750.0000, 150.0000, CAST(9950.00 AS Numeric(18, 2)), CAST(N'2016-10-30T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR7', N'Honest Pete Motors', N'United Kingdom', 7600.0000, 500.0000, 750.0000, 150.0000, CAST(9500.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'Honest Pete Motors', N'United Kingdom', 5240.0000, 500.0000, 750.0000, 150.0000, CAST(6550.00 AS Numeric(18, 2)), CAST(N'2016-09-19T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Honest Pete Motors', N'United Kingdom', 7992.0000, 500.0000, 750.0000, 150.0000, CAST(9990.00 AS Numeric(18, 2)), CAST(N'2016-12-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR5', N'King Leer Cars', N'United Kingdom', 4544.0000, 500.0000, 750.0000, 150.0000, CAST(5680.00 AS Numeric(18, 2)), CAST(N'2016-08-29T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'TR6', N'Silver HubCaps', N'United Kingdom', 5200.0000, 500.0000, 750.0000, 150.0000, CAST(6500.00 AS Numeric(18, 2)), CAST(N'2016-08-02T00:00:00.000' AS DateTime))
GO
INSERT [Reference].[YearlySales] ([MakeName], [ModelName], [CustomerName], [CountryName], [Cost], [RepairsCost], [PartsCost], [TransportInCost], [SalePrice], [SaleDate]) VALUES (N'Triumph', N'GT6', N'Alexei Tolstoi', N'United Kingdom', 2800.0000, 500.0000, 750.0000, 150.0000, CAST(3500.00 AS Numeric(18, 2)), CAST(N'2016-09-04T00:00:00.000' AS DateTime))
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'F50', N'£204760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'F50', N'£248000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'F40', N'£215600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Enzo', N'£316000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£124000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Enzo', N'£292000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Testarossa', N'£132000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£176000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£127600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'F40', N'£200000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'F50', N'£156000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£125200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Mondial', N'£82360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Mondial', N'£124000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£164000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Testarossa', N'£156000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£135600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Testarossa', N'£200000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Testarossa', N'£52000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'355', N'£100760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Enzo', N'£204000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Daytona', N'£116000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Testarossa', N'£156000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'360', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'360', N'£108000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Dino', N'£156000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'360', N'£102800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Daytona', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Ferrari', N'Dino', N'£98800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£53200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£15960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'959', N'£44480.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£15680.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£7160.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£40960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£14000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£10120.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£17280.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£6800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£15600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£6000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£12600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£26880.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£13200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£23600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£36760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£18360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'959', N'£53200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'928', N'£15600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£17720.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£7960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£16760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£7160.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£7040.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£36760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£7840.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£6000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'928', N'£7600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'928', N'£15600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£12520.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£55120.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£9592.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'911', N'£39600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'959', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'928', N'£12760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£6040.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'959', N'£71600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'Boxster', N'£18000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'924', N'£9200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Porsche', N'944', N'£15600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Diabolo', N'£188000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Diabolo', N'£135600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Diabolo', N'£20000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Jarama', N'£244000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Jarama', N'£196000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'400GT', N'£116000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Countach', N'£2920.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Diabolo', N'£204000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lamborghini', N'Countach', N'£98800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vantage', N'£100000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Rapide', N'£69200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB5', N'£55600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£29200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£62000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£52400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£98872.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£47600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£36000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£45592.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£90872.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£52360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£36760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£45200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£39600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB5', N'£29200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£45520.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£36720.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Rapide', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£60800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB5', N'£39600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB5', N'£45512.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£36480.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vantage', N'£39600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£50000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£82000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£55600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£37200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£100400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£45560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£45480.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£45200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£44800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB5', N'£34360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Rapide', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£79992.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£180000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£100000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£34000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£80000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£43600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£45560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£58000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vantage', N'£82000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£23600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vantage', N'£53200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£49240.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£35908.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Virage', N'£98800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB4', N'£37520.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£42000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£46080.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£36760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Rapide', N'£49200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£36000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB5', N'£36000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB2', N'£49200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£66072.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£36400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£36000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'Vanquish', N'£45200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£44800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB6', N'£39664.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Aston Martin', N'DB9', N'£45200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Brooklands', N'£151600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£58000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Mulsanne', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£52712.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£63600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£61200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Mulsanne', N'£45560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£45560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£64400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Continental', N'£71600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Flying Spur', N'£73720.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Arnage', N'£79960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Arnage', N'£68520.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Brooklands', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Continental', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Arnage', N'£61200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bentley', N'Continental', N'£45560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Silver Seraph', N'£79960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Silver Seraph', N'£111600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Silver Shadow', N'£108000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Ghost', N'£48400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Silver Seraph', N'£96000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Phantom', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Phantom', N'£146000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Phantom', N'£95680.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Ghost', N'£79160.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Phantom', N'£63600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Wraith', N'£130000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Corniche', N'£71600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Rolls Royce', N'Silver Shadow', N'£68000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'350SL', N'£26880.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'350SL', N'£26140.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'500SL', N'£36000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'280SL', N'£18360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'280SL', N'£45512.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'500SL', N'£24400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'250SL', N'£18080.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'280SL', N'£26760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'280SL', N'£50000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'350SL', N'£18800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'250SL', N'£10360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'280SL', N'£26000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Mercedes', N'280SL', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£8400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Spider', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Spider', N'£9200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'1750', N'£7960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£2040.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£4800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Spider', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£14360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£17200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£14800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Spider', N'£4520.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£14000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Spider', N'£4760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£6956.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£20000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£9240.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£5200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£4552.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulietta', N'£8400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Alfa Romeo', N'Giulia', N'£5560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Princess', N'£4800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Lichfield', N'£18880.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Princess', N'£920.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Cambridge', N'£18000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Lichfield', N'£5200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Princess', N'£1800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Austin', N'Princess', N'£2000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'BMW', N'Alpina', N'£17200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'BMW', N'E30', N'£26800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'BMW', N'Isetta', N'£4400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bugatti', N'57C', N'£276000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bugatti', N'Veyron', N'£176400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bugatti', N'57C', N'£284000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bugatti', N'57C', N'£284000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bugatti', N'57C', N'£236000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Bugatti', N'57C', N'£268000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Citroen', N'Traaction Avant', N'£20000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Citroen', N'Rosalie', N'£4400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Citroen', N'Torpedo', N'£52712.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Citroen', N'Rosalie', N'£792.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Citroen', N'Rosalie', N'£1080.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Delahaye', N'135', N'£20400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Delahaye', N'175', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Delahaye', N'145', N'£23600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Delahaye', N'145', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Delorean', N'DMC 12', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£47200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'Mark V', N'£20760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£17240.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK150', N'£23720.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£79600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK150', N'£23600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'Mark V', N'£26800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XJS', N'£7960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'E-Type', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'Mark X', N'£19600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XJ12', N'£28200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK150', N'£21200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'Mark X', N'£69200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XJ12', N'£14280.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£54800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£28000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£12480.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK150', N'£18392.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XJS', N'£18080.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XJS', N'£15600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£15680.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK120', N'£22312.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XJ12', N'£2860.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK150', N'£63600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Jaguar', N'XK150', N'£23600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lagonda', N'V12', N'£49200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Lagonda', N'V12', N'£125200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'McLaren', N'P1', N'£236000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Morgan', N'Plus 4', N'£14800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Noble', N'M600', N'£23600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Noble', N'M600', N'£36760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Noble', N'M14', N'£4400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Noble', N'M600', N'£20760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Noble', N'M600', N'£36000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Noble', N'M600', N'£44000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR6', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'Roadster', N'£18800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£5560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR7', N'£7912.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£7120.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£6840.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£4400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£6800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£7960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£10120.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'GT6', N'£2800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR7', N'£4544.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£7600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£5240.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR6', N'£7992.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR7', N'£7600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£4544.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'GT6', N'£7400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR6', N'£5200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR6', N'£10000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£10200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£5272.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£7992.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£10056.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR7', N'£7960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£4400.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR4', N'£11672.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR6', N'£7960.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR5', N'£9200.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'Roadster', N'£10360.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Triumph', N'TR3A', N'£31600.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Trabant', N'500', N'£920.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Trabant', N'500', N'£2000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Trabant', N'600', N'£1560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Trabant', N'600', N'£1000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Trabant', N'600', N'£1272.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'205', N'£3160.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'205', N'£760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'203', N'£1560.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'203', N'£1000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'404', N'£1000.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'404', N'£1920.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'404', N'£760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'404', N'£1996.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Peugeot', N'404', N'£2800.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Reliant', N'Robin', N'£760.00')
GO
INSERT [SourceData].[SalesInPounds] ([MakeName], [ModelName], [VehicleCost]) VALUES (N'Reliant', N'Robin', N'£760.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Ferrari', N'2 000,00 USD', N'255950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Ferrari', N'2 000,00 USD', N'310000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Ferrari', N'2 000,00 USD', N'269500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Ferrari', N'2 000,00 USD', N'395000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Ferrari', N'2 000,00 USD', N'155000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Ferrari', N'2 000,00 USD', N'365000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'132000.00', N'165000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'176000.00', N'220000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Ferrari', N'127600.00', N'159500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Ferrari', N'200000.00', N'250000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Ferrari', N'156000.00', N'195000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'125200.00', N'156500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'82360.00', N'102950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'124000.00', N'155000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'164000.00', N'205000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'156000.00', N'195000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'135600.00', N'169500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Ferrari', N'200000.00', N'250000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'52000.00', N'65000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'100760.00', N'125950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'204000.00', N'255000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'116000.00', N'145000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Ferrari', N'156000.00', N'195000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Ferrari', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Ferrari', N'108000.00', N'135000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Ferrari', N'156000.00', N'195000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Ferrari', N'102800.00', N'128500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Ferrari', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Ferrari', N'98800.00', N'123500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'53200.00', N'66500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'15960.00', N'19950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'44480.00', N'55600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'15680.00', N'19600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'7160.00', N'8950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'40960.00', N'51200.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Porsche', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Porsche', N'14000.00', N'17500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Porsche', N'10120.00', N'12650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'17280.00', N'21600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'6800.00', N'8500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'15600.00', N'19500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'6000.00', N'7500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Porsche', N'12600.00', N'15750.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'26880.00', N'33600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'13200.00', N'16500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'23600.00', N'29500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'36760.00', N'45950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'18360.00', N'22950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'53200.00', N'66500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'15600.00', N'19500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'17720.00', N'22150.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'7960.00', N'9950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'16760.00', N'20950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'7160.00', N'8950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'7040.00', N'8800.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'36760.00', N'45950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'7840.00', N'9800.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'6000.00', N'7500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'7600.00', N'9500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'15600.00', N'19500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Porsche', N'12520.00', N'15650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Porsche', N'55120.00', N'68900.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Porsche', N'9592.00', N'11990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Porsche', N'39600.00', N'49500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Porsche', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Porsche', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Porsche', N'12760.00', N'15950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'6040.00', N'7550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'71600.00', N'89500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'18000.00', N'22500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Porsche', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Porsche', N'9200.00', N'11500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Porsche', N'15600.00', N'19500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Lamborghini', N'188000.00', N'235000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Lamborghini', N'135600.00', N'169500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Lamborghini', N'20000.00', N'25000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Lamborghini', N'244000.00', N'305000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Lamborghini', N'196000.00', N'245000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Lamborghini', N'116000.00', N'145000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Lamborghini', N'2920.00', N'3650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Lamborghini', N'204000.00', N'255000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Lamborghini', N'98800.00', N'123500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Aston Martin', N'100000.00', N'125000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Aston Martin', N'69200.00', N'86500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'55600.00', N'69500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'29200.00', N'36500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'62000.00', N'77500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'52400.00', N'65500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'98872.00', N'123590.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'47600.00', N'59500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'36000.00', N'45000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'45592.00', N'56990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'90872.00', N'113590.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'52360.00', N'65450.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'36760.00', N'45950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'45200.00', N'56500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'39600.00', N'49500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'29200.00', N'36500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Aston Martin', N'45520.00', N'56900.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'36720.00', N'45900.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'60800.00', N'76000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'39600.00', N'49500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'45512.00', N'56890.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'36480.00', N'45600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'39600.00', N'49500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'50000.00', N'62500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'82000.00', N'102500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'55600.00', N'69500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'37200.00', N'46500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'100400.00', N'125500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'45560.00', N'56950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'45480.00', N'56850.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'45200.00', N'56500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'44800.00', N'56000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'34360.00', N'42950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'79992.00', N'99990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'180000.00', N'225000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'100000.00', N'125000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'34000.00', N'42500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'80000.00', N'100000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'43600.00', N'54500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'45560.00', N'56950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'58000.00', N'72500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'82000.00', N'102500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'23600.00', N'29500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'53200.00', N'66500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'49240.00', N'61550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Aston Martin', N'35908.00', N'44885.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Aston Martin', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Aston Martin', N'98800.00', N'123500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Aston Martin', N'37520.00', N'46900.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Aston Martin', N'42000.00', N'52500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Aston Martin', N'46080.00', N'57600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Aston Martin', N'36760.00', N'45950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Aston Martin', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Aston Martin', N'49200.00', N'61500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Aston Martin', N'36000.00', N'45000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Aston Martin', N'36000.00', N'45000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Aston Martin', N'49200.00', N'61500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Aston Martin', N'66072.00', N'82590.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'36400.00', N'45500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'36000.00', N'45000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'45200.00', N'56500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'44800.00', N'56000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'39664.00', N'49580.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Aston Martin', N'45200.00', N'56500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Bentley', N'151600.00', N'189500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Bentley', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Bentley', N'58000.00', N'72500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Bentley', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Bentley', N'52712.00', N'65890.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Bentley', N'63600.00', N'79500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'61200.00', N'76500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'45560.00', N'56950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'45560.00', N'56950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'64400.00', N'80500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Bentley', N'71600.00', N'89500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Bentley', N'73720.00', N'92150.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Bentley', N'79960.00', N'99950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'68520.00', N'85650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'61200.00', N'76500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bentley', N'45560.00', N'56950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Rolls Royce', N'79960.00', N'99950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Rolls Royce', N'111600.00', N'139500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Rolls Royce', N'108000.00', N'135000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Rolls Royce', N'48400.00', N'60500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Rolls Royce', N'96000.00', N'120000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Rolls Royce', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Rolls Royce', N'146000.00', N'182500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Rolls Royce', N'95680.00', N'119600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Rolls Royce', N'79160.00', N'98950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Rolls Royce', N'63600.00', N'79500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Rolls Royce', N'130000.00', N'162500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Rolls Royce', N'71600.00', N'89500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Rolls Royce', N'68000.00', N'85000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Mercedes', N'26880.00', N'33600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Mercedes', N'26140.00', N'32675.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Mercedes', N'36000.00', N'45000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Mercedes', N'18360.00', N'22950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Mercedes', N'45512.00', N'56890.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Mercedes', N'24400.00', N'30500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Mercedes', N'18080.00', N'22600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Mercedes', N'26760.00', N'33450.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Mercedes', N'50000.00', N'62500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Mercedes', N'18800.00', N'23500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Mercedes', N'10360.00', N'12950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Mercedes', N'26000.00', N'32500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Mercedes', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Alfa Romeo', N'8400.00', N'10500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Alfa Romeo', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Alfa Romeo', N'9200.00', N'11500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Alfa Romeo', N'7960.00', N'9950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Alfa Romeo', N'2040.00', N'2550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Alfa Romeo', N'4800.00', N'6000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Alfa Romeo', N'14360.00', N'17950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Alfa Romeo', N'17200.00', N'21500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Alfa Romeo', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'14800.00', N'18500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'4520.00', N'5650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'14000.00', N'17500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'4760.00', N'5950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'6956.00', N'8695.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'20000.00', N'25000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Alfa Romeo', N'9240.00', N'11550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Alfa Romeo', N'5200.00', N'6500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Alfa Romeo', N'4552.00', N'5690.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'8400.00', N'10500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Alfa Romeo', N'5560.00', N'6950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Austin', N'4800.00', N'6000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Germany', N'Austin', N'18880.00', N'23600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Austin', N'920.00', N'1150.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Austin', N'18000.00', N'22500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Austin', N'5200.00', N'6500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Austin', N'1800.00', N'2250.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Austin', N'2000.00', N'2500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'BMW', N'17200.00', N'21500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'BMW', N'26800.00', N'33500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'BMW', N'4400.00', N'5500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Bugatti', N'276000.00', N'345000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Bugatti', N'176400.00', N'220500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Bugatti', N'284000.00', N'365000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bugatti', N'284000.00', N'355000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bugatti', N'236000.00', N'295000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Bugatti', N'268000.00', N'335000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Citroen', N'20000.00', N'25000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Citroen', N'4400.00', N'5500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Citroen', N'52712.00', N'65890.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Citroen', N'792.00', N'990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Citroen', N'1080.00', N'1350.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Delahaye', N'20400.00', N'25500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Delahaye', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Delahaye', N'23600.00', N'29500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Delahaye', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Delorean', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'47200.00', N'59000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'20760.00', N'25950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'17240.00', N'21550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'23720.00', N'29650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'79600.00', N'99500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'23600.00', N'29500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Jaguar', N'26800.00', N'33500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'7960.00', N'9950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'19600.00', N'24500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'28200.00', N'35250.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'21200.00', N'26500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Jaguar', N'69200.00', N'86500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'14280.00', N'17850.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'54800.00', N'68500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'28000.00', N'35000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'12480.00', N'15600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'18392.00', N'22990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'18080.00', N'22600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'15600.00', N'19500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'15680.00', N'19600.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'22312.00', N'27890.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Jaguar', N'2860.00', N'3575.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Jaguar', N'63600.00', N'79500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Jaguar', N'23600.00', N'29500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Lagonda', N'49200.00', N'61500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Lagonda', N'125200.00', N'156500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'McLaren', N'236000.00', N'295000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Morgan', N'14800.00', N'18500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Noble', N'23600.00', N'29500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Noble', N'36760.00', N'45950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Noble', N'4400.00', N'5500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Noble', N'20760.00', N'25950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Noble', N'36000.00', N'45000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Noble', N'44000.00', N'55000.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Triumph', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Triumph', N'18800.00', N'23500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Triumph', N'5560.00', N'6950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Triumph', N'7912.00', N'9890.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Triumph', N'7120.00', N'8900.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Triumph', N'6840.00', N'8550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Triumph', N'4400.00', N'5500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'6800.00', N'8500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'7960.00', N'9950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'10120.00', N'12650.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'2800.00', N'3500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'4544.00', N'5680.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United States', N'Triumph', N'7600.00', N'9500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'5240.00', N'6550.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'7992.00', N'9990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'7600.00', N'9500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'4544.00', N'5680.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'7400.00', N'9250.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'5200.00', N'6500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Triumph', N'10000.00', N'12500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Triumph', N'10200.00', N'12750.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'5272.00', N'6590.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'7992.00', N'9990.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'10056.00', N'12570.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Triumph', N'7960.00', N'9950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Triumph', N'4400.00', N'5500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Triumph', N'11672.00', N'14590.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Triumph', N'7960.00', N'9950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Triumph', N'9200.00', N'11500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Triumph', N'10360.00', N'12950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Spain', N'Triumph', N'31600.00', N'39500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Trabant', N'920.00', N'1150.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Trabant', N'2000.00', N'2500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Trabant', N'1560.00', N'1950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Trabant', N'1000.00', N'1250.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Trabant', N'1272.00', N'1590.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Peugeot', N'3160.00', N'3950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Belgium', N'Peugeot', N'760.00', N'950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Peugeot', N'1560.00', N'1950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'France', N'Peugeot', N'1000.00', N'1250.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'Italy', N'Peugeot', N'1000.00', N'1250.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Peugeot', N'1920.00', N'2400.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Peugeot', N'760.00', N'950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Peugeot', N'1996.00', N'2495.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Peugeot', N'2800.00', N'3500.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Reliant', N'760.00', N'950.00')
GO
INSERT [SourceData].[SalesText] ([CountryName], [MakeName], [Cost], [SalePrice]) VALUES (N'United Kingdom', N'Reliant', N'760.00', N'950.00')
GO
ALTER TABLE [Data].[Stock] ADD  CONSTRAINT [DF_Stock_StockCode]  DEFAULT (newid()) FOR [StockCode]
GO