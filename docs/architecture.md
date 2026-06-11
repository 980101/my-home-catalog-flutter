# Architecture

## 프로젝트 목적

`My Home Catalog`는 카메라 이미지 분류 결과로 인테리어 스타일을 판별하고, 판별된 스타일과 사용자가 선택한 가구 타입에 맞는 물품 목록을 보여주는 Android 앱이다.

코드에서 확인되는 주요 기능은 다음과 같다.

- 초기 화면에서 메인 추천 목록, 맞춤 가구 선택, 즐겨찾기 화면으로 이동
- 맞춤 가구 화면에서 가구 타입 선택
- 카메라 프레임을 TensorFlow Lite 모델로 분류
- 분류된 스타일과 선택된 가구 타입을 기준으로 Firebase Realtime Database에서 추천 물품 조회
- 추천 물품 상세 화면 표시, 구매 링크를 외부 브라우저로 열기
- 상세 화면에서 물품을 로컬 JSON 파일에 즐겨찾기로 저장
- 즐겨찾기 화면에서 저장된 물품 목록 표시 및 삭제
- 카메라 화면에서 최근 인식 스타일 히스토리 표시 및 삭제

## 사용 기술 스택

### Android

- 단일 Android Application 모듈: `:app`
- 패키지명 및 namespace: `com.myhomecatalog`
- Java 기반 Android 코드
- `compileSdkVersion 30`
- `minSdkVersion 21`
- `targetSdkVersion 30`
- Java 8 compile options
- 메인 런처 Activity: `com.myhomecatalog.feature.custom.ui.InitialActivity`

### Gradle 및 플러그인

- Android Gradle Plugin: `com.android.tools.build:gradle:8.1.0`
- Google Services Gradle Plugin: `com.google.gms:google-services:4.4.0`
- 앱 모듈 플러그인:
  - `com.android.application`
  - `com.google.gms.google-services`

### 주요 라이브러리

- AndroidX AppCompat: `androidx.appcompat:appcompat:1.3.1`
- AndroidX CoordinatorLayout: `androidx.coordinatorlayout:coordinatorlayout:1.1.0`
- AndroidX ConstraintLayout: `androidx.constraintlayout:constraintlayout:2.1.1`
- AndroidX RecyclerView: `androidx.recyclerview:recyclerview:1.2.1`
- Material Components: `com.google.android.material:material:1.4.0`
- TensorFlow Lite:
  - `org.tensorflow:tensorflow-lite:2.4.0`
  - `org.tensorflow:tensorflow-lite-gpu:2.3.0`
  - `org.tensorflow:tensorflow-lite-support:0.1.0`
- Glide: `com.github.bumptech.glide:glide:4.16.0`
- Firebase:
  - `com.google.firebase:firebase-database:20.0.2`
  - `com.google.firebase:firebase-analytics`
  - Firebase BoM: `com.google.firebase:firebase-bom:28.4.2`

### Android 권한 및 하드웨어

`AndroidManifest.xml`에서 확인되는 권한과 기능은 다음과 같다.

- `android.permission.CAMERA`
- `android.hardware.camera`
- `android.hardware.camera.autofocus`

## 패키지 구조

```text
com.myhomecatalog
├── common
│   ├── util
│   │   ├── BorderedText.java
│   │   ├── ImageUtils.java
│   │   └── Logger.java
│   └── widget
│       ├── AutoFitTextureView.java
│       ├── OverlayView.java
│       ├── RecognitionScoreView.java
│       └── ResultsView.java
├── data
│   ├── local
│   │   └── MyJson.java
│   └── model
│       ├── CustomData.java
│       └── ItemData.java
└── feature
    ├── camera
    │   ├── tflite
    │   │   ├── Classifier.java
    │   │   ├── ClassifierFloatMobileNet.java
    │   │   └── ClassifierQuantizedMobileNet.java
    │   └── ui
    │       ├── CameraActivity.java
    │       ├── CameraConnectionFragment.java
    │       ├── ClassifierActivity.java
    │       └── LegacyCameraConnectionFragment.java
    ├── custom
    │   ├── adapter
    │   │   ├── CustomAdapter.java
    │   │   └── SpacesItemDecoration.java
    │   └── ui
    │       ├── CustomActivity.java
    │       └── InitialActivity.java
    ├── detail
    │   └── ui
    │       └── DetailActivity.java
    ├── favorites
    │   ├── adapter
    │   │   └── FavoritesAdapter.java
    │   └── ui
    │       └── FavoritesActivity.java
    └── home
        ├── adapter
        │   ├── HistoryAdapter.java
        │   ├── HistoryItemDecoration.java
        │   └── ItemAdapter.java
        └── ui
            └── MainActivity.java
```

