-- analyzing conversion funnels
/*
build a full conversion funnel, analyzing how many customers make it to each steps
Start with /lander-1 and build the funnel all the way to thank you page.
*/

USE mavenfuzzyfactory;

-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: identify each pageview as the specific funnel step
-- STEP 3: create the session-level conversion funnel view
-- final_output: aggregate the data to access funnel performance


-- STEP 1
SELECT 
	website_sessions.website_session_id,
	website_pageviews.pageview_url,
	
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
    AND website_sessions.created_at > '2012-08-05'
    AND website_sessions.created_at < '2012-09-05'
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at;
    
-- STEP 2
SELECT
	website_session_id,
	MAX(products_page) AS product_made_it,
	MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT 
	website_sessions.website_session_id,
	website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
    AND website_sessions.created_at > '2012-08-05'
    AND website_sessions.created_at < '2012-09-05'
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at
) AS pageview_level

GROUP BY website_session_id;


-- STEP 3
CREATE TEMPORARY TABLE session_level_made_it_flags
SELECT
	website_session_id,
	MAX(products_page) AS product_made_it,
	MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT 
	website_sessions.website_session_id,
	website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
    AND website_sessions.created_at > '2012-08-05'
    AND website_sessions.created_at < '2012-09-05'
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at
) AS pageview_level

GROUP BY website_session_id;

SELECT * FROM session_level_made_it_flags;

-- final_output_part_1
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy,
	COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
	COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags;


-- final_output_part_2 -- click_rates
SELECT
	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT website_session_id) AS lander_click_rt,
    
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) 
    /COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS product_click_rt,
    
	COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) 
    /COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) 
    / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    
	COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) 
    /COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing
FROM session_level_made_it_flags;

















