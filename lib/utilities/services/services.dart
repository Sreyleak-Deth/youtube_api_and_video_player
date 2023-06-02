import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:youtube_api_and_video_player/models/channel_info.dart';
import 'package:youtube_api_and_video_player/models/video_model.dart';
import 'package:youtube_api_and_video_player/utilities/constants/constant.dart';

class Services{
  static const CHANNEL_ID = 'UCi51qSaaXvNH0mn2cRL2l4g';
  static const _baseUrl = 'www.googleapis.com';

  static Future<ChannelInfo> getChannelInfo() async {
    Map<String, String> parameters = {
      'part' : 'snippet,statistics,contentDetails',
      'id': CHANNEL_ID,
      'key': Constants.API_KEY,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    Response response = await http.get(uri, headers: headers);
    ChannelInfo channelInfo = channelInfoFromJson(response.body);
    return channelInfo;
  }

  static Future<VideoList> getVideoList({required String playListId, required String pageToken}) async {
    Map<String, String > parameters = {
      'part':'snippet',
      'playlistId': playListId,
      'maxResults':'8',
      'pageToken': pageToken,
      'key': Constants.API_KEY,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );

    Response response = await http.get(uri, headers: headers);
    VideoList videoList = videoListFromJson(response.body);
    return videoList;
  }
}
