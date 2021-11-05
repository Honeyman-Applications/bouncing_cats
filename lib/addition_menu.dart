/*
  https://medium.com/@agungsurya/create-a-simple-animated-floatingactionbutton-in-flutter-2d24f37cfbcc
 */

import 'package:flutter/material.dart';
import 'package:bouncing_cats/add_custom_cat.dart';
import 'package:bouncing_cats/cat.dart';

class AdditionMenu extends StatefulWidget {
  final Function onClick;
  final Function(Image image) addCat;
  final Color buttonDefaultColor;

  AdditionMenu({
    Key? key,
    required this.onClick,
    required this.addCat,
    required this.buttonDefaultColor,
  }) : super(key: key);

  @override
  _AdditionMenuState createState() {
    return _AdditionMenuState();
  }
}

class _AdditionMenuState extends State<AdditionMenu>
    with SingleTickerProviderStateMixin {
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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.addListener(() {
      setState(() {});
    });
    _animateIcon =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color.fromARGB(
        255,
        widget.buttonDefaultColor.red,
        widget.buttonDefaultColor.green,
        widget.buttonDefaultColor.blue,
      ),
      end: Colors.red,
    ).animate(_animationController);
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

  void _animate() {
    if (isOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    isOpen = !isOpen;
  }

  AddCustomCat _addCustomCatPicture() {
    return AddCustomCat(
      addCat: widget.addCat,
    );
  }

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
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _buttonMove.value * 2,
            0.0,
          ),
          child: _addCustomCatPicture(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _buttonMove.value,
            0.0,
          ),
          child: _addCatButton(),
        ),
        _toggle(),
      ],
    );
  }
}
