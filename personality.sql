-- DATA CLEANING
# 1 - Remove Duplicates
# 2 - Standardize Data
# 3 - Null/Blank Values
# 4 - Remove Columns

SELECT * FROM personality;

# create a staging table
CREATE TABLE personality1
LIKE personality;

# insert data from original to staging table
INSERT INTO personality1
SELECT * FROM personality;

SELECT * FROM personality1;

-- 1. Remove Duplicates 
# create row_num col to identify any duplicate rows 
# create cte to see if any row_num > 1, indicating duplicate rows 
WITH duplicate_row_cte AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY Time_spent_Alone, Stage_fear, Social_event_attendance, Going_outside, 
		Drained_after_socializing, Friends_circle_size, Post_frequency, Personality) AS row_num
	FROM personality1
)
SELECT * FROM duplicate_row_cte 
WHERE row_num > 1;

# since there are duplicate rows, we create a second staging table and input row_num col
# then we remove the duplicate rows from this second staging table
CREATE TABLE `personality2` (
  `Time_spent_Alone` double DEFAULT NULL,
  `Stage_fear` text,
  `Social_event_attendance` double DEFAULT NULL,
  `Going_outside` double DEFAULT NULL,
  `Drained_after_socializing` text,
  `Friends_circle_size` double DEFAULT NULL,
  `Post_frequency` double DEFAULT NULL,
  `Personality` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# insert data from personality1 to personality2 table
INSERT INTO personality2
SELECT *, ROW_NUMBER() OVER(PARTITION BY Time_spent_Alone, Stage_fear, Social_event_attendance, Going_outside, 
		Drained_after_socializing, Friends_circle_size, Post_frequency, Personality) AS row_num
FROM personality1;

SELECT * FROM personality2;

# remove duplicate rows from personality2 table
DELETE FROM personality2
WHERE row_num > 1;

# check if all duplicate rows removed successfully
SELECT * FROM personality2
WHERE row_num > 1;


-- 2. Standardize Data
# review every column to see if any outstanding issues
SELECT DISTINCT Stage_fear FROM personality2
ORDER BY Stage_fear;
# columns Stage_fear, Drained_after_socializing have NULL/Blanks 


-- 3. NULL/Blank values 
# look over NULL/Blank values for Stage_fear column
SELECT * FROM personality2
WHERE Stage_fear IS NULL OR Stage_fear = '';

# look over NULL/Blank values for Drained_after_socializing column
SELECT * FROM personality2
WHERE Drained_after_socializing IS NULL OR Drained_after_socializing = '';

# look for rows where both Stage_fear, Drained_after_socializing columns have NULL/Blanks
SELECT * FROM personality2
WHERE (Drained_after_socializing IS NULL OR Drained_after_socializing = '')
AND (Stage_fear IS NULL OR Stage_fear = '');

# cannot populate the NULL/Blanks with existing data


-- 4. Remove Unnecessary Columns
# remove row_num column, done using it to remove duplicate rows
ALTER TABLE personality2
DROP COLUMN row_num;

# check if row_num column removed successfully
SELECT * FROM personality2;


-- EXPLORATORY DATA ANALYSIS
-- 1. EXTROVERTS + INTROVERTS - average and mode values across all cols
#0 Average values for quanitative cols, grouped by personality
SELECT personality, ROUND(AVG(Time_spent_Alone),2) Time_spent_Alone, ROUND(AVG(Social_event_attendance),2) Social_event_attendance, ROUND(AVG(Going_outside),2) Going_outside, 
				ROUND(AVG(Friends_circle_size),2) Friends_circle_size, ROUND(AVG(Post_frequency),2) Post_frequency, COUNT(personality) Count
FROM personality2
GROUP BY personality;

#1a Drained_after_socializing is key difference between extroversion and introversion
# count yes/no values for Drained_after_socializing col, grouped by personality
# can see mode for Drained_after_socializing col, grouped by personality
WITH no_cte (personality, Drained_after_socializing_NO) AS 
(
	SELECT personality, COUNT(Drained_after_socializing)
	FROM personality2
    WHERE Drained_after_socializing = 'No'
	GROUP BY personality
),
yes_cte (personality, Drained_after_socializing_YES) AS
(
	SELECT personality, COUNT(Drained_after_socializing)
	FROM personality2
    WHERE Drained_after_socializing = 'Yes'
    GROUP BY personality
)
SELECT no_cte.personality, Drained_after_socializing_NO, Drained_after_socializing_YES
FROM no_cte JOIN yes_cte ON no_cte.personality = yes_cte.personality
ORDER BY no_cte.personality;

#1b count yes/no values for Stage_fear col, grouped by personality
# can see mode for Stage_fear col, grouped by personality
WITH no_cte (personality, Stage_fear_NO) AS 
(
	SELECT personality, COUNT(Stage_fear)
	FROM personality2
    WHERE Stage_fear = 'No'
	GROUP BY personality
),
yes_cte (personality, Stage_fear_YES) AS
(
	SELECT personality, COUNT(Stage_fear)
	FROM personality2
    WHERE Stage_fear = 'Yes'
    GROUP BY personality
)
SELECT no_cte.personality, Stage_fear_NO, Stage_fear_YES
FROM no_cte JOIN yes_cte ON no_cte.personality = yes_cte.personality
ORDER BY no_cte.personality;

#1c count introverts with both stage fear, drained after socializing = NO
# findings: when i queried stage fear = NO and drained after socializing = NO separately,
# i got 75 introverts. Turns out those 75 introverts for the separate queries are the same.
# introverts who have no stage fear ALSO do not feel drained after socializing
SELECT COUNT(personality)
FROM personality2
WHERE Stage_fear = 'NO' AND Drained_after_socializing = 'NO' AND personality = 'Introvert'
GROUP BY personality;

-- 2. EXTROVERTS - compare KEY indicator Drained_after_socializing (YES vs NO)

#2 compare average values of cols for EXTROVERTS with Drained_after_socializing = YES
# with average values of cols for EXTROVERTS with Drained_after_socializing = NO
# how do these average values compare to average values for INTROVERTS with Drained_after_socializing = YES and INTROVERTS with Drained_after_socializing = NO, respectively?
# how do these average values compare to average values for INTROVERTS overall and EXTROVERTS overall, respectively?
WITH extrovert_yes AS 
(
	SELECT ROUND(AVG(Time_spent_Alone),2) Time_spent_Alone, ROUND(AVG(Social_event_attendance),2) Social_event_attendance, ROUND(AVG(Going_outside),2) Going_outside, 
				ROUND(AVG(Friends_circle_size),2) Friends_circle_size, ROUND(AVG(Post_frequency),2) Post_frequency, COUNT(personality) Count
    FROM personality2
	WHERE personality = 'Extrovert'
		AND Drained_after_socializing = 'Yes'
	GROUP BY personality
	
), extrovert_no AS   
(
	SELECT ROUND(AVG(Time_spent_Alone),2) Time_spent_Alone, ROUND(AVG(Social_event_attendance),2) Social_event_attendance, ROUND(AVG(Going_outside),2) Going_outside, 
				ROUND(AVG(Friends_circle_size),2) Friends_circle_size, ROUND(AVG(Post_frequency),2) Post_frequency, COUNT(personality) Count
    FROM personality2
	WHERE personality = 'Extrovert'
		AND Drained_after_socializing = 'No'
	GROUP BY personality
)
SELECT Time_spent_Alone, Social_event_attendance, Going_outside, Friends_circle_size, Post_frequency, Count
FROM extrovert_yes 
UNION 
SELECT Time_spent_Alone, Social_event_attendance, Going_outside, Friends_circle_size, Post_frequency, Count
FROM extrovert_no;


-- 3. INTROVERTS - compare KEY indicator Drained_after_socializing (NO vs YES)

#3 compare average values of cols for INTROVERTS with Drained_after_socializing = NO
# with average values of cols for INTROVERTS with Drained_after_socializing = YES
# how do these average values compare to average values for EXTROVERTS with Drained_after_socializing = NO and EXTROVERTS with Drained_after_socializing = YES, respectively?
# how do these average values compare to average values for EXTROVERTS overall and INTROVERTS overall, respectively?
WITH introvert_no AS 
(
	SELECT ROUND(AVG(Time_spent_Alone),2) Time_spent_Alone, ROUND(AVG(Social_event_attendance),2) Social_event_attendance, ROUND(AVG(Going_outside),2) Going_outside, 
				ROUND(AVG(Friends_circle_size),2) Friends_circle_size, ROUND(AVG(Post_frequency),2) Post_frequency, COUNT(personality) Count
    FROM personality2
	WHERE personality = 'Introvert'
		AND Drained_after_socializing = 'No'
	GROUP BY personality
	
), introvert_yes AS   
(
	SELECT ROUND(AVG(Time_spent_Alone),2) Time_spent_Alone, ROUND(AVG(Social_event_attendance),2) Social_event_attendance, ROUND(AVG(Going_outside),2) Going_outside, 
				ROUND(AVG(Friends_circle_size),2) Friends_circle_size, ROUND(AVG(Post_frequency),2) Post_frequency, COUNT(personality) Count
    FROM personality2
	WHERE personality = 'Introvert'
		AND Drained_after_socializing = 'Yes'
	GROUP BY personality
)
SELECT Time_spent_Alone, Social_event_attendance, Going_outside, Friends_circle_size, Post_frequency, Count
FROM introvert_no 
UNION 
SELECT Time_spent_Alone, Social_event_attendance, Going_outside, Friends_circle_size, Post_frequency, Count
FROM introvert_yes;

SELECT * FROM personality2;













