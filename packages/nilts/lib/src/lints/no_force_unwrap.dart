import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `no_force_unwrap` rule.
///
/// This rule checks if `!` operator is used to force unwrap a value.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅ (pattern matching is available on Dart 3.0.0 and above)
///
/// **Consider** using null coalescing operator or pattern matching instead of
/// force unwrapping.
///
/// **BAD:**
/// ```dart
/// final value = someValue!;
/// ```
///
/// **GOOD:**
/// ```dart
/// final value = someValue ?? /* default value */;
/// ```
///
/// **GOOD:**
/// ```dart
/// if (someValue case final value?) return value;
/// ```
///
/// See also:
///
/// - [Null coalescing operator - Dart language specification](https://dart.dev/language/operators#null-coalescing-operator)
/// - [Pattern matching - Dart language specification](https://dart.dev/language/patterns)
class NoForceUnwrap extends DartLintRule {
  /// Create a new instance of [NoForceUnwrap].
  const NoForceUnwrap() : super(code: _code);

  static const _code = LintCode(
    name: 'no_force_unwrap',
    problemMessage: 'Do not force unwrap',
    url: 'https://github.com/dassssshers/nilts#no_force_unwrap',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPostfixExpression((node) {
      if (node.operator.type == TokenType.BANG) {
        reporter.atToken(node.operator, _code);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddNullCoalescingOperator(),
        _ReplaceWithPatternMatching(),
      ];
}

class _AddNullCoalescingOperator extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addPostfixExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;
      if (node.operator.type != TokenType.BANG) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with null coalescing operator',
        priority: ChangePriority.addNullCoalescingOperator,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          node.sourceRange,
          '(${node.operand} ?? )',
        );
      });
    });
  }
}

class _ReplaceWithPatternMatching extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addPostfixExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;
      if (node.operator.type != TokenType.BANG) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with pattern matching',
        priority: ChangePriority.addPatternMatching,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          node.sourceRange,
          'if (${node.operand} case final value?) return value',
        );
      });
    });
  }
}
