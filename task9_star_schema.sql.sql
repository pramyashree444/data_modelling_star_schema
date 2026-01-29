SELECT * FROM ecommerce_orders LIMIT 5;
CREATE TABLE dim_customer (
    customer_key INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    customer_segment TEXT,
    country TEXT
);
CREATE TABLE dim_product (
    product_key INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id TEXT,
    category TEXT,
    price REAL
);
CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY AUTOINCREMENT,
    order_date DATE,
    year INTEGER,
    month INTEGER,
    day INTEGER
);
PRAGMA table_info(ecommerce_orders);
SELECT c1, c2, c3, c4, c5 FROM ecommerce_orders LIMIT 5;
INSERT INTO dim_product (product_id, category, price)
SELECT DISTINCT
    c3 AS product_id,
    c4 AS category,
    CAST(c5 AS REAL) AS price
FROM ecommerce_orders;
INSERT INTO dim_customer (user_id, customer_segment, country)
SELECT DISTINCT
    c2 AS user_id,
    c10 AS customer_segment,
    c9 AS country
FROM ecommerce_orders;
INSERT INTO dim_date (order_date, year, month, day)
SELECT DISTINCT
    DATE(c8),
    STRFTIME('%Y', c8),
    STRFTIME('%m', c8),
    STRFTIME('%d', c8)
FROM ecommerce_orders;
CREATE TABLE IF NOT EXISTS fact_sales (
    sales_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id TEXT,
    product_id TEXT,
    user_id TEXT,
    date_key INTEGER,
    qty INTEGER,
    total_price REAL,
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (user_id) REFERENCES dim_customer(user_id),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);
INSERT INTO fact_sales (
    order_id,
    product_id,
    user_id,
    date_key,
    qty,
    total_price
)
SELECT
    c1 AS order_id,
    c3 AS product_id,
    c2 AS user_id,
    d.date_key,
    CAST(c6 AS INTEGER) AS qty,
    CAST(c7 AS REAL) AS total_price
FROM ecommerce_orders e
JOIN dim_date d
    ON DATE(e.c8) = d.order_date;
SELECT COUNT(*) FROM dim_product;  
SELECT COUNT(*) FROM dim_customer;
SELECT COUNT(*) FROM dim_date;
SELECT COUNT(*) FROM fact_sales;
SELECT
    d.year,
    d.month,
    p.category,
    SUM(f.total_price) AS revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY d.year, d.month, p.category
ORDER BY revenue DESC;