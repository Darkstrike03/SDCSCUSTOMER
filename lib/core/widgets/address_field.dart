import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/address_provider.dart';
import 'address_selector_sheet.dart';

/// A field-style address bar matching [SearchField]'s visual design.
/// Shows the selected delivery address or a placeholder when none is set.
/// Tapping opens the address selector sheet.
class AddressField extends ConsumerStatefulWidget {
  const AddressField({super.key});

  @override
  ConsumerState<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends ConsumerState<AddressField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedAddressProvider);

    // Update controller text when the selected address changes.
    final text = selected == null ? '' : '${selected.label} — ${selected.detail}';
    if (_controller.text != text) {
      // Defer to after the current frame to avoid setState-during-build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      });
    }

    return GestureDetector(
      onTap: () => showAddressSelectorSheet(context),
      child: AbsorbPointer(
        child: TextField(
          readOnly: true,
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Add an address for delivery',
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: AppColors.textHint,
            ),
            suffixIcon: Icon(
              Icons.expand_more,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
