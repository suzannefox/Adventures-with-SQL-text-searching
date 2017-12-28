
USE [JSON_TESTING]

-- ====================================
-- Testing 1 for yes,  0 for live
-- Testing mode is only different because it doesn't write 
--        so many log records
-- ====================================

DECLARE @Testing bit = 0

-- ====================================
-- Variables
-- ====================================
DECLARE @JSON VARCHAR(MAX)
DECLARE @JSON_FILE nvarchar(200)=''
SET @JSON_FILE = 'D:\Suzanne\Zoopla\weekly_listings_big.json';

-- =====================================
-- Write a log record to tbl_Downloads
-- =====================================
DECLARE @Id_Download int=0
IF @Testing=0 
BEGIN
	INSERT INTO tbl_Downloads SELECT @JSON_FILE, getdate(), NULL
	SELECT @Id_Download = @@IDENTITY
END

-- ====================================
-- Setup Dynamic SQL so we can pass a file name as string
-- Because BULK doesn't take string arguments
-- PURPOSE :  get the json file and read into @JSON variable
-- ====================================
DECLARE @SQL_OPEN nvarchar(1000)='SELECT @JSON_OUT = BulkColumn FROM OPENROWSET (BULK ~file, SINGLE_CLOB) as j'
DECLARE @SQL_RUN nvarchar(1000)=''
DECLARE @JSON_PARAM nvarchar(500) = N'@JSON_OUT VARCHAR(MAX) OUTPUT';  
SET @SQL_RUN = REPLACE(@SQL_OPEN, '~file' ,CHAR(39) + @JSON_FILE + CHAR(39))

exec sp_executesql @SQL_RUN, @JSON_PARAM, @JSON_OUT=@json OUTPUT;

IF @Testing=0
BEGIN
	UPDATE tbl_Downloads
	SET RunFinish=getdate()
	WHERE Id_Identity=@Id_Download
END

-- ====================================
-- Create target tables
-- ====================================
-- tbl_DownloadFile =  The source file in
--    key/value/type format
--    Id_Download = tbl_Downloads.Id_Identity
--    key='listing_page' & id_Download=* gives listing pages for a file
-- ====================================
INSERT INTO tbl_DownloadFile
SELECT @Id_Download AS Id_Download, * 
FROM OPENJSON(@json, '$') as json

-- ==============================================================
-- Get the listing pages for this file
-- ==============================================================
print '... Getting Listing pages'

DELETE FROM  tbl_Listing_page
SET  @JSON=''

DECLARE @Id_Listing_page int=0
DECLARE JSON_CURSOR CURSOR FOR 
	SELECT ID_Identity, value FROM tbl_DownloadFile 
	WHERE [key]='listing_page' AND Id_Download = @Id_Download

OPEN JSON_cursor  

	FETCH NEXT FROM JSON_cursor   
	INTO @Id_Listing_page, @JSON  

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		INSERT INTO tbl_Listing_page
		SELECT @Id_Download,  @Id_Listing_page, * 
		FROM OPENJSON(@JSON, '$')

		FETCH NEXT FROM JSON_cursor   
		INTO @Id_Listing_page, @JSON
	END

CLOSE JSON_cursor
DEALLOCATE JSON_cursor

-- ========================================================
-- Get individual listings, i.e. individual properties 
-- ========================================================
print '... Getting Property Listings'

DELETE FROM tbl_listing
SET  @JSON=''

DECLARE @Id_Listing int=0
DECLARE JSON_CURSOR CURSOR FOR 
	SELECT Id_Identity,  ID_Listing_Page, value 
	FROM tbl_Listing_page 
	WHERE [key]='listing'

OPEN JSON_cursor

	FETCH NEXT FROM JSON_cursor  
	INTO @Id_Listing, @Id_Listing_page,  @JSON

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		INSERT INTO tbl_listing
		SELECT @Id_Download, @Id_Listing_page, @Id_Listing, * 
		FROM OPENJSON(@JSON, '$')

		FETCH NEXT FROM JSON_cursor
		INTO @Id_Listing, @Id_Listing_page,  @JSON
	END

CLOSE JSON_cursor
DEALLOCATE JSON_cursor

