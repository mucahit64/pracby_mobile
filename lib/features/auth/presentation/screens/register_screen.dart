import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/core/widgets/legal_links.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/auth/presentation/availability_check.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/auth/presentation/widgets/auth_close_button.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/onboarding/data/exam_groups_repository.dart';

/// Register rule of the API (`RegisterSchema`, docs 3.2): 3-20 characters,
/// lowercase letters, digits, "." and "_", starting and ending with a letter
/// or digit, no ".." / "__" / "._".
final _usernamePattern = RegExp(
  r'^[a-z0-9](?!.*[._]{2})[a-z0-9._]{1,18}[a-z0-9]$',
);
final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

String? _usernameRuleError(String v) {
  if (v.length < 3 || v.length > 20) return '3-20 karakter olmalı';
  if (!RegExp(r'^[a-z0-9._]+$').hasMatch(v)) {
    return 'Sadece küçük harf, rakam, nokta ve alt çizgi kullanılabilir';
  }
  if (!RegExp(r'^[a-z0-9].*[a-z0-9]$').hasMatch(v)) {
    return 'Harf veya rakamla başlayıp bitmeli';
  }
  if (!_usernamePattern.hasMatch(v)) {
    return 'Art arda nokta veya alt çizgi kullanılamaz';
  }
  return null;
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AvailabilityCheck _emailCheck;
  late final AvailabilityCheck _usernameCheck;
  bool _obscurePassword = true;
  bool _isLoading = false;

  /// Exam picked on this form. Only asked when the user hasn't picked one as
  /// a guest; without it the API would silently use KPSS Lisans.
  ExamTypeModel? _exam;

  /// Server errors for the register request, shown under their field.
  String? _usernameServerError;
  String? _emailServerError;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(authRepositoryProvider);
    _emailCheck = AvailabilityCheck(repo.checkEmail)..addListener(_rebuild);
    _usernameCheck = AvailabilityCheck(repo.checkUsername)
      ..addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _emailCheck.dispose();
    _usernameCheck.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _needsExam => ref.read(guestProvider).examTypeId == null;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();

    setState(() => _isLoading = true);
    // Make sure both are checked (e.g. submitted right after typing).
    final results = await Future.wait([
      _emailCheck.ensure(email),
      _usernameCheck.ensure(username),
    ]);
    if (!mounted) return;
    if (results.contains(Availability.taken)) {
      setState(() => _isLoading = false);
      _formKey.currentState!.validate();
      return;
    }

    await ref
        .read(authStateProvider.notifier)
        .register(
          email: email,
          username: username,
          password: _passwordController.text,
          examTypeId: _exam?.id,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final authState = ref.read(authStateProvider);
    if (authState.valueOrNull != null) {
      context.go(Routes.home);
      return;
    }
    final error = authState.error;
    if (error is ApiException) _showRegisterError(error);
  }

  /// 409s name the field in English (docs 3.2); show them in Turkish under
  /// that field. Anything else goes to a snackbar.
  void _showRegisterError(ApiException e) {
    if (e.statusCode == 409 && e.message.contains('Email')) {
      setState(() => _emailServerError = 'Bu e-posta zaten kayıtlı');
    } else if (e.statusCode == 409 && e.message.contains('Username')) {
      setState(() => _usernameServerError = 'Bu kullanıcı adı alınmış');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.isNetworkError
                ? 'İnternet bağlantısı yok. Bağlanınca tekrar dene.'
                : 'Kayıt olunamadı: ${e.message}',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailTaken = _emailCheck.status == Availability.taken;
    final usernameTaken = _usernameCheck.status == Availability.taken;

    return Scaffold(
      appBar: AppBar(leading: const AuthCloseButton(), leadingWidth: 64),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Hesap Oluştur',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Öğrenme yolculuğuna başla',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    prefixIcon: const Icon(Icons.person_outlined),
                    suffixIcon: _statusIcon(_usernameCheck.status),
                    helperText: _usernameCheck.status == Availability.available
                        ? 'Kullanılabilir'
                        : null,
                  ),
                  forceErrorText:
                      _usernameServerError ??
                      (usernameTaken ? 'Bu kullanıcı adı alınmış' : null),
                  onChanged: (v) {
                    // Usernames are lowercase; fix it while typing.
                    final lower = v.toLowerCase();
                    if (lower != v) {
                      _usernameController.value = _usernameController.value
                          .copyWith(text: lower);
                    }
                    _usernameServerError = null;
                    final value = lower.trim();
                    _usernameCheck.onChanged(
                      value,
                      formatValid: _usernameRuleError(value) == null,
                    );
                  },
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Kullanıcı adı gerekli';
                    return _usernameRuleError(v);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIcon: _statusIcon(_emailCheck.status),
                  ),
                  forceErrorText:
                      _emailServerError ??
                      (emailTaken ? 'Bu e-posta zaten kayıtlı' : null),
                  onChanged: (v) {
                    _emailServerError = null;
                    final value = v.trim();
                    _emailCheck.onChanged(
                      value,
                      formatValid: _emailPattern.hasMatch(value),
                    );
                  },
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'E-posta gerekli';
                    if (!_emailPattern.hasMatch(v)) {
                      return 'Geçerli bir e-posta girin';
                    }
                    return null;
                  },
                ),
                if (emailTaken || _emailServerError != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => context.push(Routes.login),
                      child: const Text('Bu hesapla giriş yapmak ister misin?'),
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre gerekli';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalı';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  textInputAction: _needsExam
                      ? TextInputAction.next
                      : TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Şifre Tekrar',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_needsExam) _handleRegister();
                  },
                ),
                if (_needsExam) ...[
                  const SizedBox(height: 16),
                  _ExamField(
                    exam: _exam,
                    onPicked: (exam) => setState(() => _exam = exam),
                  ),
                ],
                const SizedBox(height: 32),
                PbButton(
                  text: 'Kayıt Ol',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Zaten hesabın var mı?'),
                    TextButton(
                      onPressed: () => context.push(Routes.login),
                      child: const Text('Giriş Yap'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kayıt olarak Kullanım Koşulları’nı kabul edersin. Kişisel '
                  'verilerinin nasıl işlendiği Gizlilik ve KVKK metninde.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.grey400),
                ),
                const LegalLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _statusIcon(Availability status) => switch (status) {
    Availability.checking => const Padding(
      padding: EdgeInsets.all(14),
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
    Availability.available => const Padding(
      padding: EdgeInsets.all(12),
      child: PbIcon(PbIcons.check, size: 20),
    ),
    Availability.taken => const Icon(Icons.error, color: AppColors.error),
    Availability.idle || Availability.unknown => null,
  };
}

/// Exam picker (web register steps 2-3): opens a sheet with the active exam
/// groups and their exam types. Required.
class _ExamField extends ConsumerWidget {
  const _ExamField({required this.exam, required this.onPicked});

  final ExamTypeModel? exam;
  final ValueChanged<ExamTypeModel> onPicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormField<ExamTypeModel>(
      initialValue: exam,
      validator: (_) => exam == null ? 'Hazırlandığın sınavı seç' : null,
      builder: (state) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final picked = await _pick(context, ref);
          if (picked == null) return;
          onPicked(picked);
          state.didChange(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Sınav',
            prefixIcon: const Icon(Icons.school_outlined),
            suffixIcon: const Icon(Icons.expand_more),
            errorText: state.errorText,
          ),
          isEmpty: exam == null,
          child: exam == null ? null : Text(exam!.name),
        ),
      ),
    );
  }

  Future<ExamTypeModel?> _pick(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<ExamTypeModel>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final groups = ref.watch(examGroupsProvider);
          return groups.when(
            loading: () => const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(
              height: 160,
              child: Center(child: Text('Sınavlar yüklenemedi.')),
            ),
            data: (groups) => ListView(
              shrinkWrap: true,
              children: [
                for (final group in groups.where((g) => g.isActive)) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                  for (final type in group.examTypes.where((t) => t.isActive))
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      title: Text(type.name),
                      trailing: type.id == exam?.id
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () => Navigator.of(ctx).pop(type),
                    ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
