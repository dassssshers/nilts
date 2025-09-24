import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `open_type_hierarchy` rule.
///
/// This rule checks if the class is intended to be neither extended nor
/// implemented.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** adding a class modifier (final, sealed, etc.) to explicitly
/// define the inheritance policy of your class.
///
/// **BAD:**
/// ```dart
/// class MyClass {}
/// ```
///
/// **GOOD:**
/// ```dart
/// final class MyClass {}
/// ```
class OpenTypeHierarchy extends DartLintRule {
  /// Create a new instance of [OpenTypeHierarchy].
  const OpenTypeHierarchy() : super(code: _code);

  static const _code = LintCode(
    name: 'open_type_hierarchy',
    problemMessage:
        'This class is intended to be neither extended nor implemented.',
    correctionMessage: 'Try adding class modifiers to the class declaration.',
    url: 'https://github.com/dassssshers/nilts#open_type_hierarchy',
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      if (node.classKeyword.previous?.keyword != null) return;

      reporter.atToken(
        node.name,
        _code,
      );
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddFinalKeyword(),
      ];
}

class _AddFinalKeyword extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    Diagnostic analysisError,
    List<Diagnostic> others,
  ) {
    context.registry.addClassDeclaration((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      reporter
          .createChangeBuilder(
        message: 'Add final keyword',
        priority: ChangePriority.addFinalKeyword,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.classKeyword.offset,
          'final ',
        );
      });
    });
  }
}
