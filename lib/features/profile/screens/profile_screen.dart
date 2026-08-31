import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/shell_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ShellScaffold(
      appBar: LandscapeShellScope.of(context) ? null : AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + kFloatingNavHeight + kFloatingNavGap,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sayan Das',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+91 98765 43210',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                onPressed: () {},
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
