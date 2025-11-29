<div align="center">

# nilts

nilts provides lint rules, quick fixes, and assists for Dart and Flutter projects to help you enforce best practices and avoid errors.

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
- [Lint rules and quick fixes](#lint-rules-and-quick-fixes)
    - [Overview](#overview)
    - [Details](#details)
- [Assists](#assists)
- [Feature requests](#feature-requests)
- [Bug reports](#bug-reports)
- [Contributing](#contributing)

## Usage

**Note:** nilts no longer supports [`custom_lint`](https://github.com/invertase/dart_custom_lint).
If you're using `custom_lint`, please use nilts versions below v1.0 and refer to [README_CUSTOM_LINT.md](README_CUSTOM_LINT.md).

If you're using Dart SDK version 3.10 or later, add nilts to the **top-level** plugins section of your `analysis_options.yaml` file:

<!-- prettier-ignore-start -->
```yaml
plugins:
  nilts: ^1.0.0
```
<!-- prettier-ignore-end -->

## Configuration

All lint rules in nilts are **disabled by default**.

### Enable all rules (recommended)

To enable all rules, use the `include` directive with the provided configuration file:

<!-- prettier-ignore-start -->
```yaml
include: package:nilts/analysis_options.yaml
```
<!-- prettier-ignore-end -->

### Enable specific rules

To enable specific rules, use the map format with `version:` and `diagnostics:`:

<!-- prettier-ignore-start -->
```yaml
plugins:
  nilts:
    version: ^1.0.0
    diagnostics:
      defined_async_callback_type: true
      defined_void_callback_type: true
      unnecessary_rebuilds_from_media_query: true
```
<!-- prettier-ignore-end -->

See also:

- [Analyzer plugins | Dart](https://dart.dev/tools/analyzer-plugins)

## Lint rules and quick fixes

See below to learn what each lint rule does.
Some rules support quick fixes in your IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/assets/12420269/2205daf8-1bbd-4a16-a5eb-47eb75f08536)

### Overview

| Rule name                                                                       | Overview                                                                       |         Target SDK          | Rule type | Maturity level | Severity | Quick fix |
| ------------------------------------------------------------------------------- | :----------------------------------------------------------------------------- | :-------------------------: | :-------: | :------------: | :------: | :-------: |
| [defined_async_callback_type](#defined_async_callback_type)                     | Checks `Future<void> Function()` definitions.                                  | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [defined_async_value_getter_type](#defined_async_value_getter_type)             | Checks `Future<T> Function()` definitions.                                     | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [defined_async_value_setter_type](#defined_async_value_setter_type)             | Checks `Future<void> Function(T value)` definitions.                           | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [defined_value_changed_type](#defined_value_changed_type)                       | Checks `void Function(T value)` definitions.                                   | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [defined_value_getter_type](#defined_value_getter_type)                         | Checks `T Function()` definitions.                                             | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [defined_value_setter_type](#defined_value_setter_type)                         | Checks `void Function(T value)` definitions.                                   | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [defined_void_callback_type](#defined_void_callback_type)                       | Checks `void Function()` definitions.                                          | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [fixed_text_scale_rich_text](#fixed_text_scale_rich_text)                       | Checks usage of `textScaler` or `textScaleFactor` in `RichText` constructor.   | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [flaky_tests_with_set_up_all](#flaky_tests_with_set_up_all)                     | Checks `setUpAll` usages.                                                      | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [low_readability_numeric_literals](#low_readability_numeric_literals)           | Checks numeric literals with 5 or more digits.                                 |        >= Dart 3.6.0        | Practice  |     Stable     |   Info   |    ✅️    |
| [no_support_multi_text_direction](#no_support_multi_text_direction)             | Checks if supports `TextDirection` changes.                                    | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [no_support_web_platform_check](#no_support_web_platform_check)                 | Checks if `Platform.isXxx` usages.                                             | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [open_type_hierarchy](#open_type_hierarchy)                                     | Checks if class modifiers exist (final, sealed, etc.)                          | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [shrink_wrapped_scroll_view](#shrink_wrapped_scroll_view)                       | Checks the content of the scroll view is shrink wrapped.                       | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [unnecessary_rebuilds_from_media_query](#unnecessary_rebuilds_from_media_query) | Checks `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)` usages. | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [unsafe_null_assertion](#unsafe_null_assertion)                                 | Checks usage of the `!` operator for forced type casting.                      | Any versions nilts supports | Practice  |     Stable     |   Info   |    ✅️    |
| [unstable_enum_name](#unstable_enum_name)                                       | Checks usage of enum name property.                                            | Any versions nilts supports | Practice  |     Stable     |   Info   |    ❌     |
| [unstable_enum_values](#unstable_enum_values)                                   | Checks usage of enum values property.                                          | Any versions nilts supports | Practice  |     Stable     |   Info   |    ❌     |

### Details

#### defined_async_callback_type

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `Future<void> Function()` with `AsyncCallback`, which is defined in the Flutter SDK.

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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `Future<T> Function()` with `AsyncValueGetter`, which is defined in the Flutter SDK.

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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `Future<void> Function(T value)` with `AsyncValueSetter`, which is defined in the Flutter SDK.

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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `void Function(T value)` with `ValueChanged`, which is defined in the Flutter SDK.
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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `T Function()` with `ValueGetter`, which is defined in the Flutter SDK.

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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `void Function(T value)` with `ValueSetter`, which is defined in the Flutter SDK.
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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** replacing `void Function()` with `VoidCallback`, which is defined in the Flutter SDK.

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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** using `Text.rich` or adding the `textScaler` or `textScaleFactor` (deprecated in Flutter 3.16.0 and above) argument to the `RichText` constructor to make the text size responsive to user settings.

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
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** using the `setUp` function or performing initialization at the top level or within the test group body.
`setUpAll` may cause flaky tests when tests run concurrently.

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
- Target SDK     : >= Dart 3.6.0
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
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
- Maturity level : Stable
- Severity       : Info
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
- Maturity level : Stable
- Severity       : Info
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

#### open_type_hierarchy

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** adding a class modifier (final, sealed, etc.) to explicitly define the inheritance policy of your class.

**BAD:**
<!-- prettier-ignore-start -->
```dart
class MyClass {}
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final class MyClass {}
```
<!-- prettier-ignore-end -->

</details>

#### shrink_wrapped_scroll_view

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Consider** removing the `shrinkWrap` argument and updating the widget to avoid shrink wrapping.
Shrink wrapping the content of a scroll view is significantly more expensive than expanding to the maximum allowed size because the content can expand and contract during scrolling, which means the size of the scroll view needs to be recomputed whenever the scroll position changes.

You can avoid shrink wrapping with the following 3 steps if your scroll view is nested:

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
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
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

**Note that using `MediaQuery.of` or `MediaQuery.maybeOf` makes sense in the following cases:**

- Wrapping a widget with `MediaQuery` to override `MediaQueryData`
- Observing all changes to `MediaQueryData`

See also:

- [MediaQuery as InheritedModel by moffatman · Pull Request #114459 · flutter/flutter](https://github.com/flutter/flutter/pull/114459)
- [MediaQuery class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)

</details>

#### unsafe_null_assertion

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Prefer** using the if-null operator, null-aware operator, or pattern matching instead of force type casting with the `!` operator.

**BAD:**
<!-- prettier-ignore-start -->
```dart
final value = someValue!;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final value = someValue ?? /* default value */;
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final value = someValue?.someMethod();
```
<!-- prettier-ignore-end -->

See also:

- [Operators | Dart](https://dart.dev/language/operators)
- [Patterns | Dart](https://dart.dev/language/patterns)

</details>

#### unstable_enum_name

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ❌
<!-- prettier-ignore-end -->

**Consider** using a more stable way to handle enum values.
The `name` property is a string representation of the enum value,
which can be changed without breaking the code.

**BAD:**

<!-- prettier-ignore-start -->
```dart
void printColorValue(Color color) {
  print(color.name); // 'red', 'green', 'blue'
}
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
enum Color {
  red,
  green,
  blue,
  ;

  String get id => switch (this) {
    red => 'red',
    green => 'green',
    blue => 'blue',
  };
}

void printColorValue(Color color) {
  print(color.id);
}
```
<!-- prettier-ignore-end -->

See also:

- [Enums | Dart](https://dart.dev/language/enums)

</details>

#### unstable_enum_values

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ❌
<!-- prettier-ignore-end -->

**Consider** using a more stable way to handle enum values.
The `values` property returns a mutable List, which can be modified
and may cause unexpected behavior.

**BAD:**

<!-- prettier-ignore-start -->
```dart
enum Color { red, green, blue }

void printColors() {
  for (final color in Color.values) {
    print(color);
  }
}
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
enum Color { red, green, blue }

void printColors() {
  final colors = [Color.red, Color.green, Color.blue];
  for (final color in colors) {
    print(color);
  }
}
```
<!-- prettier-ignore-end -->

See also:

- [Enums - Dart language specification](https://dart.dev/language/enums)

</details>

## Assists

Coming soon... 🚀

## Feature requests

If you have any feature requests, please create [an issue from this template](https://github.com/dassssshers/nilts/issues/new?&labels=feat&template=feat.yml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/dassssshers/nilts/issues/new?&labels=bug&template=bug.yml).

## Contributing

Contributions are welcome!
Please read the [CONTRIBUTING](https://github.com/dassssshers/nilts/blob/main/CONTRIBUTING.md) guide before submitting your PR.
