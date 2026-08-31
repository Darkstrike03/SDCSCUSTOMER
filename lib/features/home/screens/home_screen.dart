import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/shell_scaffold.dart';
import '../../../data/mock_data.dart';
import '../widgets/service_category_pager.dart';
import '../widgets/emergency_button.dart';
import '../widgets/book_again_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ShellScaffold(
      appBar: LandscapeShellScope.of(context) ? null : _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                readOnly: true,
                onTap: () {},
              ),
            ),
            const SizedBox(height: 24),
            const EmergencyButton(),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Services'),
            const SizedBox(height: 12),
            ServiceCategoryPager(categories: MockData.categories),
            const SizedBox(height: 28),
            SectionHeader(
              title: 'Book Again',
              actionText: 'See All',
              onAction: () => context.go('/bookings'),
            ),
            const SizedBox(height: 12),
            const BookAgainSection(),
            const SizedBox(height: 24),
            const SizedBox(
              height: kFloatingNavHeight + kFloatingNavGap,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SDCS',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          Text(
            'Sharmik Disha Cooperative Services',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
