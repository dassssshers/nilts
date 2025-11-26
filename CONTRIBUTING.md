## Contribution Flow

1. [Create or find an issue](#create-or-find-an-issue)
2. [Fork this repository and set up](#fork-this-repository-and-set-up)
3. [Create a branch and commit your changes](#create-a-branch-and-commit-your-changes)
4. [Create a Pull Request](#create-a-pull-request)

## Create or find an issue

Before contributing, find an issue you want to work on.
If you can't find a suitable issue, [create a new one here](https://github.com/dassssshers/nilts/issues/new/choose).

## Fork this repository and set up

Fork this repository and clone it to your local machine.

### Set up asdf (optional)

Using asdf is optional, but you **must** use SDK versions managed by the [`.tool-versions`](https://github.com/dassssshers/nilts/blob/main/.tool-versions) file.

This project uses [asdf](https://asdf-vm.com) to manage Dart and Flutter SDK versions.
If you want to use asdf, install it first.
After installing asdf, run the following command in the root of this repository:

```bash
asdf install
```

If you're not familiar with asdf, read the [asdf documentation](https://asdf-vm.com) first.

### Set up Melos

This project is built with [Melos](https://melos.invertase.dev).
Install Melos globally:

```bash
dart pub global activate melos
```

If you're not familiar with Melos, read the [Melos documentation](https://melos.invertase.dev) first.

### Set up the project

Run the `melos bootstrap` and `melos prepare` commands:

```bash
# You can use `melos bs` instead
melos bootstrap
melos prepare
```

### Set up Node.js packages (optional)

This is optional because CI will detect unformatted files.

If you want to format YAML, Markdown, XML, or JSON files, you can use the provided Node.js packages.
nilts uses [Prettier](https://prettier.io) to format these files.
These packages are managed by [bun](https://bun.sh/), with the version specified in the [`.tool-versions`](https://github.com/dassssshers/nilts/blob/main/.tool-versions) file.

```bash
# Install packages
bun i
# Format files
bun fmt
```

## Create a branch and commit your changes

Create a branch from `main` and commit your changes.

### Analyzer plugins

nilts is built on top of analyzer plugins, which were introduced in Dart 3.10.
Read the official documentation to understand how to write rules, fixes, and assists:

- [Analyzer plugins | Dart](https://dart.dev/tools/analyzer-plugins)

### Writing rules

nilts follows the [writing guidelines for Dart's official lint rules](https://github.com/dart-lang/sdk/blob/main/pkg/linter/doc/writing-lints.md).
Read this guide before creating a new lint rule and ensure your rules and documentation follow it.

#### Lint name

The lint name should briefly represent **what the problem is**.
It should be written in `lower_case_with_underscores`.

The lint rule class that extends `LintRule` should be named in `PascalCase`.

**DON'T** start the name with "always", "avoid", or "prefer".

#### Problem message

The problem message should provide details about the problem.

#### Quick fix name

The quick fix name should briefly represent **what to do** to fix the problem.

The quick fix class that extends `DartFix` should be named in `PascalCase`.

#### Quick fix message

The quick fix message should provide details about the fix.

## Create a Pull Request

After committing your changes, create a Pull Request.
Write a description of your changes following the [template](https://github.com/dassssshers/nilts/blob/main/.github/PULL_REQUEST_TEMPLATE.md).
Ensure all checks pass by following the checklist in the template.
