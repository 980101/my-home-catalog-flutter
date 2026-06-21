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

## 변경 파일

### 이번 작업에서 수정 또는 추가한 파일

- `lib/main.dart`
  - Flutter counter 템플릿 제거
  - `MyHomeCatalogApp` 실행으로 변경
- `lib/app/app.dart`
  - `MaterialApp`, 앱 제목, 테마, 초기 라우트, 라우트 맵 연결
- `lib/app/router/app_routes.dart`
  - Initial, Home, Custom, Favorites 라우트 상수 정의
- `lib/app/router/app_router.dart`
  - `InitialScreen` 라우트 연결
  - 후속 마이그레이션 전까지 사용할 목적지 placeholder 화면 연결
- `lib/app/theme/app_colors.dart`
  - `ui-guideline.md` 기준 색상 토큰 정의
- `lib/app/theme/app_spacing.dart`
  - 간격 및 radius 토큰 정의
- `lib/app/theme/app_text_styles.dart`
  - 초기 화면 타이틀과 기본 라벨 텍스트 스타일 정의
- `lib/app/theme/app_theme.dart`
  - 앱 기본 테마, AppBar, ElevatedButton, TextButton 스타일 정의
- `lib/features/initial/domain/initial_navigation_handler.dart`
  - 초기 화면 버튼별 이동 로직 분리
- `lib/features/initial/presentation/initial_screen.dart`
  - Android `activity_initial.xml`과 `InitialActivity` 기준 초기 화면 UI 구현
- `test/widget_test.dart`
  - counter 테스트 제거
  - InitialScreen 표시 및 라우팅 테스트 추가
- 검증 작업 자체는 코드 수정 없이 수행했다.

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

## 발생한 문제

- Flutter 프로젝트가 기본 counter 템플릿 상태라 `InitialScreen`을 붙일 앱 구조, 라우터, 테마 파일이 없었다.
- `InitialScreen`의 이동 대상인 Home, Custom, Favorites 화면은 아직 Flutter로 마이그레이션되지 않은 상태였다.
- `dart format`, `flutter analyze`, `flutter test` 실행 시 Flutter SDK가 `/opt/homebrew/share/flutter/bin/cache/engine.stamp`를 갱신하려고 하면서 샌드박스 권한 오류가 발생했다.
- `docs/harness-checklist.md`가 작업 전부터 Git 변경사항에 포함되어 있어, 이번 작업 변경 범위와 구분할 필요가 있었다.
- `/home`, `/custom`, `/favorites` 이동 대상이 실제 Page가 아닌 placeholder라 체크리스트 일부 항목은 완전 검증할 수 없었다.
- placeholder 화면이 임시 화면 또는 TODO임을 UI상 명확히 표시하지 않는다.
- 일부 간격 값이 `AppSpacing` 토큰 대신 직접 입력되어 있다.

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
- 검증 결과:
  - `dart format lib test` 통과
  - `flutter analyze` 통과
  - `flutter test` 통과

## 다음 작업 계획

- placeholder 화면을 `MainPage`, `CustomPage`, `FavoritesPage` 기준으로 명확히 정리한다.
- placeholder 본문에 TODO 또는 임시 화면 표시를 추가한다.
- InitialScreen의 직접 입력된 간격 값을 디자인 토큰으로 교체한다.
- `CustomActivity`를 Flutter `CustomScreen`으로 마이그레이션한다.
  - 가구 타입 2열 그리드
  - 선택 상태 표시
  - 미선택 시 `"가구를 선택해주세요!"` 메시지 표시
  - 선택한 `type`을 Camera 화면으로 전달
- `MainActivity`, `FavoritesActivity` placeholder를 실제 화면으로 순차 교체한다.
- 라우트 placeholder는 각 화면 마이그레이션 완료 시 제거한다.
- Firebase, 로컬 JSON 저장소, 카메라/TFLite 등 결정이 필요한 항목은 구현 전 문서 기준과 현재 의존성을 다시 확인한다.
- 기능 단위 구현마다 `flutter analyze`, 관련 위젯 테스트 또는 수동 검증 결과를 남긴다.
