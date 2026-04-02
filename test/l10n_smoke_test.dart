import 'package:flutter/material.dart';
import 'package:flutter_commonlib/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppLocalizations zh shows tab labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context).tabHome);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('首页'), findsOneWidget);
  });

  testWidgets('AppLocalizations en shows tab labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context).tabHome);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('AppLocalizations ja shows tab labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ja'),
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context).tabHome);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ホーム'), findsOneWidget);
  });
}
