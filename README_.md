# Retail Sales & Product Performance Dashboard

**Power BI · DAX · SQL · Power Query · Data Modelling · Data Validation**

An interactive business intelligence project analysing a fictional consumer-goods retailer's sales across Poland in 2024–2025. Built as a personal analytics-engineering portfolio project to practise the process from source data to decision-ready reporting.

> **Data disclosure:** All transactions, products, and stores are synthetic. This project is not affiliated with or based on confidential information from P&G or any other company.

## Dashboard preview

![Retail sales dashboard](dashboard.png)

The dashboard shows total revenue, gross profit, profit margin, monthly sales trends, product-category revenue, and a dropdown filter by region. Changing the region updates all measures and charts.

## Key metrics (all regions)

| KPI | Result | Meaning |
|---|---:|---|
| Transactions | 5,350 | Rows in the synthetic sales fact table |
| Total Revenue | 111,191.05 | Sales after discounts |
| Total Profit | 57,977.80 | Revenue less product acquisition costs (gross profit, excluding operating expenses) |
| Profit Margin | 52.14% | Total Profit / Total Revenue |

**Product categories ranked by revenue**

| Product category | Revenue |
|---|---:|
| Personal Care | 32,590.55 |
| Home Care | 30,145.85 |
| Laundry Care | 26,066.51 |
| Baby Care | 22,388.14 |

All amounts are simulated monetary values; the dashboard uses abbreviated K labels. Values were reconciled against SQL queries in the supplied database.

## Data model

![Star-schema relationships](data_model.png)

The semantic model has three tables:

- **FactSales:** 5,350 transactions, with SaleID, OrderDate, ProductID, StoreID, Units, UnitPrice, and DiscountPct.
- **DimProducts:** 20 products with category, name, unit cost, and base price.
- **DimStores:** 12 stores with region and sales channel.

**Relationships:** `DimProducts[ProductID]` → `FactSales[ProductID]` and `DimStores[StoreID]` → `FactSales[StoreID]`, both active one-to-many (1:*) with single-direction filtering.

In Power Query, I imported the Excel source, selected the three tables, promoted the first row to headers where needed, and converted `FactSales[OrderDate]` from an Excel serial number to a date.

## Business calculations

Three implemented DAX measures are documented in [`measures_used.dax`](measures_used.dax):

- **Total Revenue:** sum of units × price after discount.
- **Total Profit:** revenue less product cost, using `RELATED()` across the model relationship.
- **Profit Margin:** `DIVIDE([Total Profit], [Total Revenue], 0)`, formatted as percentage.

SQL scripts cover monthly sales, category ranking, regional and channel comparisons, and data quality checks for duplicates, unmatched IDs, and invalid values.

## Repository structure

The GitHub repository currently stores these files at its root:

```text
.
├── README.md
├── Retail Sales & Product Performance Dashboard.pbix
├── dashboard.png
├── data_model.png
├── DimProducts.csv
├── DimStores.csv
├── FactSales.csv
├── Retail_Sales_PowerBI_Import.xlsx
├── measures_used.dax
├── 01_schema.sql
├── 02_analysis_queries.sql
├── 03_data_quality_checks.sql
├── retail_sales.db
└── load_sqlite.py
```

You can also [download the Power BI report](Retail%20Sales%20%26%20Product%20Performance%20Dashboard.pbix) from this repository. It was exported from Power BI Service; depending on your environment and account access, reopening it may require reconnecting its semantic model.

## Reproducing the project

**SQL (macOS, Linux, or Windows)**

1. Open the project folder in Terminal.
2. Run `sqlite3 retail_sales.db` to open the included SQLite database.
3. Run `.read 02_analysis_queries.sql` to explore results.
4. Run `.read 03_data_quality_checks.sql` to check data quality.

You can regenerate the database from the CSV files with `python3 load_sqlite.py` (Python standard library only).

**Power BI**

1. Open Power BI Service in a work/school account at https://app.powerbi.com/ (or use Desktop on Windows).
2. Import `Retail_Sales_PowerBI_Import.xlsx`, selecting the three named tables, not duplicate worksheet selections.
3. In Power Query, verify header names, IDs and numeric column types, and set `OrderDate` to **Date**.
4. Create a semantic model and the two one-to-many relationships specified above.
5. Create the three measures from `measures_used.dax` as separate DAX measures.
6. In a report, add three KPI cards, monthly Total Revenue line chart, horizontal category revenue bar chart, and a Region slicer.
7. Compare report totals with SQL results, then test region filtering.

**Note:** This project was built in **Power BI Service on macOS**, and its exported `.pbix` report is included above. The Excel source data, SQL scripts, DAX formulas and setup instructions are also included to reproduce the semantic model if needed.

## Portfolio highlights

- Structured a transaction fact table and two dimensions with one-to-many relationships.
- Used Power Query for header promotion and date-type transformation.
- Authored DAX measures using `SUMX()`, `RELATED()`, and `DIVIDE()`.
- Validated results against SQL aggregations and created a region-filtered interactive report.

## Future improvements

Possible extensions include a dedicated calendar table, year-over-year growth, region/channel performance visuals, and versioned team collaboration through Git branches and pull requests. These are **future ideas**, not claims about features already implemented.
