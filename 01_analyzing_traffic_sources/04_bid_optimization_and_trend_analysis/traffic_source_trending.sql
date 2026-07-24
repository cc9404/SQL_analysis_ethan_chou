-/*Traffic source trending
Based on previousconversion rate analysis, gsearch nonbrand has been bid down
this time, we pull gsearch nonbrand session volume, by week to see if the bid changes
have caused volume to drop at all
*/

SELECT
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10' 
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
    WEEK(created_at)

/* NEXT STEPS
1. continue to monitor volume levels
2. think about how we could make the campaigns more efficient so that we can
increase volume again
*/
