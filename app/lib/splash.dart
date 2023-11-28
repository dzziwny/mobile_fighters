import 'package:bubble_fight/home.dart';
import 'package:flutter/material.dart';

import 'config.dart';
import 'initialize_instances.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      initializeInstances(),
      if (forceSomeTimeOnSplash) Future.delayed(const Duration(seconds: 3)),
    ]).then(
      (value) => WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const Home()),
            (_) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        color: const Color(0xff82adbe),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 233.0,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16.0,
                  width: 16.0,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                    strokeWidth: 2.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                  'Loading...',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
