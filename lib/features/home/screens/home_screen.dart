import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/shell_scaffold.dart';
import '../../../core/widgets/address_field.dart';
import '../../../core/widgets/home_hero.dart';
import '../../../data/mock_data.dart';
import '../widgets/service_category_pager.dart';
import '../widgets/emergency_button.dart';
import '../widgets/book_again_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPortrait = !LandscapeShellScope.of(context);

    final body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPortrait) ...[
            const HomeHero(),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AddressField(),
            ),
            const SizedBox(height: 12),
          ],
          if (!isPortrait) const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(readOnly: true, onTap: null),
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
    );

    return ShellScaffold(
      appBar: null,
      showAddressBanner: false,
      body: body,
    );
  }
}
