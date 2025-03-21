// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_async_value_getter_type` rule.
///
/// This rule checks defining `Future<T> Function()` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `Future<T> Function()` with [AsyncValueGetter]
/// which is defined in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final Future<int> Function() callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final AsyncValueGetter<int> callback;
/// ```
///
/// See also:
///
/// - [AsyncValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncValueGetter.html)
class DefinedAsyncValueGetterType extends DartLintRule {
  /// Create a new instance of [DefinedAsyncValueGetterType].
  const DefinedAsyncValueGetterType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_async_value_getter_type',
    problemMessage: '`AsyncValueGetter<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/dassssshers/nilts#defined_async_value_getter_type',
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

      // Do nothing if the return type is not Future<T>.
      final returnType = type.returnType;
      if (returnType is! InterfaceType) return;
      if (!returnType.isDartAsyncFuture) return;
      if (returnType.typeArguments.length != 1) return;
      final typeArgument = returnType.typeArguments.first;
      if (typeArgument is VoidType ||
          typeArgument is InvalidType ||
          typeArgument is NeverType) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAsyncValueGetter(),
      ];
}

class _ReplaceWithAsyncValueGetter extends DartFix {
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
      if (node.type is! FunctionType) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with AsyncValueGetter<T>',
        priority: ChangePriority.replaceWithAsyncValueGetter,
      )
          .addDartFileEdit((builder) {
        final returnType = (node.type! as FunctionType).returnType;
        final returnTypeArgument =
            (returnType as InterfaceType).typeArguments.first;
        final isReturnTypeArgumentNullable =
            returnTypeArgument.nullabilitySuffix == NullabilitySuffix.question;
        final returnTypeArgumentName = returnTypeArgument.element!.name;

        final delta = node.question != null ? -1 : 0;
        final suffix = isReturnTypeArgumentNullable ? '?' : '';
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          'AsyncValueGetter<$returnTypeArgumentName$suffix>',
        );
      });
    });
  }
}
