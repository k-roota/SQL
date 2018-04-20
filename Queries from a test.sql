select *
from Orders o2
where exists(
	select od.OrderID
	from Orders o
	join Customers c on c.CustomerID = o.CustomerID
	join [Order Details] od on od.OrderID = o.OrderID
	where c.Country = 'Canada' and o.OrderID = o2.OrderID
	group by od.OrderID
	having sum(od.Quantity) < 50)

select e.LastName
from Employees e
where not exists(
	select *
	from Orders o
	where o.EmployeeID = e.EmployeeID and o.ShipCountry = 'Poland')
and exists(
	select *
	from Orders o
	join [Order Details] od on od.OrderID = o.OrderID
	join Products p on p.ProductID = od.ProductID
	where p.ProductName like '%p' and o.EmployeeID = e.EmployeeID)
order by e.LastName

select top 2 e.FirstName, e.LastName
from Employees e
join Orders o on o.EmployeeID = e.EmployeeID
group by o.EmployeeID, e.FirstName, e.LastName, e.HireDate
having sum(
	case
		when year(o.OrderDate) = 1996 and month(o.OrderDate) = 12
		then 1
		else 0
	end) > sum(
	case
		when year(o.OrderDate) = 1997 and month(o.OrderDate) = 12
		then 1
		else 0
	end)
order by e.HireDate desc

select e.FirstName, e.LastName
from Employees e
where exists(
	select *
	from Orders o
	join [Order Details] od on od.OrderID = o.OrderID
	where o.EmployeeID = e.EmployeeID and od.ProductID = (
		select p.ProductID
		from Products p
		where p.ProductName = 'Chocolade')
	and od.Quantity > 1.1 * (
		select avg(od2.Quantity)
		from [Order Details] od2
		where od2.ProductID = (
			select p.ProductID
			from Products p
			where p.ProductName = 'Chocolade')))

select count(*) as OrdersCount
from(
	select od.OrderID
	from Orders o
	join Customers c on c.CustomerID = o.CustomerID
	join [Order Details] od on od.OrderID = o.OrderID
	where c.Country = 'Germany'
	group by od.OrderID
	having count(od.ProductID) >= 3) GermanOrders