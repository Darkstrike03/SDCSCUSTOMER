import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/screens/home_screen.dart';
import '../widgets/responsive_scaffold.dart';
import '../../features/services/screens/worker_list_screen.dart';
import '../../features/booking/screens/bookings_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/booking/screens/booking_tracking_screen.dart';
import '../../features/workers/screens/worker_profile_screen.dart';
import '../../features/emergency/screens/emergency_describe_screen.dart';
import '../../features/emergency/screens/emergency_match_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/saved_addresses_screen.dart';
import '../../features/profile/screens/payment_methods_screen.dart';
import '../../features/profile/screens/help_support_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ResponsiveScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/services',
            pageBuilder: (context, state) => const NoTransitionPage(child: WorkerListScreen()),
          ),
          GoRoute(
            path: '/bookings',
            pageBuilder: (context, state) => const NoTransitionPage(child: BookingsScreen()),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) => const NoTransitionPage(child: NotificationsScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/services/:categoryId/workers',
        builder: (context, state) => WorkerListScreen(
          categoryId: state.pathParameters['categoryId'],
        ),
      ),
      GoRoute(
        path: '/workers/:workerId',
        builder: (context, state) => WorkerProfileScreen(
          workerId: state.pathParameters['workerId']!,
        ),
      ),
      GoRoute(
        path: '/workers/:workerId/book',
        builder: (context, state) => BookingScreen(
          workerId: state.pathParameters['workerId']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:bookingId/track',
        builder: (context, state) => BookingTrackingScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyDescribeScreen(),
      ),
      GoRoute(
        path: '/emergency/match',
        builder: (context, state) => const EmergencyMatchScreen(),
      ),
      GoRoute(
        path: '/profile/addresses',
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: '/profile/payments',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/profile/help',
        builder: (context, state) => const HelpSupportScreen(),
      ),
    ],
  );
});
