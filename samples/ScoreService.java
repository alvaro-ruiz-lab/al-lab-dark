package com.lumen.scores;

import java.util.List;
import java.util.Optional;

/** Guarda las puntuaciones. */
public final class ScoreService implements AutoCloseable {
    private static final int LIMIT = 100;
    private final List<Integer> scores;

    public ScoreService(List<Integer> scores) {
        this.scores = scores;
    }

    @Override
    public void close() {
        scores.clear();
    }

    public Optional<Integer> best() {
        return scores.stream().filter(s -> s > 0 && s < LIMIT).max(Integer::compare);
    }

    public static void main(String[] args) {
        System.out.println("Mejor: " + new ScoreService(List.of(3, 7, 42)).best().orElse(null));
    }
}
