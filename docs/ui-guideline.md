# UI Guideline

## 1. 문서 목적

이 문서는 `My Home Catalog`를 Flutter로 구현할 때 화면별 UI가 일관되게 생성되도록 하는 기준 문서이다.

목적은 다음과 같다.

- Flutter 화면 구현 시 앱 전체의 색상, 간격, 텍스트, 버튼, 카드 스타일을 통일한다.
- AI가 화면을 생성할 때 기존 Android 앱의 화면 구조와 기능 범위를 벗어나지 않도록 한다.
- `docs/architecture.md`, `docs/feature-spec.md`, `docs/coding-rules.md`에 기록된 기능 계약을 UI 구현 기준으로 연결한다.

이 문서는 신규 기능을 정의하지 않는다. 화면, 버튼, 상태, 데이터는 기존 Android 앱에서 확인된 범위만 사용한다.

## 2. 기준 화면과 기능 범위

Flutter UI는 다음 Android 화면 구조를 기준으로 한다.

- `InitialActivity`: 초기 진입, 추천 목록 이동, 맞춤 가구 선택 이동, 즐겨찾기 이동
- `CustomActivity`: 가구 타입 선택, 다음 버튼
- `ClassifierActivity` / `CameraActivity`: 카메라 프리뷰, 촬영 버튼, 스타일 히스토리
- `MainActivity`: 스타일 필터, 가구 타입 필터, 추천 목록, 하단 이동
- `DetailActivity`: 상품 이미지, 상품명, 가격, 저장 버튼, 구매 버튼
- `FavoritesActivity`: 즐겨찾기 목록, 삭제 대상 선택, 삭제 버튼

UI 생성 시 다음 기능을 추가하지 않는다.

- Android 원본에 없는 검색, 정렬, 장바구니, 로그인, 리뷰, 공유, 앱 내부 WebView
- 원본에 없는 신규 필터 값
- Firebase 데이터 모델에 없는 상품 필드
- Analytics 이벤트 화면 표시

## 3. 앱 전체 디자인 방향

앱은 인테리어 상품 추천 앱이므로 복잡한 장식보다 상품 이미지, 필터 선택 상태, 주요 행동 버튼이 먼저 읽히는 구조를 사용한다.

디자인 원칙:

- 배경은 밝고 깨끗하게 유지한다.
- 상품 이미지와 카드가 화면의 중심이 되도록 한다.
- 선택 가능한 항목은 선택/비선택 상태가 명확해야 한다.
- 카메라 화면은 프리뷰 영역을 가장 크게 유지하고, 히스토리와 촬영 버튼은 보조 영역으로 배치한다.
- Android 원본의 화면 이동 흐름을 유지한다.
- Material 위젯을 기본으로 사용하되 iOS에서도 어색하지 않은 중립적인 스타일을 적용한다.

권장 화면 밀도:

- 모바일 세로 화면을 기본 기준으로 설계한다.
- 목록 화면은 스크롤 가능한 단일 컬럼을 기본으로 한다.
- 가구 타입 선택은 기존 Android와 동일하게 2열 그리드를 기본으로 한다.
- 필터 버튼은 가로 스크롤 또는 줄바꿈 가능한 영역으로 구성한다.

## 4. 디자인 토큰

색상, 간격, 반경, 텍스트 스타일은 `lib/app/theme/` 또는 `lib/core/constants/`에서 상수로 관리한다.

예시 파일:

```text
lib/app/theme/app_colors.dart
lib/app/theme/app_spacing.dart
lib/app/theme/app_text_styles.dart
lib/app/theme/app_theme.dart
```

상태관리, 라우팅, 저장소 선택과 무관하게 UI 토큰은 화면에서 직접 하드코딩하지 않는다.

## 5. 주요 색상

원본 Android 리소스가 현재 Flutter 프로젝트에 포함되어 있지 않으므로, 아래 색상을 Flutter 기본 디자인 토큰으로 사용한다. 원본 Android 색상 리소스가 복구되면 같은 의미의 토큰에 매핑한다.

