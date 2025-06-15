SELECT * FROM school_details;
SELECT * FROM schools;
SELECT * FROM players;
SELECT * FROM salaries;

-- PART I: SCHOOL ANALYSIS

/* TASK 1: In each decade, how many schools were there that produced MLB players?*/

--Findings
/*1990 produced the highest MLB player (494)*/

SELECT FLOOR(yearID / 10) * 10 AS decade, COUNT(DISTINCT schoolID) AS new_school
FROM schools
GROUP BY decade
ORDER BY new_school DESC;




/*TASK 2: What are the names of the top 5 schools that produced the most players?*/

--Findings
/*University of Texas at Austin is the top school producer by 107 players*/

SELECT sd.name_full, COUNT(DISTINCT(playerID)) AS new_sum
FROM schools s
LEFT JOIN school_details sd ON s.schoolID = sd.schoolID
GROUP BY s.schoolID
ORDER BY new_sum DESC
LIMIT 5;


/*TASK 3: For each decade, what were the names of the top 3 schools that produced the most players?*/

--Findings
/*In decade 1970 Arizona State University procuded the most players of 32*/

WITH frst AS (SELECT FLOOR(s.yearID / 10) * 10 AS decade, sd.name_full, COUNT(DISTINCT s.playerID) AS num_players
				FROM schools s
                LEFT JOIN school_details sd
                ON s.schoolID = sd.schoolID
                GROUP BY decade, s.schoolID),

	rn AS (SELECT	decade, name_full, num_players,
					ROW_NUMBER() OVER(PARTITION BY decade ORDER BY num_players DESC) AS top_school
					FROM frst)
SELECT decade, name_full, num_players
FROM rn
WHERE top_school <= 3
ORDER BY decade DESC, top_school;

-- PART 2: SALARY ANALYSIS

-- TASK 1: Return the top 20% of teams in terms of average annual spending
--Findings
/*SFG team had the highest average spending by 143.5 mill*/

WITH ts AS (SELECT teamID, yearID, SUM(salary) AS total_spend
			FROM salaries
			GROUP BY teamID, yearID
            ORDER BY teamID, yearID),
            
	sp AS (SELECT teamID, AVG(total_spend) AS avg_spend,
					NTILE(5) OVER (ORDER BY AVG(total_spend) DESC) AS spend_pct
			FROM ts
			GROUP BY teamID)

            

SELECT teamID, ROUND(avg_spend / 1000000,1) AS avg_spend_millions
FROM sp
WHERE spend_pct = 1;


-- TASK 2: For each team, show the cumulative sum of spending over the years 
--Findings
/*Showed the cumulative sum of spending over the years*/

WITH ts AS (SELECT yearID, teamID, SUM(salary) AS total_spend
			FROM salaries
			GROUP BY yearID, teamID
			ORDER BY teamID, yearID)

SELECT yearID, teamID,
		ROUND(SUM(total_spend) OVER(PARTITION BY teamID ORDER BY yearID) / 1000000,1) AS cumulative_sum
FROM ts;

-- TASK 3: Return the first year that each team's cumulative spending surpassed 1 billion 
--Findings
/*Showed the first year that each team's cumulative spending surpassed 1 billion*/

WITH ts AS (SELECT yearID, teamID, SUM(salary) AS total_spend
			FROM salaries
			GROUP BY yearID, teamID
			ORDER BY teamID, yearID),

	cs	AS (SELECT yearID, teamID,
		SUM(total_spend) OVER(PARTITION BY teamID ORDER BY yearID) AS cumulative_sum 
        FROM ts),
        
	bls AS (SELECT  yearID, teamID, cumulative_sum,
			ROW_NUMBER() OVER(PARTITION BY teamID ORDER BY cumulative_sum) AS rnk
		FROM 	cs
		WHERE cumulative_sum > 1000000000)
        
SELECT yearID, teamID, ROUND(cumulative_sum / 1000000000, 2) AS billion
FROM bls
WHERE rnk = 1;

-- PART III: PLAYER CAREER ANALYSIS

-- TASK1: For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). Sort from longest career to shortest career.

SELECT	nameGiven,
		TIMESTAMPDIFF(YEAR , CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), debut) AS starting_age,
        TIMESTAMPDIFF(YEAR , CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE), finalGame) AS starting_age,
        TIMESTAMPDIFF(YEAR, debut, finalGame) AS career_length
FROM players
ORDER BY career_length DESC;


-- TASK2: What team did each player play on for their starting and ending years? 

SELECT	p.nameGiven,
		s.teamID AS starting_team, s.yearID AS starting_year, e.teamID AS ending_team, e.yearID AS ending_year
FROM	players p	INNER JOIN salaries s
							ON p.playerID = s.playerID
							AND YEAR(p.debut) = s.yearID
					INNER JOIN salaries e
							ON p.playerID = e.playerID
							AND YEAR(p.finalGame) = e.yearID;


-- TASK3: How many players started and ended on the same team and also played for over a decade?

WITH player_states AS (SELECT	p.nameGiven,
							s.teamID AS starting_team, s.yearID AS starting_year, e.teamID AS ending_team, e.yearID AS ending_year
					FROM	players p	INNER JOIN salaries s
												ON p.playerID = s.playerID
												AND YEAR(p.debut) = s.yearID
										INNER JOIN salaries e
												ON p.playerID = e.playerID
												AND YEAR(p.finalGame) = e.yearID
					WHERE	s.teamID = e.teamID
							AND e.yearID - s.yearID >= 10)

SELECT COUNT(nameGiven) AS player_numbers
FROM player_states;


-- PART IV: PLAYER COMPARISON ANALYSIS

-- TASK 1: Which players have the same birthday?

WITH bn AS (SELECT	CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE) AS birthdate,
					nameGiven
			FROM	players)
            
SELECT	birthdate, GROUP_CONCAT(nameGiven SEPARATOR ', ') AS players
FROM	bn
WHERE	YEAR(birthdate) BETWEEN 1980 AND 1990
GROUP BY birthdate
ORDER BY birthdate;

-- TASK 2: Create a summary table that shows for each team, what percent of players bat right, left and both. 

SELECT	s.teamID,
		ROUND(SUM(CASE WHEN p.bats = 'R' THEN 1 ELSE 0 END) / COUNT(p.playerID) * 100, 1) AS right_hand,
        ROUND(SUM(CASE WHEN p.bats = 'L' THEN 1 ELSE 0 END) / COUNT(p.playerID) * 100, 1) AS left_hand,
        ROUND(SUM(CASE WHEN p.bats = 'B' THEN 1 ELSE 0 END) / COUNT(p.playerID) * 100, 1) AS both_hand
FROM	salaries s LEFT JOIN players p
		ON	s.playerID = p.playerID
GROUP BY s.teamID;


-- TASK 3: How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?

WITH hw AS (SELECT	FLOOR(YEAR(debut) / 10) * 10 AS decade, ROUND(AVG(weight), 2) AS avg_weight, ROUND(AVG(height), 2) AS avg_height
				FROM	players
				WHERE	weight IS NOT NULL
						AND height IS NOT NULL
				GROUP BY decade)
SELECT	decade,
		avg_height - LAG(avg_height) OVER(ORDER BY decade) AS height_diff,
        avg_weight - LAG(avg_weight) OVER(ORDER BY decade) AS weight_diff
FROM	hw
WHERE	decade IS NOT NULL;



