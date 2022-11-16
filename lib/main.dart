import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: '分歧终端机'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _isBtnCanClick;
  late String _imagePathYou;
  late String _imagePathMe;
  Timer? _timer;
  final _random = Random();
  final _imgArray = [
    'image/guess_cloth.png',
    'image/guess_scissors.png',
    'image/guess_stone.png'
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _change() {
    if (_isBtnCanClick) {
      setState(() {
        _isBtnCanClick = false;
        _imagePathYou = 'image/guess_anim.gif';
        _imagePathMe = 'image/guess_anim.gif';
      });
      _startCountdownTimer();
    }
  }

  int _oneIndex = 0;
  int _twoIndex = 0;

  void _startCountdownTimer() {
    const duration = Duration(seconds: 3);

    callback(timer) => {
          setState(() {
            randomIndex();
          })
        };
    _timer = Timer.periodic(duration, callback);
    play(AssetSource('counter.mp3'));
  }

  void randomIndex() {
    _oneIndex = _random.nextInt(_imgArray.length);
    _twoIndex = _random.nextInt(_imgArray.length);
    if (_oneIndex == _twoIndex) {
      randomIndex();
    } else {
      _imagePathYou = _imgArray[_oneIndex];
      _imagePathMe = _imgArray[_twoIndex];
      stopTimer();
    }
  }

  void stopTimer() {
    _isBtnCanClick = true;
    _timer?.cancel();
  }

  Future<void>  play(Source source) async {
    await _audioPlayer.setSource(source);
    await _audioPlayer.stop();
    await _audioPlayer.play(source);
  }

  @override
  void initState() {
    super.initState();
    _isBtnCanClick = true;
    _imagePathYou = _imgArray[2];
    _imagePathMe = _imgArray[2];
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  @override
  void deactivate() {
    super.deactivate();
    _audioPlayer.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _imagePathYou,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      Container(
                        margin: const EdgeInsets.all(30.0),
                        child: const Text('1号选手'),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _imagePathMe,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                      Container(
                        margin: const EdgeInsets.all(30.0),
                        child: const Text('2号选手'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(50.0, 180.0, 50.0, 20.0),
              child: ElevatedButton(
                onPressed: _change,
                child: const Text('开始'),
                // textColor: Colors.white,
                // disabledTextColor: Colors.white54,
                // color: Colors.blue,
                // disabledColor: Colors.lightBlue,
                // highlightColor: Colors.deepPurpleAccent,
                // splashColor: Colors.deepPurple,
                // shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(30.0)),
                // padding:
                // EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
