// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';
import 'package:nilts_core/nilts_core.dart';

const _description =
    'This configuration is not affected by changes of `TextDirection`.';

/// A class for `no_support_multi_text_direction` rule.
///
/// This rule checks if supports `TextDirection` changes.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** using `TextDirection` aware configurations if your application
/// supports different `TextDirection` languages.
///
/// **BAD:**
/// ```dart
/// Align(
///   alignment: Alignment.bottomLeft,
/// )
/// ```
///
/// **BAD:**
/// ```dart
/// Padding(
///   padding: EdgeInsets.only(left: 16, right: 4),
/// )
/// ```
///
/// **BAD:**
/// ```dart
/// Positioned(left: 12, child: SizedBox())
/// ```
///
/// **GOOD:**
/// ```dart
/// Align(
///   alignment: AlignmentDirectional.bottomStart,
/// )
/// ```
///
/// **GOOD:**
/// ```dart
/// Padding(
///   padding: EdgeInsetsDirectional.only(start: 16, end: 4),
/// )
/// ```
///
/// **GOOD:**
/// ```dart
/// Positioned.directional(
///   start: 12,
///   textDirection: TextDirection.ltr,
///   child: SizedBox(),
/// )
///
/// PositionedDirectional(
///   start: 12,
///   child: SizedBox(),
/// )
/// ```
///
/// See also:
///
/// - [TextDirection enum - dart:ui library - Dart API](https://api.flutter.dev/flutter/dart-ui/TextDirection.html)
/// - [AlignmentDirectional class - painting library - Dart API](https://api.flutter.dev/flutter/painting/AlignmentDirectional-class.html)
/// - [EdgeInsetsDirectional class - painting library - Dart API](https://api.flutter.dev/flutter/painting/EdgeInsetsDirectional-class.html)
/// - [PositionedDirectional class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/PositionedDirectional-class.html)
class NoSupportMultiTextDirection extends AnalysisRule {
  /// Create a new instance of [NoSupportMultiTextDirection].
  NoSupportMultiTextDirection()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.experimental(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'no_support_multi_text_direction';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _description,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry
      ..addPrefixedIdentifier(this, _AlignmentVisitor(this, context))
      ..addInstanceCreationExpression(this, _EdgeInsetsVisitor(this, context))
      ..addInstanceCreationExpression(this, _PositionedVisitor(this, context));
  }
}

class _AlignmentVisitor extends SimpleAstVisitor<void> {
  _AlignmentVisitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    // Do nothing if the package of class is not `flutter`.
    final library = node.staticType?.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    // Do nothing if the class name is not `Alignment`.
    final isAlignment = node.prefix.name == 'Alignment';
    if (!isAlignment) return;

    // Do nothing if the period is not `.`.
    final operatorToken = node.period;
    if (operatorToken.type != TokenType.PERIOD) return;

    // Do nothing if the variable name is not
    // - `bottomLeft`
    // - `bottomRight`
    // - `centerLeft`
    // - `centerRight`
    // - `topLeft`
    // - `topRight`
    final propertyName = node.identifier.name;
    if (propertyName != 'bottomLeft' &&
        propertyName != 'bottomRight' &&
        propertyName != 'centerLeft' &&
        propertyName != 'centerRight' &&
        propertyName != 'topLeft' &&
        propertyName != 'topRight') {
      return;
    }

    rule.reportAtNode(node);
  }
}

class _EdgeInsetsVisitor extends SimpleAstVisitor<void> {
  _EdgeInsetsVisitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Do nothing if the package of constructor is not `flutter`.
    final library = node.constructorName.type.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    final isEdgeInsets =
        // Do nothing if the class is not `EdgeInsets`.
        node.constructorName.type.element?.name == 'EdgeInsets';
    if (!isEdgeInsets) return;

    // Do nothing if the constructor is not named constructor.
    final operatorToken = node.constructorName.period;
    if (operatorToken?.type != TokenType.PERIOD) return;

