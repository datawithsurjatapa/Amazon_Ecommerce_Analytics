
CREATE TABLE amazon_ecommerce (
    user_id VARCHAR(20),
    product_id VARCHAR(20),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    price NUMERIC(12,2),
    discount NUMERIC(5,2),
    final_price NUMERIC(12,2),
    rating NUMERIC(2,1),
    review_count INT,
    stock INT,
    seller_id VARCHAR(20),
    seller_rating NUMERIC(2,1),
    purchase_date DATE,
    shipping_time_days INT,
    location VARCHAR(100),
    device VARCHAR(50),
    payment_method VARCHAR(50),
    is_returned BOOLEAN,
    delivery_status VARCHAR(50)
);
SELECT * FROM amazon_ecommerce;
SELECT COUNT(*)
FROM amazon_ecommerce;

SELECT
    SUM(final_price) AS total_revenue,
    COUNT(*) AS total_orders,
    AVG(final_price) AS average_order_value,
    COUNT(DISTINCT user_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products,
    ROUND(
        100.0 * SUM(CASE WHEN is_returned = TRUE THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate
FROM amazon_ecommerce;

--Which categories generate the most revenue?
SELECT
    category,
    SUM(final_price) AS revenue
FROM amazon_ecommerce
GROUP BY category
ORDER BY revenue DESC;

--Which categories receive the most orders?
SELECT
    category,
    COUNT(*) AS orders
FROM amazon_ecommerce
GROUP BY category
ORDER BY orders DESC;
--How does revenue change over time?
SELECT
    EXTRACT(YEAR FROM purchase_date) AS year,
    EXTRACT(MONTH FROM purchase_date) AS month,
    SUM(final_price) AS revenue
FROM amazon_ecommerce
GROUP BY year, month
ORDER BY year, month;
--Which are the top 10 products by revenue?
SELECT
    product_id,
    SUM(final_price) AS revenue
FROM amazon_ecommerce
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

--Which categories have the highest return rates?
SELECT
    category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN is_returned = TRUE THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(
        100.0 * SUM(CASE WHEN is_returned = TRUE THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS return_rate
FROM amazon_ecommerce
GROUP BY category
ORDER BY return_rate DESC;

--Does shipping time relate to returns?
SELECT
    shipping_time_days,
    COUNT(*) AS orders,
    ROUND(
        100.0 * SUM(CASE WHEN is_returned = TRUE THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS return_rate
FROM amazon_ecommerce
GROUP BY shipping_time_days
ORDER BY shipping_time_days;

--Which payment methods are most popular?
SELECT
    payment_method,
    COUNT(*) AS orders,
    SUM(final_price) AS revenue,
    ROUND(AVG(final_price),2) AS avg_order_value
FROM amazon_ecommerce
GROUP BY payment_method
ORDER BY orders DESC;

--Which locations generate the most revenue?
SELECT
    location,
    COUNT(*) AS orders,
    SUM(final_price) AS revenue	 
FROM amazon_ecommerce
GROUP BY location
ORDER BY revenue DESC;
--What is the average discount percentage for each category?
SELECT category,
ROUND(AVG(discount),2) AS avg_discount_percentage
FROM amazon_ecommerce
GROUP BY category
ORDER BY avg_discount_percentage DESC;

--Which sellers perform best?
SELECT
    seller_id,
    COUNT(*) AS orders,
    SUM(final_price) AS revenue,
    ROUND(AVG(seller_rating),2) AS avg_seller_rating
FROM amazon_ecommerce
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;
