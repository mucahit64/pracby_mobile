import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/router/app_router.dart';
import 'package:pracby_mobile/core/theme/app_theme.dart';
import 'package:pracby_mobile/features/quiz/domain/offline_quiz_buffer.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  StreamSubscription<List<ConnectivityResult>>? _connectivity;

  @override
  void initState() {
    super.initState();
    // Send quiz results queued while offline: on launch and whenever the
    // device comes back online (web: /learn mount + `online` event).
    _syncPendingQuizzes();
    _connectivity = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) _syncPendingQuizzes();
    });
  }

  void _syncPendingQuizzes() {
    unawaited(ref.read(offlineQuizBufferProvider).syncPendingSessions());
  }

  @override
  void dispose() {
    _connectivity?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Pracby',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
