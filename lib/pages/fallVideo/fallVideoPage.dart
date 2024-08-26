import 'package:fall_watch_app/pages/fallVideo/fullScreenVideo.dart';
import 'package:fall_watch_app/pages/fallVideo/videoControl.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FallVideoPage extends StatefulWidget {
  final String videoURL;
  final String cameraID;
  final String location;
  final String date;

  const FallVideoPage({
    Key? key,
    required this.videoURL,
    required this.cameraID,
    required this.location,
    required this.date,
  }) : super(key: key);

  @override
  State<FallVideoPage> createState() => _FallVideoPageState();
}

class _FallVideoPageState extends State<FallVideoPage> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {}); // Update the UI only if the widget is still mounted
        }
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(controller: _controller),
        ),
      ).then((_) {
        setState(() {
          _isFullScreen = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.date,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Fall Detection Video',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _controller.value.isInitialized
                ? GestureDetector(
                    onTap: _toggleFullScreen,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.orange),
            const SizedBox(height: 10),
            VideoControls(controller: _controller),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Return to List Page'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(230, 81, 0, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



