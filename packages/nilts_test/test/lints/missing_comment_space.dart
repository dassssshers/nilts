// This is a comment
class A {}

// expect_lint: missing_comment_space
//This is a comment
class B {}

/// This is a comment
class C {}

// expect_lint: missing_comment_space
///This is a comment
class D {}
