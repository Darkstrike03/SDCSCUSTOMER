import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/landing_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/verification_screen.dart';
import '../widgets/responsive_scaffold.dart';
import '../../features/services/screens/worker_list_screen.dart';
import '../../features/booking/screens/bookings_screen.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/booking/screens/booking_tracking_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/booking/screens/receipt_screen.dart';
import '../../features/workers/screens/worker_profile_screen.dart';
import '../../features/emergency/screens/emergency_describe_screen.dart';
import '../../features/emergency/screens/emergency_match_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/saved_addresses_screen.dart';
import '../../features/profile/screens/payment_methods_screen.dart';
import '../../features/profile/screens/help_support_screen.dart';
import '../../features/profile/screens/add_address_screen.dart';
import '../../models/customer_data.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loggedIn = auth.isLoggedIn;
      final path = state.uri.toString();
      final onAuthRoute = path == '/login' ||
          path == '/register' ||
          path == '/verify' ||
          path == '/landing';

      if (!loggedIn && !onAuthRoute) {
        return kIsWeb ? '/landing' : '/login';
      }
      if (loggedIn && onAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ResponsiveScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/services',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WorkerListScreen()),
          ),
          GoRoute(
            path: '/bookings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BookingsScreen()),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NotificationsScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => const VerificationScreen(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
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
        path: '/bookings/:bookingId/pay',
        builder: (context, state) => PaymentScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/bookings/:bookingId/receipt',
        builder: (context, state) => ReceiptScreen(
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
        path: '/profile/addresses/new',
        builder: (context, state) => AddAddressScreen(
          existing: state.extra is CustomerAddress
              ? state.extra as CustomerAddress
              : null,
        ),
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

  ref.listen(authProvider, (previous, next) => router.refresh());
  return router;
});
