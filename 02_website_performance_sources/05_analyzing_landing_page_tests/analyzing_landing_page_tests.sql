-- Analyzing landing page tests
-- pull up bounce rates for the two groups(/lander-1, /home) and look at the time period where /lander-2 was getting traffic

/*
STEP 1: find out when the new page /lander launched
STEP 2: finding the first website_pageview_id for relevant sessions
STEP 3: identifying the landing page of each session
STEP 4: counting pageviews for each session, to identify "bounces"
STEP 5: summarizing total sessions and bounced sessions, by LP 

*/

USE mavenfuzzyfactory;
-- STEP 1
-- finding the first instance of /lander-1 to set analysis timeframe

SELECT
	MIN(created_at) AS first_created_at,
	MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
		AND created_at IS NOT NULL;
        
-- first_created_at = '2012-06-19 00:35:54'
-- first_pageview_id = 23504


-- STEP 2
CREATE TEMPORARY TABLE first_pageviews
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
SELECT website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
        AND website_sessions.created_at < '2012-07-28' -- prescribed by the assignment
        AND website_pageviews.website_pageview_id > 23504
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	website_pageviews.website_session_id;
    
SELECT * FROM first_pageviews;

-- STEP 3
CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT 
	first_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');
		
SELECT * FROM nonbrand_test_sessions_w_landing_page;

-- STEP 4 & 5
-- then a table to have count of pageviews per session
	-- then limit it to just bounced_sessions

CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions
SELECT 
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewd
FROM nonbrand_test_sessions_w_landing_page
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id
GROUP BY
	nonbrand_test_sessions_w_landing_page.website_session_id,
	nonbrand_test_sessions_w_landing_page.landing_page
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1;
    
SELECT * FROM nonbrand_test_bounced_sessions;

-- STEP 5 identify_bounces & final_output

SELECT
	nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id)/COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS bounce_rate
    
FROM nonbrand_test_sessions_w_landing_page
	LEFT JOIN nonbrand_test_bounced_sessions
		ON nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
GROUP BY
	nonbrand_test_sessions_w_landing_page.landing_page;
	



