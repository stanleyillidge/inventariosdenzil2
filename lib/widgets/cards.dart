import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:inventariosdenzil/widgets/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../styles/extenciones.dart';

// LocationsCard
class LocationsCard extends StatefulWidget {
  LocationsCard({
    Key key,
    this.fontSize,
    this.isDarkModeEnabled,
    this.cantidad,
    this.locationCollection,
    this.onTap,
    this.sede,
    this.location,
    this.imagen,
    this.nombre,
  }) : super(key: key);
  final double fontSize;
  final bool isDarkModeEnabled;
  final int cantidad;
  final CollectionReference locationCollection;
  final Referencia sede;
  final String location;
  final String nombre;
  final String imagen;
  final Function onTap;

  @override
  _LocationsCardState createState() => _LocationsCardState();
}

class _LocationsCardState extends State<LocationsCard> {
  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: (widget.isDarkModeEnabled)
          ? loCardDecorationBlack
          : loCardDecorationWhite,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              widget.onTap();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: (widget.imagen != '/assets/shapes.svg')
                  // ? Image.network(widget.imagen)
                  ? CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: widget.imagen,
                    )
                  : Image.asset('assets/shapes2.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Column(
              children: [
                // Tipo de locacion y opciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.location.capitalize(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize,
                        color: (widget.isDarkModeEnabled)
                            ? color4.withOpacity(0.5)
                            : color3.withOpacity(0.5),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        print(['value', value]);
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<dynamic>>[
                        const PopupMenuItem(
                          value: Text('Eliminar'),
                          child: Text('Eliminar'),
                        ),
                        const PopupMenuItem<dynamic>(
                          value: Text('Editar'),
                          child: Text('Editar'),
                        ),
                      ],
                    )
                  ],
                ),
                // Nombre y cantidades
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize,
                          color: (widget.isDarkModeEnabled) ? color4 : color3,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      formatter.format(widget.cantidad),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize * 1.5,
                        color:
                            (widget.isDarkModeEnabled) ? color1 : Colors.black,
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
  }
}

// ResumenCard
class ResumenCard extends StatefulWidget {
  ResumenCard({
    Key key,
    this.fontSize,
    this.isDarkModeEnabled,
    this.cantidad,
    this.locationCollection,
    this.onTap,
    this.sede,
    this.location,
    this.imagen,
    this.nombre,
    this.buenos,
    this.malos,
    this.regulares,
  }) : super(key: key);
  final double fontSize;
  final bool isDarkModeEnabled;
  final int cantidad;
  final CollectionReference locationCollection;
  final Referencia sede;
  final String location;
  final String nombre;
  final String imagen;
  final Function onTap;
  final int buenos;
  final int malos;
  final int regulares;

  @override
  _ResumenCardState createState() => _ResumenCardState();
}

class _ResumenCardState extends State<ResumenCard> {
  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    double fontScale = 1.5;
    return GestureDetector(
      onTap: () async {
        widget.onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: (widget.isDarkModeEnabled)
            ? loCardDecorationBlack
            : loCardDecorationWhite,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y cantidades
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.nombre.capitalize(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize * 1.2,
                          color: (widget.isDarkModeEnabled) ? color1 : color3,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    /* PopupMenuButton(
                      onSelected: null,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<dynamic>>[
                        const PopupMenuItem(
                          value: Text('Eliminar'),
                          child: Text('Eliminar'),
                        ),
                        const PopupMenuItem<dynamic>(
                          value: Text('Dar de baja'),
                          child: Text('Dar de baja'),
                        ),
                      ],
                    ), */
                  ],
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          formatter.format(widget.buenos),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: widget.fontSize * fontScale,
                            color:
                                (widget.isDarkModeEnabled) ? buenosB : buenosW,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Buenos",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: widget.fontSize,
                            color: (widget.isDarkModeEnabled) ? color1 : color3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          formatter.format(widget.malos),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: widget.fontSize * fontScale,
                            color: (widget.isDarkModeEnabled) ? malosW : malosW,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Malos",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: widget.fontSize,
                            color: (widget.isDarkModeEnabled) ? color1 : color3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          formatter.format(widget.regulares),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: widget.fontSize * fontScale,
                            color: (widget.isDarkModeEnabled)
                                ? regularesB
                                : regularesW,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "Regulares",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: widget.fontSize,
                            color: (widget.isDarkModeEnabled) ? color1 : color3,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      child: Text(
                        formatter.format(widget.cantidad),
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize * fontScale * 1.6,
                          color: (widget.isDarkModeEnabled)
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
      ),
    );
    /* return Container(
      padding: const EdgeInsets.all(8),
      decoration: (widget.isDarkModeEnabled)
          ? loCardDecorationBlack
          : loCardDecorationWhite,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              widget.onTap();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: (widget.imagen != '/assets/shapes.svg')
                  ? Image.network(widget.imagen)
                  : Image.asset('assets/shapes2.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Column(
              children: [
                // Tipo de locacion y opciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sede",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize,
                        color: (widget.isDarkModeEnabled)
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize,
                          color: (widget.isDarkModeEnabled) ? color4 : color3,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      formatter.format(widget.cantidad),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize * 1.5,
                        color:
                            (widget.isDarkModeEnabled) ? color1 : Colors.black,
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
    ); */
  }
}

