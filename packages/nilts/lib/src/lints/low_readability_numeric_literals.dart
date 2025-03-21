import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `low_readability_numeric_literals` rule.
///
/// This rule checks numeric literals with 5 or more digits.
///
/// - Target SDK     : >= Flutter 3.27.0 (Dart 3.6.0)
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** using digit separators for numeric literals with 5 or more
/// digits to improve readability.
///
/// **BAD:**
/// ```dart
/// const int value = 123456;
/// ```
///
/// **GOOD:**
/// ```dart
/// const int value = 123_456;
/// ```
///
/// See also:
///
/// - [Digit Separators in Dart 3.6](https://medium.com/dartlang/announcing-dart-3-6-778dd7a80983)
/// - [Built-in types | Dart](https://dart.dev/language/built-in-types#numbers)
class LowReadabilityNumericLiterals extends DartLintRule {
  /// Creates a new instance of [LowReadabilityNumericLiterals].
  const LowReadabilityNumericLiterals() : super(code: _code);

  static const _code = LintCode(
    name: 'low_readability_numeric_literals',
    problemMessage:
        'Numeric literals with 5 or more digits should use digit separators '
        'for better readability.',
    url:
        'https://github.com/dassssshers/nilts#low_readability_numeric_literals',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIntegerLiteral((node) {
      final value = node.value;
      if (value == null) return;

      final literal = node.literal.lexeme;
      if (literal.contains('_')) return;

      if (value.abs() >= 10000) {
        reporter.atNode(node, _code);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddDigitSeparators(),
      ];
}

class _AddDigitSeparators extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addIntegerLiteral((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final value = node.value;
      if (value == null) return;

      final literal = node.literal.lexeme;
      if (literal.contains('_')) return;

      reporter
          .createChangeBuilder(
        message: 'Add digit separators',
        priority: ChangePriority.addDigitSeparators,
      )
          .addDartFileEdit((builder) {
        final newLiteral = _addSeparators(literal);
        builder.addSimpleReplacement(node.sourceRange, newLiteral);
      });
    });
  }

  String _addSeparators(String literal) {
    final buffer = StringBuffer();
    var count = 0;

    for (var i = literal.length - 1; i >= 0; i--) {
      buffer.write(literal[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('_');
        count = 0;
      }
    }

    return buffer.toString().split('').reversed.join();
  }
}
