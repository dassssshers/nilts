import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

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
class UnstableEnumValues extends DartLintRule {
  /// Create a new instance of [UnstableEnumValues].
  const UnstableEnumValues() : super(code: _code);

  static const _code = LintCode(
    name: 'unstable_enum_values',
    problemMessage: 'enum values property is unstable',
    url: 'https://github.com/dassssshers/nilts#unstable_enum_values',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPrefixedIdentifier((node) {
      final staticElement = node.prefix.staticElement;
      if (staticElement is! EnumElement) return;
      if (!staticElement.isPublic) return;
      if (node.identifier.name != 'values') return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [];
}
