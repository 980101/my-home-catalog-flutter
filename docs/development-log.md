2026-06-11

프로젝트 시작

---

2026-06-21

## 작업 내용

- 기존 Android 프로젝트 `my-home-catalog`의 `InitialActivity`를 Flutter 프로젝트의 `InitialScreen`으로 마이그레이션했다.
- 참고 문서 `docs/architecture.md`, `docs/feature-spec.md`, `docs/coding-rules.md`, `docs/ui-guideline.md`를 기준으로 구현 범위를 확인했다.
- Android 원본의 초기 화면 기능만 Flutter로 구현했다.
  - 앱 타이틀 `My Home\n Catalog` 표시
  - `맞춤 가구 둘러보기` 버튼 표시 및 `CustomActivity` 대응 라우트 이동
  - `바로 시작` 버튼 표시 및 `MainActivity` 대응 라우트 이동
  - 즐겨찾기 아이콘 버튼 표시 및 `FavoritesActivity` 대응 라우트 이동
- Flutter 기본 counter 템플릿을 제거하고 앱 진입 구조를 `MyHomeCatalogApp`으로 정리했다.
- Feature First 구조에 맞춰 `initial` feature를 추가했다.
- UI와 화면 이동 로직을 분리하기 위해 `InitialNavigationHandler`를 추가했다.
- 문서의 UI guideline에 맞춰 앱 테마, 색상, 간격, 텍스트 스타일 토큰을 추가했다.
- 기존 목적지 화면(`MainActivity`, `CustomActivity`, `FavoritesActivity`)은 아직 Flutter로 구현하지 않고, InitialScreen 라우팅 검증을 위한 최소 placeholder 화면만 연결했다.
- InitialScreen 표시와 버튼별 라우팅을 확인하는 위젯 테스트를 작성했다.
- Flutter 프로젝트의 InitialScreen 마이그레이션 결과를 검증했다.
- `docs/architecture.md`, `docs/feature-spec.md`, `docs/coding-rules.md`, `docs/ui-guideline.md`, `docs/harness-checklist.md`를 기준으로 확인했다.
- Initial 화면 체크리스트 기준으로 UI 표시, 라우팅, Feature First 구조, UI 규칙, 정적 분석 결과를 점검했다.
- `flutter analyze`와 `flutter test`를 실행해 자동 검증을 수행했다.
- 기존 Android `CustomActivity`를 Flutter `CustomScreen`으로 마이그레이션했다.
- 기존 Android `MainActivity`의 화면 구조를 Flutter `MainScreen`으로 마이그레이션했다.
- 현재 단계에서 금지된 Firebase, Camera, TFLite, Favorites 저장, DetailScreen 실제 구현은 제외했다.
- Provider 기반 상태관리를 적용했다.
  - `CustomController`: 선택된 가구 타입 상태 관리
  - `HomeController`: 선택된 스타일, 선택된 가구 타입, 더미 추천 목록 상태 관리
- `CustomScreen`에서 가구 타입 2열 그리드, 선택 상태 UI, `다음` 버튼, 미선택 예외 메시지, 선택값 전달 구조를 구현했다.
- `MainScreen`에서 스타일 필터, 가구 타입 필터, 더미 추천 목록 UI, 상세 화면 이동 placeholder, 하단 이동 버튼 구조를 구현했다.
- Android 원본 데이터 계약을 유지했다.
  - 스타일 값: `all`, `natural`, `modern`, `classic`, `zen`, `industrial`
  - 가구 타입 값: `all`, `chair`, `bed`, `sofa`, `dresser`, `table`
  - 추천 아이템 필드: `image`, `name`, `price`, `link`
- `CameraPage`, `DetailPage`, `FavoritesPage`는 실제 기능 없이 TODO placeholder로만 연결했다.

## 변경 파일

### 이번 작업에서 수정 또는 추가한 파일

- `lib/main.dart`
  - Flutter counter 템플릿 제거
  - `MyHomeCatalogApp` 실행으로 변경
- `lib/app/app.dart`
  - `MaterialApp`, 앱 제목, 테마, 초기 라우트, 라우트 맵 연결
- `lib/app/router/app_routes.dart`
  - Initial, Home, Custom, Camera, Detail, Favorites 라우트 상수 정의
- `lib/app/router/app_router.dart`
  - `InitialScreen`, `CustomScreen`, `HomeScreen` 라우트 연결
  - Camera, Detail, Favorites TODO placeholder 화면 연결
- `lib/app/theme/app_colors.dart`
  - `ui-guideline.md` 기준 색상 토큰 정의
- `lib/app/theme/app_spacing.dart`
  - 간격 및 radius 토큰 정의
- `lib/app/theme/app_text_styles.dart`
  - 초기 화면 타이틀, 화면 제목, 본문, 라벨 텍스트 스타일 정의
- `lib/app/theme/app_theme.dart`
  - 앱 기본 테마, AppBar, ElevatedButton, TextButton 스타일 정의
- `lib/core/constants/catalog_options.dart`
  - 스타일, 가구 타입, 화면 표시명, 아이콘, 제목 매핑 상수 정의
- `lib/data/models/item_model.dart`
  - Android `ItemData`에 대응하는 추천 아이템 모델 정의
- `lib/shared/widgets/selectable_option_chip.dart`
  - 스타일/가구 타입 필터 공통 선택 칩 정의
- `lib/shared/widgets/bottom_nav_icon_button.dart`
  - 하단 이동 아이콘 버튼 공통 위젯 정의
