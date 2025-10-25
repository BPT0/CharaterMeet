import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MBTIProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  
  MBTIProvider(this._prefs);
  
  // 설문조사 데이터
  List<String> _answers = [];
  String? _userMBTI;
  bool _isSurveyCompleted = false;
  
  // Getters
  List<String> get answers => _answers;
  String? get userMBTI => _userMBTI;
  bool get isSurveyCompleted => _isSurveyCompleted;
  
  // 설문조사 질문 데이터
  static const List<Map<String, dynamic>> surveyQuestions = [
    {
      'question': '새로운 사람들과 만나는 파티에서 나는?',
      'options': [
        {'text': '적극적으로 많은 사람들과 대화한다', 'type': 'E'},
        {'text': '친한 몇 명과 깊은 대화를 나눈다', 'type': 'I'},
      ]
    },
    {
      'question': '데이트 계획을 세울 때 나는?',
      'options': [
        {'text': '즉흥적이고 새로운 장소를 선호한다', 'type': 'P'},
        {'text': '미리 계획하고 체계적으로 준비한다', 'type': 'J'},
      ]
    },
    {
      'question': '연인과 갈등이 생겼을 때 나는?',
      'options': [
        {'text': '논리적으로 문제를 분석하고 해결한다', 'type': 'T'},
        {'text': '상대방의 감정을 먼저 이해하려고 한다', 'type': 'F'},
      ]
    },
    {
      'question': '이상적인 데이트는?',
      'options': [
        {'text': '박물관이나 전시회 같은 문화 활동', 'type': 'N'},
        {'text': '영화관이나 카페 같은 편안한 장소', 'type': 'S'},
      ]
    },
    {
      'question': '연애에서 가장 중요한 것은?',
      'options': [
        {'text': '서로의 꿈과 목표를 공유하는 것', 'type': 'N'},
        {'text': '일상의 작은 행복을 나누는 것', 'type': 'S'},
      ]
    }
  ];
  
  // MBTI 캐릭터 데이터 - 6명 캐릭터 완전 업데이트
  static const Map<String, Map<String, dynamic>> characterData = {
    // 여자 캐릭터 3명
    'ENFP': {
      'name': '유나',
      'nickname': '불꽃 사교러',
      'emoji': '🔥',
      'description': '밝고 누구와도 금방 친해진다. 분위기 살림꾼! 감정 교류를 중시하고 작은 설렘도 귀하게 느끼는 활기찬 사람입니다.',
      'traits': ['활기찬', '외향적', '감정적', '사교적'],
      'color': 0xFFFF6B6B,
      'gender': 'female',
      'charm': '밝고 누구와도 금방 친해진다. 분위기 살림.',
      'loveStyle': '감정 교류 중시, 작은 설렘도 귀하게 느낀다.',
      'interest': '상대에게 적극적으로 질문한다.',
      'weakness': '감정 과몰입, 선택장애',
      'keyword': '활기찬·외향적·계획보다 감정',
      'quote': '딱 얘기해보면 vibe가 느껴지죠!',
      'age': 24,
      'height': '165cm',
      'job': '마케터',
      'hobby': ['카페 투어', '새로운 사람 만나기', 'SNS 활동'],
    },
    'ISTJ': {
      'name': '채린',
      'nickname': '기준 확실러',
      'emoji': '📋',
      'description': '안정적이고 깔끔한 태도로 일관성을 보여주는 사람. 천천히 알아가되 한번 열리면 깊은 관계를 만듭니다.',
      'traits': ['책임감', '안정적', '일관성', '신뢰할 수 있는'],
      'color': 0xFF4ECDC4,
      'gender': 'female',
      'charm': '안정적, 깔끔한 태도, 일관성.',
      'loveStyle': '천천히 알아가되 한번 열리면 깊다.',
      'interest': '잘 챙기지만 티는 덜 난다.',
      'weakness': '감정 표현 서툼',
      'keyword': '책임감·냉정해보이지만 속은 따뜻',
      'quote': '급하게 만나고 급하게 식는 건 못해요.',
      'age': 26,
      'height': '162cm',
      'job': '회계사',
      'hobby': ['독서', '요리', '정리정돈'],
    },
    'INFJ': {
      'name': '세아',
      'nickname': '존재감 은은러',
      'emoji': '🌙',
      'description': '깊은 공감과 감성 대화로 묘하게 끌리는 사람. 상대 마음의 결을 맞춰주며 잔잔한 배려를 보여줍니다.',
      'traits': ['감성적', '공감능력', '배려심', '깊이있는'],
      'color': 0xFF9B59B6,
      'gender': 'female',
      'charm': '깊은 공감, 감성 대화. 묘하게 끌림.',
      'loveStyle': '상대 마음의 결을 맞춘다.',
      'interest': '생각에 오래 머문 뒤 천천히 다가감.',
      'weakness': '혼자 고민하다 서운해짐',
      'keyword': '감정선·잔잔한 배려·무드 메이커',
      'quote': '그 사람만의 이야기가 있어요… 나는 그게 궁금해.',
      'age': 25,
      'height': '168cm',
      'job': '상담사',
      'hobby': ['일기 쓰기', '영화 감상', '산책'],
    },
    // 남자 캐릭터 3명
    'ENTJ': {
      'name': '현우',
      'nickname': '리드하는 전략러',
      'emoji': '🎯',
      'description': '계획적이고 주도적인 추진력을 가진 사람. 목표 설정부터 실행까지 밀당 없이 직진하는 카리스마 있는 리더입니다.',
      'traits': ['카리스마', '리더십', '야망', '추진력'],
      'color': 0xFF2ECC71,
      'gender': 'male',
      'charm': '계획적, 주도적, 추진력.',
      'loveStyle': '목표 설정 → 실행. 밀당 패스.',
      'interest': '데이트를 먼저 제안한다.',
      'weakness': '직설적, 상처 줄 수 있음',
      'keyword': '카리스마·리드·야망',
      'quote': '좋으면 표현해야죠. 바로 움직여 봅시다.',
      'age': 28,
      'height': '180cm',
      'job': '스타트업 CEO',
      'hobby': ['헬스', '독서', '네트워킹'],
    },
    'ISFP': {
      'name': '지훈',
      'nickname': '잔잔감성 아티스트',
      'emoji': '🎨',
      'description': '조용하지만 분위기 좋은 사람. 감각과 분위기, 사소한 취향 교류를 중시하며 음악과 영화를 통해 마음을 나눕니다.',
      'traits': ['감성적', '예술적', '힐링', '조용한'],
      'color': 0xFFFF9F43,
      'gender': 'male',
      'charm': '조용하지만 분위기 좋은 사람.',
      'loveStyle': '감각·분위기·사소한 취향 교류 중시.',
      'interest': '음악·영화 공유.',
      'weakness': '결정 미룸',
      'keyword': '감성·예술·힐링',
      'quote': '같이 별 보러 갈래요?',
      'age': 27,
      'height': '175cm',
      'job': '음악 프로듀서',
      'hobby': ['음악 감상', '영화 보기', '카페에서 작업'],
    },
    'ESTP': {
      'name': '도윤',
      'nickname': '스릴러 프리 다이버',
      'emoji': '🏄‍♂️',
      'description': '즉흥적이고 재미있는 데이트를 선호하는 사람. 대화 케미와 유머로 공격하며 놀리며 다가가는 스릴러입니다.',
      'traits': ['에너지', '유머', '즉흥적', '스릴러'],
      'color': 0xFFE74C3C,
      'gender': 'male',
      'charm': '즉흥적→재미있는 데이트.',
      'loveStyle': '대화 케미, 유머로 공격.',
      'interest': '놀리며 다가감.',
      'weakness': '깊은 관계에 진입할 때 고민 길어짐',
      'keyword': '에너지·스킨십 타이밍·유머',
      'quote': '어? 방금 설렜죠? 솔직히 말해봐요.',
      'age': 26,
      'height': '178cm',
      'job': '이벤트 기획자',
      'hobby': ['서핑', '클럽', '새로운 액티비티'],
    }
  };
  
  // 답변 추가
  void addAnswer(String answer) {
    _answers.add(answer);
    notifyListeners();
  }
  
  // MBTI 계산
  void calculateMBTI() {
    if (_answers.length < 5) return;
    
    final counts = <String, int>{
      'E': 0, 'I': 0, 'S': 0, 'N': 0, 
      'T': 0, 'F': 0, 'J': 0, 'P': 0
    };
    
    for (String answer in _answers) {
      counts[answer] = (counts[answer] ?? 0) + 1;
    }
    
    _userMBTI = 
        (counts['E']! >= counts['I']! ? 'E' : 'I') +
        (counts['S']! >= counts['N']! ? 'S' : 'N') +
        (counts['T']! >= counts['F']! ? 'T' : 'F') +
        (counts['J']! >= counts['P']! ? 'J' : 'P');
    
    _isSurveyCompleted = true;
    
    // 로컬 저장소에 저장
    _prefs.setString('userMBTI', _userMBTI!);
    _prefs.setBool('isSurveyCompleted', true);
    
    notifyListeners();
  }
  
  // 설문조사 초기화
  void resetSurvey() {
    _answers.clear();
    _userMBTI = null;
    _isSurveyCompleted = false;
    _prefs.remove('userMBTI');
    _prefs.setBool('isSurveyCompleted', false);
    notifyListeners();
  }
  
  // 저장된 데이터 로드
  void loadSavedData() {
    _userMBTI = _prefs.getString('userMBTI');
    _isSurveyCompleted = _prefs.getBool('isSurveyCompleted') ?? false;
    notifyListeners();
  }
  
  // 캐릭터 정보 가져오기
  Map<String, dynamic>? getCharacterInfo(String mbti) {
    return characterData[mbti];
  }
  
  // 매칭 결과 생성
  List<Map<String, dynamic>> generateMatches() {
    if (_userMBTI == null) return [];
    
    final matches = <Map<String, dynamic>>[];
    final allMBTIs = characterData.keys.toList();
    
    for (String mbti in allMBTIs) {
      if (mbti != _userMBTI) {
        final character = characterData[mbti]!;
        final score = _calculateCompatibility(_userMBTI!, mbti);
        
        matches.add({
          'mbti': mbti,
          'name': character['name'],
          'emoji': character['emoji'],
          'description': character['description'],
          'score': score,
          'color': character['color'],
        });
      }
    }
    
    matches.sort((a, b) => b['score'].compareTo(a['score']));
    return matches.take(3).toList();
  }
  
  // 호환성 계산
  int _calculateCompatibility(String mbti1, String mbti2) {
    int score = 50;
    
    for (int i = 0; i < 4; i++) {
      if (mbti1[i] == mbti2[i]) {
        score += 10;
      }
    }
    
    score += (DateTime.now().millisecondsSinceEpoch % 20);
    return score > 95 ? 95 : score;
  }
}
