/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

class ArgumentException extends FormatException {
  /// The command that was parsed before discovering the error.
  ///
  /// This will be empty if the error was on the root parser.
  final String? command;

  /// The name of the argument that was being parsed when the error was
  /// discovered.
  final String? argumentName;

  ArgumentException(
    super.message, [
    this.command,
    this.argumentName,
    super.source,
    super.offset,
  ]);
}
