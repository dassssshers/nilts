import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';

// ignore: deprecated_member_use remove this after nilts_core is updated
/// Extension methods for [LibraryElement].
// ignore: deprecated_member_use remove this after nilts_core is updated
extension LibraryElementExt on LibraryElement {
  /// Returns `true` if this library is from the package
  /// with the given [packageName].
  bool checkPackage({required String packageName}) {
    // FIXME: migrate when upgrade to analyzer 7.4.0 or later
    // https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/doc/element_model_migration_guide.md
    // ignore: deprecated_member_use
    final libraryUri = Uri.tryParse(identifier);
    if (libraryUri == null) return false;
    if (libraryUri.scheme != 'package') return false;
    if (libraryUri.pathSegments.first != packageName) return false;
    return true;
  }

  /// Returns `true` if this library is from the package `flutter`.
  bool get isFlutter => checkPackage(packageName: 'flutter');

  /// Returns `true` if this library is from the package `flutter_test`.
  bool get isFlutterTest => checkPackage(packageName: 'flutter_test');

  /// Returns `true` if this library is from the package `flutter_hooks`.
  bool get isFlutterHooks => checkPackage(packageName: 'flutter_hooks');
}

/// Extension methods for [LibraryElement2].
extension LibraryElement2Ext on LibraryElement2 {
  /// Returns `true` if this library is from the package
  /// with the given [packageName].
  bool checkPackage({required String packageName}) {
    // FIXME: migrate when upgrade to analyzer 7.4.0 or later
    // https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/doc/element_model_migration_guide.md
    // ignore: deprecated_member_use
    final libraryUri = Uri.tryParse(identifier);
    if (libraryUri == null) return false;
    if (libraryUri.scheme != 'package') return false;
    if (libraryUri.pathSegments.first != packageName) return false;
    return true;
  }

  /// Returns `true` if this library is from the package `flutter`.
  bool get isFlutter => checkPackage(packageName: 'flutter');

  /// Returns `true` if this library is from the package `flutter_test`.
  bool get isFlutterTest => checkPackage(packageName: 'flutter_test');

  /// Returns `true` if this library is from the package `flutter_hooks`.
  bool get isFlutterHooks => checkPackage(packageName: 'flutter_hooks');
}
