<div align="center">

# nilts_flutter_hooks

nilts_flutter_hooks provides lint rules, quick fixes, and assists for Dart and Flutter projects to help you enforce best practices and avoid errors.

[![build][badge-build]](https://github.com/dassssshers/nilts/actions/workflows/build.yml)
[![pub][badge-pub]](https://pub.dev/packages/nilts_flutter_hooks)
[![license][badge-license]](https://github.com/dassssshers/nilts/blob/main/packages/nilts_flutter_hooks/LICENSE)

[badge-build]: https://img.shields.io/github/actions/workflow/status/dassssshers/nilts/build.yml?style=for-the-badge&logo=github%20actions&logoColor=%232088FF&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Factions%2Fworkflows%2Fbuild.yml
[badge-pub]: https://img.shields.io/pub/v/nilts_flutter_hooks?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%nilts_flutter_hooks
[badge-license]: https://img.shields.io/badge/license-mit-green?style=for-the-badge&logo=github&logoColor=%23181717&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Fblob%2Fmain%2Fpackages%nilts_flutter_hooks%2FLICENSE

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

**Note:** nilts_flutter_hooks no longer supports [`custom_lint`](https://github.com/invertase/dart_custom_lint).
If you're using `custom_lint`, please use nilts_flutter_hooks versions below v1.0 and refer to [README_CUSTOM_LINT.md](README_CUSTOM_LINT.md).

If you're using Dart SDK version 3.10 or later, add nilts_flutter_hooks to the **top-level** plugins section of your `analysis_options.yaml` file:

<!-- prettier-ignore-start -->
```yaml
plugins:
  nilts_flutter_hooks: ^1.0.0
```
<!-- prettier-ignore-end -->

## Configuration

All lint rules in nilts_flutter_hooks are **disabled by default**.

This is because rules defined in `warnings` cannot currently be disabled individually. By using `diagnostics`, you can enable only the rules you need.

To enable rules, use the map format with `version:` and `diagnostics:`:

<!-- prettier-ignore-start -->
```yaml
plugins:
  nilts_flutter_hooks:
    version: ^1.0.0
    diagnostics:
      unnecessary_hook_widget: true
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

| Rule name                                           | Overview                                                 |                Target SDK                 | Rule type | Maturity level | Severity | Quick fix |
| --------------------------------------------------- | :------------------------------------------------------- | :---------------------------------------: | :-------: | :------------: | :------: | :-------: |
| [unnecessary_hook_widget](#unnecessary_hook_widget) | Checks if the widget is unnecessary to use `HookWidget`. | Any versions nilts_flutter_hooks supports | Practice  |     Stable     |   Info   |    ✅️    |

### Details

#### unnecessary_hook_widget

<details>

<!-- prettier-ignore-start -->
- Target SDK     : Any versions nilts_flutter_hooks supports
- Rule type      : Practice
- Maturity level : Stable
- Severity       : Info
- Quick fix      : ✅
<!-- prettier-ignore-end -->

**Prefer** using `StatelessWidget` instead of `HookWidget` when no hooks are used within the widget.

**BAD:**
<!-- prettier-ignore-start -->
```dart
class MyWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```
<!-- prettier-ignore-end -->

**GOOD:**

<!-- prettier-ignore-start -->
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```
<!-- prettier-ignore-end -->

See also:

- [HookWidget class - flutter_hooks API](https://pub.dev/documentation/flutter_hooks/latest/flutter_hooks/HookWidget-class.html)
- [StatelessWidget class - widgets library - Dart API](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)

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
