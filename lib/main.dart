import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/app.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The app is portrait-only.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final hiveStorage = HiveStorage();
  await hiveStorage.init();
  runApp(
    ProviderScope(
      overrides: [hiveStorageProvider.overrideWithValue(hiveStorage)],
      child: const App(),
    ),
  );
}
