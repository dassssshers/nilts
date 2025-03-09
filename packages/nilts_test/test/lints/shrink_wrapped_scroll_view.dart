// ignore_for_file: document_ignores
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(),
        ListView(shrinkWrap: false),
        // expect_lint: shrink_wrapped_scroll_view
        ListView(shrinkWrap: true),
        // expect_lint: shrink_wrapped_scroll_view
        ListView.builder(itemBuilder: (_, __) => null, shrinkWrap: true),
        // expect_lint: shrink_wrapped_scroll_view
        ListView.custom(
          childrenDelegate: SliverChildListDelegate([]),
          shrinkWrap: true,
        ),
        // expect_lint: shrink_wrapped_scroll_view
        ListView.separated(
          itemBuilder: (_, __) => null,
          separatorBuilder: (_, __) => const SizedBox.shrink(),
          itemCount: 0,
          shrinkWrap: true,
        ),
        // expect_lint: shrink_wrapped_scroll_view
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          shrinkWrap: true,
        ),
        // expect_lint: shrink_wrapped_scroll_view
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (_, __) => null,
          shrinkWrap: true,
        ),
        // expect_lint: shrink_wrapped_scroll_view
        GridView.custom(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          childrenDelegate: SliverChildListDelegate([]),
          shrinkWrap: true,
        ),
        // expect_lint: shrink_wrapped_scroll_view
        GridView.count(crossAxisCount: 2, shrinkWrap: true),
        // expect_lint: shrink_wrapped_scroll_view
        GridView.extent(maxCrossAxisExtent: 2, shrinkWrap: true),
        // expect_lint: shrink_wrapped_scroll_view
        const CustomScrollView(shrinkWrap: true),
      ],
    );
  }
}
