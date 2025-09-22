import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SimpleAudioScreen extends StatefulWidget {
  const SimpleAudioScreen({super.key});

  @override
  State<SimpleAudioScreen> createState() => _SimpleAudioScreenState();
}

class _SimpleAudioScreenState extends State<SimpleAudioScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playAudio() async {
    try {
      await _player.play(AssetSource('assets/level-up-04-243762.mp3'));
    } catch (e) {

     Get.snackbar('Error', 'Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audio Button Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: _playAudio,
          child: const Text("Play Audio"),
        ),
      ),
    );
  }
}
