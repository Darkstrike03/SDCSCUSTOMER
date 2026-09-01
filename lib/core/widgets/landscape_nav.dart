import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_nav.dart';
import 'app_layout.dart';
import 'address_banner.dart';

class LandscapeNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget child;

  const LandscapeNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.child,
  });

  @override
  State<LandscapeNav> createState() => _LandscapeNavState();
}

class _LandscapeNavState extends State<LandscapeNav> {
  late int _selectedIndex;
  bool _railExtended = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant LandscapeNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _selectedIndex) {
      setState(() => _selectedIndex = widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LandscapeShellScope(
      isInLandscapeShell: true,
      child: Scaffold(
        backgroundColor: AppColors.frame,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRail(context),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Material(
                        color: AppColors.surface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const AddressBanner(),
                            Expanded(child: widget.child),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      color: AppColors.frame,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              'assets/app_icon.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sharmik Disha',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Cooperative Services',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRail(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _railExtended = true),
      onExit: (_) => setState(() => _railExtended = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: _railExtended ? 240 : 76,
        color: AppColors.frame,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: List.generate(AppNav.items.length, (index) {
            final item = AppNav.items[index];
            final isSelected = index == _selectedIndex;
            return _RailDestination(
              icon: isSelected ? item.selectedIcon : item.icon,
              label: item.label,
              isSelected: isSelected,
              onTap: () => widget.onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _RailDestination extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailDestination({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showLabel = constraints.maxWidth >= 124;
            return Row(
              mainAxisAlignment: showLabel
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
