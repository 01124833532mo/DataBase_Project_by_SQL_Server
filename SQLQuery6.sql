use Emploee_AND_departement
--////////////////////////////////////////// creation 
create table employee (
SSN int primary key identity(1,1),
BD date ,
gender varchar(1) not null,
firstname varchar(20) not null,
lastname varchar(20) not null,
Dnum int not null,
superid int not null,
salary int not null,
constraint c1 check(gender='f' or gender='m'),
)
create table departement (
Dtnum int primary key identity(1,1),
Dtname varchar(20) default 'cs',
SSN int not null,
hiredate date default getdate(),


)
create table locations(
Dtnum int,
loc varchar(20),
constraint c2 primary key(Dtnum,loc)
)
create table project(
Pnum int primary key identity(1,1),
Pname varchar(20) default 'information system' ,
city varchar(20),
Dtnum int 


)
create table Dependent(
SSN int,
Dname varchar(20) ,
gender varchar(1),
BD date,
constraint c3 primary key(SSN,Dname),
constraint c4 check(gender='f' or gender='m')


)

create table Work (
SSN int ,
Pnum int,
hourss int default 8,
constraint c5 primary key(SSN,pnum)

)
--################################################## insert data
--############################ emploee data
insert into employee 
values('f','donia','mohamed',1,1,5000)

insert into employee 
values(null,'f','donia','mohamed',1,1,5000)

insert into employee 
values('1/4/2004','f','aila','mohamed',2,1,5000)
insert into employee 
values('5/4/2004','m','ali','ahmed',2,2,400)
insert into employee 
values('15/4/2004','m','mahmoud','ali',2,3,5050)
insert into employee 
values('1/4/2004','f','mona','mohamed',2,3,700)
insert into employee 
values('1/4/2004','f','aila','mohamed',3,1,5000)
insert into employee 
values('1/4/2004','f','yara','mohamed',4,3,7000)
insert into employee 
values('1/4/2004','m','ali','mohamed',4,2,5000)

--####################################### data in departement

insert into departement
values('is',null,getdate())
insert into departement
values('AI',null,getdate())
insert into departement
values('FULL-STACK',null,getdate())


--####################################### data in location
insert into locations
values(1,'cairo')
insert into locations
values(2,'cairo')
insert into locations
values(2,'alex')
insert into locations
values(3,'fayoum')
insert into locations
values(4,'aswan')
--####################################### data in project
insert into project
values('Bansk system','cairo',1)
insert into project(city,Dtnum)
values('cairo',2)
insert into project
values('Hospital system','fayoum',3)
insert into project
values('school system','aswan',4)
--####################################### data in dependant
insert into Dependent
values(2,'AI','m','1/2/2003')

insert into Dependent
values(1,'FULL-STACK','m','1/2/2003')

insert into Dependent
values(3,'cs','m','1/2/2003')
--####################################### data in work
insert into Work
values(1,1,8)
insert into Work
values(2,2,9)
insert into Work
values(3,1,8)
insert into Work
values(3,3,17)

insert into Work
values(4,4,17)

insert into Work
values(5,4,15)
--################################################ impementation

--################################################ join

select concat(firstname,' ',lastname) as 'full name',Dtname,pname
from employee , departement,project
where departement.Dtnum=employee.Dtnum and departement.Dtnum=project.Dtnum

--################################################ aggregation function 

select count(SSN) ,Dtnum  from employee 
group by Dtnum
having count(SSN)>2

select count(SSN) from employee
having count(SSN)>5

--################################################ \top function 
select top(3) with ties *
from
employee
order by salary desc
--################################################ \ranking function 
select * from(
select *,ROW_NUMBER()
over(order by salary desc) as rn
,DENSE_RANK() over(order by salary desc)as dr
from employee

) as newtable
where dr=2

select * from(
select *,ROW_NUMBER()
over(order by salary desc) as rn
,DENSE_RANK() over(order by salary desc)as dr
from employee

) as newtable
where rn=2

select * from(
select *,ROW_NUMBER()
over(partition by Dtnum
order by salary desc) as rn
,DENSE_RANK() over(order by salary desc)as dr
from employee

) as newtable
where rn=2
--################################################ varibles 
declare @x int
select @x=Dtnum from employee
where SSN=1

select @x

declare @t table (x int)
insert into @t
select SSN from employee 

select count(*)from @t

begin try
delete from employee 
where SSN=1
end try
begin catch
select 'error'

end catch
delete from locations 
where Dtnum=1
--################################################ functions
--################################################ scalar function 
create function getdep(@num int)
returns varchar(20)
begin
declare @name varchar(20)
select @name=firstname from employee
where SSN=@num
return @name
end

select dbo.getdep(1)
--################################################ multistatment function 

create function getdept(@num int)
returns @t table
(nameperson varchar(20),
namedepartment varchar(20))

as 
begin
insert into @t 
select firstname,Dtname
 from
employee inner join departement
on departement.Dtnum=employee.Dtnum 

return

end
select * from getdept(1)
--################################################ view function 

create view vcairo 

as 
select firstname from
employee

select * from vcairo
--################################################ stored procedures function 
 create proc getname @id int
 as
 select firstname from employee
 where SSN=@id
 getname 4


 create proc insertt @id int ,@supeer int,@sal int
 as
 if not exists(select SSN from employee where SSN=@id)
 insert into employee(SSN,superid,salary)
 values(@id,@supeer,@sal)
 else
 select 'dublicate id'

 insertt 11 ,1 ,5000

 --################################################ trigger function 
 create trigger t1 
 on employee 
 after insert
 as
 select *from employee

 alter table employee disable trigger t1

  --################################################ convert table to xml\

  select * from employee
  for xml raw('emploee'),elements,root('campany')
    --################################################ cursor
declare c1 cursor 
for select SSN ,firstname
from employee
for read only
declare @id int ,@name varchar(20)
open c1 
fetch c1 into @id,@name
while @@FETCH_STATUS=0
begin
select @id,@name
fetch c1 into @id,@name

end

close c1
deallocate

