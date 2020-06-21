import 'package:appscanner/common/formatting.dart';
import 'package:appscanner/common/painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;
  Map<String, List<String>> _knownApps = {
    'tiktok': ['Dubsmash', 'https://play.google.com/store/apps/details?id=com.mobilemotion.dubsmash'],
    'like': ['Dubsmash', 'https://play.google.com/store/apps/details?id=com.mobilemotion.dubsmash'],
    'helo': ['ShareChat', 'https://play.google.com/store/apps/details?id=in.mohalla.sharechat&hl=en_IN'],
    'shareit': ['Files By Google', 'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.files&hl=en_IN'],
    'ucbrowser': ['Firefox', 'https://play.google.com/store/apps/details?id=org.mozilla.focus&hl=en_IN'],
    'pubgmobile': ['Call Of Duty', 'https://play.google.com/store/apps/details?id=com.activision.callofduty.shooter&hl=en_IN'],
    'pubgmobilelite': ['Fortnite', 'https://play.google.com/store/apps/details?id=com.epicgames.fortnite&hl=en_IN'],
    'tiktoklite': ['Dubsmash', 'https://play.google.com/store/apps/details?id=com.mobilemotion.dubsmash'],
    'cutcut': ['Blend Me Photo Mixture',  'https://play.google.com/store/apps/details?id=com.appwallet.blendme'],
    'xender': ['Files By Google', 'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.files&hl=en_IN'],
    'vmate': ['Triller', 'https://play.google.com/store/apps/details?id=co.triller.droid'],
    'beautyplus': ['Candy Camera', 'https://play.google.com/store/apps/details?id=com.joeware.android.gpulumera'],
    'clubfactory': ['ShopClues' , 'https://play.google.com/store/apps/details?id=com.shopclues&hl=en'],
    'allvideodownloader': ['Free Video Downloader', 'https://play.google.com/store/apps/details?id=free.video.downloader.freevideodownloader'],
    'vigovideo': ['Triller', 'https://play.google.com/store/apps/details?id=co.triller.droid'],
    'applock': ['Norton Lock', 'https://play.google.com/store/apps/details?id=com.symantec.applock'],
    'ucbrowsermini': ['Firefox', 'https://play.google.com/store/apps/details?id=org.mozilla.focus&hl=en_IN'],
    'vigolite': ['Triller', 'https://play.google.com/store/apps/details?id=co.triller.droid'],
    'vmatestatus': ['Triller', 'https://play.google.com/store/apps/details?id=co.triller.droid'],
    'udictionary': ['Dictionary.com', 'https://play.google.com/store/apps/details?id=com.dictionary'],
    'livu': ['Azar', 'https://play.google.com/store/apps/details?id=com.azarlive.android'],
    'uplive': ['Periscope', 'https://play.google.com/store/apps/details?id=tv.periscope.android&hl=en_IN'],
    'liveme': ['Periscope', 'https://play.google.com/store/apps/details?id=tv.periscope.android&hl=en_IN'],
    'riseofcivilizations': ['Clash of Clans', 'https://play.google.com/store/apps/details?id=com.supercell.clashofclans'],
    'riseofkindoms': ['Clash of Clans', 'https://play.google.com/store/apps/details?id=com.supercell.clashofclans'],
    'vigolive': ['Periscope', 'https://play.google.com/store/apps/details?id=tv.periscope.android&hl=en_IN'],
    'kingofavalon': ['RAID: Shadow Legends', 'https://play.google.com/store/apps/details?id=com.plarium.raidlegends'],
    'gunsofglory': ['War and Order', 'https://play.google.com/store/apps/details?id=com.camelgames.superking'],
    'zakzakpro': ['Azar', 'https://play.google.com/store/apps/details?id=com.azarlive.android'],
    'clashofkings': ['Clash Royale', 'https://play.google.com/store/apps/details?id=com.supercell.clashroyale'],
    'castlecash':  ['Clash Royale', 'https://play.google.com/store/apps/details?id=com.supercell.clashroyale'],
    'camscanner' : ['Adobe Scan', 'https://play.google.com/store/apps/details?id=com.adobe.scan.android&hl=en_IN'],
    'gameofsultans': ['Clash of Clans', 'https://play.google.com/store/apps/details?id=com.supercell.clashofclans'],
    'nonolive': ['Periscope', 'https://play.google.com/store/apps/details?id=tv.periscope.android&hl=en_IN'],
    'dating.com': ['Tinder', 'https://play.google.com/store/apps/details?id=com.tinder'],
    'webnovel': ['MoboReader', 'https://play.google.com/store/apps/details?id=com.changdu.ereader'],
    'helloyo': ['Azar', 'https://play.google.com/store/apps/details?id=com.azarlive.android'],
    'legacyofdiscord': ['RAID: Shadow Legends', 'https://play.google.com/store/apps/details?id=com.plarium.raidlegends'],
    'mafiacity': ['Narcos: Cartel Wars', 'https://play.google.com/store/apps/details?id=com.ftxgames.narcos'],
    'lastempire': ['State of Survival', 'https://play.google.com/store/apps/details?id=com.kingsgroup.sos'],
    'artofconquest': ['RAID: Shadow Legends', 'https://play.google.com/store/apps/details?id=com.plarium.raidlegends'],
    'flashkeyboard': ['Gboard', 'https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin'],
    'turbovpn' : ['Proton Vpn', 'https://play.google.com/store/apps/details?id=ch.protonvpn.android&hl=en_IN'],
    'bigolive': ['Azar', 'https://play.google.com/store/apps/details?id=com.azarlive.android'],
    'mobilelegendsbangbang': ['RAID: Shadow Legends', 'https://play.google.com/store/apps/details?id=com.plarium.raidlegends'],
    'newsdog': ['Dailyhunt', 'https://play.google.com/store/apps/details?id=com.eterno'],
    'cheez': ['Zoomerang', 'https://play.google.com/store/apps/details?id=com.yantech.zoomerang'],
    'kwai': ['Triller', 'https://play.google.com/store/apps/details?id=co.triller.droid'],
    'shein': ['Myntra', 'https://play.google.com/store/apps/details?id=com.myntra.android'],
    'romwe': ['Myntra', 'https://play.google.com/store/apps/details?id=com.myntra.android'],
  };

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: CustomPaint(
              size: Size(size.width, size.height),
              painter: TopPainter([Colors.purpleAccent[200], Colors.deepPurpleAccent[400]], [0.25, 1]),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(size.width * 0.1, size.height * 0.05, size.width * 0.05, size.height * 0.01),
            child: Image(
              image: AssetImage('assets/detective-sm.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.5, size.width * 0.05, size.height * 0.01),
            child: !_loading ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                    "Click on \"Scan Now\" to secure your phone from unwanted applications",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
              ),
            ) : loader,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.68, size.width * 0.05, size.height * 0.01),
            child: Center(
              child: !_loading ? Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () async{
                    setState(() {
                      _loading = true;
                    });
                    await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true, includeAppIcons: true).then((apps) async{
                      if(apps != null){
                        List<String> knowApps = _knownApps.keys.toList();
                        Iterable<Application> chineseApps = apps.where((app) {
                          List<String> match = knowApps.where((appName) =>
                              appName.toLowerCase().startsWith(app.appName.toLowerCase().replaceAll(' ', '').replaceAll(':', '').replaceAll('-', ''))).toList();
                          return match.length > 0 ? true : false;
                        });
                        Navigator.of(context).pushReplacementNamed('installedApps', arguments: {'chineseApps' : chineseApps.toList(), 'knownApps' : _knownApps});
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
                        gradient: LinearGradient(colors: [Colors.purpleAccent, Colors.purple[400]], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text("Scan Now", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),),
                    ),
                  ),
                ),
              ) : Container(),
            ),
          )
        ],
      ),
    );
  }
}
