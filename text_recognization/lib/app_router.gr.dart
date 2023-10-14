// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CameraRoute.name: (routeData) {
      final args = routeData.argsAs<CameraRouteArgs>(
          orElse: () => const CameraRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CameraScreen(key: args.key),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
  };
}

/// generated route for
/// [CameraScreen]
class CameraRoute extends PageRouteInfo<CameraRouteArgs> {
  CameraRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CameraRoute.name,
          args: CameraRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CameraRoute';

  static const PageInfo<CameraRouteArgs> page = PageInfo<CameraRouteArgs>(name);
}

class CameraRouteArgs {
  const CameraRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'CameraRouteArgs{key: $key}';
  }
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
