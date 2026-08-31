import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../models/service_category.dart';

class ServiceCategoryPager extends StatefulWidget {
  final List<ServiceCategory> categories;

  const ServiceCategoryPager({super.key, required this.categories});

  static const _iconMap = <String, IconData>{
    'bolt': Icons.electrical_services,
    'water_drop': Icons.plumbing,
    'cleaning_services': Icons.cleaning_services,
    'hammer': Icons.handyman,
    'format_paint': Icons.format_paint,
    'elderly_woman': Icons.elderly,
    'directions_car': Icons.directions_car,
    'yard': Icons.yard,
  };

  @override
  State<ServiceCategoryPager> createState() => _ServiceCategoryPagerState();
}

class _ServiceCategoryPagerState extends State<ServiceCategoryPager> {
  static const double _minItemWidth = 96;
  static const double _crossSpacing = 16;
  static const double _mainSpacing = 18;
  static const double _pageVSpacing = 8;

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;
    if (categories.isEmpty) return const SizedBox.shrink();

    final pillSize = isLandscape(context) ? 68.0 : 56.0;
    final labelHeight = 20.0;
    final cellHeight = pillSize + 8 + labelHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth - 32;
        final cols = (contentWidth / _minItemWidth).floor().clamp(3, 6);
        final cellWidth = (contentWidth - _crossSpacing * (cols - 1)) / cols;
        final pageHeight = cellHeight * 2 + _mainSpacing + _pageVSpacing * 2;
        final aspectRatio = cellWidth / cellHeight;

        final itemsPerPage = cols * 2;
        final pages = _chunk(categories, itemsPerPage);

        return _buildPager(context, pages, cols, pillSize, cellHeight, aspectRatio, pageHeight);
      },
    );
  }

  Widget _buildPager(
    BuildContext context,
    List<List<ServiceCategory>> pages,
    int cols,
    double pillSize,
    double cellHeight,
    double aspectRatio,
    double pageHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: pageHeight,
          child: PageView.builder(
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) {
              final items = pages[index];
              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: _pageVSpacing,
                ),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: _mainSpacing,
                  crossAxisSpacing: _crossSpacing,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final cat = items[i];
                  return _buildTile(context, cat, pillSize);
                },
              );
            },
          ),
        ),
        if (pages.length > 1) ...[
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(pages.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  List<List<ServiceCategory>> _chunk(List<ServiceCategory> list, int size) {
    final result = <List<ServiceCategory>>[];
    for (var i = 0; i < list.length; i += size) {
      result.add(list.sublist(i, i + size > list.length ? list.length : i + size));
    }
    return result;
  }

  Widget _buildTile(BuildContext context, ServiceCategory cat, double pillSize) {
    final icon = ServiceCategoryPager._iconMap[cat.iconName] ?? Icons.miscellaneous_services;
    return GestureDetector(
      onTap: () => context.push('/services/${cat.id}/workers'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: pillSize,
            height: pillSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.22),
                  AppColors.primarySurface,
                ],
              ),
              borderRadius: BorderRadius.circular(pillSize * 0.3),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Icon(icon, color: AppColors.primary, size: pillSize * 0.46),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              cat.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