- `lib/features/custom/presentation/controllers/custom_controller.dart`
  - CustomScreen 가구 타입 선택 상태 관리
- `lib/features/custom/presentation/custom_screen.dart`
  - 맞춤 가구 선택 화면 구현
- `lib/features/custom/presentation/widgets/furniture_type_tile.dart`
  - 가구 타입 선택 타일 UI 구현
- `lib/features/home/data/dummy_recommendation_repository.dart`
  - Firebase 연동 전 더미 추천 목록 제공
- `lib/features/home/presentation/controllers/home_controller.dart`
  - MainScreen 스타일/타입 필터 및 목록 상태 관리
- `lib/features/home/presentation/home_screen.dart`
  - 추천 목록 화면 구조 구현
- `lib/features/home/presentation/widgets/style_filter_bar.dart`
  - 스타일 필터 UI 구현
- `lib/features/home/presentation/widgets/furniture_type_filter.dart`
  - 가구 타입 필터 UI 구현
- `lib/features/home/presentation/widgets/recommendation_item_card.dart`
  - 추천 아이템 카드 UI 구현
- `lib/features/initial/domain/initial_navigation_handler.dart`
  - 초기 화면 버튼별 이동 로직 분리
- `lib/features/initial/presentation/initial_screen.dart`
  - Android `activity_initial.xml`과 `InitialActivity` 기준 초기 화면 UI 구현
  - 직접 입력된 일부 spacing 값을 디자인 토큰으로 교체
- `test/widget_test.dart`
  - counter 테스트 제거
  - InitialScreen 표시 및 라우팅 테스트 추가
  - CustomScreen 선택/미선택 예외/선택값 전달 테스트 추가
  - MainScreen 필터, 목록, 상세 placeholder, 하단 이동 테스트 추가

### 작업 당시 Git 변경사항에 포함되어 있었으나 이번 구현에서 직접 수정하지 않은 파일

- `docs/harness-checklist.md`
  - 작업 당시 Git 상태에서는 수정 파일로 표시됐다.
  - 이번 InitialScreen 마이그레이션 작업 중 직접 편집하지 않았다.

## AI 활용 방식

- AI가 Android 원본 코드와 Flutter 문서를 함께 분석했다.
  - `InitialActivity.java`
  - `activity_initial.xml`
  - `docs/architecture.md`
  - `docs/feature-spec.md`
  - `docs/coding-rules.md`
  - `docs/ui-guideline.md`
- 문서에 정의된 기능 범위를 기준으로 Android 원본에 없는 기능은 추가하지 않았다.
- AI가 Flutter 프로젝트의 현재 상태를 확인한 뒤, counter 템플릿을 실제 앱 구조로 교체했다.
- AI가 Feature First 구조를 유지하도록 `app`, `theme`, `router`, `features/initial` 단위로 파일을 분리했다.
- AI가 구현 후 `dart format`, `flutter analyze`, `flutter test`를 실행해 정적 분석과 위젯 테스트를 검증했다.
- AI가 문서 기준과 현재 Flutter 코드를 대조했다.
- AI가 InitialScreen의 UI 요소, 라우트 연결, 테스트 코드를 확인했다.
- AI가 문제점을 바로 수정하지 않고 목록과 수정 제안으로 정리했다.
- AI가 Android `CustomActivity`, `CustomAdapter`, `activity_custom.xml`, `MainActivity`, `activity_main.xml`, `ItemAdapter`, `ItemData`를 분석해 Flutter 구현 범위를 도출했다.
- AI가 Provider 상태관리, Feature First 구조, 공통 위젯 분리를 적용해 Custom/Main 화면을 구현했다.
- AI가 현재 단계에서 금지된 기능은 실제 구현하지 않고 TODO placeholder와 더미 데이터로 대체했다.

## 발생한 문제

- Flutter 프로젝트가 기본 counter 템플릿 상태라 `InitialScreen`을 붙일 앱 구조, 라우터, 테마 파일이 없었다.
- `InitialScreen`의 이동 대상인 Home, Custom, Favorites 화면은 아직 Flutter로 마이그레이션되지 않은 상태였다.
- `dart format`, `flutter analyze`, `flutter test` 실행 시 Flutter SDK가 `/opt/homebrew/share/flutter/bin/cache/engine.stamp`를 갱신하려고 하면서 샌드박스 권한 오류가 발생했다.
- `docs/harness-checklist.md`가 작업 전부터 Git 변경사항에 포함되어 있어, 이번 작업 변경 범위와 구분할 필요가 있었다.
- `/home`, `/custom`, `/favorites` 이동 대상이 실제 Page가 아닌 placeholder라 체크리스트 일부 항목은 완전 검증할 수 없었다.
- placeholder 화면이 임시 화면 또는 TODO임을 UI상 명확히 표시하지 않는다.
- 일부 간격 값이 `AppSpacing` 토큰 대신 직접 입력되어 있다.
- Provider의 `context.select`를 `GridView.builder` itemBuilder 내부에서 직접 사용해 테스트 중 Provider assertion이 발생했다.
- CustomScreen 미선택 예외 테스트에서 SnackBar가 하단 `다음` 버튼을 일시적으로 덮어 테스트 탭이 실패했다.

## 해결 방법

- 최소 앱 구조를 먼저 만들었다.
  - `MyHomeCatalogApp`
  - `AppRouter`
  - `AppRoutes`
  - `AppTheme`
