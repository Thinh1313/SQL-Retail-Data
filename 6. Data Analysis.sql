-- Data Analysis

-- 1. Check total revenue and orders
SELECT COUNT(*) AS total_transactions, ROUND(SUM(total_amount),2) AS total_revenue
FROM retail.transactions

-- 2. Average order value by customer segment
SELECT c.customer_segment, ROUND(AVG(total_amount),2) AS avg_order
FROM retail.customer c
JOIN retail.transactions t
ON c.customer_id = t.customer_id
GROUP BY c.customer_segment
ORDER BY avg_order DESC;


-- 3. Revenue concentration deciles
WITH customer_revenue AS (
	SELECT customer_id, SUM(total_amount) AS customer_spending
    FROM retail.transactions
    GROUP BY customer_id
),
ranked AS (
	SELECT customer_id, customer_spending, NTILE(10) OVER (ORDER BY customer_spending DESC) AS decile
    FROM customer_revenue
)
SELECT decile, ROUND(SUM(customer_spending),2) AS decile_revenue, ROUND(SUM(customer_spending) / SUM(SUM(customer_spending)) OVER (), 4
) AS revenue_share
FROM ranked
GROUP BY decile
ORDER BY decile;
    

-- 4. View top ranking customers for each customer segment
SELECT c.customer_segment, c.customer_id, c.`name`, SUM(t.total_amount) AS customer_revenue,
RANK() OVER (PARTITION BY (c.customer_segment)
ORDER BY SUM(t.total_amount) DESC) AS customer_ranking
FROM retail.transactions t
JOIN retail.customer c
ON t.customer_id = c.customer_id
WHERE customer_segment IS NOT NULL
GROUP BY c.customer_segment, c.customer_id, c.`name`
ORDER BY customer_ranking;

    
-- 5. Dividing customers into three spending categories and identifying average total spending per transaction.
WITH customer_spending AS (
SELECT Customer_id, SUM(total_amount) AS total_spending
FROM retail.transactions
GROUP BY customer_id
),
Spending_tiers AS (
SELECT customer_id, total_spending, NTILE(3) OVER (ORDER BY total_spending ASC) AS customer_spending_tiers
FROM customer_spending
)
SELECT CASE customer_spending_tiers WHEN 3 THEN "High Spend"
									WHEN 2 THEN "Medium Spend"
                                    WHEN 1 THEN "Low Spend"
                                    END AS customer_type,
COUNT(*) AS customers_count, ROUND(AVG(total_spending),2) AS avg_total_spent
FROM spending_tiers
GROUP BY customer_type;
            


-- 6. View brands with highest to lowest revenue percentage
WITH product_revenue AS (
	SELECT p.product_brand, SUM(t.total_amount) AS revenue_of_product
    FROM retail.transactions t
    JOIN retail.product p
    ON t.product_id = p.product_id
    GROUP BY p.product_brand
    ORDER BY revenue_of_product DESC
)
SELECT product_brand, ROUND(revenue_of_product,2), ROUND(revenue_of_product / SUM(revenue_of_product) OVER () , 4) AS category_percentage
FROM product_revenue
GROUP BY product_brand, revenue_of_product
ORDER BY  category_percentage DESC;

-- 7. View category with highest to lowest revenue percentage.
WITH product_revenue AS (
	SELECT p.product_category, SUM(t.total_amount) AS revenue_of_product
    FROM retail.transactions t
    JOIN retail.product p
    ON t.product_id = p.product_id
    GROUP BY p.product_category
    ORDER BY revenue_of_product DESC
)
SELECT product_category, revenue_of_product, ROUND(revenue_of_product / SUM(revenue_of_product) OVER () , 4) AS category_percentage
FROM product_revenue
GROUP BY product_category, revenue_of_product
ORDER BY  category_percentage DESC;




-- 8. View month to month growth rate from March 2023 to February 2024.
WITH monthly_earnings AS (
	SELECT DATE_FORMAT(`date`, '%Y-%m') AS `Year_month`, SUM(total_amount) AS revenue
    FROM retail.transactions
    GROUP BY DATE_FORMAT(`date`,'%Y-%m')
)
SELECT `year_month`, revenue, revenue - LAG(revenue) OVER (ORDER BY `year_month`) AS mom_change, ROUND((revenue - LAG(revenue) OVER (ORDER BY `Year_month`)) / LAG(revenue) OVER (ORDER BY `Year_month`), 4) AS mon_growth_rate
FROM monthly_earnings;




-- 9. View product type with the highest to lowest revenue share percentage in Electronics.
SELECT p.product_type, ROUND(SUM(total_amount)) AS product_revenue, ROUND(SUM(t.total_amount) / SUM(SUM(t.total_amount)) OVER (), 4) AS revenue_share
FROM retail.transactions t
JOIN retail.product p
ON t.product_id = p.product_id
WHERE p.product_category = "Electronics"
GROUP BY p.product_type
ORDER BY revenue_share DESC




-- 10. Rank countires by total revenue share and measure cumulative revenue concentration.
WITH country_revenue AS (
	SELECT c.country, SUM(t.total_amount) AS country_earnings
    FROM retail.transactions t
    JOIN retail.customer c
    ON t.customer_id = c.customer_id
    WHERE country IS NOT NULL
    GROUP BY c.country
),
Country_metrics AS (
	SELECT country, country_earnings, RANK() OVER(ORDER BY country_earnings DESC) AS revenue_rank, country_earnings / SUM(country_earnings) OVER () AS revenue_share, SUM(country_earnings) OVER (ORDER BY country_earnings DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / SUM(country_earnings) OVER() AS cumulative_revenue_share
    FROM country_revenue
)
SELECT country, ROUND(country_earnings,2) AS country_earnings, revenue_rank, ROUND(revenue_share,4) AS revenue_share, ROUND(cumulative_revenue_share,4) AS cumulative_revenue_share
FROM country_metrics
ORDER BY  revenue_rank ASC;