USE [master]
GO
/****** Object:  Database [equiptimize]    Script Date: 6/30/2024 1:33:55 PM ******/
CREATE DATABASE [equiptimize]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'eso_damage', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\eso_damage.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'eso_damage_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\eso_damage_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [equiptimize] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [equiptimize].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [equiptimize] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [equiptimize] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [equiptimize] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [equiptimize] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [equiptimize] SET ARITHABORT OFF 
GO
ALTER DATABASE [equiptimize] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [equiptimize] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [equiptimize] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [equiptimize] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [equiptimize] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [equiptimize] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [equiptimize] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [equiptimize] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [equiptimize] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [equiptimize] SET  ENABLE_BROKER 
GO
ALTER DATABASE [equiptimize] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [equiptimize] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [equiptimize] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [equiptimize] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [equiptimize] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [equiptimize] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [equiptimize] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [equiptimize] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [equiptimize] SET  MULTI_USER 
GO
ALTER DATABASE [equiptimize] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [equiptimize] SET DB_CHAINING OFF 
GO
ALTER DATABASE [equiptimize] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [equiptimize] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [equiptimize] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [equiptimize] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [equiptimize] SET QUERY_STORE = ON
GO
ALTER DATABASE [equiptimize] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [equiptimize]
GO
/****** Object:  Table [dbo].[attribute]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attribute](
	[attr_id] [smallint] IDENTITY(1,1) NOT NULL,
	[attr_name] [varchar](50) NOT NULL,
	[attr_value] [float] NOT NULL,
 CONSTRAINT [PK__attribut__FC9D0A07497ECD76] PRIMARY KEY CLUSTERED 
(
	[attr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[champion]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[champion](
	[champ_id] [smallint] IDENTITY(1,1) NOT NULL,
	[champ_name] [varchar](50) NOT NULL,
	[slottable] [varchar](3) NOT NULL,
	[constellation] [varchar](8) NOT NULL,
	[champ_desc] [varchar](max) NOT NULL,
 CONSTRAINT [PK__champion__E371B94E2873708A] PRIMARY KEY CLUSTERED 
(
	[champ_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[character]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[character](
	[char_id] [int] IDENTITY(1,1) NOT NULL,
	[char_name] [varchar](50) NOT NULL,
	[char_class] [smallint] NOT NULL,
	[char_race] [smallint] NOT NULL,
	[char_mundus] [smallint] NOT NULL,
	[member_id] [int] NOT NULL,
 CONSTRAINT [PK__characte__2D4B233966613BEA] PRIMARY KEY CLUSTERED 
(
	[char_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[class]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[class](
	[class_id] [smallint] IDENTITY(1,1) NOT NULL,
	[class_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK__class__FDF47986689ADD8A] PRIMARY KEY CLUSTERED 
(
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[effect_champion]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[effect_champion](
	[champ_id] [smallint] NOT NULL,
	[op_id] [smallint] NOT NULL,
	[value] [smallint] NOT NULL,
	[attr_id] [smallint] NOT NULL,
 CONSTRAINT [PK__effect_c__8CB869EE21FA2E0A] PRIMARY KEY CLUSTERED 
(
	[champ_id] ASC,
	[attr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[effect_mundus]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[effect_mundus](
	[mundus_id] [smallint] NOT NULL,
	[op_id] [smallint] NOT NULL,
	[value] [smallint] NOT NULL,
	[attr_id] [smallint] NOT NULL,
 CONSTRAINT [PK__effect_m__CD9A8182246CC8CB] PRIMARY KEY CLUSTERED 
(
	[mundus_id] ASC,
	[attr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[member]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[member](
	[member_id] [int] IDENTITY(1,1) NOT NULL,
	[member_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK__member__B29B85343F91DBAD] PRIMARY KEY CLUSTERED 
(
	[member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mundus]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mundus](
	[mundus_id] [smallint] IDENTITY(1,1) NOT NULL,
	[mundus_name] [varchar](50) NOT NULL,
	[mundus_desc] [varchar](max) NOT NULL,
 CONSTRAINT [PK__mundus__A25351224C2EF9F7] PRIMARY KEY CLUSTERED 
(
	[mundus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[operation]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[operation](
	[op_id] [smallint] IDENTITY(1,1) NOT NULL,
	[op] [char](1) NOT NULL,
 CONSTRAINT [PK__operatio__A26AE2CE109CED27] PRIMARY KEY CLUSTERED 
(
	[op_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[race]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[race](
	[race_id] [smallint] IDENTITY(1,1) NOT NULL,
	[race_name] [varchar](50) NOT NULL,
 CONSTRAINT [PK__race__1C8FE2F921DB1A37] PRIMARY KEY CLUSTERED 
(
	[race_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[set]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[set](
	[set_id] [int] IDENTITY(1,1) NOT NULL,
	[set_name] [varchar](50) NOT NULL,
	[set_desc] [varchar](max) NOT NULL,
 CONSTRAINT [PK_set] PRIMARY KEY CLUSTERED 
(
	[set_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[set_effect]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[set_effect](
	[set_id] [int] NOT NULL,
	[items] [tinyint] NOT NULL,
	[op_id] [smallint] NOT NULL,
	[value] [float] NOT NULL,
	[attr_id] [smallint] NOT NULL,
 CONSTRAINT [PK_set_effect] PRIMARY KEY CLUSTERED 
(
	[set_id] ASC,
	[items] ASC,
	[attr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[skill]    Script Date: 6/30/2024 1:33:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[skill](
	[skill_id] [int] IDENTITY(1,1) NOT NULL,
	[skill_name] [varchar](50) NOT NULL,
	[skill_desc] [varchar](max) NOT NULL,
	[skill_status] [varchar](8) NOT NULL,
	[skill_race] [smallint] NULL,
	[skill_class] [smallint] NULL,
 CONSTRAINT [PK_skill] PRIMARY KEY CLUSTERED 
(
	[skill_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[character]  WITH CHECK ADD  CONSTRAINT [FK__character__char___0FD74C44] FOREIGN KEY([char_class])
REFERENCES [dbo].[class] ([class_id])
GO
ALTER TABLE [dbo].[character] CHECK CONSTRAINT [FK__character__char___0FD74C44]
GO
ALTER TABLE [dbo].[character]  WITH CHECK ADD  CONSTRAINT [FK__character__char___10CB707D] FOREIGN KEY([char_race])
REFERENCES [dbo].[race] ([race_id])
GO
ALTER TABLE [dbo].[character] CHECK CONSTRAINT [FK__character__char___10CB707D]
GO
ALTER TABLE [dbo].[character]  WITH CHECK ADD  CONSTRAINT [FK__character__char___11BF94B6] FOREIGN KEY([char_mundus])
REFERENCES [dbo].[mundus] ([mundus_id])
GO
ALTER TABLE [dbo].[character] CHECK CONSTRAINT [FK__character__char___11BF94B6]
GO
ALTER TABLE [dbo].[character]  WITH CHECK ADD  CONSTRAINT [FK__character__membe__0EE3280B] FOREIGN KEY([member_id])
REFERENCES [dbo].[member] ([member_id])
GO
ALTER TABLE [dbo].[character] CHECK CONSTRAINT [FK__character__membe__0EE3280B]
GO
ALTER TABLE [dbo].[effect_champion]  WITH CHECK ADD  CONSTRAINT [FK__effect_ch__champ__25C68D63] FOREIGN KEY([champ_id])
REFERENCES [dbo].[champion] ([champ_id])
GO
ALTER TABLE [dbo].[effect_champion] CHECK CONSTRAINT [FK__effect_ch__champ__25C68D63]
GO
ALTER TABLE [dbo].[effect_champion]  WITH CHECK ADD  CONSTRAINT [FK__effect_ch__op_id__26BAB19C] FOREIGN KEY([op_id])
REFERENCES [dbo].[operation] ([op_id])
GO
ALTER TABLE [dbo].[effect_champion] CHECK CONSTRAINT [FK__effect_ch__op_id__26BAB19C]
GO
ALTER TABLE [dbo].[effect_champion]  WITH CHECK ADD  CONSTRAINT [FK_effect_champion_attribute] FOREIGN KEY([attr_id])
REFERENCES [dbo].[attribute] ([attr_id])
GO
ALTER TABLE [dbo].[effect_champion] CHECK CONSTRAINT [FK_effect_champion_attribute]
GO
ALTER TABLE [dbo].[effect_mundus]  WITH CHECK ADD  CONSTRAINT [FK__effect_mu__attr___1E256B9B] FOREIGN KEY([attr_id])
REFERENCES [dbo].[attribute] ([attr_id])
GO
ALTER TABLE [dbo].[effect_mundus] CHECK CONSTRAINT [FK__effect_mu__attr___1E256B9B]
GO
ALTER TABLE [dbo].[effect_mundus]  WITH CHECK ADD  CONSTRAINT [FK__effect_mu__mundu__1C3D2329] FOREIGN KEY([mundus_id])
REFERENCES [dbo].[mundus] ([mundus_id])
GO
ALTER TABLE [dbo].[effect_mundus] CHECK CONSTRAINT [FK__effect_mu__mundu__1C3D2329]
GO
ALTER TABLE [dbo].[effect_mundus]  WITH CHECK ADD  CONSTRAINT [FK__effect_mu__op_id__1D314762] FOREIGN KEY([op_id])
REFERENCES [dbo].[operation] ([op_id])
GO
ALTER TABLE [dbo].[effect_mundus] CHECK CONSTRAINT [FK__effect_mu__op_id__1D314762]
GO
ALTER TABLE [dbo].[set_effect]  WITH CHECK ADD  CONSTRAINT [FK_set_effect_attribute] FOREIGN KEY([attr_id])
REFERENCES [dbo].[attribute] ([attr_id])
GO
ALTER TABLE [dbo].[set_effect] CHECK CONSTRAINT [FK_set_effect_attribute]
GO
ALTER TABLE [dbo].[set_effect]  WITH CHECK ADD  CONSTRAINT [FK_set_effect_operation] FOREIGN KEY([op_id])
REFERENCES [dbo].[operation] ([op_id])
GO
ALTER TABLE [dbo].[set_effect] CHECK CONSTRAINT [FK_set_effect_operation]
GO
ALTER TABLE [dbo].[set_effect]  WITH CHECK ADD  CONSTRAINT [FK_set_effect_set] FOREIGN KEY([set_id])
REFERENCES [dbo].[set] ([set_id])
GO
ALTER TABLE [dbo].[set_effect] CHECK CONSTRAINT [FK_set_effect_set]
GO
ALTER TABLE [dbo].[skill]  WITH CHECK ADD  CONSTRAINT [FK_skill_class] FOREIGN KEY([skill_class])
REFERENCES [dbo].[class] ([class_id])
GO
ALTER TABLE [dbo].[skill] CHECK CONSTRAINT [FK_skill_class]
GO
ALTER TABLE [dbo].[skill]  WITH CHECK ADD  CONSTRAINT [FK_skill_race] FOREIGN KEY([skill_race])
REFERENCES [dbo].[race] ([race_id])
GO
ALTER TABLE [dbo].[skill] CHECK CONSTRAINT [FK_skill_race]
GO
USE [master]
GO
ALTER DATABASE [equiptimize] SET  READ_WRITE 
GO
