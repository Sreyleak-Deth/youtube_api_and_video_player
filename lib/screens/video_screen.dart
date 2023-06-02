import 'package:flutter/material.dart';
import 'package:youtube_api_and_video_player/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget{

  final VideoItem videoItem;

  const VideoScreen({
    super.key,
    required this.videoItem,
  });

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen>{
  late YoutubePlayerController controller;
  late bool isPlayerReady;

  @override
   void initState(){
    super.initState();
    isPlayerReady = false;
    controller = YoutubePlayerController(
      initialVideoId: widget.videoItem.snippet.resourceId.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(listener);
  }

  void listener(){
    if(isPlayerReady && mounted && !controller.value.isFullScreen){

    }
  }

  @override
  void deactivate(){
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text(widget.videoItem.snippet.title),
    ),
    body: Container(
      padding: const EdgeInsets.all(8.0),
      child: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready');
          isPlayerReady = true;
        },
      ),
    ),
   );
  }
}
