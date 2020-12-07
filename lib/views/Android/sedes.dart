import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:inventariosdenzil/styles/inventarios_icons.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:inventariosdenzil/views/Android/ubicaciones.dart';
// import 'package:inventariosdenzil/widgets/bottomNavigationBar.dart';
import 'package:inventariosdenzil/widgets/cards.dart';
import 'package:inventariosdenzil/widgets/contadores.dart';
import 'package:inventariosdenzil/widgets/models.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// import '../../styles/extenciones.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference sedesCollection =
    FirebaseFirestore.instance.collection('denzilescolar');

bool isDarkModeEnabled = false;
bool _sideMenuOpen = false;
// bool _storageReady = false;
int articulos = 0;
int buenos = 0;
int malos = 0;
int regulares = 0;
var local = {};
var storage;

class AndroidSedesPage extends StatefulWidget {
  AndroidSedesPage({Key key, this.location}) : super(key: key);
  final String location;

  @override
  AndroidSedesPageState createState() => AndroidSedesPageState();
}

class AndroidSedesPageState extends State<AndroidSedesPage>
    with TickerProviderStateMixin {
  // @override
  // AnimationController _animationController;
  // Animation _animation;
  // bool _initialized = false;
  // bool _resumenCards = false;
  // bool _locationCards = false;
  // bool _articulosCards = false;
  // bool _error = false;
  List<dynamic> locations = [];
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    // Platform.isAndroid
    // Platform.isFuchsia
    // Platform.isIOS
    // Platform.isLinux
    // Platform.isMacOS
    // Platform.isWindows
    if (kIsWeb) {
      print(['Flutter Web', widget.location]);
      await getData(sedesCollection, widget.location, 'Web');
    } else if (Platform.isAndroid) {
      print(['Flutter Android', widget.location]);
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      storage = await Hive.openBox('storage');
      var box = widget.location;
      box = box.toString().replaceAll('á', 'a');
      box = box.toString().replaceAll('é', 'e');
      box = box.toString().replaceAll('í', 'i');
      box = box.toString().replaceAll('ó', 'o');
      box = box.toString().replaceAll('ú', 'u');
      box = box.toString().replaceAll('ñ', 'n');
      box = box.toString().replaceAll('Á', 'A');
      box = box.toString().replaceAll('É', 'E');
      box = box.toString().replaceAll('Í', 'I');
      box = box.toString().replaceAll('Ó', 'O');
      box = box.toString().replaceAll('Ú', 'U');
      box = box.toString().replaceAll('Ñ', 'N');
      await getData(sedesCollection, box, 'Android');
    }
    /* setState(() {
      locations = locations;
      _initialized = true;
      _locationCards = true;
      print(['location', locations.length, _initialized]);
    }); */
  }

  getData(CollectionReference collection, String box, String plat,
      [int index]) async {
    try {
      List<Locations> array = [];
      articulos = 0;
      var localt = storage.get('local');
      // print(['local-0', localt]);
      if (localt != null) {
        local = localt;
      } else {
        local = {};
        local['nombres'] = {};
        local['keys'] = {};
        local['nombres']['sedes'] = {};
        local['keys']['sedes'] = {};
      }
      var locationst = [];
      // print(['Internet locationst', locationst]);
      await collection.get().then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              // print(doc.data());
              var loc = Locations.fromFirebase(doc.data());
              // print(['loc', loc.toJson()]);
              array.add(loc);
              locationst.add(loc.toJson());
              local['nombres']['sedes'][doc.data()['nombre']] = {};
              local['keys']['sedes'][doc.data()['key']] = {};
              local['nombres']['sedes'][doc.data()['nombre']] = doc.data();
              local['keys']['sedes'][doc.data()['key']] = doc.data();
            })
          });
      // print(['Internet locationst', box, locationst]);
      await storage.put(box, locationst);
      await storage.put('local', local);
      // Aqui listo a las sedes por nombre
      // final data = local['nombres'] as Map;
      // final sedes = data['sedes'] as Map;
      // for (final name in sedes.keys) {
      //   // final value = data[name];
      //   print('$name');
      // }
      articulos = 0;
      buenos = 0;
      malos = 0;
      regulares = 0;
      array.forEach((element) {
        articulos += (element.cantidad is int) ? element.cantidad : 0;
        buenos += (element.buenos is int) ? element.buenos : 0;
        malos += (element.malos is int) ? element.malos : 0;
        regulares += (element.regulares is int) ? element.regulares : 0;
      });
      setState(() {
        articulos = articulos;
        buenos = buenos;
        malos = malos;
        regulares = regulares;
        locations = array;
        // _initialized = true;
        // _locationCards = true;
        // print(['location', widget.location, locations.length, _initialized]);
      });
      return array;
    } catch (e) {
      print(['Error Flutter Sedes ' + plat, e]);
      setState(() {
        // _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    isDarkModeEnabled = false;
    // _animationController =
    //     AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    // _animation = IntTween(begin: 0, end: 1).animate(_animationController);
    // _animation.addListener(() => setState(() {}));
  }

  void onStateChanged(bool isDarkModeEnabled2) async {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
    });
    // await storage.put('isDark', isDarkModeEnabled);
  }

  // double _pheight = 0.09;
  // double _pfontSize = 0.031;
  double _locationsCardsWidt = 300;
  // double _locationsCardsHeight = 120;
  double aspr = 0;
  double aspr2 = 0;
  String text = '';
  double space = 0;
  double fontSize = 12.5;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // initializeFlutterFire();
    return Stack(children: [
      Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // here the desired height
          child: AppBar(
            elevation: 0,
            backgroundColor:
                (isDarkModeEnabled) ? color3.withOpacity(0.98) : Colors.white,
            iconTheme: IconThemeData(
              color: (isDarkModeEnabled)
                  ? Colors.white
                  : color3.withOpacity(0.98), //change your color here
            ),
            titleSpacing: (widget.location != 'sedes') ? 0.0 : 15.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _sideMenuOpen = !_sideMenuOpen;
                        });
                        // await storage.put('sideMenuOpen', _sideMenuOpen);
                        // storage.clear();
                        // await FirebaseFirestore.instance.clearPersistence();
                        // print('Storage clear');
                      },
                      child: Container(
                        decoration: (isDarkModeEnabled)
                            ? circleNeumorpDecorationBlack
                            : circleNeumorpDecorationWhite,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            'Inventario general',
                            // (widget.location == 'sedes')?widget.location.capitalize():,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 1.3,
                              color: (isDarkModeEnabled) ? color4 : color5,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "Institución Educativa Denzil Escolar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 1.1,
                              color: (isDarkModeEnabled) ? color1 : color3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Container(
          color: (isDarkModeEnabled) ? color3.withOpacity(0.98) : Colors.white,
          child: Center(
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.7,
              child: WaterfallFlow.builder(
                padding: const EdgeInsets.all(5.0),
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      ((size.width ~/ _locationsCardsWidt) == null ||
                              (size.width ~/ _locationsCardsWidt) <= 0)
                          ? 1
                          : (size.width ~/ _locationsCardsWidt),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext c, int index) {
                  return LocationsCard(
                    fontSize: fontSize,
                    isDarkModeEnabled: isDarkModeEnabled,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AndroidUbicacionesPage(
                          locationCollection: FirebaseFirestore.instance
                              .collection('denzilescolar')
                              .doc(locations[index].sede.nombre)
                              .collection('ubicaciones'),
                          location: 'ubicaciones',
                          sede: locations[index].sede,
                        );
                      }));
                    },
                    locationCollection: FirebaseFirestore.instance
                        .collection('denzilescolar')
                        .doc(locations[index].sede.nombre)
                        .collection('ubicaciones'),
                    sede: locations[index].sede,
                    location: 'sede',
                    cantidad: locations[index].cantidad,
                    imagen: locations[index].imagen,
                    nombre: locations[index].nombre,
                  );
                },
                itemCount: locations.length,
              ),
            ),
          ),
        ),
      ),
      // Contadores
      Positioned(
        right: 0,
        left: 0,
        top: 85,
        child: ContadorBar(
          fontSize: fontSize,
          isDarkModeEnabled: isDarkModeEnabled,
          titulo: 'sedes',
          location: locations,
          width: 90,
          total: locations.length,
          articulos: articulos,
          buenos: buenos,
          malos: malos,
          regulares: regulares,
          isResumen: false,
        ),
      ),
    ]);
  }
}
