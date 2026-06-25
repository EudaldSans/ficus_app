import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/plant_detail/presentation/screens/plant_detail_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/plant/:macAddress',
      builder: (context, state) {
        final mac = state.pathParameters['macAddress']!;
        return PlantDetailScreen(macAddress: mac);
      },
    ),
  ],
);
