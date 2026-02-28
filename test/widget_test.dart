import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:finguard/main.dart';
import 'package:finguard/providers/analysis_provider.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AnalysisProvider(),
        child: const FinGuardApp(),
      ),
    );

    expect(find.text('FinGuard'), findsOneWidget);
    expect(find.text('Analyze Agreement'), findsOneWidget);
  });
}
