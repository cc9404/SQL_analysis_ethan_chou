/*
Trending with granular segments
analyze weekly trends for both desktop and mobile

*/

USE mavenfuzzyfactory;

SELECT
	MIN(DATE(created_at))AS week_start_date,
	COUNT(CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions,
	COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_sessions,
	COUNT(DISTINCT website_session_id) AS total_sessions
FROM website_sessions
WHERE website_sessions.created_at BETWEEN '2012-04-15' AND '2012-06-09'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY 
	YEAR(created_at),
    WEEK(created_at);
    
/* NEXT STEPS
1. Continue to monitor device-level volume and be aware of the impact bid levels has
2. Continue to monitor conversion performance at the device-level to optimize spend