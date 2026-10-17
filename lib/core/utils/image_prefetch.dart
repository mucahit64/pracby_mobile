import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Downloads images into the cache `CachedNetworkImage` reads from, so they
/// can be shown later without a connection.
abstract final class ImagePrefetch {
  /// Returns false when an image could not be fetched because of the
  /// connection. Images the server doesn't have (HTTP 4xx) don't count:
  /// they will never load, and the question shows "görsel yüklenemedi".
  static Future<bool> prefetch(Iterable<String> urls) async {
    final cache = DefaultCacheManager();
    final results = await Future.wait(
      urls.toSet().map((url) async {
        try {
          if (await cache.getFileFromCache(url) != null) return true;
          await cache.downloadFile(url);
          return true;
        } on HttpExceptionWithStatus catch (e) {
          return e.statusCode >= 400 && e.statusCode < 500;
        } catch (_) {
          return false;
        }
      }),
    );
    return results.every((ok) => ok);
  }
}
