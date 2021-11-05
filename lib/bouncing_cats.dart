import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';
import 'package:bootstrap_typography2/bootstrap_typography2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bouncing_cats/cat.dart';
import 'package:bouncing_cats/addition_menu.dart';

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
    _catKeys = <GlobalKey<CatState>>[];
    _random = Random();
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

  GlobalKey<CatState> _getKey() {
    _catKeys.add(GlobalKey<CatState>());
    return _catKeys[_catKeys.length - 1];
  }

  Image _getCatImage() {
    return Image.asset(_catAssetPaths[_random.nextInt(_catAssetPaths.length)]);
  }

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
            child: FutureBuilder(
              future: _loadJson(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scaffold(
                    body: Stack(
                      fit: StackFit.expand,
                      children: _cats,
                    ),
                    floatingActionButton: AdditionMenu(
                      buttonDefaultColor:
                          Theme.of(context).colorScheme.secondary,
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
                      addCat: (image) async {
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
                              image: image,
                            ),
                          );
                        });
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(snapshot.error.toString());
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
