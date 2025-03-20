const String? nullableString = null;
const String nonNullableString = 'nonNullableString';

void main() {
  // expect_lint: unsafe_null_assertion
  nullableString!.length;
  (nullableString ?? '').length;
  nonNullableString.length;
}