### 각 패키지 역할

- `common.util`: 카메라/TFLite 처리에 사용되는 이미지 변환, 로그, 텍스트 렌더링 유틸리티
- `common.widget`: 카메라 프리뷰 및 분류 결과 표시용 커스텀 View
- `data.model`: 화면과 Firebase 데이터 매핑에 사용되는 단순 데이터 모델
- `data.local`: 즐겨찾기 JSON 파일 저장/조회/삭제 담당
- `feature.custom`: 초기 화면 및 맞춤 가구 타입 선택 화면
- `feature.camera`: 카메라 프리뷰, 권한 처리, TFLite 이미지 분류
- `feature.home`: 추천 목록 화면, Firebase 데이터 조회, 히스토리 아이템 어댑터
- `feature.detail`: 추천/즐겨찾기 아이템 상세 화면
- `feature.favorites`: 로컬 즐겨찾기 목록 화면

## 데이터 모델

### `ItemData`

추천 목록과 즐겨찾기 목록에서 공통으로 사용하는 물품 데이터 모델이다.

- `image`
- `name`
- `price`
- `link`

`MainActivity`에서는 Firebase `DataSnapshot`을 `ItemData.class`로 변환한다. `ItemAdapter`와 `FavoritesAdapter`는 이 값을 상세 화면 Intent extra로 전달한다.

### `CustomData`

맞춤 가구 선택 화면의 그리드 아이템 모델이다.

- `iv_icon`: drawable 리소스 ID
- `tv_name`: 가구 타입 문자열

`CustomActivity`에서 다음 타입을 생성한다.

- `all`
- `chair`
- `bed`
- `sofa`
- `dresser`
- `table`

### `Classifier.Recognition`

TFLite 분류 결과 모델이다.

- `id`
- `title`
- `confidence`
- `location`

`CameraActivity.showResultsInBottomSheet()`는 최상위 결과의 `confidence`가 `0.9` 이상이면 `title`을 인식된 스타일로 저장한다.

## 데이터 흐름

### 1. 초기 진입 및 화면 이동

`InitialActivity`가 런처 Activity이다.

- `btn_favorites` 클릭: `FavoritesActivity` 실행
- `btn_start` 클릭: `MainActivity` 실행
- `btn_custom` 클릭: `CustomActivity` 실행

### 2. 맞춤 가구 타입 선택 흐름

`CustomActivity`는 `RecyclerView`와 `CustomAdapter`로 가구 타입을 표시한다.

1. `CustomActivity`가 `CustomData` 목록을 생성한다.
2. `CustomAdapter`에서 사용자가 아이템을 선택하면 `CustomActivity.onItemSelected()`가 호출된다.
3. 선택된 아이템의 텍스트가 `CustomActivity.furniture`에 저장된다.
4. `goCamera()`가 `ClassifierActivity`를 실행하며 Intent extra `type`에 선택된 가구 타입을 넣는다.
5. 가구 타입이 선택되지 않은 경우 `"가구를 선택해주세요!"` Toast를 표시하고 카메라 화면으로 이동하지 않는다.

### 3. 카메라 분류 흐름

`ClassifierActivity`는 `CameraActivity`를 상속한다.

1. `CameraActivity.onCreate()`에서 카메라 권한을 확인한다.
2. 권한이 있으면 `setFragment()`로 카메라 프리뷰 Fragment를 설정한다.
3. 기기가 Camera2 full level 또는 외부 카메라 조건을 만족하면 `CameraConnectionFragment`를 사용한다.
4. 그 외에는 `LegacyCameraConnectionFragment`를 사용한다.
5. 카메라 프레임은 `CameraActivity.onImageAvailable()` 또는 `onPreviewFrame()`에서 RGB 데이터로 변환된다.
6. `ClassifierActivity.processImage()`가 `Classifier.recognizeImage()`를 백그라운드 HandlerThread에서 실행한다.
7. `Classifier.create()`는 현재 `ClassifierQuantizedMobileNet`을 생성한다.
8. 모델 파일은 `app/src/main/assets/model.tflite`, 라벨 파일은 `app/src/main/assets/labels.txt`를 사용한다.
9. `labels.txt`에서 확인되는 라벨은 `zen`, `natural`, `modern`, `industrial`, `classic`이다.
10. `CameraActivity.showResultsInBottomSheet()`는 상위 결과의 confidence가 `0.9` 이상일 때 `recognitionStyle`에 라벨명을 저장한다.

