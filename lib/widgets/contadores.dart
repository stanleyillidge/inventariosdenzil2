// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:inventariosdenzil/views/Android/InventarioLocation.dart';
import '../styles/extenciones.dart';
import 'package:event/event.dart';

// import 'models.dart';
// import 'models.dart';

bool isDarkModeEnabled = false;

class ContadorBar extends StatefulWidget {
  ContadorBar({
    Key key,
    this.fontSize,
    this.isDarkModeEnabled,
    this.location,
    this.titulo,
    this.total,
    this.articulos,
    this.buenos,
    this.malos,
    this.regulares,
    this.width,
    this.isResumen,
  }) : super(key: key);
  final double fontSize;
  final bool isDarkModeEnabled;
  final String titulo;
  final double width;
  final List location;
  final int total;
  final int articulos;
  final int buenos;
  final int malos;
  final int regulares;
  final bool isResumen;
  final valueChangedEvent = Event<ValueEventArgs>();

  @override
  _ContadorBarState createState() => _ContadorBarState();
}

class _ContadorBarState extends State<ContadorBar> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    final formatter = new NumberFormat("#,###");
    return Container(
        height: height * 0.125,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (!widget.isResumen)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: height * 0.3,
                        // height: 40,
                        // decoration: (widget.isDarkModeEnabled)
                        //     ? contInfDecorationBlack
                        //     : contInfDecorationWhite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (widget.total > 1)
                                  ? 'Existen ' + widget.total.toString()
                                  : 'Existe ' + widget.total.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? color1
                                    : color5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                widget.titulo.capitalize(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.fontSize,
                                  color: (widget.isDarkModeEnabled)
                                      ? color1
                                      : color5,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 2,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print(widget.location[0].sede.nombre);
                      print(widget.location[0].sede.key);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        // CollectionReference locationCollection;
                        return AndroidInventarioLocationPage(
                          location: widget.titulo,
                          sede: widget.location[0].sede.key,
                        );
                      }));
                      // widget.valueChangedEvent
                      //     .broadcast(ValueEventArgs("Elementos"));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15.0, right: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatter.format(widget.articulos),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? color1
                                    : color5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              "Elementos",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? color1
                                    : color5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10.0),
                  // ),
                  child: InkWell(
                    // borderRadius: BorderRadius.circular(10.0),
                    splashColor: buenosW.withAlpha(30),
                    onTap: () {
                      print('Card tapped.');
                      widget.valueChangedEvent
                          .broadcast(ValueEventArgs("Buenos"));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15.0, right: 15.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatter.format(widget.buenos),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.fontSize,
                                      color: (widget.isDarkModeEnabled)
                                          ? color1
                                          : color5,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    "Buenos",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: widget.fontSize,
                                      color: (widget.isDarkModeEnabled)
                                          ? buenosW
                                          : buenosB,
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
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print('Card tapped.');
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15.0, right: 15.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatter.format(widget.malos),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.fontSize,
                                      color: (widget.isDarkModeEnabled)
                                          ? color1
                                          : color5,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    "Malos",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: widget.fontSize,
                                      color: (widget.isDarkModeEnabled)
                                          ? malosB
                                          : malosW,
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
                  ),
                ),
                Card(
                  elevation: 2,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print('Card tapped.');
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 15.0, right: 15.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatter.format(widget.regulares),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.fontSize,
                                      color: (widget.isDarkModeEnabled)
                                          ? color1
                                          : color5,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    "Regulares",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: widget.fontSize,
                                      color: (widget.isDarkModeEnabled)
                                          ? regularesW
                                          : regularesB,
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
                  ),
                ),
              ],
            )
          ],
        )
        /* ListView(
        padding: const EdgeInsets.all(5.0),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          (!widget.isResumen)
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    child: Container(
                      width: widget.width,
                      height: 40,
                      decoration: (widget.isDarkModeEnabled)
                          ? contInfDecorationBlack
                          : contInfDecorationWhite,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10.0, right: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.total.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize * 1.3,
                                color: (widget.isDarkModeEnabled)
                                    ? color5
                                    : color1,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                widget.titulo.capitalize(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widget.fontSize * 0.85,
                                  color: (widget.isDarkModeEnabled)
                                      ? color3
                                      : color1,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              child: Container(
                // width: 130,
                height: 40,
                decoration: (widget.isDarkModeEnabled)
                    ? contInfDecorationBlack
                    : contInfDecorationWhite,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15.0, right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatter.format(widget.articulos),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize,
                          color: (widget.isDarkModeEnabled) ? color5 : color1,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Text(
                        "Articulos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize,
                          color: (widget.isDarkModeEnabled) ? color3 : color1,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              child: Container(
                // width: 130,
                height: 40,
                decoration: (widget.isDarkModeEnabled)
                    ? contInfDecorationBlack
                    : contInfDecorationWhite,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15.0, right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatter.format(widget.buenos),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? color3
                                    : color1,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              "Buenos",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? buenosB
                                    : buenosW,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              child: Container(
                // width: 130,
                height: 40,
                decoration: (widget.isDarkModeEnabled)
                    ? contInfDecorationBlack
                    : contInfDecorationWhite,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15.0, right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatter.format(widget.malos),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? color3
                                    : color1,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              "Malos",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? malosW
                                    : malosB,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              child: Container(
                // width: 130,
                height: 40,
                decoration: (widget.isDarkModeEnabled)
                    ? contInfDecorationBlack
                    : contInfDecorationWhite,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15.0, right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatter.format(widget.regulares),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? color3
                                    : color1,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              "Regulares",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: widget.fontSize,
                                color: (widget.isDarkModeEnabled)
                                    ? regularesB
                                    : regularesW,
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
            ),
          ),
        ],
      ), */
        );
  }
}

class ValueEventArgs extends EventArgs {
  String changedValue;
  ValueEventArgs(this.changedValue);
}
