import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:hive/hive.dart';
import 'package:inventariosdenzil/styles/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

bool isDarkModeEnabled;
var storage;

class SideMenu extends StatefulWidget {
  // SideMenu({Key key}) : super(key: key);

  // @override
  // _SideMenuState createState() => _SideMenuState();

  // static final GlobalKey<Page2State> staticGlobalKey =
  //     new GlobalKey<Page2State>();

  // Page2() : super(key: Page2.currentStateKey); // Key injection
  // @override
  // Page2State createState() => Page2State();

  static final GlobalKey<SideMenuState> staticGlobalKey =
      new GlobalKey<SideMenuState>();
  SideMenu() : super(key: SideMenu.staticGlobalKey); // Key injection
  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  AnimationController controller;
  Animation _animation;
  double beginMenuWidthAnimation = 60;
  double endMenuWidthAnimation = 170;

  bool isDarkModeEnabled = false;
  bool _sideMenuOpen = false;

  initLocalStorage() async {
    try {
      // Platform.isAndroid
      // Platform.isFuchsia
      // Platform.isIOS
      // Platform.isLinux
      // Platform.isMacOS
      // Platform.isWindows
      if (kIsWeb) {
        print('Flutter Web');
        return;
      } else if (Platform.isAndroid) {
        print('Flutter Android');
        final dir = await getApplicationDocumentsDirectory();
        Hive.init(dir.path);
        return;
      }
    } catch (e) {
      print(['Error init storage', e]);
    }
  }

  initStorage() async {
    await initLocalStorage();
    storage = await Hive.openBox('storage');
    isDarkModeEnabled = await storage.get('isDark');
    _sideMenuOpen = await storage.get('sideMenuOpen');
    setState(() {
      isDarkModeEnabled =
          (isDarkModeEnabled == null) ? false : isDarkModeEnabled;
      _sideMenuOpen = (_sideMenuOpen == null) ? false : _sideMenuOpen;
    });
    print('SideMenu/Init storage');
  }

  @override
  void initState() {
    super.initState();
    initStorage();
    _sideMenuOpen = false;
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = IntTween(begin: 0, end: 1).animate(controller);
    _animation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> playAnimation() async {
    // await Storage.staticGlobalKey.currentState.initLocalStorage();
    storage = await Hive.openBox('storage');
    _sideMenuOpen = await storage.get('sideMenuOpen');
    _sideMenuOpen = (_sideMenuOpen == null) ? false : _sideMenuOpen;
    print(['playAnimation', _sideMenuOpen]);
    try {
      (_sideMenuOpen)
          ? await controller.forward().orCancel
          : await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    var size = MediaQuery.of(context).size;
    double _sideMenuHeight =
        (size.width > 560) ? (size.height) : (size.height * 0.7);
    double _iconSize = 30;
    Animation<double> menuWidthAnimation = Tween<double>(
      begin: (size.width > 560) ? beginMenuWidthAnimation : 0,
      end: endMenuWidthAnimation,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    Animation<double> itemWidthAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: (size.width > 560)
            ? Interval(
                0.0,
                0.9,
                curve: Curves.ease,
              )
            : Interval(
                0.3,
                0.7,
                curve: Curves.ease,
              ),
      ),
    );
    double _height = 40;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sideMenuOpen = !_sideMenuOpen;
        });
        playAnimation();
      },
      child: Container(
        height: _sideMenuHeight,
        width: menuWidthAnimation.value,
        decoration: (size.width > 560)
            ? (isDarkModeEnabled)
                ? sideMenuDecorationBlack
                : sideMenuDecorationWhite
            : (isDarkModeEnabled)
                ? sideMenuDecorationBlack2
                : sideMenuDecorationWhite2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: (size.width > 560)
                      ? (size.height * 0.3)
                      : (size.height * 0.15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      (size.width > 560)
                          ? SizedBox(
                              height: (size.height * 0.01),
                            )
                          : SizedBox(),
                      (size.width > 560)
                          ? GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: menuWidthAnimation.value,
                                height: _height,
                                decoration: BoxDecoration(
                                  color: Colors.transparent, // color2,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: (itemWidthAnimation.value > 0)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                decoration: (isDarkModeEnabled)
                                                    ? logoDecorationBlack
                                                    : logoDecorationWhite,
                                                child: Image.asset(
                                                    'assets/logo.png')),
                                            SizedBox(
                                              width: 0.67 *
                                                  itemWidthAnimation.value,
                                            ),
                                            Text(
                                              "Inst. Edu.\nDenzil Escolar",
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 0.8 *
                                                    itemWidthAnimation.value,
                                                color: (isDarkModeEnabled)
                                                    ? Colors.white
                                                    : color3,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Image.asset('assets/logo.png'),
                              ),
                            )
                          : SizedBox(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: (isDarkModeEnabled) ? Colors.white : color3,
              height: (size.width > 560)
                  ? (size.height * 0.05)
                  : (size.height * 0.025),
              thickness: 1,
              indent: 21,
              endIndent: (menuWidthAnimation.value > 70)
                  ? menuWidthAnimation.value -
                      (beginMenuWidthAnimation -
                          (beginMenuWidthAnimation * 0.1))
                  : 21,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: (size.height * 0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.home_outlined,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.home_outlined,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: (isDarkModeEnabled) ? Colors.white : color3,
              height: (size.width > 560)
                  ? (size.height * 0.05)
                  : (size.height * 0.025),
              thickness: 1,
              indent: 21,
              endIndent: (menuWidthAnimation.value > 70)
                  ? menuWidthAnimation.value -
                      (beginMenuWidthAnimation -
                          (beginMenuWidthAnimation * 0.1))
                  : 21,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: (size.height * 0.125),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: menuWidthAnimation.value,
                          height: _height,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // color2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: (itemWidthAnimation.value > 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.apps,
                                        color: (isDarkModeEnabled)
                                            ? Colors.white
                                            : color3,
                                        size: _iconSize,
                                      ),
                                      SizedBox(
                                        width: 0.7 * itemWidthAnimation.value,
                                      ),
                                      Text(
                                        "Exportar",
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize:
                                              1 * itemWidthAnimation.value,
                                          color: (isDarkModeEnabled)
                                              ? Colors.white
                                              : color3,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Icon(
                                  Icons.apps,
                                  color: (isDarkModeEnabled)
                                      ? Colors.white
                                      : color3,
                                  size: (size.width > 560)
                                      ? _iconSize
                                      : itemWidthAnimation.value,
                                ),
                          // duration: Duration(milliseconds: 500),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
