import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:inventariosdenzil/styles/inventarios_icons.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:inventariosdenzil/views/Android/Inventario.dart';
// import 'package:inventariosdenzil/views/Android/subUbicaciones.dart';
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

import '../../styles/extenciones.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference ubicacionsCollection =
    FirebaseFirestore.instance.collection('denzilescolar');

bool isDarkModeEnabled = false;
bool _sideMenuOpen = false;
// bool _storageReady = false;
int articulos = 0;
int buenos = 0;
int malos = 0;
int regulares = 0;
List<Locations> locations = [];
var local = {};
var storage;

class AndroidInventarioSubUbicacionesPage extends StatefulWidget {
  AndroidInventarioSubUbicacionesPage(
      {Key key,
      this.locationCollection,
      this.location,
      this.sede,
      this.ubicacion,
      this.subUbicacion})
      : super(key: key);
  final CollectionReference locationCollection;
  final String location;
  final Referencia subUbicacion;
  final Referencia ubicacion;
  final Referencia sede;
  @override
  AndroidInventarioSubUbicacionesPageState createState() =>
      AndroidInventarioSubUbicacionesPageState();
}

class AndroidInventarioSubUbicacionesPageState
    extends State<AndroidInventarioSubUbicacionesPage>
    with TickerProviderStateMixin {
  List<Locations> locations = [];
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    if (kIsWeb) {
      // print(['Flutter Web', widget.location]);
      await getData(
          widget.locationCollection, widget.subUbicacion.nombre, 'Web');
    } else if (Platform.isAndroid) {
      /* print([
        'Flutter Android',
        widget.location,
        widget.sede.toJson(),
        widget.ubicacion.toJson(),
        widget.subUbicacion.toJson()
      ]); */
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      storage = await Hive.openBox('storage');
      var box = widget.subUbicacion.key + ' - ' + widget.subUbicacion.nombre;
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
      await getData(widget.locationCollection, box, 'Android');
    }
  }

  getData(CollectionReference collection, String box, String plat,
      [int index]) async {
    try {
      List<Locations> array = [];
      var local = await storage.get('local');
      var locationst = [];
      switch (widget.location) {
        case 'inventario':
          local['nombres']['sedes'][widget.sede.nombre]['ubicaciones']
                  [widget.ubicacion.nombre]['subUbicaciones']
              [widget.subUbicacion.nombre]['inventario'] = {};

          local['keys']['sedes'][widget.sede.key]['ubicaciones']
                  [widget.ubicacion.key]['subUbicaciones']
              [widget.subUbicacion.key]['inventario'] = {};
          await collection.get().then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  // print(doc.data());
                  var loc = Locations.fromFirebase(doc.data());
                  loc.sede = widget.sede;
                  loc.ubicacion = widget.ubicacion;
                  loc.subUbicacion = widget.subUbicacion;
                  // print(['loc', loc.toJson()]);
                  array.add(loc);
                  locationst.add(loc.toJson());
                  local['nombres']['sedes'][widget.sede.nombre]['ubicaciones']
                              [widget.ubicacion.nombre]['subUbicaciones']
                          [widget.subUbicacion.nombre]['inventario']
                      [doc.data()['nombre']] = {};
                  local['keys']['sedes'][widget.sede.key]['ubicaciones']
                              [widget.ubicacion.key]['subUbicaciones']
                          [widget.subUbicacion.key]['inventario']
                      [doc.data()['key']] = {};

                  local['nombres']['sedes'][widget.sede.nombre]['ubicaciones']
                              [widget.ubicacion.nombre]['subUbicaciones']
                          [widget.subUbicacion.nombre]['inventario']
                      [doc.data()['nombre']] = doc.data();
                  local['keys']['sedes'][widget.sede.key]['ubicaciones']
                              [widget.ubicacion.key]['subUbicaciones']
                          [widget.subUbicacion.key]['inventario']
                      [doc.data()['key']] = doc.data();
                })
              });
          // print(['Internet locationst', box, locationst]);
          await storage.put(box, locationst);
          await storage.put('local', local);
          // Aqui listo a las ubicaciones de la sede por nombre
          /* final sedes = local['nombres']['sedes'] as Map;
          for (final sede in sedes.keys) {
            // final value = data[sede];
            // print(local['nombres']['sedes'][sede]['ubicaciones']);
            final ubic = local['nombres']['sedes'][sede]['ubicaciones'] as Map;
            print('$sede');
            if (ubic != null) {
              for (final ubi in ubic.keys) {
                final subUbic = local['nombres']['sedes'][sede]['ubicaciones'][ubi]
                    ['subUbicaciones'] as Map;
                print([sede + ' - ' + ubi]);
                if (subUbic != null) {
                  for (final subUbi in subUbic.keys) {
                    final inve = local['nombres']['sedes'][sede]['ubicaciones'][ubi]
                        ['subUbicaciones'][subUbi]['inventario'] as Map;
                    print([sede + ' - ' + ubi + ' - ' + subUbi]);
                    if (inve != null) {
                      for (final inv in inve.keys) {
                        print([sede + ' - ' + ubi + ' - ' + subUbi + ' - ' + inv]);
                      }
                    }
                  }
                }
              }
            }
          } */
          break;
        default:
      }
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
        locations = array;
        articulos = articulos;
        buenos = buenos;
        malos = malos;
        regulares = regulares;
        // _initialized = true;
        // _locationCards = true;
      });
      /* print([
        'location',
        'inventario',
        articulos,
        buenos,
        malos,
        regulares,
        locations.length,
        _initialized
      ]); */
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
    await storage.put('isDark', isDarkModeEnabled);
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
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    // int _selectedItem = 0;
    // final formatter = new NumberFormat("#,###");
    print(['Width', size.width, 'Height', size.height]);
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
            titleSpacing: ('ubicaciones' != 'ubicacions') ? 0.0 : 15.0,
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
                        await storage.put('sideMenuOpen', _sideMenuOpen);
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
                            widget.subUbicacion.nombre.capitalize(),
                            // ('ubicaciones' == 'ubicacions')?'ubicaciones'.capitalize():,
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
                            'Sede ' +
                                widget.sede.nombre.capitalize() +
                                ' - ' +
                                widget.ubicacion.nombre.capitalize(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              color: (isDarkModeEnabled) ? color1 : color3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        /* FittedBox(
                          child: Text(
                            widget.ubicacion.nombre.capitalize(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              color: (isDarkModeEnabled) ? color1 : color3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ), */
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
              height: size.height * 0.715,
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
                  // print(['Articulo', locations[index].toJson()]);
                  CollectionReference locationCollection = FirebaseFirestore
                      .instance
                      .collection('denzilescolar')
                      .doc(locations[index].sede.nombre)
                      .collection('ubicaciones')
                      .doc(locations[index].ubicacion.nombre)
                      .collection('subUbicaciones')
                      .doc(locations[index].subUbicacion.nombre)
                      .collection('inventario')
                      .doc(locations[index].nombre)
                      .collection('articulos');
                  return ResumenCard(
                    fontSize: fontSize,
                    isDarkModeEnabled: isDarkModeEnabled,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AndroidInventarioPage(
                          locationCollection: locationCollection,
                          location: 'articulos',
                          nombre: locations[index].nombre,
                          akey: locations[index].key,
                          sede: locations[index].sede,
                          ubicacion: locations[index].ubicacion,
                          subUbicacion: locations[index].subUbicacion,
                        );
                        // return Test();
                      }));
                    },
                    locationCollection: locationCollection,
                    sede: locations[index].sede,
                    location: 'subUbicaciones',
                    cantidad: locations[index].cantidad,
                    imagen: locations[index].imagen,
                    nombre: locations[index].nombre,
                    buenos: locations[index].buenos,
                    malos: locations[index].malos,
                    regulares: locations[index].regulares,
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
          titulo: 'Articulos unicos',
          location: locations,
          width: 105,
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
