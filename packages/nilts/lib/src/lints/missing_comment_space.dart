import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

/// A class for `missing_comment_space` rule.
///
/// This rule checks if comments have a space after the comment marker.
///
/// - Target SDK     : Any versions nilts supports
/// - Rule type      : Style
/// - Maturity level : Experimental
/// - Quick fix      : ✅
///
/// **Consider** adding a space after the comment marker.
///
/// **BAD:**
/// ```dart
/// //This is a comment
/// ///This is a documentation comment
/// ```
///
/// **GOOD:**
/// ```dart
/// // This is a comment
/// /// This is a documentation comment
/// ```
final class MissingCommentSpace extends DartLintRule {
  /// Create a new instance of [MissingCommentSpace].
  const MissingCommentSpace() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_comment_space',
    problemMessage: 'Please add a space after the comment marker.',
    correctionMessage: 'Try adding a space after the comment marker.',
    url: 'https://github.com/dassssshers/nilts#missing_comment_space',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addComment((node) {
      final text = node.toString();
      String? commentPrefix;
      if (text.startsWith('///')) {
        commentPrefix = '///';
      } else if (text.startsWith('//')) {
        commentPrefix = '//';
      } else {
        commentPrefix = null;
      }

      if (commentPrefix != null) {
        final prefixLength = commentPrefix.length;
        if (text.length > prefixLength && !text.startsWith('$commentPrefix ')) {
          reporter.atNode(
            node,
            _code,
          );
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddCommentSpace(),
      ];
}

final class _AddCommentSpace extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    context.registry.addComment((node) {
      if (!node.sourceRange.intersects(analysisError.sourceRange)) return;

      final text = node.toString();
      final offset = text.startsWith('///') ? 3 : 2;

      reporter
          .createChangeBuilder(
        message: 'Add space after comment marker',
        priority: ChangePriority.addCommentSpace,
      )
          .addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.offset + offset,
          ' ',
        );
      });
    });
  }
}
