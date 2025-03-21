// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `defined_value_changed_type` rule.
///
/// This rule checks defining `void Function(T value)` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function(T value)` with [ValueChanged]
/// which is defined in Flutter SDK.
/// If the value has been set, use [ValueSetter] instead.
///
/// **BAD:**
/// ```dart
/// final void Function(int value) callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueChanged<int> callback;
/// ```
///
/// See also:
///
/// - [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)
/// - [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)
class DefinedValueChangedType extends _DefinedValueCallbackType {
  /// Create a new instance of [DefinedValueChangedType].
  const DefinedValueChangedType() : super(_code);

  static const _code = LintCode(
    name: 'defined_value_changed_type',
    problemMessage: '`ValueChanged<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/dassssshers/nilts#defined_value_changed_type',
  );

  @override
  List<Fix> getFixes() => [
        _ReplaceWithValueChanged(),
      ];
}

/// A class for `defined_value_setter_type` rule.
///
/// This rule checks defining `void Function(T value)` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function(T value)` with [ValueSetter]
/// which is defined in Flutter SDK.
/// If the value has changed, use [ValueChanged] instead.
///
/// **BAD:**
/// ```dart
/// final void Function(int value) callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueSetter<int> callback;
/// ```
///
/// See also:
///
///   - [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)
///   - [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)
class DefinedValueSetterType extends _DefinedValueCallbackType {
  /// Create a new instance of [DefinedValueSetterType].
  const DefinedValueSetterType() : super(_code);

  static const _code = LintCode(
    name: 'defined_value_setter_type',
    problemMessage: '`ValueSetter<T>` type is defined in Flutter SDK.',
    url: 'https://github.com/dassssshers/nilts#defined_value_setter_type',
  );

  @override
  List<Fix> getFixes() => [
        _ReplaceWithValueSetter(),
      ];
}

class _ReplaceWithValueChanged extends _ReplaceWithValueCallbackType {
  _ReplaceWithValueChanged()
      : super(
          'ValueChanged',
          ChangePriority.replaceWithValueChanged,
        );
}

class _ReplaceWithValueSetter extends _ReplaceWithValueCallbackType {
  _ReplaceWithValueSetter()
      : super(
          'ValueSetter',
          ChangePriority.replaceWithValueSetter,
        );
}

class _DefinedValueCallbackType extends DartLintRule {
  const _DefinedValueCallbackType(LintCode code)
      : _lintCode = code,
        super(code: code);

  final LintCode _lintCode;

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

      // Do nothing if the return type is not void.
      final returnType = type.returnType;
      if (returnType is! VoidType) return;

      reporter.atNode(node, _lintCode);
    });
  }
}

class _ReplaceWithValueCallbackType extends DartFix {
  _ReplaceWithValueCallbackType(
    this._typeName,
    this._changePriority,
  );

  final String _typeName;
  final int _changePriority;

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
        message: 'Replace with $_typeName<T>',
        priority: _changePriority,
      )
          .addDartFileEdit((builder) {
        final paramType = (node.type! as FunctionType).parameters.first.type;
        final isSuffixNullable =
            paramType.nullabilitySuffix == NullabilitySuffix.question;
        final paramTypeName = paramType.element!.displayName;

        final delta = node.question != null ? -1 : 0;
        final suffix = isSuffixNullable ? '?' : '';
        builder.addSimpleReplacement(
          node.sourceRange.getMoveEnd(delta),
          '$_typeName<$paramTypeName$suffix>',
        );
      });
    });
  }
}
