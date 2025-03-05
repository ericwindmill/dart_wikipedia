import 'dart:async';

import 'package:command_runner/command_runner.dart';

class PrettyEcho extends Command<String> {
  PrettyEcho() {
    addFlag(
      'blue-only',
      abbr: 'b',
      help: 'When true, the echoed text will all be blue.',
    );
  }

  @override
  String get name => 'echo';

  @override
  bool get requiresArgument => true;

  @override
  String get description => 'Print input, but colorful.';

  @override
  String? get help =>
      'echos a String provided as an argument with ANSI coloring,';

  @override
  String? get valueHelp => 'STRING';

  @override
  FutureOr<String> run(ArgResults arg) {
    if (arg.commandArg == null) {
      throw ArgumentException(
        'This argument requires one positional argument',
        name,
      );
    }

    List<String> prettyWords = [];
    var words = arg.commandArg!.split(' ');
    for (var i = 0; i < words.length; i++) {
      var word = words[i];
      switch (i % 3) {
        case 0:
          prettyWords.add(word.titleText);
        case 1:
          prettyWords.add(word.instructionText);
        case 2:
          prettyWords.add(word.errorText);
      }
    }

    return prettyWords.join(' ');
  }
}

void main(List<String> arguments) {
  final runner = CommandRunner<String>()..addCommand(PrettyEcho());

  runner.run(arguments);
}
