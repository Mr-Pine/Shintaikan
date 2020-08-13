import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:shintaikan/drawerItems/item0.dart';
import 'package:shintaikan/drawerItems/item1.dart';
import 'package:shintaikan/drawerItems/item2.dart';
import 'package:shintaikan/drawerItems/item3.dart';
import 'package:shintaikan/drawerItems/item4.dart';
import 'package:shintaikan/drawerItems/item5.dart';
import 'package:shintaikan/drawerItems/item6.dart';
import 'package:shintaikan/drawerItems/item7.dart';
import 'package:shintaikan/drawerItems/item8.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

enum DrawerSelection { home, favorites, settings }
enum Qualities { low, medium }

Qualities _qualities = Qualities.low;

// ignore: non_constant_identifier_names
String GCMID = "";

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  Future<String> asyncFuture() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await _firebaseMessaging
        .getToken()
        .then((value) => strToken = value.toString());
    buildNumber = packageInfo.buildNumber;
    appName = packageInfo.appName;
    return Future.value("Data successfully");
  }

  AnimationController rotationController;

  final listController = ScrollController();
  double develInfoContainerHeight =
      0; //height of the container at the bottom of the App Drawer
  String buildNumber = "";
  String appName = "name";
  String strToken = "...";
  String appBarTitle = "Shintaikan";
  bool canRefresh = true;
  int clip = 0;
  int clickedItem = 0;
  double webViewOpacity = 0;
  String url = "https://www.shintaikan.de/index-app.html";
  WebViewController controller;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.lightBlue[900]);
    return MaterialApp(
      routes: {
        Video.routeName: (context) => Video(),
      },
      title: 'Shintaikan',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.lightBlue[600],
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900]),
            headline2: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900]),
            bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900]),
            bodyText2: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.red[900]),
          )),
      home: Builder(
        builder: (context) => SafeArea(
          top: false,
          child: Scaffold(
            drawer: myAppDrawer(context, controller),
            appBar:
                AppBar(title: Text(appBarTitle), actions: <Widget>[refresh()]),
            body: Center(
              child: mainBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget refresh() {
    if (canRefresh) {
      CurvedAnimation animation = CurvedAnimation(
          parent: rotationController, curve: Curves.easeOutCubic);
      return (RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Aktualisieren',
            onPressed: () {
              rotationController.forward(from: 0.0);
              //controller.clearCache().then((value) => controller.reload());
            },
          )));
    } else {
      return Container();
    }
  }

  Widget mainBody() {
    if (clickedItem == 0) return (Item0());
    if (clickedItem == 1) return (Item1());
    if (clickedItem == 2) return (Item2());
    if (clickedItem == 3) return (Item3());
    if (clickedItem == 4) return (Item4());
    if (clickedItem == 5) return (Item5());
    if (clickedItem == 6) return (Item6());
    if (clickedItem == 7) return (Item7());
    if (clickedItem == 8)
      return (Item8());
    else
      return (Item0());
  }

  Widget _buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: url,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        controller = webViewController;
      },
      onPageStarted: (String s) {
        setState(() {
          webViewOpacity = 0.0;
        });
      },
      onPageFinished: (String s) {
        setState(() {
          webViewOpacity = 1.0;
        });
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Clip starten'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    title: const Text('Niedrige Qualität'),
                    leading: Radio(
                      value: Qualities.low,
                      groupValue: _qualities,
                      onChanged: (Qualities value) {
                        setState(() {
                          _qualities = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Mittlere Qualität'),
                    leading: Radio(
                      value: Qualities.medium,
                      groupValue: _qualities,
                      onChanged: (Qualities value) {
                        setState(() {
                          _qualities = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              OutlineButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  String url = "https://www.shintaikan.de";
                  if (_qualities == Qualities.low) {
                    if (clip == 0) {
                      url =
                          "https://shintaikan.de/content/filme/seefestfilm2019_25.mp4";
                    } else if (clip == 1) {
                      url =
                          "https://shintaikan.de/content/filme/mixfilm2019_25.mp4";
                    }
                  } else {
                    if (clip == 0) {
                      url =
                          "https://shintaikan.de/content/filme/seefestfilm2019_50.mp4";
                    } else if (clip == 1) {
                      url =
                          "https://shintaikan.de/content/filme/mixfilm2019_50.mp4";
                    }
                  }
                  Navigator.pushNamed(
                    context,
                    Video.routeName,
                    arguments: ScreenArguments(url),
                  );
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF42A5F5),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Film ab!'),
                ),
              ),
            ],
          );
        },
      );
    }

    _showMyDialog();
  }

  void showInfoDialog(BuildContext context, String text) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    _showMyDialog();
  }

  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.getToken().then((token) {
      print(token);
      showInfoDialog(context, token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Widget myAppDrawer(BuildContext context, WebViewController controller) {
    DrawerSelection _drawerSelection = DrawerSelection.home;
    return Drawer(
        child: ListView(
            controller: listController,
            padding: EdgeInsets.zero,
            children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/images/pelli.png'),
          ),
          ListTile(
            leading: Icon(OMIcons.info),
            title: Text('Start',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("https://shintaikan.de/index-app.html");
              setState(() {
                clickedItem = 0;
                appBarTitle = "Shintaikan";
                canRefresh = true;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.dateRange),
            title: Text('Trainingsplan',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/trplan-app.html");
              setState(() {
                clickedItem = 1;
                appBarTitle = "Trainingsplan";
                canRefresh = true;
              });
              Navigator.pop(context);
            },
            selected: _drawerSelection == DrawerSelection.favorites,
          ),
          ListTile(
            leading: Icon(OMIcons.callMade),
            title: Text('Gürtelprüfungen',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/pruefung-app.html");
              setState(() {
                clickedItem = 2;
                appBarTitle = "Gürtelprüfungen";
                canRefresh = true;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.beachAccess),
            title: Text('Ferientraining',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/ferien-app.html");
              setState(() {
                clickedItem = 3;
                appBarTitle = "Ferientraining";
                canRefresh = true;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.wbSunny),
            title: Text('Nach den Sommerferien',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/nach_sofe-app.html");
              setState(() {
                clickedItem = 4;
                appBarTitle = "Nach den Sommerferien";
                canRefresh = false;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.home),
            title: Text('Der Club/Wegbeschreibung',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/club-app.html");
              setState(() {
                clickedItem = 5;
                appBarTitle = "Der Club/Wegbeschreibung";
                canRefresh = false;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.directionsWalk),
            title: Text('Anfänger/Interessenten',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/interessenten-app.html");
              setState(() {
                clickedItem = 6;
                appBarTitle = "Anfänger/Interessenten";
                canRefresh = false;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.removeRedEye),
            title: Text('Vorführungen',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/show-app.html");

              setState(() {
                clickedItem = 7;
                appBarTitle = "Vorführungen";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.people),
            title: Text('Lehrgänge + Turniere',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              //controller.loadUrl("http://shintaikan.de/lehrgang-app.html");
              setState(() {
                clickedItem = 8;
                appBarTitle = "Lehrgänge + Turniere";
                canRefresh = true;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.movie),
            title: Text('Infofilmchen starten',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Video()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(OMIcons.movie),
            title: Text('Seefest 2019',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.pop(context);
              clip = 0;
              showAlertDialog(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.movie),
            title: Text('Mixfilm 2019',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.pop(context);
              clip = 1;
              showAlertDialog(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(OMIcons.attachFile),
            title: Text('Impressum',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              controller.loadUrl("https://shintaikan.de/?page_id=207");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.lock),
            title: Text('Datenschutz',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              controller.loadUrl("https://shintaikan.de/?page_id=202");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(OMIcons.tagFaces),
            title: Text('Weiteres',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.pop(context);
              showInfoDialog(context,
                  "Was Rüdiger noch sagen wollte: Tiefer stehen, schneller schlagen! :)");
            },
          ),
          ListTile(
            leading: Icon(OMIcons.info),
            title: Text('Über',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationVersion: buildNumber,
                  applicationIcon: FlutterLogo(),
                  applicationLegalese: 'http://old.shintaikan.de/impress.htm',
                  applicationName: appName);
            },
          ),
          Divider(),
          Center(
              child: IconButton(
            icon: FlutterLogo(),
            onPressed: () {
              setState(() {
                develInfoContainerHeight = 80.0;
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                if (listController != null) {
                  listController.animateTo(
                    listController.position.maxScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              });
            },
          )),
          Container(
            alignment: Alignment.center,
            height: develInfoContainerHeight,
            child: FutureBuilder(
                future: asyncFuture(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return (Column(children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      buildNumber,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Clipboard.setData(new ClipboardData(text: strToken))
                              .then((value) {
                            final snackBar = SnackBar(
                              content: Text('In die Zwischenablage kopiert'),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                        },
                        child: Text(
                          strToken,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 8,
                          ),
                        ))
                  ]));
                }),
          ),
        ]));
  }
}

class ScreenArguments {
  final String url;

  ScreenArguments(this.url);
}

class Video extends StatelessWidget {
  static const routeName = '/video';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: null,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: args.url,
          ),
        ));
  }
}