### 4. 카메라 화면에서 추천 목록으로 이동

`CameraActivity`의 `"촬영하기"` 버튼은 `goMain()`을 호출한다.

1. `recognitionStyle`이 비어 있지 않은 경우에만 이동한다.
2. `saveStyle()`로 인식된 스타일을 SharedPreferences에 저장한다.
3. `ClassifierActivity`를 실행할 때 받은 Intent extra `type`을 다시 읽는다.
4. `MainActivity`를 실행하며 Intent extra를 전달한다.
   - `style`: TFLite 인식 결과 라벨
   - `type`: 맞춤 가구 화면에서 선택한 타입

### 5. 추천 목록 데이터 조회 흐름

`MainActivity`는 Firebase Realtime Database에서 추천 물품을 조회한다.

1. Intent extra `style`이 있으면 해당 값을 사용하고, 없으면 `all`을 사용한다.
2. Intent extra `type`이 있으면 해당 값을 사용하고, 없으면 `all`을 사용한다.
3. `FirebaseDatabase.getInstance()`로 데이터베이스 인스턴스를 얻는다.
4. `database.getReference("all")`을 루트 참조로 사용한다.
5. `modifyList()`가 조회 대상 스타일 목록과 타입 목록을 만든다.
   - 스타일 `all`: `natural`, `modern`, `classic`, `industrial`, `zen` 전체 조회
   - 타입 `all`: `bed`, `chair`, `dresser`, `sofa`, `table` 전체 조회
   - 개별 값이면 해당 값 하나만 조회
6. `loadData()`가 `all/{style}/{type}` 경로마다 `addListenerForSingleValueEvent()`를 등록한다.
7. 각 `DataSnapshot`의 child를 `ItemData`로 변환해 `dataList`에 추가한다.
8. `ItemAdapter`가 `RecyclerView`에 물품 이미지, 이름, 가격을 표시한다.
9. 이미지는 Glide로 로드한다.

### 6. 추천/즐겨찾기 목록에서 상세 화면으로 이동

`ItemAdapter`와 `FavoritesAdapter`는 아이템 클릭 시 `DetailActivity`를 실행한다.

전달되는 Intent extra는 동일하다.

- `image`
- `name`
- `price`
- `link`

`DetailActivity`는 전달받은 값으로 이미지, 제품명, 가격을 표시한다.

### 7. 구매 링크 흐름

`DetailActivity.goToBuy()`는 `link` 값을 `Uri.parse()`로 변환하고 `Intent.ACTION_VIEW` Intent를 실행한다.

즉, 구매 링크는 앱 내부 WebView가 아니라 Android 외부 브라우저 또는 해당 URL을 처리할 수 있는 앱으로 열린다.

### 8. 즐겨찾기 저장 흐름

`DetailActivity.saveItem()`은 현재 상세 아이템을 JSON 객체로 만든다.

저장 필드는 다음과 같다.

- `Image`
- `Name`
- `Price`
- `Link`

`MyJson.saveData()`는 앱 내부 파일 디렉터리의 `savedItem.json`에 JSON 배열 형태로 저장한다. 저장 전 `Name` 값을 기준으로 중복 여부를 확인하며, 동일한 `Name`이 있으면 새로 추가하지 않는다.

### 9. 즐겨찾기 조회 및 삭제 흐름

`FavoritesActivity`는 `MyJson.getData()`로 `savedItem.json` 내용을 읽는다.

1. 파일 내용을 `JSONArray`로 변환한다.
2. 각 객체의 `Image`, `Name`, `Price`, `Link` 값을 읽는다.
3. `ItemData`로 변환해 `FavoritesAdapter`에 전달한다.
4. 즐겨찾기 아이템의 선택 버튼을 누르면 선택 위치가 `FavoritesActivity.selected`에 저장된다.
5. 상단 삭제 버튼은 `MyJson.deleteData()`를 호출해 해당 position을 제외한 새 JSON 배열을 `savedItem.json`에 다시 쓴다.

