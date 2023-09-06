-- RETURN ALL EMPLOYEES, PAY RATE, & TITLE
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

-- RETURN SALES PEOPLE WITH BONUSES OF $3000 OR HIGHER
SELECT p.FirstName, p.LastName, s.Bonus
FROM Person.Person p
LEFT JOIN Sales.SalesPerson s
ON s.BusinessEntityID = p.BusinessEntityID
WHERE s.Bonus >= 3000
ORDER BY s.Bonus DESC;

-- SELECT EMPLOYEE WHO DONT HAVE ORDERS WITH 'Riders Company'
SELECT FirstName
FROM Person.Person
WHERE FirstName NOT IN (SELECT p.FirstName
					FROM Person.Person p
					INNER JOIN Sales.Store v
					ON p.BusinessEntityID = v.SalesPersonID
					WHERE v.name = 'Riders Company')
;

-- RETURN ALL SALES PEOPLE AND THEIR ORDER COUNTS
SELECT p.FirstName,
	   COUNT(v.name) AS OrderCount
FROM Person.Person p
LEFT JOIN Sales.Store v
ON p.BusinessEntityID = v.SalesPersonID
WHERE p.PersonType = 'SP'
GROUP BY p.FirstName
ORDER BY OrderCount DESC;

-- RETURN ALL EMPLOYEES AND THEIR TENURE IN YEARS
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
INNER JOIN HumanResources.EmployeeDepartmentHistory hrd
ON p.BusinessEntityID = hrd.BusinessEntityID
INNER JOIN HumanResources.Employee hre
ON hrd.BusinessEntityID = hre.BusinessEntityID;

-- RETURN AVERAGE EMPLOYEE RETENTION FOR EACH POSITION
SELECT 
hre.JobTitle,
AVG(CASE
	WHEN hrd.EndDate IS NULL THEN DATEDIFF(YEAR, hrd.StartDate, GETDATE())
	ELSE DATEDIFF(YEAR, hrd.StartDate, hrd.EndDate)
END) AS 'AVG Retention(Years)'
FROM HumanResources.EmployeeDepartmentHistory hrd
INNER JOIN HumanResources.Employee hre
ON hrd.BusinessEntityID = hre.BusinessEntityID
GROUP BY hre.JobTitle
ORDER BY 'AVG Retention(Years)' DESC;

-- RETURN ALL VENDORS AND THEIR TOTAL SPENT
SELECT
    v.BusinessEntityID AS VendorID,
    v.Name AS VendorName,
    ROUND(SUM(poh.TotalDue), 2) AS TotalPurchaseAmount
FROM Purchasing.Vendor v
INNER JOIN Purchasing.PurchaseOrderHeader poh
ON v.BusinessEntityID = POH.VendorID
GROUP BY v.BusinessEntityID, v.Name
ORDER BY TotalPurchaseAmount DESC;
