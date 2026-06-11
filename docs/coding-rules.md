# Coding Rules

## 1. 문서 목적

이 문서는 `My Home Catalog` Android 앱을 Flutter로 마이그레이션할 때 적용할 코딩 규칙이다.

주요 목적은 다음과 같다.

- Flutter 프로젝트 개발 시 AI 도구가 일관된 구조와 스타일로 코드를 생성하도록 한다.
- Context Engineering 및 Harness Engineering에서 공통 기준 문서로 사용한다.
- 기존 Android 앱에서 확인된 기능을 유지하면서 Flutter 프로젝트 구조를 실무 수준으로 정리한다.
- 아직 결정되지 않은 기술 선택을 AI가 임의로 확정하지 않도록 제한한다.

## 2. 기준 문서

기능 구현, 리팩터링, 코드 생성 전 반드시 다음 문서를 확인한다.

- `docs/architecture.md`
- `docs/feature-spec.md`
- `docs/harness-checklist.md`

### 확인된 원본 Android 기능

현재 분석 문서에서 확인된 기능은 다음 범위로 제한한다.

- 초기 화면에서 추천 목록, 맞춤 가구 선택, 즐겨찾기 화면으로 이동
- 전체 추천 목록 조회
- 스타일 필터와 가구 타입 필터 기반 추천 목록 조회
- 맞춤 가구 선택 후 카메라 화면 이동
- 카메라 프레임을 TensorFlow Lite 모델로 분류
- confidence `0.9` 이상인 최상위 분류 결과를 스타일로 사용
- 스타일 히스토리 표시, 재탐색, 삭제
- Firebase Realtime Database의 `all/{style}/{type}` 경로에서 추천 물품 조회
- 추천 물품 상세 화면 표시
- 구매 링크를 외부 브라우저 또는 외부 앱으로 열기
- 상세 화면에서 즐겨찾기 저장
- 즐겨찾기 목록 조회 및 삭제

### 결정 필요 항목

다음 항목은 Android 원본에서 Flutter 구현 방식이 확정되지 않았으므로 작업 전 결정이 필요하다.

- 상태관리 최종 선택: Provider, Riverpod, Bloc, Cubit, ValueNotifier 등
- 라우팅 방식: Navigator 1.0, go_router, auto_route 등
- 로컬 저장 방식: 파일 JSON 유지, shared_preferences, sqflite, hive 등
- Firebase 초기화 및 환경 분리 방식
- TFLite Flutter 패키지 선택 및 카메라 프레임 처리 방식
- 이미지 캐싱 패키지 선택
- 디자인 시스템 및 테마 토큰 범위
- 테스트 프레임워크 적용 범위
- Analytics 사용 여부

`architecture.md`에는 Flutter Migration Goal로 Provider 기반 상태관리 적용 예정이 기록되어 있다. 단, 실제 Flutter 코드와 프로젝트 의존성이 아직 확인되지 않은 경우에는 최종 확정 전까지 Provider 사용을 기정사실로 두고 광범위한 구조를 생성하지 않는다.

## 3. 기본 개발 원칙

- 기존 Android 앱에서 확인된 기능을 우선 보존한다.
- 확인되지 않은 신규 기능을 임의로 추가하지 않는다.
- 화면, 데이터 필드, Firebase 경로, 로컬 저장 key는 기존 계약을 우선 유지한다.
- 기능 구현은 한 번에 하나의 기능 단위로 진행한다.
- 기능 단위는 화면, 데이터 흐름, 저장소, 예외 처리, 검증 항목이 함께 닫히는 범위로 정의한다.
- 공통화는 실제 중복이 확인된 뒤 수행한다.
- UI/UX 개선은 기능 보존 이후 별도 작업으로 분리한다.
- Android 원본과 다른 동작을 도입할 경우 변경 이유를 문서 또는 작업 로그에 기록한다.
- AI가 생성한 코드는 반드시 사람이 검토한 뒤 적용한다.

## 4. Flutter 프로젝트 구조 규칙

