USE mavenfuzzyfactory;
/*
building_product_conversion_funnels
-- ananlyze the conversion funnels from each product page to conversion
-- produce a comparison between the two conversion funnels, for all website traffic
*/

-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: figure out which pageview urls to look for
-- STEP 3: pull all pageviews and identify the funnel steps
-- STEP 4: create the session-level conversion funnel view
-- STEP 5:	aggregate the data to access funnel performance

-- STEP 1
CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT DISTINCT 
	website_session_id,
    website_pageview_id,
    pageview_url AS product_page_seen    
FROM website_pageviews
WHERE created_at < '2013-04-10'
	AND created_at > '2013-01-06' -- product 2 launch
    AND pageview_url IN('/the-original-mr-fuzzy','/the-forever-love-bear');
    
SELECT * FROM sessions_seeing_product_pages;

-- STEP 2
-- finding the right pageview_urls to build the funnels
SELECT DISTINCT
	 website_pageviews.pageview_url
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id;
        
-- STEP 3 & 4
-- look at the inner query first to look over the pageview-level results
SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
ORDER BY 
	sessions_seeing_product_pages.website_session_id,
	website_pageviews.created_at
;

-- then, turn it into a subquery and make it the summary with flags
CREATE TEMPORARY TABLE session_product_level_made_it_flags
SELECT
	website_session_id,
	CASE
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		ELSE 'check logic'
	END AS product_seen,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
	MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
ORDER BY 
	sessions_seeing_product_pages.website_session_id,
	website_pageviews.created_at
) AS pageview_level
GROUP BY
	website_session_id,
    CASE
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		ELSE 'check logic'
	END;
    
SELECT * FROM session_product_level_made_it_flags;
    
-- final_output_part_1
SELECT
	product_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
	COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_product_level_made_it_flags
GROUP BY product_seen;

-- final_output_part_2
SELECT
	product_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS product_page_click_rt,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt
FROM session_product_level_made_it_flags
GROUP BY product_seen;










