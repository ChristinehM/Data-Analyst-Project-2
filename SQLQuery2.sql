/*
 [AdventureWorks2019] Data Exploration (online transaction processing database)

Skills used: Applying Criteria, Inequalities, Dates and Datetimes, Handling NULL Values, CASE, Joins, UNION,
Sorting Data, Matching Text Patterns With Wildcards
*/


SELECT A.[PurchaseOrderID]
      ,A.[PurchaseOrderDetailID]
      ,A.[OrderQty]
      ,A.[UnitPrice]
      ,A.[LineTotal]
	  ,B.[OrderDate]
	  ,[OrderSizeCategory] = 
		CASE
			WHEN A.[OrderQty] > 500 THEN 'Large'
			WHEN A.[OrderQty] > 50 THEN 'Medium'
			ELSE 'Small'
		END
	  ,[ProductName] = C.[Name]
	  ,[Subcategory] = ISNULL(D.[Name], 'None')
	  ,[Category] = ISNULL(E.[Name],'None')

FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] A
JOIN [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] B
	ON A.[PurchaseOrderID] = B.[PurchaseOrderID]
JOIN [AdventureWorks2019].[Production].[Product] C
	ON A.[ProductID] = C.[ProductID]
LEFT JOIN [AdventureWorks2019].[Production].[ProductSubcategory] D
	ON C.[ProductSubcategoryID] = d.[ProductSubcategoryID]
LEFT JOIN [AdventureWorks2019].[Production].[ProductCategory] E
	ON D.[ProductCategoryID] = E.[ProductCategoryID]

WHERE MONTH(B.[OrderDate]) = 12
--------------------------------------------------------------------------------------------------------------
SELECT 
	   [OrderType] = 'Sale'
	  ,[OrderID] = A.[SalesOrderID]
      ,[OrderDetailID] = A.[SalesOrderDetailID]
      ,A.[OrderQty]
      ,A.[UnitPrice]
      ,A.[LineTotal]
	  ,B.[OrderDate]
	  ,[OrderSizeCategory] = 
		CASE
			WHEN A.[OrderQty] > 500 THEN 'Large'
			WHEN A.[OrderQty] > 50 THEN 'Medium'
			ELSE 'Small'
		END
	  ,[ProductName] = C.[Name]
	  ,[Subcategory] = ISNULL(D.[Name], 'None')
	  ,[Category] = ISNULL(E.[Name],'None')

FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] A
JOIN [AdventureWorks2019].[Sales].[SalesOrderHeader] B
	ON A.[SalesOrderID] = B.[SalesOrderID]
JOIN [AdventureWorks2019].[Production].[Product] C
	ON A.[ProductID] = C.[ProductID]
LEFT JOIN [AdventureWorks2019].[Production].[ProductSubcategory] D
	ON C.[ProductSubcategoryID] = d.[ProductSubcategoryID]
LEFT JOIN [AdventureWorks2019].[Production].[ProductCategory] E
	ON D.[ProductCategoryID] = E.[ProductCategoryID]

WHERE MONTH(B.[OrderDate]) = 12

UNION ALL

SELECT 
	   [OrderType] = 'Purchase'
	  ,A.[PurchaseOrderID]
      ,A.[PurchaseOrderDetailID]
      ,A.[OrderQty]
      ,A.[UnitPrice]
      ,A.[LineTotal]
	  ,B.[OrderDate]
	  ,[OrderSizeCategory] = 
		CASE
			WHEN A.[OrderQty] > 500 THEN 'Large'
			WHEN A.[OrderQty] > 50 THEN 'Medium'
			ELSE 'Small'
		END
	  ,[ProductName] = C.[Name]
	  ,[Subcategory] = ISNULL(D.[Name], 'None')
	  ,[Category] = ISNULL(E.[Name],'None')

FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] A
JOIN [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] B
	ON A.[PurchaseOrderID] = B.[PurchaseOrderID]
JOIN [AdventureWorks2019].[Production].[Product] C
	ON A.[ProductID] = C.[ProductID]
LEFT JOIN [AdventureWorks2019].[Production].[ProductSubcategory] D
	ON C.[ProductSubcategoryID] = d.[ProductSubcategoryID]
