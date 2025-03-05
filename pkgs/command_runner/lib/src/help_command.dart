/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'dart:async';

import '../command_runner.dart';

/// Prints program and argument usage.
///
/// When given a command as an argument, it prints the usage of
/// that command only, including its options and other details.
/// When the flag 'verbose' is set, it prints options and details for all commands.
///
/// This command isn't automatically added to CommandRunner instances.
/// Packages users should add it themselves with [CommandRunner.addCommand],
/// or create their own command that prints usage.
class HelpCommand extends Command<String> {
  HelpCommand() {
    addFlag(
      'verbose',
      abbr: 'v',
      help: 'When true, this command will print each command and its options.',
    );
    addOption(
      'command',
      abbr: 'c',
      help:
          "When a command is passed as an argument, prints only that command's verbose usage.",
    );
  }
  @override
  String get name => 'help';

  @override
  String get description => 'Prints usage information to the command line.';

  @override
  String? get help => 'Prints this usage information';

  @override
  FutureOr<String> run(ArgResults args) async {
    final buffer = StringBuffer();
    buffer.writeln(runner.usage);

    if (args.flag('verbose')) {
      for (var cmd in runner.commands) {
        buffer.write(_renderCommandVerbose(cmd));
      }

      return buffer.toString();
    }

    // If an arg was passed in, verbose print that command's usage only
    if (args.hasOption('command')) {
      var (:option, :input) = args.getOption('command');

      var cmd = runner.commands.firstWhere(
        (command) => command.name == input,
        orElse: () {
          throw ArgumentException(
            'Input ${args.commandArg} is not a known command.',
          );
        },
      );

      return _renderCommandVerbose(cmd);
    }

    // Verbose is false and no arg was passed in, so print basic usage.
    for (var command in runner.commands) {
      buffer.writeln(command.usage);
    }

    return buffer.toString();
  }

  String _renderCommandVerbose(Command cmd) {
    final indent = ' ' * 10;
    final buffer = StringBuffer();
    buffer.writeln(cmd.usage); //abbr, name: description
    buffer.writeln('$indent ${cmd.help}');
    if (cmd.valueHelp != null) {
      buffer.writeln(
        '$indent [Argument] Required? ${cmd.requiresArgument}, Type: ${cmd.valueHelp}, Default: ${cmd.defaultValue ?? 'none'}',
      );
    }
    buffer.writeln('$indent Options:');
    for (var option in cmd.options) {
      buffer.writeln('$indent ${option.usage}');
    }
    return buffer.toString();
  }
}
