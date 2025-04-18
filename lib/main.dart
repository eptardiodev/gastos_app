import 'dart:async';
import 'package:gastos_app/ui/home/home_page.dart';
import 'package:gastos_app/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:gastos_app/app.dart';
import 'di/injector.dart';

void main() {
  Injector.init();
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      const BaseApp(
        initPage: SplashPage(),
      )
    );
  }, (error, stackTrace) async {
    Injector.instance.logger.log(error);
  });
}
