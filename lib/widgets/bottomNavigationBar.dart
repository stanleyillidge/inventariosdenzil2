// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io' show Platform;
import 'package:hive/hive.dart';
// import 'package:inventariosdenzil/styles/styles.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

bool isDarkModeEnabled = false;

class BottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  BottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.onChange});

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation _animation;
  double beginMenuWidthAnimation = 60;
  double endMenuWidthAnimation = 170;
  // bool _sideMenuOpen = false;
  var storage;

  _initStorage() async {
    storage = await Hive.openBox('storage');
    isDarkModeEnabled = await storage.get('isDark');
    isDarkModeEnabled = (isDarkModeEnabled == null) ? false : isDarkModeEnabled;
    print('Main/Init storage');
  }

  @override
  void initState() {
    _initStorage();
    super.initState();
    // _sideMenuOpen = false;
    controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = IntTween(begin: 0, end: 1).animate(controller);
    _animation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /* Future<void> _playAnimation() async {
    try {
      (_sideMenuOpen)
          ? await controller.forward().orCancel
          : await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  } */

  Widget _buildAnimation(BuildContext context, Widget child) {
    /* var size = MediaQuery.of(context).size;
    double _sideMenuHeight = (size.height * 0.9);
    double _height = 40;
    double _iconSize = 30;
    Animation<double> menuWidthAnimation = Tween<double>(
      begin: beginMenuWidthAnimation,
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
        curve: Interval(
          0.1,
          0.9,
          curve: Curves.ease,
        ),
      ),
    ); */
    return Container();
    /* return GestureDetector(
      onTap: () {
        setState(() {
          _sideMenuOpen = !_sideMenuOpen;
        });
        _playAnimation();
      },
      child: AnimatedContainer(
        width: itemWidthAnimation.value,
        height: _height,
        decoration: BoxDecoration(
          color: (itemWidthAnimation.value > 0.1)
              ? Colors.grey.withOpacity(0.25)
              : Colors.transparent, // color2,
          borderRadius: BorderRadius.circular(50),
        ),
        child: (itemWidthAnimation.value > 1)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    // Icons.drive_eta_outlined,
                    color: (isDarkModeEnabled) ? Colors.white : color3,
                    size: _iconSize,
                  ),
                  SizedBox(
                    // second child
                    width: _spaceWidth,
                  ),
                  Container(
                    width: _widthIn * (_animations[index].value),
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // color4,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Exportar",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 5 * _animations[index].value,
                          color: (isDarkModeEnabled) ? Colors.white : color3,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Icon(
                icon,
                // Icons.drive_eta_outlined,
                color: (isDarkModeEnabled) ? Colors.white : color3,
                size: _iconSize,
              ),
        duration: Duration(milliseconds: 10),
        // Provide an optional curve to make the animation feel smoother.
      ),
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

/* class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  List<AnimationController> _animationControllers = [];
  List<Animation> _animations = [];
  List<IconData> _iconList = [];
  bool isDarkModeEnabled = false;
  bool _sideMenuOpen = false;
  var storage;

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
    setState(() {
      isDarkModeEnabled =
          (isDarkModeEnabled == null) ? false : isDarkModeEnabled;
    });
    print('CustomBottomNavigationBar/Init storage');
  }

  @override
  void initState() {
    super.initState();
    initStorage();
    _iconList = widget.iconList;
    for (var i = 0; i < _iconList.length; i++) {
      _animationControllers.add(AnimationController(
          duration: Duration(milliseconds: 200), vsync: this));
      _animations
          .add(IntTween(begin: 0, end: 3).animate(_animationControllers[i]));
      _animations[i].addListener(() => setState(() {}));
    }
  }

  double _iconSize = 30;
  double _widthPorc = 1;
  double _spaceWidth = 2;
  double _width = 37;
  double _height = 40;
  double _widthIn = 21;
  List<bool> tests = [false, false, false, false];
  bool test = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }
    return Container(
      height: 60.0,
      width: (size.width * 0.8),
      decoration: (isDarkModeEnabled)
          ? bottonBarDecorationBlack
          : bottonBarDecorationWhite,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navBarItemList,
      )),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        // Use setState to rebuild the widget with new values.
        setState(() {
          for (var i = 0; i < _iconList.length; i++) {
            _animationControllers[i].reverse();
          }
          if (_animationControllers[index].value == 0.0) {
            _animationControllers[index].forward();
          } else {
            _animationControllers[index].reverse();
          }
        });
      },
      child: AnimatedContainer(
        // padding: EdgeInsets.only(left: 1.0, right: 1.0),
        width: ((_width * _widthPorc) * _animations[index].value) + _width,
        height: _height,
        decoration: BoxDecoration(
          color: (_animations[index].value > 0.1)
              ? Colors.grey.withOpacity(0.25)
              : Colors.transparent, // color2,
          borderRadius: BorderRadius.circular(50),
        ),
        child: (_animations[index].value > 1)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    // Icons.drive_eta_outlined,
                    color: (isDarkModeEnabled) ? Colors.white : color3,
                    size: _iconSize,
                  ),
                  SizedBox(
                    // second child
                    width: _spaceWidth,
                  ),
                  Container(
                    width: _widthIn * (_animations[index].value),
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // color4,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Exportar",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 5 * _animations[index].value,
                          color: (isDarkModeEnabled) ? Colors.white : color3,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Icon(
                icon,
                // Icons.drive_eta_outlined,
                color: (isDarkModeEnabled) ? Colors.white : color3,
                size: _iconSize,
              ),
        duration: Duration(milliseconds: 10),
        // Provide an optional curve to make the animation feel smoother.
      ),
    );
  }
} */
