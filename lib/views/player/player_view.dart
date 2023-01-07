
import 'package:ambientestereo/views/player/config.dart';
import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);

    //final isResumed = state == AppLifecycleState.resumed;
    final isDetached = state == AppLifecycleState.detached;
    final isInactive = state == AppLifecycleState.inactive;
    final isBackground = state == AppLifecycleState.paused;
    
    if( isInactive || isBackground ){
      //print('RADIO Inactivo..........');
    }
    else if( isDetached ){
      //print('RADIO Destroyed..........');
      _radioPlayer.stop();
      super.dispose();
    }

  }


  void initRadioPlayer() {

    _radioPlayer.setChannel(
      title: 'Radio Ambiente Stereo 88.4FM',
      url: 'https://radio06.cehis.net:9036/stream',
      imagePath: 'assets/others/logo.png',
    ).then((_) {
      if (Config.autoplay) _radioPlayer.play();
    });

    _radioPlayer.stateStream.listen( (value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });




  }

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Ink(
          decoration: const ShapeDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            shape: CircleBorder(),
          ),
          child: 
            IconButton(
              onPressed: () {
                isPlaying ? 
                _radioPlayer.pause() 
                : 
                _radioPlayer.play();
              },
              iconSize: 38,
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: const Color.fromARGB(255, 112, 226, 119),
              ),
        ),
        ),
    );
  }
}
