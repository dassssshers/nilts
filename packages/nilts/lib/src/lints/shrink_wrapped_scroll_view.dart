// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';
import 'package:nilts_core/nilts_core.dart';

/// A class for `shrink_wrapped_scroll_view` rule.
///
/// This rule checks if the content of the scroll view is shrink wrapped.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** removing `shrinkWrap` argument and update the Widget not to
/// shrink wrap.
/// Shrink wrapping the content of the scroll view is
/// significantly more expensive than expanding to the maximum allowed size
/// because the content can expand and contract during scrolling,
/// which means the size of the scroll view needs to be recomputed
/// whenever the scroll position changes.
///
/// You can avoid shrink wrap with 3 steps below
/// in case of your scroll view is nested.
///
/// 1. Replace the parent scroll view with [CustomScrollView].
/// 2. Replace the child scroll view with [SliverListView] or [SliverGridView].
/// 3. Set [SliverChildBuilderDelegate] to `delegate` argument of
/// [SliverListView] or [SliverGridView].
///
/// **BAD:**
/// ```dart
/// ListView(shrinkWrap: true)
/// ```
///
/// **GOOD:**
/// ```dart
/// ListView(shrinkWrap: false)
/// ```
///
/// See also:
///
/// - [shrinkWrap property - ScrollView class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/ScrollView/shrinkWrap.html)
/// - [ShrinkWrap vs Slivers | Decoding Flutter - YouTube](https://youtu.be/LUqDNnv_dh0)
class ShrinkWrappedScrollView extends DartLintRule {
  /// Create a new instance of [ShrinkWrappedScrollView].
  const ShrinkWrappedScrollView() : super(code: _code);

  static const _code = LintCode(
    name: 'shrink_wrapped_scroll_view',
    problemMessage: 'Shrink wrapping the content of the scroll view is '
        'significantly more expensive than '
        'expanding to the maximum allowed size.',
    url: 'https://github.com/dassssshers/nilts#shrink_wrapped_scroll_view',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final constructorName = node.constructorName;
      final library = constructorName.staticElement?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the constructor is not sub class of `ScrollView`.
      if (!_scrollViewSubClasses.contains(constructorName.type.element?.name)) {
        return;
      }

      // Do nothing if the constructor doesn't have `shrinkWrap` argument.
      final arguments = node.argumentList.arguments;
      final isShrinkWrapSet = arguments.any(
        (argument) =>
            argument is NamedExpression &&
            argument.name.label.name == 'shrinkWrap',
      );
      if (!isShrinkWrapSet) return;

      // Do nothing if `shrinkWrap: true` is not set.
      final isShrinkWrapped = arguments.any(
        (argument) =>
            argument is NamedExpression &&
            argument.name.label.name == 'shrinkWrap' &&
            argument.expression is BooleanLiteral &&
            (argument.expression as BooleanLiteral).value,
      );
      if (!isShrinkWrapped) return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _RemoveShrinkWrapArgument(),
      ];
}

class _RemoveShrinkWrapArgument extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the constructor is not sub class of `ScrollView`.
      final constructorName = node.constructorName;
      if (!_scrollViewSubClasses.contains(constructorName.type.element?.name)) {
        return;
      }

      reporter
          .createChangeBuilder(
        message: 'Remove shrinkWrap',
        priority: ChangePriority.removeShrinkWrap,
      )
          .addDartFileEdit((builder) {
        final arguments = node.argumentList.arguments;
        final argument = arguments.firstWhere(
          (argument) =>
              argument is NamedExpression &&
              argument.name.label.name == 'shrinkWrap',
        );
        builder.addDeletion(argument.sourceRange);
      });
    });
  }
}

const _scrollViewSubClasses = [
  'ListView',
  'GridView',
  'CustomScrollView',
];
