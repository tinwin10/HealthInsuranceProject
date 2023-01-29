/* 

Health Insurance Demographics Exploratory Data Analysis
 
Skills Used: Case Statements, Updates, CTE, Subqueries, Aggregate Functions, Concatenations
   
 */

-- Query for entire dataset

SELECT 
	*
FROM 
	Health_Insurance.Demographics AS demographics

-- 1) Demographics trends among claimants and their claim values

-- Claimant by gender, region

SELECT 
	region,
	COUNT(CASE WHEN gender = "male" THEN 1 ELSE NULL END) AS male,
	COUNT(CASE WHEN gender = "female" THEN 1 ELSE NULL END) AS female
FROM 
	demographics
GROUP BY
	region

-- Claimant by gender, age

SELECT 
	gender,
	age
FROM
	demographics 
ORDER BY
	age ASC
	
-- Claim value by gender, region

SELECT 
	region,
	gender,
	CONCAT("$ ", claim) AS claim
FROM
	demographics 
ORDER BY
	region ASC

-- 2) Correlations between claim amount, age, and health conditions

-- Correlation between claim amount, age, and bmi range

SELECT 
	age,
	CASE 
		WHEN bmi <= 18.5 THEN "underweight"
		WHEN bmi BETWEEN 18.5 AND 24.9 THEN "healthy"
		WHEN bmi BETWEEN 25.0 AND 29.9 THEN "overweight"
		WHEN bmi >= 30.0 THEN "obese"
		ELSE bmi
	END AS bmi_range,
		CONCAT("$ ",claim) AS claim
FROM
	demographics
ORDER BY
	bmi ASC

-- Correlation between claim amount, age, and blood pressure (MAP) range

SELECT 
	gender,
	CASE 
		WHEN bloodpressure < 70 THEN "low_MAP"
		WHEN bloodpressure BETWEEN 70 AND 100 THEN "normal_MAP"
		WHEN bloodpressure > 100 THEN "high_MAP"
		ELSE bloodpressure
	END AS MAP_range,
	CONCAT("$ ",claim) AS claim
FROM
	demographics 
ORDER BY
	MAP_range ASC
	

-- Correlation between claim amount, age, and diabetic status 

UPDATE 
	demographics
SET 
	diabetic = 
		CASE 
			WHEN diabetic = "no" THEN "non-diabetic"
			WHEN diabetic = "yes" THEN "diabetic"
			ELSE diabetic
		END
WHERE
	diabetic IN ("no", "yes")
	
SELECT 	
	age,
	diabetic AS diabetic_status,
	CONCAT("$ ",claim) AS claim
FROM
	demographics 
ORDER BY
	diabetic_status ASC
	
-- Correlation between claim amount, age, and number of children 

SELECT 
	age,
	children,
	CONCAT("$ ",claim) AS claim
FROM
	demographics 
ORDER BY
	children ASC

-- Correlation between claim amount, age, and smoker status 
	
UPDATE 
	demographics
SET 
	smoker = 
		CASE 
			WHEN smoker = "no" THEN "non-smoker"
			WHEN smoker = "yes" THEN "smoker"
			ELSE smoker
		END
WHERE
	smoker IN ("no", "yes")

SELECT 	
	age,
	smoker AS smoker_status,
	CONCAT("$ ",claim) AS claim
FROM
	demographics
ORDER BY 
	smoker_status ASC	

-- 3) Total claims by demographics and health conditions

-- Total claims by region

WITH total AS(
SELECT 
	COUNT(*) AS population
FROM
	demographics
)
	
SELECT
	region,
	CONCAT((COUNT(*) / (SELECT population FROM total)) * 100, "%") AS total_claims
FROM
	demographics 
GROUP BY
	region
	
-- Total claims by age groups (in-progress)

WITH total_ages AS(
SELECT 	
	CASE 

		WHEN age BETWEEN 18 AND 24 THEN "18-24"
		WHEN age BETWEEN 25 AND 34 THEN "25-34"
		WHEN age BETWEEN 35 AND 44 THEN "35-44"
		WHEN age BETWEEN 45 AND 54 THEN "45-54"
		WHEN age BETWEEN 55 AND 64 THEN "55-64"
		ELSE age
	END AS age_group
FROM 
	demographics 
)

SELECT
	age_group,
	CONCAT(COUNT(*) / (SELECT COUNT(*) FROM demographics) * 100, "%") AS total_claims
FROM total_ages
GROUP BY
	age_group
	
-- Total claims by gender

WITH total AS(
SELECT 
	COUNT(*) AS population
FROM
	demographics
)

SELECT
	gender,
	CONCAT((COUNT(*) / (SELECT population FROM total)) * 100, "%") AS total_claims
FROM
	demographics 
GROUP BY 
	gender
	
-- Total claims by bmi range 

WITH total_bmi AS(
SELECT 	
	CASE 
		WHEN bmi <= 18.5 THEN "underweight"
		WHEN bmi BETWEEN 18.5 AND 24.9 THEN "healthy"
		WHEN bmi BETWEEN 25.0 AND 29.9 THEN "overweight"
		WHEN bmi >= 30.0 THEN "obese"
		ELSE bmi
	END AS bmi_group
FROM 
	demographics 
)

SELECT
	bmi_group,
	CONCAT(COUNT(*) / (SELECT COUNT(*) FROM demographics) * 100, "%") AS total_claims
FROM total_bmi
GROUP BY
	bmi_group
	
-- Total claims by blood pressure (MAP) ranges

WITH total_MAP AS(
SELECT 
	CASE 
		WHEN bloodpressure < 70 THEN "low_MAP"
		WHEN bloodpressure BETWEEN 70 AND 100 THEN "normal_MAP"
		WHEN bloodpressure > 100 THEN "high_MAP"
		ELSE bloodpressure
	END AS MAP_group
FROM demographics 
)

SELECT
	MAP_group,
	CONCAT(COUNT(*) / (SELECT COUNT(*) FROM demographics) * 100, "%") AS total_claims
FROM total_MAP
GROUP BY
	MAP_group

-- Total claims by diabetics

WITH total AS(
SELECT 
	COUNT(*) AS population
FROM
	demographics
)

SELECT
	diabetic AS diabetic_status,
	CONCAT((COUNT(*) / (SELECT population FROM total)) * 100, "%") AS total_claims
FROM
	demographics 
GROUP BY 
	diabetic_status

-- Total claims by smokers

WITH total AS(
SELECT 
	COUNT(*) AS population
FROM
	demographics
)

SELECT
	smoker AS smoker_status,
	CONCAT((COUNT(*) / (SELECT population FROM total)) * 100, "%") AS total_claims
FROM
	demographics 
GROUP BY 
	smoker_status

-- Total claims by number of children

WITH total AS(
SELECT 
	COUNT(*) AS population
FROM
	demographics
)

SELECT
	children AS number_of_children,
	CONCAT((COUNT(*) / (SELECT population FROM total)) * 100, "%") AS total_claims
FROM
	demographics 
GROUP BY 
	number_of_children