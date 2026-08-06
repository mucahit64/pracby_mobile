import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

class PbButton extends StatelessWidget {
  const PbButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(),
      );
    }
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      );
    }
    return Text(text);
  }
}
