--FUNCTION
--F1

CREATE FUNCTION actorvsactor(@name1 varchar(200),@surname1 varchar(200),@name2 varchar(200),@surname2 varchar(200))
RETURNS varchar(200)
AS
BEGIN
DECLARE @result varchar(200)
DECLARE @isExist int
DECLARE @id1 int
DECLARE @id2 int
DECLARE @num1 int
DECLARE @num2 int

SET @isExist = (SELECT COUNT(*) FROM person.Person WHERE Name= @name1 AND Surname=@surname1)

IF(@isExist =0)
	BEGIN
	SET @result= @name1+' does not exist'
	return @result
	END

SET @isExist = (SELECT COUNT(*) FROM person.Person WHERE Name= @name2 AND Surname=@surname2)

IF(@isExist =0)
	BEGIN
	SET @result= @name2+' does not exist'
	return @result
	END

SET @id1 = (SELECT ID FROM person.Person WHERE Name=@name1 AND Surname=@surname1)
SET @id2 = (SELECT ID FROM person.Person WHERE Name=@name2 AND Surname=@surname2)
SET @num1 = (SELECT COUNT(*) FROM person.PersonWorkingOnMovie WHERE PersonID=@id1)
SET @num2 = (SELECT COUNT(*) FROM person.PersonWorkingOnMovie WHERE PersonID=@id2)

IF(@num1>@num2)
	SET @result=@name1 +' '+ @surname1 + ' has acted in more movies than ' + @name1 +' '+ @surname1
IF(@num1<@num2)
	SET @result=@name2 +' '+@surname2 + ' has acted in more movies than ' + @name1 +' '+ @surname1
IF(@num1=@num2)
	SET @result=@name1 + ' ' +@surname1 + ' has acted in equal amount of movies as ' + @name2 + ' ' +@surname2

return @result
end

select dbo.actorvsactor('Heath','Ledger','Brad','Pitt')

--F2



CREATE FUNCTION ProducerCompareByMovieBudget(
@firstProducerName varchar(200),@secondProducerName varchar(200))
RETURNS varchar(200)

AS
BEGIN
DECLARE @result varchar(200)
DECLARE @isExist int
DECLARE @firstBudget int
DECLARE @secondBudget int

SET @isExist = (SELECT COUNT(*) FROM person.Producer AS PR WHERE PR.Name = @firstProducerName) 
IF(@isExist =0)
	BEGIN
	SET @result= @firstProducerName+' does not exist'
	return @result
	END


SET @isExist = (SELECT COUNT(*) FROM person.Producer AS PR WHERE PR.Name = @secondProducerName) 
IF(@isExist =0)
	BEGIN
	SET @result= @secondProducerName+' does not exist'
	return @result
	END

SET @firstBudget =( SELECT SUM(M.Budget) FROM person.Producer AS PR
INNER JOIN person.Producer_Movie AS PM
ON PM.ProducerID = PR.ID
INNER JOIN movie.Movie AS M
ON PM.MovieID = M.ID
WHERE PR.Name = @firstProducerName)


SET @secondBudget =( SELECT SUM(M.Budget) FROM person.Producer AS PR
INNER JOIN person.Producer_Movie AS PM
ON PM.ProducerID = PR.ID
INNER JOIN movie.Movie AS M
ON PM.MovieID = M.ID
WHERE PR.Name = @secondProducerName)


IF(@firstBudget > @secondBudget)
	SET @result = @firstProducerName +' has more spend money on movies than '+@secondProducerName
ELSE IF (@firstBudget = @secondBudget)
	SET @result = @firstProducerName +' and '+@secondProducerName +' has equaly spend money on movies'
ELSE
	SET @result = @secondProducerName +' has more spend money on movies than '+@firstProducerName


RETURN @result

END


select.dbo.ProducerCompareByMovieBudget('Warner Bros.','Universal Pictures')
