import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MediaQueryData _deviceData;

  @override
  Widget build(BuildContext context) {
    _deviceData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("App Scanner"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Expanded(child: Container(),),
              Text("Click the scan button to find chinese apps on your phone."),
              SizedBox(height: 20,),
              Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {},
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
              ),
              SizedBox(height: _deviceData.size.height - 500,)
            ],
          ),
      ),
    );
  }
}
