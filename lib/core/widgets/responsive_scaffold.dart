import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'app_nav.dart';
import 'app_layout.dart';
import 'floating_bottom_nav.dart';
import 'landscape_nav.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;

  const ResponsiveScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return AppNav.indexForLocation(location);
  }

  void _onTap(BuildContext context, int index) {
    final location = GoRouterState.of(context).uri.toString();
    if (AppNav.indexForLocation(location) == index) return;
    context.go(AppNav.locationForIndex(index));
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.sizeOf(context).width >= kLandscapeBreakpoint;
    final currentIndex = _currentIndex(context);

    if (isLandscape) {
      return LandscapeNav(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        child: child,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: kFloatingNavGap,
            child: SafeArea(
              top: false,
              child: FloatingBottomNav(
                currentIndex: currentIndex,
                onTap: (i) => _onTap(context, i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
