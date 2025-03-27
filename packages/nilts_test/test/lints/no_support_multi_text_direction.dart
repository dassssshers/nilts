// ignore_for_file: document_ignores
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

final class Alignments extends StatelessWidget {
  const Alignments({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Align(
          // expect_lint: no_support_multi_text_direction
          alignment: Alignment.bottomLeft,
        ),
        Align(
          // expect_lint: no_support_multi_text_direction
          alignment: Alignment.bottomRight,
        ),
        Align(
          // expect_lint: no_support_multi_text_direction
          alignment: Alignment.centerLeft,
        ),
        Align(
          // expect_lint: no_support_multi_text_direction
          alignment: Alignment.centerRight,
        ),
        Align(
          // expect_lint: no_support_multi_text_direction
          alignment: Alignment.topLeft,
        ),
        Align(
          // expect_lint: no_support_multi_text_direction
          alignment: Alignment.topRight,
        ),
        Align(alignment: Alignment.bottomCenter),
        Align(alignment: Alignment.center),
        Align(alignment: Alignment.topCenter),
        Align(alignment: Alignment(12, 12)),
      ],
    );
  }
}

final class Insets extends StatelessWidget {
  const Insets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          // expect_lint: no_support_multi_text_direction
          padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
        ),
        const Padding(
          // expect_lint: no_support_multi_text_direction
          padding: EdgeInsets.only(left: 12),
        ),
        const Padding(
          // expect_lint: no_support_multi_text_direction
          padding: EdgeInsets.only(right: 12),
        ),
        const Padding(
          // expect_lint: no_support_multi_text_direction
          padding: EdgeInsets.only(top: 16, right: 12),
        ),
        const Padding(padding: EdgeInsets.all(12)),
        Padding(
          padding: EdgeInsets.fromViewPadding(View.of(context).padding, 0),
        ),
        const Padding(padding: EdgeInsets.only(top: 16, bottom: 12)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
      ],
    );
  }
}

final class Positions extends StatelessWidget {
  const Positions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // expect_lint: no_support_multi_text_direction
        const Positioned(left: 12, child: SizedBox()),
        // expect_lint: no_support_multi_text_direction
        const Positioned(right: 12, child: SizedBox()),
        // expect_lint: no_support_multi_text_direction
        const Positioned(top: 16, right: 12, child: SizedBox()),
        // expect_lint: no_support_multi_text_direction
        const Positioned.fill(left: 12, child: SizedBox()),
        // expect_lint: no_support_multi_text_direction
        const Positioned.fill(right: 12, child: SizedBox()),
        // expect_lint: no_support_multi_text_direction
        const Positioned.fill(top: 16, right: 12, child: SizedBox()),
        const Positioned(top: 16, child: SizedBox()),
        Positioned.directional(
          start: 12,
          textDirection: TextDirection.ltr,
          child: const SizedBox(),
        ),
        const Positioned.fill(top: 16, child: SizedBox()),
        Positioned.fromRect(
          rect: const Rect.fromLTRB(12, 16, 12, 16),
          child: const SizedBox(),
        ),
        Positioned.fromRelativeRect(
          rect: const RelativeRect.fromLTRB(12, 16, 12, 16),
          child: const SizedBox(),
        ),
      ],
    );
  }
}