| 토큰 | 값 | 용도 |
| --- | --- | --- |
| `primary` | `#6B7A5A` | 주요 버튼, 선택된 필터, 강조 액션 |
| `primaryDark` | `#4E5B3F` | 버튼 pressed 상태, 강조 텍스트 |
| `primaryLight` | `#E7ECDF` | 선택된 칩/카드 배경 |
| `background` | `#FAFAF7` | 앱 기본 배경 |
| `surface` | `#FFFFFF` | 카드, 리스트 아이템, 바텀 영역 |
| `surfaceVariant` | `#F1F1EC` | 비선택 필터, 구분 배경 |
| `textPrimary` | `#222222` | 제목, 상품명, 주요 텍스트 |
| `textSecondary` | `#666666` | 보조 설명, 가격 보조 정보 |
| `textDisabled` | `#A3A3A3` | 비활성 텍스트 |
| `border` | `#DDDDD6` | 카드/필터 경계선 |
| `error` | `#B3261E` | 에러 화면, 실패 메시지 |
| `scrim` | `#000000` with 45% opacity | 카메라/이미지 위 오버레이가 필요한 경우 |

사용 규칙:

- `primary`는 화면당 핵심 액션과 선택 상태에만 사용한다.
- 상품 카드 배경은 `surface`를 사용한다.
- 전체 화면 배경은 `background`를 사용한다.
- 에러 화면과 실패 상태는 `error`를 사용하되, 일반 빈 화면에는 사용하지 않는다.
- 카메라 프리뷰 화면은 프리뷰를 해치지 않도록 하단 컨트롤 영역에 `surface` 또는 반투명 `scrim`을 사용한다.

Flutter 예시:

```dart
class AppColors {
  static const primary = Color(0xFF6B7A5A);
  static const primaryDark = Color(0xFF4E5B3F);
  static const primaryLight = Color(0xFFE7ECDF);
  static const background = Color(0xFFFAFAF7);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F1EC);
  static const textPrimary = Color(0xFF222222);
  static const textSecondary = Color(0xFF666666);
  static const textDisabled = Color(0xFFA3A3A3);
  static const border = Color(0xFFDDDDD6);
  static const error = Color(0xFFB3261E);
}
```

## 6. 간격과 크기

기본 간격은 4dp grid를 따른다.

| 토큰 | 값 | 용도 |
| --- | --- | --- |
| `xs` | `4` | 아이콘과 텍스트 사이 |
| `sm` | `8` | 카드 내부 작은 간격 |
| `md` | `16` | 화면 기본 padding, 리스트 간격 |
| `lg` | `24` | 섹션 간격 |
| `xl` | `32` | 큰 제목과 주요 콘텐츠 간격 |

화면 규칙:

- 일반 화면 좌우 padding은 `16`을 기본으로 한다.
- 카드 내부 padding은 `12` 또는 `16`을 사용한다.
- 리스트 아이템 사이 간격은 `12`를 기본으로 한다.
- 하단 고정 영역이 있는 화면은 `SafeArea`와 하단 padding을 반드시 고려한다.
- 터치 가능한 영역의 최소 높이는 `48`을 유지한다.

Radius:

| 토큰 | 값 | 용도 |
| --- | --- | --- |
| `radiusSmall` | `8` | 칩, 작은 버튼 |
| `radiusMedium` | `12` | 카드, 리스트 아이템 |
| `radiusLarge` | `16` | 큰 이미지, 하단 패널 |

카드 반경은 과도하게 둥글게 만들지 않는다. 기본은 `12`이며, 반복 카드에는 `8` 또는 `12`를 사용한다.

## 7. 텍스트 스타일

앱의 기본 텍스트는 시스템 폰트를 사용한다. 별도 폰트가 확정되기 전까지 커스텀 폰트를 추가하지 않는다.

| 토큰 | 크기 | 굵기 | 용도 |
| --- | --- | --- | --- |
| `display` | `32` | `700` | 초기 화면 앱 이름 `My Home Catalog` |
| `titleLarge` | `24` | `700` | 화면 제목 |
| `titleMedium` | `20` | `700` | 섹션 제목, 상세 상품명 강조 |
| `bodyLarge` | `16` | `400` | 기본 본문, 버튼 텍스트 |
| `bodyMedium` | `14` | `400` | 리스트 보조 정보, 가격 |
| `labelLarge` | `14` | `600` | 필터, 작은 버튼 |
| `labelSmall` | `12` | `500` | 히스토리, 보조 라벨 |

텍스트 규칙:

