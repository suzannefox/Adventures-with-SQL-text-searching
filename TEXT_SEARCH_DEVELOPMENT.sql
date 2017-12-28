


RETURN

select 
	*
from 
	test
WHERE 
	search like '% ANGLE%'

RETURN


ALTER TABLE test
ADD CONSTRAINT PK_test
-- PRIMARY KEY(Id_Identity)
	PRIMARY KEY CLUSTERED ([Id_Identity] ASC) 
	WITH (PAD_INDEX = OFF, 
		STATISTICS_NORECOMPUTE = OFF, 
		IGNORE_DUP_KEY = OFF, 
		ALLOW_ROW_LOCKS = ON, 
		ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]

CREATE FULLTEXT INDEX ON dbo.test(SEARCH) KEY INDEX PK_test;  


RETURN
RETURN
-- ======================================
-- finds kingston and staines 6 seconds for 43477
SELECT 
	*
FROM 
	dbo.delivery_point
WHERE
	contains(POST_TOWN,'UPON AND THAMES') 

RETURN
-- ======================================
-- 70/77/85
SELECT 
	SUB_BUILDING_NAME, BUILDING_NAME, BUILDING_NUMBER, THOROUGHFARE,  POST_TOWN, POSTCODE
FROM 
	dbo.delivery_point
WHERE
	contains(POSTCODE, 'CV36') and contains(thoroughfare,'campden')
ORDER BY
	BUILDING_NUMBER

RETURN

SELECT 
	*
FROM 
	delivery_point
WHERE
	freetext(building_name, 'floor')

RETURN
SELECT 
	building_name
from 
	delivery_point
WHERE
	building_name <> ''