
USE [abp_search]

exec usp_SearchForAddress '59 Hylton Street'

RETURN

-- ===========================================================
select *
from abp_search
where
	contains(search, '2 AND CHURCH AND "STR*" AND SHIPSTON') 
order by 
	search

RETURN

select *
from abp_search
where
	contains(search, 'CHURCH AND SHIPSTON') and 
	search like '2 %'
order by search

RETURN
-- ===========================================================
-- EXAMPLE 1a - Instant - returns 16 records
select *
from abp_search
where
	contains(search, 'CHURCH AND SHIPSTON') and 
	search like '2 %'
order by search

-- EXAMPLE 1b - Takes 1:52 - returns 16 records
select *
from abp_search
where
	search like '%church%' and
	search like '%shipston%' and
	search like '2%'
order by search

-- EXAMPLE 1c - Instant - returns 16 records
DECLARE @SearchString nvarchar(100) = 'CHURCH AND SHIPSTON'
select *
from abp_search
where
	contains(search, @SearchString) and 
	search like '2%'
order by search

-- ===========================================================
-- EXAMPLE 2 - OK
select *
from abp_search
where
	contains(search, '20 AND CHURCH AND SHIPSTON')
order by search

-- ===========================================================
-- EXAMPLE 3a - FAILS TO  RETURN ANY RECORDS
-- Need to use an empty stoplist or else single numbers are stopped
select *
from abp_search
where
	contains(search, '2 AND CHURCH AND SHIPSTON') 
order by search

-- Example 3b - Takes 1:47 - returns 7 rows
select *
from abp_search
where
	search like '%church%' and
	search like '%shipston%' and
	search like '2 %'
order by search

-- Example 3c - FAILS TO  RETURN ANY RECORDS
-- DECLARE @SearchString nvarchar(100) = '2 AND CHURCH AND SHIPSTON'
select *
from abp_search
where
	contains(search, @SearchString)
order by search

RETURN

-- ================================================
-- 617 Cricklade Road, Swindon Swindon

select
	*
from
	abp_search
where
	contains(search, '617 AND cricklade AND road AND swindon AND swindon') -- 8 secs/2 secs
order by
	search


RETURN
-- ================================================

-- ================================================

select
	*
from
	abp_search
where
--	contains(search,'63 AND Balch AND Road AND Wells AND Somerset') -- 38 secs zero
--	contains(search,'Balch') -- 38 secs zero
--	contains(search, '34 AND Gilsland AND Street AND Sunderland') -- 42 secs
--	contains(search, '34 AND Gilsland AND Sunderland') -- 40 secs
	contains(search, '34 AND Gilsland AND sunderland') -- 2 secs
order by
	search

RETURN

select
	*
from
	abp_search
where
	contains(search,'shipston')