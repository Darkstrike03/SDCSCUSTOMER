import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/address_provider.dart';
import 'address_selector_sheet.dart';

class AddressBanner extends ConsumerWidget {
  const AddressBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedAddressProvider);

    return GestureDetector(
      onTap: () => showAddressSelectorSheet(context),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primarySurface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              size: 18,
              color: selected == null ? AppColors.textHint : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: selected == null
                  ? Text(
                      'Add an address for delivery',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  : Text(
                      'Deliver to: ${selected.label} — ${selected.detail}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
            ),
            const Icon(Icons.expand_more, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
