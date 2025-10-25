import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/mbti_provider.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int _currentQuestion = 0;
  
  @override
  Widget build(BuildContext context) {
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
                // 진행률 바
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentQuestion + 1) / MBTIProvider.surveyQuestions.length,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 30),
                
                // 질문 카드
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
                        // 질문 텍스트
                        Text(
                          MBTIProvider.surveyQuestions[_currentQuestion]['question'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: 40),
                        
                        // 선택지들
                        ...MBTIProvider.surveyQuestions[_currentQuestion]['options']
                            .map<Widget>((option) => _buildOptionButton(option))
                            .toList(),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // 진행 상황
                Text(
                  '${_currentQuestion + 1} / ${MBTIProvider.surveyQuestions.length}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildOptionButton(Map<String, dynamic> option) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () => _selectOption(option['type']),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF8F9FA),
          foregroundColor: Color(0xFF333333),
          elevation: 2,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Color(0xFFE9ECEF)),
          ),
        ),
        child: Text(
          option['text'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
  void _selectOption(String type) {
    // 답변 저장
    Provider.of<MBTIProvider>(context, listen: false).addAnswer(type);
    
    // 다음 질문으로 이동
    if (_currentQuestion < MBTIProvider.surveyQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      // 설문조사 완료
      Provider.of<MBTIProvider>(context, listen: false).calculateMBTI();
      context.go('/result');
    }
  }
}
