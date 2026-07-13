# Feature Spec

## 1. 기능 개요

`My Home Catalog`는 인테리어 스타일과 가구 타입을 기준으로 물품을 추천하고, 사용자가 물품 상세 정보 확인, 구매 링크 이동, 즐겨찾기 저장을 할 수 있는 Android 앱이다.

코드에서 확인되는 기능은 다음과 같다.

- 초기 화면에서 메인 추천 목록, 맞춤 가구 선택, 즐겨찾기 화면으로 이동
- 전체 추천 목록 조회
- 스타일 필터와 가구 타입 필터를 이용한 추천 목록 조회
- 맞춤 가구 선택 후 카메라 화면으로 이동
- 카메라 프레임을 TensorFlow Lite 모델로 분류
- 분류 결과 스타일과 선택한 가구 타입으로 추천 목록 이동
- 최근 인식 스타일 히스토리 표시, 재탐색, 삭제
- 추천 목록 아이템 상세 정보 표시
- 상세 화면에서 구매 링크를 외부 앱으로 열기
- 상세 화면에서 즐겨찾기 저장
- 즐겨찾기 목록 조회 및 삭제

## 2. 사용자 플로우

### 기본 추천 목록 플로우

1. 앱 실행 시 `InitialActivity`가 열린다.
2. 사용자가 `"바로 시작"` 버튼을 누른다.
3. `MainActivity`가 열린다.
4. `MainActivity`는 기본값으로 `style=all`, `type=all`을 사용한다.
5. Firebase Realtime Database의 `all/{style}/{type}` 경로들을 조회한다.
6. 조회된 물품 목록을 `RecyclerView`에 표시한다.
7. 사용자가 물품을 누르면 `DetailActivity`가 열린다.
8. 상세 화면에서 물품 이미지, 이름, 가격을 표시한다.
9. 사용자가 `"구매하기"` 버튼을 누르면 `link`가 `Intent.ACTION_VIEW`로 열린다.

### 필터 기반 추천 목록 플로우

1. 사용자가 `MainActivity`에서 스타일 버튼을 누른다.
2. 선택된 스타일 버튼 배경과 텍스트 색상이 변경된다.
3. 스타일 변경 시 가구 타입은 `all`로 초기화된다.
4. 추천 목록 데이터가 비워진다.
5. 선택된 스타일과 `type=all` 기준으로 Firebase 데이터를 다시 조회한다.
6. 사용자가 가구 타입을 누르면 선택된 타입 배경이 변경된다.
7. 추천 목록 데이터가 비워진다.
8. 선택된 스타일과 타입 기준으로 Firebase 데이터를 다시 조회한다.

### 맞춤 가구 및 카메라 분류 플로우

1. 사용자가 `InitialActivity`에서 `"맞춤 가구 둘러보기"` 버튼을 누른다.
2. `CustomActivity`가 열린다.
3. 사용자가 가구 타입을 선택한다.
4. 선택한 타입이 `CustomActivity.furniture`에 저장된다.
5. 사용자가 `"다음"` 버튼을 누른다.
6. 선택된 타입이 Intent extra `type`으로 `ClassifierActivity`에 전달된다.
7. `ClassifierActivity`는 카메라 프리뷰를 열고 프레임을 TFLite 모델로 분류한다.
8. 최상위 분류 결과의 confidence가 `0.9` 이상이면 해당 라벨이 `recognitionStyle`에 저장된다.
9. 사용자가 `"촬영하기"` 버튼을 누른다.
10. `recognitionStyle`이 비어 있지 않으면 히스토리에 저장된다.
11. `MainActivity`가 열리고 Intent extra `style`, `type`이 전달된다.
12. `MainActivity`가 전달받은 스타일과 타입으로 Firebase 추천 목록을 조회한다.

### 히스토리 재탐색 플로우

1. `CameraActivity`가 SharedPreferences `"file"`의 모든 값을 읽는다.
2. 읽은 스타일 문자열을 `rv_history` 가로 목록에 표시한다.
3. 사용자가 히스토리 아이템을 누른다.
4. `MainActivity`가 열린다.
5. 히스토리 아이템의 스타일이 Intent extra `style`로 전달된다.
6. 현재 `CustomActivity.furniture` 값이 Intent extra `type`으로 전달된다.
7. 사용자가 히스토리 아이템의 삭제 버튼을 누르면 화면 목록에서 제거되고 SharedPreferences에서도 해당 스타일 key가 제거된다.

### 즐겨찾기 플로우

