import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
// import 'package:inventariosdenzil/styles/inventarios_icons.dart';
import 'package:inventariosdenzil/styles/styles.dart';
// import 'package:inventariosdenzil/widgets/bottomNavigationBar.dart';
import 'package:inventariosdenzil/widgets/models.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/sidemenu.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference sedesCollection =
    FirebaseFirestore.instance.collection('denzilescolar');

bool isDarkModeEnabled = false;
bool _sideMenuOpen = false;
// bool _storageReady = false;
List<Locations> sedes = [];
var storage;

class WebPage extends StatefulWidget {
  WebPage({Key key, this.location}) : super(key: key);
  final String location;

  @override
  WebPageState createState() => WebPageState();
}

class WebPageState extends State<WebPage> with TickerProviderStateMixin {
  // @override
  // AnimationController _animationController;
  // Animation _animation;
  bool _initialized = false;
  // bool _resumenCards = false;
  bool _locationCards = false;
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
      print('Flutter Web');
      await getData(sedesCollection, locations, 'sedes', 'Web');
    } else if (Platform.isAndroid) {
      print('Flutter Android');
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      await getData(sedesCollection, locations, 'sedes', 'Android');
    }
    /* setState(() {
      locations = locations;
      _initialized = true;
      _locationCards = true;
      print(['location', locations.length, _initialized]);
    }); */
  }

  getData(CollectionReference collection, List array, String box, String plat,
      [int index]) async {
    try {
      storage = await Hive.openBox('storage');
      // _storageReady = true;
      var locationst = await storage.get(box);
      if ((locationst != null) && (locationst.length > 0)) {
        locationst.forEach((sedet) {
          print(['sedet', sedet]);
          array.add(Locations.fromLocal(sedet));
        });
        print(['Local locationst', locationst]);
      } else {
        locationst = [];
        // print(['Internet locationst', locationst]);
        collection.get().then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                // print(doc.data());
                var loc = Locations.fromFirebase(doc.data());
                if (index != null) {
                  switch (loc.location) {
                    case 'ubicacion':
                      loc.sede.nombre = locations[index].nombre;
                      break;
                    case 'subUbicacion':
                      loc.sede.nombre = locations[index].sede.nombre;
                      loc.ubicacion.nombre = locations[index].ubicacion.nombre;
                      break;
                    default:
                  }
                }
                // print(['loc', loc.toJson()]);
                array.add(loc);
                locationst.add(loc.toJson());
              })
            });
        print(['Internet locationst', box, locationst]);
        await storage.put(box, locationst);
      }
      setState(() {
        locations = array;
        _initialized = true;
        _locationCards = true;
        print(['location', widget.location, locations.length]);
      });
      return array;
    } catch (e) {
      print(['Error Flutter ' + plat + ' despues de iniciar firabase', e]);
      setState(() {
        // _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    // _animationController =
    //     AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    // _animation = IntTween(begin: 0, end: 1).animate(_animationController);
    // _animation.addListener(() => setState(() {}));
  }

  void onStateChanged(bool isDarkModeEnabled2) async {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
    });
    await storage.put('isDark', isDarkModeEnabled);
  }

  double _pheight = 0.09;
  double _pfontSize = 0.031;
  double _locationsCardsWidt = 300;
  // double _locationsCardsHeight = 120;
  double aspr = 0;
  double aspr2 = 0;
  String text = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double fontSize = 15;
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    // int _selectedItem = 0;
    print(['Width', size.width, 'Height', size.height]);
    return LayoutBuilder(
      builder: (context, constraints) {
        final formatter = new NumberFormat("#,###");
        return Container(
          color:
              (isDarkModeEnabled) ? color3.withOpacity(0.98) : Colors.grey[100],
          child: Stack(
            children: [
              // Titulo y SubTitulo
              Padding(
                padding: (size.width < 560)
                    ? const EdgeInsets.only(left: 10.0, top: 35.0, right: 10)
                    : const EdgeInsets.only(left: 90.0, top: 35.0, right: 10),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 55.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (size.width < 560)
                            ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _sideMenuOpen = !_sideMenuOpen;
                                  });
                                  await storage.put(
                                      'sideMenuOpen', _sideMenuOpen);
                                  // await _SideMenuState()._playAnimation2();
                                  await SideMenu.staticGlobalKey.currentState
                                      .playAnimation();
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 15.0, right: 15),
                                  child: Container(
                                    decoration: (isDarkModeEnabled)
                                        ? circleNeumorpDecorationBlack
                                        : circleNeumorpDecorationWhite,
                                    child: Image.asset(
                                      'assets/logo.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                "Inventario",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
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
                                  fontSize: 15,
                                  color: (isDarkModeEnabled) ? color1 : color3,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Info - Buenos- Malos - Regulares
              Padding(
                padding: (size.width < 940)
                    ? (size.width < 560)
                        ? const EdgeInsets.only(
                            left: 2.5, top: 40.0, right: 2.5)
                        : const EdgeInsets.only(left: 80, top: 40.0, right: 10)
                    : const EdgeInsets.only(left: 390.0, top: 0.0, right: 10),
                child: SizedBox(
                  height: (size.width >= 940) ? 60 : 120,
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: (size.width < 560)
                            ? (size.width * _pheight)
                            : 50, // (size.width * _pheight)
                        decoration: (isDarkModeEnabled)
                            ? infoDecorationBlack
                            : infoDecorationWhite,
                        child: Center(
                          child: Padding(
                            padding: (size.width < 560)
                                ? const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 3.0,
                                    bottom: 3.0)
                                : const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 5.0,
                                    bottom: 5.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      locations.length.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color5,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      "Sedes",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color4
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: (size.width < 560) ? 10 : 20,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      formatter.format(6560),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color5,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      "Articulos",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color4
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height:
                            (size.width < 560) ? (size.width * _pheight) : 50,
                        decoration: (isDarkModeEnabled)
                            ? infoDecorationBlack
                            : infoDecorationWhite,
                        child: Center(
                          child: Padding(
                            padding: (size.width < 560)
                                ? const EdgeInsets.only(
                                    left: 5.0,
                                    right: 10.0,
                                    top: 3.0,
                                    bottom: 3.0)
                                : const EdgeInsets.only(
                                    left: 5.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 8,
                                  height: (size.width < 560)
                                      ? (size.width * _pheight) -
                                          ((size.width * _pheight) * 0.25)
                                      : 40,
                                  decoration: BoxDecoration(
                                    color:
                                        (isDarkModeEnabled) ? buenosB : buenosW,
                                    // borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      formatter.format(6560),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      "Buenos",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height:
                            (size.width < 560) ? (size.width * _pheight) : 50,
                        decoration: (isDarkModeEnabled)
                            ? infoDecorationBlack
                            : infoDecorationWhite,
                        child: Center(
                          child: Padding(
                            padding: (size.width < 560)
                                ? const EdgeInsets.only(
                                    left: 5.0,
                                    right: 10.0,
                                    top: 3.0,
                                    bottom: 3.0)
                                : const EdgeInsets.only(
                                    left: 5.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 8,
                                  height: (size.width < 560)
                                      ? (size.width * _pheight) -
                                          ((size.width * _pheight) * 0.25)
                                      : 40,
                                  decoration: BoxDecoration(
                                    color:
                                        (isDarkModeEnabled) ? malosW : malosW,
                                    // borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      formatter.format(6560),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      "Malos",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height:
                            (size.width < 560) ? (size.width * _pheight) : 50,
                        decoration: (isDarkModeEnabled)
                            ? infoDecorationBlack
                            : infoDecorationWhite,
                        child: Center(
                          child: Padding(
                            padding: (size.width < 560)
                                ? const EdgeInsets.only(
                                    left: 5.0,
                                    right: 10.0,
                                    top: 3.0,
                                    bottom: 3.0)
                                : const EdgeInsets.only(
                                    left: 5.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 8,
                                  height: (size.width < 560)
                                      ? (size.width * _pheight) -
                                          ((size.width * _pheight) * 0.25)
                                      : 40,
                                  decoration: BoxDecoration(
                                    color: (isDarkModeEnabled)
                                        ? regularesB
                                        : regularesW,
                                    // borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      formatter.format(6560),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      "Regulares",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: (size.width < 560)
                                            ? (size.width * _pfontSize)
                                            : fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // DayNightSwitcherIcon
              Positioned(
                right: 10,
                top: 25,
                child: DayNightSwitcherIcon(
                  isDarkModeEnabled: isDarkModeEnabled,
                  onStateChanged: onStateChanged,
                ),
              ),
              // contenido
              // locations card
              (_initialized && _locationCards)
                  ? Positioned(
                      top: (size.width >= 940) ? 80 : 130,
                      left: (size.width >= 940)
                          ? 90
                          : (size.width >= 560)
                              ? 90
                              : 10,
                      right: 10,
                      child: Container(
                        width: size.width * 0.9,
                        height: size.height * 0.715,
                        child: WaterfallFlow.builder(
                          padding: const EdgeInsets.all(5.0),
                          gridDelegate:
                              SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ((size.width ~/ _locationsCardsWidt) == null ||
                                        (size.width ~/ _locationsCardsWidt) <=
                                            0)
                                    ? 1
                                    : (size.width ~/ _locationsCardsWidt),
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (BuildContext c, int index) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: (isDarkModeEnabled)
                                  ? loCardDecorationBlack
                                  : loCardDecorationWhite,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var location;
                                      var sede;
                                      var ubicacion;
                                      // var subUbicacion;
                                      CollectionReference locationCollection;
                                      if ((locations[index].sede == null) &&
                                          (locations[index].ubicacion ==
                                              null) &&
                                          (locations[index].subUbicacion ==
                                              null)) {
                                        location = 'sede';
                                        sede = locations[index].key;
                                        if ((locations[index].sede != null) &&
                                            (locations[index].ubicacion ==
                                                null) &&
                                            (locations[index].subUbicacion ==
                                                null)) {
                                          location = 'ubicacion';
                                          sede = locations[index].sede.nombre;
                                          ubicacion = locations[index].key;
                                          locationCollection = FirebaseFirestore
                                              .instance
                                              .collection('denzilescolar')
                                              .doc(sede)
                                              .collection('ubicaciones');
                                          if ((locations[index].sede != null) &&
                                              (locations[index].ubicacion !=
                                                  null) &&
                                              (locations[index].subUbicacion ==
                                                  null)) {
                                            location = 'subUbicacion';
                                            sede = locations[index].sede.nombre;
                                            ubicacion = locations[index]
                                                .ubicacion
                                                .nombre;
                                            // subUbicacion = locations[index].key;
                                            locationCollection =
                                                FirebaseFirestore
                                                    .instance
                                                    .collection('denzilescolar')
                                                    .doc(sede)
                                                    .collection('ubicaciones')
                                                    .doc(ubicacion)
                                                    .collection(
                                                        'subUbicaciones');
                                          }
                                        }
                                      }
                                      if (kIsWeb) {
                                        print('Flutter Web');
                                        await getData(locationCollection,
                                            locations, location, 'Web');
                                      } else if (Platform.isAndroid) {
                                        print('Flutter Android');
                                        await getData(locationCollection,
                                            locations, location, 'Android');
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: (locations[index].imagen !=
                                              '/assets/shapes.svg')
                                          ? Image.network(
                                              locations[index].imagen)
                                          : Image.asset('assets/shapes2.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, top: 5.0),
                                    child: Column(
                                      children: [
                                        // Tipo de locacion y opciones
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Sede",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: (size.width < 560)
                                                    ? (size.width *
                                                            _pfontSize) *
                                                        1.25
                                                    : fontSize,
                                                color: (isDarkModeEnabled)
                                                    ? color4.withOpacity(0.5)
                                                    : color3.withOpacity(0.5),
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            Icon(Icons.more)
                                          ],
                                        ),
                                        // Nombre y cantidades
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                locations[index].nombre,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: (size.width < 560)
                                                      ? (size.width *
                                                              _pfontSize) *
                                                          1.25
                                                      : fontSize,
                                                  color: (isDarkModeEnabled)
                                                      ? color4
                                                      : color3,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              formatter.format(
                                                  locations[index].cantidad),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: (size.width < 560)
                                                    ? (size.width *
                                                            _pfontSize) *
                                                        2
                                                    : fontSize,
                                                color: (isDarkModeEnabled)
                                                    ? color1
                                                    : Colors.black,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: locations.length,
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()),
                    ),
              /* // resumen card
              Positioned(
                // top: (size.width > 559)
                //     ? (size.height * 0.45)
                //     : (size.height * 0.45 + 140),
                // left: (size.width > 559) ? 80 : 20,
                top: (size.width >= 940) ? 80 : 140,
                left: (size.width >= 940)
                    ? 90
                    : (size.width >= 560)
                        ? 90
                        : 10,
                right: 10,
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.9,
                  /* child: GridView.count(
                    primary: false,
                    padding: (size.width >= 940)
                        ? const EdgeInsets.only(left: 10, right: 10, bottom: 10)
                        : (size.width >= 560)
                            ? const EdgeInsets.only(
                                top: 60, left: 10, right: 10, bottom: 10)
                            : const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: aspr2,
                    crossAxisCount: (size.width / _locationsCardsWidt).round(),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Column(
                            children: [
                              // Nombre y cantidades
                              Expanded(
                                child: Text(
                                  "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _fontSize,
                                    color:
                                        (isDarkModeEnabled) ? color1 : color3,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? buenosB
                                              : buenosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Buenos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? malosW
                                              : malosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Malos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? regularesB
                                              : regularesW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Regulares",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    child: Text(
                                      formatter.format(9352),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (aspr > 1.1) ? 26 : 20,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Column(
                            children: [
                              // Nombre y cantidades
                              Expanded(
                                child: Text(
                                  "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color:
                                        (isDarkModeEnabled) ? color1 : color3,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? buenosB
                                              : buenosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Buenos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? malosW
                                              : malosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Malos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? regularesB
                                              : regularesW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Regulares",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    child: Text(
                                      formatter.format(9352),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (aspr > 1.1) ? 26 : 20,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Column(
                            children: [
                              // Nombre y cantidades
                              Expanded(
                                child: Text(
                                  "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color:
                                        (isDarkModeEnabled) ? color1 : color3,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? buenosB
                                              : buenosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Buenos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? malosW
                                              : malosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Malos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15,
                                          color: (isDarkModeEnabled)
                                              ? regularesB
                                              : regularesW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Regulares",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    child: Text(
                                      formatter.format(9352),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (aspr > 1.1) ? 26 : 20,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ), */
                  /* child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ((size.width ~/ _locationsCardsWidt) == null ||
                                  (size.width ~/ _locationsCardsWidt) <= 0)
                              ? 1
                              : (size.width ~/ _locationsCardsWidt),
                      crossAxisSpacing:
                          (size.width ~/ _locationsCardsWidt) + 0.0,
                      mainAxisSpacing:
                          (size.width ~/ _locationsCardsWidt) + 0.0,
                      childAspectRatio:
                          (size.aspectRatio > 1) // ojo ajustar desde aqui
                              ? size.aspectRatio
                              : 1 / size.aspectRatio,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Column(
                            children: [
                              // Nombre y cantidades
                              Expanded(
                                child: Text(
                                  "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _fontSize,
                                    color:
                                        (isDarkModeEnabled) ? color1 : color3,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _fontSize,
                                          /* fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15, */
                                          color: (isDarkModeEnabled)
                                              ? buenosB
                                              : buenosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Buenos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: _fontSize,
                                          /* fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13, */
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _fontSize,
                                          /* fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15, */
                                          color: (isDarkModeEnabled)
                                              ? malosW
                                              : malosW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Malos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: _fontSize,
                                          /* fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13, */
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        formatter.format(6560),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _fontSize,
                                          /* fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 15, */
                                          color: (isDarkModeEnabled)
                                              ? regularesB
                                              : regularesW,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        "Regulares",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: _fontSize,
                                          /* fontSize: (size.width < 560)
                                              ? (size.width * _pfontSize)
                                              : 13, */
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    child: Text(
                                      formatter.format(9352),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _fontSize,
                                        // fontSize: (aspr > 1.1) ? 26 : 20,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : Colors.black,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ), */
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
                      double _fontSize = 12;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                // Nombre y cantidades
                                Expanded(
                                  child: Text(
                                    '$index ' +
                                        'TestString' * 10 * (index % 4 + 1),
                                    // "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _fontSize,
                                      color:
                                          (isDarkModeEnabled) ? color1 : color3,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '6560',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize,
                                            /* fontSize: (size.width < 560)
                                                          ? (size.width * _pfontSize)
                                                          : 15, */
                                            color: (isDarkModeEnabled)
                                                ? buenosB
                                                : buenosW,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Text(
                                          "Buenos",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: _fontSize,
                                            /* fontSize: (size.width < 560)
                                                          ? (size.width * _pfontSize)
                                                          : 13, */
                                            color: (isDarkModeEnabled)
                                                ? color1
                                                : color3,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '6560',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize,
                                            /* fontSize: (size.width < 560)
                                                          ? (size.width * _pfontSize)
                                                          : 15, */
                                            color: (isDarkModeEnabled)
                                                ? malosW
                                                : malosW,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Text(
                                          "Malos",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: _fontSize,
                                            /* fontSize: (size.width < 560)
                                                          ? (size.width * _pfontSize)
                                                          : 13, */
                                            color: (isDarkModeEnabled)
                                                ? color1
                                                : color3,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '6560',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize,
                                            /* fontSize: (size.width < 560)
                                                          ? (size.width * _pfontSize)
                                                          : 15, */
                                            color: (isDarkModeEnabled)
                                                ? regularesB
                                                : regularesW,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        Text(
                                          "Regulares",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: _fontSize,
                                            /* fontSize: (size.width < 560)
                                                          ? (size.width * _pfontSize)
                                                          : 13, */
                                            color: (isDarkModeEnabled)
                                                ? color1
                                                : color3,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                    FittedBox(
                                      child: Text(
                                        '9352',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          // fontSize: (aspr > 1.1) ? 26 : 20,
                                          color: (isDarkModeEnabled)
                                              ? color1
                                              : Colors.black,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 35,
                  ),
                ),
              ), */
              /* // articulo card
              Positioned(
                top: (size.width >= 940) ? 80 : 140,
                left: (size.width >= 940)
                    ? 90
                    : (size.width >= 560)
                        ? 90
                        : 10,
                right: 10,
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.9,
                  /* child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount:
                          ((size.width ~/ _locationsCardsWidt) == null ||
                                  (size.width ~/ _locationsCardsWidt) <= 0)
                              ? 1
                              : (size.width ~/ _locationsCardsWidt),
                      crossAxisSpacing:
                          (size.width ~/ _locationsCardsWidt) + 0.0,
                      mainAxisSpacing:
                          (size.width ~/ _locationsCardsWidt) + 0.0,
                      height: _locationsCardsHeight, //48 dp of height
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 1.5, right: 1.5, top: 1.5, bottom: 1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre y cantidades
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                child: Image.asset(
                                  'assets/pupitre.jpg',
                                  scale: 1.8, // -(size.aspectRatio * 0.003),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: _fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                      width: 5,
                                    ),
                                    Text(
                                      "Bueno",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: (isDarkModeEnabled)
                                            ? buenosB
                                            : buenosW,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                      width: 5,
                                    ),
                                    Text(
                                      "Celia Catalina de Lopez\nAulas de clases\nAula - 01",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color4
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ), */
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
                      double _fontSize = 12;
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: (isDarkModeEnabled)
                            ? loCardDecorationBlack
                            : loCardDecorationWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 1.5, right: 1.5, top: 1.5, bottom: 1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre y cantidades
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                child: Image.asset(
                                  'assets/pupitre.jpg',
                                  scale: 1.8, // -(size.aspectRatio * 0.003),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$index ' +
                                          'TestString' * 2 * (index % 4 + 1),
                                      // "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: _fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color1
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                      width: 5,
                                    ),
                                    Text(
                                      "Bueno",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: (isDarkModeEnabled)
                                            ? buenosB
                                            : buenosW,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                      width: 5,
                                    ),
                                    Text(
                                      "Celia Catalina de Lopez\nAulas de clases\nAula - 01",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _fontSize,
                                        color: (isDarkModeEnabled)
                                            ? color4
                                            : color3,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 35,
                  ),
                ),
              ), */
              (size.width > 559)
                  ? Positioned(
                      top: 20,
                      bottom: 20,
                      left: 10,
                      // right: (size.width * 0.9),
                      child: SideMenu(),
                    )
                  : Positioned(
                      top: 85,
                      bottom: 100,
                      left: 0,
                      // right: (size.width * 0.9),
                      child: SideMenu(),
                    ),
              (size.width < 560)
                  ? Positioned(
                      bottom: 10,
                      left: (size.width * 0.02),
                      right: (size.width * 0.02),
                      child: Container(),
                      /* BottomNavigationBar(
                        iconList: [
                          Icons.home,
                          Icons.add_shopping_cart,
                          Icons.save_alt,
                          Icons.person,
                        ],
                        onChange: (val) {
                          setState(() {
                            _selectedItem = val;
                          });
                        },
                        defaultSelectedIndex: 0,
                      ), */
                    )
                  : Container(),
              (size.width < 560)
                  ? Positioned(
                      bottom: 65,
                      left: (size.width * 0.4),
                      right: (size.width * 0.4),
                      child: RawMaterialButton(
                        onPressed: () async {
                          String barcode = await scanner.scan();
                          print(['barcode', barcode]);
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                            }),
                          ); */
                        },
                        elevation: 20.0,
                        fillColor: (isDarkModeEnabled) ? color4 : color5,
                        child: Icon(
                          // Inventarios.qr_code_2,
                          Icons.qr_code_scanner,
                          color: (isDarkModeEnabled) ? color3 : color4,
                          size: 35.0,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
