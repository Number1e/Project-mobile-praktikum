import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/camera_controller.dart';
import 'package:video_player/video_player.dart';
import 'audio_screen.dart'; // Tambahkan impor ini

class CameraScreen extends StatelessWidget {
  final cameraController = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shop Camera'),
      ),
      body: Obx(() {
        if (cameraController.capturedMediaPath.isEmpty) {
          return const Center(
            child: Text('Ambil foto atau video untuk menampilkannya di sini.'),
          );
        } else if (cameraController.capturedMediaPath.value.endsWith('.mp4')) {
          return FutureBuilder(
            future: cameraController.videoController?.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio:
                      cameraController.videoController!.value.aspectRatio,
                  child: VideoPlayer(cameraController.videoController!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Image.file(File(cameraController.capturedMediaPath.value));
        }
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: cameraController.takePicture,
            heroTag: 'photo',
            child: const Icon(Icons.camera),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              if (!cameraController.isRecording.value) {
                cameraController.startRecording();
              } else {
                cameraController.stopRecording();
              }
            },
            heroTag: 'video',
            child: Obx(() => Icon(cameraController.isRecording.value
                ? Icons.stop
                : Icons.videocam)),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              // Navigasi ke AudioScreen
              Get.to(() => AudioScreen());
            },
            heroTag: 'audio',
            child: const Icon(Icons.music_note),
          ),
        ],
      ),
    );
  }
}
