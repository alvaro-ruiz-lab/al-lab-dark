-- Ranking de jugadores por temporada
CREATE TABLE IF NOT EXISTS players (
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    score BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT p.name, COUNT(m.id) AS matches, MAX(m.score) AS best
FROM players p
LEFT JOIN matches m ON m.player_id = p.id
WHERE p.created_at >= '2026-01-01' AND m.score > 100
GROUP BY p.name
HAVING COUNT(m.id) > 5
ORDER BY best DESC
LIMIT 10;

UPDATE players SET score = score + 50 WHERE id IN (1, 2, 3);