1. 추천 목록 또는 즐겨찾기 목록에서 물품을 누른다.
2. `DetailActivity`가 열린다.
3. 상세 화면은 `image`, `name`, `price`, `link` extra를 표시한다.
4. 사용자가 저장 버튼을 누른다.
5. `savedItem.json`에 해당 물품이 JSON 배열 요소로 저장된다.
6. 사용자가 초기 화면 또는 메인 화면에서 즐겨찾기 화면으로 이동한다.
7. `FavoritesActivity`가 `savedItem.json`을 읽어 목록을 표시한다.
8. 사용자가 즐겨찾기 아이템의 `"선택"` 버튼을 누르면 삭제 대상 position이 저장된다.
9. 사용자가 상단 삭제 버튼을 누르면 선택된 position의 항목이 파일과 화면 목록에서 제거된다.

## 3. 화면별 기능 명세

### `InitialActivity`

- 레이아웃: `app/src/main/res/layout/activity_initial.xml`
- 화면 텍스트:
  - `"My Home\n Catalog"`
  - `"맞춤 가구 둘러보기"`
  - `"바로 시작"`
- 기능:
  - `btn_favorites`: `FavoritesActivity` 실행
  - `btn_start`: `MainActivity` 실행
  - `btn_custom`: `CustomActivity` 실행
- 입력:
  - 버튼 클릭
- 출력:
  - Activity 전환

### `CustomActivity`

- 레이아웃: `app/src/main/res/layout/activity_custom.xml`
- 화면 텍스트:
  - `"맞춤 가구 둘러보기"`
  - `"가구 선택"`
  - `"다음"`
- 표시 데이터:
  - `all`
  - `chair`
  - `bed`
  - `sofa`
  - `dresser`
  - `table`
- 기능:
  - 2열 `RecyclerView`로 가구 타입 표시
  - 선택된 가구 타입 아이템 배경 변경
  - `"다음"` 클릭 시 `ClassifierActivity` 실행
  - `ClassifierActivity`에 Intent extra `type` 전달
- 입력:
  - 가구 타입 선택
  - `"다음"` 버튼 클릭
- 출력:
  - 선택된 `type`
  - Activity 전환
- 예외/분기:
  - 가구 타입이 선택되지 않은 상태에서 `"다음"` 클릭 시 `"가구를 선택해주세요!"` Toast 표시

### `ClassifierActivity` / `CameraActivity`

- Activity 레이아웃: `app/src/main/res/layout/tfe_ic_activity_camera.xml`
- Fragment 레이아웃: `app/src/main/res/layout/tfe_ic_camera_connection_fragment.xml`
- 화면 텍스트:
  - `"촬영하기"`
- 기능:
  - 카메라 권한 확인 및 요청
  - 카메라 프리뷰 표시
  - 기기 조건에 따라 Camera2 또는 Legacy Camera 프리뷰 사용
  - 카메라 프레임을 RGB 데이터로 변환
  - 백그라운드 `HandlerThread("inference")`에서 TFLite 분류 실행
  - TFLite 모델 `model.tflite`와 라벨 `labels.txt` 사용
  - confidence `0.9` 이상인 최상위 라벨을 인식 스타일로 저장
  - 최근 인식 스타일 히스토리 표시
  - `"촬영하기"` 클릭 시 인식 스타일과 가구 타입을 `MainActivity`로 전달
- 입력:
  - Intent extra `type`
  - 카메라 프레임
  - `"촬영하기"` 버튼 클릭
  - 히스토리 아이템 클릭
  - 히스토리 삭제 버튼 클릭
- 출력:
  - Intent extra `style`
  - Intent extra `type`
  - SharedPreferences 히스토리 저장/삭제
- 분류 라벨:
  - `zen`
  - `natural`
  - `modern`
  - `industrial`
  - `classic`
- 예외/분기:
  - 카메라 권한이 없으면 권한 요청
  - 권한 설명이 필요한 경우 `"Camera permission is required for this demo"` Toast 표시 후 권한 요청
  - 권한 요청 결과가 승인되면 카메라 Fragment 설정
  - 권한 요청 결과가 거부되면 다시 권한 요청
  - 인식 스타일이 비어 있으면 `"촬영하기"`를 눌러도 `MainActivity`로 이동하지 않음
  - confidence가 `0.9` 미만이면 `recognitionStyle`을 갱신하지 않음
  - 처리 중인 프레임이 있으면 추가 프레임은 처리하지 않음
  - Camera2 이미지가 없거나 프리뷰 크기가 준비되지 않았으면 프레임 처리를 중단

### `MainActivity`

- 레이아웃: `app/src/main/res/layout/activity_main.xml`
- 기본 제목:
  - `"모든 스타일"`
