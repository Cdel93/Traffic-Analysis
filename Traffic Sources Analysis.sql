/* a list of where the bulk of the website sessions are coming from */

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY 1 , 2 , 3
ORDER BY sessions DESC;

/* calculate conversion rate for specific campaign  */

create temporary table gsearch_sessions

SELECT 
    website_sessions.website_session_id,
    website_sessions.utm_source,
    website_sessions.utm_campaign
FROM
    website_sessions
WHERE
    website_sessions.created_at < '2012-04-12'
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand';

SELECT 
    COUNT(DISTINCT gsearch_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT gsearch_sessions.website_session_id) AS cvr
FROM
    gsearch_sessions
        LEFT JOIN
    orders ON gsearch_sessions.website_session_id = orders.website_session_id;

/* spesific campaign session volume by week */

SELECT 
    MIN(DATE(created_at)) AS week_start_at,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    website_sessions.created_at < '2012-05-12'
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at);


/*  find conversion rates from session to session to orders by device type (bid optimization ) */

SELECT 
    device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS cvr
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2012-05-11'
GROUP BY device_type;

/* find weekly trends by device type */

SELECT 
    MIN(DATE(created_at)) AS week_start_at,
    COUNT(DISTINCT CASE
            WHEN device_type = 'desktop' THEN website_session_id
            ELSE NULL
        END) AS desktop_sessions,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) AS mobile_sessions
FROM
    website_sessions
WHERE
    website_sessions.created_at < '2012-06-09'
GROUP BY YEAR(created_at) , WEEK(created_at);




