# data_modelling_star_schema
data_modelling_task9
# Ecommerce Star Schema Project (SQLite)

## Project Overview
This project creates a **star schema** from an ecommerce orders dataset using SQLite.  
It separates data into **dimension tables** and a **fact table** to make analysis easy.

---

## Dataset Columns

| Column | Description |
|--------|-------------|
| c1     | order_id |
| c2     | user_id |
| c3     | product_id |
| c4     | category |
| c5     | price |
| c6     | quantity |
| c7     | total_price |
| c8     | order_date |
| c9     | country |
| c10    | customer_segment |

---

## Star Schema

- **Fact Table:** `fact_sales`  
  Contains order details with foreign keys to dimensions.

- **Dimensions:**  
  1. `dim_product` – product info  
  2. `dim_customer` – customer info  
  3. `dim_date` – date info  

---

## How to Run

1. Open `ecommerce_star_schema.sql` in SQLite or DB Browser.  
2. Execute all commands from top to bottom.  
3. Check that tables are populated using `SELECT COUNT(*) FROM <table>` queries.  
4. Run analysis queries like:

```sql
SELECT p.category, SUM(f.total_price) AS total_revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category;
