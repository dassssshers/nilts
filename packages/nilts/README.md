<div align="center">

# nilts

nilts is lint rules, quick fixes and assists for Dart and Flutter projects that helps you enforce best practices, and avoid errors.

[![build][badge-build]](https://github.com/dassssshers/nilts/actions/workflows/build.yml)
[![pub][badge-pub]](https://pub.dev/packages/nilts)
[![license][badge-license]](https://github.com/dassssshers/nilts/blob/main/packages/nilts/LICENSE)

[badge-build]: https://img.shields.io/github/actions/workflow/status/dassssshers/nilts/build.yml?style=for-the-badge&logo=github%20actions&logoColor=%232088FF&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Factions%2Fworkflows%2Fbuild.yml
[badge-pub]: https://img.shields.io/pub/v/nilts?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fnilts
[badge-license]: https://img.shields.io/badge/license-mit-green?style=for-the-badge&logo=github&logoColor=%23181717&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Fblob%2Fmain%2Fpackages%2Fnilts%2FLICENSE

</div>

---

## Contents

- [Usage](#usage)
- [Configuration](#configuration)
    - [Disabling strategy](#disabling-strategy)
    - [Enabling strategy](#enabling-strategy)
- [Lint rules and quick fixes](#lint-rules-and-quick-fixes)
    - [Overview](#overview)
    - [Details](#details)
- [Assists](#assists)
- [Known issues](#known-issues)
- [Feature requests](#feature-requests)
- [Bug reports](#bug-reports)
- [Contributing](#contributing)

## Usage

nilts depends on [`custom_lint`](https://github.com/invertase/dart_custom_lint).
You should add `nilts` and `custom_lint` to your `dev_dependencies` in `pubspec.yaml` file.

<!-- prettier-ignore-start -->
```yaml
dev_dependencies:
  custom_lint: <version>
  nilts: <version>
```
<!-- prettier-ignore-end -->

And also, add `custom_lint` to your `analysis_options.yaml` file.

<!-- prettier-ignore-start -->
```yaml
analyzer:
  plugins:
    - custom_lint
```
<!-- prettier-ignore-end -->

## Configuration

You can configure all lint rules provided by `nilts` in `analysis_options.yaml` file.
Choice one of the following configuration strategies.

### Disabling strategy

All of `nilts` rules are enabled by default.
Add lint rule name and set `false` to disable it.

<!-- prettier-ignore-start -->
```yaml
custom_lint:
  rules:
    # Disable particular lint rules if you want ignore them whole package.
    - unnecessary_rebuilds_from_media_query: false
```
<!-- prettier-ignore-end -->

### Enabling strategy

You can disable all lint rules depends on custom_lint by setting `enable_all_lint_rules` to `false`.
Add lint rule name and set `true` to enable it.

<!-- prettier-ignore-start -->
```yaml
custom_lint:
  # Disable all lint rules depends on custom_lint.
  enable_all_lint_rules: false
  rules:
    - unnecessary_rebuilds_from_media_query: true
```
<!-- prettier-ignore-end -->

**NOTE: If you `enable_all_lint_rules` set to `false`, all of lint rules (not only all of nilts's lint rules) depends on `custom_lint` will be disabled by default.**

## Lint rules and quick fixes

Read below to learn about each lint rules intend to.
Some of lint rules support quick fixes on IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/assets/12420269/2205daf8-1bbd-4a16-a5eb-47eb75f08536)

### Overview

| Rule name                                                                       | Overview                                                                       |           Target SDK           | Rule type | Maturity level | Quick fix |
| ------------------------------------------------------------------------------- | :----------------------------------------------------------------------------- | :----------------------------: | :-------: | :------------: | :-------: |
| [defined_async_callback_type](#defined_async_callback_type)                     | Checks `Future<void> Function()` definitions.                                  |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [defined_async_value_getter_type](#defined_async_value_getter_type)             | Checks `Future<T> Function()` definitions.                                     |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [defined_async_value_setter_type](#defined_async_value_setter_type)             | Checks `Future<void> Function(T value)` definitions.                           |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [defined_value_changed_type](#defined_value_changed_type)                       | Checks `void Function(T value)` definitions.                                   |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [defined_value_getter_type](#defined_value_getter_type)                         | Checks `T Function()` definitions.                                             |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [defined_value_setter_type](#defined_value_setter_type)                         | Checks `void Function(T value)` definitions.                                   |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [defined_void_callback_type](#defined_void_callback_type)                       | Checks `void Function()` definitions.                                          |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [fixed_text_scale_rich_text](#fixed_text_scale_rich_text)                       | Checks usage of `textScaler` or `textScaleFactor` in `RichText` constructor.   |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [flaky_tests_with_set_up_all](#flaky_tests_with_set_up_all)                     | Checks `setUpAll` usages.                                                      |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [low_readability_numeric_literals](#low_readability_numeric_literals)           | Checks numeric literals with 5 or more digits.                                 | >= Flutter 3.27.0 (Dart 3.6.0) | Practice  |  Experimental  |    ✅️    |
| [no_support_multi_text_direction](#no_support_multi_text_direction)             | Checks if supports `TextDirection` changes.                                    |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [no_support_web_platform_check](#no_support_web_platform_check)                 | Checks if `Platform.isXxx` usages.                                             |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [shrink_wrapped_scroll_view](#shrink_wrapped_scroll_view)                       | Checks the content of the scroll view is shrink wrapped.                       |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |
| [unnecessary_rebuilds_from_media_query](#unnecessary_rebuilds_from_media_query) | Checks `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)` usages. | >= Flutter 3.10.0 (Dart 3.0.0) | Practice  |  Experimental  |    ✅️    |
| [no_force_unwrap](#no_force_unwrap)                                             | Checks usage of the `!` operator for forced unwrapping.                        |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️    |

### Details

#### defined_async_callback_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `Future<void> Function()` with `AsyncCallback` which is defined in Flutter SDK.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final Future<void> Function() callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final AsyncCallback callback;
```
<!-- prettier-ignore-end -->

See also:

- [AsyncCallback typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncCallback.html)

</details>

#### defined_async_value_getter_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `Future<T> Function()` with `AsyncValueGetter` which is defined in Flutter SDK.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final Future<int> Function() callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final AsyncValueGetter<int> callback;
```
<!-- prettier-ignore-end -->

See also:

- [AsyncValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncValueGetter.html)

</details>

#### defined_async_value_setter_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `Future<void> Function(T value)` with `AsyncValueSetter` which is defined in Flutter SDK.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final Future<void> Function(int value) callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final AsyncValueSetter<int> callback;
```
<!-- prettier-ignore-end -->

See also:

- [AsyncValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncValueSetter.html)

</details>

#### defined_value_changed_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `void Function(T value)` with `ValueChanged` which is defined in Flutter SDK.
If the value has been set, use `ValueSetter` instead.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final void Function(int value) callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final ValueChanged<int> callback;
```
<!-- prettier-ignore-end -->

See also:

- [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)
- [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)

</details>

#### defined_value_getter_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `T Function()` with `ValueGetter` which is defined in Flutter SDK.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final int Function() callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final ValueGetter<int> callback;
```
<!-- prettier-ignore-end -->

See also:

- [ValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueGetter.html)

</details>

#### defined_value_setter_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `void Function(T value)` with `ValueSetter` which is defined in Flutter SDK.
If the value has changed, use `ValueChanged` instead.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final void Function(int value) callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final ValueSetter<int> callback;
```
<!-- prettier-ignore-end -->

See also:

- [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)
- [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)

</details>

#### defined_void_callback_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replace `void Function()` with `VoidCallback` which is defined in Flutter SDK.

**BAD:**

<!-- prettier-ignore-start -->
```dart
final void Function() callback;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final VoidCallback callback;
```
<!-- prettier-ignore-end -->

See also:

- [VoidCallback typedef - dart:ui library - Dart API](https://api.flutter.dev/flutter/dart-ui/VoidCallback.html)

</details>

#### fixed_text_scale_rich_text

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** using `Text.rich` or adding `textScaler` or `textScaleFactor` (deprecated on Flutter 3.16.0 and above) argument to `RichText` constructor to make the text size responsive for user setting.

**BAD:**
<!-- prettier-ignore-start -->
```dart
RichText(
  text: TextSpan(
    text: 'Hello, world!',
  ),
)
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
Text.rich(
  TextSpan(
    text: 'Hello, world!',
  ),
)
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
RichText(
  text: TextSpan(
    text: 'Hello, world!',
  ),
  textScaler: MediaQuery.textScalerOf(context),
)
```
<!-- prettier-ignore-end -->

**GOOD (deprecated on Flutter 3.16.0 and above):**

<!-- prettier-ignore-start -->
```dart
RichText(
  text: TextSpan(
    text: 'Hello, world!',
  ),
  textScaleFactor: MediaQuery.textScaleFactorOf(context),
)
```
<!-- prettier-ignore-end -->

See also:

- [Text.rich constructor - Text - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/Text/Text.rich.html)
- [RichText class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/RichText-class.html)

</details>

#### flaky_tests_with_set_up_all

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** using `setUp` function or initialization on top level or body of test group.
`setUpAll` may cause flaky tests with concurrency executions.

**BAD:**
<!-- prettier-ignore-start -->
```dart
setUpAll(() {
  // ...
});
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
setUp(() {
  // ...
});
```
<!-- prettier-ignore-end -->

<!-- prettier-ignore-start -->
```dart
void main() {
  // do initialization on top level
  // ...

 group('...', () {
  // or do initialization on body of test group
  // ...
 });
}
```
<!-- prettier-ignore-end -->

See also:

- [setUpAll function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUpAll.html)
- [setUp function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUp.html)

</details>

#### low_readability_numeric_literals

<details>

<!-- prettier-ignore-start -->
- Target SDK     : >= Flutter 3.27.0 (Dart 3.6.0)
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** using digit separators for numeric literals with 5 or more digits to improve readability.

**BAD:**
<!-- prettier-ignore-start -->
```dart
const int value = 123456;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
const int value = 123_456;
```
<!-- prettier-ignore-end -->

See also:

- [Digit Separators in Dart 3.6](https://medium.com/dartlang/announcing-dart-3-6-778dd7a80983)
- [Built-in types | Dart](https://dart.dev/language/built-in-types#numbers)

</details>

#### no_support_multi_text_direction

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** using `TextDirection` aware configurations if your application supports different `TextDirection` languages.

**BAD:**
<!-- prettier-ignore-start -->
```dart
Align(
  alignment: Alignment.bottomLeft,
)
```
<!-- prettier-ignore-end -->

**BAD:**

<!-- prettier-ignore-start -->
```dart
Padding(
  padding: EdgeInsets.only(left: 16, right: 4),
)
```
<!-- prettier-ignore-end -->

**BAD:**

<!-- prettier-ignore-start -->
```dart
Positioned(left: 12, child: SizedBox())
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
Align(
  alignment: AlignmentDirectional.bottomStart,
)
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
Padding(
  padding: EdgeInsetsDirectional.only(start: 16, end: 4),
)
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
Positioned.directional(
  start: 12,
  textDirection: TextDirection.ltr,
  child: SizedBox(),
)

PositionedDirectional(
  start: 12,
  child: SizedBox(),
)
```
<!-- prettier-ignore-end -->

See also:

- [TextDirection enum - dart:ui library - Dart API](https://api.flutter.dev/flutter/dart-ui/TextDirection.html)
- [AlignmentDirectional class - painting library - Dart API](https://api.flutter.dev/flutter/painting/AlignmentDirectional-class.html)
- [EdgeInsetsDirectional class - painting library - Dart API](https://api.flutter.dev/flutter/painting/EdgeInsetsDirectional-class.html)
- [PositionedDirectional class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/PositionedDirectional-class.html)

</details>

#### no_support_web_platform_check

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

Prefer using `defaultTargetPlatform` instead of `Platform` API if you want to know which platform your application is running on.
This is because

- `Platform` API throws a runtime exception on web application.
- By combining `kIsWeb` and `defaultTargetPlatform`, you can accurately determine which platform your web application is running on.

**BAD:**
<!-- prettier-ignore-start -->
```dart
bool get isIOS => !kIsWeb && Platform.isIOS;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
```
<!-- prettier-ignore-end -->

See also:

- [defaultTargetPlatform property - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/defaultTargetPlatform.html)

</details>

#### shrink_wrapped_scroll_view

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** removing `shrinkWrap` argument and update the Widget not to shrink wrap.
Shrink wrapping the content of the scroll view is significantly more expensive than expanding to the maximum allowed size because the content can expand and contract during scrolling, which means the size of the scroll view needs to be recomputed whenever the scroll position changes.

You can avoid shrink wrap with 3 steps below in case of your scroll view is nested.

1. Replace the parent scroll view with `CustomScrollView`.
2. Replace the child scroll view with `SliverListView` or `SliverGridView`.
3. Set `SliverChildBuilderDelegate` to `delegate` argument of the `SliverListView` or `SliverGridView`.

**BAD:**
<!-- prettier-ignore-start -->
```dart
ListView(shrinkWrap: true)
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
ListView(shrinkWrap: false)
```
<!-- prettier-ignore-end -->

See also:

- [shrinkWrap property - ScrollView class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/ScrollView/shrinkWrap.html)
- [ShrinkWrap vs Slivers | Decoding Flutter - YouTube](https://youtu.be/LUqDNnv_dh0)

</details>

#### unnecessary_rebuilds_from_media_query

<details>

<!-- prettier-ignore-start -->
- Target SDK     : >= Flutter 3.10.0 (Dart 3.0.0)
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Prefer** using `MediaQuery.xxxOf` or `MediaQuery.maybeXxxOf` instead of `MediaQuery.of` or `MediaQuery.maybeOf` to avoid unnecessary rebuilds.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final size = MediaQuery.of(context).size;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final size = MediaQuery.sizeOf(context);
```
<!-- prettier-ignore-end -->

**Note that using `MediaQuery.of` or `MediaQuery.maybeOf` makes sense following cases:**

- wrap Widget with `MediaQuery` overridden `MediaQueryData`
- observe all changes of `MediaQueryData`

See also:

- [MediaQuery as InheritedModel by moffatman · Pull Request #114459 · flutter/flutter](https://github.com/flutter/flutter/pull/114459)
- [MediaQuery class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)

</details>

### no_force_unwrap

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅ (pattern matching is available on Dart 3.0.0 and above)
<!-- prettier-ignore-end -->

**Prefer** using null coalescing operator or pattern matching instead of force unwrapping with `!` operator.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final value = someValue!;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final value = someValue ?? /* Replace with a suitable default value */;
```
<!-- prettier-ignore-end -->

**GOOD(using Pattern Matching on Dart 3.0.0 and above):**

<!-- prettier-ignore-start -->
```dart
if (someValue case final actualValue) {
  print('取得した値: $actualValue');
}
```
<!-- prettier-ignore-end -->

See also:

- [Null coalescing operator - Dart language specification](https://dart.dev/language/operators#null-coalescing-operator)
- [Pattern matching - Dart language specification](https://dart.dev/language/patterns)

## Assists

Upcoming... 🚀

## Known issues

### Lint rule errors don't appear and quick fixes don't work in IDE (Fixed)

> [!IMPORTANT]
> This issue is solved on nilts 0.18.3 using custom_lint 0.7.3.

Since custom_lint 0.6.7, the IDE has not shown lint rule errors in some cases.

See also:

- [analysis.setContextRoots failed - RequestErrorCode.PLUGIN_ERROR ProcessException: / No such file or directory / Command: flutter pub get · Issue #270 · invertase/dart_custom_lint](https://github.com/invertase/dart_custom_lint/issues/270)
- [IntelliJ and Android Studio don't show custom lints · Issue #307 · invertase/dart_custom_lint](https://github.com/invertase/dart_custom_lint/issues/307)

### Quick fix priorities (Fixed)

> [!IMPORTANT]
> Finding which a plugin version fixed the issue is hard, but it looks work as expected.
> Checked works as expected on Dart plugin [242.24931](https://plugins.jetbrains.com/plugin/6351-dart/versions/stable/644082) and [243.23654.44](https://plugins.jetbrains.com/plugin/6351-dart/versions/stable/656656).

The priorities assigned to quick fixes are not currently visible in IntelliJ IDEA and Android Studio due to the lack of support for `PrioritizedSourceChange` in these environments.
In contrast, VS Code does support this feature, allowing quick fixes to be listed along with their respective priorities.

|                                                           VS Code                                                            |                                                           IntelliJ IDEA / Android Studio                                                            |
| :--------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------: |
| <img width="500" alt="VS Code" src="https://github.com/ronnnnn/nilts/assets/12420269/b756c354-00f1-42f6-9fde-eaffce255811"/> | <img width="500" alt="IntelliJ IDEA / Android Studio" src="https://github.com/ronnnnn/nilts/assets/12420269/99a1032b-db40-4376-8345-c5e960f156a2"/> |

See also:

- [IDEA-336551 Support PrioritizedSourceChange on quick fix.](https://youtrack.jetbrains.com/issue/IDEA-336551/Support-PrioritizedSourceChange-on-quick-fix.)

### fix-all assist (Fixed)

> [!IMPORTANT]
> Finding which a plugin version fixed the issue is hard, but it looks as expected.
> Checked works as expected on Dart plugin [242.24931](https://plugins.jetbrains.com/plugin/6351-dart/versions/stable/644082) and [243.23654.44](https://plugins.jetbrains.com/plugin/6351-dart/versions/stable/656656).

The fix-all assist feature has been introduced in [custom_lint_builder 0.6.0](https://github.com/invertase/dart_custom_lint/pull/223).
However, this feature is not yet supported in IntelliJ IDEA and Android Studio, owing to their current lack of support for `PrioritizedSourceChange`.

|                                                            VS Code                                                            |                                                            IntelliJ IDEA / Android Studio                                                            |
| :---------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------: |
| <img width="500" alt="VS Code" src="https://github.com/ronnnnn/nilts/assets/12420269/3d8f7d66-5325-4877-b1f9-eb246c8edd00" /> | <img width="500" alt="IntelliJ IDEA / Android Studio" src="https://github.com/ronnnnn/nilts/assets/12420269/ce76bbd3-719c-4bce-8f54-7dea04354b5e" /> |

## Feature requests

If you have any feature requests, please create [an issue from this template](https://github.com/dassssshers/nilts/issues/new?&labels=feat&template=feat.yml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/dassssshers/nilts/issues/new?&labels=bug&template=bug.yml).

## Contributing

Welcome your contributions!!
Please read [CONTRIBUTING](https://github.com/dassssshers/nilts/blob/main/CONTRIBUTING.md) docs before submitting your PR.
