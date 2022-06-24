use Northwind

--Question 1
create view view_product_order_thompson
as
select p.ProductName,
(
select sum(od.Quantity) from
"Order Details" od where od.ProductID = p.ProductID
) as QuantityOrdered
from Products p

--Question 2
create proc sp_product_order_quantity_thompson
@product_id int,
@total_quantity_ordered int out
as
begin
select @total_quantity_ordered = sum(od.Quantity) from "Order Details" od where od.ProductID = @product_id
end

--Question 3
create proc sp_product_order_city_thompson
@product_name varchar(40)
as
begin
select top 5 c.City, sum(od.Quantity) as TotalQuantityOrdered
from "Order Details" od inner join Orders o on od.OrderID = o.OrderID inner join Customers c on o.CustomerID = c.CustomerID
inner join Products p on od.ProductID = p.ProductID
where p.ProductName = @product_name
group by c.City
order by TotalQuantityOrdered desc
end

--Question 4
create table city_thompson (
Id int identity primary key,
City varchar(20)
)

create table people_thompson (
Id int identity primary key,
Name varchar(20),
City int foreign key references city_thompson(Id) on delete set null
)

insert into city_thompson values
('Seattle'),
('Green Bay')

insert into people_thompson values
('Aaron Rodgers', 2),
('Russel Wilson', 1),
('Jody Nelson', 2)

delete from city_thompson where City = 'Seattle'
insert into city_thompson values ('Madison')
update people_thompson
set City = 3 where City is null

create view Packers_thompson
as
select Name from people_thompson
where City = (select id from city_thompson where City = 'Green Bay')

drop table people_thompson
drop table city_thompson
drop view Packers_thompson

--Question 5
create proc sp_birthday_employees_thompson
as
begin
create table #birthday_employees_thompson(
Id int primary key foreign key references Employees(EmployeeID),
Name varchar(20),
Birthday date
)
insert into #birthday_employees_thompson
select EmployeeID, FirstName + ' ' + LastName as FullName, BirthDate
from Employees where month(Birthdate) = 2
select * from #birthday_employees_thompson
drop table #birthday_employees_thompson
end

--Question 6
/*
You can make sure two tables contain the same data by using Foreign Key restraints. When creating tables, declare column values using foreign key
constraints if you want to ensure they contain the same data as a different table. This referential constraint will prevent any rows from being added
to the table with a foreign key constraint unless an identical value can be found in the table it is referencing.

You can use other kinds of constraints when declaring tables to ensure the values inputted follow certain rules which is important if you want data types
in one table to match data types in another table.
*/
