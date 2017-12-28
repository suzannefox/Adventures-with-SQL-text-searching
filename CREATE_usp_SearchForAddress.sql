USE [abp_search]
GO

/****** Object:  StoredProcedure [dbo].[usp_SearchForAddress]    Script Date: 28-Dec-17 4:40:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Suzanne Fox
-- Create date: Dec 2017
-- Description:	Search for an address
-- =============================================
CREATE PROCEDURE [dbo].[usp_SearchForAddress] @InputString nvarchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	DECLARE @InputString nvarchar(500) = ''
	DECLARE @SearchString nvarchar(500) = ''

	--SET @InputString = '"2*church*street*shipston*on*stour"'
	--SET @InputString = '2 church street, shipston-on-stour'

	--SET @InputString = '102 consfield'
	--SET @InputString = '2 high street hambledon'
	--SET @InputString = '11 Jarvis Street upavon pewsey'

	SET @SearchString = @InputString

	-- strip leading or trailing spaces
	SET @SearchString =  LTRIM(RTRIM(@SearchString))
	-- Replace commas
	SET @SearchString = REPLACE(@SearchString,',',' ')
	-- Replace dashes
	SET @SearchString = REPLACE(@SearchString,'-',' ')

	-- collapse whitespace
	WHILE CHARINDEX('  ',@SearchString  ) > 0
	BEGIN
	   SET @SearchString = replace(@SearchString, '  ', ' ')
	END

	-- Add ANDS
	SET @SearchString = REPLACE(@SearchString,' ',' AND ')
	-- SELECT @SearchString

	-- ================================================================
	-- SEARCH
	SELECT
		*
	FROM
		dbo.abp_search
	WHERE
		CONTAINS(search, @SearchString) 
	
END
GO