- 스타일 필터:
  - `"전체"`: `all`
  - `"내추럴"`: `natural`
  - `"모던"`: `modern`
  - `"클래식"`: `classic`
  - `"젠"`: `zen`
  - `"인더스트리얼"`: `industrial`
- 가구 타입 필터:
  - `"All"`: `all`
  - `"Chair"`: `chair`
  - `"Bed"`: `bed`
  - `"Sofa"`: `sofa`
  - `"Dresser"`: `dresser`
  - `"Table"`: `table`
- 기능:
  - Intent extra `style`이 없으면 `all` 사용
  - Intent extra `type`이 없으면 `all` 사용
  - 스타일별 제목 변경
  - 스타일 필터 선택 시 가구 타입을 `all`로 초기화
  - 스타일/타입 선택 상태를 배경 리소스로 표시
  - Firebase Realtime Database에서 추천 목록 조회
  - 추천 목록을 세로 `RecyclerView`로 표시
  - 물품 이미지는 Glide로 로드
  - 물품 클릭 시 `DetailActivity` 실행
  - 하단 버튼으로 `CustomActivity`, `InitialActivity`, `FavoritesActivity` 이동
  - 뒤로가기 시 `InitialActivity` 실행
- 입력:
  - Intent extra `style`
  - Intent extra `type`
  - 스타일 버튼 클릭
  - 타입 버튼 클릭
  - 추천 목록 아이템 클릭
  - 하단 이동 버튼 클릭
- 출력:
  - Firebase 조회 결과 `ItemData` 목록
  - `DetailActivity`로 Intent extra `image`, `name`, `price`, `link` 전달
- 예외/분기:
  - Firebase 조회 취소 시 `Log.e("MainActivity", error.toException())` 기록

### `DetailActivity`

- 레이아웃: `app/src/main/res/layout/activity_detail.xml`
- 화면 텍스트:
  - `"제품명"`
  - `"가격"`
  - `"구매하기"`
- 기능:
  - Intent extra로 받은 이미지, 이름, 가격 표시
  - Glide로 이미지 로드
  - 즐겨찾기 저장 여부 확인
  - 이미 저장된 항목이면 저장 버튼 배경을 `ic_save_fill`로 변경
  - 저장 버튼 클릭 시 현재 물품을 `savedItem.json`에 저장
  - `"구매하기"` 클릭 시 `link`를 외부 앱으로 열기
- 입력:
  - Intent extra `image`
  - Intent extra `name`
  - Intent extra `price`
  - Intent extra `link`
  - 저장 버튼 클릭
  - `"구매하기"` 버튼 클릭
- 출력:
  - 화면 표시 값
  - 로컬 JSON 파일 저장
  - `Intent.ACTION_VIEW` 실행
- 예외/분기:
  - `Name` 기준으로 이미 저장된 물품이면 `"이미 존재하는 아이템입니다."` Toast 표시
  - JSON 객체 생성 중 `JSONException` 발생 시 `Log.e("TAG", "Error: ...")` 기록

### `FavoritesActivity`

- 레이아웃: `app/src/main/res/layout/activity_favorites.xml`
- 화면 텍스트:
  - `"즐겨찾기"`
  - 즐겨찾기 아이템 버튼 `"선택"`
- 기능:
  - `savedItem.json` 읽기
  - JSON 배열을 `ItemData` 목록으로 변환
  - 즐겨찾기 목록을 세로 `RecyclerView`로 표시
  - 물품 이미지는 Glide로 로드
  - 즐겨찾기 아이템 클릭 시 `DetailActivity` 실행
  - 즐겨찾기 아이템의 `"선택"` 버튼 클릭 시 삭제 대상 position 저장
  - 상단 삭제 버튼 클릭 시 선택된 항목 삭제
- 입력:
  - 로컬 파일 `savedItem.json`
  - 즐겨찾기 아이템 클릭
  - `"선택"` 버튼 클릭
  - 삭제 버튼 클릭
- 출력:
  - 즐겨찾기 `ItemData` 목록
  - `DetailActivity`로 Intent extra `image`, `name`, `price`, `link` 전달
  - 삭제 후 갱신된 `savedItem.json`
- 예외/분기:
  - JSON 파싱 중 `JSONException` 발생 시 `Log.e("TAG", "Error in Comparing: ...")` 기록
  - 즐겨찾기 목록이 비어 있거나 삭제 대상이 선택되지 않은 상태에서 삭제 버튼 클릭 시 `"즐겨찾기한 항목이 없습니다 !"` Toast 표시

