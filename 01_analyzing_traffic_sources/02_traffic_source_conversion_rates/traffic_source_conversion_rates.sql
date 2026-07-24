/*
Traffic source conversion rates
Goal: Determine whether nonbrand search traffic is generating enough orders by calculating its conversion rate (CVR).
Method: calculate the CVR from session to order and we'll need a CVR of 4% to make numbers work
*/

USE mavenfuzzyfactory;

SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/ COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM website_sessions
	LEFT JOIN orders
    ON orders.website_session_id = website_sessions.website_session_id
WHERE 
website_sessions.created_at < '2012-04-14' -- the day receive the assignment
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
;

-- NEXT STEP
-- Monitor the impact of bid reductions