- 아직 구현되지 않은 목적지 화면은 새 기능을 추가하지 않고, 라우팅 계약 검증용 placeholder 화면으로만 연결했다.
- `InitialNavigationHandler`를 두어 UI 위젯과 화면 이동 로직을 분리했다.
- Flutter SDK cache 권한 문제는 승인된 escalated command로 동일 명령을 다시 실행해 해결하고 검증했다.
- `docs/harness-checklist.md`는 수정하지 않고, 작업 당시 Git 변경사항에 포함되어 있었음을 작업 기록에 분리해서 남겼다.
- 미완료 항목은 수정하지 않고 문제 목록과 수정 제안으로 분리했다.
- `CustomScreen`과 `MainScreen`을 실제 Flutter Page로 연결해 기존 placeholder를 교체했다.
- `CameraPage`, `DetailPage`, `FavoritesPage`는 금지된 기능을 구현하지 않고 TODO placeholder로 명확히 표시했다.
- `context.select`는 GridView itemBuilder 밖에서 사용해 Provider assertion을 해결했다.
- SnackBar가 사라진 뒤 다음 버튼을 누르도록 위젯 테스트 타이밍을 보정했다.
- InitialScreen의 직접 입력 spacing 일부를 `AppSpacing` 토큰으로 교체했다.
- 검증 결과:
  - `dart format lib test` 통과
  - `flutter analyze` 통과
  - `flutter test` 통과

## 다음 작업 계획

- `CameraActivity` / `ClassifierActivity` 마이그레이션 범위를 결정한다.
  - 카메라 권한
  - 카메라 프리뷰
  - TFLite 모델 asset 등록
  - 선택된 `type` 전달 유지
- `DetailActivity`를 Flutter `DetailScreen`으로 마이그레이션한다.
  - `image`, `name`, `price`, `link` 전달 계약 유지
  - 구매 링크 외부 앱 열기
  - 즐겨찾기 저장은 별도 단계에서 진행
- `FavoritesActivity`를 Flutter `FavoritesScreen`으로 마이그레이션한다.
  - 로컬 JSON 저장소 방식 결정 후 구현
- Firebase 연동 전 `DummyRecommendationRepository`를 실제 repository interface로 분리할지 검토한다.
- 기능 단위 구현마다 `flutter analyze`, 관련 위젯 테스트 또는 수동 검증 결과를 남긴다.

---

2026-06-22

## 작업 내용

- 기존 Android `DetailActivity`를 Flutter `DetailScreen`으로 마이그레이션했다.
- 기존 Android `FavoritesActivity`와 `FavoritesAdapter`를 Flutter `FavoritesScreen`으로 마이그레이션했다.
- `docs/architecture.md`, `docs/feature-spec.md`, `docs/coding-rules.md`, `docs/ui-guideline.md`, `docs/harness-checklist.md` 기준으로 구현 범위를 확인했다.
- Android 원본 데이터 계약을 유지했다.
  - 추천/즐겨찾기 상세 전달 필드: `image`, `name`, `price`, `link`
  - 로컬 즐겨찾기 JSON 원본 계약: `Image`, `Name`, `Price`, `Link`
- 현재 단계에서 금지된 Firebase 연동, Camera 기능, TFLite 추론, 실제 즐겨찾기 저장, 실제 JSON 파일 저장, 추천 데이터 조회 API는 구현하지 않았다.
- `DetailScreen`에서 전달받은 상품 이미지 placeholder, 상품명, 가격, 구매하기 버튼, 즐겨찾기 버튼을 표시했다.
- `url_launcher` 기반 외부 링크 실행 구조를 추가했다.
- `FavoritesScreen`에서 로컬 더미 데이터 기반 즐겨찾기 목록, 선택 버튼, 삭제 버튼, 상세 화면 이동, 빈 상태 UI를 구현했다.
- Provider 기반 상태관리를 적용했다.
  - `DetailController`: 즐겨찾기 버튼 상태, 구매 링크 실행 상태, 메시지 상태 관리
  - `FavoritesController`: 더미 즐겨찾기 목록, 삭제 대상 선택, 삭제, 빈 상태 관리
- `ItemImagePlaceholder`를 공통 위젯으로 분리해 추천 목록, 상세 화면, 즐겨찾기 목록에서 재사용했다.

## 변경 파일

- `pubspec.yaml`
  - `url_launcher` 의존성 추가
- `pubspec.lock`
  - `url_launcher` 및 플랫폼 패키지 잠금 정보 갱신
- `ios/Flutter/Debug.xcconfig`
- `ios/Flutter/Release.xcconfig`
- `ios/Podfile`
- `macos/Flutter/Flutter-Debug.xcconfig`
- `macos/Flutter/Flutter-Release.xcconfig`
- `macos/Flutter/GeneratedPluginRegistrant.swift`
- `macos/Podfile`
- `linux/flutter/generated_plugin_registrant.cc`
- `linux/flutter/generated_plugins.cmake`
- `windows/flutter/generated_plugin_registrant.cc`
- `windows/flutter/generated_plugins.cmake`
  - `url_launcher` 플러그인 등록을 위해 Flutter tool이 생성 또는 갱신
- `lib/app/router/app_router.dart`
  - `DetailScreen`, `FavoritesScreen` 실제 라우트 연결
- `lib/features/home/presentation/widgets/recommendation_item_card.dart`
  - 공통 이미지 placeholder 사용으로 변경
- `lib/shared/widgets/item_image_placeholder.dart`
  - 상품 이미지 placeholder 공통 위젯 추가
- `lib/features/detail/data/external_link_launcher.dart`
  - 외부 링크 실행 service 추가
- `lib/features/detail/presentation/controllers/detail_controller.dart`
  - 상세 화면 상태관리 추가
