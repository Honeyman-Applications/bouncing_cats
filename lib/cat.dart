import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bootstrap_typography2/bootstrap_typography2.dart';
import 'package:bootstrap_like_modal/bootstrap_like_modal.dart';

/// Cat is the image that moves within the bounds of the screen randomly
/// ratio is the size the cat should be relative to the size of the screen
class Cat extends StatefulWidget {
  final String name;
  final String presentVerb;
  final String pastVerb;
  final Image image;
  final int ratio;
  final Duration animationDuration;
  final EdgeInsets padding;

  Cat({
    GlobalKey<CatState>? key,
    required this.name,
    required this.presentVerb,
    required this.pastVerb,
    required this.image,
    required this.padding,
    this.ratio = 4,
    this.animationDuration = const Duration(
      seconds: 1,
    ),
  }) : super(key: key);

  @override
  CatState createState() {
    return CatState();
  }
}

class CatState extends State<Cat> {
  double _maxX = 0;
  double _maxY = 0;
  double _x = 0;
  double _y = 0;
  final Random _random = Random();
  late BSModal _modal;

  @override
  void initState() {
    super.initState();

    // create a BSModal that can be displayed when the cat is pressed
    _modal = BSModal(
      content: P(
        BSTextParams(
            "My name is: ${widget.name}, I like to ${widget.presentVerb}, and I used to like to be ${widget.pastVerb}."),
      ),
    );
    _modal.title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H4(
          BSTextParams(
            widget.name,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
          ),
          color: Colors.red,
          onPressed: () {
            _modal.hide();
          },
        ),
      ],
    );

    _modal.actions = <Widget>[
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.red,
          ),
        ),
        child: P(
          BSTextParams("Close"),
        ),
        onPressed: () {
          _modal.hide();
        },
      )
    ];
  }

  // when called from an external source, update the new destination
  // to a random value within the screen
  void update() {
    if (this.mounted) {
      setState(() {
        _x = _random.nextInt(_maxX.toInt()).toDouble();
        _y = _random.nextInt(_maxY.toInt()).toDouble();
      });
    }
  }

  // returns the width if it is smaller than the height; otherwise the
  // height is returned
  double _getDim(double width, double height) {
    return width <= height ? width : height;
  }

  @override
  Widget build(BuildContext context) {
    // get the width & height of the screen from the current context
    _maxX = MediaQuery.of(context).size.width -
        widget.padding.left -
        widget.padding.right;
    _maxY = MediaQuery.of(context).size.height -
        widget.padding.top -
        widget.padding.bottom;

    // calculate the possible width and height using the passed ratio
    double width = _maxX / widget.ratio;
    double height = _maxY / widget.ratio;

    // ensure the cat stays in the bounds of the screen
    if (_x >= _maxX - _getDim(width, height)) {
      _x = _maxX - _getDim(width, height);
    }
    if (_y >= _maxY - _getDim(width, height)) {
      _y = _maxY - _getDim(width, height);
    }

    return AnimatedPositioned(
      left: _x,
      top: _y,

      // set width and height to the smaller of the two
      width: _getDim(width, height),
      height: _getDim(width, height),
      duration: widget.animationDuration,

      // show modal on cat pressed
      child: GestureDetector(
        onTap: () {
          _modal.show(context);
        },
        child: Container(
          child: Center(
            child: Stack(
              children: [
                widget.image,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: P(
                    BSTextParams(
                      widget.name,
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