// ArticuloCard
class ArticuloCard extends StatefulWidget {
  ArticuloCard({
    Key key,
    this.fontSize,
    this.isDarkModeEnabled,
    this.locationCollection,
    this.cantidad,
    this.onTap,
    this.articulo,
  }) : super(key: key);
  final double fontSize;
  final bool isDarkModeEnabled;
  final int cantidad;
  final CollectionReference locationCollection;
  final Function onTap;
  final Articulo articulo;

  @override
  _ArticuloCardState createState() => _ArticuloCardState();
}

class _ArticuloCardState extends State<ArticuloCard> {
  @override
  Widget build(BuildContext context) {
    // final formatter = new NumberFormat("#,###");
    // double fontScale = 1.5;
    return GestureDetector(
      onTap: () async {
        widget.onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        /* color: (widget.articulo.estado == 'Bueno')
            ? (widget.isDarkModeEnabled)
                ? buenosB
                : buenosW
            : (widget.articulo.estado == 'Malo')
                ? (widget.isDarkModeEnabled)
                    ? malosB
                    : malosW
                : (widget.articulo.estado == 'Regular')
                    ? (widget.isDarkModeEnabled)
                        ? regularesB
                        : regularesW
                    : Colors.black, */
        decoration: (widget.isDarkModeEnabled)
            ? BoxDecoration(
                color: (widget.articulo.estado == 'Bueno')
                    ? color3
                    : (widget.articulo.estado == 'Malo')
                        ? malosB.withAlpha(80)
                        : (widget.articulo.estado == 'Regular')
                            ? regularesB.withAlpha(80)
                            : color1,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.55),
                    offset: Offset(0.0, 2.5),
                    blurRadius: 6.0,
                    spreadRadius: 1.5,
                  ),
                ],
              )
            : BoxDecoration(
                color: (widget.articulo.estado == 'Bueno')
                    ? color1
                    : (widget.articulo.estado == 'Malo')
                        ? malosW.withAlpha(100)
                        : (widget.articulo.estado == 'Regular')
                            ? regularesW.withAlpha(100)
                            : color3,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 5.0,
                    // spreadRadius: 2.5,
                  ),
                ],
              ),
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
                child: (widget.articulo.imagen != '/assets/shapes.svg')
                    /* ? Image.network(
                        widget.articulo.imagen,
                        // height: 100,
                        // width: 150,
                        scale: 3,
                      ) */
                    ? CachedNetworkImage(
                        fit: BoxFit.scaleDown, height: 90,
                        // width: 150,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: widget.articulo.imagen,
                      )
                    : Image.asset(
                        'assets/shapes2.png',
                        scale: 1.8,
                      ),
              ),
              SizedBox(
                height: 10,
                width: 10,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.articulo.nombre.capitalize(),
                      // "Kit silla y mesa pequeña con superficie, espaldar y brazo PLASTICO con estructura en TUBO metalico",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize,
                        color: (widget.isDarkModeEnabled) ? color1 : color3,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                      width: 5,
                    ),
                    Text(
                      widget.articulo.estado,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize * 1.2,
                        color: (widget.articulo.estado == 'Bueno')
                            ? (widget.isDarkModeEnabled)
                                ? buenosB
                                : buenosW
                            : (widget.articulo.estado == 'Malo')
                                ? (widget.isDarkModeEnabled)
                                    ? malosB
                                    : malosW
                                : (widget.articulo.estado == 'Regular')
                                    ? (widget.isDarkModeEnabled)
                                        ? Colors.orange
                                        : Colors.orange[900]
                                    : Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                      width: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.articulo.sede.nombre.capitalize(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.fontSize * 0.8,
                                  color: (widget.isDarkModeEnabled)
                                      ? color4
                                      : color3,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                widget.articulo.ubicacion.nombre.capitalize(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.fontSize * 0.8,
                                  color: (widget.isDarkModeEnabled)
                                      ? color4
                                      : color3,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                widget.articulo.subUbicacion.nombre
                                    .capitalize(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.fontSize * 0.8,
                                  color: (widget.isDarkModeEnabled)
                                      ? color4
                                      : color3,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: null,
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<dynamic>>[
                            const PopupMenuItem(
                              value: Text('Eliminar'),
                              child: Text('Eliminar'),
                            ),
                            const PopupMenuItem<dynamic>(
                              value: Text('Dar de baja'),
                              child: Text('Dar de baja'),
                            ),
                            const PopupMenuItem<dynamic>(
                              value: Text('Etiqueta'),
                              child: Text('Etiqueta'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:inventariosdenzil/styles/styles.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => new _TestState();
}

class _TestState extends State<Test> {
  double rating = 3.5;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: new List.generate(42, (index) {
            var text = 'Drag me ' + index.toString();
            return new SlideMenu(
              child: new ListTile(
                title: new Container(
                  child: new Text(text),
                  decoration: loCardDecorationWhite,
                ),
              ),
              menuItems: <Widget>[
                new Container(
                  child: new IconButton(
                    icon: new Icon(Icons.delete),
                  ),
                ),
                new Container(
                  child: new IconButton(
                    icon: new Icon(Icons.info),
                  ),
                ),
              ],
            );
          }),
        ).toList(),
      ),
    );
  }
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 200)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity <
                -200) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
} */
