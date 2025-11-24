import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';

const _description =
    'Numeric literals with 5 or more digits should use digit separators for '
    'better readability.';

/// A class for `low_readability_numeric_literals` rule.
///
/// This rule checks numeric literals with 5 or more digits.
///
/// - Target SDK     : >= Flutter 3.27.0 (Dart 3.6.0)
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
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
class LowReadabilityNumericLiterals extends AnalysisRule {
  /// Creates a new instance of [LowReadabilityNumericLiterals].
  LowReadabilityNumericLiterals()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'low_readability_numeric_literals';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addIntegerLiteral(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    final value = node.value;
    if (value == null) return;

    final literal = node.literal.lexeme;
    if (literal.contains('_')) return;

    if (value.abs() >= 10000) {
      rule.reportAtNode(node);
    }
  }
}

/// A class for fixing `low_readability_numeric_literals` rule.
///
/// This fix adds digit separators to numeric literals.
class AddDigitSeparators extends ResolvedCorrectionProducer {
  /// Create a new instance of [AddDigitSeparators].
  AddDigitSeparators({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.addDigitSeparators',
    FixKindPriority.addDigitSeparators,
    'Add digit separators',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! IntegerLiteral) return;
    final integerLiteral = node as IntegerLiteral;

    final value = integerLiteral.value;
    if (value == null) return;

    final literal = integerLiteral.literal.lexeme;
    if (literal.contains('_')) return;

    await builder.addDartFileEdit(file, (builder) {
      final newLiteral = _addSeparators(literal);
      builder.addSimpleReplacement(
        SourceRange(integerLiteral.offset, integerLiteral.length),
        newLiteral,
      );
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
