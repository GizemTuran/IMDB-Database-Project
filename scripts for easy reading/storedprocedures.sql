--STORED PROCEDURE


--P1
CREATE PROCEDURE actorsofmovie
@moviename varchar(200)
AS 
BEGIN 
DECLARE @Result table(Name nvarchar(200),Surname nvarchar(200))

SELECT pp.Name, pp.Surname FROM person.Person AS pp
INNER JOIN person.PersonWorkingOnMovie AS pwo
ON pwo.PersonID=pp.ID
INNER JOIN movie.Movie AS mm
ON mm.ID=pwo.MovieID WHERE mm.Name=@moviename
END


EXEC dbo.actorsofmovie'The Dark Knight'

--P2
CREATE PROCEDURE GetCategoryByMovie
@name varchar(200)
AS
BEGIN
DECLARE @Result table(Name nvarchar(200))
SELECT mc.Name FROM movie.Category AS mc
INNER JOIN movie.Movie_Category AS mmc
ON mmc.CategoryID=mc.ID
INNER JOIN movie.Movie AS mm
ON mmc.MovieID=mm.ID
WHERE mm.Name=@name
END

EXEC dbo.GetCategoryByMovie 'The Dark Knight'

--P3
CREATE PROCEDURE GetMovieByCategory
@category varchar(200)
AS
BEGIN
DECLARE @Result table(Category nvarchar(200))
SELECT mm.Name FROM movie.Movie AS mm
INNER JOIN movie.Movie_Category AS mmc
ON mmc.MovieID=mm.ID
INNER JOIN movie.Category AS mc
ON mmc.CategoryID=mc.ID
WHERE mc.Name=@category
END

EXEC dbo.GetMovieByCategory 'Comedy'

--P4
--budgetı 200 binden fazla olan producerları printle

CREATE PROCEDURE GetProducerByBudget
@budget int
AS
BEGIN
SELECT pp.Name FROM person.Producer AS pp
INNER JOIN person.producer_Movie AS ppm
ON ppm.ProducerID=pp.ID
INNER JOIN movie.Movie AS mm
ON ppm.MovieID=mm.ID
WHERE mm.Budget >= @budget
END

EXEC dbo.GetProducerByBudget 200000

--P5

--1990 ve 2000 arasında yapılan filmleri bastır
CREATE PROCEDURE GetMoviesBetweenDates
@firstdate date, @seconddate date
AS
BEGIN
SELECT mm.ReleaseDate,mm.Name FROM movie.Movie AS mm WHERE mm.ReleaseDate BETWEEN @firstdate AND @seconddate
END

EXEC dbo.GetMoviesBetweenDates '1990/01/01' ,'2000/01/01' 

--P6
--Ödül ismi girilsin alan filmler listelensin

CREATE PROCEDURE GetMoviesByAward
@awardname nvarchar(200)
AS
BEGIN
SELECT mao.Name,mm.Name FROM movie.Movie AS mm
INNER JOIN movie.Award AS ma
ON ma.MovieID=mm.ID
INNER JOIN movie.AwardOrganization AS mao
ON ma.AwardOrganizationID=mao.ID
WHERE mao.Name=@awardname
END

EXEC dbo.GetMoviesByAward 'Emmy'

--P7
CREATE PROCEDURE DeletePhoto
@galleryid int,@image nvarchar(50)
AS
BEGIN
	DELETE media.Photo
	WHERE GalleryID=@galleryid AND image=@image
END

EXEC dbo.DeletePhoto 22,'22.png'

--P8

CREATE PROCEDURE actorsAllMovies
@actorName varchar(200),
@actorSurname varchar(200)
AS
BEGIN
DECLARE @Result table(MovieName varchar(200),RoleName varchar(200))
SELECT M.Name, PWM.Role
FROM person.Person AS P
INNER JOIN person.PersonWorkingOnMovie AS PWM
ON P.ID = PWM.PersonID
INNER JOIN movie.Movie AS M
ON M.ID = PWM.MovieID
WHERE P.Name = @actorName AND P.Surname=@actorSurname
END


