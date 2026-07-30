USE mavenfuzzyfactory;
/*
-- impact of new product launch
analyzing_product_launches
monthly order volume, overall conversion rates, revenue per session, and a breakdown
of sales by product
*/
SELECT
	YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mon,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,		
	COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
	SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,	
    COUNT(CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_orders,
	COUNT(CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-04-01' AND '2013-04-01'
GROUP BY 1,2;
