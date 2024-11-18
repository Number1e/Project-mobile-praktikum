import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioPath;

  void _pickAudio() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioPath = result.files.single.path!;
      });
    }
  }

  void _playAudio() {
    if (_audioPath != null) {
      _audioPlayer.setSourceDeviceFile(_audioPath!);
      _audioPlayer.resume();
    }
  }

  void _pauseAudio() {
    _audioPlayer.pause();
  }

  void _stopAudio() {
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAudio,
              child: const Text('Pilih Audio'),
            ),
            const SizedBox(height: 20),
            if (_audioPath != null) Text('Audio: $_audioPath'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _playAudio,
                  child: const Text('Putar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pauseAudio,
                  child: const Text('Jeda'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopAudio,
                  child: const Text('Berhenti'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
