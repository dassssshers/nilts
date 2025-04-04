<div align="center">

# nilts_clock

nilts_clock is lint rules, quick fixes and assists for Dart and Flutter projects using [clock](https://pub.dev/packages/clock) package that helps you enforce best practices, and avoid errors.

[![build][badge-build]](https://github.com/dassssshers/nilts/actions/workflows/build.yml)
[![pub][badge-pub]](https://pub.dev/packages/nilts_clock)
[![license][badge-license]](https://github.com/dassssshers/nilts/blob/main/packages/nilts_clock/LICENSE)

[badge-build]: https://img.shields.io/github/actions/workflow/status/dassssshers/nilts/build.yml?style=for-the-badge&logo=github%20actions&logoColor=%232088FF&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Factions%2Fworkflows%2Fbuild.yml
[badge-pub]: https://img.shields.io/pub/v/nilts_clock?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fnilts_clock
[badge-license]: https://img.shields.io/badge/license-mit-green?style=for-the-badge&logo=github&logoColor=%23181717&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Fblob%2Fmain%2Fpackages%nilts_clock%2FLICENSE

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

nilts_clock depends on [`custom_lint`](https://github.com/invertase/dart_custom_lint).
You should add `nilts_clock` and `custom_lint` to your `dev_dependencies` in `pubspec.yaml` file.

<!-- prettier-ignore-start -->
```yaml
dev_dependencies:
  custom_lint: <version>
  nilts_clock: <version>
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

You can configure all lint rules provided by `nilts_clock` in `analysis_options.yaml` file.
Choice one of the following configuration strategies.

### Disabling strategy

All of `nilts_clock` rules are enabled by default.
Add lint rule name and set `false` to disable it.

<!-- prettier-ignore-start -->
```yaml
custom_lint:
  rules:
    # Disable particular lint rules if you want ignore them whole package.
    - unnecessary_hook_widget: false
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
    - unnecessary_hook_widget: true
```
<!-- prettier-ignore-end -->

**NOTE: If you `enable_all_lint_rules` set to `false`, all of lint rules (not only all of nilts_clock's lint rules) depends on `custom_lint` will be disabled by default.**

## Lint rules and quick fixes

Read below to learn about each lint rules intend to.
Some of lint rules support quick fixes on IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/assets/12420269/2205daf8-1bbd-4a16-a5eb-47eb75f08536)

### Overview

| Rule name                                   | Overview                            |            Target SDK             | Rule type  | Maturity level | Quick fix |
| ------------------------------------------- | :---------------------------------- | :-------------------------------: | :--------: | :------------: | :-------: |
| [using_date_time_now](#using_date_time_now) | Checks if `DateTime.now()` is used. | Any versions nilts_clock supports | ErrorProne |  Experimental  |    ✅️    |

### Details

#### using_date_time_now

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts_clock supports
- Rule type      : ErrorProne
- Maturity level : Experimental
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**DON'T** use `DateTime.now()`.

If your project depends on `clock` package and expects current time is encapsulated,
always use `clock.now()` instead for consistency.

**BAD:**

<!-- prettier-ignore-start -->
```dart
final dateTimeNow = DateTime.now();
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
final clockNow = clock.now();
```
<!-- prettier-ignore-end -->

See also:

- [clock | Dart package](https://pub.dev/packages/clock)

</details>

## Assists

Upcoming... 🚀

## Known issues

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
