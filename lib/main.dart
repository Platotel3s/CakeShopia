import 'package:flutter/material.dart';
import 'package:shofy_management/app_color.dart';
import 'pages/home_screen.dart';
 
 void main() {
   runApp(const MyApp());
 }

 class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp( 
       title: 'ShofyManagement',
       theme: ThemeData(
         primaryColor: AppColor.primaryColor,
         visualDensity: VisualDensity.adaptivePlatformDensity,
         fontFamily: 'Poppins',
       ),
       home: HomeScreen(),
       debugShowCheckedModeBanner: false,
     );
   }
 }
