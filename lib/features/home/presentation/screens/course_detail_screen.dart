import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({required this.courseId, super.key});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseFullProvider(courseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Kurs Detayı')),
      body: courseAsync.when(
        loading: () => const PbLoading(),
        error: (error, _) => Center(child: Text('Hata: $error')),
        data: (course) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (course.description != null) ...[
                const SizedBox(height: 8),
                Text(course.description!),
              ],
              const SizedBox(height: 24),
              Text(
                '${course.topics.length} Konu',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
