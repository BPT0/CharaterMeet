import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/mbti_provider.dart';

class CharacterProgramScreen extends StatefulWidget {
  @override
  _CharacterProgramScreenState createState() => _CharacterProgramScreenState();
}

class _CharacterProgramScreenState extends State<CharacterProgramScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _currentProgram = 0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<MBTIProvider>(
      builder: (context, mbtiProvider, child) {
        final userMBTI = mbtiProvider.userMBTI;
        if (userMBTI == null) {
          return Scaffold(
            body: Center(
              child: Text('MBTI 결과를 찾을 수 없습니다.'),
            ),
          );
        }
        
        final characterInfo = mbtiProvider.getCharacterInfo(userMBTI);
        if (characterInfo == null) {
          return Scaffold(
            body: Center(
              child: Text('캐릭터 정보를 찾을 수 없습니다.'),
            ),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: Text('캐릭터 프로그램'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go('/result'),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 캐릭터 헤더
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Color(characterInfo['color']).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      characterInfo['emoji'],
                                      style: TextStyle(fontSize: 50),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  characterInfo['name'],
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // 프로그램 탭
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(0, '연애 팁', Icons.favorite),
                        _buildTabButton(1, '데이트 아이디어', Icons.event),
                        _buildTabButton(2, '성장 가이드', Icons.trending_up),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // 프로그램 콘텐츠
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _buildProgramContent(userMBTI, _currentProgram),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTabButton(int index, String title, IconData icon) {
    final isSelected = _currentProgram == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentProgram = index;
          });
          _animationController.reset();
          _animationController.forward();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Color(0xFF667eea) : Colors.white70,
                size: 20,
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Color(0xFF667eea) : Colors.white70,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProgramContent(String mbti, int program) {
    switch (program) {
      case 0:
        return _buildLoveTips(mbti);
      case 1:
        return _buildDateIdeas(mbti);
      case 2:
        return _buildGrowthGuide(mbti);
      default:
        return Container();
    }
  }
  
  Widget _buildLoveTips(String mbti) {
    final tips = _getLoveTips(mbti);
    return Container(
      key: ValueKey('tips'),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _fadeAnimation.value) * 50),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFF667eea).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            Icons.lightbulb,
                            color: Color(0xFF667eea),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            tips[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF333333),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  Widget _buildDateIdeas(String mbti) {
    final ideas = _getDateIdeas(mbti);
    return Container(
      key: ValueKey('ideas'),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: ideas.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _fadeAnimation.value) * 50),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Color(0xFF667eea),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              ideas[index]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          ideas[index]['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  Widget _buildGrowthGuide(String mbti) {
    final guides = _getGrowthGuides(mbti);
    return Container(
      key: ValueKey('guides'),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: guides.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _fadeAnimation.value) * 50),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Color(0xFF667eea),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              guides[index]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          guides[index]['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  List<String> _getLoveTips(String mbti) {
    final tipsMap = {
      'ENFP': [
        '상대방에게 적극적으로 질문하며 관심을 표현하세요',
        '감정 교류를 중시하니 상대방의 마음을 잘 들어주세요',
        '작은 설렘도 귀하게 느끼니 일상의 소소한 순간들을 소중히 여기세요',
        '선택장애가 있으니 중요한 결정은 충분히 고민한 후 하세요'
      ],
      'ISTJ': [
        '천천히 알아가되 한번 열리면 깊은 관계를 만들어가세요',
        '잘 챙기되 티를 덜 내며 자연스럽게 배려하세요',
        '감정 표현이 서툴러도 행동으로 보여주세요',
        '급하게 만나고 급하게 식는 건 피하고 꾸준히 관계를 쌓아가세요'
      ],
      'INFJ': [
        '상대 마음의 결을 맞춰주며 깊이 있는 대화를 나누세요',
        '생각에 오래 머문 뒤 천천히 다가가되 서운해하지 마세요',
        '잔잔한 배려로 무드 메이커 역할을 하세요',
        '상대방만의 이야기에 진심으로 관심을 가져주세요'
      ],
      'ENTJ': [
        '목표 설정부터 실행까지 밀당 없이 직진하세요',
        '데이트를 먼저 제안하며 주도적으로 이끌어가세요',
        '직설적이되 상대방의 마음을 배려하는 표현을 사용하세요',
        '카리스마와 리더십을 연애에서도 발휘하되 상대방의 의견도 존중하세요'
      ],
      'ISFP': [
        '감각과 분위기를 중시하니 아름다운 장소를 선택하세요',
        '음악과 영화를 통해 마음을 나누세요',
        '조용하지만 분위기 좋은 사람의 매력을 살리세요',
        '결정을 미루지 말고 솔직한 마음을 표현하세요'
      ],
      'ESTP': [
        '즉흥적이고 재미있는 데이트로 상대방을 놀라게 하세요',
        '대화 케미와 유머로 자연스럽게 다가가세요',
        '놀리며 다가가되 상대방의 반응을 잘 살피세요',
        '깊은 관계로 진입할 때는 충분히 고민한 후 결정하세요'
      ]
    };
    
    return tipsMap[mbti] ?? [
      '상대방을 진심으로 사랑하고 배려하세요',
      '서로의 차이점을 존중하고 이해하려고 노력하세요',
      '소통을 통해 갈등을 해결하고 관계를 발전시키세요',
      '함께 성장하고 꿈을 이루어가세요'
    ];
  }
  
  List<Map<String, String>> _getDateIdeas(String mbti) {
    final ideasMap = {
      'ENFP': [
        {'title': '즉흥 여행', 'description': '당일치기로 가까운 도시나 관광지를 탐방하며 새로운 경험을 함께 나누세요'},
        {'title': '문화 체험', 'description': '전시회, 공연, 박물관 등 다양한 문화 활동을 통해 서로의 취향을 알아가세요'},
        {'title': '야외 활동', 'description': '등산, 캠핑, 해변가 산책 등 자연 속에서 자유롭게 시간을 보내세요'},
      ],
      'ISTJ': [
        {'title': '전통 데이트', 'description': '식당에서 정중한 식사 후 산책하며 전통적인 데이트를 즐기세요'},
        {'title': '계획된 여행', 'description': '미리 계획을 세워 체계적으로 여행을 준비하고 실행하세요'},
        {'title': '집에서 데이트', 'description': '집에서 요리하거나 영화를 보며 편안한 시간을 보내세요'},
      ],
      'INFJ': [
        {'title': '감성 카페', 'description': '조용하고 분위기 좋은 카페에서 깊이 있는 대화를 나누세요'},
        {'title': '자연 속 산책', 'description': '공원이나 강변에서 산책하며 마음을 나누세요'},
        {'title': '문화 공간', 'description': '갤러리, 도서관, 박물관 등 조용한 문화 공간에서 시간을 보내세요'},
      ],
      'ENTJ': [
        {'title': '전략 게임', 'description': '체스, 보드게임 등 두뇌 게임으로 재미있게 경쟁하세요'},
        {'title': '지적 대화', 'description': '카페에서 깊이 있는 주제로 대화하며 서로의 생각을 나누세요'},
        {'title': '목표 설정 데이트', 'description': '함께 미래 계획을 세우고 목표를 공유하는 시간을 가져보세요'},
      ],
      'ISFP': [
        {'title': '별 보기', 'description': '야외에서 별을 보며 감성적인 시간을 보내세요'},
        {'title': '음악 감상', 'description': '함께 좋아하는 음악을 듣고 감상을 나누세요'},
        {'title': '예술 체험', 'description': '갤러리, 공연장 등 예술적 공간에서 감성을 나누세요'},
      ],
      'ESTP': [
        {'title': '즉흥 데이트', 'description': '계획 없이 즉흥적으로 재미있는 장소를 찾아가세요'},
        {'title': '액티비티', 'description': '놀이공원, 스포츠, 레저 활동 등 활발한 활동을 함께하세요'},
        {'title': '파티 데이트', 'description': '친구들과 함께하는 파티나 모임에서 즐거운 시간을 보내세요'},
      ]
    };
    
    return ideasMap[mbti] ?? [
      {'title': '카페 데이트', 'description': '편안한 카페에서 대화하며 서로를 알아가세요'},
      {'title': '공원 산책', 'description': '자연 속에서 산책하며 마음을 나누세요'},
      {'title': '영화 관람', 'description': '함께 영화를 보고 이야기를 나누세요'},
    ];
  }
  
  List<Map<String, String>> _getGrowthGuides(String mbti) {
    final guidesMap = {
      'ENFP': [
        {'title': '집중력 향상', 'description': '하나의 프로젝트에 집중하는 연습을 통해 완성도를 높이세요'},
        {'title': '현실적 계획', 'description': '이상과 현실의 균형을 맞추는 계획 수립 능력을 기르세요'},
        {'title': '감정 관리', 'description': '감정의 기복을 인식하고 안정적으로 관리하는 방법을 배우세요'},
        {'title': '선택 능력', 'description': '선택장애를 극복하기 위해 작은 결정부터 연습하세요'},
      ],
      'ISTJ': [
        {'title': '유연성 개발', 'description': '고정된 관념에서 벗어나 새로운 관점을 받아들이는 유연성을 기르세요'},
        {'title': '창의적 사고', 'description': '전통적인 방식에서 벗어나 창의적인 해결책을 찾는 연습을 하세요'},
        {'title': '감정적 표현', 'description': '논리적 사고와 함께 감정을 표현하고 공감하는 능력을 기르세요'},
        {'title': '속도 조절', 'description': '급하게 진행하지 말고 천천히 관계를 쌓아가는 방법을 배우세요'},
      ],
      'INFJ': [
        {'title': '소통 능력', 'description': '생각을 오래 머물지 말고 적절한 타이밍에 표현하는 방법을 배우세요'},
        {'title': '자기 주장', 'description': '서운해하지 말고 자신의 의견을 명확히 표현하는 연습을 하세요'},
        {'title': '경계 설정', 'description': '상대방의 마음에만 맞추지 말고 자신의 경계를 설정하세요'},
        {'title': '현실적 접근', 'description': '이상적인 관계보다 현실적인 관계를 만드는 방법을 배우세요'},
      ],
      'ENTJ': [
        {'title': '감정 표현', 'description': '논리적 사고와 함께 감정을 표현하는 방법을 연습하세요'},
        {'title': '유연성 기르기', 'description': '계획에 변화가 생겼을 때 유연하게 대응하는 능력을 기르세요'},
        {'title': '소통 기술', 'description': '다른 사람들과의 소통에서 공감과 이해의 기술을 향상시키세요'},
        {'title': '상대방 존중', 'description': '리더십을 발휘하되 상대방의 의견도 존중하는 방법을 배우세요'},
      ],
      'ISFP': [
        {'title': '결정력 기르기', 'description': '결정을 미루지 말고 적절한 타이밍에 결정하는 능력을 기르세요'},
        {'title': '자신감 향상', 'description': '조용한 성격의 매력을 살리며 자신감을 키우세요'},
        {'title': '표현력 개발', 'description': '음악과 영화를 통한 감정 표현을 더욱 발전시키세요'},
        {'title': '목표 설정', 'description': '감성적 사고와 함께 구체적인 목표를 설정하는 방법을 배우세요'},
      ],
      'ESTP': [
        {'title': '깊이 있는 사고', 'description': '표면적인 즐거움을 넘어 깊이 있는 사고와 성찰을 연습하세요'},
        {'title': '장기 계획', 'description': '즉흥적인 성격과 함께 미래를 계획하는 능력을 기르세요'},
        {'title': '관계 깊이', 'description': '깊은 관계로 진입할 때 충분히 고민하는 방법을 배우세요'},
        {'title': '감정 인식', 'description': '유머와 재미만이 아닌 진정한 감정 교류의 중요성을 인식하세요'},
      ]
    };
    
    return guidesMap[mbti] ?? [
      {'title': '자기 이해', 'description': '자신의 강점과 약점을 객관적으로 파악하고 개선하세요'},
      {'title': '소통 능력', 'description': '다른 사람과의 효과적인 소통 방법을 배우고 실천하세요'},
      {'title': '성장 마인드', 'description': '지속적인 학습과 성장을 위한 마인드셋을 기르세요'},
    ];
  }
}
