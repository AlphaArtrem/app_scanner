import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:appscanner/common/painter.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InstalledApps extends StatefulWidget {
  @override
  _InstalledAppsState createState() => _InstalledAppsState();
}

class _InstalledAppsState extends State<InstalledApps> with WidgetsBindingObserver{
  static const platform = const MethodChannel('com.alphaartrem.appscanner/deleteApp');
  List _apps;
  Map _knownApps;
  List<bool> _showAlternatives = [];
  List<TopPainter> _painters = [
    TopPainter([Colors.redAccent[700], Colors.redAccent, Colors.red[50]],  [0.1, 0.25, 1]),
    TopPainter([Colors.lightGreenAccent, Colors.green],  [0.2, 1])
  ];
  int _appCount;
  List _uninstalledApps = [];
  int _currentAppIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _apps = data['chineseApps'];
    _knownApps = data['knownApps'];
    if(_appCount == null){
      _appCount = _apps.length;
    }
    if(_showAlternatives.isEmpty || _showAlternatives.length != _apps.length){
      _showAlternatives = List.filled(_apps.length, false);
    }
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: CustomPaint(
                size: Size(size.width, size.height),
                painter: _appCount > 0 ? _painters[0] : _painters[1],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.1, size.height * 0.05, size.width * 0.05, size.height * 0.01),
              child: Image(
                image: AssetImage('assets/img/detective-lg.png'),
              ),
            ),
            _appCount == 0 ? Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.27, size.height * 0.4, size.width * 0.05, size.height * 0.01),
              child: Text(
                'Your Device Is Safe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Quicksand', color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ) : Container(),
            Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.56, size.width * 0.05, size.height * 0.01),
              child: ListView.builder(
                itemCount: _apps.length,
                itemBuilder: (context, index){
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 4,
                                  child: Image.memory(_apps[index].icon, scale: 2,)
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 9,
                                child: Text('${_apps[index].appName}${_uninstalledApps.contains(_apps[index]) ? ' has been uninstalled' : ''}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',),),
                              ),
                              !_showAlternatives[index] ? Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        _showAlternatives[index] = true;
                                      });
                                    },
                                    child : Image.asset(
                                      'assets/img/alternative-lg.png',
                                      height: size.width * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("View\nAlternative", style: TextStyle(fontFamily: 'Quicksand', fontSize: 8), textAlign: TextAlign.center,),
                                ],
                              ) : Container(),
                              SizedBox(width: 20,),
                              !_uninstalledApps.contains(_apps[index]) ? Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async{
                                      _currentAppIndex = index;
                                      await _deleteApp(index);
                                    },
                                    child : Image.asset(
                                      'assets/img/uninstall-lg.png',
                                      height: size.height * 0.03,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Uninstall", style: TextStyle(fontFamily: 'Quicksand', fontSize: 8),),
                                ],
                              ) : Container(),
                            ],
                          ),
                          _showAlternatives[index] ? SizedBox(height: 10,) : Container(),
                          _showAlternatives[index] ? Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Image.asset(
                                  'assets/img/google_play.png',
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  '${_knownApps[_apps[index].appName.toLowerCase().replaceAll(' ', '').replaceAll(':', '').replaceAll('-', '')][0]}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async{
                                      AndroidIntent intent = AndroidIntent(
                                          action: 'action_view',
                                          data: _knownApps[_apps[index].appName.toLowerCase().replaceAll(' ', '').replaceAll(':', '').replaceAll('-', '')][1]
                                      );
                                      await intent.launch();
                                    },
                                    child : Image.asset(
                                      'assets/img/alternative-lg.png',
                                      height: size.width * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Install Now", style: TextStyle(fontFamily: 'Quicksand', fontSize: 8),),
                                ],
                              ),
                              SizedBox(width: 20,),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showAlternatives[index] = false;
                                      });
                                    },
                                    child : Image.asset(
                                      'assets/img/close-lg.png',
                                      height: size.width * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Hide", style: TextStyle(fontFamily: 'Quicksand', fontSize: 8),),
                                ],
                              ),
                              SizedBox(width: 8,),
                            ],
                          ) : Container(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteApp(int index) async {
    try {
      await platform.invokeMethod('deleteApp', {'package' : _apps[index].packageName});
    } on PlatformException catch (e) {
      print("Error : ${e.message}.");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.paused:
        Timer(Duration(seconds: 5), () async{
          if(_currentAppIndex != null){
            await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true).then((List apps){
              if(apps != null){
                dynamic match = apps.firstWhere((app) => app.packageName == _apps[_currentAppIndex].packageName, orElse: () => null);
                print(match);
                if(match == null){
                  if(!_uninstalledApps.contains(_apps[_currentAppIndex])){
                    _appCount--;
                    _uninstalledApps.add(_apps[_currentAppIndex]);
                    setState(() {});
                  }
                }
              }
            });
          }
        });
        break;
    }
  }
}
