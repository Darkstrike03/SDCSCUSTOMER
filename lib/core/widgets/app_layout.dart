import 'package:flutter/widgets.dart';

const double kLandscapeBreakpoint = 720;

bool isLandscape(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= kLandscapeBreakpoint;
}

/// Inherited flag injected by the landscape shell so descendant shell
/// screens can suppress their own AppBar (the global header replaces it).
class LandscapeShellScope extends InheritedWidget {
  const LandscapeShellScope({
    super.key,
    required this.isInLandscapeShell,
    required super.child,
  });

  final bool isInLandscapeShell;

  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<LandscapeShellScope>()
            ?.isInLandscapeShell ??
        false;
  }

  @override
  bool updateShouldNotify(LandscapeShellScope oldWidget) {
    return isInLandscapeShell != oldWidget.isInLandscapeShell;
  }
}
