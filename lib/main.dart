// ignore_for_file: unused_import, duplicate_import, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
//استوراد شاشة البداية
import 'secreens/welcome_screen.dart';
//قاعدة البيانات
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
//ملف الكود
import 'db/database_helper.dart';

class SaveAnswerPage extends StatelessWidget {
  final db = DatabaseHelper(); //كائن مسؤول على القاعده

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدخال إجابة')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            //ادخال سؤال واججابة
            await db.insertAnswer('كم مرة تستخدم السيارة؟', '3 مرات');
            //يجيب كل الاجابات
            final answers = await db.getAnswers();
            print(answers);//يطبعهم في الكونسول
          },
          child: Text('حفظ إجابة'),
        ),
      ),
    );
  }
}

void main() => runApp(const CarbonFootprintApp());

class CarbonFootprintApp extends StatelessWidget {
  const CarbonFootprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //عنوان التطبيق
      title: 'بصمتي الكربونية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF27301B),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      //اول شاشة تطلع
      home: const WelcomeScreen(),
      //تحديد لغة التطبيق
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
