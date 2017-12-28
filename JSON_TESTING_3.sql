
-- =====================================================
-- EXAMPLE 1 
-- Unpack  Parent/Child/GrandChild Structure
-- =====================================================

DECLARE @json_str NVARCHAR(MAX) = 
 '{ "ExtractID" : "A1",
    "Month" : "Jan",
    "People" : [
	  {"Id" : "1", 
	   "Name":"Fred", 
	   "Hobbies":["Tennis",
	              "Cricket"]},

	  {"Id" : "2", 
	   "Name":"Jim", 
	   "Hobbies":["Tennis",
	              "Golf"]},

	  {"Id" : "3", 
	   "Name":"Richard", 
	   "Hobbies":["Badmington",
	              "Cricket"]}
	]
  }'

-- Returns Key/Value pair
SELECT 0 AS LEVEL, 'root' AS CONTAINER, * 
FROM OPENJSON(@JSON_str, '$')

-- Return all children as records
SELECT 1 AS LEVEL, 'People' AS CONTAINER, * 
FROM OPENJSON(@JSON_str, '$.People')

-- Use Schema to Return all children as formatted table
; WITH myJSON AS (
	SELECT 1 AS LEVEL, 'People' AS CONTAINER, * 
	FROM OPENJSON(@JSON_str, '$.People')
)
SELECT 1 AS LEVEL, 'People' AS CONTAINER, * 
FROM OPENJSON(@JSON_str, '$.People')
  	WITH (Id  int            '$.Id',  
		  Name nvarchar(100) '$.Name',
		  [Hobbies]  nvarchar(MAX)  AS JSON
		)


-- Use Schema to Return a formatted Child table
; WITH myJSON AS (
	SELECT 1 AS LEVEL, 'People' AS CONTAINER, * 
	FROM OPENJSON(@JSON_str, '$.People')
),
myChildren as (
	SELECT LEVEL, CONTAINER, [Key],
		   JSON_VALUE([value], '$.Id') AS Id,
		   JSON_VALUE([value], '$.Name') AS Name,
		   JSON_QUERY([value], '$.Hobbies') AS Hobbies
	FROM myJSON
)
SELECT *
FROM myChildren

-- Get Grandchildren
DECLARE @x int = 0
WHILE @x < 3
BEGIN
	DECLARE @myCondition nvarchar(100)= '$.People[' + CAST(@x AS varchar(10)) + '].Hobbies'
	SELECT 2 AS LEVEL, 'Hobbies' AS CONTAINER, @x as ChildKey, * 
	FROM OPENJSON(@JSON_str, @myCondition)

	SELECT @x =  @x + 1
END

  -- =====================================================
-- EXAMPLE 2
-- Unpack With Schema
-- =====================================================

DECLARE @json NVARCHAR(MAX) = N'[  
  {  
    "Order": {  
      "Number":"SO43659",  
      "Date":"2011-05-31T00:00:00"  
    },  
    "AccountNumber":"AW29825",  
    "Item": {  
      "Price":2024.9940,  
      "Quantity":1  
    }  ,
	"Flags" : {"Progress" : "Yes", "Refer" : "Yes", "Followup" : "No"},

	"Flags2" : [{"P1" : "Yes"}, {"P1" : "Yes"}, {"P1" : "No"}]
  },  
  {  
    "Order": {  
      "Number":"SO43661",  
      "Date":"2011-06-01T00:00:00"  
    },  
    "AccountNumber":"AW73565",  
    "Item": {  
      "Price":2024.9940,  
      "Quantity":3  
    }  
  }
]'  

DECLARE @jsonChild NVARCHAR(MAX)

; WITH PARENT AS (
	SELECT *
	FROM OPENJSON ( @json )  
	WITH (   
				  Number   varchar(200)   '$.Order.Number',  
				  Date     datetime       '$.Order.Date',  
				  Customer varchar(200)   '$.AccountNumber',  
				  Quantity int            '$.Item.Quantity',  
				  Price float             '$.Item.Price', 
				  Floowup varchar(10)     '$.Flags.Followup', 
				  [Order]  nvarchar(MAX)  AS JSON ,
				  [Item] nvarchar(MAX) AS JSON,
				  [Flags2] nvarchar(MAX) AS JSON 
		)
)
SELECT *
FROM  PARENT

-- =========================================================
--
-- =========================================================
--Value of the Type column 	JSON data type
--0 	null
--1 	string
--2 	int
--3 	true/false
--4 	array
--5 	object