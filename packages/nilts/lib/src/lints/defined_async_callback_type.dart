// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_async_callback_type` rule.
///
/// This rule checks defining `Future<void> Function()` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `Future<void> Function()` with [AsyncCallback] which is
/// defined in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final Future<void> Function() callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final AsyncCallback callback;
/// ```
///
/// See also:
///
/// - [AsyncCallback typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncCallback.html)
class DefinedAsyncCallbackType extends DartLintRule {
  /// Create a new instance of [DefinedAsyncCallbackType].
  const DefinedAsyncCallbackType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_async_callback_type',
    problemMessage: '`AsyncCallback` type is defined in Flutter SDK.',
    url: 'https://github.com/dassssshers/nilts#defined_async_callback_type',
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

      // Do nothing if the return type is not Future<void>.
      final returnType = type.returnType;
      if (returnType is! InterfaceType) return;
      if (!returnType.isDartAsyncFuture) return;
      if (returnType.typeArguments.length != 1) return;
      if (returnType.typeArguments.first is! VoidType) return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAsyncCallbackType(),
      ];
}

class _ReplaceWithAsyncCallbackType extends DartFix {
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
        message: 'Replace with AsyncCallback',
        priority: ChangePriority.replaceWithAsyncCallback,
      )
          .addDartFileEdit((builder) {
        final delta = node.question != null ? -1 : 0;
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          'AsyncCallback',
        );
      });
    });
  }
}
