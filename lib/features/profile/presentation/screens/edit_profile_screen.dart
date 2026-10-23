import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';

/// Username, email and password, like the web `/profile/edit` (docs 11.5).
/// Only changed fields are sent; the current password is asked for (and
/// required) only when the email or password changes.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

/// API-side username rule (`UpdateProfileSchema`).
final _usernamePattern = RegExp(r'^[a-z0-9._]+$');
final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

enum _Field { username, email, currentPassword, newPassword }

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  late final String _originalUsername;
  late final String _originalEmail;
  bool _saving = false;
  bool _showPasswords = false;

  /// Errors from the server, shown under their field until it is edited.
  final _serverErrors = <_Field, String>{};

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).valueOrNull;
    _originalUsername = user?.username ?? '';
    _originalEmail = user?.email ?? '';
    _username.text = _originalUsername;
    _email.text = _originalEmail;
    for (final c in [_username, _email, _newPassword, _confirmPassword]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _username,
      _email,
      _currentPassword,
      _newPassword,
      _confirmPassword,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _usernameChanged => _username.text.trim() != _originalUsername;
  bool get _emailChanged => _email.text.trim() != _originalEmail;
  bool get _passwordChanged => _newPassword.text.isNotEmpty;
  bool get _needsCurrentPassword => _emailChanged || _passwordChanged;
  bool get _hasChanges => _usernameChanged || _emailChanged || _passwordChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                forceErrorText: _serverErrors[_Field.username],
                onChanged: (v) {
                  // Usernames are lowercase; fix it while typing.
                  final lower = v.toLowerCase();
                  if (lower != v) {
                    _username.value = _username.value.copyWith(text: lower);
                  }
                  _clearServerError(_Field.username);
                },
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.length < 3 || v.length > 30) {
                    return 'Kullanıcı adı 3-30 karakter olmalı';
                  }
                  if (!_usernamePattern.hasMatch(v)) {
                    return 'Sadece küçük harf, rakam, nokta ve alt çizgi '
                        'kullanılabilir';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                forceErrorText: _serverErrors[_Field.email],
                onChanged: (_) => _clearServerError(_Field.email),
                validator: (value) =>
                    _emailPattern.hasMatch(value?.trim() ?? '')
                    ? null
                    : 'Geçerli bir e-posta adresi gir',
              ),
              const SizedBox(height: 32),
              Text(
                'Şifre Değiştir',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                'Değiştirmek istemiyorsan boş bırak.',
                style: TextStyle(fontSize: 13, color: AppColors.grey400),
              ),
              const SizedBox(height: 12),
              _passwordField(
                controller: _newPassword,
                label: 'Yeni Şifre',
                field: _Field.newPassword,
                validator: (v) => (v ?? '').isNotEmpty && v!.length < 6
                    ? 'Yeni şifre en az 6 karakter olmalı'
                    : null,
              ),
              const SizedBox(height: 16),
              _passwordField(
                controller: _confirmPassword,
                label: 'Yeni Şifre (Tekrar)',
                validator: (v) => _passwordChanged && v != _newPassword.text
                    ? 'Şifreler eşleşmiyor'
                    : null,
              ),
              // Asked for only when it is needed: email or password change.
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _needsCurrentPassword
                    ? Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: _passwordField(
                          controller: _currentPassword,
                          label: 'Mevcut Şifre',
                          field: _Field.currentPassword,
                          helper: 'E-posta veya şifre değiştirmek için gerekli',
                          validator: (v) =>
                              (v ?? '').isEmpty ? 'Mevcut şifreni gir' : null,
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              const SizedBox(height: 32),
              PbButton(
                text: 'Kaydet',
                isLoading: _saving,
                onPressed: _hasChanges && !_saving ? _save : null,
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Hesabı Sil',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Hesabın, ilerlemen, palamutların ve envanterin kalıcı olarak '
                'silinir. Bu işlem geri alınamaz.',
                style: TextStyle(fontSize: 13, color: AppColors.grey400),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _saving ? null : _deleteAccount,
                child: const Text('Hesabımı sil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    _Field? field,
    String? helper,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_showPasswords,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          tooltip: _showPasswords ? 'Şifreyi gizle' : 'Şifreyi göster',
          icon: Icon(
            _showPasswords
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => _showPasswords = !_showPasswords),
        ),
      ),
      forceErrorText: field == null ? null : _serverErrors[field],
      onChanged: field == null ? null : (_) => _clearServerError(field),
      validator: validator,
    );
  }

  /// Store requirement (Google Play / App Store): in-app account deletion.
  /// The dialog asks for the password and makes the request; on success the
  /// session ends and the router leaves this screen, like signing out.
  Future<void> _deleteAccount() async {
    final deleted = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteAccountDialog(),
    );
    if (deleted != true || !mounted) return;
    // Like the web: guest progress left from a failed merge must not end up in
    // the next account created on this device.
    ref.read(guestProvider.notifier).clear();
    await ref.read(authStateProvider.notifier).logout();
  }

  void _clearServerError(_Field field) {
    if (_serverErrors.remove(field) != null) setState(() {});
  }

  Future<void> _save() async {
    setState(_serverErrors.clear);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(userRepositoryProvider)
          .updateProfile(
            username: _usernameChanged ? _username.text.trim() : null,
            email: _emailChanged ? _email.text.trim() : null,
            newPassword: _passwordChanged ? _newPassword.text : null,
            currentPassword: _needsCurrentPassword
                ? _currentPassword.text
                : null,
          );
      await ref.read(authStateProvider.notifier).refreshUser();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Profil güncellendi.'),
          backgroundColor: AppColors.success,
        ),
      );
      if (mounted) context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      final field = _fieldFor(e);
      if (field != null) {
        setState(() => _serverErrors[field] = _messageFor(e, field));
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Which field a server error belongs to (docs 11.5 error codes).
  _Field? _fieldFor(ApiException e) {
    if (e.statusCode == 403) return _Field.currentPassword;
    if (e.statusCode == 409) {
      return e.message.contains('e-posta') ? _Field.email : _Field.username;
    }
    for (final field in _Field.values) {
      if (e.fieldErrors.containsKey(field.name)) return field;
    }
    return null;
  }

  /// The API's 403/409 messages are Turkish; validation ones are English.
  String _messageFor(ApiException e, _Field field) {
    if (e.statusCode == 403 || e.statusCode == 409) return e.message;
    return switch (field) {
      _Field.username => 'Bu kullanıcı adı kullanılamaz',
      _Field.email => 'Geçerli bir e-posta adresi gir',
      _Field.currentPassword => 'Mevcut şifreni gir',
      _Field.newPassword => 'Yeni şifre en az 6 karakter olmalı',
    };
  }
}

class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog();

  @override
  ConsumerState<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  final _password = TextEditingController();
  bool _deleting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await ref.read(userRepositoryProvider).deleteAccount(_password.text);
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hesabını sil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tüm verilerin kalıcı olarak silinecek. Onaylamak için şifreni gir.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Şifre',
              prefixIcon: const Icon(Icons.lock_outlined),
              errorText: _error,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          onPressed: _deleting || _password.text.isEmpty ? null : _delete,
          child: _deleting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kalıcı olarak sil'),
        ),
      ],
    );
  }
}
