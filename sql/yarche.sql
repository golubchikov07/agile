create database Yarche
use Yarche

CREATE TABLE manager
(
    id_manager int Identity NOT NULL,
    Fname nvarchar(10) NOT NULL,
	Lname nvarchar(15) NOT NULL,
	Phone char(12),
	Email varchar(15) NOT NULL
);

alter table manager
alter column Phone char(15)

alter table manager
alter column Email char(25)

alter table manager
add constraint CK_manager_phone
Check (phone LIKE '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')

/*alter table manager
nocheck constraint CK_manager_phone*/


Insert into manager Values
('Artem','Golubchikov','(923) 749-19-50','Golubchikov@mail.ru'),
('Dima','Lapenko','(023) 346-35-62','Lapenko@mail.ru'),
('Lida','Sidorov','(456) 574-46-20','Sidorov@mail.ru'),
('Evgeniy','Semenov','(254) 436-57-35','Semenov@mail.ru'),
('Vasiliy','Pyatkov','(231) 124-46-35','Pyatkov@mail.ru'),
('Katya','Kishyk','(421) 234-46-53','Kishyk@mail.ru')

select * from manager

truncate table manager

IF OBJECT_ID('sale') IS NOT NULL
  DROP TABLE sale;
GO

create table sale 
(
	id_sale int Identity(1,1) not null,
	id_manager int not null,
	saledate datetime 
)
-- поставить не нул в datetime
/*alter table sale
add constraint CK_sale_saledate default getdate() for saledate

truncate table sale*/

insert into sale values
(1,'2020-03-01 00:00:00'),(2,'2020-03-02 00:00:00' ),(2,'2020-03-03 00:00:00' ),(3,'2020-02-01 00:00:00' ),(4,'2020-02-02 00:00:00'),(5,'2020-02-03 00:00:00'),
(6,'2020-02-03 00:00:00' ),(1,'2020-03-02 00:00:00' ),(2,'2020-03-02 00:00:00' ),(3,'2020-02-03 00:00:00'),(5,'2020-03-03 00:00:00'),
(6,'2020-02-03 00:00:00' ),(1,'2020-02-02 00:00:00' ),(1,'2020-02-03 00:00:00' )
-- yyddmm

select * from sale

create table saleitem 
(
	id_saleitem int not null,
	id_wares int not null,
	quantity int not null
)
--Для атрибутов quantity, orderprice, day, warescount допустимы только положительные значения отличные от нуля.
insert into saleitem values 
(1,1,3),(2,2,2),(3,3,1),(4,4,4),(5,5,5),(6,6,3),(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,6),(6,3,3),(1,3,3),(2,1,3)

--truncate table saleitem

select * from saleitem

create table wares
(
	id_wares int identity(1,1) not null,
	[name] nvarchar(50) NOT NULL,
	[description] nvarchar(100) NOT NULL,
	orderprice int NOT NULL,
	saleprice  AS ([orderprice]*(1.3)),
	id_discount int NOT NULL
)

--truncate table wares 

insert  wares
([name],[description],orderprice,id_discount)
values 
('chernogolovka','water',10,10),
('chedder','cheese',100,1),
('kandi','tea',25,15),
('napoleon','cake',245,12),
('lilpeep','gingerbread',200,13),
('russkiy','bread',23,14)

select * from wares

create table discount 
(
	id_discount int IDENTITY(1,1) NOT NULL,
	[percent] int NOT NULL --уровень скидки
)

insert into discount values
(1),(2),(3),(4)

select * from discount

create table [period]
(
	id_provider int NOT NULL,
	Idwares int NOT NULL,
	[day] int NOT NULL,
)

insert into [period] values
(1,1,1),(2,1,2),(3,1,3),(4,2,4),(1,3,4),(2,3,3),(3,1,2),(4,3,1),(1,1,4),(2,5,3),(3,1,2),
(4,5,1),(1,6,1),(2,1,7),(3,6,6),(4,1,3),(1,4,6),(1,1,5),(2,4,1),(1,4,2),(4,3,3),(1,1,1)
--изменить данные , так как встречаются дубли 1-1 на за разные дни
select * from [period]
go