    // Do nothing if the named constructor name is not
    // - `fromLTRB`
    // - `only`
    final constructorName = node.constructorName.name?.name;
    if (constructorName != 'fromLTRB' && constructorName != 'only') return;

    if (constructorName == 'only') {
      // Do nothing if the constructor has not `left` or `right` parameter.
      if (!_hasLRArgument(node.argumentList)) return;
    }

    rule.reportAtNode(node);
  }

  bool _hasLRArgument(ArgumentList argumentList) {
    // Do nothing if the constructor has not `left` or `right` parameter.
    final arguments = argumentList.arguments;
    return arguments.whereType<NamedExpression>().any(
      (argument) =>
          argument.name.label.name == 'left' ||
          argument.name.label.name == 'right',
    );
  }
}

class _PositionedVisitor extends SimpleAstVisitor<void> {
  _PositionedVisitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Do nothing if the package of constructor is not `flutter`.
    final library = node.constructorName.type.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    final isPositioned =
        // Do nothing if the class is not `Positioned`.
        node.constructorName.type.element?.name == 'Positioned';
    if (!isPositioned) return;

    // Do nothing if the named constructor name is not
    // - primary constructor
    // - `fill`
    final constructorName = node.constructorName.name?.name;
    if (constructorName != null && constructorName != 'fill') return;

    // Do nothing if the constructor has not `left` or `right` parameter.
    if (!_hasLRArgument(node.argumentList)) return;

    rule.reportAtNode(node);
  }

  bool _hasLRArgument(ArgumentList argumentList) {
    // Do nothing if the constructor has not `left` or `right` parameter.
    final arguments = argumentList.arguments;
    return arguments.whereType<NamedExpression>().any(
      (argument) =>
          argument.name.label.name == 'left' ||
          argument.name.label.name == 'right',
    );
  }
}

/// A class for fixing `no_support_multi_text_direction` rule.
///
/// This fix replaces [Alignment] with [AlignmentDirectional].
class ReplaceWithAlignmentDirectional extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithAlignmentDirectional].
  ReplaceWithAlignmentDirectional({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithAlignmentDirectional',
    FixKindPriority.replaceWithAlignmentDirectional,
    'Replace with AlignmentDirectional',
  );

  final _identifierMap = {
    'bottomLeft': 'bottomStart',
    'bottomRight': 'bottomEnd',
    'centerLeft': 'centerStart',
    'centerRight': 'centerEnd',
    'topLeft': 'topStart',
    'topRight': 'topEnd',
  };

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! PrefixedIdentifier) return;
    final prefixedIdentifier = node as PrefixedIdentifier;

    // Do nothing if the class name is not `Alignment`.
    final isAlignment = prefixedIdentifier.prefix.name == 'Alignment';
    if (!isAlignment) return;

    await builder.addDartFileEdit(file, (builder) {
      builder
        ..addSimpleReplacement(
          SourceRange(
            prefixedIdentifier.identifier.offset,
            prefixedIdentifier.identifier.length,
          ),
          _identifierMap[prefixedIdentifier.identifier.name]!,
        )
        ..addSimpleReplacement(
          SourceRange(
            prefixedIdentifier.prefix.offset,
            prefixedIdentifier.prefix.length,
          ),
          'AlignmentDirectional',
        );
    });
  }
}

