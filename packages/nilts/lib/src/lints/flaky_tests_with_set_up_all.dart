// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';
import 'package:nilts_core/nilts_core.dart';

/// A class for `flaky_tests_with_set_up_all` rule.
///
/// This rule checks if [setUpAll] is used.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** using [setUp] function or
/// initialization on top level or body of test group.
/// [setUpAll] may cause flaky tests with concurrency executions.
///
/// **BAD:**
/// ```dart
/// setUpAll(() {
///   // ...
/// });
/// ```
///
/// **GOOD:**
/// ```dart
/// setUp(() {
///   // ...
/// });
/// ```
///
/// ```dart
/// void main() {
///   // do initialization on top level
///   // ...
///
///  group('...', () {
///   // or do initialization on body of test group
///   // ...
///  });
/// }
/// ```
///
/// See also:
///
/// - [setUpAll function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUpAll.html)
/// - [setUp function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUp.html)
class FlakyTestsWithSetUpAll extends DartLintRule {
  /// Create a new instance of [FlakyTestsWithSetUpAll].
  const FlakyTestsWithSetUpAll() : super(code: _code);

  static const _code = LintCode(
    name: 'flaky_tests_with_set_up_all',
    problemMessage:
        '`setUpAll` may cause flaky tests with concurrency executions.',
    url: 'https://github.com/dassssshers/nilts#flaky_tests_with_set_up_all',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      // Do nothing if the method name is not `setUpAll`.
      final methodName = node.methodName;
      if (methodName.name != 'setUpAll') return;

      // Do nothing if the method argument's type is not `Function`.
      final arguments = node.argumentList.arguments;
      if (arguments.length != 1) return;
      final firstArgument = node.argumentList.arguments.first.staticType;
      if (firstArgument == null) return;
      if (firstArgument is! FunctionType) return;

      // Do nothing if the package of method is not `flutter_test`.
      final library = methodName.staticElement?.library;
      if (library == null) return;
      if (!library.isFlutterTest) return;

      reporter.atNode(node.methodName, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithSetUp(),
        _UnwrapSetUpAll(),
      ];
}

class _ReplaceWithSetUp extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the method name is not `setUpAll`.
      final methodName = node.methodName;
      if (methodName.name != 'setUpAll') return;

      reporter
          .createChangeBuilder(
        message: 'Replace With setUp',
        priority: ChangePriority.replaceWithSetUp,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(node.methodName.sourceRange, 'setUp');
      });
    });
  }
}

class _UnwrapSetUpAll extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the method name is not `setUpAll`.
      final methodName = node.methodName;
      if (methodName.name != 'setUpAll') return;

      reporter
          .createChangeBuilder(
        message: 'Unwrap setUpAll',
        priority: ChangePriority.unwrapSetUpAll,
      )
          .addDartFileEdit((builder) {
        final arguments = node.argumentList;
        final functionArgument = arguments.arguments.first;
        // Do nothing if the function argument is not `Function`.
        if (functionArgument is! FunctionExpression) return;

        final parameters = functionArgument.parameters;
        final typeParameters = functionArgument.typeParameters;
        final functionBody = functionArgument.body;
        final star = functionBody.star;
        final keyword = functionBody.keyword;

        // Delete `);`.
        builder
          ..addDeletion(SourceRange(node.endToken.end, 1))
          ..addDeletion(node.endToken.sourceRange);

        if (functionBody is BlockFunctionBody) {
          // Delete `{` and `}`.
          builder
            ..addDeletion(functionBody.block.leftBracket.sourceRange)
            ..addDeletion(functionBody.block.rightBracket.sourceRange);
        } else if (functionBody is ExpressionFunctionBody) {
          // Delete `=>`.
          builder.addDeletion(functionBody.functionDefinition.sourceRange);
        }

        // Delete `*`.
        if (star != null) {
          builder.addDeletion(star.sourceRange);
        }
        // Delete `async`.
        if (keyword != null) {
          builder.addDeletion(keyword.sourceRange);
        }
        // Delete `(...)`.
        if (parameters != null) {
          builder.addDeletion(parameters.sourceRange);
        }
        // Delete `<...>`.
        if (typeParameters != null) {
          builder.addDeletion(typeParameters.sourceRange);
        }
        // Delete `(`.
        builder.addDeletion(
          node.methodName.sourceRange.getMoveEnd(
            node.argumentList.leftParenthesis.length,
          ),
        );
      });
    });
  }
}
