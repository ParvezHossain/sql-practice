SELECT *
FROM icc_world_cup;

WITH all_teams
AS (
	SELECT team
		,SUM(matches_played) AS matches_played
	FROM (
		SELECT team_1 AS team
			,COUNT(*) AS matches_played
		FROM icc_world_cup
		GROUP BY team_1
		
		UNION ALL
		
		SELECT team_2 AS team
			,COUNT(*) AS matches_played
		FROM icc_world_cup
		GROUP BY team_2
		) AS subquery
	GROUP BY team
	)
	,winners_list
AS (
	SELECT winner
		,COUNT(*) AS wins
	FROM icc_world_cup
	GROUP BY winner
	)
SELECT all_teams.team
	,all_teams.matches_played
	,all_teams.matches_played - COALESCE(winners_list.wins, 0) AS match_lost
	,COALESCE(winners_list.wins, 0) AS match_won
	,COALESCE(winners_list.wins, 0) * 2 AS Pts
FROM all_teams
LEFT JOIN winners_list
	ON all_teams.team = winners_list.winner
ORDER BY match_won DESC;

-- Another soltuion

SELECT *
FROM icc_world_cup;

SELECT team
	,COUNT(*) AS matches_played
	,SUM(CASE WHEN team = winner THEN 1 ELSE 0 END) AS matches_wins
	,SUM(CASE WHEN team != winner AND winner <> 'DRAW' THEN 1 ELSE 0 END) AS matches_lost
	,SUM(CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END) AS matches_drawn
	,(SUM(CASE WHEN team = winner THEN 1 ELSE 0 END) * 2) + SUM(CASE WHEN winner = 'DRAW' THEN 1 ELSE 0 END) * 1 AS Pts
FROM (
	SELECT team_1 AS team, winner FROM icc_world_cup
UNION ALL
SELECT team_2 AS team, winner FROM icc_world_cup
) AS combined_teams
GROUP BY team
ORDER BY matches_wins DESC