- `lib/features/detail/presentation/detail_screen.dart`
  - 상품 상세 화면 구현
- `lib/features/detail/presentation/widgets/detail_info_row.dart`
  - 상세 정보 표시 위젯 추가
- `lib/features/favorites/data/dummy_favorites_repository.dart`
  - 즐겨찾기 더미 데이터 repository 추가
- `lib/features/favorites/presentation/controllers/favorites_controller.dart`
  - 즐겨찾기 목록, 선택, 삭제 상태관리 추가
- `lib/features/favorites/presentation/favorites_screen.dart`
  - 즐겨찾기 화면 구현
- `lib/features/favorites/presentation/widgets/favorite_item_card.dart`
  - 즐겨찾기 아이템 카드 구현
- `test/widget_test.dart`
  - DetailScreen 표시 검증 추가
  - FavoritesScreen 목록, 선택, 삭제, 상세 이동, 빈 상태 테스트 추가

## AI 활용 방식

- AI가 Android 원본 `DetailActivity`, `FavoritesActivity`, `FavoritesAdapter`와 Flutter docs를 함께 분석했다.
- AI가 `feature-spec.md`에 존재하는 기능만 Flutter 화면 구조로 옮겼다.
- AI가 금지된 실제 저장/JSON 파일 저장은 구현하지 않고 Provider 상태와 더미 repository로 대체했다.
- AI가 외부 링크 실행은 `url_launcher` service로 분리해 UI와 실행 로직을 분리했다.
- AI가 위젯 테스트를 통해 Detail/Favorites 라우팅과 화면 상태를 검증했다.

## 발생한 문제

- `url_launcher` 의존성 추가 후 Flutter tool이 iOS/macOS/Linux/Windows plugin registrant와 Podfile을 생성 또는 수정했다.
- 일반 샌드박스에서 Flutter SDK cache 갱신 권한 문제로 `flutter pub get`, `dart format`, `flutter analyze` 실행이 실패했다.
- 즐겨찾기 더미 repository가 `const` 리스트를 반환해 삭제 시 `Unsupported operation: Cannot remove from an unmodifiable list` 오류가 발생했다.

## 해결 방법

- Flutter SDK cache 권한 문제는 승인된 escalated command로 동일 명령을 다시 실행해 해결했다.
- `FavoritesController`에서 repository 반환 값을 수정 가능한 리스트로 복사해 삭제 오류를 해결했다.
- `CameraPage`는 이번 범위 밖이므로 기존 TODO placeholder를 유지했다.
- 실제 JSON 저장 기능은 이후 단계로 남기고, 현재 단계에서는 로컬 더미 데이터와 화면 상태만 구현했다.

## 검증 결과

- `flutter pub get` 통과
- `dart format lib test` 통과
- `flutter analyze` 통과
- `flutter test` 통과
  - InitialScreen 표시 및 이동
  - CustomScreen 선택/미선택 예외/선택값 전달
  - MainScreen 필터/목록/상세 이동
  - DetailScreen 상품 정보 표시
  - FavoritesScreen 목록/선택/삭제/상세 이동/빈 상태

## 다음 작업 계획

- 실제 즐겨찾기 저장소를 구현한다.
  - `savedItem.json` 읽기
  - `Image`, `Name`, `Price`, `Link` mapper 분리
  - 저장, 중복 체크, 삭제 반영
- `DetailScreen` 즐겨찾기 버튼을 실제 저장소와 연결한다.
- `FavoritesScreen`을 더미 repository에서 실제 로컬 JSON repository로 교체한다.
- `CameraActivity` / `ClassifierActivity` 마이그레이션 범위를 결정한다.
- Firebase 추천 데이터 조회 repository 적용은 Camera/Detail/Favorites 이후 별도 단계에서 진행한다.

## 추가 작업 내용 - Firebase 추천 목록 연동

- 기존 Android `MainActivity`의 Firebase Realtime Database 조회 계약을 Flutter에 반영했다.
- Firebase 조회 경로는 기존 계약과 동일하게 `all/{style}/{type}`을 사용하도록 구현했다.
- `style=all`일 때 `natural`, `modern`, `classic`, `industrial`, `zen` 전체를 순회하도록 분리했다.
- `type=all`일 때 `bed`, `chair`, `dresser`, `sofa`, `table` 전체를 순회하도록 분리했다.
- Firebase child snapshot을 `image`, `name`, `price`, `link` 필드 기반 `ItemModel`로 변환하도록 구현했다.
- MainScreen의 더미 추천 목록 repository를 Firebase repository 주입 구조로 교체했다.
- `HomeController`가 `loading`, `data`, `empty`, `error` 상태를 구분하도록 변경했다.
- MainScreen에 로딩 상태, 빈 목록 상태, 에러 상태 UI를 추가했다.
- `DetailScreen`은 전달받은 `ItemModel`만 표시하며 Firebase를 직접 호출하지 않도록 유지했다.
- 테스트에서는 Firebase 실제 설정에 의존하지 않도록 fake repository를 앱에 주입했다.

## 추가 변경 파일 - Firebase 추천 목록 연동

- `pubspec.yaml`
  - `firebase_core`, `firebase_database` 의존성 추가
- `pubspec.lock`
  - Firebase 관련 패키지 잠금 정보 갱신
- `lib/main.dart`
  - `Firebase.initializeApp()` 초기화 추가
- `lib/app/app.dart`
  - `RecommendationRepository` 주입 구조 추가
  - 기본 repository를 `FirebaseRecommendationRepository`로 설정
