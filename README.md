<div align="center">

# nilts

nilts is lint rules, quick fixes and assists for Dart and Flutter projects that helps you enforce best practices, and avoid errors.

[![build][badge-build]](https://github.com/dassssshers/nilts/actions/workflows/build.yml)
[![license][badge-license]](https://github.com/dassssshers/nilts/blob/main/packages/nilts/LICENSE)

[badge-build]: https://img.shields.io/github/actions/workflow/status/dassssshers/nilts/build.yml?style=for-the-badge&logo=github%20actions&logoColor=%232088FF&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Factions%2Fworkflows%2Fbuild.yml
[badge-license]: https://img.shields.io/badge/license-mit-green?style=for-the-badge&logo=github&logoColor=%23181717&color=gray&link=https%3A%2F%2Fgithub.com%2Fdassssshers%2Fnilts%2Fblob%2Fmain%2Fpackages%2Fnilts%2FLICENSE

</div>

---

![Quick fix demo](https://github.com/ronnnnn/nilts/assets/12420269/2205daf8-1bbd-4a16-a5eb-47eb75f08536)

## Contents

- [Packages](#packages)
- [Usage](#usage)
- [Known issues](#known-issues)
- [Feature requests](#feature-requests)
- [Bug reports](#bug-reports)
- [Contributing](#contributing)

## Packages

This repository is a collection of the following packages.

| Package                                                                                            | pub.dev                                                                               | description                              |
| -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ---------------------------------------- |
| [nilts](https://github.com/dassssshers/nilts/tree/main/packages/nilts)                             | [![pub][badge-pub-nilts]](https://pub.dev/packages/nilts)                             | For Dart and Flutter projects            |
| [nilts_core](https://github.com/dassssshers/nilts/tree/main/packages/nilts_core)                   | [![pub][badge-pub-nilts-core]](https://pub.dev/packages/nilts_core)                   | Helper package for another packages      |
| [nilts_flutter_hooks](https://github.com/dassssshers/nilts/tree/main/packages/nilts_flutter_hooks) | [![pub][badge-pub-nilts-flutter-hooks]](https://pub.dev/packages/nilts_flutter_hooks) | For Flutter projects using flutter_hooks |

[badge-pub-nilts]: https://img.shields.io/pub/v/nilts?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fnilts
[badge-pub-nilts-core]: https://img.shields.io/pub/v/nilts_core?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fnilts_core
[badge-pub-nilts-flutter-hooks]: https://img.shields.io/pub/v/nilts_flutter_hooks?style=for-the-badge&logo=dart&logoColor=%230175C2&color=gray&link=https%3A%2F%2Fpub.dev%2Fpackages%nilts_flutter_hooks

## Usage

Check out the each package's README for more details.

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
