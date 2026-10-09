-- Synthetic consumer-goods sales data. SQLite-compatible SQL.
PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS DimProducts (
  ProductID TEXT PRIMARY KEY,
  ProductName TEXT NOT NULL,
  Category TEXT NOT NULL,
  UnitCost REAL NOT NULL CHECK(UnitCost >= 0),
  BasePrice REAL NOT NULL CHECK(BasePrice > 0)
);
CREATE TABLE IF NOT EXISTS DimStores (
  StoreID TEXT PRIMARY KEY,
  StoreName TEXT NOT NULL,
  Region TEXT NOT NULL,
  Channel TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS FactSales (
  SaleID TEXT PRIMARY KEY,
  OrderDate TEXT NOT NULL, -- ISO YYYY-MM-DD
  ProductID TEXT NOT NULL REFERENCES DimProducts(ProductID),
  StoreID TEXT NOT NULL REFERENCES DimStores(StoreID),
  Units INTEGER NOT NULL CHECK(Units > 0),
  UnitPrice REAL NOT NULL CHECK(UnitPrice > 0),
  DiscountPct REAL NOT NULL CHECK(DiscountPct BETWEEN 0 AND 1)
);
CREATE INDEX IF NOT EXISTS IX_FactSales_Date ON FactSales(OrderDate);
CREATE INDEX IF NOT EXISTS IX_FactSales_Product ON FactSales(ProductID);
CREATE INDEX IF NOT EXISTS IX_FactSales_Store ON FactSales(StoreID);
