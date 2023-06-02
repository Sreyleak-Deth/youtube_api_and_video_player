import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api_and_video_player/models/channel_info.dart';
import 'package:youtube_api_and_video_player/models/video_model.dart';
import 'package:youtube_api_and_video_player/screens/video_screen.dart';
import 'package:youtube_api_and_video_player/utilities/services/services.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>{

  late ChannelInfo channelInfo;
  late Item item;
  late bool isLoading;
  late String playListId;
  late String nextPageToken;
  late VideoList videoList;

  @override
  void initState(){
    super.initState();
    isLoading = true;
    videoList = VideoList();
    nextPageToken = '';
    videoList.videos = [];
    _getChannelInfo();
  }

  _getChannelInfo() async {
    channelInfo = await Services.getChannelInfo();
    item = channelInfo.items[0];
    playListId = item.contentDetails.relatedPlaylists.uploads;
    await _loadingVideo();
    setState(() {
      isLoading = false;
    });
  }

  _loadingVideo() async {
    VideoList tempVideoList = await Services.getVideoList(
      playListId: playListId,
      pageToken: nextPageToken,
    );

    nextPageToken = tempVideoList.nextPageToken ?? '';
    videoList.videos!.addAll(tempVideoList.videos!);
    print('Videos: ${videoList.videos!.length}');
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("YouTube Channel"),
      ),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            buildInfoView(context),
            const SizedBox(height: 12.0,),
            Expanded(
              child: ListView.builder(
                itemCount: videoList.videos!.length,
                itemBuilder: (context, index){
                  VideoItem videoItem = videoList.videos![index];
                  return InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context){
                            return VideoScreen(videoItem: videoItem);
                          }
                        )
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: videoItem.snippet.thumbnails.thumbnailsDefault.url,
                          ),
                          const SizedBox(width: 20),
                          Flexible(child: Text(videoItem.snippet.title)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoView(BuildContext context){
    return isLoading? const CircularProgressIndicator(): Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  item.snippet.thumbnails.medium.url,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  item.snippet.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(item.statistics.videoCount),
              const SizedBox(width: 20),

            ],
          ),
        ),
      ),
    );
  }
 }
