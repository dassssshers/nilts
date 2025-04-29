import 'package:analyzer/dart/ast/token.dart';
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
    problemMessage: 'Space is missing after the comment marker.',
    correctionMessage: 'Try adding a space after the comment marker.',
    url: 'https://github.com/dassssshers/nilts#missing_comment_space',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addRegularComment((token) {
      int? commentErrorOffset(Token comment) {
        final lexeme = comment.lexeme;
        var contentStart = 0;

        // Skip the leading slashes
        for (; contentStart < lexeme.length; contentStart++) {
          if (lexeme[contentStart] != '/') {
            break;
          }
        }

        // Return the offset if there is no space after the slashes
        if (contentStart < lexeme.length && lexeme[contentStart] != ' ') {
          return contentStart;
        }
        return null;
      }

      if (commentErrorOffset(token) case final contentStart?) {
        reporter.atOffset(
          offset: token.offset + contentStart,
          length: token.length,
          errorCode: _code,
        );
      }
    });
    context.registry.addComment((node) {
      for (final token in node.tokens) {
        String? commentPrefix;
        if (token.lexeme.startsWith('///')) {
          commentPrefix = '///';
        } else if (token.lexeme.startsWith('//')) {
          commentPrefix = '//';
        } else {
          commentPrefix = null;
        }

        if (commentPrefix != null) {
          final prefixLength = commentPrefix.length;
          if (token.lexeme.length > prefixLength &&
              !token.lexeme.startsWith('$commentPrefix ')) {
            reporter.atNode(
              node,
              _code,
            );
          }
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

extension on LintRuleNodeRegistry {
  void addRegularComment(void Function(Token comment) listener) {
    addCompilationUnit((node) {
      bool isRegularComment(Token token) {
        final lexeme = token.lexeme;
        return !lexeme.startsWith('///') && lexeme.startsWith('//');
      }

      Token? currentToken = node.root.beginToken;
      while (currentToken != null) {
        Token? precedingComment = currentToken.precedingComments;
        while (precedingComment != null) {
          if (isRegularComment(precedingComment)) {
            listener(precedingComment);
          }
          precedingComment = precedingComment.next;
        }

        if (currentToken == currentToken.next) {
          break;
        }

        currentToken = currentToken.next;
      }
    });
  }
}