- 화면 제목은 한 화면에 하나만 둔다.
- 상품명은 최대 2줄, 초과 시 `TextOverflow.ellipsis`를 사용한다.
- 가격은 원본 `price` 문자열을 그대로 표시한다. 임의 포맷 변경을 하지 않는다.
- 스타일과 가구 타입의 저장 값은 영어 key를 유지하되, 화면 표시 텍스트는 기존 Android 문구를 따른다.
- 사용자가 보는 Toast/SnackBar 문구는 `feature-spec.md`에 기록된 기존 문구를 우선 유지한다.

표시 텍스트 매핑:

| 값 | 표시 |
| --- | --- |
| `all` style | `전체` 또는 화면 제목 `모든 스타일` |
| `natural` | `내추럴` |
| `modern` | `모던` |
| `classic` | `클래식` |
| `zen` | `젠` |
| `industrial` | `인더스트리얼` |
| `all` type | `All` |
| `chair` | `Chair` |
| `bed` | `Bed` |
| `sofa` | `Sofa` |
| `dresser` | `Dresser` |
| `table` | `Table` |

## 8. 버튼 스타일

### Primary Button

사용 위치:

- `InitialPage`: `맞춤 가구 둘러보기`, `바로 시작`
- `CustomPage`: `다음`
- `CameraPage`: `촬영하기`
- `DetailPage`: `구매하기`

스타일:

- 높이: `52`
- 배경: `primary`
- 텍스트: 흰색, `bodyLarge` 또는 `labelLarge`
- radius: `12`
- 좌우 padding: `16`
- disabled 배경: `textDisabled`

규칙:

- 한 화면의 가장 중요한 행동에만 primary button을 사용한다.
- `CustomPage`에서 가구가 선택되지 않은 상태로 `다음`을 누르면 기존과 동일하게 `"가구를 선택해주세요!"` 메시지를 표시한다.
- `CameraPage`에서 인식 스타일이 없으면 추천 목록으로 이동하지 않는다. 버튼은 유지할 수 있으나 이동 동작은 기존 계약을 따른다.

### Secondary Button

사용 위치:

- 초기 화면의 보조 이동 버튼이 필요한 경우
- 리스트 아이템 내부의 `선택` 버튼
- 하단 이동 버튼

스타일:

- 높이: `44` 이상
- 배경: `surface`
- 텍스트/아이콘: `primary`
- border: `border`
- radius: `12`

### Icon Button

사용 위치:

- 즐겨찾기 저장 버튼
- 즐겨찾기 삭제 버튼
- 히스토리 삭제 버튼
- 하단 이동 아이콘

규칙:

- 터치 영역은 최소 `48 x 48`을 확보한다.
- 즐겨찾기 저장 여부는 outline/fill 아이콘 또는 `primary` 색상으로 구분한다.
- 삭제 아이콘은 위험 동작이므로 `error` 또는 `textSecondary`를 사용하되, 과도하게 강조하지 않는다.
- 아이콘만 사용하는 경우 `tooltip` 또는 `semanticLabel`을 제공한다.

## 9. 필터와 선택 상태

### 스타일 필터

대상 값:

- `all`
- `natural`
- `modern`
- `classic`
- `zen`
- `industrial`

UI 규칙:

- `MainPage` 상단 제목 아래에 배치한다.
- 가로 스크롤 가능한 칩 또는 버튼 그룹으로 구성한다.
- 선택된 스타일은 `primary` 배경과 흰색 텍스트를 사용한다.
- 비선택 스타일은 `surfaceVariant` 배경과 `textPrimary` 텍스트를 사용한다.
- 스타일 변경 시 가구 타입은 기존 계약대로 `all`로 초기화한다.

### 가구 타입 필터

대상 값:

- `all`
- `chair`
- `bed`
- `sofa`
- `dresser`
- `table`

UI 규칙:

- 스타일 필터 아래에 배치한다.
- 선택 상태는 스타일 필터와 동일한 규칙을 따른다.
- 텍스트는 기존 Android 화면 기준인 `All`, `Chair`, `Bed`, `Sofa`, `Dresser`, `Table`을 사용한다.

### Custom 가구 선택 그리드

UI 규칙:

- 2열 그리드로 표시한다.
- 각 아이템은 아이콘과 가구 타입 텍스트를 포함한다.
- 선택된 아이템은 `primaryLight` 배경, `primary` border, `primaryDark` 텍스트를 사용한다.
- 비선택 아이템은 `surface` 배경, `border` border를 사용한다.
- 선택 값은 Firebase path에 사용되는 key 그대로 유지한다.

