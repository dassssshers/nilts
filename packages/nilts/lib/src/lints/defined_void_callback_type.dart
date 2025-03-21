// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_void_callback_type` rule.
///
/// This rule checks defining `void Function()` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function()` with [VoidCallback] which is defined
/// in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final void Function() callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final VoidCallback callback;
/// ```
///
/// See also:
///
/// - [VoidCallback typedef - dart:ui library - Dart API](https://api.flutter.dev/flutter/dart-ui/VoidCallback.html)
class DefinedVoidCallbackType extends DartLintRule {
  /// Create a new instance of [DefinedVoidCallbackType].
  const DefinedVoidCallbackType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_void_callback_type',
    problemMessage: '`VoidCallback` type is defined in Flutter SDK.',
    url: 'https://github.com/dassssshers/nilts#defined_void_callback_type',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addTypeAnnotation((node) {
      final type = node.type;

      // Do nothing if the type is instance of type alias.
      if (type?.alias != null) return;

      // Do nothing if the type is not Function.
      if (type is! FunctionType) return;

      // Do nothing if Function has parameters.
      if (type.parameters.isNotEmpty) return;

      // Do nothing if the return type is not void.
      final returnType = type.returnType;
      if (returnType is! VoidType) return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithVoidCallbackType(),
      ];
}

class _ReplaceWithVoidCallbackType extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addTypeAnnotation((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with VoidCallback',
        priority: ChangePriority.replaceWithVoidCallback,
      )
          .addDartFileEdit((builder) {
        final delta = node.question != null ? -1 : 0;
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          'VoidCallback',
        );
      });
    });
  }
}
