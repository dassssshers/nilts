import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';

const _description = 'Do not force type casting with !';

/// A class for `unsafe_null_assertion` rule.
///
/// This rule checks if `!` operator is used to force type casting a value.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// **Prefer** using if-null operator, null-aware operator or pattern matching
/// instead of force type casting with `!` operator.
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
/// final value = someValue?.someMethod();
/// ```
///
/// **GOOD:**
/// ```dart
/// if (someValue case final value?) return value;
/// ```
///
/// See also:
///
/// - [Operators | Dart](https://dart.dev/language/operators)
/// - [Patterns | Dart](https://dart.dev/language/patterns)
class UnsafeNullAssertion extends AnalysisRule {
  /// Create a new instance of [UnsafeNullAssertion].
  UnsafeNullAssertion()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'unsafe_null_assertion';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Replace with null-safe operator',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addPostfixExpression(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitPostfixExpression(PostfixExpression node) {
    if (node.operator.type == TokenType.BANG) {
      rule.reportAtToken(node.operator);
    }
  }
}

/// A class for fixing `unsafe_null_assertion` rule.
///
/// This fix replaces `value!` with `(value ?? )`.
class ReplaceWithIfNullOperator extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithIfNullOperator].
  ReplaceWithIfNullOperator({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithIfNullOperator',
    FixKindPriority.replaceWithIfNullOperator,
    'Replace with if-null operator',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final postfixExpression = node.thisOrAncestorOfType<PostfixExpression>();
    if (postfixExpression == null) return;
    if (postfixExpression.operator.type != TokenType.BANG) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        SourceRange(
          postfixExpression.offset,
          postfixExpression.length,
        ),
        '(${postfixExpression.operand} ?? )',
      );
    });
  }
}

/// A class for fixing `unsafe_null_assertion` rule.
///
/// This fix replaces `value!.method()` with `value?.method()`.
class ReplaceWithNullAwareOperator extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithNullAwareOperator].
  ReplaceWithNullAwareOperator({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithNullAwareOperator',
    FixKindPriority.replaceWithNullAwareOperator,
    'Replace with null-aware operator',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final postfixExpression = node.thisOrAncestorOfType<PostfixExpression>();
    if (postfixExpression == null) return;
    if (postfixExpression.operator.type != TokenType.BANG) return;

    final parent = postfixExpression.parent;
    if (parent is! PropertyAccess && parent is! MethodInvocation) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        SourceRange(
          postfixExpression.offset,
          postfixExpression.length,
        ),
        '${postfixExpression.operand}?',
      );
    });
  }
}

/// A class for fixing `unsafe_null_assertion` rule.
///
/// This fix replaces `value!` with `if (value case final value?) return value`.
class ReplaceWithPatternMatching extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithPatternMatching].
  ReplaceWithPatternMatching({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithPatternMatching',
    FixKindPriority.replaceWithPatternMatching,
    'Replace with pattern matching',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final postfixExpression = node.thisOrAncestorOfType<PostfixExpression>();
    if (postfixExpression == null) return;
    if (postfixExpression.operator.type != TokenType.BANG) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        SourceRange(
          postfixExpression.offset,
          postfixExpression.length,
        ),
        'if (${postfixExpression.operand} case final value?) return value',
      );
    });
  }
}
