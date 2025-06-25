import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CategoryItemButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final String videoUrl;
  final String type;

  const CategoryItemButton({
    required this.imagePath,
    required this.text,
    required this.videoUrl,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(videoUrl: videoUrl, type: type),
        ));
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 100, // Adjust the height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final String type;

  const FullScreenVideoPlayer({required this.videoUrl, required this.type});

  bool isYouTube(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  @override
  Widget build(BuildContext context) {
    return isYouTube(videoUrl)
        ? YouTubeScreen(videoUrl: videoUrl)
        : M3U8Screen(videoUrl: videoUrl);
  }
}

class YouTubeScreen extends StatefulWidget {
  final String videoUrl;
  const YouTubeScreen({required this.videoUrl});

  @override
  _YouTubeScreenState createState() => _YouTubeScreenState();
}

class _YouTubeScreenState extends State<YouTubeScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131A28),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != 0) {
            Navigator.of(context).pop();
          }
        },
        child: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}

class M3U8Screen extends StatefulWidget {
  final String videoUrl;

  const M3U8Screen({required this.videoUrl});

  @override
  _M3U8ScreenState createState() => _M3U8ScreenState();
}

class _M3U8ScreenState extends State<M3U8Screen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          allowedScreenSleep: false,
          allowFullScreen: false, // Disable built-in fullscreen as we handle it
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.blueAccent,
            handleColor: Colors.blueAccent,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.grey.withOpacity(0.5),
          ),
          placeholder: Container(
            color: Color(0xFF131A28),
          ),
          autoInitialize: true,
        );
      });
    }).catchError((error) {
      // Handle initialization error
      print("Video player initialization error: $error");
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131A28),
      body: SafeArea(
        child: _chewieController != null && 
               _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != 0) {
                    Navigator.of(context).pop();
                  }
                },
                child: Center(
                  child: Chewie(controller: _chewieController!),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              ),
      ),
    );
  }
}