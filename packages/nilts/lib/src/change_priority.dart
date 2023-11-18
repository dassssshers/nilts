// ignore_for_file: comment_references

/// A class for defining priorities of quick fix and assist in nilts.
///
/// Fixes to ignore rules are defined on [IgnoreCode].
/// These priorities are 34 and 35.
///
/// See also:
///   - [IgnoreCode](https://github.com/invertase/dart_custom_lint/blob/1df2851a80ccdc5a2bda4418006560f49c03b8ec/packages/custom_lint_builder/lib/src/ignore.dart#L102)
class ChangePriority {
  /// The priority for [_AddTextScaleFactor].
  static const int addTextScaleFactor = 90;

  /// The priority for [_AddTextScaler].
  static const int addTextScaler = 90;

  /// The priority for [_RemoveShrinkWrap].
  static const int removeShrinkWrap = 100;

  /// The priority for [_ReplaceWithAlignmentDirectional].
  static const int replaceWithAlignmentDirectional = 100;

  /// The priority for [_ReplaceWithEdgeInsetsDirectional].
  static const int replaceWithEdgeInsetsDirectional = 100;

  /// The priority for [_ReplaceWithMediaQueryXxxOf].
  static const int replaceWithMediaQueryXxxOf = 100;

  /// The priority for [_ReplaceWithPositionedDirectional].
  static const int replaceWithPositionedDirectional = 90;

  /// The priority for [_ReplaceWithPositionedDirectionalClass].
  static const int replaceWithPositionedDirectionalClass = 100;

  /// The priority for [_ReplaceWithSetUp].
  static const int replaceWithSetUp = 100;

  /// The priority for [_ReplaceWithTextRich].
  static const int replaceWithTextRich = 100;

  /// The priority for [_ReplaceWithVoidCallback].
  static const int replaceWithVoidCallback = 100;

  /// The priority for [_UnwrapSetUpAll].
  static const int unwrapSetUpAll = 90;
}
