const String? nullableString = null;

void main() {
  // expect_lint: no_force_unwrap
  nullableString!.length;
}
