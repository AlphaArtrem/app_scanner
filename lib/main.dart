import 'file:///D:/Workspace/flutter/app_scanner/lib/screens/installed_apps.dart';
import 'package:appscanner/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppScanner());
}

class AppScanner extends StatefulWidget {
  @override
  _AppScannerState createState() => _AppScannerState();
}

class _AppScannerState extends State<AppScanner> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App Scanner",
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        'installedApps' : (context) => InstalledApps(),
      },
    );
  }
}
