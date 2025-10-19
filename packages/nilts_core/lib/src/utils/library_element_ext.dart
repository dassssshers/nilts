import 'package:analyzer/dart/element/element.dart';

/// Extension methods for [LibraryElement].
extension LibraryElementExt on LibraryElement {
  /// Returns `true` if this library is from the package
  /// with the given [packageName].
  bool checkPackage({required String packageName}) {
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