- `lib/app/router/app_router.dart`
  - HomeScreen 라우트에 repository 전달
- `lib/data/models/item_model.dart`
  - Firebase map 변환 factory 추가
- `lib/features/home/data/recommendation_repository.dart`
  - 추천 목록 repository interface 추가
- `lib/features/home/data/recommendation_query.dart`
  - `all` style/type 순회 경로 resolver 추가
- `lib/features/home/data/firebase_recommendation_repository.dart`
  - Firebase Realtime Database 추천 목록 조회 repository 추가
- `lib/features/home/data/dummy_recommendation_repository.dart`
  - repository interface 구현 및 비동기 반환으로 변경
- `lib/features/home/presentation/controllers/home_controller.dart`
  - 비동기 조회, loading/data/empty/error 상태관리 적용
- `lib/features/home/presentation/home_screen.dart`
  - Provider 상태 기반 추천 목록 UI 적용
  - 로딩, 빈 목록, 에러 UI 추가
- `test/widget_test.dart`
  - Firebase 경로 resolver 테스트 추가
  - MainScreen loading/empty/error 상태 테스트 추가
  - Firebase 실제 설정 대신 fake repository 주입
- `macos/Flutter/GeneratedPluginRegistrant.swift`
- `windows/flutter/generated_plugin_registrant.cc`
- `windows/flutter/generated_plugins.cmake`
  - Firebase plugin 등록을 위해 Flutter tool이 갱신

## 추가 AI 활용 방식 - Firebase 추천 목록 연동

- AI가 Android `MainActivity.modifyList()`와 `loadData()`의 조회 흐름을 Flutter repository 구조로 옮겼다.
- AI가 `feature-spec.md`와 `harness-checklist.md`의 Firebase path, 필터, 상태 검증 기준을 코드 구조에 반영했다.
- AI가 Screen에서 Firebase를 직접 호출하지 않도록 repository interface와 Provider 상태관리로 분리했다.
- AI가 Firebase 설정 파일 없이도 테스트 가능한 구조를 만들기 위해 fake repository 주입 방식을 적용했다.

## 추가 발생한 문제 - Firebase 추천 목록 연동

- Flutter 프로젝트 안에서 Firebase Android/iOS 설정 파일을 찾을 수 없었다.
  - `android/app/google-services.json` 없음
  - `ios/Runner/GoogleService-Info.plist` 없음
- 일반 샌드박스에서 Flutter SDK cache 갱신 권한 문제로 의존성/검증 명령이 실패할 수 있었다.
- loading 상태 테스트에서 비동기 조회가 너무 빨리 끝나 `CircularProgressIndicator` 검증이 불안정했다.
- 같은 테스트 안에서 앱을 다시 pump할 때 이전 Navigator 상태가 남아 초기 화면을 찾지 못하는 문제가 있었다.

## 추가 해결 방법 - Firebase 추천 목록 연동

- Firebase 설정 파일 누락은 지시대로 수정하지 않고 미검증 사항으로 남겼다.
- Flutter SDK cache 권한 문제는 승인된 명령으로 재실행해 해결했다.
- loading 상태 테스트는 완료되지 않는 fake repository를 사용해 안정화했다.
- empty/error 상태 테스트 전에는 위젯 트리를 비운 뒤 새 앱을 pump해 Navigator 상태를 초기화했다.
- Firebase 실제 호출은 repository에만 두고, MainScreen은 Provider 상태만 구독하도록 유지했다.

## 추가 검증 결과 - Firebase 추천 목록 연동

- `flutter pub get` 통과
- `dart format lib test` 통과
- `flutter analyze` 통과
- `flutter test` 통과
  - Firebase 경로 resolver 검증
  - MainScreen 기본값 `style=all`, `type=all` 검증
  - MainScreen 필터 변경 및 상세 전달 검증
  - MainScreen loading/empty/error 상태 검증

## 추가 다음 작업 계획 - Firebase 추천 목록 연동

