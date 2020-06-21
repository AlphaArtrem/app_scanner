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
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _apps = data['chineseApps'];
    _knownApps = data['knownApps'];
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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
              image: AssetImage('assets/detective-sm.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.56, size.width * 0.05, size.height * 0.01),
            child: ListView.builder(
              itemCount: _apps.length,
              itemBuilder: (context, index){
                return Card(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[500]))
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Image.memory(_apps[index].icon, scale: 8,)
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                flex: 9,
                                child: Text('${_apps[index].appName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),
                              ),
                              IconButton(
                                onPressed: () async{
                                  await _deleteApp(_apps[index].packageName);
                                },
                                icon : Icon(Icons.delete, color: Colors.deepPurpleAccent,),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Get',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Text(
                                '${_knownApps[_apps[index].appName.toLowerCase().replaceAll(' ', '').replaceAll(':', '').replaceAll('-', '')][0]}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                              ),
                            ),
                            IconButton(
                              onPressed: () async{
                                AndroidIntent intent = AndroidIntent(
                                    action: 'action_view',
                                    data: _knownApps[_apps[index].appName.toLowerCase().replaceAll(' ', '').replaceAll(':', '').replaceAll('-', '')][1]
                                );
                                await intent.launch();
                              },
                              icon : Icon(Icons.get_app, color: Colors.deepPurpleAccent,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteApp(String package) async {
    try {
      await platform.invokeMethod('deleteApp', {'package' : package});
      _apps.removeWhere((app) => app.packageName == package);
      setState(() {});
    } on PlatformException catch (e) {
      print("Error : ${e.message}.");
    }
  }
}
