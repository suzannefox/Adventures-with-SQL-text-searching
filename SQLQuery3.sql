-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_CREATE_FULL_TEXT_INDEX
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- MAKE SURE UNIQUE,  NON NULLABLE INDEXES EXISTON THE TABLE
	-- CAN'T DO THIS VIA ALTER TABLE
	DROP INDEX ui_blpu ON dbo.blpu
	CREATE UNIQUE INDEX ui_blpu ON dbo.blpu(UPRN); 

	DROP INDEX ui_delivery_point ON dbo.delivery_point
	CREATE UNIQUE INDEX ui_delivery_point ON dbo.delivery_point(UPRN);  

	-- ====================================
	-- CREATE full  text search
	-- ====================================
	CREATE FULLTEXT INDEX ON dbo.delivery_point 
	(  
		Document                         --Full-text index column name   
			TYPE COLUMN POST_TOWN    --Name of column that contains file type information  
			Language 2057                 --2057 is the LCID for British English  
	)  
	KEY INDEX ui_TEXT_delivery_point ON ui_delivery_point --Unique index  
	WITH CHANGE_TRACKING AUTO            --Population type;  

END