### 10. 스타일 히스토리 흐름

`CameraActivity`는 SharedPreferences 이름 `"file"`을 사용한다.

- `saveStyle()`은 key와 value 모두 `recognitionStyle`인 문자열을 저장한다.
- 이미 같은 key가 있으면 기존 값을 제거한 뒤 다시 저장한다.
- `CameraActivity.onCreate()`는 `mPreferences.getAll()`을 순회해 히스토리 목록을 만든다.
- 히스토리 목록은 `HistoryAdapter`와 가로 `RecyclerView`로 표시된다.
- 히스토리 아이템을 누르면 `MainActivity`로 이동하며 `style`과 `type` extra를 전달한다.
- 히스토리 삭제 버튼을 누르면 화면 목록에서 제거하고 SharedPreferences에서도 해당 style key를 제거한다.

## 주요 화면 구조

### `InitialActivity`

- 레이아웃: `app/src/main/res/layout/activity_initial.xml`
- 주요 UI:
  - 즐겨찾기 버튼: `btn_favorites`
  - 타이틀: `"My Home\n Catalog"`
  - 맞춤 가구 둘러보기 버튼: `btn_custom`
  - 바로 시작 버튼: `btn_start`
- 이동 대상:
  - `FavoritesActivity`
  - `MainActivity`
  - `CustomActivity`

### `CustomActivity`

- 레이아웃: `app/src/main/res/layout/activity_custom.xml`
- 주요 UI:
  - 타이틀: `"맞춤 가구 둘러보기"`
  - 서브타이틀: `"가구 선택"`
  - 가구 타입 RecyclerView: `rv_custom`
  - 다음 버튼: `btn_next`
- 표시 데이터:
  - `all`, `chair`, `bed`, `sofa`, `dresser`, `table`
- 다음 화면:
  - `ClassifierActivity`

### `ClassifierActivity` / `CameraActivity`

- Activity 레이아웃: `app/src/main/res/layout/tfe_ic_activity_camera.xml`
- 카메라 Fragment 레이아웃: `app/src/main/res/layout/tfe_ic_camera_connection_fragment.xml`
- 주요 UI:
  - 카메라 프리뷰 컨테이너: `container`
  - 히스토리 RecyclerView: `rv_history`
  - 촬영 버튼: `btn_capture`, 텍스트 `"촬영하기"`
- 주요 처리:
  - 카메라 권한 요청
  - Camera2 또는 Legacy Camera Fragment 선택
  - TFLite 분류 실행
  - confidence `0.9` 이상 결과를 스타일로 사용
  - 스타일 히스토리 저장

### `MainActivity`

- 레이아웃: `app/src/main/res/layout/activity_main.xml`
- 주요 UI:
  - 제목 TextView: `tv_title`
  - 스타일 필터 버튼:
    - `btn_style_all`
    - `btn_style_natural`
    - `btn_style_modern`
    - `btn_style_classic`
    - `btn_style_zen`
    - `btn_style_industrial`
  - 가구 타입 필터:
    - `type_all`
    - `type_chair`
    - `type_bed`
    - `type_sofa`
    - `type_dresser`
    - `type_table`
  - 추천 목록 RecyclerView: `list_furniture`
  - 하단 이동 버튼:
    - 맞춤 화면
    - 초기 화면
    - 즐겨찾기 화면
- 데이터:
  - Firebase Realtime Database `all/{style}/{type}` 경로 조회
  - `ItemData` 목록을 `ItemAdapter`에 연결

### `DetailActivity`

- 레이아웃: `app/src/main/res/layout/activity_detail.xml`
- 주요 UI:
  - 즐겨찾기 저장 버튼: `btn_detail`
  - 상품 이미지: `iv_detail`
  - 상품명: `tv_detail_name`
  - 가격: `tv_detail_price`
  - 구매하기 버튼: `btn_detail`, 텍스트 `"구매하기"`
- 데이터:
  - Intent extra `image`, `name`, `price`, `link`
- 동작:
  - Glide로 이미지 표시
  - 구매 링크를 `Intent.ACTION_VIEW`로 열기
  - 즐겨찾기를 `savedItem.json`에 저장

