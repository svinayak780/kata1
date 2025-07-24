import 'dart:math';

import 'package:test/test.dart';

import '../bin/kata1.dart';

void main() {
  group('Kata1 Argument Parser Tests', () {
    test('returns 0 against an empty string', () {
      expect(add(""), 0);
    });
    test('recognizes a custom delimiter', () {
      expect(extractDelimiter("//;\n1;2;3"), ';');
    });
    test('omit delimiter', () {
      expect(extractNumbers("1,2,3"), [1, 2, 3]);
    });
    test('extracts numbers with custom delimiter', () {
      expect(extractNumbers("//*\n1*2*3"), [1, 2, 3]);
    });
    test('adds numbers with custom delimiter', () {
      expect(add("//*\n1*2*3"), 6);
    });
    test('adds numbers with default delimiter', () {
      expect(add("1,2,3"), 6);
    });
    test('add numbers with random length', () {
      // Generate a random length and create a list of random numbers.
      final length = Random.secure().nextInt(100);
      List<int> numbers = List.generate(
        length,
        (index) => Random.secure().nextInt(100),
      );
      // Convert the list of numbers to a string with commas to act as a stubbed input.
      String input = numbers.join(',');
      // Call the add function and check if it returns the sum of the numbers.
      expect(add(input), numbers.fold(0, (a, b) => a + b));
    });
    test('new line as delimiter', () {
      expect(add("1\n2\n3"), 6);
    });
    test('new line with custom delimiter', () {
      expect(add("//;\n1;2\n3"), 6);
    });
    test('throws FormatException for negative numbers', () {
      expect(() => add("-1,2,-3"), throwsFormatException);
    });
    test('ignore numbers greater than 1000', () {
      expect(add("1,2,1001"), 3);
    });
    test('custom delimiter length', () {
      expect(add("//[***]\n1***2***3"), 6);
    });
  });
}
