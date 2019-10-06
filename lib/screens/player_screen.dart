import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_fm/model/radio_model.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:volume/volume.dart';

enum PlayerState { stopped, playing, paused }

class PlayerScreen extends StatefulWidget {
  PlayerScreen({@required this.radioStations, @required this.index});

  //final RadioModel radio;
  final List<RadioModel> radioStations;
  int index;

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  String name = "Radio Kantipur - 96.1 MHz";

  String image =
      "https://dl.dropboxusercontent.com/s/w0n053n9a48zsmw/radio_kantipur.jpg";

  String link = "http://kantipur-stream.softnep.com:7248/stream";
  AudioPlayer audioPlayer = new AudioPlayer();
  PlayerState playerState;
  double _volumeValue = 10.0;
  int maxVol, currentVol;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    updateVolumes();

    widget.radioStations[widget.index].link.isNotEmpty
        ? play(widget.radioStations[widget.index].link)
        : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.stop();
  }

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  setVol(int i) async {
    await Volume.setVol(i);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  Future<void> play(String url) async {
    await audioPlayer.play(url);
    setState(() => playerState = PlayerState.playing);
  }

  Future<void> pause() async {
    await audioPlayer.pause();

    setState(() => playerState = PlayerState.paused);
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
    });
  }

  RadioModel _getRadio(int currentIndex) {
    print(
        "$currentIndex and ${widget.index} and ${widget.radioStations.length}");
    if (currentIndex > widget.radioStations.length - 1) {
      currentIndex = 0;
    } else if (currentIndex < 0) {
      currentIndex = widget.radioStations.length - 1;
    }
    widget.index = currentIndex;
    RadioModel radioData = widget.radioStations[currentIndex];
    print(radioData.name);

    return radioData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(_getRadio(widget.index).image),
                          fit: BoxFit.cover)),
                ),
                Container(
                  height: 500.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF2B159E).withOpacity(0.4),
                      Color(0xFF2B159E)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 52.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Icon(FontAwesomeIcons.caretDown),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                          ),
//                          Column(
//                            children: <Widget>[
//                              Text(name),
//                              Text("PLAYLIST"),
//                            ],
//                          ),
                          Icon(FontAwesomeIcons.plus),
                        ],
                      ),
                      Spacer(),
                      Text(
                        _getRadio(widget.index).name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0),
                      ),
                      Text(
                        "Buffering",
                        style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  stop();
                  play(_getRadio(widget.index - 1).link);
                },
//                onPressed: () => playerState == PlayerState.playing
//                    ? () {
//                        stop();
//                        play(_getRadio(widget.index - 1).link);
//                      }
//                    : null,
                child: Icon(
                  Icons.fast_rewind,
                  size: 42.0,
                ),
              ),
              SizedBox(
                width: 52.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: FlatButton(
                  onPressed: () => playerState == PlayerState.paused ||
                          playerState == PlayerState.stopped
                      ? play(_getRadio(widget.index).link)
                      : stop(),
                  child: Icon(
                    playerState == PlayerState.paused ||
                            playerState == PlayerState.stopped
                        ? Icons.play_arrow
                        : Icons.stop,
                    size: 60.0,
                  ),
                ),
              ),
              SizedBox(
                width: 52.0,
              ),
              FlatButton(
                onPressed: () {
                  stop();
                  play(_getRadio(widget.index + 1).link);
                },
//                onPressed: playerState == PlayerState.playing
//                    ? () {
//                        stop();
//                        play(_getRadio(widget.index + 1).link);
//                      }
//                    : null,
                child: Icon(
                  Icons.fast_forward,
                  size: 42.0,
                ),
              )
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.volume_down,
                size: 15.0,
              ),
              Slider(
                min: 0,
                divisions: maxVol,
                max: maxVol / 1.0,
                onChanged: (double value) {
                  setState(() {
                    setVol(value.toInt());
                    updateVolumes();
                  });
                },
                value: currentVol / 1.0,
                activeColor: Colors.pink,
              ),
              Icon(
                Icons.volume_up,
                size: 15.0,
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.alarm),
              FlatButton(
                  onPressed: () => print(audioPlayer.state.toString()),
                  child: Icon(Icons.add_circle)),
              Icon(Icons.favorite),
              Icon(Icons.settings),
            ],
          ),
          SizedBox(
            height: 58.0,
          )
        ],
      ),
    );
  }
}
