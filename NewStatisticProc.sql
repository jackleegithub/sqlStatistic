
USE Statistic;
GO

/*
2015-12-27
--修改uspGetCourseInfo
----增加输入参数@CampusID,以区分不同校区的课程信息。
*/
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
	END;
GO	

--get course name by campus grade class and stu v2.0 2015-12-27
CREATE PROC uspGetCourseNameDynamic
(
	@CampusID int,
	@GradeID int,
	@Class	int,
	@StuID	varchar(10)
)
AS
	SET NOCOUNT ON;
	
	DECLARE @str varchar(2000) ;
	DECLARE @minCourseClassID int;

	SET @str = 'SELECT [LoginID],[Name]'
	SELECT @minCourseClassID = MIN(ID) FROM Info.CourseClass;
	WHILE @minCourseClassID IS NOT NULL
	BEGIN
		SET @str = @str + ',dbo.fnGetCourseNameByStuID([LoginID],' + CAST(@minCourseClassID as varchar) +') AS Column' + CAST(@minCourseClassID as varchar);
		SELECT @minCourseClassID = MIN(ID) FROM Info.CourseClass WHERE [ID] >  @minCourseClassID;
	END
	SET @str = @str + ' FROM StuInfo'
	
	IF '0' = @StuID
	BEGIN
		IF 0 = @Class
		BEGIN
			IF 0 = @GradeID
			BEGIN
				IF 0 = @CampusID 
				BEGIN -- (0,0,0,0)
					SET @str = @str + ' WHERE 1 = 1';
				END
				ELSE
				BEGIN -- (1,0,0,0)
					SET @str = @str + ' WHERE [CampusID]   =' + CAST(@CampusID AS varchar);
				END
			END
			ELSE
			BEGIN -- (1,1,0,0)
				SET @str = @str + ' WHERE [CampusID] = '+ CAST(@CampusID AS varchar) + ' AND [Grade] = ' + CAST(@GradeID AS varchar) ;
			END
		END
		ELSE
		BEGIN -- (1,1,1,0)
			SET @str = @str + ' WHERE [CampusID] ='+ CAST(@CampusID AS varchar) + ' AND [Grade] ='+ CAST(@GradeID AS varchar)+' AND [Class] = ' + CAST(@Class AS varchar);
		END
	END
	ELSE
	BEGIN --(1,1,1,1)
		SET @str = @str + ' WHERE [LoginID]  = ''' +  @StuID + '''';
	END;
	
	EXEC (@str);
GO

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



/*
获取课程信息
Parameter:
	*CourseClassID int 课程分类ID
	*CampusID int 校区ID
Return：
	*课程ID，名称的表
*/
CREATE PROC uspGetCourseInfo
(	
	@CourseClassID int,
	@CampusID int
)
AS
	SET NOCOUNT ON
	SELECT [id],[name] FROM dbo.Course WHERE [CourseClassID] = @CourseClassID AND [CampusID] = @CampusID;
GO


	
CREATE PROC CheckLogin		--VERSION 2
	@LoginID varchar(10),
	@LoginPwd varchar(20),
	@Roles varchar(100) OUTPUT,
	@CampusID int OUTPUT
AS
	SET NOCOUNT ON;
	DECLARE @tID varchar(10) = NULL;
	SELECT @tID  = [LoginID], @Roles = [Roles], @CampusID = [CampusID] FROM dbo.StuInfo WHERE [LoginID] = @LoginID AND [pwd] = @LoginPwd;
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
