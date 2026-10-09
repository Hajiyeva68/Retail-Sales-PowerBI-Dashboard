-- Run after loading data in retail_sales.db; SQLite syntax.
-- 1. Monthly net revenue and gross profit
SELECT substr(f.OrderDate, 1, 7) AS YearMonth,
       ROUND(SUM(f.Units * f.UnitPrice * (1 - f.DiscountPct)), 2) AS NetSales,
       ROUND(SUM(f.Units * (f.UnitPrice * (1 - f.DiscountPct) - p.UnitCost)), 2) AS GrossProfit
FROM FactSales f JOIN DimProducts p ON p.ProductID = f.ProductID
GROUP BY substr(f.OrderDate, 1, 7)
ORDER BY YearMonth;

-- 2. Product categories ranked by revenue
SELECT p.Category,
       SUM(f.Units) AS UnitsSold,
       ROUND(SUM(f.Units * f.UnitPrice * (1 - f.DiscountPct)), 2) AS NetSales
FROM FactSales f JOIN DimProducts p ON p.ProductID = f.ProductID
GROUP BY p.Category
ORDER BY NetSales DESC;

-- 3. Revenue by channel and region
SELECT s.Channel, s.Region,
       ROUND(SUM(f.Units * f.UnitPrice * (1 - f.DiscountPct)), 2) AS NetSales
FROM FactSales f JOIN DimStores s ON s.StoreID = f.StoreID
GROUP BY s.Channel, s.Region
ORDER BY NetSales DESC;

-- 4. Year-on-year growth
WITH annual AS (
 SELECT substr(OrderDate,1,4) AS Yr,
        SUM(Units * UnitPrice * (1 - DiscountPct)) AS Revenue
 FROM FactSales GROUP BY substr(OrderDate,1,4)
)
SELECT current.Yr, ROUND(current.Revenue, 2) AS NetSales,
       ROUND(prior.Revenue,2) AS PreviousYearSales,
       ROUND(100.0 * (current.Revenue-prior.Revenue)/NULLIF(prior.Revenue,0),2) AS GrowthPct
FROM annual current LEFT JOIN annual prior
ON CAST(prior.Yr AS INTEGER) = CAST(current.Yr AS INTEGER)-1
ORDER BY current.Yr;
