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

  testWidgets('InitialScreen start button opens MainPage route', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    expect(find.text('모든 스타일'), findsOneWidget);
    expect(find.text('Natural Chair'), findsOneWidget);
  });

  testWidgets('CustomScreen validates selection and passes selected type', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('맞춤 가구 둘러보기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('다음'));
    await tester.pump();

    expect(find.text('가구를 선택해주세요!'), findsOneWidget);

    await tester.tap(find.text('chair'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.text('CameraPage'), findsOneWidget);
    expect(
      find.text('TODO: CameraActivity migration pending. type=chair'),
      findsOneWidget,
    );
  });

  testWidgets('MainScreen updates style and type filters', (tester) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('모던'));
    await tester.pumpAndSettle();

    expect(find.text('모던').first, findsOneWidget);
    expect(find.text('Modern Bed'), findsOneWidget);

    await tester.tap(find.text('Chair'));
    await tester.pumpAndSettle();

    expect(find.text('Modern Bed'), findsNothing);
  });

  testWidgets('MainScreen item tap opens DetailScreen with item contract', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Natural Chair'));
    await tester.pumpAndSettle();

    expect(find.text('상세 정보'), findsOneWidget);
    expect(find.text('제품명'), findsOneWidget);
    expect(find.text('Natural Chair'), findsOneWidget);
    expect(find.text('가격'), findsOneWidget);
    expect(find.text('120,000원'), findsOneWidget);
    expect(find.text('구매하기'), findsOneWidget);
    expect(find.byTooltip('즐겨찾기 저장'), findsOneWidget);
  });

  testWidgets('MainScreen bottom navigation opens Custom and Favorites pages', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('맞춤 가구 둘러보기'));
    await tester.pumpAndSettle();

    expect(find.text('가구 선택'), findsOneWidget);

    Navigator.of(tester.element(find.text('가구 선택'))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('즐겨찾기'));
    await tester.pumpAndSettle();

    expect(find.text('즐겨찾기'), findsOneWidget);
    expect(find.text('Favorite Chair'), findsOneWidget);
  });

  testWidgets('FavoritesScreen selects, deletes, and opens detail', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.text('Favorite Chair'), findsOneWidget);
    expect(find.text('Favorite Table'), findsOneWidget);
    expect(find.text('선택'), findsNWidgets(2));

    await tester.tap(find.text('선택').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('삭제'));
    await tester.pumpAndSettle();

    expect(find.text('Favorite Chair'), findsNothing);
    expect(find.text('Favorite Table'), findsOneWidget);

    await tester.tap(find.text('Favorite Table'));
    await tester.pumpAndSettle();

    expect(find.text('상세 정보'), findsOneWidget);
    expect(find.text('Favorite Table'), findsOneWidget);
    expect(find.text('210,000원'), findsOneWidget);
  });

  testWidgets('FavoritesScreen shows empty state after deleting all items', (
    tester,
  ) async {
    await tester.pumpWidget(const MyHomeCatalogApp());

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    await tester.tap(find.text('선택').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('삭제'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('선택').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('삭제'));
    await tester.pumpAndSettle();

    expect(find.text('즐겨찾기한 항목이 없습니다 !'), findsOneWidget);
  });
}
