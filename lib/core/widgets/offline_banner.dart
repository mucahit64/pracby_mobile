import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

/// True while the device has no network connection (no Wi-Fi, mobile data or
/// ethernet). It doesn't probe the server, so a network without internet
/// still counts as online; failed requests are queued as before.
final isOfflineProvider = StreamProvider<bool>((ref) async* {
  bool offline(List<ConnectivityResult> results) =>
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  yield offline(await Connectivity().checkConnectivity());
  yield* Connectivity().onConnectivityChanged.map(offline);
});

/// A thin strip above every screen while offline. The app keeps working
/// from its cache and sends queued actions once the connection is back.
/// Used from `MaterialApp.builder`, so it takes over the top safe area.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(isOfflineProvider).valueOrNull ?? false;
    if (!offline) return child;

    return Column(
      children: [
        Material(
          color: AppColors.grey800,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.wifi_off_rounded, size: 14, color: AppColors.white),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'İnternet yok · Yaptıkların bağlanınca gönderilecek',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // The strip already covers the status bar, so screens below it must
        // not pad for it again.
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
