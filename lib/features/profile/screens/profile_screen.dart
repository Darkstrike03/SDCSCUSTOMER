import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/shell_scaffold.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/customer_data_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final customerAsync = ref.watch(customerDataProvider);
    final customer = customerAsync.valueOrNull;

    final displayName = customer?.fullName.isNotEmpty == true
        ? customer!.fullName
        : (auth.name ?? 'User');
    final displayEmail = customer?.email ?? auth.email ?? '';
    final displayPhone = customer?.phone;

    return ShellScaffold(
      appBar: null,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + kFloatingNavHeight + kFloatingNavGap,
        ),
        child: Column(
          children: [
            // -- Profile card --
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => _EditProfileSheet(
                    fullName: displayName,
                    email: displayEmail,
                    phone: displayPhone,
                    avatarUrl: customer?.avatarUrl,
                    backgroundUrl: customer?.backgroundUrl,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  image: customer?.backgroundUrl != null &&
                          customer!.backgroundUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(customer.backgroundUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  gradient: LinearGradient(
                    colors: customer?.backgroundUrl != null &&
                            customer!.backgroundUrl!.isNotEmpty
                        ? [Colors.black26, Colors.black54]
                        : [AppColors.primary, AppColors.primaryDark],
                    begin: customer?.backgroundUrl != null &&
                            customer!.backgroundUrl!.isNotEmpty
                        ? Alignment.topCenter
                        : Alignment.topLeft,
                    end: customer?.backgroundUrl != null &&
                            customer!.backgroundUrl!.isNotEmpty
                        ? Alignment.bottomCenter
                        : Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _ProfileCard(
                  displayName: displayName,
                  displayEmail: displayEmail,
                  displayPhone: displayPhone,
                  hasAvatar: customer?.avatarUrl != null &&
                      customer!.avatarUrl!.isNotEmpty,
                  avatarUrl: customer?.avatarUrl,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (customer != null && customer.addresses.isNotEmpty) ...[
              _ProfileMenuItem(
                icon: Icons.location_on_outlined,
                label: 'Saved Addresses',
                trailing: '${customer.addresses.length}',
                onTap: () => context.push('/profile/addresses'),
              ),
            ] else
              _ProfileMenuItem(
                icon: Icons.location_on_outlined,
                label: 'Saved Addresses',
                onTap: () => context.push('/profile/addresses'),
              ),
            _ProfileMenuItem(
              icon: Icons.payment_outlined,
              label: 'Payment Methods',
              onTap: () => context.push('/profile/payments'),
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () => context.push('/profile/help'),
            ),
            _ProfileMenuItem(
              icon: Icons.language,
              label: 'Language',
              trailing: 'English',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notification Settings',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/landing');
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        trailing: trailing != null
            ? Text(trailing!, style: const TextStyle(color: AppColors.textSecondary))
            : const Icon(Icons.chevron_right, color: AppColors.textHint),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String displayName;
  final String displayEmail;
  final String? displayPhone;
  final bool hasAvatar;
  final String? avatarUrl;

  const _ProfileCard({
    required this.displayName,
    required this.displayEmail,
    this.displayPhone,
    required this.hasAvatar,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: hasAvatar
              ? ClipOval(
                  child: Image.network(
                    avatarUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        if (displayEmail.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            displayEmail,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
          ),
        ],
        if (displayPhone != null && displayPhone!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            displayPhone!,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
          ),
        ],
      ],
    );
  }
}

class _EditProfileSheet extends ConsumerStatefulWidget {
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? backgroundUrl;

  const _EditProfileSheet({
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.backgroundUrl,
  });

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _avatarCtrl;
  late final TextEditingController _bgCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.fullName);
    _phoneCtrl = TextEditingController(text: widget.phone ?? '');
    _avatarCtrl = TextEditingController(text: widget.avatarUrl ?? '');
    _bgCtrl = TextEditingController(text: widget.backgroundUrl ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _avatarCtrl.dispose();
    _bgCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await updateCustomerProfile(
        ref,
        fullName: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        avatarUrl: _avatarCtrl.text.trim().isEmpty ? null : _avatarCtrl.text.trim(),
        backgroundUrl: _bgCtrl.text.trim().isEmpty ? null : _bgCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding + kFloatingNavHeight + kFloatingNavGap),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildField(_nameCtrl, 'Full Name', Icons.person_outline),
            const SizedBox(height: 12),
            _buildField(
              TextEditingController(text: widget.email),
              'Email',
              Icons.email_outlined,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            _buildField(_phoneCtrl, 'Phone', Icons.phone_outlined),
            const SizedBox(height: 12),
            _buildField(_avatarCtrl, 'Avatar URL', Icons.image_outlined),
            const SizedBox(height: 12),
            _buildField(_bgCtrl, 'Background URL', Icons.photo_outlined),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool readOnly = false,
  }) {
    return TextField(
      controller: ctrl,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
