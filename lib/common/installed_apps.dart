import 'package:android_intent/android_intent.dart';
import 'package:appscanner/common/painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InstalledApps extends StatefulWidget {
  @override
  _InstalledAppsState createState() => _InstalledAppsState();
}

class _InstalledAppsState extends State<InstalledApps> {
  static const platform = const MethodChannel('com.alphaartrem.appscanner/deleteApp');
  List _apps;
  Map _knownApps;
  List<bool> _showAlternatives = [];
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _apps = data['chineseApps'];
    _knownApps = data['knownApps'];
    if(_showAlternatives.isEmpty || _showAlternatives.length != _apps.length){
      _showAlternatives = List.filled(_apps.length, false);
    }
    print(_showAlternatives);
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              child: CustomPaint(
                size: Size(size.width, size.height),
                painter: TopPainter([Colors.redAccent[700], Colors.redAccent, Colors.red[50]],  [0.1, 0.25, 1]),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(size.width * 0.1, size.height * 0.05, size.width * 0.05, size.height * 0.01),
              child: Image(
                image: AssetImage('assets/img/detective-lg.png'),
              ),
            ),
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
                                child: Text('${_apps[index].appName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',),),
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
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async{
                                      await _deleteApp(_apps[index].packageName);
                                    },
                                    child : Image.asset(
                                      'assets/img/uninstall-lg.png',
                                      height: size.height * 0.03,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Uninstall", style: TextStyle(fontFamily: 'Quicksand', fontSize: 8),),
                                ],
                              ),
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

  Future<void> _deleteApp(String package) async {
    try {
      int result = await platform.invokeMethod('deleteApp', {'package' : package});
      _apps.removeWhere((app) => app.packageName == package);
      setState(() {});
    } on PlatformException catch (e) {
      print("Error : ${e.message}.");
    }
  }
}
