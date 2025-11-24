// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:nilts/src/fix_kind_priority.dart';
import 'package:nilts_core/nilts_core.dart';

const _description =
    'Default `textScaler` or `textScaleFactor` value of `RichText` is '
    'fixed value.';
const _descriptionLegacy =
    'Default `textScaleFactor` value of `RichText` is fixed value.';

/// A class for `fixed_text_scale_rich_text` rule.
///
/// This rule checks if `textScaler` or `textScaleFactor` are missing in
/// [RichText] constructor.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Stable
/// - Severity       : Info
/// - Quick fix      : ✅
///
/// **Consider** using `Text.rich` or adding
/// `textScaler` or `textScaleFactor` (deprecated on Flutter 3.16.0 and above)
/// argument to [RichText] constructor to
/// make the text size responsive for user setting.
///
/// **BAD:**
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: 'Hello, world!',
///   ),
/// )
/// ```
///
/// **GOOD:**
/// ```dart
/// Text.rich(
///   TextSpan(
///     text: 'Hello, world!',
///   ),
/// )
/// ```
///
/// **GOOD:**
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: 'Hello, world!',
///   ),
///   textScaler: MediaQuery.textScalerOf(context),
/// )
/// ```
///
/// **GOOD (deprecated on Flutter 3.16.0 and above):**
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: 'Hello, world!',
///   ),
///   textScaleFactor: MediaQuery.textScaleFactorOf(context),
/// )
/// ```
///
/// See also:
///
/// - [Text.rich constructor - Text - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/Text/Text.rich.html)
/// - [RichText class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/RichText-class.html)
class FixedTextScaleRichText extends AnalysisRule {
  /// Create a new instance of [FixedTextScaleRichText].
  FixedTextScaleRichText()
    : super(
        name: ruleName,
        description: _description,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'fixed_text_scale_rich_text';

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
    registry.addInstanceCreationExpression(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Do nothing if the package of constructor is not `flutter`.
    final constructorName = node.constructorName;
    final library = constructorName.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    // Do nothing if the constructor name is not `RichText`.
    if (constructorName.type.element?.name != 'RichText') return;

    // Do nothing if the constructor has
    // `textScaler` or `textScaleFactor` argument.
    final arguments = node.argumentList.arguments;
    final isTextScaleFactorSet = arguments.any(
      (argument) =>
          argument is NamedExpression &&
          (argument.name.label.name == 'textScaler' ||
              argument.name.label.name == 'textScaleFactor'),
    );
    if (isTextScaleFactorSet) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `fixed_text_scale_rich_text` rule.
///
/// This fix replaces [RichText] with [Text.rich].
class ReplaceWithTextRich extends ResolvedCorrectionProducer {
  /// Create a new instance of [ReplaceWithTextRich].
  ReplaceWithTextRich({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.replaceWithTextRich',
    FixKindPriority.replaceWithTextRich,
    'Replace with Text.rich',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    // Do nothing if the constructor name is not `RichText`.
    final constructorName = instanceCreation.constructorName;
    if (constructorName.type.element?.name != 'RichText') return;

    await builder.addDartFileEdit(file, (builder) {
      final arguments = instanceCreation.argumentList.arguments;
      final textArgument =
          arguments.firstWhere(
                (argument) =>
                    argument is NamedExpression &&
                    argument.name.label.name == 'text',
              )
              as NamedExpression;
      final textArgumentRange = SourceRange(
        textArgument.name.offset,
        textArgument.name.length,
      );

      builder
        ..addSimpleReplacement(
          SourceRange(constructorName.type.offset, constructorName.type.length),
          'Text.rich',
        )
        ..addDeletion(textArgumentRange.getMoveEnd(1)); // Delete 'text: '
    });
  }
}

/// A class for fixing `fixed_text_scale_rich_text` rule.
///
/// This fix adds `textScaler` argument to [RichText] constructor.
class AddTextScaler extends ResolvedCorrectionProducer {
  /// Create a new instance of [AddTextScaler].
  AddTextScaler({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.addTextScaler',
    FixKindPriority.addTextScaler,
    'Add textScaler',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    // Do nothing if the constructor name is not `RichText`.
    final constructorName = instanceCreation.constructorName;
    if (constructorName.type.element?.name != 'RichText') return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleInsertion(
        instanceCreation.argumentList.arguments.last.end,
        ',\ntextScaler: MediaQuery.textScalerOf(context)',
      );
    });
  }
}

/// Legacy version of [FixedTextScaleRichText].
/// This rule is for under Flutter 3.16.0.
class FixedTextScaleRichTextLegacy extends AnalysisRule {
  /// Create a new instance of [FixedTextScaleRichTextLegacy].
  FixedTextScaleRichTextLegacy()
    : super(
        name: ruleName,
        description: _descriptionLegacy,
        state: const RuleState.stable(),
      );

  /// The name of this lint rule.
  static const String ruleName = 'fixed_text_scale_rich_text';

  /// The lint code for this rule.
  static const LintCode code = LintCode(
    ruleName,
    _descriptionLegacy,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _VisitorLegacy(this, context));
  }
}

class _VisitorLegacy extends SimpleAstVisitor<void> {
  _VisitorLegacy(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Do nothing if the package of constructor is not `flutter`.
    final constructorName = node.constructorName;
    final library = constructorName.element?.library;
    if (library == null) return;
    if (!library.isFlutter) return;

    // Do nothing if the constructor name is not `RichText`.
    if (constructorName.type.element?.name != 'RichText') return;

    // Do nothing if the constructor has `textScaleFactor` argument.
    final arguments = node.argumentList.arguments;
    final isTextScaleFactorSet = arguments.any(
      (argument) =>
          argument is NamedExpression &&
          argument.name.label.name == 'textScaleFactor',
    );
    if (isTextScaleFactorSet) return;

    rule.reportAtNode(node);
  }
}

/// A class for fixing `fixed_text_scale_rich_text` rule (Legacy).
///
/// This fix adds `textScaleFactor` argument to [RichText] constructor.
class AddTextScaleFactor extends ResolvedCorrectionProducer {
  /// Create a new instance of [AddTextScaleFactor].
  AddTextScaleFactor({required super.context});

  static const _fixKind = FixKind(
    'nilts.fix.addTextScaleFactor',
    FixKindPriority.addTextScaleFactor,
    'Add textScaleFactor',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind? get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    if (node is! InstanceCreationExpression) return;
    final instanceCreation = node as InstanceCreationExpression;

    // Do nothing if the constructor name is not `RichText`.
    final constructorName = instanceCreation.constructorName;
    if (constructorName.type.element?.name != 'RichText') return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleInsertion(
        instanceCreation.argumentList.arguments.last.end,
        ',\ntextScaleFactor: MediaQuery.textScaleFactorOf(context)',
      );
    });
  }
}
