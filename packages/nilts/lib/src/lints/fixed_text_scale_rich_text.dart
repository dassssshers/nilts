// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';
import 'package:nilts_core/nilts_core.dart';

/// A class for `fixed_text_scale_rich_text` rule.
///
/// This rule checks if `textScaler` or `textScaleFactor` are missing in
/// [RichText] constructor.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
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
class FixedTextScaleRichText extends DartLintRule {
  /// Create a new instance of [FixedTextScaleRichText].
  const FixedTextScaleRichText() : super(code: _code);

  static const _code = LintCode(
    name: 'fixed_text_scale_rich_text',
    problemMessage: 'Default `textScaler` or `textScaleFactor` value of '
        '`RichText` is fixed value.',
    url: 'https://github.com/dassssshers/nilts#fixed_text_scale_rich_text',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final constructorName = node.constructorName;
      final library = constructorName.staticElement?.library;
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

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithTextRich(),
        _AddTextScaler(),
      ];
}

class _ReplaceWithTextRich extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the constructor name is not `RichText`.
      final constructorName = node.constructorName;
      if (constructorName.type.element?.name != 'RichText') return;

      reporter
          .createChangeBuilder(
        message: 'Replace with Text.rich',
        priority: ChangePriority.replaceWithTextRich,
      )
          .addDartFileEdit((builder) {
        final arguments = node.argumentList.arguments;
        final textArgument = arguments.firstWhere(
          (argument) =>
              argument is NamedExpression && argument.name.label.name == 'text',
        ) as NamedExpression;
        final textArgumentRange = textArgument.name.sourceRange;

        builder
          ..addSimpleReplacement(
            constructorName.type.sourceRange,
            'Text.rich',
          )
          ..addDeletion(textArgumentRange);
      });
    });
  }
}

class _AddTextScaler extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the constructor name is not `RichText`.
      final constructorName = node.constructorName;
      if (constructorName.type.element?.name != 'RichText') return;

      reporter
          .createChangeBuilder(
        message: 'Add textScaler',
        priority: ChangePriority.addTextScaler,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.argumentList.arguments.last.end,
          ',\ntextScaler: MediaQuery.textScalerOf(context)',
        );
      });
    });
  }
}

/// Legacy version of [FixedTextScaleRichText].
/// This rule is for under Flutter 3.16.0.
class FixedTextScaleRichTextLegacy extends DartLintRule {
  /// Create a new instance of [FixedTextScaleRichTextLegacy].
  const FixedTextScaleRichTextLegacy() : super(code: _code);

  static const _code = LintCode(
    name: 'fixed_text_scale_rich_text',
    problemMessage: 'Default `textScaleFactor` value of `RichText` is '
        'fixed value.',
    url: 'https://github.com/dassssshers/nilts#fixed_text_scale_rich_text',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final constructorName = node.constructorName;
      final library = constructorName.staticElement?.library;
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

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithTextRich(),
        _AddTextScaleFactor(),
      ];
}

class _AddTextScaleFactor extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the constructor name is not `RichText`.
      final constructorName = node.constructorName;
      if (constructorName.type.element?.name != 'RichText') return;

      reporter
          .createChangeBuilder(
        message: 'Add textScaleFactor',
        priority: ChangePriority.addTextScaleFactor,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.argumentList.arguments.last.end,
          ',\ntextScaleFactor: MediaQuery.textScaleFactorOf(context)',
        );
      });
    });
  }
}
