import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';

void main() {
  const tenMinutes = 10 * 60 * 1000;
  int now() => DateTime.now().millisecondsSinceEpoch;

  group('Guest energy regen (docs 10.4, web useGuestState)', () {
    test('adds one energy per full 10 minutes and keeps the remainder', () {
      final start = now() - (2 * tenMinutes + 5000);
      final result = GuestNotifier.applyEnergyRegen(
        GuestState(energyCount: 10, energyRefreshedAtMs: start),
      );
      expect(result.energyCount, 12);
      expect(result.energyRefreshedAtMs, start + 2 * tenMinutes);
    });

    test('stops at 25 and clears the timer', () {
      final result = GuestNotifier.applyEnergyRegen(
        GuestState(
          energyCount: 24,
          energyRefreshedAtMs: now() - 5 * tenMinutes,
        ),
      );
      expect(result.energyCount, maxEnergy);
      expect(result.energyRefreshedAtMs, isNull);
    });

    test('does nothing before 10 minutes pass', () {
      final start = now() - 1000;
      final result = GuestNotifier.applyEnergyRegen(
        GuestState(energyCount: 3, energyRefreshedAtMs: start),
      );
      expect(result.energyCount, 3);
      expect(result.energyRefreshedAtMs, start);
    });
  });

  group('GuestState', () {
    test('starts with 500 acorns and 25 energy, no progress', () {
      const s = GuestState();
      expect(s.acornBalance, 500);
      expect(s.energyCount, 25);
      expect(s.hasProgress, isFalse);
      expect(s.isActive, isFalse);
    });

    test('progress means results, claims or more than 500 acorns', () {
      expect(const GuestState(acornBalance: 501).hasProgress, isTrue);
      expect(const GuestState(claimedRewardStepIds: ['s']).hasProgress, isTrue);
    });

    test('round-trips through JSON', () {
      const s = GuestState(
        examTypeId: 'e',
        quizResults: [
          GuestQuizResult(
            topicId: 't',
            stepId: 's',
            correctCount: 7,
            totalQuestions: 10,
          ),
        ],
        acornBalance: 507,
        energyCount: 20,
        energyRefreshedAtMs: 123,
      );
      final back = GuestState.fromJson(s.toJson());
      expect(back.examTypeId, 'e');
      expect(back.quizResults.single.correctCount, 7);
      expect(back.acornBalance, 507);
      expect(back.energyRefreshedAtMs, 123);
    });

    test('quiz results use the API guest_data keys and omit nulls', () {
      const r = GuestQuizResult(
        topicId: 't',
        correctCount: 1,
        totalQuestions: 2,
      );
      expect(r.toJson(), {
        'topicId': 't',
        'correctCount': 1,
        'totalQuestions': 2,
      });
    });
  });
}
