import 'package:flutter/material.dart';
import 'package:support/core/widgets/custom_rounded_button.dart';

class ContinueSignButton extends StatelessWidget {
  const ContinueSignButton({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: customRoundedButton(
          text: "Continue",
          backgroundColor: theme.colorScheme.primary,
          borderColor: Colors.transparent,
          padding: const EdgeInsets.only(left: 20, right: 20),
          onPressed: onPressed,
          foregroundColor: Colors.white),
    );
  }
}
