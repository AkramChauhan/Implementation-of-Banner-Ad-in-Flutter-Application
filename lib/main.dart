import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static BannerAd _bannerAd;
  static bool isShown = false;
  static bool _isGoingToBeShown = false;
  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterian','flutter'],
    childDirected: true, //for family-designed apps
  );

  static void setBannerAd(){
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          isShown = true;
          _isGoingToBeShown = false;
        } else if (event == MobileAdEvent.failedToLoad) {
          isShown = false;
          _isGoingToBeShown = false;
        }
      },
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) setBannerAd();
    if (!isShown && !_isGoingToBeShown) {
      _isGoingToBeShown = true;
      isShown = true;
      _bannerAd
        ..load()..show(anchorOffset: 10.0);
    }
  }

  static void hideBannerAd(){
    if (_bannerAd != null && !_isGoingToBeShown) {
      _bannerAd.dispose().then((disposed) {
        isShown = !disposed;
      });
      _bannerAd = null;
      isShown = false;
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
    showBannerAd();
  }
  @override
  void dispose() {
    hideBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //If Ad loaded add some padding to
    List<Widget> fakeBottomButtons = new List<Widget>();
    List<Widget> noAdsButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 50.0,
    ));
    noAdsButtons.add(new Container(
      height: 0.0,
    ));
    return MaterialApp(
      title: 'Flutterian',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Controlling Banner Ad in Flutter"),
          //elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        ),
        body: Container(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.green[900],
                            Colors.green[800],
                            Colors.green[700],
                            Colors.green[600],
                            Colors.green[800],
                            Colors.green[900],
                          ]
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset.zero,
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          showBannerAd();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: Text("Show Banner Ad",style: TextStyle(
                            fontSize:24.0,
                            color:Colors.white,
                          )),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.red[900],
                            Colors.red[800],
                            Colors.red[700],
                            Colors.red[400],
                            Colors.red[800],
                            Colors.red[900],
                          ]
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset.zero,
                          blurRadius: 3.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          hideBannerAd();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          child: Text("Hide Banner Ad",style: TextStyle(
                            fontSize:24.0,
                            color:Colors.white,
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
        persistentFooterButtons: isShown? fakeBottomButtons:noAdsButtons,
      ),
    );
  }
}