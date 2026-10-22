import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// The web's legal pages (`/gizlilik`, `/kullanim-kosullari`), opened in the
/// browser. Shown on the profile and register screens.
class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key});

  static const _links = [
    ('Gizlilik ve KVKK', '/gizlilik'),
    ('Kullanım Koşulları', '/kullanim-kosullari'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (final (label, path) in _links)
          TextButton(
            onPressed: () => openWebPage(context, path),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.grey400,
              ),
            ),
          ),
      ],
    );
  }
}

/// Opens [path] of the web app in the browser; a SnackBar if that fails.
Future<void> openWebPage(BuildContext context, String path) async {
  final messenger = ScaffoldMessenger.of(context);
  bool opened;
  try {
    opened = await launchUrl(
      Uri.parse('$webBaseUrl$path'),
      mode: LaunchMode.externalApplication,
    );
  } on Exception {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Sayfa açılamadı.')),
    );
  }
}
