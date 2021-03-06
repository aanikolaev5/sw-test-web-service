-- Microsoft SQL Server Express (64-bit) 12.0.2000.8

USE [master]
GO
/****** Object:  Database [sw-web-service]    Script Date: 01.10.2021 12:04:20 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'sw-web-service')
BEGIN
CREATE DATABASE [sw-web-service]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'sw-web-service', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\sw-web-service.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'sw-web-service_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\sw-web-service_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END

GO
ALTER DATABASE [sw-web-service] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [sw-web-service].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [sw-web-service] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [sw-web-service] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [sw-web-service] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [sw-web-service] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [sw-web-service] SET ARITHABORT OFF 
GO
ALTER DATABASE [sw-web-service] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [sw-web-service] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [sw-web-service] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [sw-web-service] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [sw-web-service] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [sw-web-service] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [sw-web-service] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [sw-web-service] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [sw-web-service] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [sw-web-service] SET  DISABLE_BROKER 
GO
ALTER DATABASE [sw-web-service] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [sw-web-service] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [sw-web-service] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [sw-web-service] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [sw-web-service] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [sw-web-service] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [sw-web-service] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [sw-web-service] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [sw-web-service] SET  MULTI_USER 
GO
ALTER DATABASE [sw-web-service] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [sw-web-service] SET DB_CHAINING OFF 
GO
ALTER DATABASE [sw-web-service] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [sw-web-service] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [sw-web-service] SET DELAYED_DURABILITY = DISABLED 
GO
USE [sw-web-service]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Department]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Department](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[Phone] [varchar](100) NULL,
 CONSTRAINT [PK_Department_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Employee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Surname] [varchar](100) NOT NULL,
	[Phone] [varchar](50) NULL,
	[CompanyID] [int] NOT NULL,
	[PassportType] [varchar](50) NOT NULL,
	[PassportNumber] [varchar](50) NOT NULL,
	[DepartmentID] [int] NOT NULL,
 CONSTRAINT [PK_Employee_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vEmployeesAll]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vEmployeesAll]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vEmployeesAll]
AS
SELECT        dbo.Employee.ID, dbo.Employee.Name, dbo.Employee.Surname, dbo.Employee.Phone, dbo.Employee.CompanyID, dbo.Employee.PassportType, 
                         dbo.Employee.PassportNumber, dbo.Department.Name AS DepartmentName, dbo.Department.Phone AS DepartmentPhone
FROM            dbo.Employee INNER JOIN
                         dbo.Department ON dbo.Employee.DepartmentID = dbo.Department.ID
' 
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IUN_Department_Name]    Script Date: 01.10.2021 12:04:20 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Department]') AND name = N'IUN_Department_Name')
CREATE UNIQUE NONCLUSTERED INDEX [IUN_Department_Name] ON [dbo].[Department]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IUN_Employee_PassportNumber]    Script Date: 01.10.2021 12:04:20 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND name = N'IUN_Employee_PassportNumber')
CREATE UNIQUE NONCLUSTERED INDEX [IUN_Employee_PassportNumber] ON [dbo].[Employee]
(
	[PassportNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Department_DepartmentID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Department_DepartmentID] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([ID])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Department_DepartmentID]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Department_DepartmentID]
GO
/****** Object:  StoredProcedure [dbo].[spDepartment_Load]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDepartment_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spDepartment_Load] AS' 
END
GO

ALTER PROCEDURE [dbo].[spDepartment_Load]
	@rintID     INT OUTPUT, 
  @vstrName   VARCHAR(150),
  @vstrPhone  VARCHAR(100)
AS
/*=============================================
  Author: NAA
  Create date: 29-Sep-2021

  Purpose:
    This SP inserts or updates a employee department.

  Revision History:
    Author dd-mmm-yyyy Purpose
=============================================*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  DECLARE
    @intErrNo       INT,
    @intReturn      INT

  IF NOT EXISTS ( SELECT dep.ID
                    FROM dbo.Department dep
                   WHERE dep.ID = @rintID
                )
  BEGIN

    INSERT INTO dbo.Department (
      Name,
      Phone
    )
    VALUES (
      @vstrName,
      @vstrPhone
    )

    -- Check whether insert was successful; get PK of new record
    SELECT @intErrNo  = @@ERROR,
           @rintID    = SCOPE_IDENTITY()

  END
  ELSE
  BEGIN

    UPDATE dep
    SET
      Name  = @vstrName,
      Phone = @vstrPhone
    
    FROM
      dbo.Department dep
    
    WHERE dep.ID = @rintID

    SET @intErrNo = @@ERROR

  END

  IF (@intErrNo <> 0)
    SET @intReturn = @intErrNo
  ELSE
    SET @intReturn = 0

  RETURN @intReturn

END

GO
/****** Object:  StoredProcedure [dbo].[spEmployee_Delete]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spEmployee_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spEmployee_Delete] AS' 
END
GO

ALTER PROCEDURE [dbo].[spEmployee_Delete] 
	@vintID INT 
AS
/*=============================================
  Author: NAA
  Create date: 29-Sep-2021

  Purpose:
    This SP deletes an employee record.

  Revision History:
    Author dd-mmm-yyyy Purpose
=============================================*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  DECLARE
    @intErrNo         INT,
    @intReturn        INT

  DELETE emp
  FROM
    dbo.Employee emp
  WHERE emp.ID = @vintID

  SET @intErrNo = @@ERROR

  IF (@intErrNo <> 0)
    SET @intReturn = @intErrNo
  ELSE
    SET @intReturn = 0

  RETURN @intReturn

END

GO
/****** Object:  StoredProcedure [dbo].[spEmployee_List]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spEmployee_List]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spEmployee_List] AS' 
END
GO

ALTER PROCEDURE [dbo].[spEmployee_List] 
	@vintCompanyId INT = NULL,
  @vstrDepartmentName VARCHAR(200) = NULL
AS
/*=============================================
  Author: NAA
  Create date: 29-Sep-2021

  Purpose:
    This SP retrieves a list of an employee records.

  Revision History:
    Author dd-mmm-yyyy Purpose
=============================================*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  DECLARE
    @intReturn        INT

  SELECT
    EmpAll.ID,
    EmpAll.Name,
    EmpAll.Surname,
    EmpAll.Phone,
    EmpAll.CompanyID,
    EmpAll.PassportType,
    EmpAll.PassportNumber,
    EmpAll.DepartmentName,
    EmpAll.DepartmentPhone
  
  FROM
    vEmployeesAll EmpAll

  WHERE (@vintCompanyId IS NULL OR EmpAll.CompanyID = @vintCompanyId)
    AND (@vstrDepartmentName IS NULL OR EmpAll.DepartmentName = @vstrDepartmentName)

  SET @intReturn = 0

  RETURN @intReturn

END

GO
/****** Object:  StoredProcedure [dbo].[spEmployee_Load]    Script Date: 01.10.2021 12:04:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spEmployee_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spEmployee_Load] AS' 
END
GO

ALTER PROCEDURE [dbo].[spEmployee_Load]
	@rintID               INT OUTPUT, 
	@vstrName             VARCHAR(50),
  @vstrSurname          VARCHAR(100),
  @vstrPhone            VARCHAR(50),
  @vintCompanyId        INT,
  @vstrPassportType     VARCHAR(50),
  @vstrPassportNumber   VARCHAR(50),
  @vstrDepartmentName   VARCHAR(150),
  @vstrDepartmentPhone  VARCHAR(100)
AS
/*=============================================
  Author: NAA
  Create date: 29-Sep-2021

  Purpose:
    This SP inserts or updates a employee record.

  Revision History:
    Author dd-mmm-yyyy Purpose
=============================================*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  DECLARE
    @intErrNo         INT,
    @intReturn        INT,
    @intDepartmentID  INT
  
  BEGIN TRY
    BEGIN TRAN

    SELECT
      @intDepartmentID = dep.ID
    
    FROM 
      dbo.Department dep
    
    WHERE dep.Name = @vstrDepartmentName

    EXEC @intErrNo = dbo.spDepartment_Load @rintID    = @intDepartmentID OUTPUT,
                                           @vstrName  = @vstrDepartmentName,
                                           @vstrPhone = @vstrDepartmentPhone

    IF NOT EXISTS ( SELECT emp.ID
                      FROM dbo.Employee emp
                     WHERE emp.ID = @rintID
              )
    BEGIN

      INSERT INTO dbo.Employee (
        Name,
        Surname,
        Phone,
        CompanyID,
        PassportType,
        PassportNumber,
        DepartmentID
      )
      VALUES (
        @vstrName,
        @vstrSurname,
        @vstrPhone,
        @vintCompanyId,
        @vstrPassportType,
        @vstrPassportNumber,
        @intDepartmentID
      )

      -- Get PK of new record
      SET @rintID = SCOPE_IDENTITY()
    
    END
    ELSE
    BEGIN
      
      UPDATE emp
      SET
        Name            = @vstrName,
        Surname         = @vstrSurname,
        Phone           = @vstrPhone,
        CompanyID       = @vintCompanyId,
        PassportType    = @vstrPassportType,
        PassportNumber  = @vstrPassportNumber,
        DepartmentID    = @intDepartmentID

      FROM
        dbo.Employee emp

      WHERE emp.ID = @rintID

    END
    
    COMMIT TRAN
    
    SET @intReturn = 0
  
  END TRY
  BEGIN CATCH
    
    SET @intErrNo  = @@ERROR

    IF (@@TRANCOUNT > 0)
      ROLLBACK TRAN

    IF (@intErrNo <> 0)
      SET @intReturn = @intErrNo;

    THROW

  END CATCH
  
  RETURN @intReturn

END

GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'vEmployeesAll', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Employee"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Department"
            Begin Extent = 
               Top = 6
               Left = 254
               Bottom = 118
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3150
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vEmployeesAll'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'vEmployeesAll', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vEmployeesAll'
GO
USE [master]
GO
ALTER DATABASE [sw-web-service] SET  READ_WRITE 
GO
