import 'package:appscanner/common/installed_apps.dart';
import 'package:appscanner/screens/home.dart';
import 'package:flutter/material.dart';
import 'Services/Analytics.dart';

void main() {
  runApp(AppScanner());
}

class AppScanner extends StatefulWidget {
  @override
  _AppScannerState createState() => _AppScannerState();
}

class _AppScannerState extends State<AppScanner> {
  @override
  void initState() {
    Analytics().appOpen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App Scanner",
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        'installedApps': (context) => InstalledApps(),
      },
    );
  }
}
