// ignore_for_file: comment_references because referencing to private classes

/// A class for defining priorities of quick fix and assist in nilts.
///
/// Fixes to ignore rules are defined on [IgnoreCode].
/// These priorities are 34 and 35.
///
/// See also:
///   - [IgnoreCode](https://github.com/invertase/dart_custom_lint/blob/1df2851a80ccdc5a2bda4418006560f49c03b8ec/packages/custom_lint_builder/lib/src/ignore.dart#L102)
class ChangePriority {
  /// The priority for [_ReplaceWithClockNow]
  static const int replaceWithClockNow = 100;
}
