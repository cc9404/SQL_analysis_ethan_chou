-- finding top entry pages (landing pages)
-- STEP 1: find the first pageview for each session
-- STEP 2: find the url the customer saw on that first pageview

CREATE TEMPORARY TABLE first_pv_per_session
SELECT
	website_session_id,
    MIN(website_pageview_id) AS first_pv
FROM
website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT
	website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT first_pv_per_session.website_session_id) AS sessions_hitting_page
FROM first_pv_per_session
	LEFT JOIN website_pageviews
		ON first_pv_per_session.first_pv = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url;

/*
NEXT STEPS
1. Analyze landing page performance, for the homepage specifically
2. Think about whether or not the homepage is the best intial experiences for all customers



