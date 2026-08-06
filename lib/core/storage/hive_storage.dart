import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _quizBufferBox = 'quiz_buffer';

final hiveStorageProvider = Provider<HiveStorage>((ref) {
  return HiveStorage();
});

class HiveStorage {
  Box<Map<dynamic, dynamic>>? _quizBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _quizBox = await Hive.openBox<Map<dynamic, dynamic>>(_quizBufferBox);
  }

  Box<Map<dynamic, dynamic>> get quizBox {
    assert(_quizBox != null, 'HiveStorage not initialized. Call init() first.');
    return _quizBox!;
  }

  Future<void> addBufferedAnswer(Map<String, dynamic> answer) async {
    await quizBox.add(answer);
  }

  List<Map<String, dynamic>> getBufferedAnswers() {
    return quizBox.values
        .map(Map<String, dynamic>.from)
        .toList();
  }

  Future<void> clearBufferedAnswers() async {
    await quizBox.clear();
  }
}
