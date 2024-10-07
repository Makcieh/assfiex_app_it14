import 'package:assfiex_app_it14/employee_side/pages/Time_Avail_page.dart';
import 'package:assfiex_app_it14/employee_side/pages/components/bottom_nav.dart';
import 'package:assfiex_app_it14/employee_side/pages/createschedpages/create_sched_page.dart';
import 'package:assfiex_app_it14/employee_side/pages/employees_pages/employees_page.dart';
import 'package:assfiex_app_it14/employee_side/pages/menu_page.dart';
import 'package:assfiex_app_it14/employee_side/pages/requestpages/all_request.dart';
import 'package:assfiex_app_it14/manager_side/components/bottom_nav.dart';
import 'package:assfiex_app_it14/manager_side/pages/TA_pages/Time_Avail_fill.dart';
import 'package:assfiex_app_it14/manager_side/pages/employees_pages/employee_fill.dart';
import 'package:assfiex_app_it14/manager_side/pages/employees_pages/employees_page.dart';
import 'package:assfiex_app_it14/manager_side/pages/requestpages/all_request.dart';
import 'package:assfiex_app_it14/manager_side/pages/requestpages/request_page.dart';
import 'package:assfiex_app_it14/manager_side/pages/TA_pages/Time_Avail_page.dart';
import 'package:assfiex_app_it14/manager_side/pages/auth_page.dart';
import 'package:assfiex_app_it14/manager_side/pages/createschedpages/create_sched_page.dart';
import 'package:assfiex_app_it14/manager_side/pages/menu_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

          //Manger Side Routes
          '/menupage': (context) => const MenuPage(),
          '/createschedpage': (context) => const CreateSchedPage(),
          '/timeavailpage': (context) => const TimeAvailPage(),
          '/requestpage': (context) => const RequestPage(),
          '/employeepage': (context) => const EmployeesPage(),
          '/try': (context) => const BottomNav(),
          '/allrequest': (context) => const AllRequest(),
          '/addemploye': (context) => const EmployeeFill(),
          '/addta': (context) => const TimeAvailFill(),

          //Employee Side Routes
          '/employee_menupage': (context) => const Employee_MenuPage(),
          '/employee_createschedpage': (context) =>
              const Employee_CreateSchedPage(),
          '/employee_timeavailpage': (context) =>
              const Employee_TimeAvailPage(),
          // '/employee_requestpage': (context) => const Employee_RequestPage(),
          '/employee_employeepage': (context) => const See_EmployeesPage(),
          '/employee_try': (context) => const Employee_BottomNav(),
          '/employee_allrequest': (context) => const Employee_AllRequest(),
          '/employee_addemploye': (context) => const See_EmployeesPage()
        });
  }
}
