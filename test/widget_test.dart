import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fritou/main.dart';

void main() {
  testWidgets('Fritou app smoke test', (WidgetTester tester) async {
    // Setup SharedPreferences mock values
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Re-pump to let SharedPreferences async initialization finish and rebuild the screen
    await tester.pump();

    // Verify that our counter displays "0 / 10".
    expect(find.text('0 / 10'), findsOneWidget);
    expect(find.text('1 / 10'), findsNothing);

    // Scroll to the button to make sure it is on-screen and tapable
    final buttonFinder = find.text('🍟 NOUVEAU BAIN DE FRITURE !');
    await tester.ensureVisible(buttonFinder);
    await tester.pump();

    // Tap the add bath button and trigger a frame.
    await tester.tap(buttonFinder);
    
    // Pump frames to let the tap take effect, and advance the animation timer 
    // by 650ms so the AnimatedSwitcher transition completes and removes "0 / 10".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));

    // Verify that our counter has incremented to 1 / 10.
    expect(find.text('0 / 10'), findsNothing);
    expect(find.text('1 / 10'), findsOneWidget);
  });
}
