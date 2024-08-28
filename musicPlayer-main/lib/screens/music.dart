import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicplayergetx/colors/colors.dart';
import 'package:musicplayergetx/controllers/playercontroller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
class Player extends StatefulWidget {
  final song;
  //const Player({Key? key}) : super(key: key);
  final List<SongModel>data;
  Player({required this.song,required this.data,Key? key});
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    var controller=Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(backgroundColor: acolor,),
      body: Obx(()=>
          Column(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 125,
                child: QueryArtworkWidget(

                  id:widget.data[controller.index.value].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Icon(Icons.music_note,color: tcolor,),
                  artworkHeight: 250,
                  artworkWidth: 350,
                ),

              ),
            )),
            SizedBox(height: 20,),
            Expanded(child:Container(
              decoration: BoxDecoration(color: tilecolor,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                Center(child: Text("${widget.data[controller.index.value].displayNameWOExt}",style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,color: tcolor,fontSize: 12))),
                  Obx(
                    ()=> Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                      children:[
                        Text("${controller.position}",style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,color: tcolor,fontSize: 16)),
                      Expanded(child:

                        Slider(
                            thumbColor: bcolor,
                            activeColor: bcolor,
                            inactiveColor: bgcolor,
                            min: Duration(seconds: 0).inSeconds.toDouble(),
                            max: controller.max.value,
                            value: controller.value.value,
                            onChanged: (newvalue) {
                              setState(() {
                                controller.updatePosition();
                                controller.changeDurationToSeconds(newvalue.toInt());
                              });
                            }
                        )

                      ),
                        Text("${controller.duration}",style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,color: tcolor,fontSize: 16)),
                      ]
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                    Obx(
                      ()=> Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:controller.index.value>0?IconButton(onPressed: (){
                            if(controller.index.value==0){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("It is the first Song"),backgroundColor: Colors.redAccent,));
                            }
                            else{
                              controller.playSong(widget.data[controller.index.value-1].uri, controller.index.value-1);
                            }
                          }, icon: Icon(Icons.skip_previous,color: tcolor,size: 36,)):Icon(Icons.shuffle),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(onPressed: (){
                            if(controller.isPlaying.value){
                              //controller.index.value=
                              controller.audioPlayer.pause();
                              controller.isPlaying.value=false;
                              setState(() {});
                            }
                            else{
                              controller.audioPlayer.play();
                              controller.isPlaying.value=true;
                              setState(() {});
                            }
                          }, icon: controller.isPlaying.value?Icon(Icons.stop_circle_rounded,color: tcolor,size:72):Icon(Icons.play_circle,color: tcolor,size:72)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:(controller.index.value+1<widget.data.length)?IconButton(onPressed: (){
                            if(controller.index.value+1>=widget.data.length){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("It is the Last Song No more Songs"),backgroundColor: Colors.redAccent,));
                            }
                            else{
                              controller.playSong(widget.data[controller.index.value+1].uri, controller.index.value+1);
                            }
                          }, icon: Icon(Icons.skip_next,color: tcolor,size:36)):Icon(Icons.shuffle),
                        ),
                      ],
                    ),
                  )
                ],

              ),
            )),
          ],
        ),
      ),
    );
  }
}
