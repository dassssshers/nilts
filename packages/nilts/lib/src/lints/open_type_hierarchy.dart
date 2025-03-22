import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `open_type_hierarchy` rule.
///
/// This rule checks if the class is not intended to be extended.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** add class modifier to the class declaration.
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
    problemMessage: 'Please add the class modifier to the class declaration.',
    correctionMessage: 'Try adding a class modifier to the class declaration.',
    url: 'https://github.com/dassssshers/nilts#open_type_hierarchy',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
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
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
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
