import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A class for `final_defined_class` rule.
///
/// This rule checks if the class is not intended to be extended.
///
/// - Target SDK     : >= Flutter 3.10.0 (Dart 3.0.0)
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** add `final` keyword to the class declaration.
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
final class FinalDefinedClass extends DartLintRule {
  /// Create a new instance of [FinalDefinedClass].
  const FinalDefinedClass() : super(code: _code);

  static const _code = LintCode(
    name: 'final_defined_class',
    problemMessage: 'Please add the final keyword to the class declaration.',
    correctionMessage: 'Try adding the final keyword to the class declaration.',
    url: 'https://github.com/dassssshers/nilts#prefer_final_class',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      if (node.sealedKeyword != null ||
          node.abstractKeyword != null ||
          node.finalKeyword != null ||
          node.baseKeyword != null ||
          node.interfaceKeyword != null ||
          node.mixinKeyword != null) {
        return;
      }

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

final class _AddFinalKeyword extends DartFix {
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
        priority: 100,
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
