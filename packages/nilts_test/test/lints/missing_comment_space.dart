// This is a comment
//
// This is a comment
final class A {}

// expect_lint: missing_comment_space
//This is a comment
final class B {}

/// This is a comment
///
/// This is a comment
final class C {}

// expect_lint: missing_comment_space
///This is a comment
final class D {}
