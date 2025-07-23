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
    if (results.rest.isEmpty) {
      print('No input provided. Please provide a string to add.');
      return;
    }
    print(add(results.rest.first));
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}

int add(String input) {
  if (input.isEmpty) {
    return 0;
  }
  // Placeholder for actual calculation logic.
  return input.length; // Example: return the length of the input string.
}
