
SELECT BulkColumn
 FROM OPENROWSET (BULK 'C:\Users\SuzanneFox\Documents\Zoopla\simple.json', SINGLE_CLOB) as j


DECLARE @json NVARCHAR(MAX)

SET @json='{"name":"John","surname":"Doe","age":45,"skills":["SQL","C#","MVC"]}';

SELECT *
FROM OPENJSON(@json);