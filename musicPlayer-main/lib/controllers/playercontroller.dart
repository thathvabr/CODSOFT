import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import "package:on_audio_query/on_audio_query.dart";
import 'package:permission_handler/permission_handler.dart';
class PlayerController extends GetxController{
  final OnAudioQuery audioQuery = OnAudioQuery();
  final audioPlayer=AudioPlayer();
  //bool _hasPermission = false;
  //late int index;

  late var isPlaying=false.obs;
  var duration="".obs;
  var position="".obs;
  var max=0.0.obs;
  var value=0.0.obs;
  var index=0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkAndRequestPermissions();
  }
  changeDurationToSeconds(seconds){
    var duration=Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
  updatePosition(){
    audioPlayer.durationStream.listen((event) {
      duration.value=event.toString().split(".")[0];
      max.value=event!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((event) {
      position.value=event.toString().split(".")[0];
      value.value=event!.inSeconds.toDouble();
    });
  }

  playSong(String? path,int index){
    this.index.value=index;
    try{
      audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(path!)),
      );
      audioPlayer.play();

      isPlaying.value=true;
      updatePosition();
    }
    catch(e){
     print(e);
    }
  }
  checkAndRequestPermissions() async {
    // The param 'retryRequest' is false, by default.
    var permission=await Permission.storage.request();
    if(permission.isGranted){
      return audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,sortType: null,uriType: UriType.EXTERNAL,
      );

    }
  }

}