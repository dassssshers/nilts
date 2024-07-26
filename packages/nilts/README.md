<div align="center">

# nilts

nilts is lint rules, quick fixes and assists for Dart and Flutter projects that helps you enforce best practices, and avoid errors.

[![build][badge-build]](https://github.com/ronnnnn/nilts/actions/workflows/build.yml)
[![pub][badge-pub]](https://pub.dev/packages/nilts)
[![license][badge-license]](https://github.com/ronnnnn/nilts/blob/main/packages/nilts/LICENSE)

[badge-build]: https://img.shields.io/github/actions/workflow/status/ronnnnn/nilts/build.yml?style=for-the-badge&logo=github%20actions&logoColor=%232088FF&color=gray&link=https%3A%2F%2Fgithub.com%2Fronnnnn%2Fnilts%2Factions%2Fworkflows%2Fbuild.yml
[badge-pub]: https://img.shields.io/pub/v/nilts?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fnilts
[badge-license]: https://img.shields.io/badge/license-mit-green?style=for-the-badge&logo=github&logoColor=%23181717&color=gray&link=https%3A%2F%2Fgithub.com%2Fronnnnn%2Fnilts%2Fblob%2Fmain%2Fpackages%2Fnilts%2FLICENSE

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

```yaml
dev_dependencies:
  custom_lint: <version>
  nilts: <version>
```

And also, add `custom_lint` to your `analysis_options.yaml` file.

```yaml
analyzer:
  plugins:
    - custom_lint
```

## Configuration

You can configure all lint rules provided by `nilts` in `analysis_options.yaml` file.  
Choice one of the following configuration strategies.

### Disabling strategy

All of `nilts` rules are enabled by default.  
Add lint rule name and set `false` to disable it.

```yaml
custom_lint:
  rules:
    # Disable particular lint rules if you want ignore them whole package.
    - unnecessary_rebuilds_from_media_query: false
```

### Enabling strategy

You can disable all lint rules depends on custom_lint by setting `enable_all_lint_rules` to `false`.  
Add lint rule name and set `true` to enable it.

```yaml
custom_lint:
  # Disable all lint rules depends on custom_lint.
  enable_all_lint_rules: false
  rules:
    - unnecessary_rebuilds_from_media_query: true
```

**NOTE: If you `enable_all_lint_rules` set to `false`, all of lint rules (not only all of nilts's lint rules) depends on `custom_lint` will be disabled by default.**

## Lint rules and quick fixes

Read below to learn about each lint rules intend to.  
Some of lint rules support quick fixes on IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/assets/12420269/2205daf8-1bbd-4a16-a5eb-47eb75f08536)

### Overview

| Rule name                                                                           | Overview                                                                       |           Target SDK           | Rule type | Maturity level | Quick fix |
|-------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------|:------------------------------:| :-------: |:--------------:|:---------:|
| [defined\_async\_callback\_type](#defined_async_callback_type)                      | Checks `Future<void> Function()` definitions.                                  |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [defined\_async\_value\_getter\_type](#defined_async_value_getter_type)             | Checks `Future<T> Function()` definitions.                                     |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [defined\_async\_value\_setter\_type](#defined_async_value_setter_type)             | Checks `Future<void> Function(T value)` definitions.                           |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [defined\_value\_changed\_type](#defined_value_changed_type)                        | Checks `void Function(T value)` definitions.                                   |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [defined\_value\_getter\_type](#defined_value_getter_type)                          | Checks `T Function()` definitions.                                             |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [defined\_value\_setter\_type](#defined_value_setter_type)                          | Checks `void Function(T value)` definitions.                                   |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [defined\_void\_callback\_type](#defined_void_callback_type)                        | Checks `void Function()` definitions.                                          |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [fixed\_text\_scale\_rich\_text](#fixed_text_scale_rich_text)                       | Checks usage of `textScaler` or `textScaleFactor` in `RichText` constructor.   |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [flaky\_tests\_with\_set\_up\_all](#flaky_tests_with_set_up_all)                    | Checks `setUpAll` usages.                                                      |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [no\_support\_multi\_text\_direction](#no_support_multi_text_direction)             | Checks if supports `TextDirection` changes.                                    |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [no\_support\_web\_platform\_check](#no_support_web_platform_check)                 | Checks if `Platform.isXxx` usages.                                             |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [shrink\_wrapped\_scroll\_view](#shrink_wrapped_scroll_view)                        | Checks the content of the scroll view is shrink wrapped.                       |  Any versions nilts supports   | Practice  |  Experimental  |    ✅️     |
| [unnecessary\_rebuilds\_from\_media\_query](#unnecessary_rebuilds_from_media_query) | Checks `MediaQuery.xxxOf(context)` or `MediaQuery.maybeXxxOf(context)` usages. | >= Flutter 3.10.0 (Dart 3.0.0) | Practice  |  Experimental  |    ✅️     |

### Details

#### defined_async_callback_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `Future<void> Function()` with `AsyncCallback` which is defined in Flutter SDK.

**BAD:**

```dart
final Future<void> Function() callback;
```


**GOOD:**

```dart
final AsyncCallback callback;
```

See also:

- [AsyncCallback typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncCallback.html)

</details>

#### defined_async_value_getter_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `Future<T> Function()` with `AsyncValueGetter` which is defined in Flutter SDK.

**BAD:**

```dart
final Future<int> Function() callback;
```

**GOOD:**

```dart
final AsyncValueGetter<int> callback;
```

See also:

- [AsyncValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncValueGetter.html)

</details>

#### defined_async_value_setter_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `Future<void> Function(T value)` with `AsyncValueSetter` which is defined in Flutter SDK.

**BAD:**

```dart
final Future<void> Function(int value) callback;
```

**GOOD:**

```dart
final AsyncValueSetter<int> callback;
```

See also:

- [AsyncValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/AsyncValueSetter.html)

</details>

#### defined_value_changed_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `void Function(T value)` with `ValueChanged` which is defined in Flutter SDK.  
If the value has been set, use `ValueSetter` instead.

**BAD:**
```dart
final void Function(int value) callback;
```

**GOOD:**
```dart
final ValueChanged<int> callback;
```

See also:

- [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)
- [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)

</details>

#### defined_value_getter_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `T Function()` with `ValueGetter` which is defined in Flutter SDK.

**BAD:**
```dart
final int Function() callback;
```

**GOOD:**
```dart
final ValueGetter<int> callback;
```

See also:

- [ValueGetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueGetter.html)

</details>

#### defined_value_setter_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `void Function(T value)` with `ValueSetter` which is defined in Flutter SDK.  
If the value has changed, use `ValueChanged` instead.

**BAD:**
```dart
final void Function(int value) callback;
```

**GOOD:**
```dart
final ValueSetter<int> callback;
```

See also:

- [ValueSetter typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueSetter.html)
- [ValueChanged typedef - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/ValueChanged.html)

</details>

#### defined_void_callback_type

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** replace `void Function()` with `VoidCallback` which is defined in Flutter SDK.

**BAD:**

```dart
final void Function() callback;
```


**GOOD:**

```dart
final VoidCallback callback;
```

See also:

- [VoidCallback typedef - dart:ui library - Dart API](https://api.flutter.dev/flutter/dart-ui/VoidCallback.html)

</details>

#### fixed_text_scale_rich_text

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** using `Text.rich` or adding `textScaler` or `textScaleFactor` (deprecated on Flutter 3.16.0 and above) argument to `RichText` constructor to make the text size responsive for user setting.  

**BAD:**
```dart
RichText(
  text: TextSpan(
    text: 'Hello, world!',
  ),
)
```

**GOOD:**
```dart
Text.rich(
  TextSpan(
    text: 'Hello, world!',
  ),
)
```

**GOOD:**
```dart
RichText(
  text: TextSpan(
    text: 'Hello, world!',
  ),
  textScaler: MediaQuery.textScalerOf(context),
)
```

**GOOD (deprecated on Flutter 3.16.0 and above):**
```dart
RichText(
  text: TextSpan(
    text: 'Hello, world!',
  ),
  textScaleFactor: MediaQuery.textScaleFactorOf(context),
)
```

See also:
                           
- [Text.rich constructor - Text - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/Text/Text.rich.html)
- [RichText class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/RichText-class.html)

</details>

#### flaky_tests_with_set_up_all

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** using `setUp` function or initialization on top level or body of test group.
`setUpAll` may cause flaky tests with concurrency executions.

**BAD:**
```dart
setUpAll(() {
  // ...
});
```

**GOOD:**
```dart
setUp(() {
  // ...
});
```

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

See also:

- [setUpAll function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUpAll.html)
- [setUp function - flutter_test library - Dart API](https://api.flutter.dev/flutter/flutter_test/setUp.html)

</details>

#### no_support_multi_text_direction

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** using `TextDirection` aware configurations if your application supports different `TextDirection` languages.

**BAD:**
```dart
Align(
  alignment: Alignment.bottomLeft,
)
```

**BAD:**
```dart
Padding(
  padding: EdgeInsets.only(left: 16, right: 4),
)
```

**BAD:**
```dart
Positioned(left: 12, child: SizedBox())
```

**GOOD:**
```dart
Align(
  alignment: AlignmentDirectional.bottomStart,
)
```

**GOOD:**
```dart
Padding(
  padding: EdgeInsetsDirectional.only(start: 16, end: 4),
)
```

**GOOD:**
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

See also:

- [TextDirection enum - dart:ui library - Dart API](https://api.flutter.dev/flutter/dart-ui/TextDirection.html)
- [AlignmentDirectional class - painting library - Dart API](https://api.flutter.dev/flutter/painting/AlignmentDirectional-class.html)
- [EdgeInsetsDirectional class - painting library - Dart API](https://api.flutter.dev/flutter/painting/EdgeInsetsDirectional-class.html)
- [PositionedDirectional class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/PositionedDirectional-class.html)

</details>

#### no_support_web_platform_check

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

Prefer using `defaultTargetPlatform` instead of `Platform` API if you want to know which platform your application is running on.
This is because

- `Platform` API throws a runtime exception on web application.
- By combining `kIsWeb` and `defaultTargetPlatform`, you can accurately determine which platform your web application is running on.

**BAD:**
```dart
bool get isIOS => !kIsWeb && Platform.isIOS;
```

**GOOD:**
```dart
bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
```

See also:

- [defaultTargetPlatform property - foundation library - Dart API](https://api.flutter.dev/flutter/foundation/defaultTargetPlatform.html)

</details>

#### shrink_wrapped_scroll_view

<details>

- Target SDK     : Any versions nilts supports
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅

**Consider** removing `shrinkWrap` argument and update the Widget not to shrink wrap.  
Shrink wrapping the content of the scroll view is significantly more expensive than expanding to the maximum allowed size because the content can expand and contract during scrolling, which means the size of the scroll view needs to be recomputed whenever the scroll position changes.

You can avoid shrink wrap with 3 steps below in case of your scroll view is nested.

1. Replace the parent scroll view with `CustomScrollView`.
2. Replace the child scroll view with `SliverListView` or `SliverGridView`.
3. Set `SliverChildBuilderDelegate` to `delegate` argument of the `SliverListView` or `SliverGridView`.

**BAD:**
```dart
ListView(shrinkWrap: true)
```

**GOOD:**
```dart
ListView(shrinkWrap: false)
```

See also:

- [shrinkWrap property - ScrollView class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/ScrollView/shrinkWrap.html)
- [ShrinkWrap vs Slivers | Decoding Flutter - YouTube](https://youtu.be/LUqDNnv_dh0)

</details>

#### unnecessary_rebuilds_from_media_query

<details>

- Target SDK     : >= Flutter 3.10.0 (Dart 3.0.0)
- Rule type      : Practice
- Maturity level : Experimental
- Quick fix      : ✅
  
**Prefer** using `MediaQuery.xxxOf` or `MediaQuery.maybeXxxOf` instead of `MediaQuery.of` or `MediaQuery.maybeOf` to avoid unnecessary rebuilds.

**BAD:**

```dart
final size = MediaQuery.of(context).size;
```


**GOOD:**

```dart
final size = MediaQuery.sizeOf(context);
```

**Note that using `MediaQuery.of` or `MediaQuery.maybeOf` makes sense following cases:**

- wrap Widget with `MediaQuery` overridden `MediaQueryData`
- observe all changes of `MediaQueryData`  
  
See also:  

- [MediaQuery as InheritedModel by moffatman · Pull Request #114459 · flutter/flutter](https://github.com/flutter/flutter/pull/114459)
- [MediaQuery class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)

</details>

## Assists

Upcoming... 🚀

## Known issues

### Quick fix priorities
The priorities assigned to quick fixes are not currently visible in IntelliJ IDEA and Android Studio due to the lack of support for `PrioritizedSourceChange` in these environments.  
In contrast, VS Code does support this feature, allowing quick fixes to be listed along with their respective priorities.

|                                                           VS Code                                                            |                                                            IntelliJ IDEA / Android Studio                                                             |
|:----------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img width="500" alt="VS Code" src="https://github.com/ronnnnn/nilts/assets/12420269/b756c354-00f1-42f6-9fde-eaffce255811"/> |  <img width="500" alt="IntelliJ IDEA / Android Studio" src="https://github.com/ronnnnn/nilts/assets/12420269/99a1032b-db40-4376-8345-c5e960f156a2"/>  |

See also:

- [IDEA-336551 Support PrioritizedSourceChange on quick fix.](https://youtrack.jetbrains.com/issue/IDEA-336551/Support-PrioritizedSourceChange-on-quick-fix.)

### fix-all assist
The fix-all assist feature has been introduced in [custom_lint_builder 0.6.0](https://github.com/invertase/dart_custom_lint/pull/223).  
However, this feature is not yet supported in IntelliJ IDEA and Android Studio, owing to their current lack of support for `PrioritizedSourceChange`.

|                                                            VS Code                                                            |                                                            IntelliJ IDEA / Android Studio                                                            |
|:-----------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------:|
| <img width="500" alt="VS Code" src="https://github.com/ronnnnn/nilts/assets/12420269/3d8f7d66-5325-4877-b1f9-eb246c8edd00" /> | <img width="500" alt="IntelliJ IDEA / Android Studio" src="https://github.com/ronnnnn/nilts/assets/12420269/ce76bbd3-719c-4bce-8f54-7dea04354b5e" /> |

## Feature requests

If you have any feature requests, please create [an issue from this template](https://github.com/ronnnnn/nilts/issues/new?&labels=feat&template=feat.yml).

## Bug reports

If you find any bugs, please create [an issue from this template](https://github.com/ronnnnn/nilts/issues/new?&labels=bug&template=bug.yml).

## Contributing

Welcome your contributions!!  
Please read [CONTRIBUTING](https://github.com/ronnnnn/nilts/blob/main/CONTRIBUTING.md) docs before submitting your PR.
