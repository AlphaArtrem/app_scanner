import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class InstalledApps extends StatefulWidget {
  @override
  _InstalledAppsState createState() => _InstalledAppsState();
}

class _InstalledAppsState extends State<InstalledApps> {
  List<Application> _apps;
  @override
  Widget build(BuildContext context) {
    _apps = ModalRoute.of(context).settings.arguments;
    print(_apps.length);
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
            return Container(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('${_apps[index].appName}'),
                  ),
                  Icon(Icons.delete, color: Colors.blue,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
