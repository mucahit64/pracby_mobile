import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';

/// Opened from the reset email link (`/reset-password?token=…`, web
/// `pages/auth/reset-password.vue`). The token comes from the link; without
/// one the user is sent to request a new link.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({this.token, super.key});

  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

/// Reset tokens are 64 hex characters (API `ResetPasswordSchema`).
final _tokenPattern = RegExp(r'^[0-9a-f]{64}$');

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  /// Set when the API rejects the link (used or expired).
  String? _linkError;

  bool get _hasValidToken => _tokenPattern.hasMatch(widget.token ?? '');

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            token: widget.token!,
            newPassword: _passwordController.text,
          );
      if (!mounted) return;
      final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isLoggedIn
                ? 'Şifren değiştirildi.'
                : 'Şifren değiştirildi. Yeni şifrenle giriş yapabilirsin.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      context.go(isLoggedIn ? Routes.home : Routes.login);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (e.statusCode == 400) {
        setState(() => _linkError = e.message);
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              e.isNetworkError ? 'İnternet bağlantısı yok.' : e.message,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
      context.go(isLoggedIn ? Routes.home : Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Kapat',
          onPressed: _close,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _hasValidToken && _linkError == null
              ? _buildForm(context)
              : _buildInvalidLink(context),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) => Text(
    text,
    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
    ),
    textAlign: TextAlign.center,
  );

  /// No token, a malformed one, or one the API rejected.
  Widget _buildInvalidLink(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.link_off, size: 72, color: AppColors.grey400),
        const SizedBox(height: 16),
        _title(context, 'Bağlantı Geçersiz'),
        const SizedBox(height: 12),
        Text(
          _linkError ??
              'Bu şifre sıfırlama bağlantısı eksik veya hatalı. '
                  'Yeni bir bağlantı isteyebilirsin.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        PbButton(
          text: 'Yeni Bağlantı İste',
          onPressed: () => context.go(Routes.forgotPassword),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _title(context, 'Yeni Şifre Belirle'),
          const SizedBox(height: 40),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Yeni Şifre',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Şifreyi göster' : 'Şifreyi gizle',
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Şifre gerekli';
              if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscurePassword,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Yeni Şifre (Tekrar)',
              prefixIcon: Icon(Icons.lock_outlined),
            ),
            validator: (value) => value != _passwordController.text
                ? 'Şifreler eşleşmiyor'
                : null,
            onFieldSubmitted: (_) => _handleReset(),
          ),
          const SizedBox(height: 32),
          PbButton(
            text: 'Şifreyi Değiştir',
            onPressed: _handleReset,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
