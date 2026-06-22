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
