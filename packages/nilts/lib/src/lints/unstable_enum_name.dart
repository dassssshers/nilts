import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

const _description = 'enum name property is unstable';

/// A class for `unstable_enum_name` rule.
///
/// This rule checks if `name` property is used to get from an enum value.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ❌
///
/// **Consider** using a more stable way to handle enum values.
/// The `name` property is a string representation of the enum value,
/// which can be changed without breaking the code.
///
/// **BAD:**
/// ```dart
/// enum Color { red, green, blue }
///
/// void printColorValue(Color color) {
///   print(color.name); // 'red', 'green', 'blue'
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// enum Color {
///   red,
///   green,
///   blue,
///   ;
///
///   String get id => switch (this) {
///     red => 'red',
///     green => 'green',
///     blue => 'blue',
///   };
/// }
///
/// void printColorValue(Color color) {
///   print(color.id);
/// }
/// ```
///
/// See also:
///
/// - [Enums | Dart](https://dart.dev/language/enums)
class UnstableEnumName extends AnalysisRule {
  /// Create a new instance of [UnstableEnumName].
  UnstableEnumName()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'unstable_enum_name';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Use a custom getter instead of enum.name',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry
      ..addPropertyAccess(this, visitor)
      ..addPrefixedIdentifier(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.target?.staticType?.element is! EnumElement) return;
    if (node.propertyName.name != 'name') return;

    rule.reportAtNode(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.prefix.staticType?.element is! EnumElement) return;
    if (node.identifier.name != 'name') return;

    rule.reportAtNode(node);
  }
}