## 4. 데이터 입력/출력

### Activity Intent 데이터

| 출발 | 도착 | Key | Value |
| --- | --- | --- | --- |
| `CustomActivity` | `ClassifierActivity` | `type` | 선택된 가구 타입 문자열 |
| `CameraActivity` | `MainActivity` | `style` | TFLite 인식 스타일 라벨 |
| `CameraActivity` | `MainActivity` | `type` | `ClassifierActivity`가 받은 가구 타입 문자열 |
| `HistoryAdapter` | `MainActivity` | `style` | 히스토리 아이템의 스타일 문자열 |
| `HistoryAdapter` | `MainActivity` | `type` | `CustomActivity.furniture` 값 |
| `ItemAdapter` | `DetailActivity` | `image` | `ItemData.image` |
| `ItemAdapter` | `DetailActivity` | `name` | `ItemData.name` |
| `ItemAdapter` | `DetailActivity` | `price` | `ItemData.price` |
| `ItemAdapter` | `DetailActivity` | `link` | `ItemData.link` |
| `FavoritesAdapter` | `DetailActivity` | `image` | `ItemData.image` |
| `FavoritesAdapter` | `DetailActivity` | `name` | `ItemData.name` |
| `FavoritesAdapter` | `DetailActivity` | `price` | `ItemData.price` |
| `FavoritesAdapter` | `DetailActivity` | `link` | `ItemData.link` |

### 추천 물품 데이터

`ItemData` 필드:

- `image`
- `name`
- `price`
- `link`

사용 위치:

- Firebase `DataSnapshot`에서 `ItemData.class`로 변환
- 추천 목록 표시
- 즐겨찾기 목록 표시
- 상세 화면 표시
- 구매 링크 실행

### 맞춤 가구 데이터

`CustomData` 필드:

- `iv_icon`
- `tv_name`

`CustomActivity`에서 생성되는 값:

- `R.drawable.ic_furnitures`, `all`
- `R.drawable.ic_chair`, `chair`
- `R.drawable.ic_bed`, `bed`
- `R.drawable.ic_sofa`, `sofa`
- `R.drawable.ic_dresser`, `dresser`
- `R.drawable.ic_table`, `table`

### TFLite 입력/출력

입력:

- 카메라 프레임 Bitmap
- 센서 회전값

처리:

- 프레임을 정사각형 crop/pad
- 모델 입력 크기로 resize
- 회전 보정
- quantized MobileNet classifier 사용

출력:

- confidence 내림차순 상위 3개 `Classifier.Recognition`
- 최상위 결과 confidence가 `0.9` 이상일 때 `recognitionStyle` 저장

## 5. 예외 처리

코드에서 확인되는 예외 처리와 분기만 정리한다.

### 사용자에게 표시되는 Toast

- 가구 미선택 상태에서 `CustomActivity`의 `"다음"` 클릭:
  - `"가구를 선택해주세요!"`
- 상세 화면에서 이미 즐겨찾기에 존재하는 아이템 저장:
  - `"이미 존재하는 아이템입니다."`
- 즐겨찾기 목록이 비어 있거나 삭제 대상이 선택되지 않은 상태에서 삭제:
  - `"즐겨찾기한 항목이 없습니다 !"`
- 카메라 권한 설명 필요 시:
  - `"Camera permission is required for this demo"`
- Camera2 캡처 세션 설정 실패 시:
  - `"Failed"`

### 로그로만 처리되는 예외

- `MyJson.checkData()` JSON 파싱 오류:
  - `Log.e("TAG", "Error in Loading: ...")`
- `MyJson.saveData()` JSON 비교 오류:
  - `Log.e("TAG", "Error in Comparing: ...")`
- `MyJson.saveData()` 파일 쓰기 오류:
  - `Log.e("TAG", "Error in Writing: ...")`
- `MyJson.getData()` 파일 읽기 오류:
  - `Log.e("TAG", "Error in Reading: ...")`
- `MyJson.deleteData()` JSON 삭제 처리 오류:
  - `Log.e("TAG", "Error in Deleting: ...")`
- `DetailActivity.saveItem()` JSON 객체 생성 오류:
  - `Log.e("TAG", "Error: ...")`
- `FavoritesActivity` JSON 파싱 오류:
  - `Log.e("TAG", "Error in Comparing: ...")`
- `MainActivity` Firebase 조회 취소:
  - `Log.e("MainActivity", error.toException())`
- 카메라 프레임 처리, 카메라 접근, 스레드 종료, classifier 생성 오류:
  - `Logger.e(...)`로 기록

