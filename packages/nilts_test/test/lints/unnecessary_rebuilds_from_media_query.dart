// ignore_for_file: document_ignores
// ignore_for_file: unused_local_variable
// ignore_for_file: invalid_null_aware_operator
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: unnecessary_rebuilds_from_media_query
    MediaQuery.of(context);
    // expect_lint: unnecessary_rebuilds_from_media_query
    MediaQuery.maybeOf(context);

    // expect_lint: unnecessary_rebuilds_from_media_query
    final size = MediaQuery.of(context).size;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final nullableSize = MediaQuery.of(context)?.size;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeSize = MediaQuery.maybeOf(context)?.size;

    // expect_lint: unnecessary_rebuilds_from_media_query
    final orientation = MediaQuery.of(context).orientation;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final textScaler = MediaQuery.of(context).textScaler;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final padding = MediaQuery.of(context).padding;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final viewInsets = MediaQuery.of(context).viewInsets;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final systemGestureInsets = MediaQuery.of(context).systemGestureInsets;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final viewPadding = MediaQuery.of(context).viewPadding;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final alwaysUse24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final accessibleNavigation = MediaQuery.of(context).accessibleNavigation;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final invertColors = MediaQuery.of(context).invertColors;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final highContrast = MediaQuery.of(context).highContrast;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final onOffSwitchLabels = MediaQuery.of(context).onOffSwitchLabels;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final boldText = MediaQuery.of(context).boldText;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final navigationMode = MediaQuery.of(context).navigationMode;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final gestureSettings = MediaQuery.of(context).gestureSettings;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final displayFeatures = MediaQuery.of(context).displayFeatures;

    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeOrientation = MediaQuery.maybeOf(context)?.orientation;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeDevicePixelRatio = MediaQuery.maybeOf(context)?.devicePixelRatio;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeTextScaleFactor = MediaQuery.maybeOf(context)?.textScaleFactor;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeTextScaler = MediaQuery.maybeOf(context)?.textScaler;
    final maybePlatformBrightness =
        // expect_lint: unnecessary_rebuilds_from_media_query
        MediaQuery.maybeOf(context)?.platformBrightness;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybePadding = MediaQuery.maybeOf(context)?.padding;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeViewInsets = MediaQuery.maybeOf(context)?.viewInsets;
    final maybeSystemGestureInsets =
        // expect_lint: unnecessary_rebuilds_from_media_query
        MediaQuery.maybeOf(context)?.systemGestureInsets;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeViewPadding = MediaQuery.maybeOf(context)?.viewPadding;
    final maybeAlwaysUse24HourFormat =
        // expect_lint: unnecessary_rebuilds_from_media_query
        MediaQuery.maybeOf(context)?.alwaysUse24HourFormat;
    final maybeAccessibleNavigation =
        // expect_lint: unnecessary_rebuilds_from_media_query
        MediaQuery.maybeOf(context)?.accessibleNavigation;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeInvertColors = MediaQuery.maybeOf(context)?.invertColors;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeHighContrast = MediaQuery.maybeOf(context)?.highContrast;
    final maybeOnOffSwitchLabels =
        // expect_lint: unnecessary_rebuilds_from_media_query
        MediaQuery.maybeOf(context)?.onOffSwitchLabels;
    final maybeDisableAnimations =
        // expect_lint: unnecessary_rebuilds_from_media_query
        MediaQuery.maybeOf(context)?.disableAnimations;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeBoldText = MediaQuery.maybeOf(context)?.boldText;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeNavigationMode = MediaQuery.maybeOf(context)?.navigationMode;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeGestureSettings = MediaQuery.maybeOf(context)?.gestureSettings;
    // expect_lint: unnecessary_rebuilds_from_media_query
    final maybeDisplayFeatures = MediaQuery.maybeOf(context)?.displayFeatures;

    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
