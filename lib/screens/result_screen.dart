import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/mbti_provider.dart';

class ResultScreen extends StatelessWidget {
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
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // 결과 제목
                    Text(
                      '당신의 연애 캐릭터는',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white70,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // 캐릭터 카드
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(30),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 캐릭터 이모지
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Color(characterInfo['color']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Center(
                                child: Text(
                                  characterInfo['emoji'],
                                  style: TextStyle(fontSize: 60),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            // 캐릭터 이름
                            Text(
                              characterInfo['name'],
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // 캐릭터 설명
                            Text(
                              characterInfo['description'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF666666),
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            SizedBox(height: 20),
                            
                            // 캐릭터 대사
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(characterInfo['color']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Color(characterInfo['color']).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                '"${characterInfo['quote']}"',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(characterInfo['color']),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // 특성 태그들
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: characterInfo['traits']
                                  .map<Widget>((trait) => Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(characterInfo['color']).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Color(characterInfo['color']).withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          trait,
                                          style: TextStyle(
                                            color: Color(characterInfo['color']),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // 상세 정보
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow('매력 포인트', characterInfo['charm']),
                                  SizedBox(height: 10),
                                  _buildDetailRow('연애 스타일', characterInfo['loveStyle']),
                                  SizedBox(height: 10),
                                  _buildDetailRow('관심 표현', characterInfo['interest']),
                                  SizedBox(height: 10),
                                  _buildDetailRow('약점', characterInfo['weakness']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // 버튼들
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => context.go('/character-program'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(characterInfo['color']),
                                foregroundColor: Colors.white,
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
                        
                        SizedBox(width: 15),
                        
                        Expanded(
                          child: Container(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => context.go('/matching'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF667eea),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                '매칭 시작',
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
