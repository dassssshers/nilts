import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

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
class UnstableEnumName extends DartLintRule {
  /// Create a new instance of [UnstableEnumName].
  const UnstableEnumName() : super(code: _code);

  static const _code = LintCode(
    name: 'unstable_enum_name',
    problemMessage: 'enum name property is unstable',
    url: 'https://github.com/dassssshers/nilts#unstable_enum_name',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPropertyAccess((node) {
      // FIXME: migrate when upgrade to analyzer 7.4.0 or later
      // https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/doc/element_model_migration_guide.md
      // ignore: deprecated_member_use
      if (node.target?.staticType?.element is! EnumElement) return;
      if (node.propertyName.name != 'name') return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [];
}
