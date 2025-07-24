import 'dart:io';

import 'package:args/args.dart';

const String version = '1.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

// Print usage information for the command-line tool.
void printUsage(ArgParser argParser) {
  print('Usage: dart kata1.dart <flags> [arguments]');
  print('<-------      ------->');
  print('Function: add numbers from a string input');
  print('Function: new lines work as delimiters');
  print("Function: multiline arguments can be specified as\n'''\n<input>\n'''");
  print(
    'Function: specify custom delimiters using "//<delimiter>" in the first line',
  );
  print(
    'Function: multicharacter delimiters are supported with "//[<delimiter>]"',
  );
  print(
    'Function: multiple custom delimiters can be specified with "//[<delimiter1>][<delimiter2>]"',
  );
  print('<-------      ------->');
  print('Constraint: negative numbers will throw an exception');
  print('Constraint: numbers greater than 1000 will be ignored');
  print('Constraint: empty strings will be ignored');
  print('Constraint: numbers must be integers');
  print(r'Constraint: "[" and "]" are reserved for custom delimiters');
  print('<-------      ------->');
  print('Flags:');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;
    late String input;

    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('kata1 version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    if (results.rest.isEmpty) {
      print('No arguments provided. Please provide a string to add.');
      // Read input from stdin if no arguments are provided.
      List<String> lines = [];
      String? line;

      do {
        line = stdin.readLineSync();
        if (line != null && line.isNotEmpty) {
          lines.add(line);
        }
      } while (line != null && line.isNotEmpty);
      input = lines.join('\n');
    } else {
      input = results.rest.join('\n');
    }
    // Call `add` function with the input string.
    print(add(input, verbose: verbose));
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    print('Use --help for usage information.');
  }
}

// add numbers from a list of integers
// returns the sum of the numbers
// throws FormatException if negative numbers are found
// ignores numbers greater than 1000
int add(String numbers, {bool? verbose}) {
  if (numbers.isEmpty) {
    return 0;
  }
  final extractedNumbers = extractNumbers(numbers.trim(), verbose: verbose);
  final negatives = extractedNumbers.where((n) => n < 0).toList();
  if (extractedNumbers.isNotEmpty) {
    throw FormatException('negatives not allowed: ${negatives.join(', ')}');
  }
  return extractedNumbers.fold(0, (a, b) => b < 1000 ? a + b : a);
}

// extract the delimiter from the input string
// returns a list of delimiters
// if no custom delimiter is found, returns a list with the default delimiter ','
List<String> extractDelimiter(String input) {
  final RegExp delimiterPattern = RegExp(r'^\/\/(.)\n(.|\n)*');
  final RegExp customDelimiterPattern = RegExp(r'^\/\/\[(.*)\]\n(.|\n)*');
  final matches = delimiterPattern.allMatches(input);
  if (matches.isNotEmpty) {
    return [matches.first.group(1) ?? ','];
  } else if (customDelimiterPattern.hasMatch(input)) {
    return customDelimiterPattern.firstMatch(input)?.group(1)?.split('][') ??
        [','];
  }
  return [','];
}

// extract numbers from the input string
// returns a list of integers
// if verbose is true, prints the detected delimiters and extracted numbers
List<int> extractNumbers(String input, {bool? verbose}) {
  if (input.startsWith('//')) {
    final delimiters = extractDelimiter(input);
    if (verbose == true) {
      print('[VERBOSE] Detected delimiters: $delimiters');
    }
    final buffer = input.split('\n').sublist(1).join(',');
    final bufferList = buffer.split(RegExp('[${delimiters.join('')},]'));
    if (verbose == true) {
      print('[VERBOSE] Extracted numbers: $bufferList');
    }
    return bufferList.map(int.parse).toList();
  } else {
    return input.split('\n').join(',').split(',').map(int.parse).toList();
  }
}