### 조용히 중단되는 분기

- `CameraActivity.goMain()`에서 `recognitionStyle`이 비어 있으면 추천 화면으로 이동하지 않는다.
- `CameraActivity.onPreviewFrame()`에서 이미 처리 중인 프레임이 있으면 새 프레임을 버린다.
- `CameraActivity.onImageAvailable()`에서 프리뷰 크기가 준비되지 않았거나 이미지가 없으면 처리를 중단한다.
- `CameraActivity.onImageAvailable()`에서 이미 처리 중인 프레임이 있으면 이미지를 닫고 처리를 중단한다.
- `ClassifierActivity.onPreviewSizeChosen()`에서 classifier 생성 실패로 `classifier == null`이면 이후 초기화를 중단한다.
- `ClassifierActivity.onInferenceConfigurationChanged()`에서 `rgbFrameBitmap == null`이면 classifier 재생성을 미룬다.
- `MyJson.getData()`에서 `savedItem.json` 파일이 없으면 `null`을 반환한다.
- `MyJson.checkData()`에서 기존 저장 데이터가 없으면 `false`를 반환한다.

## 6. Firebase 사용 기능

### 사용 라이브러리 및 설정

- 앱 모듈에 `com.google.gms.google-services` 플러그인 적용
- `com.google.firebase:firebase-database:20.0.2` 사용
- `com.google.firebase:firebase-analytics` 의존성 선언
- `app/google-services.json`에 Android package name `com.myhomecatalog` 설정

### Realtime Database 사용 위치

Firebase Realtime Database는 `MainActivity`에서 추천 목록 조회에 사용된다.

```java
database = FirebaseDatabase.getInstance();
databaseReference = database.getReference("all");
```

### 조회 경로

기본 참조:

```text
all
```

실제 조회 경로:

```text
all/{style}/{type}
```

스타일 값:

- `natural`
- `modern`
- `classic`
- `industrial`
- `zen`

타입 값:

- `bed`
- `chair`
- `dresser`
- `sofa`
- `table`

`style=all`이면 모든 스타일을 순회한다. `type=all`이면 모든 타입을 순회한다.

### Firebase 출력 데이터

각 leaf 경로의 child snapshot은 다음 모델로 변환된다.

```java
ItemData itemData = postSnapshot.getValue(ItemData.class);
```

따라서 앱에서 사용하는 출력 필드는 다음과 같다.

- `image`
- `name`
- `price`
- `link`

### Analytics

`com.google.firebase:firebase-analytics` 의존성은 선언되어 있다. 현재 코드에서 Analytics 이벤트 기록 API를 직접 호출하는 기능은 확인되지 않는다.

## 7. 로컬 저장 기능

### 즐겨찾기 저장 파일

- 담당 클래스: `MyJson`
- 파일명: `savedItem.json`
- 저장 위치: `context.getFilesDir()`
- 저장 형식: JSON 배열

저장되는 JSON object key:

- `Image`
- `Name`
- `Price`
- `Link`

기능:

- `checkData(Context, String name)`: `Name` 기준으로 저장 여부 확인
- `saveData(Context, JSONObject)`: 새 즐겨찾기 저장
- `getData(Context)`: 파일 내용 읽기
- `deleteData(Context, int position)`: position 기준 삭제 후 파일 재작성

중복 처리:

- `saveData()`는 저장 전 `Name` 기준으로 기존 항목을 확인한다.
- 같은 `Name`이 있으면 JSON 배열에 추가하지 않는다.

사용 위치:

- `DetailActivity`: 즐겨찾기 여부 확인 및 저장
- `FavoritesActivity`: 즐겨찾기 목록 조회 및 삭제

### 스타일 히스토리 SharedPreferences

- 사용 클래스: `CameraActivity`, `HistoryAdapter`
- SharedPreferences 이름: `"file"`
- 저장 key: 인식 스타일 문자열
- 저장 value: 인식 스타일 문자열

기능:

- `CameraActivity.saveStyle()`:
  - 기존 key가 있으면 제거
  - 이후 `putString(recognitionStyle, recognitionStyle)`로 저장
- `CameraActivity.onCreate()`:
  - `mPreferences.getAll()`로 모든 히스토리 값을 읽어 목록 구성
- `HistoryAdapter.removeAt()`:
  - 화면 목록에서 히스토리 삭제
  - SharedPreferences에서 해당 style key 삭제

히스토리에 저장될 수 있는 스타일 값은 TFLite 라벨 파일 기준 다음과 같다.

- `zen`
- `natural`
- `modern`
- `industrial`
- `classic`
