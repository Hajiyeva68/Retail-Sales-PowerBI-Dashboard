#!/usr/bin/env python3
"""Build the SQLite database from CSV files. No extra Python packages needed."""
import csv, sqlite3
from pathlib import Path
root=Path(__file__).resolve().parent
con=sqlite3.connect(root/'retail_sales.db')
con.executescript((root/'sql/01_schema.sql').read_text(encoding='utf-8'))
for table in ('DimProducts','DimStores','FactSales'):
    with (root/'data'/f'{table}.csv').open(newline='',encoding='utf-8') as f:
        reader=csv.DictReader(f)
        records=list(reader)
        cols=reader.fieldnames
    marks=','.join(['?']*len(cols))
    con.executemany(f'INSERT OR REPLACE INTO {table} ({",".join(cols)}) VALUES ({marks})',[[r[col] for col in cols] for r in records])
con.commit()
for table in ('DimProducts','DimStores','FactSales'):
    print(f'{table}: {con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]} records')
con.close()