LEFT JOIN [AdventureWorks2019].[Production].[ProductCategory] E
	ON D.[ProductCategoryID] = E.[ProductCategoryID]

WHERE MONTH(B.[OrderDate]) = 12

ORDER BY [OrderDate] DESC
-------------------------------------------------------------------------------------------------------
SELECT A.[BusinessEntityID]
      ,A.[PersonType]
	  ,[FullName] = 
			A.[FirstName] + ' ' +
			CASE WHEN A.[MiddleName] IS NULL THEN '' ELSE A.[MiddleName] + ' ' END +
			A.[LastName]
	  ,[Address] = C.[AddressLine1]
	  ,C.[City]
	  ,C.[PostalCode]
	  ,[State] = D.[Name]
	  ,[Country] = E.[Name]

FROM [AdventureWorks2019].[Person].[Person] A
JOIN [AdventureWorks2019].[Person].[BusinessEntityAddress] B
	ON A.[BusinessEntityID] = B.[BusinessEntityID]
JOIN [AdventureWorks2019].[Person].[Address] C
	ON B.[AddressID] = C.[AddressID]
JOIN [AdventureWorks2019].[Person].[StateProvince] D
	ON C.[StateProvinceID] = D.[StateProvinceID]
JOIN [AdventureWorks2019].[Person].[CountryRegion] E
	ON D.[CountryRegionCode] = E.[CountryRegionCode]

WHERE (LEFT(C.[PostalCode], 1) = '9' AND LEN(C.[PostalCode]) = 5 AND E.[Name] = 'United States')
	OR A.[PersonType] = 'SP'

---------------------------------------------------------------------------------------------------------
SELECT A.[BusinessEntityID]
      ,A.[PersonType]
	  ,[FullName] = 
			A.[FirstName] + ' ' +
			CASE WHEN A.[MiddleName] IS NULL THEN '' ELSE A.[MiddleName] + ' ' END +
			A.[LastName]
	  ,[Address] = C.[AddressLine1]
	  ,C.[City]
	  ,C.[PostalCode]
	  ,[State] = D.[Name]
	  ,[Country] = E.[Name]
	  ,[JobTitle] = ISNULL(F.[JobTitle],'NA')
	  ,[JobCategory] = 
		CASE
			WHEN F.[JobTitle] LIKE '%Manager%' OR F.[JobTitle] LIKE '%President%' OR F.[JobTitle] LIKE '%Executive%' THEN 'Management'
			WHEN F.[JobTitle] LIKE '%Engineer%' THEN 'Engineering'
			WHEN F.[JobTitle] LIKE '%Production%' THEN 'Production'
			WHEN F.[JobTitle] LIKE '%Marketing%' THEN 'Marketing'
			WHEN F.[JobTitle] IS NULL THEN 'NA'
			WHEN F.[JobTitle] IN('Recruiter', 'Benefits Specialist', 'Human Resources Administrative Assistant') THEN 'Human Resources'
			ELSE 'Other'
		END

FROM [AdventureWorks2019].[Person].[Person] A
JOIN [AdventureWorks2019].[Person].[BusinessEntityAddress] B
	ON A.[BusinessEntityID] = B.[BusinessEntityID]
JOIN [AdventureWorks2019].[Person].[Address] C
	ON B.[AddressID] = C.[AddressID]
JOIN [AdventureWorks2019].[Person].[StateProvince] D
	ON C.[StateProvinceID] = D.[StateProvinceID]
JOIN [AdventureWorks2019].[Person].[CountryRegion] E
	ON D.[CountryRegionCode] = E.[CountryRegionCode]
LEFT JOIN [AdventureWorks2019].[HumanResources].[Employee] F
	ON A.[BusinessEntityID] = F.[BusinessEntityID]

WHERE (LEFT(C.[PostalCode], 1) = '9' AND LEN(C.[PostalCode]) = 5 AND E.[Name] = 'United States')
	OR A.[PersonType] = 'SP'
-----------------------------Calculate number of days remaining until the end of the current month--------------------------------------
SELECT [Days Until EOM] = 
DATEDIFF(DAY, GETDATE(),
DATEADD(DAY, -1,
DATEADD(MONTH,1,
DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))))