import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:toeic_reading/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  testWidgets('Guest opens library directly without account fields', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    await tester.pumpWidget(const ReadingApp());
    await tester.pump();
    expect(find.text('Reading Studio'), findsOneWidget);
    expect(find.text('THƯ VIỆN ĐỀ'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsNothing);
    expect(find.text('Mật khẩu'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
