import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/app.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveStorage = HiveStorage();
  await hiveStorage.init();
  runApp(
    ProviderScope(
      overrides: [
        hiveStorageProvider.overrideWithValue(hiveStorage),
      ],
      child: const App(),
    ),
  );
}