/// A class for fixing `no_support_multi_text_direction` rule.
///
/// This fix replaces [EdgeInsets] with [EdgeInsetsDirectional].
class ReplaceWithEdgeInsetsDirectional extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithEdgeInsetsDirectional].
  ReplaceWithEdgeInsetsDirectional({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithEdgeInsetsDirectional',
    FixKindPriority.replaceWithEdgeInsetsDirectional,
    'Replace with EdgeInsetsDirectional',
  );

  final _argumentMap = {
    'left': 'start',
    'right': 'end',
  };

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    final isEdgeInsets =
        // Do nothing if the class is not `EdgeInsets`.
        instanceCreation.constructorName.type.element?.name == 'EdgeInsets';
    if (!isEdgeInsets) return;

    await builder.addDartFileEdit(file, (builder) {
      if (instanceCreation.constructorName.name?.name == 'fromLTRB') {
        builder.addSimpleReplacement(
          SourceRange(
            instanceCreation.constructorName.name!.offset,
            instanceCreation.constructorName.name!.length,
          ),
          'fromSTEB',
        );
      }
      instanceCreation.argumentList.arguments
          .whereType<NamedExpression>()
          .forEach(
            (argument) {
              final newArgument = _argumentMap[argument.name.label.name];
              if (newArgument != null) {
                builder.addSimpleReplacement(
                  SourceRange(
                    argument.name.label.offset,
                    argument.name.label.length,
                  ),
                  newArgument,
                );
              }
            },
          );
      builder.addSimpleReplacement(
        SourceRange(
          instanceCreation.constructorName.type.offset,
          instanceCreation.constructorName.type.length,
        ),
        'EdgeInsetsDirectional',
      );
    });
  }
}

/// A class for fixing `no_support_multi_text_direction` rule.
///
/// This fix replaces [Positioned] with [PositionedDirectional].
class ReplaceWithPositionedDirectionalClass extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithPositionedDirectionalClass].
  ReplaceWithPositionedDirectionalClass({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithPositionedDirectionalClass',
    FixKindPriority.replaceWithPositionedDirectionalClass,
    'Replace with PositionedDirectional',
  );

  final _argumentMap = {
    'left': 'start',
    'right': 'end',
  };

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    final isPositioned =
        // Do nothing if the class is not `Positioned`.
        instanceCreation.constructorName.type.element?.name == 'Positioned';
    if (!isPositioned) return;

    await builder.addDartFileEdit(file, (builder) {
      instanceCreation.argumentList.arguments
          .whereType<NamedExpression>()
          .forEach(
            (argument) {
              final newArgument = _argumentMap[argument.name.label.name];
              if (newArgument != null) {
                builder.addSimpleReplacement(
                  SourceRange(
                    argument.name.label.offset,
                    argument.name.label.length,
                  ),
                  newArgument,
                );
              }
            },
          );
      builder.addSimpleReplacement(
        SourceRange(
          instanceCreation.constructorName.offset,
          instanceCreation.constructorName.length,
        ),
        'PositionedDirectional',
      );
    });
  }
}

/// A class for fixing `no_support_multi_text_direction` rule.
///
/// This fix replaces [Positioned] with [Positioned.directional].
class ReplaceWithPositionedDirectional extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithPositionedDirectional].
  ReplaceWithPositionedDirectional({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithPositionedDirectional',
    FixKindPriority.replaceWithPositionedDirectional,
    'Replace with Positioned.directional',
  );

  final _argumentMap = {
    'left': 'start',
    'right': 'end',
  };

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    final isPositioned =
        // Do nothing if the class is not `Positioned`.
        instanceCreation.constructorName.type.element?.name == 'Positioned';
    if (!isPositioned) return;

    await builder.addDartFileEdit(file, (builder) {
      final constructorName = instanceCreation.constructorName.name?.name;

      instanceCreation.argumentList.arguments
          .whereType<NamedExpression>()
          .forEach(
            (argument) {
              final newArgument = _argumentMap[argument.name.label.name];
              if (newArgument != null) {
                builder.addSimpleReplacement(
                  SourceRange(
                    argument.name.label.offset,
                    argument.name.label.length,
                  ),
                  newArgument,
                );
              }
            },
          );

      if (constructorName == 'fill') {
        builder.addSimpleReplacement(
          SourceRange(
            instanceCreation.constructorName.offset,
            instanceCreation.constructorName.length,
          ),
          'Positioned.directional',
        );
      }
      if (constructorName == null) {
        builder.addSimpleInsertion(
          instanceCreation.constructorName.type.end,
          '.directional',
        );
      }
    });
  }
}
