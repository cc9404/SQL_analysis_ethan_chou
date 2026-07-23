/*
-- Finding top resources on understanding the bulk of website seessions are coming from by analyzing the 
breakdown by UTM source, campaign and reffering domain
*/

USE mavenfuzzyfactory;

SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS number_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12' -- the day receive the assignment
GROUP BY 
    utm_source,
    utm_campaign,
    http_referer
ORDER BY number_of_sessions DESC;

-- NEXT STEPS 
-- Drill deeper into gsearch nonbrand campaign traffic to explore potential optimization opportunities
