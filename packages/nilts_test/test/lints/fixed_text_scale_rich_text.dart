// ignore_for_file: document_ignores
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // expect_lint: fixed_text_scale_rich_text
        RichText(text: const TextSpan(text: 'Hello World!')),
        RichText(
          text: const TextSpan(text: 'Hello World!'),
          textScaler: MediaQuery.textScalerOf(context),
        ),
        RichText(
          text: const TextSpan(text: 'Hello World!'),
          textScaleFactor: MediaQuery.textScaleFactorOf(context),
        ),
      ],
    );
  }
}
