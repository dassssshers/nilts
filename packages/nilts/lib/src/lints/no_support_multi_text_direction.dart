import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';
import 'package:nilts_core/nilts_core.dart';

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
class NoSupportMultiTextDirection extends DartLintRule {
  /// Create a new instance of [NoSupportMultiTextDirection].
  const NoSupportMultiTextDirection() : super(code: _code);

  static const _code = LintCode(
    name: 'no_support_multi_text_direction',
    problemMessage:
        'This configuration is not affected by changes of `TextDirection`.',
    url: 'https://github.com/dassssshers/nilts#no_support_multi_text_direction',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // Check for `Alignment`.
    context.registry.addPrefixedIdentifier((node) {
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

      reporter.atNode(node, _code);
    });

    // Check for `EdgeInsets`.
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final library = node.constructorName.type.element?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the class is not `EdgeInsets`.
      final isEdgeInsets =
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

      reporter.atNode(node, _code);
    });

    // Check for `Positioned`.
    context.registry.addInstanceCreationExpression((node) {
      // Do nothing if the package of constructor is not `flutter`.
      final library = node.constructorName.type.element?.library;
      if (library == null) return;
      if (!library.isFlutter) return;

      // Do nothing if the class is not `Positioned`.
      final isEdgeInsets =
          node.constructorName.type.element?.name == 'Positioned';
      if (!isEdgeInsets) return;

      // Do nothing if the named constructor name is not
      // - primary constructor
      // - `fill`
      final constructorName = node.constructorName.name?.name;
      if (constructorName != null && constructorName != 'fill') return;

      // Do nothing if the constructor has not `left` or `right` parameter.
      if (!_hasLRArgument(node.argumentList)) return;

      reporter.atNode(node, _code);
    });
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

  @override
  List<Fix> getFixes() => [
        _ReplaceWithAlignmentDirectional(),
        _ReplaceWithEdgeInsetsDirectional(),
        _ReplaceWithPositionedDirectionalClass(),
        _ReplaceWithPositionedDirectional(),
      ];
}

class _ReplaceWithAlignmentDirectional extends DartFix {
  final _identifierMap = {
    'bottomLeft': 'bottomStart',
    'bottomRight': 'bottomEnd',
    'centerLeft': 'centerStart',
    'centerRight': 'centerEnd',
    'topLeft': 'topStart',
    'topRight': 'topEnd',
  };

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addPrefixedIdentifier((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      // Do nothing if the class name is not `Alignment`.
      final isAlignment = node.prefix.name == 'Alignment';
      if (!isAlignment) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with AlignmentDirectional',
        priority: ChangePriority.replaceWithAlignmentDirectional,
      )
          .addDartFileEdit((builder) {
        builder
          ..addSimpleReplacement(
            node.identifier.sourceRange,
            _identifierMap[node.identifier.name]!,
          )
          ..addSimpleReplacement(
            node.prefix.sourceRange,
            'AlignmentDirectional',
          );
      });
    });
  }
}

class _ReplaceWithEdgeInsetsDirectional extends DartFix {
  final _argumentMap = {
    'left': 'start',
    'right': 'end',
  };

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

      // Do nothing if the class is not `EdgeInsets`.
      final isEdgeInsets =
          node.constructorName.type.element?.name == 'EdgeInsets';
      if (!isEdgeInsets) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with EdgeInsetsDirectional',
        priority: ChangePriority.replaceWithEdgeInsetsDirectional,
      )
          .addDartFileEdit((builder) {
        if (node.constructorName.name?.name == 'fromLTRB') {
          builder.addSimpleReplacement(
            node.constructorName.name!.sourceRange,
            'fromSTEB',
          );
        }
        node.argumentList.arguments.whereType<NamedExpression>().forEach(
          (argument) {
            final newArgument = _argumentMap[argument.name.label.name];
            if (newArgument != null) {
              builder.addSimpleReplacement(
                argument.name.label.sourceRange,
                newArgument,
              );
            }
          },
        );
        builder.addSimpleReplacement(
          node.constructorName.type.sourceRange,
          'EdgeInsetsDirectional',
        );
      });
    });
  }
}

class _ReplaceWithPositionedDirectionalClass extends DartFix {
  final _argumentMap = {
    'left': 'start',
    'right': 'end',
  };

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

      // Do nothing if the class is not `Positioned`.
      final isEdgeInsets =
          node.constructorName.type.element?.name == 'Positioned';
      if (!isEdgeInsets) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with PositionedDirectional',
        priority: ChangePriority.replaceWithPositionedDirectionalClass,
      )
          .addDartFileEdit((builder) {
        node.argumentList.arguments.whereType<NamedExpression>().forEach(
          (argument) {
            final newArgument = _argumentMap[argument.name.label.name];
            if (newArgument != null) {
              builder.addSimpleReplacement(
                argument.name.label.sourceRange,
                newArgument,
              );
            }
          },
        );
        builder.addSimpleReplacement(
          node.constructorName.sourceRange,
          'PositionedDirectional',
        );
      });
    });
  }
}

class _ReplaceWithPositionedDirectional extends DartFix {
  final _argumentMap = {
    'left': 'start',
    'right': 'end',
  };

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

      // Do nothing if the class is not `Positioned`.
      final isEdgeInsets =
          node.constructorName.type.element?.name == 'Positioned';
      if (!isEdgeInsets) return;

      reporter
          .createChangeBuilder(
        message: 'Replace with Positioned.directional',
        priority: ChangePriority.replaceWithPositionedDirectional,
      )
          .addDartFileEdit((builder) {
        final constructorName = node.constructorName.name?.name;

        node.argumentList.arguments.whereType<NamedExpression>().forEach(
          (argument) {
            final newArgument = _argumentMap[argument.name.label.name];
            if (newArgument != null) {
              builder.addSimpleReplacement(
                argument.name.label.sourceRange,
                newArgument,
              );
            }
          },
        );

        if (constructorName == 'fill') {
          builder.addSimpleReplacement(
            node.constructorName.sourceRange,
            'Positioned.directional',
          );
        }
        if (constructorName == null) {
          builder.addSimpleInsertion(
            node.constructorName.type.end,
            '.directional',
          );
        }
      });
    });
  }
}
