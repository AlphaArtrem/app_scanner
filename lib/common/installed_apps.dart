import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:appscanner/common/painter.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:flutter_share/flutter_share.dart';

class InstalledApps extends StatefulWidget {
  @override
  _InstalledAppsState createState() => _InstalledAppsState();
}

class _InstalledAppsState extends State<InstalledApps> with WidgetsBindingObserver{
  static const platform = const MethodChannel('com.alphaartrem.appscanner/deleteApp');

  List<TopPainter> _painters = [
    TopPainter([Colors.redAccent[700], Colors.redAccent, Colors.red[50]],  [0.1, 0.25, 1]),
    TopPainter([Colors.lightGreenAccent, Colors.green],  [0.2, 1])
  ];

  List _apps;
  Map _knownApps;
  String directory;
  int _appCount;
  int _currentAppIndex;

  List _uninstalledApps = [];
  bool _loading = false;
  List<bool> _showAlternatives = [];

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
              margin: EdgeInsets.fromLTRB(size.width * 0.1, size.height * 0.04, size.width * 0.05, size.height * 0.01),
              child: Image.asset(
                  'assets/img/detective-lg.png',
                  height: size.height * 0.45,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.8, size.height * 0.06, size.width * 0.05, size.height * 0.01),
              child: IconButton(
                onPressed: () async{
                  String path = await NativeScreenshot.takeScreenshot();
                  print(path);
                  await FlutterShare.shareFile(
                    title: 'Protect Your Phone And Country From Chinese Apps',
                    text: 'Hey, I am using App Scanner to get rid of malicious chinese apps which snoop on our privacy and harm our phones. '
                        'If you want to protect your phone and privcay like me try the app by clicking the link below.\n'
                        'https://play.google.com/store/apps/details?id=com.alphaartrem.appscanner',
                    filePath: path,
                  );
                },
                icon: Icon(Icons.share, color: Colors.white,),
              ),
            ),
            _appCount == 0 ? Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.28, size.height * 0.4, size.width * 0.05, size.height * 0.01),
              child: Text(
                'Your Device Is Safe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Quicksand', color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ) : Container(),
            !_loading ? Container(
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
                                child: Text(
                                  '${_apps[index].appName}${_uninstalledApps.contains(_apps[index]) ? ' has been uninstalled' : ''}',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',),
                                ),
                              ),
                              !_showAlternatives[index] ? Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
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
                                  GestureDetector(
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
                                  GestureDetector(
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
                                  GestureDetector(
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
            ) :  Container(
                margin: EdgeInsets.fromLTRB(size.width * 0.09, size.height * 0.5, size.width * 0.05, size.height * 0.01),
                child: SpinKitDoubleBounce(
                color:  _appCount > 0 ? Colors.red : Colors.green,
                size: 50.0,
            )),
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
        if(_currentAppIndex != null){
          setState(() {
            _loading = true;
          });
        }
        Timer(Duration(seconds: 5), () async{
          if(_currentAppIndex != null){
            await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true).then((List apps){
              if(apps != null){
                dynamic match = apps.firstWhere((app) => app.packageName == _apps[_currentAppIndex].packageName, orElse: () => null);
                if(match == null){
                  if(!_uninstalledApps.contains(_apps[_currentAppIndex])){
                    _appCount--;
                    _uninstalledApps.add(_apps[_currentAppIndex]);
                  }
                }
                _loading = false;
                _currentAppIndex = null;
                setState(() {});
              }
            });
          }
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
    }
  }
}
