import 'package:cloud_audio_player/cloud_player_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:play_fm/model/radio_model.dart';
import 'package:volume/volume.dart';
import 'package:cloud_audio_player/cloud_audio_player.dart';
import 'dart:async';

enum PlayerState { STOPPED, PLAYING, ERROR, LOADING }

class PlayerScreen extends StatefulWidget {
  PlayerScreen({@required this.radioStations, @required this.index});

  //final RadioModel radio;
  final List<RadioModel> radioStations;
  int index;

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PlayerState playerState;
  int maxVol, currentVol;
  CloudAudioPlayer _player;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    updateVolumes();

    _player = CloudAudioPlayer();
    _player.addListeners(
      statusListener: _onStatusChanged,
    );

    widget.radioStations[widget.index].link.isNotEmpty
        ? _onLoad(widget.radioStations[widget.index].link)
        : null;
  }

  void _onLoad(String url) {
    _player.play(url);
    setState(() => playerState = PlayerState.PLAYING);
  }

  void _onStop() {
    _player.stop();
    setState(() => playerState = PlayerState.STOPPED);
  }

  //================== PLAYER EVENT ================
  //Player Event
  _onStatusChanged(CloudPlayerState status) {
    print(status);
    setState(() {
      //_statusText = status.toString();
      if (status == CloudPlayerState.STOPPED) {
        setState(() => playerState = PlayerState.STOPPED);
      } else if (status == CloudPlayerState.PLAYING) {
        setState(() => playerState = PlayerState.PLAYING);
      } else if (status == CloudPlayerState.ERROR) {
        setState(() => playerState = PlayerState.ERROR);
      } else if (status == CloudPlayerState.LOADING) {
        setState(() => playerState = PlayerState.LOADING);
      }
    });
    print("after $status");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //audioPlayer.stop();
    _player.stop();
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
                          fit: BoxFit.fill)),
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
                              _player.stop();
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Icon(FontAwesomeIcons.caretDown),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                          ),
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
                        playerState
                            .toString()
                            .substring(playerState.toString().indexOf('.') + 1),
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
                  _onStop();
                  _onLoad(_getRadio(widget.index - 1).link);
                },
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
                  onPressed: () => playerState == PlayerState.STOPPED
                      ? _onLoad(_getRadio(widget.index).link)
                      : _onStop(),
                  child: Icon(
                    playerState == PlayerState.STOPPED
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
                  _onStop();
                  _onLoad(_getRadio(widget.index + 1).link);
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
          Slider(
            min: 0,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.volume_down,
                  size: 15.0,
                ),
                Icon(
                  Icons.volume_up,
                  size: 15.0,
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: () => setSleepTimer(1), child: Icon(Icons.alarm)),
              FlatButton(onPressed: () {}, child: Icon(Icons.add_circle)),
              FlatButton(onPressed: () {}, child: Icon(Icons.favorite)),
              FlatButton(onPressed: () {}, child: Icon(Icons.settings)),
            ],
          ),
          SizedBox(
            height: 58.0,
          )
        ],
      ),
    );
  }

  void setSleepTimer(int minutes) {
    print("TIMER SET");
    Timer(Duration(minutes: minutes), () {
      print("STOPPING");
      _onStop();
    });
  }
}
