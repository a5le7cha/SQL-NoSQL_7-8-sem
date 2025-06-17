--table 2
BEGIN TRANSACTION;
UPDATE Child SET height = height + 10 WHERE Id = 1;
COMMIT;

SELECT * FROM Child

SELECT [weight] FROM Child WHERE Id = 2;


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT [adress] FROM Child WHERE Id = 3;


BEGIN TRANSACTION;
UPDATE Child SET weight = 25 WHERE Id = 1;
COMMIT;


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRANSACTION;
UPDATE Child SET height = 110 WHERE Id = 2;
COMMIT;

BEGIN TRANSACTION;
INSERT INTO Child (Id, FIO, [height], [weight], [date birth], [adress], [Id Group], IdParent1, IdParent2) 
VALUES (20, 'Егоров Дмитрий Игоревич', 112.3, 21.0, '2018-07-22', 'ул. Садовая, 17', 1, null, null);
COMMIT;



SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


INSERT INTO Child (Id, FIO, [height], [weight], [date birth], [adress], [Id Group], IdParent1, IdParent2) 
VALUES (6, 'Сержантова Елена Сергеевна', 115, 21.2, '2018-09-14', 'ул. Центральная, 5', 2, null, null);
