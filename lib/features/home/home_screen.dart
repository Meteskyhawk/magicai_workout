import 'package:flutter/material.dart';
import 'package:magic_tracker/features/workout/workout_list_viewmodel.dart';
import 'package:magic_tracker/features/workout/workout_list_screen.dart';
import 'package:provider/provider.dart';
import '../weekly_summary/weekly_summary_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/magicfit_logo.jpeg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Magic AI Workout!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildQuickAccessButtons(context),
                const SizedBox(height: 32),
                _buildWorkoutSummary(),
                const SizedBox(height: 32),
                _buildExerciseCategories(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context) {
    const SizedBox(height: 40);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickAccessButton(
          context: context,
          icon: Icons.calendar_today,
          label: 'PLANNING',
          onTap: () {},
          color: Colors.orange,
        ),
        _buildQuickAccessButton(
          context: context,
          icon: Icons.fitness_center,
          label: 'WORKOUTS',
          onTap: () async {
            await _showWorkoutAnimation(context);
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                  builder: (context) => const WorkoutListScreen()),
            );
          },
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    Key? key, // Accept the key parameter
  }) {
    return GestureDetector(
      key: key, // Assign the key to the GestureDetector
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showWorkoutAnimation(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/animations/dumbbell_pull.json',
              repeat: false,
              onLoaded: (composition) {
                Future.delayed(const Duration(milliseconds: 1200), () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkoutSummary() {
    return Consumer<WorkoutListViewModel>(
      builder: (context, viewModel, child) {
        final weeklyStats = viewModel.weeklyStats;
        return GestureDetector(
          onTap: () async {
            await _showWorkoutAnimation(context);
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WeeklySummaryScreen()),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Week',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem(
                        'Workouts', weeklyStats['workouts'].toString()),
                    _buildSummaryItem(
                        'Total Sets', weeklyStats['sets'].toString()),
                    _buildSummaryItem('Total Weight',
                        '${weeklyStats['weight'].toStringAsFixed(1)} kg'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildExerciseCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXERCISES',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildExerciseCategory('Arm', 'assets/arm.json'),
            _buildExerciseCategory('Abs', 'assets/abs.json'),
            _buildExerciseCategory('Legs', 'assets/leg.json'),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseCategory(String name, String asset) {
    bool isLottie = asset.endsWith('.json');
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: isLottie
              ? Lottie.asset(asset, fit: BoxFit.cover)
              : Image.asset(asset, fit: BoxFit.cover),
        ),
        const SizedBox(height: 8),
        Text(name),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center), label: 'Workouts'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.purple,
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutListScreen()),
          );
        }
      },
    );
  }
}