### `FavoritesActivity`

- 레이아웃: `app/src/main/res/layout/activity_favorites.xml`
- 주요 UI:
  - 삭제 버튼: `btn_favorites_delete`
  - 제목: `"즐겨찾기"`
  - 즐겨찾기 RecyclerView: `list_favorites`
- 데이터:
  - 앱 내부 파일 `savedItem.json`
  - `FavoritesAdapter`로 목록 표시
- 동작:
  - 아이템 클릭 시 `DetailActivity` 이동
  - 선택된 position 삭제

## 외부 서비스 연동 구조

### Firebase 설정

Firebase 연동은 다음 파일과 설정에서 확인된다.

- 루트 `build.gradle`
  - `com.google.gms:google-services:4.4.0`
- 앱 `build.gradle`
  - `apply plugin: 'com.google.gms.google-services'`
  - `com.google.firebase:firebase-database:20.0.2`
  - `com.google.firebase:firebase-analytics`
  - `com.google.firebase:firebase-bom:28.4.2`
- `app/google-services.json`
  - Android package name: `com.myhomecatalog`
  - Firebase project id: `house-server-34d68`

### Firebase Realtime Database 사용 위치

실제 데이터 조회 코드는 `MainActivity`에 있다.

```java
database = FirebaseDatabase.getInstance();
databaseReference = database.getReference("all");
```

조회 경로는 코드상 다음 구조이다.

```text
all/{style}/{type}
```

`style` 값은 코드와 라벨 파일에서 다음 값으로 확인된다.

- `natural`
- `modern`
- `classic`
- `industrial`
- `zen`

`type` 값은 코드에서 다음 값으로 확인된다.

- `bed`
- `chair`
- `dresser`
- `sofa`
- `table`

각 leaf 경로의 child snapshot은 `ItemData`로 변환되므로, Firebase 데이터 객체는 `ItemData`의 필드명과 매핑 가능한 구조여야 한다.

```text
image
name
price
link
```

### Firebase Analytics

`app/build.gradle`에 `com.google.firebase:firebase-analytics` 의존성이 선언되어 있다. 현재 Java 코드에서 Analytics API를 직접 호출하는 부분은 확인되지 않는다.

## 로컬 저장 구조

### 즐겨찾기 JSON 파일

- 담당 클래스: `data.local.MyJson`
- 파일명: `savedItem.json`
- 저장 위치: `context.getFilesDir()`
- 저장 형태: JSON 배열 문자열
- 저장 필드:
  - `Image`
  - `Name`
  - `Price`
  - `Link`
- 중복 체크 기준: `Name`

### 히스토리 SharedPreferences

- 사용 위치: `CameraActivity`, `HistoryAdapter`
- SharedPreferences 이름: `"file"`
- 저장 형태:
  - key: 인식 스타일 문자열
  - value: 인식 스타일 문자열
- 삭제:
  - 히스토리 아이템의 삭제 버튼에서 해당 style key 제거

## 앱 내부 화면 전환 요약

```text
InitialActivity
├── MainActivity
│   ├── DetailActivity
│   │   └── 외부 브라우저(Intent.ACTION_VIEW)
│   ├── CustomActivity
│   └── FavoritesActivity
├── CustomActivity
│   └── ClassifierActivity
│       └── MainActivity
└── FavoritesActivity
    └── DetailActivity
        └── 외부 브라우저(Intent.ACTION_VIEW)
```

## 주요 리소스

- TFLite 모델: `app/src/main/assets/model.tflite`
- TFLite 라벨: `app/src/main/assets/labels.txt`
- 화면 레이아웃:
  - `activity_initial.xml`
  - `activity_custom.xml`
  - `tfe_ic_activity_camera.xml`
  - `tfe_ic_camera_connection_fragment.xml`
  - `activity_main.xml`
  - `activity_detail.xml`
  - `activity_favorites.xml`
- RecyclerView 아이템 레이아웃:
  - `item_button.xml`
  - `item_furniture.xml`
  - `item_favorites.xml`
  - `item_history.xml`

# Flutter Migration Goal

목표

- Android Native → Flutter 전환
- Android/iOS 동시 지원
- 기존 기능 유지
- Provider 기반 상태관리 적용 예정
- Firebase 연동 구조 유지 검토