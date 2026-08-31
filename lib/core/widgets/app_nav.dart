import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class AppNav {
  AppNav._();

  static const List<NavItem> items = [
    NavItem(label: 'Services', icon: Icons.construction_outlined, selectedIcon: Icons.construction),
    NavItem(label: 'Bookings', icon: Icons.book_outlined, selectedIcon: Icons.book),
    NavItem(label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home),
    NavItem(label: 'Notifications', icon: Icons.notifications_outlined, selectedIcon: Icons.notifications),
    NavItem(label: 'Profile', icon: Icons.person_outline, selectedIcon: Icons.person),
  ];

  static int indexForLocation(String location) {
    if (location == '/') return 2;
    if (location.startsWith('/services')) return 0;
    if (location.startsWith('/bookings')) return 1;
    if (location.startsWith('/notifications')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 2;
  }

  static String locationForIndex(int index) {
    switch (index) {
      case 0:
        return '/services';
      case 1:
        return '/bookings';
      case 2:
        return '/';
      case 3:
        return '/notifications';
      case 4:
        return '/profile';
      default:
        return '/';
    }
  }
}