Flutter 프로젝트는 실무에서 일반적으로 사용하는 `lib/` 중심 구조를 따른다.

권장 기본 구조:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── repositories/
├── features/
│   ├── initial/
│   ├── home/
│   ├── custom/
│   ├── camera/
│   ├── detail/
│   └── favorites/
└── main.dart
```

### 디렉터리 역할

- `app/`: 앱 진입점, 라우팅, 테마, 전역 앱 설정
- `core/`: 특정 기능에 종속되지 않는 상수, 에러, 유틸, 공통 위젯
- `data/`: 외부 데이터 소스, 로컬 저장소, 모델, repository 구현
- `features/`: 화면 또는 기능 단위 구현
- `features/{feature}/presentation/`: 화면, 위젯, 상태 객체
- `features/{feature}/domain/`: 필요 시 use case, entity, repository interface
- `features/{feature}/data/`: 기능에 강하게 종속된 data source 또는 mapper

### Feature First 구조 적용 검토

현재 Android 원본은 `feature.camera`, `feature.custom`, `feature.detail`, `feature.favorites`, `feature.home` 구조를 사용한다.

Flutter 마이그레이션에서는 Feature First 구조 적용을 권장한다.

적용 대상:

- `initial`: 초기 진입 화면
- `home`: 추천 목록, 스타일/타입 필터, Firebase 조회 결과 표시
- `custom`: 가구 타입 선택
- `camera`: 카메라, TFLite 분류, 스타일 히스토리
- `detail`: 물품 상세, 구매 링크, 즐겨찾기 저장
- `favorites`: 즐겨찾기 목록, 선택 삭제

Feature First를 적용하되, 다음 데이터는 공통 `data/` 또는 `core/`로 분리할 수 있다.

- `ItemData`에 대응하는 추천/즐겨찾기 공통 모델
- Firebase 추천 목록 조회 repository
- 즐겨찾기 로컬 저장소
- 스타일/가구 타입 상수
- 외부 URL 실행 유틸

## 5. 네이밍 규칙

### 파일명

- Dart 파일은 `snake_case.dart`를 사용한다.
- 화면 파일은 `{feature}_page.dart` 또는 `{feature}_screen.dart` 중 하나로 통일한다.
- 위젯 파일은 `{role}_widget.dart`보다 의미 있는 이름을 사용한다.
- 모델 파일은 `{model_name}_model.dart`를 사용한다.
- repository 파일은 `{domain}_repository.dart`를 사용한다.
- data source 파일은 `{domain}_{local|remote}_data_source.dart`를 사용한다.

예시:

```text
home_page.dart
item_card.dart
item_model.dart
recommendation_repository.dart
favorites_local_data_source.dart
firebase_recommendation_data_source.dart
```

### 클래스명

- 클래스명은 `PascalCase`를 사용한다.
- Widget 클래스는 역할이 드러나도록 명명한다.
- Provider, Controller, Bloc 등 상태 객체는 선택된 상태관리 방식의 관례를 따른다.

예시:

```dart
class HomePage extends StatelessWidget {}
class ItemModel {}
class RecommendationRepository {}
class FavoritesLocalDataSource {}
```

### 변수명과 상수명

- 변수와 함수는 `lowerCamelCase`를 사용한다.
- 상수는 Dart 관례에 따라 `lowerCamelCase`를 사용한다.
- Firebase path, intent extra에 대응하는 key, JSON key는 상수화한다.

예시:

```dart
const firebaseRootPath = 'all';
const itemImageKey = 'image';
const favoriteNameKey = 'Name';
```

## 6. Widget 작성 규칙

- 화면 단위 Widget은 가능한 얇게 유지한다.
- 화면 Widget 안에 긴 비즈니스 로직, Firebase 호출, 파일 IO를 직접 작성하지 않는다.
- 반복 UI는 별도 Widget으로 분리한다.
- 분기 UI는 명확한 상태 이름을 기준으로 작성한다.
- `build()` 메서드 안에서 네트워크 호출, 파일 IO, 상태 변경을 수행하지 않는다.
- `setState()` 사용 범위는 로컬 UI 상태로 제한한다.
- 공통 버튼, 필터 칩, 아이템 카드, 빈 상태 UI는 `core/widgets/` 또는 feature 내부 `widgets/`에 둔다.
- 하나의 Widget 파일이 과도하게 커지면 역할 기준으로 분리한다.
- `BuildContext`를 async gap 이후 사용할 때는 `mounted` 확인을 수행한다.
- 이미지, 텍스트, 버튼은 null 또는 빈 값에 대한 표시 정책을 명확히 둔다.

### 화면별 Widget 분리 기준

- `InitialPage`: 초기 이동 버튼과 타이틀
- `CustomPage`: 가구 타입 그리드, 선택 상태, 다음 버튼
- `CameraPage`: 카메라 프리뷰, 촬영 버튼, 히스토리 목록
- `HomePage`: 스타일 필터, 타입 필터, 추천 목록, 하단 이동
- `DetailPage`: 이미지, 이름, 가격, 저장 버튼, 구매 버튼
- `FavoritesPage`: 즐겨찾기 목록, 선택 상태, 삭제 버튼

## 7. 상태관리 규칙

### 기본 원칙

- 상태관리 방식은 프로젝트에서 하나를 선택해 일관되게 사용한다.
- AI는 상태관리 기술을 임의로 선택하지 않는다.
- 단순 화면 로컬 상태와 앱 기능 상태를 구분한다.
- Firebase 조회, 즐겨찾기 저장, 카메라 분류 결과는 Widget 내부 임시 변수로만 관리하지 않는다.
- 비동기 상태는 loading, data, empty, error를 구분한다.

### 상태로 관리해야 하는 값

- 현재 선택된 스타일
- 현재 선택된 가구 타입
- 추천 물품 목록
- 추천 목록 조회 상태
- 즐겨찾기 목록
- 즐겨찾기 선택 삭제 대상
- 물품 저장 여부
- 카메라 인식 스타일
- 스타일 히스토리 목록
- 카메라 권한 상태
- TFLite 분류 처리 중 여부

### 기존 Android 계약

- 기본 스타일 값은 `all`이다.
- 기본 가구 타입 값은 `all`이다.
- 스타일 필터 변경 시 가구 타입은 `all`로 초기화된다.
- 카메라 분류 결과는 confidence `0.9` 이상인 최상위 라벨만 사용한다.
- 인식 스타일이 비어 있으면 추천 목록 화면으로 이동하지 않는다.
- 처리 중인 카메라 프레임이 있으면 새 프레임은 처리하지 않는다.

### 결정 필요

상태관리 도입 전 다음 중 하나를 확정한다.

- Provider
- Riverpod
- Bloc/Cubit
- ValueNotifier 기반 경량 구조
- 기타 프로젝트 표준

확정 전에는 대규모 상태관리 보일러플레이트를 생성하지 않는다.

## 8. 데이터 모델 규칙

### 공통 모델

Android 원본의 `ItemData`에 대응하는 모델은 다음 필드를 유지한다.

```text
image
name
price
link
```

규칙:

- Firebase 응답 필드명은 소문자 key를 유지한다.
- 즐겨찾기 로컬 JSON 저장 필드는 기존 Android key를 유지할지 마이그레이션할지 결정 후 적용한다.
- 모델에는 `fromJson`, `toJson`을 명시적으로 구현한다.
- Firebase JSON과 로컬 즐겨찾기 JSON의 key가 다르면 mapper를 분리한다.
- UI 표시용 문자열 변환은 모델 내부에 과도하게 넣지 않는다.

### 즐겨찾기 로컬 JSON 계약

Android 원본의 즐겨찾기 저장 필드는 다음과 같다.

```text
Image
Name
Price
Link
```

규칙:

- 기존 사용자 데이터 호환이 필요하면 위 key를 유지한다.
- Flutter에서 새 저장 구조를 도입할 경우 마이그레이션 정책을 먼저 작성한다.
- 중복 체크 기준은 기존과 동일하게 `Name`이다.
- 삭제는 기존과 동일하게 선택된 position 기준 동작을 우선 보존한다.

### 스타일과 가구 타입 값

스타일 값:

```text
all
natural
modern
classic
industrial
zen
```

TFLite 라벨 값:

```text
zen
natural
modern
industrial
classic
```

가구 타입 값:

```text
all
bed
chair
dresser
sofa
table
```

규칙:

- 문자열 literal을 화면 곳곳에 직접 작성하지 않는다.
- enum 또는 sealed class 사용 여부는 프로젝트 컨벤션 결정 후 적용한다.
- Firebase path에 들어가는 값과 화면 표시 텍스트를 분리한다.

## 9. Firebase 연동 규칙

### 확인된 Firebase 계약

원본 Android 앱은 Firebase Realtime Database를 사용한다.

기본 참조:

```text
all
```

조회 경로:

```text
all/{style}/{type}
```

leaf child의 데이터 필드:

```text
image
name
price
link
```

### 구현 규칙

- Firebase 조회 코드는 화면 Widget에 직접 작성하지 않는다.
- Firebase 접근은 data source 또는 repository 계층으로 분리한다.
- `style=all`이면 전체 스타일을 순회한다.
- `type=all`이면 전체 타입을 순회한다.
- 조회 결과는 `ItemModel` 또는 이에 대응하는 모델로 변환한다.
- 조회 실패는 로그만 남기는지, 사용자에게 표시하는지 정책을 정한 뒤 일관되게 처리한다.
- Firebase Analytics는 Android 의존성에 존재하지만 직접 호출 코드는 확인되지 않았다. Flutter에서 Analytics 이벤트를 임의로 추가하지 않는다.

### 결정 필요

- `firebase_core`, `firebase_database`, `firebase_analytics` 사용 여부
- Android/iOS Firebase 설정 파일 관리 방식
- dev/prod 환경 분리 여부
- Firebase 조회 실패 시 UI 표시 정책

## 10. TFLite 및 카메라 규칙

### 확인된 Android 계약

- 모델 파일: `model.tflite`
- 라벨 파일: `labels.txt`
- 라벨: `zen`, `natural`, `modern`, `industrial`, `classic`
- classifier: quantized MobileNet
- 최상위 결과 confidence가 `0.9` 이상일 때만 인식 스타일로 저장
- 상위 3개 결과를 confidence 내림차순으로 다룬다.
- 처리 중인 프레임이 있으면 추가 프레임은 버린다.

### Flutter 구현 규칙

- 카메라 권한 요청 흐름을 명시적으로 구현한다.
- TFLite 모델과 라벨 파일은 Flutter asset으로 등록한다.
- 프레임 회전, crop/pad, resize 처리 방식을 문서화한다.
- 추론은 UI thread를 막지 않도록 처리한다.
- confidence threshold `0.9`를 상수로 관리한다.
- 인식 스타일이 없을 때 추천 화면으로 이동하지 않는 기존 동작을 유지한다.

### 결정 필요

- Flutter 카메라 패키지
- TFLite 실행 패키지
- isolate 사용 여부
- iOS 카메라 및 TFLite 지원 범위

## 11. 로컬 저장 규칙

### 즐겨찾기

- 기존 파일명은 `savedItem.json`이다.
- 기존 Android 저장 위치는 앱 내부 파일 디렉터리이다.
- 기존 저장 형식은 JSON 배열이다.
- 기존 중복 기준은 `Name`이다.

Flutter 구현 규칙:

- 저장소 구현은 repository 또는 local data source로 분리한다.
- 파일 저장을 유지할 경우 JSON 파싱 실패와 파일 없음 상태를 구분한다.
- 저장, 조회, 삭제 API는 비동기 함수로 작성한다.
- 삭제 후 목록 상태를 즉시 갱신한다.
- 기존 데이터 호환 여부를 결정하기 전 key를 임의 변경하지 않는다.

### 스타일 히스토리

Android 원본의 히스토리 저장 계약:

- SharedPreferences 이름: `file`
- key: 인식 스타일 문자열
- value: 인식 스타일 문자열

Flutter 구현 규칙:

- 히스토리 저장소를 화면 Widget 내부에 직접 구현하지 않는다.
- 동일 스타일 저장 시 기존 값을 제거 후 다시 저장하는 동작을 보존할지 결정한다.
- 히스토리 삭제는 UI 목록과 저장소 모두에 반영한다.

## 12. 공통 컴포넌트 관리 규칙

- 두 개 이상의 feature에서 사용하는 Widget만 `core/widgets/`로 이동한다.
- 특정 feature에서만 쓰는 Widget은 해당 feature 내부에 둔다.
- 색상, typography, spacing은 theme 또는 design token으로 관리한다.
- Firebase path, JSON key, asset path, route name은 상수화한다.
- 공통 컴포넌트는 비즈니스 로직을 포함하지 않는다.
- 공통 컴포넌트는 외부 상태관리 구현체에 직접 의존하지 않도록 설계한다.

공통화 후보:

- 추천/즐겨찾기 아이템 카드
- 스타일 필터 버튼
- 가구 타입 필터 버튼
- 빈 목록 표시
- 로딩 표시
- 에러 표시
- 외부 링크 실행 유틸

## 13. 예외 처리 규칙

### 기본 규칙

- 예외를 빈 `catch`로 삼키지 않는다.
- 사용자에게 보여야 하는 오류와 로그만 남길 오류를 구분한다.
- 비동기 작업 실패 시 상태를 `error`로 전환할 수 있어야 한다.
- 파일 없음, 빈 목록, 파싱 실패, 네트워크 실패는 서로 다른 상태로 다룬다.
- 외부 링크 실행 실패 시 사용자 안내 정책을 정한다.

### Android 원본에서 확인된 사용자 메시지

다음 메시지는 기존 동작 보존 대상이다.

- `"가구를 선택해주세요!"`
- `"이미 존재하는 아이템입니다."`
- `"즐겨찾기한 항목이 없습니다 !"`
- `"Camera permission is required for this demo"`
- `"Failed"`

문구를 변경할 경우 변경 이유를 기록한다.

### Android 원본에서 로그 처리된 오류

다음 오류 범주는 Flutter에서도 로깅 정책을 가져야 한다.

- 즐겨찾기 JSON 읽기 실패
- 즐겨찾기 JSON 쓰기 실패
- 즐겨찾기 JSON 파싱 실패
- 즐겨찾기 삭제 처리 실패
- Firebase 조회 취소 또는 실패
- 카메라 접근 실패
- 카메라 프레임 처리 실패
- classifier 생성 실패
- TFLite 추론 실패

## 14. AI 코드 생성 규칙

AI 도구는 다음 규칙을 반드시 따른다.

- 기능 구현 전 `docs/architecture.md`와 `docs/feature-spec.md`를 확인한다.
- 구현 완료 후 `docs/harness-checklist.md` 기준으로 검증한다.
- 하나의 기능 단위로 작업한다.
- 기존 기능과 충돌하면 변경 이유를 작업 로그 또는 PR 설명에 기록한다.
- 확인되지 않은 기능, 화면, 데이터 필드를 추가하지 않는다.
- 상태관리, 라우팅, 저장소, 패키지 선택을 임의로 확정하지 않는다.
- 파일 구조를 변경할 때는 변경 범위와 이유를 명확히 남긴다.
- Android 원본의 데이터 계약을 변경하지 않는다.
- Firebase 경로와 JSON key는 상수화한다.
- 테스트 또는 수동 검증 없이 완료로 표시하지 않는다.
- 생성된 코드는 반드시 사람이 검토한 후 적용한다.

### AI 작업 전 체크리스트

- [ ] 구현 대상 기능이 `feature-spec.md`에 존재하는가?
- [ ] 관련 데이터 흐름이 `architecture.md`에 기록되어 있는가?
- [ ] 상태관리 방식이 확정되어 있는가?
- [ ] 라우팅 방식이 확정되어 있는가?
- [ ] Firebase 또는 로컬 저장 key 변경이 필요한가?
- [ ] 기존 Android 동작과 달라지는 부분이 있는가?
- [ ] 검증 기준이 `harness-checklist.md`에 있는가?

### AI 작업 후 체크리스트

- [ ] 하나의 기능 단위로 변경이 닫혔는가?
- [ ] 신규 기능을 임의로 추가하지 않았는가?
- [ ] 기존 데이터 계약을 유지했는가?
- [ ] 예외 처리와 빈 상태가 구현되었는가?
- [ ] Widget에 비즈니스 로직이 과도하게 들어가지 않았는가?
- [ ] `flutter analyze` 기준 위반이 없는가?
- [ ] 관련 테스트 또는 수동 검증을 수행했는가?
- [ ] `harness-checklist.md` 결과를 확인했는가?

## 15. 코드 리뷰 규칙

코드 리뷰는 기능 보존과 마이그레이션 안정성을 우선한다.

리뷰 체크리스트:

- [ ] Android 원본 기능과 동작이 일치하는가?
- [ ] `feature-spec.md`에 없는 기능이 추가되지 않았는가?
- [ ] Firebase 경로 `all/{style}/{type}` 계약을 유지하는가?
- [ ] `ItemData` 대응 필드 `image`, `name`, `price`, `link`가 유지되는가?
- [ ] 즐겨찾기 저장 key와 중복 기준이 의도대로 유지되는가?
- [ ] 상태관리 책임이 Widget에 과도하게 집중되지 않았는가?
- [ ] 비동기 loading, empty, error 상태가 명확한가?
- [ ] 카메라 권한 실패와 추론 실패 처리가 있는가?
- [ ] 외부 링크 실행 실패 처리가 있는가?
- [ ] 공통 컴포넌트가 특정 feature 로직에 의존하지 않는가?
- [ ] 테스트 또는 수동 검증 결과가 남아 있는가?

## 16. 금지 사항

다음 작업은 금지한다.

- 분석 문서에 없는 기능을 임의로 추가
- 상태관리 기술을 임의로 선택해 전역 구조 생성
- Firebase Database 경로를 임의 변경
- `image`, `name`, `price`, `link` 필드명을 임의 변경
- 즐겨찾기 key `Image`, `Name`, `Price`, `Link`를 호환 정책 없이 변경
- confidence threshold `0.9`를 임의 변경
- 스타일 라벨 또는 가구 타입 값을 임의 추가
- Widget `build()` 안에서 네트워크 호출 또는 파일 IO 수행
- 화면 Widget에 Firebase, 파일 저장, TFLite 추론 로직 직접 작성
- 예외를 무시하거나 빈 `catch`로 처리
- 사용자 검토 없이 AI 생성 코드를 그대로 병합
- 검증 없이 작업 완료 처리
- 기존 사용자 플로우를 변경하면서 변경 이유를 기록하지 않음

## 17. 마이그레이션 구현 우선순위

권장 구현 순서는 다음과 같다.

1. Flutter 프로젝트 기본 구조와 라우팅 결정
2. 스타일, 가구 타입, Firebase path, JSON key 상수 정의
3. `ItemModel` 및 즐겨찾기 모델/mapper 정의
4. 초기 화면, 홈 화면, 상세 화면 기본 UI 구현
5. Firebase 추천 목록 조회 구현
6. 즐겨찾기 로컬 저장/조회/삭제 구현
7. 맞춤 가구 선택 화면 구현
8. 카메라 권한 및 프리뷰 구현
9. TFLite 추론 구현
10. 스타일 히스토리 구현
11. 전체 플로우 검증

각 단계 완료 후 `harness-checklist.md` 기준으로 검증 결과를 남긴다.
