import 'package:flutter/material.dart';
import 'package:magic_tracker/core/constants.dart';
import 'package:provider/provider.dart';
import 'features/home/home_screen.dart';
import 'features/workout/workout_list_viewmodel.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutListViewModel()..loadWorkouts(),
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
