import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';
import 'package:bootstrap_typography2/bootstrap_typography2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bouncing_cats/cat.dart';
import 'package:bouncing_cats/addition_menu.dart';

/// main state for controlling app
class BouncingCats extends StatefulWidget {
  const BouncingCats({Key? key}) : super(key: key);

  @override
  _BouncingCatsState createState() {
    return _BouncingCatsState();
  }
}

class _BouncingCatsState extends State<BouncingCats> {
  late dynamic _catNames;
  late dynamic _verbs;
  late dynamic _catAssetPaths;
  late bool _firstLoad;
  late List<Widget> _cats;
  late List<GlobalKey<CatState>> _catKeys;
  late Random _random;

  _BouncingCatsState() {
    // say is first time loading, and create the title of the app
    // note that the title is not built at this time
    _firstLoad = true;
    _cats = <Widget>[
      BSContainer(
        children: [
          BSRow(
            children: [
              BSColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  H1(
                    BSTextParams("Bouncing Cats"),
                  ),
                  H3(
                    BSTextParams("Add a cat using the buttons below!"),
                  ),
                  P(
                    BSTextParams(
                        "Tap on the cats to learn what they like, and used to like to be."),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];

    // int cat keys, random
    _catKeys = <GlobalKey<CatState>>[];
    _random = Random();

    // start periodic timer, which says when to change position
    _catUpdatePeriodic();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// generates a key for a cat, and adds the key to the _catKeys list
  GlobalKey<CatState> _getKey() {
    _catKeys.add(GlobalKey<CatState>());
    return _catKeys[_catKeys.length - 1];
  }

  /// returns a random cat Image
  Image _getCatImage() {
    return Image.asset(_catAssetPaths[_random.nextInt(_catAssetPaths.length)]);
  }

  /// loads cat verbs past and present.
  Future _loadJson() async {
    if (_firstLoad) {
      String data = await rootBundle.loadString("assets/cat_names.json");
      _catNames = jsonDecode(data);

      data = await rootBundle.loadString("assets/verbs.json");
      _verbs = jsonDecode(data);

      data = await rootBundle.loadString("assets/cats/cat_map.json");
      _catAssetPaths = jsonDecode(data);

      _firstLoad = false;
    }

    return true;
  }

  /// creates a timer, which tells all cats to update their position
  void _catUpdatePeriodic() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        _catKeys.forEach((element) {
          element.currentState!.update();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Builder(
        builder: (aboveSafeContext) {
          return SafeArea(
            // future for waiting for json to load
            child: FutureBuilder(
              future: _loadJson(),
              builder: (context, snapshot) {
                // once json loaded run app
                if (snapshot.hasData) {
                  return Scaffold(
                    // stack containing cats
                    body: Stack(
                      fit: StackFit.expand,
                      children: _cats,
                    ),
                    // buttons that shows or hides other buttons when pressed
                    floatingActionButton: AdditionMenu(
                      buttonDefaultColor:
                          Theme.of(context).colorScheme.secondary,

                      // add random cat button on pressed
                      onClick: () async {
                        setState(() {
                          _cats.add(
                            Cat(
                              key: _getKey(),
                              padding: MediaQuery.of(aboveSafeContext).padding,
                              name:
                                  _catNames[_random.nextInt(_catNames.length)],
                              presentVerb:
                                  _verbs[_random.nextInt(_verbs.length)]
                                      ["present"],
                              pastVerb: _verbs[_random.nextInt(_verbs.length)]
                                  ["past"],
                              image: _getCatImage(),
                            ),
                          );
                        });
                      },

                      // added custom cat on pressed, using device camera
                      // add a cat from a image file on the device
                      addFileCat: (
                        image, {
                        required description,
                        required name,
                      }) async {
                        setState(() {
                          _cats.add(
                            Cat.customDescription(
                              key: _getKey(),
                              padding: MediaQuery.of(aboveSafeContext).padding,
                              name: name,
                              description: description,
                              image: image,
                            ),
                          );
                        });
                      },
                    ),
                  );
                  // if error display error on screen
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(snapshot.error.toString());

                  // show circular progress indicator while waiting for json to load
                } else {
                  return Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
