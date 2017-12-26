
SELECT 
	*
FROM 
	dbo.delivery_point
WHERE
	contains(building_name, 'second')

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