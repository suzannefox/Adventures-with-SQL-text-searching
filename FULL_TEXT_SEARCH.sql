
USE [abp]

DECLARE @SetupTables varchar(1)='N'

IF @SetupTables = 'Y'
BEGIN
	-- STEP 1
	-- Check if fulltextsearch is installed
	-- SELECT FULLTEXTSERVICEPROPERTY('IsFullTextInstalled')

	-- STEP 2.1
	-- Drop and Create table
	-- Make sure there is a unique key index
	DROP TABLE delivery_point ;
	CREATE TABLE [dbo].[delivery_point](
		[Id_Identity] [int] NOT NULL,
		[RECORD_IDENTIFIER] [int] NULL,
		[CHANGE_TYPE] [varchar](255) NULL,
		[PRO_ORDER] [int] NULL,
		[UPRN] [varchar](255) NULL,
		[UDPRN] [int] NULL,
		[ORGANISATION_NAME] [varchar](255) NULL,
		[DEPARTMENT_NAME] [varchar](255) NULL,
		[SUB_BUILDING_NAME] [varchar](255) NULL,
		[BUILDING_NAME] [varchar](255) NULL,
		[BUILDING_NUMBER] [int] NULL,
		[DEPENDENT_THOROUGHFARE] [varchar](255) NULL,
		[THOROUGHFARE] [varchar](255) NULL,
		[DOUBLE_DEPENDENT_LOCALITY] [varchar](255) NULL,
		[DEPENDENT_LOCALITY] [varchar](255) NULL,
		[POST_TOWN] [varchar](255) NULL,
		[POSTCODE] [varchar](255) NULL,
		[POSTCODE_TYPE] [varchar](255) NULL,
		[DELIVERY_POINT_SUFFIX] [varchar](255) NULL,
		[WELSH_DEPENDENT_THOROUGHFARE] [varchar](255) NULL,
		[WELSH_THOROUGHFARE] [varchar](255) NULL,
		[WELSH_DOUBLE_DEPENDENT_LOCALITY] [varchar](255) NULL,
		[WELSH_DEPENDENT_LOCALITY] [varchar](255) NULL,
		[WELSH_POST_TOWN] [varchar](255) NULL,
		[PO_BOX_NUMBER] [varchar](255) NULL,
		[PROCESS_DATE] [varchar](255) NULL,
		[START_DATE] [varchar](255) NULL,
		[END_DATE] [varchar](255) NULL,
		[LAST_UPDATE_DATE] [varchar](255) NULL,
		[ENTRY_DATE] [varchar](255) NULL,
	 CONSTRAINT [PK_delivery_point] 
	 PRIMARY KEY CLUSTERED ([Id_Identity] ASC) 
	 WITH (PAD_INDEX = OFF, 
			STATISTICS_NORECOMPUTE = OFF, 
			IGNORE_DUP_KEY = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) 
	ON [PRIMARY]

	-- STEP 2.2
	-- Drop and Create table
	-- Make sure there is a unique key index
	DROP TABLE blpu ;
	CREATE TABLE [dbo].[blpu](
		[Id_Identity] [int] NOT NULL,
		[RECORD_IDENTIFIER] [int] NULL,
		[CHANGE_TYPE] [varchar](255) NULL,
		[PRO_ORDER] [int] NULL,
		[UPRN] [varchar](255) NOT NULL,
		[LOGICAL_STATUS] [int] NULL,
		[BLPU_STATE] [int] NULL,
		[BLPU_STATE_DATE] [varchar](255) NULL,
		[PARENT_UPRN] [varchar](255) NULL,
		[X_COORDINATE] [float] NULL,
		[Y_COORDINATE] [float] NULL,
		[LATITUDE] [float] NULL,
		[LONGITUDE] [float] NULL,
		[RPC] [int] NULL,
		[LOCAL_CUSTODIAN_CODE] [int] NULL,
		[COUNTRY] [varchar](255) NULL,
		[START_DATE] [varchar](255) NULL,
		[END_DATE] [varchar](255) NULL,
		[LAST_UPDATE_DATE] [varchar](255) NULL,
		[ENTRY_DATE] [varchar](255) NULL,
		[ADDRESSBASE_POSTAL] [varchar](255) NULL,
		[POSTCODE_LOCATOR] [varchar](255) NULL,
		[MULTI_OCC_COUNT] [int] NULL,
	 CONSTRAINT [PK_blpu] 
	 PRIMARY KEY CLUSTERED ( [Id_Identity] ASC) 
	 WITH (PAD_INDEX = OFF, 
		   STATISTICS_NORECOMPUTE = OFF, 
		   IGNORE_DUP_KEY = OFF, 
		   ALLOW_ROW_LOCKS = ON, 
		   ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) 
	 ON [PRIMARY]

	-- STEP 3
	print 'NOW IMPORT CSV DATA USING R'

	RETURN
END
ELSE
	-- STEP 4
	-- Check tables
	SELECT 
		t.NAME AS TableName,
		i.name as indexName,
		p.[Rows],
		sum(a.total_pages) as TotalPages, 
		sum(a.used_pages) as UsedPages, 
		sum(a.data_pages) as DataPages,
		(sum(a.total_pages) * 8) / 1024 as TotalSpaceMB, 
		(sum(a.used_pages) * 8) / 1024 as UsedSpaceMB, 
		(sum(a.data_pages) * 8) / 1024 as DataSpaceMB
	FROM 
		sys.tables t
	INNER JOIN      
		sys.indexes i ON t.OBJECT_ID = i.object_id
	INNER JOIN 
		sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
	INNER JOIN 
		sys.allocation_units a ON p.partition_id = a.container_id
	WHERE 
		t.NAME NOT LIKE 'dt%' AND
		i.OBJECT_ID > 255 AND   
		i.index_id <= 1
	GROUP BY 
		t.NAME, i.object_id, i.index_id, i.name, p.[Rows]
	ORDER BY 
		object_name(i.object_id) 

	-- STEP 5
	-- Drop and Create Text Catalog
	DROP FULLTEXT CATALOG Address_Catalog;
	CREATE FULLTEXT CATALOG Address_Catalog AS DEFAULT; 

	-- STEP 6.1
	-- Create text index
	CREATE FULLTEXT INDEX ON dbo.blpu(UPRN) KEY INDEX PK_blpu;  

	-- STEP 6.2
	-- Create text index
	CREATE FULLTEXT INDEX ON dbo.delivery_point(BUILDING_NAME,
	                                            SUB_BUILDING_NAME,
												THOROUGHFARE, 
	                                            POST_TOWN, 
												POSTCODE) KEY INDEX PK_delivery_point;  

	-- STEP 7
	-- Check TextSearch Indexes
	SELECT 'FULLTEXTSEARCH' AS Type, o.name as TableName, c.name as ColumnName, ftic.language_id
	FROM 
		sys.fulltext_index_columns ftic
	INNER JOIN
		sys.objects o on ftic.object_id = o.object_id
	INNER JOIN
		sys.columns c on ftic.object_id = c.object_id AND ftic.column_id = c.column_id