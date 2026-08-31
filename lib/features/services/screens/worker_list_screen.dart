import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/worker_card.dart';
import '../../../core/widgets/shell_scaffold.dart';
import '../../../data/mock_data.dart';

class WorkerListScreen extends StatelessWidget {
  final String? categoryId;

  const WorkerListScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final filteredWorkers = categoryId != null
        ? MockData.workers.where((w) => w.categoryId == categoryId).toList()
        : MockData.workers;

    final title = categoryId != null
        ? MockData.categories.firstWhere((c) => c.id == categoryId).name
        : 'All Workers';

    return ShellScaffold(
      appBar: LandscapeShellScope.of(context) ? null : AppBar(title: Text(title)),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(label: 'Distance', icon: Icons.keyboard_arrow_down, selected: false, onTap: () {}),
                const SizedBox(width: 8),
                _FilterChip(label: 'Rating 4.0+', selected: false, onTap: () {}),
                const SizedBox(width: 8),
                _FilterChip(label: 'Price', icon: Icons.keyboard_arrow_down, selected: false, onTap: () {}),
                const SizedBox(width: 8),
                _FilterChip(label: 'Available Today', selected: true, onTap: () {}),
              ],
            ),
          ),
          Expanded(
            child: filteredWorkers.isEmpty
                ? const Center(
                    child: Text('No workers found for this category.'),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      16 + kFloatingNavHeight + kFloatingNavGap,
                    ),
                    itemCount: filteredWorkers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => WorkerCard(worker: filteredWorkers[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primarySurface
              : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 2),
              Icon(icon, size: 16, color: color),
            ],
          ],
        ),
      ),
    );
  }
}
