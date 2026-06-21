import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_home_catalog_flutter/app/app.dart';

void main() {
  testWidgets('InitialScreen shows Android initial entry actions', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    expect(find.text('My Home\n Catalog'), findsOneWidget);
    expect(find.text('맞춤 가구 둘러보기'), findsOneWidget);
    expect(find.text('바로 시작'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('InitialScreen start button opens MainActivity route', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    expect(find.text('MainActivity'), findsOneWidget);
  });

  testWidgets('InitialScreen custom button opens CustomActivity route', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('맞춤 가구 둘러보기'));
    await tester.pumpAndSettle();

    expect(find.text('CustomActivity'), findsOneWidget);
  });

  testWidgets('InitialScreen favorites button opens FavoritesActivity route', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.text('FavoritesActivity'), findsOneWidget);
  });
}