## 10. 카드 스타일

### 추천 상품 카드

사용 위치:

- `MainPage` 추천 목록
- `FavoritesPage` 즐겨찾기 목록

구성:

- 상품 이미지
- 상품명
- 가격
- 즐겨찾기 목록에서는 삭제 대상 선택 버튼 `선택`

스타일:

- 배경: `surface`
- radius: `12`
- border: `border` 1px 또는 약한 shadow
- 내부 padding: `12`
- 아이템 간격: `12`
- 이미지 radius: `8`
- 이미지 비율: `1:1` 또는 목록형에서는 고정 정사각형 썸네일

규칙:

- 상품 이미지는 Firebase `image` 값을 사용한다.
- 이미지 로딩 실패 시 빈 박스가 아니라 placeholder 영역을 표시한다.
- 상품명과 가격 외에 원본 데이터에 없는 정보를 추가하지 않는다.
- 카드 전체 클릭 시 상세 화면으로 이동한다.
- 즐겨찾기 목록의 `선택` 버튼은 삭제 대상을 지정하는 기능만 수행한다.

### 상세 상품 영역

사용 위치:

- `DetailPage`

구성:

- 상단 상품 이미지
- 상품명 라벨 `제품명`
- 상품명 값
- 가격 라벨 `가격`
- 가격 값
- 저장 아이콘 버튼
- 구매하기 버튼

규칙:

- 이미지가 화면 상단에서 충분히 크게 보여야 한다.
- 구매 링크는 앱 내부 WebView가 아니라 외부 브라우저 또는 외부 앱으로 연다.
- 이미 저장된 상품은 저장 버튼 상태를 채워진 아이콘으로 표시한다.
- 중복 저장 시 `"이미 존재하는 아이템입니다."` 메시지를 표시한다.

## 11. 리스트 아이템 스타일

### 일반 리스트

규칙:

- `ListView.separated` 또는 동일한 간격 정책을 사용한다.
- 좌우 padding은 `16`을 기본으로 한다.
- 마지막 아이템은 하단 navigation 또는 safe area에 가리지 않도록 추가 bottom padding을 둔다.
- 로딩 중에는 기존 리스트를 비우고 로딩 상태를 표시할지, 기존 리스트를 유지할지 기능별 상태 정책에 맞춘다.

### 히스토리 리스트

사용 위치:

- `CameraPage`

구성:

- 스타일명
- 삭제 버튼

스타일:

- 가로 스크롤 리스트
- 높이: `40` 이상
- 배경: `surface` 또는 `scrim` 위 `surface`
- 선택/이동 가능한 영역과 삭제 버튼 영역을 분리한다.

규칙:

- 히스토리 값은 TFLite 라벨인 `zen`, `natural`, `modern`, `industrial`, `classic` 범위만 표시한다.
- 히스토리 아이템 클릭 시 `MainPage`로 이동하며 `style`을 전달한다.
- 삭제 버튼 클릭 시 화면 목록과 저장소에서 모두 제거한다.

## 12. 로딩, 빈 화면, 에러 화면

비동기 상태는 `loading`, `data`, `empty`, `error`를 구분한다.

### Loading

사용 위치:

- Firebase 추천 목록 조회
- 즐겨찾기 파일 읽기
- 카메라/TFLite 초기화

UI 규칙:

- 기본 로딩은 중앙 `CircularProgressIndicator`를 사용한다.
- 색상은 `primary`를 사용한다.
- 카메라 프리뷰 초기화 중에는 프리뷰 영역 중앙에 표시한다.
- 로딩 중 임의의 안내 문구를 추가하지 않는다.

### Empty

사용 위치:

- 추천 목록 조회 결과가 비어 있음
- 즐겨찾기 목록이 비어 있음
- 히스토리 목록이 비어 있음

UI 규칙:

- 빈 화면은 `textSecondary` 색상의 짧은 문구와 선택적으로 아이콘을 사용한다.
- 원본 Android에 명시된 빈 목록 메시지는 즐겨찾기 삭제 시 `"즐겨찾기한 항목이 없습니다 !"` Toast이다.
- 화면 상시 빈 상태 문구는 기능을 추가로 설명하지 않는다.
- 빈 상태에서도 기존 화면 이동 버튼은 유지한다.

