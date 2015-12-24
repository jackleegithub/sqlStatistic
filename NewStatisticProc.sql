
USE Statistic;
GO
/*

CREATE FUNCTION [dbo].[fnGetCourseNameByStuID]
(
	@StuID varchar(10),
	@CourseClassID tinyint
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @str nvarchar(1000) = '';
	DECLARE @CourseName nvarchar(1000) = NULL;
	DECLARE @minCourseID int = 0;
	
	SELECT @minCourseID = MIN(s.[CourseID]) 
	FROM StuCourse  AS s
		INNER JOIN Course AS c
			ON c.ID = s.CourseID
	WHERE s.[StuID] = @StuID AND c.CourseClassID = @CourseClassID;
	
	WHILE @minCourseID IS NOT NULL
	BEGIN
		SELECT @CourseName = [Name] FROM Course WHERE [id] = @minCourseID;
		SET @str = @str + '，' + @CourseName;
		
		SELECT @minCourseID = MIN(s.[CourseID]) 
		FROM StuCourse  AS s
			INNER JOIN Course AS c
				ON c.ID = s.CourseID
		WHERE s.[StuID] = @StuID AND c.CourseClassID = @CourseClassID AND s.[CourseID] > @minCourseID;
	END
	
	
	SET @str = SUBSTRING(@str, 2, LEN(@str));
	RETURN @str;
END;

GO

--get course name by campus grade class and stu
CREATE PROC uspGetCourseName
(
	@CampusID int,
	@GradeID int,
	@Class	int,
	@StuID	varchar(10)
)
AS
	SET NOCOUNT ON;
	
	IF '0' = @StuID
	BEGIN
		IF 0 = @Class
		BEGIN
			IF 0 = @GradeID
			BEGIN
				IF 0 = @CampusID 
				BEGIN -- (0,0,0,0)
					SELECT [LoginID]
						   ,[Name]
						   ,dbo.fnGetCourseNameByStuID([LoginID], 1) AS OrgName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 2) AS PhyName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 3) AS SciName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 4) AS ArtName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 5) AS OptName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 6) AS ContestName
					FROM StuInfo
				END
				ELSE
				BEGIN -- (1,0,0,0)
					SELECT [LoginID]
						   ,[Name]
						   ,dbo.fnGetCourseNameByStuID([LoginID], 1) AS OrgName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 2) AS PhyName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 3) AS SciName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 4) AS ArtName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 5) AS OptName
						   ,dbo.fnGetCourseNameByStuID([LoginID], 6) AS ContestName
					FROM StuInfo
					WHERE [CampusID]   = @CampusID  ;
				END
			END
			ELSE
			BEGIN -- (1,1,0,0)
				SELECT [LoginID]
					   ,[Name]
					   ,dbo.fnGetCourseNameByStuID([LoginID], 1) AS OrgName
					   ,dbo.fnGetCourseNameByStuID([LoginID], 2) AS PhyName
					   ,dbo.fnGetCourseNameByStuID([LoginID], 3) AS SciName
					   ,dbo.fnGetCourseNameByStuID([LoginID], 4) AS ArtName
					   ,dbo.fnGetCourseNameByStuID([LoginID], 5) AS OptName
					   ,dbo.fnGetCourseNameByStuID([LoginID], 6) AS ContestName
				FROM StuInfo
				WHERE [CampusID] = @CampusID AND [Grade]   = @GradeID ;
			END
		END
		ELSE
		BEGIN -- (1,1,1,0)
			SELECT [LoginID]
				   ,[Name]
				   ,dbo.fnGetCourseNameByStuID([LoginID], 1) AS OrgName
				   ,dbo.fnGetCourseNameByStuID([LoginID], 2) AS PhyName
				   ,dbo.fnGetCourseNameByStuID([LoginID], 3) AS SciName
				   ,dbo.fnGetCourseNameByStuID([LoginID], 4) AS ArtName
				   ,dbo.fnGetCourseNameByStuID([LoginID], 5) AS OptName
				   ,dbo.fnGetCourseNameByStuID([LoginID], 6) AS ContestName
			FROM StuInfo
			WHERE [CampusID] =@CampusID AND [Grade] = @GradeID AND [Class] = @Class;
		END
	END
	ELSE
	BEGIN --(1,1,1,1)
		SELECT [LoginID]
			   ,[Name]
			   ,dbo.fnGetCourseNameByStuID([LoginID], 1) AS OrgName
			   ,dbo.fnGetCourseNameByStuID([LoginID], 2) AS PhyName
			   ,dbo.fnGetCourseNameByStuID([LoginID], 3) AS SciName
			   ,dbo.fnGetCourseNameByStuID([LoginID], 4) AS ArtName
			   ,dbo.fnGetCourseNameByStuID([LoginID], 5) AS OptName
			   ,dbo.fnGetCourseNameByStuID([LoginID], 6) AS ContestName
		FROM StuInfo
		WHERE [LoginID]  = @StuID;
	END
	
	


CREATE PROC uspGetCourseNameByStuID
(
	@StuID varchar(10)
)
AS
	SET NOCOUNT ON;
	SELECT [LoginID]
		   ,[Name]
		   ,dbo.fnGetCourseNameByStuID([LoginID], 1) AS OrgName
		   ,dbo.fnGetCourseNameByStuID([LoginID], 2) AS PhyName
		   ,dbo.fnGetCourseNameByStuID([LoginID], 3) AS SciName
		   ,dbo.fnGetCourseNameByStuID([LoginID], 4) AS ArtName
		   ,dbo.fnGetCourseNameByStuID([LoginID], 5) AS OptName
		   ,dbo.fnGetCourseNameByStuID([LoginID], 6) AS ContestName
	FROM StuInfo
	WHERE [LoginID]  = @StuID;
GO
  
CREATE PROC uspInsertStuSelectedCourse
(
	@StuID varchar(10),
	@CourseID int
)
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS(SELECT ID FROM StuCourse WHERE [StuID] = @Stuid AND [CourseID] = @CourseID)
	BEGIN
		INSERT INTO StuCourse ([StuID] ,[CourseID] )VALUES(@StuID, @CourseID );
	END
END




CREATE PROC uspGetCourseInfo
(	
	@CourseClassID int 
)
AS
	SET NOCOUNT ON
	SELECT [id],[name] FROM dbo.Course WHERE [CourseClassID] = @CourseClassID;
GO


	
CREATE PROC CheckLogin		--VERSION 2
	@LoginID varchar(10),
	@LoginPwd varchar(20),
	@Roles varchar(100) OUTPUT
AS
	SET NOCOUNT ON;
	DECLARE @tID varchar(10) = NULL;
	SELECT @tID  = [LoginID], @Roles = [Roles] FROM dbo.StuInfo WHERE [LoginID] = @LoginID AND [pwd] = @LoginPwd;
	IF @tID IS NULL
		BEGIN
			RETURN 1;
		END
	ELSE
		BEGIN
			RETURN 0;
		END;
		
GO

--Student modify password
CREATE PROCEDURE uspUserChangePwd
(
	@StuID varchar(10),
	@OldPwd varchar(20),
	@NewPwd varchar(20)
)
AS
	SET NOCOUNT ON;
	IF EXISTS (SELECT [LoginID] FROM [dbo].[StuInfo]  WHERE [LoginID] = @StuID AND [Pwd] = @OldPwd )
	BEGIN
		UPDATE [dbo].[StuInfo] SET [Pwd] = @NewPwd WHERE [LoginID] = @StuID;
		RETURN 0;
	END 
	ELSE
	BEGIN
		RETURN 1;
	END;
GO

--Get Campus info
CREATE PROCEDURE uspGetCampusInfo
AS
	SET NOCOUNT ON;
	
	SELECT 0 AS [id], '全部' AS [Name]
	UNION
	SELECT [ID],[Name] FROM [Info].[Campus];
GO

--Get grade info by campus id
CREATE PROCEDURE uspGetGradeInfoByCampusID
(
	@CampusID int
)
AS
	SET NOCOUNT ON;
	
	SELECT 0 AS [ID], '全部' AS [Name]
	UNION
	SELECT g.ID, g.Name 
	FROM Info.Grade AS g
		INNER JOIN dbo.GradeInCampus AS gc
		ON gc.GradeID = g.id
	 WHERE gc.CampusID = @CampusID ;
	
GO

--Get Class info by grade id
CREATE PROCEDURE uspGetClassInfoByGradeID
(
	@GradeID int
)
AS
	SET NOCOUNT ON;

	SELECT 0 AS [ID], '全部' AS [Name]
	UNION
	SELECT DISTINCT [Class], [Class] + '班' FROM dbo.StuInfo WHERE [Grade] = @GradeID ;
GO



--Get student info by grade id and class id
CREATE PROCEDURE uspGetStuInfoByGradeAndClass
(
	@GradeID int,
	@ClassID int
)
AS
	SELECT 0 AS [ID], '全部' AS [Name]
	UNION
	SELECT [LoginID], [Name] FROM dbo.StuInfo  WHERE [Grade] = @GradeID AND [Class] = @ClassID;
GO


CREATE PROCEDURE uspGetCourseClassInfo
AS
	SET NOCOUNT ON;
	SELECT [ID], [Name] FROM Info.CourseClass;
GO

*/
