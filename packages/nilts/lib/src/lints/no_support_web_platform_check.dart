// ignore_for_file: comment_references to avoid unnecessary imports

import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `no_support_web_platform_check` rule.
///
/// This rule checks if
///
/// - [Platform.isLinux]
/// - [Platform.isMacOS]
/// - [Platform.isWindows]
/// - [Platform.isAndroid]
/// - [Platform.isIOS]
/// - [Platform.isFuchsia]
///
/// are used.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Practice
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// Prefer using [defaultTargetPlatform] instead of [Platform] API
/// if you want to know which platform your application is running on.
/// This is because
///
/// - [Platform] API throws a runtime exception on web application.
/// - By combining [kIsWeb] and [defaultTargetPlatform], you can
/// accurately determine which platform your web application is running on.
///
/// **BAD:**
/// ```dart
/// bool get isIOS => !kIsWeb && Platform.isIOS;
/// ```
///
/// **GOOD:**
/// ```dart
/// bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
/// ```
///
/// See also:
///
/// - [defaultTargetPlatform property - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/defaultTargetPlatform.html)
class NoSupportWebPlatformCheck extends DartLintRule {
  /// Create a new instance of [NoSupportWebPlatformCheck].
  const NoSupportWebPlatformCheck() : super(code: _code);

  static const _code = LintCode(
    name: 'no_support_web_platform_check',
    problemMessage:
        'Platform check with dart:io API is not supported on web application.',
    url: 'https://github.com/dassssshers/nilts#no_support_web_platform_check',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addPrefixedIdentifier((node) {
      // Do nothing if the identifier name is not
      // - `isLinux`
      // - `isMacOS`
      // - `isWindows`
      // - `isAndroid`
      // - `isIOS`
      // - `isFuchsia`
      final identifierName = node.identifier;
      if (identifierName.name != 'isLinux' &&
          identifierName.name != 'isMacOS' &&
          identifierName.name != 'isWindows' &&
          identifierName.name != 'isAndroid' &&
          identifierName.name != 'isIOS' &&
          identifierName.name != 'isFuchsia') {
        return;
      }

      // Do nothing if the package of identifier is not `dart.io`.
      final library = identifierName.staticElement?.library;
      if (library == null) return;
      if (library.name != 'dart.io') return;

      // Do nothing if the token is not `.`.
      final period = node.period;
      if (period.type != TokenType.PERIOD) return;

      // Do nothing if prefix is not `Platform`.
      final prefix = node.prefix;
      final isPlatform = prefix.name == 'Platform';
      if (!isPlatform) return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [
        _ReplaceWithDefaultTargetPlatform(),
      ];
}

class _ReplaceWithDefaultTargetPlatform extends DartFix {
  static const Map<String, String> _targetPlatformMap = {
    'isLinux': 'linux',
    'isMacOS': 'macOS',
    'isWindows': 'windows',
    'isAndroid': 'android',
    'isIOS': 'iOS',
    'isFuchsia': 'fuchsia',
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

      final identifier = node.identifier.name;
      final mappedProperty = _targetPlatformMap[identifier];

      // Do nothing if the identifier is not
      // - `isLinux`
      // - `isMacOS`
      // - `isWindows`
      // - `isAndroid`
      // - `isIOS`
      // - `isFuchsia`.
      if (mappedProperty == null) return;

      reporter
          .createChangeBuilder(
        message: 'Replace With defaultTargetPlatform check',
        priority: ChangePriority.replaceWithDefaultTargetPlatform,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          node.sourceRange,
          'defaultTargetPlatform == TargetPlatform.$mappedProperty',
        );
      });
    });
  }
}
