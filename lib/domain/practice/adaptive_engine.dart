enum WordOutcome { correct, missed, skipped }

/// RA-PRD-401. Kata yang dilewati karena tidak terdengar jelas tidak mengubah hitungan.
class AdaptiveEngine {
  const AdaptiveEngine({this.raiseAfter = 3, this.lowerAfter = 2, this.maxLevel = 5});

  final int raiseAfter;
  final int lowerAfter;
  final int maxLevel;

  AdaptiveState evaluate(AdaptiveState state, WordOutcome outcome) {
    switch (outcome) {
      case WordOutcome.skipped:
        return state;
      case WordOutcome.correct:
        final streak = state.correctStreak + 1;
        if (streak >= raiseAfter) {
          return AdaptiveState(level: (state.level + 1).clamp(1, maxLevel));
        }
        return AdaptiveState(level: state.level, correctStreak: streak);
      case WordOutcome.missed:
        final streak = state.missStreak + 1;
        if (streak >= lowerAfter) {
          return AdaptiveState(level: (state.level - 1).clamp(1, maxLevel));
        }
        return AdaptiveState(level: state.level, missStreak: streak);
    }
  }
}

class AdaptiveState {
  const AdaptiveState({required this.level, this.correctStreak = 0, this.missStreak = 0});

  final int level;
  final int correctStreak;
  final int missStreak;
}
