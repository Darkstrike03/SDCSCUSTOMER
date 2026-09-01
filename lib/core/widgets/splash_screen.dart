import 'dart:async';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

const Duration kSplashLanguageInterval = Duration(seconds: 5);
const Duration kSplashTotalDuration = Duration(seconds: 20);
const Duration kSplashFadeDuration = Duration(milliseconds: 500);

const List<String> _languages = [
  'Sharmik Disha',
  'श्रमिक दिशा',
  'শ্রমিক দিশা',
  'శ్రమిక్ దిశ',
  'ಶ್ರಮಿಕ ದಿಶಾ',
  'श्रमिक दिशा',
];

class SplashGate extends StatefulWidget {
  final Widget child;

  const SplashGate({super.key, required this.child});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(kSplashTotalDuration, () {
      if (!mounted) return;
      setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        IgnorePointer(
          ignoring: !_visible,
          child: AnimatedOpacity(
            key: const ValueKey('splash-opacity'),
            opacity: _visible ? 1 : 0,
            duration: kSplashFadeDuration,
            curve: Curves.easeOut,
            child: SplashScreen(visible: _visible),
          ),
        ),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool visible;

  const SplashScreen({super.key, required this.visible});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.visible) _startRotation();
  }

  void _startRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(kSplashLanguageInterval, (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _languages.length);
    });
  }

  @override
  void didUpdateWidget(covariant SplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.visible && _timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _languages[_index];
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: kSplashFadeDuration,
                    child: Text(
                      current,
                      key: ValueKey('wordmark-$_index'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'YatraOne',
                        fontSize: 44,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.primary,
                    backgroundColor: AppColors.divider,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}