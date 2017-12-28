USE [JSON_TESTING]

--SELECT *
--FROM  tbl_Downloads
--ORDER BY Id_Identity DESC

DECLARE @dl int = 14

SELECT *
FROM  tbl_Downloads
WHERE Id_Identity=@dl

SELECT *
FROM  tbl_DownloadFile
WHERE Id_Download=@dl

SELECT *
FROM  tbl_Listing_page
where ID_Download=@dl

SELECT *
FROM  tbl_Listing
WHERE Id_Download=@dl


