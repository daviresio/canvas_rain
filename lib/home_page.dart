import 'package:canvas_rain/rain_painter.dart';
import 'package:flutter/material.dart';
import 'package:useful_utils/useful_utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  List<Drop> drops = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;

      setState(() {
        drops = List.generate(
          600,
          (index) {
            final random = utils.randomInt(min: 0, max: 20).toDouble();
            final y = utils.randomInt(min: -height.toInt(), max: 0).toDouble();
            return Drop(
              x: utils.randomInt(min: 0, max: width.toInt()).toDouble(),
              y: y,
              speed: utils.remap(random, 0, 20, 1, 10),
              dropSize: utils.remap(random, 0, 20, 10, 50).toInt(),
              blur: utils.remap(random, 0, 20, 0.8, 3).toInt().toDouble(),
            );
          },
        );
      });

      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.black87,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          CustomPaint(
            painter: RainPainter(
              drops,
              _controller,
            ),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
