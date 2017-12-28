

DECLARE @SearchString nvarchar(500) 
DECLARE @Option int = 2

IF @Option = 1 SELECT @SearchString =  '11 AND Jocelyn  AND Drive  AND Wells  AND Jocelyn  AND Drive  AND Wells' -- 4 seconds / instant
IF @Option = 2 SELECT @SearchString =  '11 AND Jocelyn  AND Drive  AND Wells' -- 1 second / instant

select *
from abp_search
where
	contains(search, @SearchString) 
order by 
	search