권장 문구:

| 화면 | 문구 |
| --- | --- |
| 추천 목록 | `표시할 상품이 없습니다.` |
| 즐겨찾기 | `즐겨찾기한 항목이 없습니다.` |
| 히스토리 | `최근 인식한 스타일이 없습니다.` |

### Error

사용 위치:

- Firebase 조회 실패
- 즐겨찾기 JSON 읽기/파싱 실패
- 카메라 권한 거부 또는 카메라 초기화 실패
- 외부 링크 실행 실패

UI 규칙:

- 에러는 `error` 색상 아이콘 또는 제목으로 표시한다.
- 재시도 버튼은 해당 기능에 실제 재시도 동작이 구현된 경우에만 표시한다.
- 원본 Android에서 로그만 남기던 오류를 사용자에게 표시할지 여부는 구현 작업 시 정책을 남긴다.
- 권한 오류는 OS 권한 요청 흐름을 우선 사용하고, 화면 안에서는 짧은 안내만 표시한다.

원본 유지 메시지:

- `"가구를 선택해주세요!"`
- `"이미 존재하는 아이템입니다."`
- `"즐겨찾기한 항목이 없습니다 !"`
- `"Camera permission is required for this demo"`
- `"Failed"`

Flutter에서는 Toast 대신 `SnackBar`를 사용할 수 있다. 단, 문구와 발생 조건은 기존 계약을 우선 유지한다.

## 13. 화면별 UI 규칙

### InitialPage

구성:

- 앱 이름 `My Home\n Catalog`
- 즐겨찾기 이동 버튼
- `맞춤 가구 둘러보기` 버튼
- `바로 시작` 버튼

규칙:

- 앱 이름은 `display` 스타일을 사용한다.
- 주요 진입 버튼은 하단 또는 중앙 하단에 세로로 배치한다.
- `바로 시작`은 `MainPage`로 이동하고 기본값 `style=all`, `type=all`을 사용한다.
- 즐겨찾기 이동은 기존 Android와 동일하게 별도 버튼으로 제공한다.

### CustomPage

구성:

- 제목 `맞춤 가구 둘러보기`
- 서브타이틀 `가구 선택`
- 가구 타입 2열 그리드
- `다음` 버튼

규칙:

- 선택 전/후 상태가 명확해야 한다.
- `다음` 버튼은 화면 하단에 배치하되 `SafeArea`를 고려한다.
- 선택 없이 다음을 누르면 `"가구를 선택해주세요!"` 메시지를 표시한다.

### CameraPage

구성:

- 카메라 프리뷰
- 최근 스타일 히스토리 가로 목록
- `촬영하기` 버튼

규칙:

- 카메라 프리뷰는 화면의 핵심 영역으로 가장 크게 배치한다.
- 히스토리와 촬영 버튼은 프리뷰를 과도하게 가리지 않도록 하단에 배치한다.
- confidence `0.9` 이상 결과만 인식 스타일로 사용한다.
- 인식 스타일이 없으면 `촬영하기`를 눌러도 추천 화면으로 이동하지 않는다.

### MainPage

구성:

- 스타일별 제목
- 스타일 필터
- 가구 타입 필터
- 추천 상품 목록
- 하단 이동 버튼

규칙:

- 기본 제목은 `모든 스타일`이다.
- 스타일 필터 변경 시 가구 타입 필터는 `All`로 초기화한다.
- 추천 목록 아이템 클릭 시 `DetailPage`로 이동한다.
- 하단 이동 버튼은 맞춤 화면, 초기 화면, 즐겨찾기 화면으로만 이동한다.

### DetailPage

구성:

- 상품 이미지
- 저장 버튼
- `제품명`
- 상품명
- `가격`
- 가격
- `구매하기` 버튼

규칙:

- 상품 정보는 Intent extra에 대응하는 `image`, `name`, `price`, `link`만 표시한다.
- `구매하기`는 외부 앱으로 링크를 연다.
- 저장 여부는 `Name` 기준 중복 체크 결과와 연결한다.

### FavoritesPage

구성:

- 제목 `즐겨찾기`
- 삭제 버튼
- 즐겨찾기 목록
- 아이템별 `선택` 버튼

규칙:

