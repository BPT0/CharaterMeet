# 💕 CharacterMeet - Flutter 소개팅앱

MBTI 기반 소개팅앱을 Flutter로 구현한 모바일 애플리케이션입니다.

## 🚀 주요 기능

### 1. MBTI 설문조사
- 간단한 5개 질문으로 빠른 성격 분석
- 실시간 진행률 표시
- 직관적인 모바일 UI/UX

### 2. 연애 캐릭터 시스템
- 8가지 MBTI 유형별 연애 캐릭터
- 각 캐릭터의 성격 특성과 설명
- 시각적으로 매력적인 캐릭터 카드

### 3. 캐릭터 프로그램 (NEW!)
- **연애 팁**: MBTI별 맞춤 연애 조언
- **데이트 아이디어**: 성격에 맞는 데이트 추천
- **성장 가이드**: 개인 성장을 위한 맞춤 가이드

### 4. 매칭 시스템
- 호환성 기반 매칭 알고리즘
- 상위 3명의 매칭 결과 제공
- 호환성 점수 표시

## 🛠️ 기술 스택

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Navigation**: GoRouter
- **Local Storage**: SharedPreferences
- **Animation**: Lottie (선택사항)

## 📁 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── providers/
│   └── mbti_provider.dart       # MBTI 상태 관리
└── screens/
    ├── home_screen.dart         # 메인 화면
    ├── survey_screen.dart       # MBTI 설문조사
    ├── result_screen.dart       # 결과 화면
    ├── character_program_screen.dart  # 캐릭터 프로그램
    └── matching_screen.dart      # 매칭 화면
```

## 🎯 2인 4시간 개발 전략

### 역할 분담
- **개발자 A**: UI/UX 디자인 + MBTI 설문조사 구현
- **개발자 B**: 캐릭터 프로그램 + 매칭 알고리즘 + 데이터 관리

### 시간 배분
1. **1시간**: Flutter 프로젝트 설정 + 기본 UI 구조
2. **1.5시간**: MBTI 설문조사 + 캐릭터 시스템
3. **1시간**: 캐릭터 프로그램 + 매칭 알고리즘
4. **0.5시간**: 모바일 빌드 + 최종 통합

## 🚀 실행 방법

### 개발 환경 설정
```bash
# Flutter 설치 확인
flutter doctor

# 의존성 설치
flutter pub get

# 개발 서버 실행
flutter run
```

### 모바일 빌드

#### Android
```bash
# APK 빌드
flutter build apk --release

# AAB 빌드 (Google Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# iOS 빌드 (macOS 필요)
flutter build ios --release
```

## 📱 플랫폼 지원

- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **iOS**: iOS 11.0+
- ✅ **반응형 디자인**: 다양한 화면 크기 지원

## 🎨 UI/UX 특징

- **Material Design**: Android 네이티브 느낌
- **Cupertino Design**: iOS 네이티브 느낌
- **그라데이션 배경**: 시각적 매력
- **부드러운 애니메이션**: 사용자 경험 향상
- **터치 친화적**: 모바일 최적화

## 🔮 향후 개선 사항

1. **백엔드 연동**: Firebase 연동으로 실제 사용자 데이터 저장
2. **푸시 알림**: 매칭 알림 서비스
3. **실시간 채팅**: 매칭된 사용자 간 소통
4. **소셜 로그인**: Google, Apple 로그인
5. **AI 기반 추천**: 머신러닝 기반 개인화 매칭

## 📊 성능 최적화

- **이미지 최적화**: WebP 포맷 사용
- **코드 스플리팅**: 필요시에만 로드
- **메모리 관리**: 효율적인 상태 관리
- **배터리 최적화**: 백그라운드 작업 최소화

## 🎯 데모 시나리오

1. **사용자 여정**
   - 메인 화면 → MBTI 테스트 → 결과 확인 → 캐릭터 프로그램 → 매칭 시작

2. **핵심 가치 제안**
   - 빠른 성격 분석 (5분 이내)
   - 맞춤형 연애 가이드
   - 직관적인 매칭 시스템
   - 시각적으로 매력적인 결과

## 📈 확장 가능성

- **PWA 지원**: 웹에서도 앱처럼 사용
- **다국어 지원**: 글로벌 서비스
- **웨어러블 지원**: Apple Watch, Galaxy Watch
- **AR 기능**: 가상 데이트 체험

## 🤖 GPT Pro AI 도구 활용 방법

### 1. Flutter 코드 생성
```
프롬프트 예시:
"Flutter에서 MBTI 설문조사 UI를 모바일 친화적으로 구현해주세요"
"Provider를 사용한 상태 관리 코드를 생성해주세요"
```

### 2. 애니메이션 최적화
```
프롬프트 예시:
"Flutter 애니메이션 성능을 최적화하는 방법을 제안해주세요"
"Lottie 애니메이션을 Flutter에 통합하는 방법을 알려주세요"
```

### 3. 플랫폼별 최적화
```
프롬프트 예시:
"Android와 iOS에서 각각 최적화된 UI를 구현해주세요"
"Flutter 앱의 빌드 크기를 줄이는 방법을 제안해주세요"
```

---

**개발 시간**: 2인 4시간  
**기술 스택**: Flutter/Dart  
**목표**: 모바일 최적화 프로토타입 개발 및 데모