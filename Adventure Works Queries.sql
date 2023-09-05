-- All employees pay rate
SELECT 
	p.FirstName,
	p.LastName,
	hr.JobTitle,
	ep.Rate
FROM Person.Person p
LEFT JOIN HumanResources.Employee hr
ON p.BusinessEntityID = hr.BusinessEntityID
LEFT JOIN HumanResources.EmployeePayHistory ep
ON p.BusinessEntityID = ep.BusinessEntityID
ORDER BY ep.Rate DESC;

-- Sales person w/ bonus of 3000 or above
SELECT p.FirstName, p.LastName, s.Bonus
FROM Person.Person p
LEFT JOIN Sales.SalesPerson s
ON s.BusinessEntityID = p.BusinessEntityID
WHERE s.Bonus >= 3000
ORDER BY s.Bonus DESC;

-- SELECT EMPLOYEE WHO DONT HAVE ORDERS WITH 'Riders Company
SELECT FirstName
FROM Person.Person
WHERE FirstName NOT IN (
	SELECT p.FirstName
	FROM Person.Person p
	JOIN Sales.Store v
	ON p.BusinessEntityID = v.SalesPersonID
	WHERE v.name = 'Riders Company'
	)
;

-- SHOW ALL SALES PEOPLE AND THEIR ORDER COUNTS
SELECT p.FirstName,
	   COUNT(v.name) AS OrderCount
FROM Person.Person p
LEFT JOIN Sales.Store v
ON p.BusinessEntityID = v.SalesPersonID
WHERE p.PersonType = 'SP'
GROUP BY p.FirstName
ORDER BY OrderCount DESC;

-- Show employee information and their tenure in Years
SELECT 
p.FirstName,
p.LastName,
hre.JobTitle,
hrd.StartDate,
hrd.EndDate,
CASE
	WHEN hrd.EndDate IS NULL THEN DATEDIFF(YEAR, hrd.StartDate, GETDATE())
	ELSE DATEDIFF(YEAR, hrd.StartDate, hrd.EndDate)
END AS 'Tenure(Years)'
FROM Person.Person p 
JOIN HumanResources.EmployeeDepartmentHistory hrd
ON p.BusinessEntityID = hrd.BusinessEntityID
JOIN HumanResources.Employee hre
ON hrd.BusinessEntityID = hre.BusinessEntityID;
