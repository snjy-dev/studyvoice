import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_voice/app.dart';

void main() {
  testWidgets('StudyVoice foundation initializes', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: StudyVoiceApp()));

    expect(find.text('StudyVoice Foundation Initialized'), findsOneWidget);
    expect(find.text('StudyVoice'), findsWidgets);
  });
}
