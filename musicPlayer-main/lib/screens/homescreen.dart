import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:musicplayergetx/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:musicplayergetx/controllers/playercontroller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'music.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController s=TextEditingController();

  @override
  Widget build(BuildContext context) {
    var controller=Get.put(PlayerController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: acolor,
          leading: IconButton(
            onPressed:(){},
            icon: Icon(Icons.menu_open,color:tcolor),
          ),
          centerTitle: true,
          title: Text("Beats++",style:GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.headlineMedium,color: tcolor)),
        bottom: PreferredSize(child:Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(controller: s,decoration:InputDecoration(hintText:"Enter the Song that you want to search",icon: Icon(Icons.search,color:tcolor),border: InputBorder.none,hintStyle:TextStyle(color: Colors.white)),style:GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,color: tcolor,),),
          ),decoration:BoxDecoration(color: bgcolor,borderRadius: BorderRadius.circular(10.0),)),
        ), preferredSize: Size.fromHeight(50)),
    ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,sortType: null,uriType: UriType.EXTERNAL,),
            builder: (BuildContext context,snapshot){
            if(snapshot.data==null){
              return Center(
                child: CircularProgressIndicator(backgroundColor: bgcolor,color: bcolor,),

              );
            }
            else if(snapshot.data!.isEmpty){
            return Center(child: Text("Hey!We Could'nt find any Songs at the moment!",style:GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.headline4,color: tcolor,),));
            }
            else{
              return ListView.builder(itemBuilder: (BuildContext context,int index){
                return ListTile(
                  onTap: (){

                    controller.playSong(snapshot.data![index].uri,index);
                    Get.to(()=>Player(song:snapshot.data![index],data:snapshot.data!));
                  },
                  leading: QueryArtworkWidget(
                    id:snapshot.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note,color: tcolor,),
                  ),
                  title: Text("${snapshot.data![index].displayNameWOExt}",style:GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyMedium,color: tcolor)),
                  trailing:IconButton(icon: Icon(Icons.play_circle,color: tcolor,),onPressed: (){
                    controller.playSong(snapshot.data![index].uri,index);
                    Get.to(()=>Player(song:snapshot.data![index],data: snapshot.data!,));
                  },),
                );
              },itemCount: snapshot.data!.length,
                physics: BouncingScrollPhysics(),
              );
            }
            }
        ),
      ),
    );
  }
}
