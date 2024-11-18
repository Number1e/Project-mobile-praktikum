import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:get_storage/get_storage.dart';

class CameraController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var capturedMediaPath = ''.obs;
  var isRecording = false.obs;
  VideoPlayerController? videoController;
  final storage = GetStorage();

  Future<void> takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      capturedMediaPath.value = photo.path;
      storage.write('lastCaptured', photo.path);
    }
  }

  Future<void> startRecording() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      capturedMediaPath.value = video.path;
      storage.write('lastCaptured', video.path);
      isRecording.value = true;
    }
  }

  void stopRecording() {
    isRecording.value = false;
    videoController = VideoPlayerController.file(File(capturedMediaPath.value))
      ..initialize().then((_) {
        videoController!.setLooping(true);
        videoController!.play();
        update();
      });
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}
