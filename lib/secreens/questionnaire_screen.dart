// ignore_for_file: deprecated_member_use, prefer_final_fields, override_on_non_overriding_member

import 'package:flutter/material.dart';
import '../widgets/animated_star_field.dart';
import '../widgets/glass_card_container.dart';
import '../models/question.dart';
import 'results_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  final PageController _pageController = PageController();
  Map<String, String?> _answers = {};

  final List<Question> _questions = [
    Question(
      id: 'q1',
      text: 'كم مرة تتناول اللحوم أو منتجات الألبان؟',
      options: [
        'أبدًا (نباتي صرف)',
        'نادراً (نباتي)',
        'بضع مرات في الأسبوع',
        'يوميًا',
      ],
    ),
    Question(
      id: 'q2',
      text: 'ما هو وسيلة التنقل الأساسية الخاصة بك؟',
      options: [
        'المشي أو ركوب الدراجة',
        'وسائل النقل العام',
        'سيارة كهربائية',
        'سيارة هجينة',
        
      ],
    ),
    Question(
      id: 'q3',
      text: 'كم عدد الأشخاص في منزلك؟',
      options: [
        'شخص واحد',
        'شخصان',
        '3 - 4 أشخاص',
        '5 - 6 أشخاص',
        
      ],
    ),
    Question(
      id: 'q4',
      text: 'كم مرة تشتري ملابس جديدة؟',
      options: [
        'نادراً (عند الحاجة فقط)',
        'بضع مرات في السنة',
        'شهريًا',
        'كل بضعة أسابيع',
        
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double calculateFootprint(Map<String, String?> answers) {
    answers = answers.map((key, value) => MapEntry(key, value ?? ''));
    double footprint = 0.0;

    switch (answers['q1']) {
      case 'أبدًا (نباتي صرف)':
        footprint += 1.5;
        break;
      case 'نادراً (نباتي)':
        footprint += 2.5;
        break;
      case 'بضع مرات في الأسبوع':
        footprint += 4.0;
        break;
      case 'يوميًا':
        footprint += 6.0;
        break;
      case 'عدة مرات في اليوم':
        footprint += 8.0;
        break;
      default:
        footprint += 4.0;
    }

    switch (answers['q2']) {
      case 'المشي أو ركوب الدراجة':
        footprint += 0.5;
        break;
      case 'وسائل النقل العام':
        footprint += 2.0;
        break;
      case 'سيارة كهربائية':
        footprint += 3.0;
        break;
      case 'سيارة هجينة':
        footprint += 4.5;
        break;
      case 'سيارة تعمل بالبنزين':
        footprint += 7.0;
        break;
      default:
        footprint += 3.5;
    }

    switch (answers['q3']) {
      case 'شخص واحد':
        footprint += 3.0;
        break;
      case 'شخصان':
        footprint += 2.5;
        break;
      case '3 - 4 أشخاص':
        footprint += 2.0;
        break;
      case '5 - 6 أشخاص':
        footprint += 1.8;
        break;
      case 'أكثر من 6 أشخاص':
        footprint += 1.5;
        break;
      default:
        footprint += 2.0;
    }

    switch (answers['q4']) {
      case 'نادراً (عند الحاجة فقط)':
        footprint += 0.5;
        break;
      case 'بضع مرات في السنة':
        footprint += 1.0;
        break;
      case 'شهريًا':
        footprint += 2.0;
        break;
      case 'كل بضعة أسابيع':
        footprint += 3.0;
        break;
      case 'أسبوعيًا أو أكثر':
        footprint += 4.0;
        break;
      default:
        footprint += 1.5;
    }

    return double.parse(footprint.toStringAsFixed(1));
  }

  void _answerQuestion(String questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        final calculatedFootprint = calculateFootprint(_answers);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ResultsScreen(
              answers: _answers,
              calculatedFootprint: calculatedFootprint,
            ),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.75;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            const AnimatedStarField(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.teal.withOpacity(0.1),
                    Colors.greenAccent.withOpacity(0.2),
                  ],
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: GlassCardContainer(
                    height: cardHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: LinearProgressIndicator(
                            value:
                                (_currentQuestionIndex + 1) / _questions.length,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: Colors.tealAccent,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(
                          height: cardHeight - 100,
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            itemCount: _questions.length,
                            itemBuilder: (context, index) {
                              final question = _questions[index];
                              return _buildQuestionPage(question);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPage(Question question) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.quiz,
            size: 40,
            color: Colors.tealAccent,
          ),
          const SizedBox(height: 15),
          Text(
            'السؤال ${_currentQuestionIndex + 1} من ${_questions.length}',
            style: const TextStyle(
              color: Colors.tealAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: question.options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(question.id, option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.tealAccent.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
