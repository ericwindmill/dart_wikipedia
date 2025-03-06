/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:command_runner/command_runner.dart';

/// Establishes a protocol for the app to communicate continuously with I/O.
/// When [run] is called, the app will start waiting for input from stdin.
/// Input can also be added programatically via the [onInput] method.
///
class CommandRunner<T> {
  CommandRunner({this.onOutput, this.onError});

  /// If not null, this method is used to handle output. Useful if you want to
  /// execute code before the output is printed to the console, or if you
  /// want to do something other than print output the console.
  /// If null, the onInput method will [print] the output.
  FutureOr<void> Function(String)? onOutput;

  FutureOr<void> Function(Object)? onError;

  final Map<String, Command<T>> _commands = <String, Command<T>>{};

  UnmodifiableSetView<Command<T>> get commands =>
      UnmodifiableSetView<Command<T>>(<Command<T>>{..._commands.values});

  void addCommand(Command<T> command) {
    if (_validateArgument(command)) {
      _commands[command.name] = command;
      command.runner = this;
    }
  }

  Future<void> run(List<String> input) async {
    try {
      final ArgResults results = parse(input);
      if (results.command != null) {
        T? output = await results.command!.run(results);
        if (onOutput != null) {
          await onOutput!(output.toString());
        } else {
          print(output.toString());
        }
      }
    } on Exception catch (e) {
      _onError(e);
    }
  }

  void _onError(Object error) {
    if (onError != null) {
      onError!(error);
    } else {
      throw error;
    }
  }

  /// Parses the arguments passed into the program
  /// This demo [CommandRunner] package requires a stricter structure than pkg:args.
  ///
  /// The following inputs would be parsed successfully.
  /// Minimum input:
  /// ```bash
  /// $ dart <executable>
  /// ```
  ///
  /// Only commands are top level inputs. There are no flags or options on the base executable.
  /// ```bash
  /// $ dart <executable> <command>
  /// ```
  ///
  /// Commands can take one position arg, which is a [String]. The positional arg can
  /// appear anywhere in the input (i.e. after options).
  /// ```bash
  /// $ dart <executable> <command> "positional arg"
  /// ```
  ///
  /// Commands can have options (including flags).
  /// Options take one arg, which is a [String]. It must immediately follow the option.
  /// Flags are [Option] objects that take no arguments, and are parsed into [bool] types
  /// ```bash
  /// $ dart <executable> <command> --<option> "arg" --<flag>
  /// ```
  ArgResults parse(List<String> input) {
    ArgResults results = ArgResults();
    if (input.isEmpty) return results;

    if (_commands.containsKey(input.first)) {
      results.command = _commands[input.first];
      input = input.sublist(1);
    } else {
      throw ArgumentException(
        'The first word of input must be a command.',
        null,
        input.first,
      );
    }
    if (results.command != null &&
        input.isNotEmpty &&
        _commands.containsKey(input.first)) {
      throw ArgumentException(
        'Input can only contain one command. Got ${input.first} and ${results.command!.name}',
        null,
        input.first,
      );
    }

    // Section: handle Options (including flags)
    Map<Option, Object?> inputOptions = {};
    int i = 0;
    while (i < input.length) {
      if (input[i].startsWith('-')) {
        var base = _removeDash(input[i]);
        var option = results.command!.options.firstWhere(
          (option) => option.name == base || option.abbr == base,
          orElse: () {
            throw ArgumentException(
              'Unknown option ${input[i]}',
              results.command!.name,
              input[i],
            );
          },
        );

        if (option.type == OptionType.flag) {
          // all flags are false by default, and true if they appear at all
          inputOptions[option] = true;
          i++;
          continue;
        }

        if (option.type == OptionType.option) {
          if (i + 1 >= input.length) {
            throw ArgumentException(
              'Option ${option.name} requires an argument',
              results.command!.name,
              option.name,
            );
          }
          if (input[i + 1].startsWith('-')) {
            throw ArgumentException(
              'Option ${option.name} requires an argument, but got another option ${input[i + 1]}',
              results.command!.name,
              option.name,
            );
          }
          var arg = input[i + 1];
          inputOptions[option] = arg;
          // increment 1 extra to account for the arg
          i++;
        }
        // The arg must be a positional arg
      } else {
        if (results.commandArg != null && results.commandArg!.isNotEmpty) {
          throw ArgumentException(
            'Commands can only have up to one argument.',
            results.command!.name,
            input[i],
          );
        }
        results.commandArg = input[i];
      }

      i++;
    }
    results.options = inputOptions;

    return results;
  }

  String _removeDash(String input) {
    if (input.startsWith('--')) {
      return input.substring(2);
    }
    if (input.startsWith('-')) {
      return input.substring(1);
    }
    return input;
  }

  /// Returns usage for the executable only.
  /// Should be overridden if you aren't using [HelpCommand]
  /// or another means of printing usage.
  String get usage {
    final exeFile = Platform.script.path.split('/').last;
    return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
  }

  bool _validateArgument(Argument arg) {
    if (_commands.containsKey(arg.name)) {
      // This indicates a bug in the code of the consumer of this API that
      // needs to be caught at compile time.
      throw ArgumentError('Input ${arg.name} already exists.');
    }

    return true;
  }
}
