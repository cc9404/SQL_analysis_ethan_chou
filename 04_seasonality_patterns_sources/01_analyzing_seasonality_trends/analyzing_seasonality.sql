 USE mavenfuzzyfactory;
 /* analyzing_seasonality
 take a look at 2012's monthly and weekly volume patterns, to see if we can find
 any seasonal trends we should plan for in 2013.
 
 and also pull session volume and order volume

*/
 
-- pull session volume and order volume monthly
-- monthly_breakdown
SELECT DISTINCT
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1,2;

 -- pull session volume and order volume weekly
 -- weekly_breakdown
 SELECT DISTINCT
	YEAR(website_sessions.created_at) AS yr,
    WEEK(website_sessions.created_at) AS wk,
    MIN(DATE(website_sessions.created_at)) AS week_start,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1,2;


