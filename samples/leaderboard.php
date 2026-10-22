<?php
declare(strict_types=1);

namespace Lumen\Web;

final class Leaderboard
{
    private const LIMIT = 10;

    public function __construct(private \PDO $db) {}

    public function top(int $season = 1): array
    {
        $stmt = $this->db->prepare('SELECT name, score FROM players WHERE season = ? LIMIT ' . self::LIMIT);
        $stmt->execute([$season]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC) ?: [];
    }
}

echo "Top: {$season}\n";
