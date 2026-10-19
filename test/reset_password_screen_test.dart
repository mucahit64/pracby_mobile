import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/reset_password_screen.dart';

class _LoggedOut extends AuthNotifier {
  @override
  Future<UserModel?> build() async => null;
}

Future<void> _pump(WidgetTester tester, String? token) => tester.pumpWidget(
  ProviderScope(
    overrides: [authStateProvider.overrideWith(_LoggedOut.new)],
    child: MaterialApp(home: ResetPasswordScreen(token: token)),
  ),
);

void main() {
  testWidgets('a link with a token shows the new password form', (
    tester,
  ) async {
    await _pump(tester, 'a' * 64);
    expect(find.text('Yeni Şifre Belirle'), findsOneWidget);
    // The token comes from the link; there is no field for it.
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  for (final token in [null, '', 'not-a-token']) {
    testWidgets('a missing or malformed token ("$token") asks for a new link', (
      tester,
    ) async {
      await _pump(tester, token);
      expect(find.text('Bağlantı Geçersiz'), findsOneWidget);
      expect(find.text('Yeni Bağlantı İste'), findsOneWidget);
    });
  }
}
