// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_async_value_setter_type` rule.
///
/// This rule checks defining `Future<void> Function(T value)` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `Future<void> Function(T value)` with
/// [AsyncValueSetter] which is defined in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final Future<void> Function(int value) callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final AsyncValueSetter<int> callback;
/// ```
///
/// See also:
///
/// - [AsyncValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncValueSetter.html)
class DefinedAsyncValueSetterType extends DartLintRule {
  /// Create a new instance of [DefinedAsyncValueSetterType].
  const DefinedAsyncValueSetterType() : super(code: _code);

  static const _code = LintCode(
    name: 'defined_async_value_setter_type',
    problemMessage: '`AsyncValueSetter<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/dassssshers/nilts#defined_async_value_setter_type',
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

      // Do nothing if Function doesn't have a parameter.
      if (type.parameters.length != 1) return;

      final param = type.parameters.first;
      // Do nothing if the parameter is named or optional.
      if (param.isNamed || param.isOptional) return;

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
        _ReplaceWithAsyncValueSetter(),
      ];
}

class _ReplaceWithAsyncValueSetter extends DartFix {
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
        message: 'Replace with AsyncValueSetter<T>',
        priority: ChangePriority.replaceWithAsyncValueSetter,
      )
          .addDartFileEdit((builder) {
        final paramType = (node.type! as FunctionType).parameters.first.type;
        final isParamTypeNullable =
            paramType.nullabilitySuffix == NullabilitySuffix.question;
        final paramTypeName = paramType.element!.displayName;

        final delta = node.question != null ? -1 : 0;
        final suffix = isParamTypeNullable ? '?' : '';
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          'AsyncValueSetter<$paramTypeName$suffix>',
        );
      });
    });
  }
}
