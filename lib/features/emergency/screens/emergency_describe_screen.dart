import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

class EmergencyDescribeScreen extends StatefulWidget {
  const EmergencyDescribeScreen({super.key});

  @override
  State<EmergencyDescribeScreen> createState() => _EmergencyDescribeScreenState();
}

class _EmergencyDescribeScreenState extends State<EmergencyDescribeScreen> {
  String _selectedCategory = 'electrical';
  final _controller = TextEditingController();

  static const _categories = [
    {'id': 'electrical', 'label': 'Electrical', 'icon': Icons.electrical_services},
    {'id': 'plumbing', 'label': 'Plumbing', 'icon': Icons.plumbing},
    {'id': 'cleaning', 'label': 'Cleaning', 'icon': Icons.cleaning_services},
    {'id': 'other', 'label': 'Other', 'icon': Icons.miscellaneous_services},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Service'),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.error,
      ),
      body: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Describe your emergency briefly. We\'ll match you with the nearest available worker.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Service Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: _categories.asMap().entries.map((entry) {
                final cat = entry.value;
                final isSelected = cat['id'] == _selectedCategory;
                return Expanded(
                  key: ValueKey('emergency-cat-${cat['id']}'),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat['id'] as String),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            cat['icon'] as IconData,
                            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['label'] as String,
                            style: TextStyle(
                              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Describe the issue',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'e.g. Power cut in the kitchen, wire sparking',
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Find Worker',
              icon: Icons.search,
              onPressed: () => context.push('/emergency/match'),
            ),
          ],
        ),
      ),
    );
  }
}
