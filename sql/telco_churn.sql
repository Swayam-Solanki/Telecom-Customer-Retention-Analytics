-- =====================================
-- 1. Executive KPIs
-- =====================================

-- How many total customers does the company have?
SELECT COUNT(*) AS total_customers FROM telco_churn;

-- How many customers stayed, joined, and churned?
SELECT customer_status, COUNT(*) AS customer_count 
FROM telco_churn
GROUP BY customer_status;

-- What is the overall churn rate?
SELECT
	COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END) churn_count,
	COUNT(CASE WHEN customer_status = 'Stayed' THEN 1 END ) stayed_count,
	
	(COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END) * 100 /
	(COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END) + 
	 COUNT(CASE WHEN customer_status = 'Stayed' THEN 1 END ))) AS churn_rate_perc
FROM telco_churn;

-- How many customers joined during the last quarter?
SELECT COUNT(*) AS cust_join_lstqtr
FROM telco_churn
WHERE customer_status = 'Joined' AND tenure_in_months BETWEEN 1 AND 3;

-- What is the average customer tenure?
SELECT ROUND(AVG(tenure_in_months),2) AS avg_cust_ten
FROM telco_churn;

-- =====================================
-- 2. Customer Segmentation
-- =====================================

-- Which age groups have the highest churn?
WITH age_grp AS (
	SELECT 
		CASE WHEN age BETWEEN 18 AND 24 THEN 'Young' 
			 WHEN age BETWEEN 25 AND 34 THEN 'Young adult' 
			 WHEN age BETWEEN 35 AND 44 THEN 'Core adult' 
			 WHEN age BETWEEN 45 AND 54 THEN 'Middle age' 
			 ELSE 'Senior'
		END AS age_bucket, customer_status
	FROM telco_churn
)

SELECT age_bucket,
	   COUNT(*) AS total_customer,
	   SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
	   ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM age_grp 
GROUP BY age_bucket
ORDER BY churn_rate_pct DESC;

-- Does gender influence churn?
SELECT gender,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY gender

-- Does marital status affect churn?
SELECT married,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY married;

-- Do customers with dependents churn less?
SELECT number_of_dependents,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY number_of_dependents;

-- Does marital status affect churn?
SELECT married,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY married;

-- Which cities have the highest churn rate?
SELECT city,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY city
ORDER BY churn_rate_pct DESC;


-- =====================================
-- 3. Service & Contract Analysis
-- =====================================

-- Which contract type has the highest churn?
SELECT contract,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- Which internet service type has the highest churn?
SELECT internet_type,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY internet_type
ORDER BY churn_rate_pct DESC;

-- Which payment method is associated with the highest churn?
SELECT payment_method,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

-- Does tenure influence churn?
SELECT tenure_in_months,
COUNT(*) AS total_customer,
SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*),2) AS churn_rate_pct
FROM telco_churn
GROUP BY tenure_in_months
ORDER BY churn_rate_pct DESC;

-- =====================================
-- 4. Revenue Analysis
-- =====================================

-- What is the total revenue generated?
SELECT ROUND(SUM(total_revenue):: numeric,2) AS total_revenue
FROM telco_churn;

-- How much revenue has been lost from churned customers?
SELECT ROUND(SUM(total_revenue):: numeric,2) AS total_lost_revenue
FROM telco_churn
WHERE customer_status = 'Churned';

-- Which customer Internet Type segment generates the highest revenue?
SELECT internet_type, ROUND(SUM(total_revenue):: numeric,2) AS total_revenue
FROM telco_churn 
GROUP BY internet_type
ORDER BY total_revenue DESC;

-- Which contract type contributes the most revenue?
SELECT contract, ROUND(SUM(total_revenue):: numeric,2) AS total_revenue
FROM telco_churn 
GROUP BY contract
ORDER BY total_revenue DESC;

-- =====================================
-- 5. Churn Reasons
-- =====================================

-- What are the top churn categories?
SELECT churn_category , COUNT(*) AS churn_customer
FROM telco_churn
WHERE churn_category IS NOT NULL
GROUP BY churn_category
ORDER BY churn_customer DESC;

-- What are the top churn reasons?
SELECT churn_reason , COUNT(*) AS churn_customer
FROM telco_churn
WHERE churn_reason IS NOT NULL
GROUP BY churn_reason
ORDER BY churn_customer DESC;

-- Which churn reasons account for the greatest revenue loss?
SELECT churn_reason, ROUND(SUM(total_revenue):: numeric,2) AS total_revenue
FROM telco_churn
WHERE churn_reason IS NOT NULL
GROUP BY churn_reason
ORDER BY total_revenue DESC;

-- =====================================
-- 6. High-Value Customers
-- =====================================
SELECT * FROM telco_churn;

-- Who are the highest-value customers based on Total Revenue?
SELECT customer_i_d, total_revenue
FROM telco_churn
ORDER BY total_revenue DESC
LIMIT 10;

-- Is the company losing high-value customers?
SELECT customer_status,
       COUNT(*) AS total_customers,
       ROUND(AVG(total_revenue)::numeric, 2) AS avg_revenue
FROM telco_churn
GROUP BY customer_status
ORDER BY avg_revenue DESC;   

-- Which customer segment should be prioritized for retention?
SELECT contract,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(100.0 * SUM(CASE WHEN customer_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
       ROUND(AVG(total_revenue)::numeric, 2) AS avg_revenue
FROM telco_churn
GROUP BY contract
ORDER BY churn_rate_pct DESC, avg_revenue DESC;
