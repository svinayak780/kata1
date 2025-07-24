import 'dart:io';

import 'package:args/args.dart';

const String version = '0.0.1';

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

void printUsage(ArgParser argParser) {
  print('Usage: dart kata1.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;
    late String input;

    // Process the parsed arguments.
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

    // Act on the arguments provided.
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
    // Check if the input string is provided.
    if (results.rest.isEmpty) {
      print('No arguments provided. Please provide a string to add.');
      // Read input from stdin if no arguments are provided.
      List<String> lines = [];
      String?
      line; // Use nullable String to handle potential null from readLineSync()

      do {
        line = stdin.readLineSync();
        if (line != null && line.isNotEmpty) {
          lines.add(line);
        }
      } while (line != null && line.isNotEmpty);
      input = lines.join('\n');
    } else {
      // Use the first argument as input.
      input = results.rest.first;
    }
    // Call `add` function with the input string.
    print(add(input));
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}

int add(String numbers) {
  if (numbers.isEmpty) {
    return 0;
  }
  return addNumbers(extractNumbers(numbers));
}

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

List<int> extractNumbers(String input) {
  if (input.startsWith('//')) {
    final delimiter = extractDelimiter(input);
    final buffer = input.split('\n').sublist(1).join(',');
    final bufferList = buffer.split(RegExp('[${delimiter.join('')},]'));
    return bufferList.map(int.parse).toList();
  } else {
    return input.split('\n').join(',').split(',').map(int.parse).toList();
  }
}

int addNumbers(List<int> numbers) {
  final negatives = numbers.where((n) => n < 0).toList();
  if (negatives.isNotEmpty) {
    throw FormatException('negatives not allowed: ${negatives.join(', ')}');
  }
  return numbers.fold(0, (a, b) => b < 1000 ? a + b : a);
}
