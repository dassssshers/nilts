<div align="center">

# nilts_clock

nilts_clock provides lint rules, quick fixes, and assists for Dart and Flutter projects using the [clock](https://pub.dev/packages/clock) package to help you enforce best practices and prevent errors.

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
- [Lint rules and quick fixes](#lint-rules-and-quick-fixes)
    - [Overview](#overview)
    - [Details](#details)
- [Assists](#assists)
- [Feature requests](#feature-requests)
- [Bug reports](#bug-reports)
- [Contributing](#contributing)

## Usage

**Note:** nilts_clock no longer supports [`custom_lint`](https://github.com/invertase/dart_custom_lint).
If you're using `custom_lint`, please use nilts_clock versions below v1.0 and refer to [README_CUSTOM_LINT.md](README_CUSTOM_LINT.md).

If you're using Dart SDK version 3.10 or later, add nilts_clock to the **top-level** plugins section of your `analysis_options.yaml` file:

<!-- prettier-ignore-start -->
```yaml
plugins:
  nilts_clock: ^1.0.0
```
<!-- prettier-ignore-end -->

## Configuration

All lint rules in nilts_clock are **disabled by default**.

This is because rules defined in `warnings` cannot currently be disabled individually. By using `diagnostics`, you can enable only the rules you need.

To enable rules, use the map format with `version:` and `diagnostics:`:

<!-- prettier-ignore-start -->
```yaml
plugins:
  nilts_clock:
    version: ^1.0.0
    diagnostics:
      using_date_time_now: true
```
<!-- prettier-ignore-end -->

For a complete example of enabling all rules, see [`analysis_options.yaml`](https://github.com/dassssshers/nilts/blob/main/analysis_options.yaml).

See also:

- [Analyzer plugins | Dart](https://dart.dev/tools/analyzer-plugins)

## Lint rules and quick fixes

See below to learn what each lint rule does.
Some rules support quick fixes in your IDE.

![Quick fix demo](https://github.com/ronnnnn/nilts/assets/12420269/2205daf8-1bbd-4a16-a5eb-47eb75f08536)

### Overview

| Rule name                                   | Overview                            |            Target SDK             | Rule type  | Maturity level | Severity | Quick fix |
| ------------------------------------------- | :---------------------------------- | :-------------------------------: | :--------: | :------------: | :------: | :-------: |
| [using_date_time_now](#using_date_time_now) | Checks if `DateTime.now()` is used. | Any versions nilts_clock supports | ErrorProne |     Stable     |   Info   |    ✅️    |

### Details

#### using_date_time_now

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts_clock supports
- Rule type      : ErrorProne
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**DON'T** use `DateTime.now()`.

If your project depends on the `clock` package and expects the current time to be encapsulated,
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

Coming soon... 🚀

## Feature requests

Have a feature request? Please [create an issue using this template](https://github.com/dassssshers/nilts/issues/new?&labels=feat&template=feat.yml).

## Bug reports

Found a bug? Please [create an issue using this template](https://github.com/dassssshers/nilts/issues/new?&labels=bug&template=bug.yml).

## Contributing

Contributions are welcome!
Please read the [CONTRIBUTING](https://github.com/dassssshers/nilts/blob/main/CONTRIBUTING.md) guide before submitting your PR.
