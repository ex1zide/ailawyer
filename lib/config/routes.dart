import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:legalhelp_kz/features/auth/screens/splash_screen.dart';
import 'package:legalhelp_kz/features/auth/screens/onboarding_screen.dart';
import 'package:legalhelp_kz/features/auth/screens/phone_auth_screen.dart';
import 'package:legalhelp_kz/features/auth/screens/sms_verification_screen.dart';
import 'package:legalhelp_kz/features/auth/screens/profile_setup_screen.dart';
import 'package:legalhelp_kz/features/auth/screens/register_screen.dart';
import 'package:legalhelp_kz/features/auth/screens/login_screen.dart';
import 'package:legalhelp_kz/features/home/screens/home_dashboard_screen.dart';
import 'package:legalhelp_kz/features/home/screens/search_screen.dart';
import 'package:legalhelp_kz/features/home/screens/notifications_screen.dart';
import 'package:legalhelp_kz/features/chat/screens/ai_chat_screen.dart';
import 'package:legalhelp_kz/features/lawyers/screens/lawyer_marketplace_screen.dart';
import 'package:legalhelp_kz/features/lawyers/screens/lawyer_profile_screen.dart';
import 'package:legalhelp_kz/features/lawyers/screens/saved_lawyers_screen.dart';
import 'package:legalhelp_kz/features/bookings/screens/booking_flow_screen.dart';
import 'package:legalhelp_kz/features/bookings/screens/my_bookings_screen.dart';
import 'package:legalhelp_kz/features/bookings/screens/payment_screen.dart';
import 'package:legalhelp_kz/features/bookings/screens/payment_success_screen.dart';
import 'package:legalhelp_kz/features/documents/screens/document_scanner_screen.dart';
import 'package:legalhelp_kz/features/documents/screens/document_library_screen.dart';
import 'package:legalhelp_kz/features/news/screens/legal_news_screen.dart';
import 'package:legalhelp_kz/features/news/screens/emergency_contacts_screen.dart';
import 'package:legalhelp_kz/features/news/screens/help_support_screen.dart';
import 'package:legalhelp_kz/features/profile/screens/profile_screen.dart';
import 'package:legalhelp_kz/features/profile/screens/user_profile_screen.dart';
import 'package:legalhelp_kz/features/profile/screens/settings_screen.dart';
import 'package:legalhelp_kz/features/profile/screens/subscription_plans_screen.dart';
import 'package:legalhelp_kz/features/profile/screens/payment_methods_screen.dart';
import 'package:legalhelp_kz/widgets/common/main_shell.dart';

// Route names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String phoneAuth = '/phone-auth';
  static const String smsVerification = '/sms-verification';
  static const String profileSetup = '/profile-setup';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String aiChat = '/chat';
  static const String lawyerMarketplace = '/lawyers';
  static const String lawyerProfile = '/lawyers/:id';
  static const String savedLawyers = '/saved-lawyers';
  static const String bookingFlow = '/booking/:lawyerId';
  static const String myBookings = '/my-bookings';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment-success';
  static const String documentScanner = '/scanner';
  static const String documentLibrary = '/documents';
  static const String legalNews = '/news';
  static const String emergencyContacts = '/emergency';
  static const String helpSupport = '/help';
  static const String profile = '/profile';
  static const String userProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String subscriptionPlans = '/subscription';
  static const String paymentMethods = '/payment-methods';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneAuth,
        builder: (context, state) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.smsVerification,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return SMSVerificationScreen(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Notifications (full screen over shell)
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      // Lawyer Profile
      GoRoute(
        path: AppRoutes.lawyerProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lawyerId = state.pathParameters['id']!;
          return LawyerProfileScreen(lawyerId: lawyerId);
        },
      ),
      GoRoute(
        path: AppRoutes.savedLawyers,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SavedLawyersScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingFlow,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lawyerId = state.pathParameters['lawyerId']!;
          return BookingFlowScreen(lawyerId: lawyerId);
        },
      ),
      GoRoute(
        path: AppRoutes.myBookings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.payment,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final lawyerId = state.uri.queryParameters['lawyerId'] ?? '';
          final price = int.tryParse(state.uri.queryParameters['price'] ?? '0') ?? 0;
          return PaymentScreen(lawyerId: lawyerId, price: price);
        },
      ),
      GoRoute(
        path: AppRoutes.paymentSuccess,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentScanner,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DocumentScannerScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentLibrary,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DocumentLibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.legalNews,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LegalNewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.emergencyContacts,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmergencyContactsScreen(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionPlans,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SubscriptionPlansScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentMethods,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      // Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomeDashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.search,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.aiChat,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const AIChatScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.lawyerMarketplace,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const LawyerMarketplaceScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
