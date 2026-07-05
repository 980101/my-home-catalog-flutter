import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_home_catalog_flutter/app/app.dart';
import 'package:my_home_catalog_flutter/data/models/item_model.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_query.dart';
import 'package:my_home_catalog_flutter/features/home/data/recommendation_repository.dart';
import 'package:my_home_catalog_flutter/shared/widgets/item_network_image.dart';

void main() {
  test('RecommendationQueryResolver expands all style and type values', () {
    const resolver = RecommendationQueryResolver();

    final queries = resolver.resolve(style: 'all', type: 'all');

    expect(queries, hasLength(25));
    expect(
      queries.map((query) => 'all/${query.style}/${query.type}'),
      containsAll([
        'all/natural/bed',
        'all/modern/chair',
        'all/classic/dresser',
        'all/industrial/sofa',
        'all/zen/table',
      ]),
    );
  });

  test('RecommendationQueryResolver keeps specific style and type path', () {
    const resolver = RecommendationQueryResolver();

    final queries = resolver.resolve(style: 'modern', type: 'chair');

    expect(queries, hasLength(1));
    expect(queries.single.style, 'modern');
    expect(queries.single.type, 'chair');
  });

  test('ItemModel maps Firebase item fields', () {
    final item = ItemModel.fromFirebaseMap(
      data: const {
        'image': 'https://example.com/item.png',
        'name': 'Firebase Chair',
        'price': '99,000원',
        'link': 'https://example.com/item',
      },
      style: 'natural',
      type: 'chair',
    );

    expect(item.image, 'https://example.com/item.png');
    expect(item.name, 'Firebase Chair');
    expect(item.price, '99,000원');
    expect(item.link, 'https://example.com/item');
    expect(item.style, 'natural');
    expect(item.type, 'chair');
  });

  testWidgets('ItemNetworkImage shows placeholder for invalid image url', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ItemNetworkImage(
          imageUrl: 'not-a-network-url',
          placeholderLabel: 'chair',
          size: 88,
        ),
      ),
    );

    expect(find.text('chair'), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
  });

  testWidgets('InitialScreen shows Android initial entry actions', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('My Home\n Catalog'), findsOneWidget);
    expect(find.text('맞춤 가구 둘러보기'), findsOneWidget);
    expect(find.text('바로 시작'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('InitialScreen start button opens MainPage route', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    expect(find.text('모든 스타일'), findsOneWidget);
    expect(find.text('Natural Chair'), findsOneWidget);
  });

  testWidgets('CustomScreen validates selection and passes selected type', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

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
    await tester.pumpWidget(_testApp());

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
    await tester.pumpWidget(_testApp());

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

  testWidgets('MainScreen shows loading, empty, and error states', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(repository: const _PendingRepository()));

    await tester.tap(find.text('바로 시작'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(_testApp(repository: const _EmptyRepository()));

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    expect(find.text('추천 상품이 없습니다.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(_testApp(repository: const _ErrorRepository()));

    await tester.tap(find.text('바로 시작'));
    await tester.pumpAndSettle();

    expect(find.textContaining('firebase-error'), findsOneWidget);
  });

  testWidgets('MainScreen bottom navigation opens Custom and Favorites pages', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

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
    await tester.pumpWidget(_testApp());

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
    await tester.pumpWidget(_testApp());

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

Widget _testApp({
  RecommendationRepository repository = const _FakeRepository(),
}) {
  return MyHomeCatalogApp(recommendationRepository: repository);
}

class _FakeRepository implements RecommendationRepository {
  const _FakeRepository();

  @override
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  }) async {
    final styles = style == 'all'
        ? ['natural', 'modern', 'classic', 'industrial', 'zen']
        : [style];
    final types = type == 'all'
        ? ['bed', 'chair', 'dresser', 'sofa', 'table']
        : [type];

    return _items
        .where((item) {
          return styles.contains(item.style) && types.contains(item.type);
        })
        .toList(growable: false);
  }

  static const _items = [
    ItemModel(
      image: 'dummy://natural-chair',
      name: 'Natural Chair',
      price: '120,000원',
      link: 'https://example.com/natural-chair',
      style: 'natural',
      type: 'chair',
    ),
    ItemModel(
      image: 'dummy://modern-bed',
      name: 'Modern Bed',
      price: '420,000원',
      link: 'https://example.com/modern-bed',
      style: 'modern',
      type: 'bed',
    ),
  ];
}

class _EmptyRepository implements RecommendationRepository {
  const _EmptyRepository();

  @override
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const [];
  }
}

class _PendingRepository implements RecommendationRepository {
  const _PendingRepository();

  @override
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  }) {
    return Completer<List<ItemModel>>().future;
  }
}

class _ErrorRepository implements RecommendationRepository {
  const _ErrorRepository();

  @override
  Future<List<ItemModel>> findItems({
    required String style,
    required String type,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    throw Exception('firebase-error');
  }
}
