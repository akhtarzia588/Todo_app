import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..forward();

  late final Animation<double> _scale = Tween(begin: 0.5, end: 1.0).animate(
    CurvedAnimation(
        parent: _c, curve: const Interval(0, 0.55, curve: Curves.easeOutBack)),
  );
  late final Animation<double> _fadeLogo = CurvedAnimation(
      parent: _c, curve: const Interval(0, 0.4, curve: Curves.easeOut));
  late final Animation<double> _fadeText = CurvedAnimation(
      parent: _c, curve: const Interval(0.5, 0.85, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.1,
            colors: [Color(0xFF241A4D), AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              FadeTransition(
                opacity: _fadeLogo,
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.violet.withValues(alpha: 0.5),
                          blurRadius: 50,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const AppLogo(size: 130),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FadeTransition(
                opacity: _fadeText,
                child: const Column(
                  children: [
                    Text('MY TODO',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 8,
                          color: Colors.white,
                        )),
                    SizedBox(height: 10),
                    Text('Organise. Focus. Achieve.',
                        style: TextStyle(
                            color: AppColors.dim,
                            letterSpacing: 1.5,
                            fontSize: 13)),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 0, 90, 40),
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (_, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _c.value,
                      minHeight: 3,
                      backgroundColor: AppColors.border,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.gold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
