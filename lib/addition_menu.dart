/*
  https://medium.com/@agungsurya/create-a-simple-animated-floatingactionbutton-in-flutter-2d24f37cfbcc
 */

import 'package:flutter/material.dart';
import 'package:bouncing_cats/add_custom_cat.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bouncing_cats/add_file_cat.dart';

/// Creates a floating action button that when pressed either shows or hides
/// the buttons for adding a cat, custom cat, or file cat
/// The custom cat button is only shown on Web, Android, or IOS, as it requires
/// the camera.
/// onClick runs when a new cat can be added
/// addCat runs when a custom cat should be added
/// addFileCat runs when a file cat should be added
class AdditionMenu extends StatefulWidget {
  final Function onClick;
  final Function(Image image) addCat;
  final Function(Image image) addFileCat;
  final Color buttonDefaultColor;

  AdditionMenu({
    Key? key,
    required this.onClick,
    required this.addCat,
    required this.addFileCat,
    required this.buttonDefaultColor,
  }) : super(key: key);

  @override
  _AdditionMenuState createState() {
    return _AdditionMenuState();
  }
}

class _AdditionMenuState extends State<AdditionMenu>
    with SingleTickerProviderStateMixin {
  // animations
  late final AnimationController _animationController;
  late final Animation<double> _buttonMove;
  late final Animation<double> _animateIcon;
  late final Animation<Color?> _buttonColor;
  final Curve _curve = Curves.easeOut;
  final double _height = 56.0;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    // init animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.addListener(() {
      setState(() {});
    });

    // open close animated icon
    _animateIcon =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    // open close animated color, uses pased default buttons color
    // and red
    _buttonColor = ColorTween(
      begin: Color.fromARGB(
        255,
        widget.buttonDefaultColor.red,
        widget.buttonDefaultColor.green,
        widget.buttonDefaultColor.blue,
      ),
      end: Colors.red,
    ).animate(_animationController);

    // animatebuttons moving up and down
    _buttonMove = Tween<double>(
      begin: _height,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // show or hide buttons using animation
  void _animate() {
    if (isOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    isOpen = !isOpen;
  }

  // add custom cat using device camera if is web, andoid or ios
  // else show nothing
  Widget _addCustomCatPicture() {
    if (UniversalPlatform.isWeb ||
        UniversalPlatform.isAndroid ||
        UniversalPlatform.isIOS) {
      return AddCustomCat(
        addCat: widget.addCat,
      );
    }
    return SizedBox.shrink();
  }

  // add a cat(s) from a file
  AddFileCat _addFileCat() {
    return AddFileCat(
      addFileCat: widget.addFileCat,
    );
  }

  // add a random cat using the cat images local to the app
  FloatingActionButton _addCatButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
      ),
      onPressed: () {
        widget.onClick();
      },
    );
  }

  // show and hide buttons, and change the button icon and color
  FloatingActionButton _toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
      onPressed: () => _animate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // custom cat
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _buttonMove.value * 3,
            0.0,
          ),
          child: _addCustomCatPicture(),
        ),
        // file cat
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _buttonMove.value * 2,
            0.0,
          ),
          child: _addFileCat(),
        ),
        // random cat
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _buttonMove.value,
            0.0,
          ),
          child: _addCatButton(),
        ),
        // show and hide buttons on pressed
        _toggle(),
      ],
    );
  }
}