-- создание хранимой процедру на добавление менеджера
create PROCEDURE [dbo].[spr_addmanager]
	@id_manager int OUT, 
	@Fname nvarchar(30),
	@Lname nvarchar(30),
	@Phone nvarchar(16)
  
AS
IF EXISTS(SELECT * FROM manager WHERE Phone=@Phone)
  RETURN -100

INSERT manager(Fname,Lname,Phone)
VALUES (@Fname,@Lname, @Phone)
SET @id_manager = @@IDENTITY
RETURN 0
go

--вызов процедуры
DECLARE	@return_value int, 
@id_manager int 
EXEC @return_value = spr_addmanager
  @Fname='Vika',
  @Lname='Lesli',
  @Phone= '(923) 234-21-23',
@id_manager = @id_manager OUTPUT
IF @return_value = 0
  BEGIN
    PRINT 'Менеджер успешно добавлен'
SELECT @id_manager as 'Номер менеджера'
  END
ELSE
  BEGIN
    PRINT 'При добавлении произошла ошибка' 
END
go
-- создание процедуры на удаление менеджера
Create procedure [dbo].[spr_delmanager]
  @id_manager int
AS
	if not exists (select * from manager where id_manager=@id_manager)
	return -100
delete from manager
where id_manager=@id_manager
RETURN 0
go
-- вызов процедуры
DECLARE	@return int
EXEC @return = spr_delmanager
 @id_manager=13
IF @return = 0
  BEGIN
    PRINT 'Менеджер успешно удален'
  END
ELSE
  BEGIN
    PRINT 'Во время удаления произошла ошибка'
  END
  go
  --select * from manager

  --создание процедуры на поиск продаж между датами
create procedure [dbo].[spr_salesearch]
@date1 datetime, 
@date2 datetime
AS
SELECT w.[name], w.[description], s.saledate
FROM wares w, sale s,saleitem si
where s.id_sale=si.id_saleitem and si.id_wares=w.id_wares and saledate BETWEEN @date1 AND @date2
RETURN
go

-- вызов процедуры
EXEC spr_salesearch
@date1 = '2020-01-03',
@date2 = '2020-03-03'
go

--функция на высчет выручки за этот промежуток времени
Create FUNCTION [dbo].[sum] (@date1 smalldatetime, @date2 smalldatetime)
RETURNS TABLE
AS
return
 (
select sum(w.saleprice-(w.saleprice*(d.[percent]*0.01))-w.orderprice)as 'сумма'
from  wares w inner join
discount d on w.id_discount=d.id_discount inner join
saleitem si on w.id_wares=si.id_wares inner join
sale s on si.id_saleitem=s.id_sale
where  (s.saledate >= @date1) and (s.saledate <= @date2)
)
go

--вызов функции
select *
from dbo.[sum] ('2020-02-02', '2020-03-03')
go
-- создание функции на поиск лучшего сотрудника
create FUNCTION [dbo].[bestmanager]() 
returns table
as
return( 
select m.[Fname],m.Lname, count(s.id_sale) 'Продажи' 
from  manager m inner join sale s 
on m.id_manager=s.id_manager
group by m.[Fname],m.Lname
)
go

--вызов функции
select *
from dbo.bestmanager()
order by 'Продажи' desc
go

-- создание тригерра
CREATE TABLE History 
(
    Id INT IDENTITY PRIMARY KEY,
    Idmanager INT NOT NULL,
    Operation NVARCHAR(200) NOT NULL,
    CreateAt DATETIME NOT NULL DEFAULT GETDATE(),
);
go

/*Drop trigger manager_Insert
go */

CREATE TRIGGER manager_INSERT
ON manager
AFTER INSERT
AS
INSERT INTO History (Idmanager, Operation)
SELECT id_manager, 'Добавлен менеджер ' + Fname + ' '  + Lname + ' ' + Phone + ' ' + Email 
FROM INSERTED

-- добавляем менеджера
INSERT INTO  manager (FName, Lname, Phone, Email)
VALUES('Lil', 'Peep','(000) 000-00-00', 'Peep@mail.ru')

SELECT * FROM History
select * from manager












