USE mavenfuzzyfactory;
/*
impact_of_bid_changes
pull weekly session volume for gsaerch and bsearch non brand, broke down by device,
since November 4th?
*/

SELECT
-- YEARWEEK(website_sessions.created_at),
	MIN(DATE(website_sessions.created_at))AS week_start_date,
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS g_dtop_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS b_dtop_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END)
	/ COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END)
	AS b_pct_of_g_dtop,
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) 
	AS g_mob_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) 
	AS b_mob_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)
	/COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)
	AS b_pct_of_g_mob
FROM website_sessions
	WHERE website_sessions.created_at < '2012-12-22' 
	AND website_sessions.created_at > '2012-11-04'
	AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 
	YEARWEEK(website_sessions.created_at);

