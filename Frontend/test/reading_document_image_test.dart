import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toeic_reading/widgets/reading_document_image.dart';

void main() {
  testWidgets('Timer rebuild retains image provider and reading scroll offset', (
    tester,
  ) async {
    const png =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLbtAAAAABJRU5ErkJggg==';
    final scroll = ScrollController();
    final tick = ValueNotifier(0);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<int>(
            valueListenable: tick,
            builder: (_, value, child) => ListView(
              controller: scroll,
              children: [
                Text('Time $value'),
                SizedBox(
                  height: 900,
                  child: ReadingDocumentImage(
                    encoded: utf8.decode(utf8.encode(png)),
                  ),
                ),
                const SizedBox(
                  height: 900,
                  child: Text('Question and answers'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final before = tester.widget<Image>(find.byType(Image)).image;
    scroll.jumpTo(650);
    for (var i = 1; i <= 5; i++) {
      tick.value = i;
      await tester.pump(const Duration(seconds: 1));
      expect(tester.widget<Image>(find.byType(Image)).image, before);
      expect(scroll.offset, 650);
    }
    await tester.pumpWidget(const SizedBox());
    scroll.dispose();
    tick.dispose();
  });
}
