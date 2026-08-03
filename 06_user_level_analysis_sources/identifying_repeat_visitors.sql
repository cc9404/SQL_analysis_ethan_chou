USE mavenfuzzyfactory;
/*
identifying_repeat_visitors
pull the data on how many of our website vivstors come back for another session?
2014 to date is good

STEP 1: Identify the relevant new sessions, Use the user_id values from step 1 to find any repeat sessions those users had
final_output: Analyze the data at the user level (how many sessions did each user have?), Aggregate the user-level analysis to generate bahavioral analysis

*/

-- STEP 1
CREATE TEMPORARY TABLE sessions_w_repeats
SELECT 
	new_sessions.user_id,
	new_sessions.website_session_id AS new_session_id,
	website_sessions.website_session_id AS repeat_session_id
FROM    
(
SELECT
	user_id,
    website_session_id
FROM website_sessions
WHERE created_at < '2014-11-01' 
	AND created_at >= '2014-01-01'
	AND is_repeat_session = 0 -- new sessions only
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
		AND website_sessions.is_repeat_session = 1
        AND website_sessions.website_session_id > new_sessions.website_session_id
        AND website_sessions.created_at < '2014-11-01'
        AND website_sessions.created_at >= '2014-01-01'
;

SELECT * FROM sessions_w_repeats;
        
-- STEP 2
SELECT
	repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM
(
SELECT
	user_id,
    COUNT(DISTINCT new_session_id) AS new_sessions,
	COUNT(DISTINCT repeat_session_id) AS repeat_sessions
FROM sessions_w_repeats
GROUP BY 1
ORDER BY 3 DESC
) AS user_level
GROUP BY 1
;



  
        
        

