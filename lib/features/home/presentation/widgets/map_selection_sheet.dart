import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/core/api/response_cache.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/offline_banner.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';

/// The exam / module / course picked in [showMapSelectionSheet].
typedef MapSelection = ({String examTypeId, String? moduleId, String courseId});

/// Picks the course shown on the lesson map. Replaces the exam, module and
/// course tab rows above the map, which took too much of the screen. Picking
/// an exam or module shows its courses; picking a course closes the sheet.
Future<MapSelection?> showMapSelectionSheet(
  BuildContext context, {
  required List<EnrollmentModel> enrollments,
  required String examTypeId,
  required String? moduleId,
  required String? courseId,
}) {
  return showModalBottomSheet<MapSelection>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: _MapSelectionSheet(
          enrollments: enrollments,
          examTypeId: examTypeId,
          moduleId: moduleId,
          courseId: courseId,
        ),
      ),
    ),
  );
}

class _MapSelectionSheet extends ConsumerStatefulWidget {
  const _MapSelectionSheet({
    required this.enrollments,
    required this.examTypeId,
    required this.moduleId,
    required this.courseId,
  });

  final List<EnrollmentModel> enrollments;
  final String examTypeId;
  final String? moduleId;
  final String? courseId;

  @override
  ConsumerState<_MapSelectionSheet> createState() => _MapSelectionSheetState();
}

class _MapSelectionSheetState extends ConsumerState<_MapSelectionSheet> {
  late String _examTypeId = widget.examTypeId;
  late String? _moduleId = widget.moduleId;

  @override
  Widget build(BuildContext context) {
    final modulesAsync = ref.watch(modulesProvider(_examTypeId));
    final modules = modulesAsync.valueOrNull ?? const <ModuleModel>[];
    // Like the map: an unknown module falls back to the first one.
    final moduleId = modules.any((m) => m.id == _moduleId)
        ? _moduleId
        : modules.firstOrNull?.id;
    final coursesAsync = modulesAsync.isLoading
        ? const AsyncLoading<List<CourseModel>>()
        : moduleId != null
        ? ref.watch(coursesByModuleProvider((_examTypeId, moduleId)))
        : ref.watch(coursesByExamProvider(_examTypeId));
    // Offline: another exam can't be switched to (it's saved on the server)
    // and only courses whose map is cached can open.
    final offline = ref.watch(isOfflineProvider).valueOrNull ?? false;
    final cache = ref.watch(responseCacheProvider);
    void needsInternet(String what) => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what için internet gerekli.')));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.enrollments.length > 1) ...[
            const _SectionTitle('Sınav'),
            _ChipWrap(
              children: [
                for (final e in widget.enrollments)
                  _Chip(
                    label: e.examTypeName,
                    selected: e.examTypeId == _examTypeId,
                    enabled: !offline || e.examTypeId == widget.examTypeId,
                    onTap: () {
                      if (offline && e.examTypeId != widget.examTypeId) {
                        needsInternet('Sınav değiştirmek');
                        return;
                      }
                      setState(() {
                        _examTypeId = e.examTypeId;
                        _moduleId = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (modules.isNotEmpty) ...[
            const _SectionTitle('Modül'),
            _ChipWrap(
              children: [
                for (final m in modules)
                  _Chip(
                    label: m.name,
                    selected: m.id == moduleId,
                    onTap: () => setState(() => _moduleId = m.id),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          const _SectionTitle('Ders'),
          coursesAsync.when(
            skipLoadingOnReload: true,
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => const Text(
              'Dersler yüklenemedi.',
              style: TextStyle(color: AppColors.grey500),
            ),
            data: (courses) => courses.isEmpty
                ? const Text(
                    'Bu sınav için henüz içerik eklenmedi.',
                    style: TextStyle(color: AppColors.grey500),
                  )
                : _ChipWrap(
                    children: [
                      for (final c in courses)
                        if (offline && !cache.has(Endpoints.courseFull(c.id)))
                          _Chip(
                            label: c.title,
                            selected: false,
                            outlined: true,
                            enabled: false,
                            onTap: () => needsInternet('Bu dersi açmak'),
                          )
                        else
                          _Chip(
                            label: c.title,
                            selected: c.id == widget.courseId,
                            outlined: true,
                            onTap: () => Navigator.pop<MapSelection>(context, (
                              examTypeId: _examTypeId,
                              moduleId: moduleId,
                              courseId: c.id,
                            )),
                          ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.grey400,
      ),
    ),
  );
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 8, runSpacing: 8, children: children);
}

/// Filled when selected (exam, module); [outlined] keeps a light purple
/// fill like the old course tabs.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.outlined = false,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool outlined;

  /// Dimmed when it needs a connection; a tap explains why.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    if (!selected) {
      background = Colors.white;
      foreground = AppColors.grey600;
    } else if (outlined) {
      background = AppColors.primary.withValues(alpha: 0.1);
      foreground = AppColors.primary;
    } else {
      background = AppColors.primary;
      foreground = Colors.white;
    }
    final chip = Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.grey200,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
        ),
      ),
    );
    return enabled ? chip : Opacity(opacity: 0.45, child: chip);
  }
}
