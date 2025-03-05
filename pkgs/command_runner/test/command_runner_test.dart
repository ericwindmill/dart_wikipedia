import 'package:command_runner/command_runner.dart';
import 'package:test/test.dart';

import '../example/command_runner_example.dart';

void main() {
  final app =
      CommandRunner<String>()
        ..addCommand(HelpCommand())
        ..addCommand(PrettyEcho());

  group('CommandRunner', () {
    test("commands isn't empty after addCommand is called.", () {
      final app = CommandRunner<String>();
      expect(app.commands, isEmpty);
      app.addCommand(HelpCommand());
      expect(app.commands.length, 1);
    });

    test("addCommand throws when a command with the same name is added.", () {
      final app = CommandRunner<String>();
      expect(app.commands, isEmpty);
      app.addCommand(HelpCommand());
      expect(app.commands.length, 1);
      expect(() => app.addCommand(HelpCommand()), throwsArgumentError);
    });

    test('parse returns ArgResults with a HelpCommand', () {
      final results = app.parse(['help']);
      expect(results, isA<ArgResults>());
      expect(results.command, isA<HelpCommand>());
    });

    test("parse throws input doesn't contain a known command", () {
      expect(() => app.parse(['pizza']), throwsException);
    });

    test("parse throws when multiple commands are input", () {
      expect(() => app.parse(['help', 'echo']), throwsException);
    });

    test("parse throws when unknown option is provided that isn't ", () {
      expect(() => app.parse(['echo', '--bold']), throwsException);
    });

    test('parse succeeds when option is a flag and has no argument', () {
      var args = app.parse(['echo', '-b']);
      expect(args, isA<ArgResults>());
      expect(args.options.keys, isNotEmpty);
      expect(args.options.keys.first.name, 'blue-only');
    });

    test('parse succeeds when option has on argument', () {
      var args = app.parse(['help', '--command', 'echo']);
      expect(args, isA<ArgResults>());
      expect(args.options, isNotEmpty);
    });

    test('parse throws when option has no argument', () {
      expect(() => app.parse(['help', '--command']), throwsException);
    });
  });

  group('Command', () {
    test(
      "addFlag adds an Option with a defaultValue that is a bool and a type is an OptionType.flag",
      () {
        final command = HelpCommand();
        command.addFlag('shout', help: 'Capitalizes all output');
        final shout = command.options.firstWhere(
          (option) => option.name == 'shout',
        );
        expect(shout.defaultValue, isA<bool>());
        expect(shout.type, OptionType.flag);
      },
    );

    test("addOption adds an Option with type OptionType.option", () {
      final command = HelpCommand();
      command.addOption('shout', help: 'Capitalizes all output');
      final shout = command.options.firstWhere(
        (option) => option.name == 'shout',
      );
      expect(shout.type, OptionType.option);
    });

    test("getOption successfully returns an option with a matching name", () {
      final command = HelpCommand();
      command.addOption('shout', help: 'Capitalizes all output');
      final shout = command.options.firstWhere(
        (option) => option.name == 'shout',
      );
      expect(shout.type, OptionType.option);
    });

    group('ArgResults', () {
      test(
        'hasOption returns true when an option exists matching the name',
        () {
          var argResults = app.parse(['echo', '-b']);
          expect(argResults.hasOption('blue-only'), true);
        },
      );

      test(
        'hasOption returns false when no option exists matching the name',
        () {
          var argResults = app.parse(['echo', '-b']);
          expect(argResults.hasOption('red-only'), false);
        },
      );

      test('flag returns true when the flag exists and is passed in', () {
        var argResults = app.parse(['echo', 'hello', '-b']);
        expect(argResults.flag('blue-only'), true);
      });

      test('flag returns false when the flag exists and is not passed in', () {
        var argResults = app.parse(['echo', 'hello']);
        expect(argResults.flag('blue-only'), false);
      });

      test("getOption returns an option and it's argument", () {
        var argResults = app.parse(['help', '-c', 'echo']);
        var option = argResults.getOption('command');
        expect(option.option, isA<Option>());
        expect(option.option.name, 'command');
        expect(option.input, 'echo');
      });
    });
  });
}
