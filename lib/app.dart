import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/router/app_router.dart';
import 'package:pracby_mobile/core/theme/app_theme.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? _connectivity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Send actions queued while offline (docs 7.5.1): on launch, whenever
    // the device comes back online and once the logged-in user is known
    // (member actions are only sent for their own user).
    unawaited(_syncOfflineQueue());
    _connectivity = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        unawaited(_syncOfflineQueue());
      }
    });
    ref.listenManual(authStateProvider.select((s) => s.valueOrNull?.id), (
      _,
      userId,
    ) {
      if (userId != null) unawaited(_syncOfflineQueue());
    });
  }

  Future<void> _syncOfflineQueue() async {
    final user = ref.read(authStateProvider).valueOrNull;
    final changed = await ref.read(offlineQueueProvider).sync(userId: user?.id);
    if (!changed || !mounted) return;
    // The server now has the queued actions: show its balances and progress.
    if (user != null) {
      await ref.read(authStateProvider.notifier).refreshUser();
    }
    ref.invalidate(courseFullProvider);
  }

  /// Back in the foreground (docs 10.4): energy regenerated while the app
  /// was in the background, and a new day may have broken the streak.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (ref.read(authStateProvider).valueOrNull != null) {
      unawaited(ref.read(authStateProvider.notifier).refreshUser());
      ref
        ..invalidate(userStatsProvider)
        ..invalidate(streakHistoryProvider);
    } else {
      ref.read(guestProvider.notifier).refreshEnergy();
    }
    unawaited(_syncOfflineQueue());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
