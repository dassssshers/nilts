import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

const _description = 'enum values property is unstable';

/// A class for `unstable_enum_values` rule.
///
/// This rule checks if `values` property is used to get from enum values.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ❌
///
/// **Consider** using a more stable way to handle enum values.
/// The `values` property returns a mutable List, which can be modified
/// and may cause unexpected behavior.
///
/// **BAD:**
/// ```dart
/// enum Color { red, green, blue }
///
/// void printColors() {
///   for (final color in Color.values) {
///     print(color);
///   }
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// enum Color { red, green, blue }
///
/// void printColors() {
///   final colors = [Color.red, Color.green, Color.blue];
///   for (final color in colors) {
///     print(color);
///   }
/// }
/// ```
///
/// See also:
///
/// - [Enums | Dart](https://dart.dev/language/enums)
class UnstableEnumValues extends AnalysisRule {
  /// Create a new instance of [UnstableEnumValues].
  UnstableEnumValues()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'unstable_enum_values';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Use a custom list instead of enum.values',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addPrefixedIdentifier(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    final staticElement = node.prefix.element;
    if (staticElement is! EnumElement) return;
    if (!staticElement.isPublic) return;
    if (node.identifier.name != 'values') return;

    rule.reportAtNode(node);
  }
}
