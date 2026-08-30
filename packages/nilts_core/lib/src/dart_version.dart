import 'dart:io';

import 'package:meta/meta.dart';

/// A class that represents the Dart version.
///
/// The Dart versioning string from [Platform.version] is as follows:
///
/// ```txt
/// // stable channel
/// 3.0.5 (stable) (Mon Jun 12 18:31:49 2023 +0000) on "macos_arm64"
/// // beta channel
/// 3.0.0-417.4.beta (beta) (Tue May 2 10:26:14 2023 +0000) on "macos_arm64"
/// // dev channel
/// 3.0.0-417.0.dev (dev) (Thu Apr 6 09:10:27 2023 -0700) on "macos_arm64"
/// ```
///
/// See also:
///
/// - [Get the Dart SDK | Dart](https://dart.dev/get-dart#release-channels)
@immutable
class DartVersion {
  /// Creates a new [DartVersion] instance.
  const DartVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.pre,
    this.prePatch,
    this.channel = DartReleaseChannel.stable,
  });

  /// Creates a new [DartVersion] instance from [Platform.version].
  factory DartVersion.fromPlatform() {
    return DartVersion.fromString(Platform.version);
  }

  /// Creates a new [DartVersion] instance from the given [version].
  factory DartVersion.fromString(String version) {
    final pattern = RegExp(
      r'^(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(-(?<pre>0|[1-9]\d*)\.(?<prePatch>0|[1-9]\d*)\.(?<channel>(beta|dev)?))?.*$',
    );
    final match = pattern.firstMatch(version);
    if (match == null) {
      throw ArgumentError('Invalid Dart versioning string');
    }

    final major = match.namedGroup('major');
    final minor = match.namedGroup('minor');
    final patch = match.namedGroup('patch');
    final pre = match.namedGroup('pre');
    final prePatch = match.namedGroup('prePatch');
    final channelString = match.namedGroup('channel');

    if (major == null || minor == null || patch == null) {
      throw ArgumentError('Invalid Dart versioning string');
    }
    if (channelString != null &&
        channelString != 'beta' &&
        channelString != 'dev') {
      throw ArgumentError('Invalid Dart versioning string');
    }
    if (channelString != null && (pre == null || prePatch == null)) {
      throw ArgumentError('Invalid Dart versioning string');
    }
    if (channelString == null && (pre != null || prePatch != null)) {
      throw ArgumentError('Invalid Dart versioning string');
    }

    final DartReleaseChannel channel;
    switch (channelString) {
      case 'dev':
        channel = DartReleaseChannel.dev;
      case 'beta':
        channel = DartReleaseChannel.beta;
      case null:
        channel = DartReleaseChannel.stable;
      default:
        throw ArgumentError('Invalid Dart versioning string');
    }

    return DartVersion(
      major: int.parse(major),
      minor: int.parse(minor),
      patch: int.parse(patch),
      pre: pre == null ? null : int.parse(pre),
      prePatch: prePatch == null ? null : int.parse(prePatch),
      channel: channel,
    );
  }

  /// The major version.
  final int major;

  /// The minor version.
  final int minor;

  /// The patch version.
  final int patch;

  /// The prerelease version.
  final int? pre;

  /// The prerelease patch version.
  final int? prePatch;

  /// The channel
  final DartReleaseChannel channel;

  /// Whether this version is stable.
  bool get isStable => channel == DartReleaseChannel.stable;

  /// Whether this version is beta.
  bool get isBeta => channel == DartReleaseChannel.beta;

  /// Whether this version is dev.
  bool get isDev => channel == DartReleaseChannel.dev;

  /// Whether this version is newer release than [other].
  ///
  /// Returns `1` if this version is newer than [other].
  /// Returns `-1` if this version is older than [other].
  /// Returns `0` if this version is same as [other].
  int compareTo(DartVersion other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    }
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }
    if (patch != other.patch) {
      return patch.compareTo(other.patch);
    }
    if (channel != other.channel) {
      if (isStable) {
        return 1;
      } else if (isBeta) {
        if (other.isStable) {
          return -1;
        } else if (other.isDev) {
          return 1;
        }
      } else if (isDev) {
        if (other.isStable) {
          return -1;
        } else if (other.isBeta) {
          return -1;
        }
      }
    }
    if (pre != other.pre) {
      return pre!.compareTo(other.pre!);
    }
    if (prePatch != other.prePatch) {
      return prePatch!.compareTo(other.prePatch!);
    }
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DartVersion &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          pre == other.pre &&
          prePatch == other.prePatch &&
          channel == other.channel;

  @override
  int get hashCode =>
      major.hashCode ^
      minor.hashCode ^
      patch.hashCode ^
      patch.hashCode ^
      prePatch.hashCode ^
      channel.hashCode;

  /// Whether this version is older release than [other].
  bool operator <(DartVersion other) => compareTo(other) < 0;

  /// Whether this version is older or same release than [other].
  bool operator <=(DartVersion other) => compareTo(other) <= 0;

  /// Whether this version is newer release than [other].
  bool operator >(DartVersion other) => compareTo(other) > 0;

  /// Whether this version is newer or same release than [other].
  bool operator >=(DartVersion other) => compareTo(other) >= 0;

  @override
  String toString() {
    final mainVersion = '$major.$minor.$patch';
    if (isStable) return mainVersion;

    return '$mainVersion-$pre.$prePatch.$channel';
  }
}

/// Enum of Dart release channel.
///
/// See also:
///
/// - [Get the Dart SDK | Dart](https://dart.dev/get-dart#release-channels)
enum DartReleaseChannel {
  /// Stable channel.
  stable,

  /// Beta channel.
  beta,

  /// Dev channel.
  dev,
}
