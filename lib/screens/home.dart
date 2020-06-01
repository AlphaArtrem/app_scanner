import 'package:appscanner/common/formatting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Scanner"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !_loading ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Scan Phone For Chinese Apps.")),
              ) : loader,
              SizedBox(height: 20,),
              !_loading ? Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () async{
                    setState(() {
                      _loading = true;
                    });
                    await DeviceApps.getInstalledApplications().then((apps) {
                      if(apps != null){
                        Navigator.of(context).pushReplacementNamed('installedApps', arguments: apps);
                      }
                      else{
                        setState(() {
                          _loading = false;
                        });
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue[200]], begin: Alignment.centerLeft, end: Alignment.centerRight,),
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text("Scan", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),),
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
      ),
    );
  }
}
