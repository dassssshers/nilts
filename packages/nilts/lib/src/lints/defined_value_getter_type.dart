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

const _description = '`ValueGetter<T>` type is defined in Flutter SDK.';

/// A class for `defined_value_getter_type` rule.
///
/// This rule checks defining `T Function()` type.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// **Consider** replace `T Function()` with [ValueGetter] which is defined
/// in Flutter SDK.
///
/// **BAD:**
/// ```dart
/// final int Function() callback;
/// ```
///
/// **GOOD:**
/// ```dart
/// final ValueGetter<int> callback;
/// ```
///
/// See also:
///
/// - [ValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueGetter.html)
class DefinedValueGetterType extends AnalysisRule {
  /// Create a new instance of [DefinedValueGetterType].
  DefinedValueGetterType()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'defined_value_getter_type';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
    correctionMessage: 'Replace with ValueGetter<T>',
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

    // Do nothing if Function has parameters.
    if (type.formalParameters.isNotEmpty) return;

    // Do nothing if the return type is void, InvalidType, NeverType, or Future.
    final returnType = type.returnType;
    if (returnType is VoidType ||
        returnType is InvalidType ||
        returnType is NeverType ||
        returnType.isDartAsyncFuture) {
      return;
    }

    rule.reportAtNode(node);
  }
}

/// A class for fixing `defined_value_getter_type` rule.
///
/// This fix replaces `T Function()` with `ValueGetter<T>`.
class ReplaceWithValueGetter extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithValueGetter].
  ReplaceWithValueGetter({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithValueGetter',
    FixKindPriority.replaceWithValueGetter,
    'Replace with ValueGetter<T>',
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
    if (type.formalParameters.isNotEmpty) return;

    final returnType = type.returnType;
    if (returnType is VoidType ||
        returnType is InvalidType ||
        returnType is NeverType ||
        returnType.isDartAsyncFuture) {
      return;
    }

    await builder.addDartFileEdit(file, (builder) {
      final isReturnTypeNullable =
          returnType.nullabilitySuffix == NullabilitySuffix.question;
      final returnTypeName = returnType.element!.name;

      final delta = genericFunctionType.question != null ? -1 : 0;
      final suffix = isReturnTypeNullable ? '?' : '';
      builder.addSimpleReplacement(
        SourceRange(
          genericFunctionType.offset,
          genericFunctionType.length + delta,
        ),
        'ValueGetter<$returnTypeName$suffix>',
      );
    });
  }
}
