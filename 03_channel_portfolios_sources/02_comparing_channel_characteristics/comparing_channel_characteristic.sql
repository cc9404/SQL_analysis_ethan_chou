USE mavenfuzzyfactory;
/*
comparing_channel_characteristic
learn more about bsearch nonbrand campaign, and pull out the percentage of 
traffic coming on Mobile, and compare that to gsearch.
*/
SELECT
	utm_source,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_sessions.website_session_id) AS pct_mobile
FROM website_sessions
WHERE created_at > '2012-08-22'
	AND created_at < '2012-11-30'
	AND utm_campaign = 'nonbrand'
GROUP BY 1;
