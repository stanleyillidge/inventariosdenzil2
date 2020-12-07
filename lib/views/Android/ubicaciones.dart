import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:inventariosdenzil/styles/inventarios_icons.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:inventariosdenzil/views/Android/subUbicaciones.dart';
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

class AndroidUbicacionesPage extends StatefulWidget {
  AndroidUbicacionesPage(
      {Key key, this.locationCollection, this.location, this.sede})
      : super(key: key);
  final CollectionReference locationCollection;
  final String location;
  final Referencia sede;

  @override
  AndroidUbicacionesPageState createState() => AndroidUbicacionesPageState();
}

class AndroidUbicacionesPageState extends State<AndroidUbicacionesPage>
    with TickerProviderStateMixin {
  void initializeFlutterFire() async {
    if (kIsWeb) {
      // print(['Flutter Web', widget.location]);
      await getData(widget.locationCollection, widget.sede.nombre, 'Web');
    } else if (Platform.isAndroid) {
      // print(['Flutter Android', widget.location]);
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      storage = await Hive.openBox('storage');
      var box = widget.sede.nombre;
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
      // print(['Internet locationst', locationst]);
      local['nombres']['sedes'][widget.sede.nombre]['ubicaciones'] = {};
      local['keys']['sedes'][widget.sede.key]['ubicaciones'] = {};
      await collection.get().then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              // print(doc.data());
              var loc = Locations.fromFirebase(doc.data());
              loc.sede = widget.sede;
              // print(['loc', loc.toJson()]);
              array.add(loc);
              locationst.add(loc.toJson());
              local['nombres']['sedes'][loc.sede.nombre]['ubicaciones']
                  [doc.data()['nombre']] = {};
              local['keys']['sedes'][loc.sede.key]['ubicaciones']
                  [doc.data()['key']] = {};

              local['nombres']['sedes'][loc.sede.nombre]['ubicaciones']
                  [doc.data()['nombre']] = doc.data();
              local['keys']['sedes'][loc.sede.key]['ubicaciones']
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
            // final value = data[ubi];
            print([sede + ' - ' + ubi]);
          }
        }
      } */
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
        'ubicaciones',
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

  getInventario() async {
    // await FirebaseFirestore.instance.collectionGroup('inventario');
    try {
      await FirebaseFirestore.instance
          .collectionGroup('articulos')
          .where('sede', isEqualTo: '-L_YhRmNkVwwNEBkswCH')
          .orderBy('estado', descending: true)
          .limit(10)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  print(['Item nombre: ', doc.data()['nombre']]);
                })
              });
    } catch (e) {
      print(['Error group query', e]);
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    // getInventario();
    isDarkModeEnabled = false;
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
  /* ContadorBar c = ContadorBar(
    fontSize: 12.5,
    isDarkModeEnabled: isDarkModeEnabled,
    total: locations.length,
    titulo: 'ubicaciones',
    location: locations,
    width: 130,
    articulos: articulos,
    buenos: buenos,
    malos: malos,
    regulares: regulares,
    isResumen: false,
  ); */
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // c.valueChangedEvent +
    //     (args) => print('value changed in ubicaciones ${args.changedValue}');
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
            titleSpacing: 0.0,
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
                            'Sede ' + widget.sede.nombre.capitalize(),
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
                  CollectionReference locationCollection = FirebaseFirestore
                      .instance
                      .collection('denzilescolar')
                      .doc(locations[index].sede.nombre)
                      .collection('ubicaciones')
                      .doc(locations[index].ubicacion.nombre)
                      .collection('subUbicaciones');
                  return LocationsCard(
                    fontSize: fontSize,
                    isDarkModeEnabled: isDarkModeEnabled,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AndroidSubUbicacionesPage(
                          locationCollection: locationCollection,
                          location: 'subUbicaciones',
                          sede: locations[index].sede,
                          ubicacion: locations[index].ubicacion,
                        );
                      }));
                    },
                    locationCollection: locationCollection,
                    sede: locations[index].sede,
                    location: 'ubicacion',
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
          fontSize: 12.5,
          isDarkModeEnabled: isDarkModeEnabled,
          total: locations.length,
          titulo: 'ubicaciones',
          location: locations,
          width: 130,
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
