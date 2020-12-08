import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

// import 'package:validators/validators.dart' as validator;
import 'package:inventariosdenzil/styles/inventarios_icons.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:inventariosdenzil/widgets/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../styles/extenciones.dart';
import 'package:qrscan/qrscan.dart' as scanner;

// Articulo articulo = Articulo();
bool isDarkModeEnabled;
bool isDataLoad;
int total = 0;
int buenos = 0;
int malos = 0;
int regulares = 0;
var local = {};
var storage;

class ArticuloPage extends StatefulWidget {
  ArticuloPage({Key key, this.akey, this.articulo}) : super(key: key);
  final String akey;
  final Articulo articulo;

  @override
  _ArticuloPageState createState() => _ArticuloPageState();
}

class _ArticuloPageState extends State<ArticuloPage> {
  File _image;
  String _sede;
  String _ubicacion;
  String _subUbicacion;
  String _estado;
  var _nombre = TextEditingController();
  var _serie = TextEditingController();
  var _valor = TextEditingController();
  var _descripcion = TextEditingController();
  List<String> _estadoList = ['Bueno', 'Malo', 'Regular'];
  List<Referencia> _sedeList = [];
  List<Referencia> _ubicacionList = [];
  List<Referencia> _subUbicacionList = [];
  // Define an async function to initialize FlutterFire
  /* void initializeFlutterFire2() async {
    if (kIsWeb) {
      // print(['Flutter Web', widget.location]);
    } else if (Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      storage = await Hive.openBox('storage');
      var localt = await storage.get('local');
      if (localt != null) {
        local = localt;
        final sedes = local['nombres']['sedes'] as Map;
        for (final sede in sedes.keys) {
          // final value = data[sede];
          // print(local['nombres']['sedes'][sede]['ubicaciones']);
          final ubic = local['nombres']['sedes'][sede]['ubicaciones'] as Map;
          // print('$sede');
          _sedeList.add(sede);
          if (ubic != null) {
            for (final ubi in ubic.keys) {
              final subUbic = local['nombres']['sedes'][sede]['ubicaciones']
                  [ubi]['subUbicaciones'] as Map;
              // print([sede + ' - ' + ubi]);
              _ubicacionList.add(ubi);
              if (subUbic != null) {
                for (final subUbi in subUbic.keys) {
                  print([sede + ' - ' + ubi + ' - ' + subUbi]);
                  _subUbicacionList.add(subUbi);
                }
              }
            }
          }
        }
      }
      var articulot = await storage.get(widget.akey);
      if ((articulot != null)) {
        setState(() {
          articulo = widget.articulo.fromLocal(articulot);
          _estado.text = widget.articulo.estado;
          _nombre.text = widget.articulo.nombre;
          _sede = widget.articulo.sede.nombre;
          _ubicacion = widget.articulo.ubicacion.nombre;
          _subUbicacion = widget.articulo.subUbicacion.nombre;
          _serie.text = widget.articulo.serie;
          _valor.text = widget.articulo.valor.toString();
          _descripcion.text = widget.articulo.descripcion;
          isDataLoad = true;
        });
        print(widget.articulo.toJson());
      }
    }
  } */
  void initializeFlutterFire() async {
    if (kIsWeb) {
      // print(['Flutter Web', widget.location]);
    } else if (Platform.isAndroid) {
      // final dir = await getApplicationDocumentsDirectory();
      // Hive.init(dir.path);
      // storage = await Hive.openBox('storage');
      // var localt = await storage.get('local');
      /* if (localt != null) {
        local = localt;
        final sedes = local['nombres']['sedes'] as Map;
        for (final sede in sedes.keys) {
          _sedeList.add(sede);
        }
        final ubic = local['nombres']['sedes'][widget.articulo.sede.nombre]
            ['ubicaciones'] as Map;
        if (ubic != null) {
          for (final ubi in ubic.keys) {
            // print([sede + ' - ' + ubi]);
            _ubicacionList.add(ubi);
          }
        }
        final subUbic = local['nombres']['sedes'][widget.articulo.sede.nombre]
                ['ubicaciones'][widget.articulo.ubicacion.nombre]
            ['subUbicaciones'] as Map;
        if (subUbic != null) {
          for (final subUbi in subUbic.keys) {
            /* print([
              widget.articulo.sede.nombre +
                  ' - ' +
                  widget.articulo.ubicacion.nombre +
                  ' - ' +
                  subUbi
            ]); */
            _subUbicacionList.add(subUbi);
          }
        }
      } */
      await FirebaseFirestore.instance
          .collection('sedes')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  // print(doc.data());
                  var loc = Locations.fromFirebase(doc.data());
                  // loc.sede = Referencia(nombre: loc.nombre, key: loc.sede.key);
                  // print(loc.sede.nombre);
                  _sedeList.add(loc.sede);
                })
              });
      await FirebaseFirestore.instance
          .collection('sedes')
          .doc(widget.articulo.sede.key)
          .collection('ubicaciones')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  // print(doc.data());
                  var loc = Locations.fromFirebase(doc.data());
                  // loc.sede = Referencia(
                  //     nombre: widget.articulo.sede.nombre, key: loc.sede.key);
                  // var ubicacion = loc.ubicacion.nombre;
                  // print(loc.ubicacion.nombre);
                  _ubicacionList.add(loc.ubicacion);
                })
              });
      await FirebaseFirestore.instance
          .collection('sedes')
          .doc(widget.articulo.sede.key)
          .collection('ubicaciones')
          .doc(widget.articulo.ubicacion.key)
          .collection('subUbicaciones')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  // print(doc.data());
                  var loc = Locations.fromFirebase(doc.data());
                  // loc.sede = Referencia(
                  //     nombre: widget.articulo.sede.nombre, key: loc.sede.key);
                  // loc.ubicacion = Referencia(
                  //     nombre: widget.articulo.ubicacion.nombre,
                  //     key: loc.ubicacion.key);
                  // var subUbicacion = loc.subUbicacion.nombre;
                  // print(loc.subUbicacion.nombre);
                  _subUbicacionList.add(loc.subUbicacion);
                })
              });
      setState(() {
        // articulo = widget.articulo.fromLocal(articulot);
        _sede = widget.articulo.sede.key;
        _ubicacion = widget.articulo.ubicacion.key;
        _subUbicacion = widget.articulo.subUbicacion.key;
        _estado = widget.articulo.estado;
        _nombre.text = widget.articulo.nombre;
        _serie.text = widget.articulo.serie;
        _valor.text = widget.articulo.valor.toString();
        _descripcion.text = widget.articulo.descripcion;
        _sedeList = _sedeList;
        isDataLoad = true;
      });
      print([_sede, _ubicacion, _subUbicacion]);
      // print(widget.articulo.toJson());
    }
  }

  change(String sede, [String ubicacion]) async {
    print(['sede', sede, 'ubicacion', ubicacion]);
    if (_sede != sede) {
      _ubicacionList = [];
      await FirebaseFirestore.instance
          .collection('sedes')
          .doc(sede)
          .collection('ubicaciones')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  // print(doc.data());
                  var loc = Locations.fromFirebase(doc.data());
                  // loc.sede = Referencia(nombre: sede, key: loc.sede.key);
                  // var ubicacion = loc.ubicacion.nombre;
                  _ubicacionList.add(loc.ubicacion);

                  // if (local['nombres']['sedes'][loc.sede.nombre]['ubicaciones'] ==
                  //     null) {
                  //   local['nombres']['sedes'][loc.sede.nombre]
                  //       ['ubicaciones'] = {};
                  //   local['keys']['sedes'][loc.sede.key]['ubicaciones'] = {};
                  // }

                  // local['nombres']['sedes'][loc.sede.nombre]['ubicaciones']
                  //     [doc.data()['nombre']] = {};
                  // local['keys']['sedes'][loc.sede.key]['ubicaciones']
                  //     [doc.data()['key']] = {};

                  // local['nombres']['sedes'][loc.sede.nombre]['ubicaciones']
                  //     [doc.data()['nombre']] = doc.data();
                  // local['keys']['sedes'][loc.sede.key]['ubicaciones']
                  //     [doc.data()['key']] = doc.data();
                })
              });
    }
    if (ubicacion != null) {
      _subUbicacionList = [];
      await FirebaseFirestore.instance
          .collection('sedes')
          .doc(sede)
          .collection('ubicaciones')
          .doc(ubicacion)
          .collection('subUbicaciones')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  // print(doc.data());
                  var loc = Locations.fromFirebase(doc.data());
                  // loc.sede = Referencia(nombre: sede, key: loc.sede.key);
                  // loc.ubicacion =
                  //     Referencia(nombre: ubicacion, key: loc.ubicacion.key);
                  // var subUbicacion = loc.subUbicacion.nombre;
                  // print(subUbicacion);
                  _subUbicacionList.add(loc.subUbicacion);

                  // if (local['nombres']['sedes'][loc.sede.nombre]['ubicaciones']
                  //         [loc.ubicacion.nombre]['subUbicaciones'] ==
                  //     null) {
                  //   local['nombres']['sedes'][loc.sede.nombre]['ubicaciones']
                  //       [loc.ubicacion.nombre]['subUbicaciones'] = {};

                  //   local['keys']['sedes'][loc.sede.key]['ubicaciones']
                  //       [loc.ubicacion.key]['subUbicaciones'] = {};
                  // }

                  // local['nombres']['sedes'][sede]['ubicaciones'][ubicacion]
                  //     ['subUbicaciones'][doc.data()['nombre']] = {};
                  // local['keys']['sedes'][loc.sede.key]['ubicaciones']
                  //         [loc.ubicacion.key]['subUbicaciones']
                  //     [doc.data()['key']] = {};

                  // local['nombres']['sedes'][sede]['ubicaciones'][ubicacion]
                  //     ['subUbicaciones'][doc.data()['nombre']] = doc.data();
                  // local['keys']['sedes'][loc.sede.key]['ubicaciones']
                  //         [loc.ubicacion.key]['subUbicaciones']
                  //     [doc.data()['key']] = doc.data();
                })
              });
    }
    // await storage.put('local', local);
    setState(() {
      _ubicacionList = _ubicacionList;
      _subUbicacionList = _subUbicacionList;
    });
    // print(['_ubicacion', _ubicacionList]);
    // print(['_subUbicacion', _subUbicacionList]);
  }

  @override
  void initState() {
    isDataLoad = false;
    initializeFlutterFire();
    super.initState();
    isDarkModeEnabled = false;
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = 12.5;
    return Scaffold(
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
                    onTap: () async {},
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (isDataLoad)
                              ? widget.articulo.nombre.capitalize()
                              : 'Articulo',
                          // ('ubicaciones' == 'ubicacions')?'ubicaciones'.capitalize():,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize * 1.1,
                            color: (isDarkModeEnabled) ? color4 : color5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            (isDataLoad)
                                ? widget.articulo.subUbicacion.nombre
                                    .capitalize()
                                : 'subUbicacion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              color: (isDarkModeEnabled) ? color1 : color3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            (isDataLoad)
                                ? 'Sede ' +
                                    widget.articulo.sede.nombre.capitalize() +
                                    ' - ' +
                                    widget.articulo.ubicacion.nombre
                                        .capitalize()
                                : 'Sede - Ubicacion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              color: (isDarkModeEnabled) ? color1 : color3,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: (isDataLoad)
          ? Container(
              color:
                  (isDarkModeEnabled) ? color3.withOpacity(0.98) : Colors.white,
              child: ListView(
                // padding: const EdgeInsets.all(8),
                children: <Widget>[
                  GestureDetector(
                    onTap: getImage,
                    child: ClipRRect(
                      child: _image != null
                          ? Image.file(_image)
                          : (widget.articulo.imagen != null)
                              // ? Image.network(widget.articulo.imagen)
                              ? CachedNetworkImage(
                                  // fit: BoxFit.scaleDown, height: 90,
                                  // width: 150,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: widget.articulo.imagen,
                                )
                              : Image.asset('assets/shapes2.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _nombre,
                      maxLines: (_nombre.text.length > 30)
                          ? (_nombre.text.length / 30).ceil()
                          : 1,
                      decoration: InputDecoration(
                        icon: Icon(Inventarios.box_1),
                        hintText: 'Nombre',
                        contentPadding: EdgeInsets.all(15.0),
                        // border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      obscureText: false,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        widget.articulo.nombre = value;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ListTile(
                          // visualDensity: VisualDensity.compact,
                          // dense: true,
                          horizontalTitleGap: 1,
                          leading: const Icon(Icons.label),
                          title: const Text('Sede'),
                          // subtitle: const Text('None'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          width: 190,
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _sede,
                                  isDense: true,
                                  onChanged: (String newValue) async {
                                    setState(() {
                                      _subUbicacion = null;
                                      _ubicacion = null;
                                      _sede = newValue;
                                      state.didChange(newValue);
                                    });
                                    await change(newValue);
                                  },
                                  hint: FittedBox(
                                      child: Text('Seleciona una sede',
                                          style: TextStyle(color: Colors.red))),
                                  items: _sedeList.map((Referencia value) {
                                    return DropdownMenuItem<String>(
                                      value: value.key,
                                      child:
                                          FittedBox(child: Text(value.nombre)),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ListTile(
                          // visualDensity: VisualDensity.compact,
                          // dense: true,
                          horizontalTitleGap: 1,
                          leading: const Icon(Icons.label),
                          title: const Text('Ubicacion'),
                          // subtitle: const Text('None'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          width: 190,
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _ubicacion,
                                  isDense: true,
                                  onChanged: (String newValue) async {
                                    setState(() {
                                      _subUbicacion = null;
                                      _ubicacion = newValue;
                                      state.didChange(newValue);
                                    });
                                    await change(_sede, newValue);
                                    print([
                                      'Listo sub',
                                      _subUbicacionList.toList()
                                    ]);
                                  },
                                  hint: FittedBox(
                                      child: Text('Seleciona una ubicacion',
                                          style: TextStyle(color: Colors.red))),
                                  items: _ubicacionList
                                      .map((Referencia ubicacion) {
                                    return DropdownMenuItem<String>(
                                      value: ubicacion.key,
                                      child: FittedBox(
                                          child: Text(ubicacion.nombre)),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ListTile(
                          // visualDensity: VisualDensity.compact,
                          // dense: true,
                          horizontalTitleGap: 1,
                          leading: const Icon(Icons.label),
                          title: FittedBox(child: Text('SubUbicacion')),
                          // subtitle: const Text('None'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          width: 190,
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _subUbicacion,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _subUbicacion = newValue;
                                      state.didChange(newValue);
                                    });
                                    print([
                                      'SubUbic Despues',
                                      widget.articulo.subUbicacion.toJson()
                                    ]);
                                  },
                                  hint: FittedBox(
                                      child: Text('Seleciona una subUbicacion',
                                          style: TextStyle(color: Colors.red))),
                                  items:
                                      _subUbicacionList.map((Referencia value) {
                                    return DropdownMenuItem<String>(
                                      value: value.key,
                                      child:
                                          FittedBox(child: Text(value.nombre)),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ListTile(
                          // visualDensity: VisualDensity.compact,
                          // dense: true,
                          horizontalTitleGap: 1,
                          leading: const Icon(Icons.label),
                          title: Text(
                            'Estado',
                            style: TextStyle(fontSize: 16.5),
                          ),
                          // subtitle: const Text('None'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          width: 190,
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _estado,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _estado = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _estadoList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: FittedBox(child: Text(value)),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _serie,
                      decoration: InputDecoration(
                        icon: Icon(Inventarios.barcode),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            String barcode = await scanner.scan();
                            print(['barcode', barcode]);
                            setState(() {
                              _serie.text = barcode;
                            });
                          },
                          icon: Icon(Icons.add_box),
                        ),
                        hintText: 'Serial',
                        contentPadding: EdgeInsets.all(15.0),
                        // border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      obscureText: false,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Digite el serial del equipo';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        widget.articulo.nombre = value;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _valor,
                      inputFormatters: [NumericTextFormatter()],
                      decoration: InputDecoration(
                        icon: Icon(Icons.monetization_on_outlined),
                        hintText: 'Valor',
                        contentPadding: EdgeInsets.all(15.0),
                        // border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      obscureText: false,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Digite el serial del equipo';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        widget.articulo.nombre = value;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _descripcion,
                      // maxLines: 2,
                      decoration: InputDecoration(
                        icon: Icon(Inventarios.iconfinder_copy_728927),
                        hintText: 'descripcion',
                        contentPadding: EdgeInsets.all(15.0),
                        // border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      obscureText: false,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Digite el serial del equipo';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        widget.articulo.nombre = value;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  /* ListTile(
                    leading: const Icon(Icons.email),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                  ),
                  ListTile(
                    leading: const Icon(Icons.label),
                    title: const Text('Nick'),
                    subtitle: const Text('None'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: const Text('Birthday'),
                    subtitle: const Text('February 20, 1980'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Contact group'),
                    subtitle: const Text('Not specified'),
                  ), */
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