EXEC dbo.actorsAllMovies 'Brad','Pitt'

--P9
--UserRateleri 6'nın üzerinde olanları alınır.

CREATE PROCEDURE userRatesLimit
@rateLimit int
AS
BEGIN

SELECT  M.Name, AVG(RM.Rating) AS [UserRatesByRateLimit]
FROM [users].[User] AS U
INNER JOIN [users].[Rate_On_Movie] AS RM
ON U.ID = RM.UserID
INNER JOIN movie.Movie AS M
ON M.ID = RM.MovieID
GROUP BY M.Name , U.Name
HAVING AVG(RM.Rating) > @rateLimit 
ORDER BY AVG(RM.Rating) DESC

END

EXEC dbo.userRatesLimit '6'


--P10

CREATE PROCEDURE GetUserCommentbyMovie
@movieName varchar(200)
AS
BEGIN

SELECT U.Name,UR.Comment 
FROM [users].[User] AS U
INNER JOIN users.UserReview AS UR
ON UR.UserID = U.ID
INNER JOIN movie.Movie AS M
ON M.ID = UR.MovieID
WHERE M.Name = @movieName

END

EXEC dbo.GetUserCommentbyMovie 'Inception'

--P11

CREATE PROCEDURE GetActorByMoviesDate
@mdate date
AS
BEGIN

SELECT P.Name AS [Actor Name], P.Surname , M.Name AS [Movie Name] ,M.ReleaseDate
FROM person.Person AS P
INNER JOIN person.PersonWorkingOnMovie AS PWD
ON P.ID = PWD.PersonID
INNER JOIN movie.Movie AS M
ON M.ID = PWD.MovieID
INNER JOIN person.Star AS S
ON S.PersonID = P.ID
WHERE M.ReleaseDate > @mdate

END

EXEC dbo.GetActorByMoviesDate '2012/01/01'



--P12


CREATE PROCEDURE MostPopularMoviesbyRank
@popularityRank int
AS
BEGIN
SELECT M.Name,M.Popularity
FROM movie.Movie AS M
WHERE M.Popularity < @popularityRank

END



EXEC dbo.MostPopularMoviesbyRank 500


--P13

CREATE PROCEDURE GetMovieByDirector
@directorName  varchar(200),
@directorSurName  varchar(200)
AS
BEGIN
SELECT M.Name , PWD.Role
FROM movie.Movie AS M
INNER JOIN person.PersonWorkingOnMovie AS PWD
ON PWD.MovieID = M.ID
INNER JOIN person.Person AS P
ON P.ID = PWD.PersonID
WHERE P.Name = @directorName AND P.Surname = @directorSurName AND PWD.Role = 'Director'

END


EXEC dbo.GetMovieByDirector 'Christopher','Nolan'


--P14

CREATE PROCEDURE GetActorNumberByProducer
@producerName  varchar(200)
AS
BEGIN
SELECT PR.Name AS [ProducerName] , P.Name ,P.Surname
FROM person.Producer AS PR
INNER JOIN person.Producer_Movie PM
ON PM.ProducerID = PR.ID
INNER JOIN movie.Movie AS M
ON M.ID = PM.MovieID
INNER JOIN person.PersonWorkingOnMovie AS PWM
ON M.ID = PWM.MovieID
INNER JOIN person.Person as P
ON P.ID = PWM.PersonID
WHERE PWM.Role = 'Lead role' AND PR.Name = @producerName
END



EXEC dbo.GetActorNumberByProducer 'Warner Bros.'


---P15

CREATE PROCEDURE GetNumberOfPhotosOfMovie
@movieName  varchar(200)
AS
BEGIN
SELECT M.Name , COUNT(PH.image) as [Number Of Photo]
FROM movie.Movie as M
INNER JOIN media.Gallery AS G
ON G.MovieID = M.ID
INNER JOIN media.Photo AS PH
ON PH.GalleryID = G.ID
GROUP BY M.Name
HAVING M.Name = @movieName

END


EXEC dbo.GetNumberOfPhotosOfMovie 'The Dark Knight'