- Flutter Firebase 설정 파일을 추가한다.
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`
- 실제 Firebase 프로젝트 연결 후 `flutter run`으로 런타임 조회를 확인한다.
- 실제 Firebase 데이터가 비어 있는 경우 빈 상태 UI를 기준으로 수동 검증한다.
- 즐겨찾기 로컬 JSON 저장소 구현을 진행한다.
- Camera/TFLite 마이그레이션 전 `CameraPage`에서 `MainPage`로 `style`, `type` 전달 계약을 확정한다.

## 2026-07-05 작업 내용 - Firebase Android 설정 및 실데이터 이미지 로딩 보완

### 작업 내용

- Android 에뮬레이터에서 발생한 Firebase 초기화 실패 오류를 점검했다.
- `google-services.json`이 Android 리소스로 변환되지 않아 발생한 `Failed to load FirebaseOptions from resource` 문제를 수정했다.
- Android Gradle 설정에 Google Services 플러그인을 등록하고 앱 모듈에 적용했다.
- MainScreen의 Firebase Realtime Database 실데이터 조회 흐름을 점검했다.
- Firebase snapshot 파싱을 보완해 leaf 데이터가 `Map` 또는 `List` 형태여도 `ItemModel`로 변환되도록 했다.
- 추천 카드에서 Firebase `image` 필드를 사용해 네트워크 이미지를 로드하도록 변경했다.
- 이미지 URL이 없거나 잘못됐거나 로딩에 실패하면 placeholder를 표시하도록 구현했다.
- Firebase 모델 변환과 이미지 실패 placeholder 테스트를 추가했다.

### 변경 파일

- `android/settings.gradle.kts`
- `android/app/build.gradle.kts`
- `lib/features/home/data/firebase_recommendation_repository.dart`
- `lib/features/home/presentation/widgets/recommendation_item_card.dart`
- `lib/shared/widgets/item_image_placeholder.dart`
- `lib/shared/widgets/item_network_image.dart`
- `test/widget_test.dart`

### AI 활용 방식

- AI가 스크린샷의 Firebase 초기화 오류 메시지를 기준으로 Android Firebase 리소스 생성 문제를 추적했다.
- AI가 `google-services.json` 위치, `package_name`, Android `applicationId`, Gradle 플러그인 적용 여부를 확인했다.
- AI가 `feature-spec.md`, `coding-rules.md`, `ui-guideline.md`, `harness-checklist.md` 기준으로 작업 범위를 MainScreen/Firebase/이미지 로딩으로 제한했다.
- AI가 Camera, TFLite, 즐겨찾기 `savedItem.json`, iOS 설정은 이번 작업에서 제외했다.
- AI가 단위/위젯 테스트와 Android 에뮬레이터 수동 검증을 함께 수행했다.

### 발생한 문제

- `android/app/google-services.json`은 존재했지만 `com.google.gms.google-services` 플러그인이 적용되지 않아 `google_app_id`, `firebase_database_url` 리소스가 생성되지 않았다.
- 일반 샌드박스에서 Gradle wrapper가 `~/.gradle` lock 파일에 접근하지 못해 Gradle 태스크가 실패했다.
- 이전 `flutter run` 실행 중 `The log reader stopped unexpectedly` 오류가 발생한 적이 있었다.
- Firebase 실데이터는 표시됐지만, 현재 `image` 값은 에뮬레이터에서 실제 이미지로 로드되지 않고 placeholder로 표시됐다.
- ADB 화면 캡처와 입력은 일반 샌드박스에서 ADB daemon 접근 제한으로 실패해 승인된 명령으로 재실행했다.

### 해결 방법

- `android/settings.gradle.kts`에 `com.google.gms.google-services` 플러그인 버전을 등록했다.
- `android/app/build.gradle.kts`에 `id("com.google.gms.google-services")`를 적용했다.
- `./gradlew :app:processDebugGoogleServices`로 Firebase Android 리소스 생성을 확인했다.
- `build/app/generated/res/processDebugGoogleServices/values/values.xml`에서 `google_app_id`, `firebase_database_url` 생성을 확인했다.
- Firebase leaf snapshot 파싱 로직을 `Map`과 `List` 모두 처리하도록 보완했다.
- `ItemNetworkImage` 위젯을 추가해 `Image.network` 로딩, 로딩 표시, 실패 placeholder를 처리했다.
- 잘못된 URL 또는 비어 있는 URL은 네트워크 요청 없이 placeholder로 처리하도록 했다.

### 검증 결과

- `dart format lib test` 통과
- `flutter analyze` 통과
- `flutter test` 통과
- `./gradlew :app:processDebugGoogleServices` 통과
- `./gradlew :app:assembleDebug` 통과
- `flutter run -d emulator-5554 --no-resident` 통과
- Android 에뮬레이터에서 InitialScreen 정상 진입 확인
- Android 에뮬레이터에서 MainScreen 진입 후 `style=all`, `type=all` Firebase 실데이터 표시 확인
- 스타일 필터 `모던` 선택 시 목록 재조회 및 갱신 확인
- 가구 타입 필터 `Bed` 선택 시 목록 재조회 및 갱신 확인
- 이미지 로딩 실패 시 placeholder 표시 및 앱 크래시 없음 확인

### 다음 작업 계획

- Firebase `image` 필드가 실제 접근 가능한 HTTP/HTTPS 이미지 URL인지 점검한다.
- 실제 이미지 URL이 유효한 경우 MainScreen에서 상품 이미지가 정상 표시되는지 재검증한다.
- 즐겨찾기 `savedItem.json` 저장/조회/삭제 repository를 구현한다.
- `DetailScreen` 즐겨찾기 버튼을 실제 저장소와 연결한다.
- `FavoritesScreen`을 더미 repository에서 실제 로컬 JSON repository로 교체한다.
- Camera/TFLite 구현 전 `CameraPage`에서 `MainPage`로 전달할 `style`, `type` 계약을 유지한다.

---

## 2026-07-07 작업 내용 - 즐겨찾기 로컬 저장 구현

### 작업 내용

- 기존 Android 프로젝트와 Flutter 문서를 기준으로 즐겨찾기 로컬 저장 기능을 구현했다.
- `savedItem.json` 기반 로컬 저장소를 추가했다.
- Android 기존 계약에 맞춰 저장 key는 `Image`, `Name`, `Price`, `Link`를 유지했다.
- `ItemModel`에 Firebase 소문자 key와 로컬 JSON 대문자 key 매핑을 분리했다.
- 상세 화면 저장 버튼이 실제 파일 저장을 수행하도록 연결했다.
- `Name` 기준 중복 저장을 방지하고, 중복 시 `"이미 존재하는 아이템입니다."` 메시지를 표시하도록 했다.
- 즐겨찾기 화면이 더미 데이터 대신 `savedItem.json`을 읽도록 변경했다.
- 선택 항목 삭제 시 `savedItem.json`을 갱신하고 화면 목록도 다시 반영하도록 했다.
- 파일 없음, 빈 파일, 빈 목록 상태를 처리했다.
- 즐겨찾기 목록 이미지 표시를 실제 `image` 값 기반 네트워크 이미지 위젯으로 변경했다.
- Camera, TFLite, Firebase 구조, 로그인/회원가입, 앱 내부 WebView는 변경하지 않았다.

### 변경 파일

- `pubspec.yaml`
  - `path_provider` 의존성 추가
- `pubspec.lock`
  - `path_provider` 및 플랫폼 패키지 잠금 정보 갱신
- `lib/app/app.dart`
  - 즐겨찾기 repository 주입 구조 추가
- `lib/app/router/app_router.dart`
  - Detail/Favorites 라우트에 실제 즐겨찾기 repository 전달
- `lib/data/models/item_model.dart`
  - `Image`, `Name`, `Price`, `Link` 로컬 JSON 매핑 추가
- `lib/features/favorites/data/favorites_repository.dart`
  - `savedItem.json` 조회, 저장, 중복 확인, 삭제 repository 추가
- `lib/features/favorites/data/dummy_favorites_repository.dart`
  - 더미 즐겨찾기 repository 제거
- `lib/features/detail/presentation/controllers/detail_controller.dart`
  - 실제 즐겨찾기 저장, 중복 처리, 저장 여부 조회 연결
- `lib/features/detail/presentation/detail_screen.dart`
  - 즐겨찾기 repository 주입 및 저장 상태 UI 연결
- `lib/features/favorites/presentation/controllers/favorites_controller.dart`
  - 파일 기반 즐겨찾기 로딩, 삭제, 오류 상태 처리
- `lib/features/favorites/presentation/favorites_screen.dart`
  - 로딩, 오류, 빈 목록, 파일 기반 목록 표시 연결
- `lib/features/favorites/presentation/widgets/favorite_item_card.dart`
  - 실제 이미지 URL 기반 표시로 변경
- `test/widget_test.dart`
  - 로컬 JSON 매핑, 저장, 중복, 삭제, 빈 상태, 상세 저장 테스트 추가
- `macos/Flutter/GeneratedPluginRegistrant.swift`
- `linux/flutter/generated_plugins.cmake`
- `windows/flutter/generated_plugins.cmake`
  - `path_provider` 플러그인 등록을 위해 Flutter tool이 갱신

### AI 활용 방식

- AI가 `docs/architecture.md`, `docs/feature-spec.md`, `docs/coding-rules.md`, `docs/ui-guideline.md`, `docs/harness-checklist.md`를 확인했다.
- AI가 Android 원본의 `savedItem.json` 파일명과 `Image`, `Name`, `Price`, `Link` 저장 계약을 Flutter 모델 매핑에 반영했다.
- AI가 화면 Widget 내부에 파일 IO를 넣지 않고 repository와 controller로 분리했다.
- AI가 기존 더미 repository 의존 테스트를 실제 저장소 단위 테스트와 인메모리 화면 테스트로 분리했다.

### 발생한 문제

- 기존 `DetailController`는 실제 저장 없이 임시 메시지만 표시했다.
- 기존 `FavoritesScreen`은 더미 repository를 읽고 화면 목록만 삭제해 실제 파일이 갱신되지 않았다.
- 위젯 테스트에서 실제 `dart:io` 파일 Future를 직접 사용하면 테스트 fake async 환경에서 로딩 상태가 불안정했다.

### 해결 방법

- `FavoritesRepository`를 추가해 파일 조회, 저장, 중복 확인, 삭제 책임을 분리했다.
- `DetailController`가 저장 여부를 비동기로 확인하고 저장 결과에 따라 메시지와 아이콘 상태를 갱신하도록 변경했다.
- `FavoritesController`가 삭제 후 repository에서 목록을 다시 읽어 화면 상태를 갱신하도록 변경했다.
- 파일 저장소 자체는 단위 테스트로 검증하고, 화면 테스트는 인메모리 repository로 검증했다.

### 검증 결과

- `flutter pub get` 통과
- `dart format lib test` 통과
- `flutter analyze` 통과
- `flutter test` 통과

### 다음 작업 계획

- Android/iOS 실제 기기에서 앱 재시작 후 `savedItem.json` 유지 여부를 확인한다.
- 저장 성공 시 사용자 피드백 문구를 추가할지 결정한다.
- 실제 Firebase 이미지 URL이 즐겨찾기 화면에서도 정상 표시되는지 수동 검증한다.

---

## 2026-07-07 작업 내용 - Camera 및 TFLite 기능 마이그레이션

### 작업 내용

- 기존 Android `CameraActivity` / `ClassifierActivity` 기능 계약을 Flutter `CameraScreen`으로 마이그레이션했다.
- 기존 Android 프로젝트의 `model.tflite`, `labels.txt`를 Flutter asset으로 복사하고 등록했다.
- `CameraScreen` placeholder를 실제 카메라 화면으로 교체했다.
- Android `CAMERA` 권한과 iOS `NSCameraUsageDescription`을 추가했다.
- `permission_handler`를 사용해 카메라 런타임 권한 요청 흐름을 구현했다.
- `camera` 패키지 기반 카메라 프리뷰를 구현했다.
- `tflite_flutter` 기반 TFLite 모델 로딩 및 추론 구조를 구현했다.
- 카메라 프레임을 RGB 변환, 회전 보정, 정사각 crop, resize 후 모델 입력으로 전달하도록 했다.
- confidence `0.9` 이상인 최상위 라벨만 `recognitionStyle`로 저장하도록 했다.
- `recognitionStyle`이 있을 때 `촬영하기` 클릭 시 `MainScreen`으로 `style`, `type`을 전달하도록 했다.
- `recognitionStyle`이 없으면 `촬영하기` 클릭 시 화면 이동하지 않도록 했다.
- 최근 인식 스타일 히스토리 저장, 조회, 삭제, 히스토리 클릭 이동을 구현했다.
- Firebase 구조, 로그인/회원가입, 검색, 장바구니, 앱 내부 WebView는 변경하지 않았다.

### 변경 파일

- `assets/model.tflite`
  - 원본 Android 모델 asset 복사
- `assets/labels.txt`
  - 원본 Android 라벨 asset 복사
- `pubspec.yaml`
  - `camera`, `tflite_flutter`, `image`, `shared_preferences`, `permission_handler` 의존성 추가
  - `model.tflite`, `labels.txt` asset 등록
- `pubspec.lock`
  - 카메라, TFLite, 이미지 처리, SharedPreferences, 권한 패키지 잠금 정보 갱신
- `android/app/src/main/AndroidManifest.xml`
  - Android 카메라 권한과 camera feature 선언
- `ios/Runner/Info.plist`
  - iOS 카메라 권한 설명 추가
- `lib/app/app.dart`
  - 테스트에서 CameraScreen 대체 주입이 가능하도록 `cameraBuilder` 추가
- `lib/app/router/app_router.dart`
  - Camera 라우트를 실제 `CameraScreen`으로 연결
- `lib/features/camera/data/style_history_repository.dart`
  - 최근 인식 스타일 히스토리 저장, 조회, 삭제 repository 추가
- `lib/features/camera/data/tflite_style_classifier.dart`
  - TFLite 모델 로딩, 라벨 로딩, 프레임 전처리, 추론, confidence threshold 처리 추가
- `lib/features/camera/presentation/controllers/camera_screen_controller.dart`
  - 권한 요청, 카메라 초기화, 프레임 스트림, recognitionStyle, 히스토리, 화면 이동 상태 관리 추가
- `lib/features/camera/presentation/camera_screen.dart`
  - 카메라 프리뷰, 히스토리 가로 목록, 삭제 버튼, `촬영하기` 버튼 UI 구현
- `test/widget_test.dart`
  - 히스토리 repository 테스트 추가
  - Camera 라우팅 테스트를 fake CameraScreen 주입 방식으로 변경
- `macos/Flutter/GeneratedPluginRegistrant.swift`
- `linux/flutter/generated_plugins.cmake`
- `windows/flutter/generated_plugin_registrant.cc`
- `windows/flutter/generated_plugins.cmake`
  - 신규 Flutter 플러그인 등록을 위해 Flutter tool이 갱신

### AI 활용 방식

- AI가 `docs/architecture.md`, `docs/feature-spec.md`, `docs/coding-rules.md`, `docs/ui-guideline.md`, `docs/harness-checklist.md`의 Camera/TFLite 계약을 확인했다.
- AI가 원본 Android 프로젝트의 `app/src/main/assets/model.tflite`, `labels.txt`를 찾아 Flutter asset으로 복사했다.
- AI가 Camera, TFLite, 히스토리 책임을 각각 screen, controller, classifier, repository로 분리했다.
- AI가 테스트 환경에서 실제 카메라 플러그인을 실행하지 않도록 라우터에 `cameraBuilder` 주입 지점을 추가했다.
- AI가 Android 에뮬레이터 연결 상태를 확인하고, 연결된 Android 디바이스가 없어 APK 빌드 검증으로 대체했다.

### 발생한 문제

- Flutter 프로젝트에는 `model.tflite`, `labels.txt`가 없어서 원본 Android 프로젝트에서 asset을 찾아 복사해야 했다.
- `flutter pub add` 이후 직접 추가한 의존성이 중복되어 `pubspec.yaml` duplicate mapping 오류가 발생했다.
- 일반 샌드박스에서 Flutter SDK cache 접근 제한으로 `flutter build apk --debug`가 실패했다.
- 현재 `flutter devices`에서 Android 에뮬레이터가 감지되지 않아 권한 요청과 카메라 프리뷰 수동 검증을 완료할 수 없었다.

### 해결 방법

- `/Users/hj/project_personal/my-home-catalog/app/src/main/assets/`의 `model.tflite`, `labels.txt`를 `assets/`로 복사했다.
- `pubspec.yaml`의 중복 의존성을 제거하고 asset 등록을 정리했다.
- 카메라 프레임은 RGB 변환, 센서 방향 기반 회전 보정, 정사각 crop, resize 순서로 전처리했다.
- 이미 프레임을 처리 중이면 새 프레임을 건너뛰고, 추론 간격을 제한해 UI 부담을 줄였다.
- Flutter SDK cache 권한 문제는 승인된 escalated command로 `flutter build apk --debug`를 재실행해 검증했다.

### 검증 결과

- `dart format lib test` 통과
- `flutter analyze` 통과
- `flutter test` 통과
- `flutter build apk --debug` 통과
- `flutter devices` 실행 결과 Android 에뮬레이터 미연결 확인

### 다음 작업 계획

- Android 에뮬레이터 또는 실기기에서 CameraScreen 진입, 권한 요청, 프리뷰 표시를 수동 검증한다.
- 실제 카메라 프레임에서 TFLite confidence와 라벨 갱신이 Android 원본과 유사한지 확인한다.
- 히스토리 클릭 시 `MainScreen`으로 전달되는 `style`, `type`이 실제 추천 목록 조회에 반영되는지 수동 검증한다.
- iOS 실기기에서 카메라 권한과 프리뷰 표시를 검증한다.
- 필요 시 TFLite 추론을 isolate로 분리해 성능을 최적화한다.
