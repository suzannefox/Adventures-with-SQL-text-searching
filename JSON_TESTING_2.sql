



DECLARE @JSON_String VARCHAR(MAX)
 
SELECT @JSON_String = BulkColumn FROM OPENROWSET(BULK'D:\Suzanne\Zoopla\Test_listing.json', SINGLE_BLOB) JSON;
SELECT @JSON_String as SingleRow_Column

; WITH LISTS AS (
	SELECT * FROM  
	dbo.HierarchyFromJSON(@JSON_String)
	WHERE Name IN ('Listing_id','bullet')
)
SELECT *
FROM LISTS

RETURN

--  Check for valid format
IF (ISJSON(@JSON_String) = 1)
	SELECT 'Valid JSON'
ELSE
	SELECT 'Invalid JSON format'

-- Works
--SELECT * FROM OPENJSON(@JSON_String, '$.listing_page.listing')
-- doesn't work
--SELECT * FROM OPENJSON(@JSON_String, '$.listing.price')


SELECT [Key], Value 
FROM OPENJSON(@JSON_String, '$.listing_page.listing')

RETURN
SELECT * FROM
  OPENJSON(@JSON_String, '$.listing_page.listing')
  WITH(
        price nvarchar(50) '$.price',
        property_id nvarchar(50) '$.property_id',
		outcode nvarchar(50) '$.outcode',
        incode nvarchar(50) '$.incode',
		status nvarchar(50) '$.status'
  )