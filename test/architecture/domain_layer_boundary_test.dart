import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Domain code must remain portable: it should not know how data is stored.
/// This catches accidental imports when moving repositories or database code.
void main() {
  test('quiz domain does not import core/database or Flutter', () {
    final domainDirectory = Directory('lib/features/quiz/domain');
    expect(domainDirectory.existsSync(), isTrue);

    final dartFiles = domainDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in dartFiles) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains("core/database")),
        reason: '${file.path} must not depend on the database layer',
      );
      expect(
        source,
        isNot(contains("package:flutter/")),
        reason: '${file.path} must not depend on Flutter',
      );
    }
  });
}
