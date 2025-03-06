import 'package:cli/cli.dart';
import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  final errorLogger = initFileLogger('errors');
  final app =
      CommandRunner<String>(
          onOutput: (String output) async {
            await write(output);
          },
          onError: (Object error) {
            if (error is Error) {
              errorLogger.severe(
                '[Error] ${error.toString()}\n${error.stackTrace}',
              );
              throw error;
            }
            if (error is Exception) {
              errorLogger.warning(error);
            }
          },
        )
        ..addCommand(HelpCommand())
        ..addCommand(SearchCommand(logger: errorLogger))
        ..addCommand(GetArticleCommand(logger: errorLogger));

  app.run(arguments);
}
