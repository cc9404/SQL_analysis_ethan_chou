-- Finding most-viewed website pages, ranked by session volume
USE mavenfuzzyfactory;

SELECT
	pageview_url,
	COUNT(DISTINCT website_pageview_id) AS pageviews
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY pageviews DESC;

/*
NEXT STEPS
1. Dig into whether this list is also representative of our top entry pages
2. Analyze the performance of each of our top pages to look for improvement opportunities
*/
