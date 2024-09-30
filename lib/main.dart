import 'package:assfiex_app_it14/components/bottom_nav.dart';
import 'package:assfiex_app_it14/firebase_options.dart';
import 'package:assfiex_app_it14/pages/employees_pages/employee_fill.dart';
import 'package:assfiex_app_it14/pages/employees_pages/employees_page.dart';
import 'package:assfiex_app_it14/pages/requestpages/all_request.dart';
import 'package:assfiex_app_it14/pages/requestpages/request_page.dart';
import 'package:assfiex_app_it14/pages/Time_Avail_page.dart';
import 'package:assfiex_app_it14/pages/auth_page.dart';
import 'package:assfiex_app_it14/pages/createschedpages/create_sched_page.dart';
import 'package:assfiex_app_it14/pages/menu_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        routes: {
          //routes in all pages
          '/menupage': (context) => const MenuPage(),
          '/createschedpage': (context) => CreateSchedPage(),
          '/timeavailpage': (context) => const TimeAvailPage(),
          '/requestpage': (context) => const RequestPage(),
          '/employeepage': (context) => const EmployeesPage(),
          '/try': (context) => const BottomNav(),
          '/allrequest': (context) => const AllRequest(),
          '/addemployee': (context) => const EmployeeFill()
        });
  }
}