- 저장된 `savedItem.json`의 항목만 표시한다.
- 아이템 클릭 시 `DetailPage`로 이동한다.
- `선택` 버튼은 삭제 대상 position을 지정한다.
- 삭제 버튼 클릭 시 선택 대상이 없거나 목록이 비어 있으면 `"즐겨찾기한 항목이 없습니다 !"` 메시지를 표시한다.

## 14. Android/iOS 공통 UI 고려사항

공통 규칙:

- `SafeArea`를 사용해 노치, 홈 인디케이터, 상태바 영역을 침범하지 않는다.
- 터치 영역은 최소 `48 x 48`을 유지한다.
- Android와 iOS 모두 Material 기반 화면 구조를 사용한다.
- 플랫폼별로 기능이 달라지지 않도록 한다.
- 시스템 뒤로가기와 iOS back gesture에서 기존 Android 화면 흐름과 충돌하지 않도록 라우팅 정책을 정한다.

권한:

- 카메라 권한 요청은 Android/iOS 모두 명시적으로 처리한다.
- 권한 거부 시 카메라 프리뷰 대신 권한 상태 화면을 표시한다.
- 권한 안내 문구는 기존 문구 `"Camera permission is required for this demo"`를 우선 유지하되, iOS 설정 이동 등 OS별 처리가 필요하면 별도 구현 기록을 남긴다.

외부 링크:

- Android의 `Intent.ACTION_VIEW`에 해당하는 동작은 Flutter에서 외부 브라우저/외부 앱 열기로 구현한다.
- 앱 내부 WebView를 추가하지 않는다.
- 링크 실행 실패 시 사용자에게 짧은 오류 메시지를 표시한다.

이미지:

- 네트워크 이미지는 비율을 유지해 표시한다.
- 로딩, 실패, 빈 URL 상태를 구분한다.
- iOS에서도 이미지가 카드 radius 밖으로 넘치지 않도록 clip 처리한다.

## 15. 접근성 및 사용성

- 아이콘 버튼에는 `tooltip` 또는 `Semantics(label: ...)`를 제공한다.
- 텍스트 크기는 시스템 접근성 설정에서 잘리지 않도록 최대 2줄 또는 flexible layout을 사용한다.
- 상품명, 가격, 버튼 텍스트가 작은 화면에서 겹치지 않도록 `Expanded`, `Flexible`, `Wrap`을 사용한다.
- 색상만으로 상태를 전달하지 않는다. 선택 상태는 배경, border, 텍스트 굵기를 함께 사용한다.
- 카메라 화면의 하단 컨트롤은 프리뷰와 충분한 대비를 확보한다.

## 16. Flutter 구현 참고 규칙

ThemeData 권장 방향:

```dart
ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
)
```

공통 위젯 후보:

- `PrimaryButton`
- `SecondaryButton`
- `SelectableFilterChip`
- `FurnitureTypeTile`
- `ItemCard`
- `FavoriteItemCard`
- `AppEmptyState`
- `AppErrorState`
- `AppLoading`

공통 위젯 작성 규칙:

- 비즈니스 로직을 포함하지 않는다.
- Firebase path, JSON key, 저장소 접근 코드를 포함하지 않는다.
- 선택 상태와 callback은 외부에서 주입받는다.
- 동일한 컴포넌트가 두 개 이상의 feature에서 사용될 때만 `core/widgets/`로 이동한다.

## 17. AI 화면 생성 체크리스트

화면 생성 전:

- [ ] 구현하려는 화면이 `feature-spec.md`에 존재하는가?
- [ ] 화면에서 사용하는 데이터 필드가 기존 계약에 존재하는가?
- [ ] 신규 버튼, 신규 필터, 신규 화면을 추가하지 않았는가?
- [ ] 색상과 간격을 토큰으로 사용했는가?
- [ ] Android 원본의 이동 흐름을 유지했는가?

화면 생성 후:

- [ ] loading, empty, error 상태가 분리되어 있는가?
- [ ] 선택 상태가 색상 외의 방식으로도 구분되는가?
- [ ] 상품명과 가격이 작은 화면에서 잘리지 않거나 겹치지 않는가?
- [ ] Android/iOS safe area를 고려했는가?
- [ ] 외부 링크, 카메라 권한, 즐겨찾기 중복 등 기존 예외 조건을 유지했는가?
