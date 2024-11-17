import 'package:auto_route/auto_route.dart';
import 'package:zanatlija_app/navigation/router.gr.dart';
import 'package:zanatlija_app/navigation/routes.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: InitialRoute.page,
          path: kInitialRoute,
          initial: true,
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: kLoginRoute,
        ),
        AutoRoute(
          page: RegistrationRoute.page,
          path: kRegistrationRoute,
        ),
        AutoRoute(
          page: HomeRoute.page,
          path: kHomeRoute,
        ),
        AutoRoute(
          page: AddCraft.page,
          path: kAddCraftRoute,
        ),
        AutoRoute(
          page: ViewCraft.page,
          path: kViewCraftRoute,
        ),
        AutoRoute(
          page: ChatRoom.page,
          path: kChatRoomRoute,
        ),
      ];
}
