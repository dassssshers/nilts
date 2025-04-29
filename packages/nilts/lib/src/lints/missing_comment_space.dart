import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:nilts/src/change_priority.dart';

const _documentCommentPrefix = '///';
const _regularCommentPrefix = '//';

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
    // for regular comment (eg. // comments)
    context.registry.addRegularComment((node, token) {
      if (token.lexeme.length > _regularCommentPrefix.length &&
          token.lexeme[_regularCommentPrefix.length] != ' ') {
        reporter.atNode(
          node,
          _code,
        );
      }
    });

    // for documentation comment (eg. /// comments)
    context.registry.addComment((node) {
      for (final token in node.tokens) {
        if (token.lexeme.length > _documentCommentPrefix.length &&
            token.lexeme[_documentCommentPrefix.length] != ' ') {
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
      final offset = text.startsWith(_documentCommentPrefix)
          ? _documentCommentPrefix.length
          : _regularCommentPrefix.length;

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
  void addRegularComment(
    void Function(CompilationUnit node, Token comment) listener,
  ) {
    addCompilationUnit((node) {
      Token? currentToken = node.root.beginToken;
      while (currentToken != null) {
        Token? precedingComment = currentToken.precedingComments;
        while (precedingComment != null) {
          if (precedingComment.lexeme.startsWith(_regularCommentPrefix) &&
              !precedingComment.lexeme.startsWith(_documentCommentPrefix)) {
            listener(node, precedingComment);
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
