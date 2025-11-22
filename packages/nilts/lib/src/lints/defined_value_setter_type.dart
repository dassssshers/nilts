// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';

const _description = '`ValueSetter<T>` type is defined in Flutter SDK.';

/// A class for `defined_value_setter_type` rule.
///
/// This rule checks defining `void Function(T)` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** replace `void Function(T)` with [ValueSetter]
/// which is defined in Flutter SDK.
/// If the value has changed, use [ValueChanged] instead.
///
/// **BAD:**
/// ```dart
/// final void Function(int) callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueSetter<int> callback;
/// ```
///
/// See also:
///
/// - [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)
/// - [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)
class DefinedValueSetterType extends AnalysisRule {
  /// Create a new instance of [DefinedValueSetterType].
  DefinedValueSetterType()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'defined_value_setter_type';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Replace with ValueSetter<T>',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addGenericFunctionType(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitGenericFunctionType(GenericFunctionType node) {
    // Do nothing if this is part of a typedef declaration
    if (node.parent is GenericTypeAlias) return;

    final type = node.type;

    // Do nothing if the type is instance of type alias.
    if (type?.alias != null) return;

    // Do nothing if the type is not Function.
    if (type is! FunctionType) return;

    // Do nothing if Function doesn't have exactly one parameter.
    if (type.formalParameters.length != 1) return;

    final param = type.formalParameters.first;
    // Do nothing if the parameter is named or optional.
    if (param.isNamed || param.isOptional) return;

    // Do nothing if the return type is not void.
    final returnType = type.returnType;
    if (returnType is! VoidType) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `defined_value_setter_type` rule.
///
/// This fix replaces `void Function(T)` with `ValueSetter<T>`.
class ReplaceWithValueSetter extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithValueSetter].
  ReplaceWithValueSetter({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithValueSetter',
    FixKindPriority.replaceWithValueSetter,
    'Replace with ValueSetter<T>',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final genericFunctionType = node
        .thisOrAncestorOfType<GenericFunctionType>();
    if (genericFunctionType == null) return;

    final type = genericFunctionType.type;
    if (type?.alias != null) return;
    if (type is! FunctionType) return;
    if (type.formalParameters.length != 1) return;

    final param = type.formalParameters.first;
    if (param.isNamed || param.isOptional) return;

    final returnType = type.returnType;
    if (returnType is! VoidType) return;

    await builder.addDartFileEdit(file, (builder) {
      final paramType = param.type;
      final isParamTypeNullable =
          paramType.nullabilitySuffix == NullabilitySuffix.question;
      final paramTypeName = paramType.element!.name;

      final delta = genericFunctionType.question != null ? -1 : 0;
      final suffix = isParamTypeNullable ? '?' : '';
      builder.addSimpleReplacement(
        SourceRange(
          genericFunctionType.offset,
          genericFunctionType.length + delta,
        ),
        'ValueSetter<$paramTypeName$suffix>',
      );
    });
  }
}
