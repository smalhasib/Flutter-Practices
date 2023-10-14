import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:text_recognization/camera_screen.dart';
import 'package:text_recognization/main_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainRoute.page, initial: true),
        AutoRoute(page: CameraRoute.page),
      ];
}
