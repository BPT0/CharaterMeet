import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/mbti_provider.dart';

class MatchingScreen extends StatefulWidget {
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
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
      begin: 0.5,
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
        final matches = mbtiProvider.generateMatches();
        
        return Scaffold(
          appBar: AppBar(
            title: Text('💘 매칭 결과'),
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
                  // 매칭 결과 헤더
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '당신과 잘 맞는 연애 캐릭터',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '호환성 기반 매칭 결과',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 매칭 결과 리스트
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0, 
                                (1 - _fadeAnimation.value) * (50 + index * 20)
                              ),
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: _buildMatchCard(matches[index], index),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  
                  // 하단 버튼
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => context.go('/'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white24,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                '다시 시작',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => context.go('/character-program'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF667eea),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                '캐릭터 프로그램',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
  
  Widget _buildMatchCard(Map<String, dynamic> match, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // 캐릭터 아바타
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(match['color']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                match['emoji'],
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          
          SizedBox(width: 20),
          
          // 캐릭터 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  match['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Color(0xFFE91E63),
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${match['score']}% 호환',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 호환성 점수
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getScoreColor(match['score']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getScoreColor(match['score']).withOpacity(0.3),
              ),
            ),
            child: Text(
              '${match['score']}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(match['score']),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getScoreColor(int score) {
    if (score >= 90) return Color(0xFF4CAF50);
    if (score >= 80) return Color(0xFF8BC34A);
    if (score >= 70) return Color(0xFFFFC107);
    if (score >= 60) return Color(0xFFFF9800);
    return Color(0xFFFF5722);
  }
}
