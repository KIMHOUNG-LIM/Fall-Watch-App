import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          icon: Icons.replay_10,
          onPressed: () {
            controller.seekTo(
              controller.value.position - const Duration(seconds: 10),
            );
          },
        ),
        _controlButton(
          icon: controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          onPressed: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        _controlButton(
          icon: Icons.forward_10,
          onPressed: () {
            controller.seekTo(
              controller.value.position + const Duration(seconds: 10),
            );
          },
        ),
      ],
    );
  }

  Widget _controlButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Icon(
          icon,
          size: 35,
          color: Colors.orange,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
