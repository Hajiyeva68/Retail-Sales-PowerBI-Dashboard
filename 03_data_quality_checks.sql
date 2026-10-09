-- These checks should each return 0 problematic rows.
SELECT COUNT(*) AS DuplicateSalesIDs FROM (
  SELECT SaleID FROM FactSales GROUP BY SaleID HAVING COUNT(*) > 1
);
SELECT COUNT(*) AS MissingProductReferences FROM FactSales f
LEFT JOIN DimProducts p ON f.ProductID=p.ProductID WHERE p.ProductID IS NULL;
SELECT COUNT(*) AS MissingStoreReferences FROM FactSales f
LEFT JOIN DimStores s ON f.StoreID=s.StoreID WHERE s.StoreID IS NULL;
SELECT COUNT(*) AS InvalidValues FROM FactSales
WHERE Units <= 0 OR UnitPrice <= 0 OR DiscountPct < 0 OR DiscountPct > 1
   OR OrderDate IS NULL;
SELECT COUNT(*) AS NegativeMarginRows FROM FactSales f
JOIN DimProducts p ON f.ProductID=p.ProductID
WHERE f.UnitPrice * (1 - f.DiscountPct) < p.UnitCost;
