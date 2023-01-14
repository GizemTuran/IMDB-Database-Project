--TRIGGER

--T1

CREATE TRIGGER AllDMLOperationForRole
ON role.Role
FOR INSERT,DELETE,UPDATE
AS
BEGIN
	PRINT 'NOT ALLOWED PERFORM INSERT OPERATION'
	ROLLBACK TRANSACTION
END

INSERT INTO role.Role VALUES('visitor')

--T2


CREATE TRIGGER userScoredMovie
ON [users].[Rate_On_Movie]
AFTER INSERT
AS 
BEGIN
DECLARE @nUserID int,@nMovieID int, @nrate int, @nmovieRate int
SELECT @nUserID = UserID ,@nMovieID =MovieID, @nrate=Rating FROM INSERTED;
SET @nmovieRate = (SELECT AVG(RM.Rating) FROM  users.Rate_On_Movie AS RM WHERE RM.MovieID = @nMovieID)
UPDATE movie.Movie
SET Rating = @nmovieRate
WHERE ID = @nMovieID
END


INSERT INTO users.Rate_On_Movie VALUES(1,2,3)


--T3


CREATE TRIGGER ModifedComment
ON users.UserReview
AFTER UPDATE
AS 
BEGIN
DECLARE @mUserID varchar(200),@mMovieID varchar(200),@mComment varchar(200), @mCommentDate datetime
SELECT @mUserID = UserID , @mMovieID = MovieID, @mComment = Comment,@mCommentDate = CommentDate FROM INSERTED;

IF( DATEDIFF(Day, @mCommentDate, getdate() ) > 0)
	BEGIN
		UPDATE users.UserReview
		SET CommentDate = GETDATE()
		WHERE UserID = @mUserID AND MovieID = @mMovieID 
	END

END


UPDATE users.UserReview
SET Comment = 'Fena değil...!'
WHERE MovieID = 2 AND UserID = 5



-----------------------------------------------------------


