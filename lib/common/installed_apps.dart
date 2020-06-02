import 'package:android_intent/android_intent.dart';
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
  @override
  Widget build(BuildContext context) {
    _apps = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Unistall Apps"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: ListView.builder(
          itemCount: _apps.length,
          itemBuilder: (context, index){
            return Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
            );
          },
        ),
      ),
    );
  }

  Future<void> _deleteApp(String package) async {
    dynamic result;
    try {
      result = await platform.invokeMethod('deleteApp', {'package' : package});
      _apps.removeWhere((app) => app.packageName == package);
      setState(() {});
    } on PlatformException catch (e) {
      result = "Error : '${e.message}'.";
    }
  }
}
