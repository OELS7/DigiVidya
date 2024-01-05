import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class bgAudioPlayer {
  late ConcatenatingAudioSource concatenatingAudioSource;
  AudioPlayer player = AudioPlayer();
  int playListLength = 0;
  int initialTrack = 0, specificTrack = 0;

  bgAudioPlayer({required this.concatenatingAudioSource});

  void initAudioPlayer() async {
    await _setAudioPlayer();
  }

  Future<void> _setAudioPlayer() async {
    try {
      // await player.setAudioSource(preload: true, concatenatingAudioSource);

      playListLength = concatenatingAudioSource.length;

      await playSpecificTrack(audioTrackNumber: 0);

      print(player.duration);
      print("Total length of Audio track is: $playListLength");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> playSpecificTrack({required int audioTrackNumber}) async {
    if (audioTrackNumber >= 0 && audioTrackNumber < playListLength) {
      try {
        player.stop();

        await player.setAudioSource(
            preload: true,
            ConcatenatingAudioSource(useLazyPreparation: true, children: [
              concatenatingAudioSource.children.elementAt(audioTrackNumber)
            ]));
        await player.play();
      } on PlatformException catch (e) {
        player.dispose();
        player = AudioPlayer();
        await playSpecificTrack(audioTrackNumber: specificTrack);
        //  print(e.toString());
      } on PlayerInterruptedException catch (e) {
        // print(e.message.toString());
      } on PlayerException catch (e) {
        // print(e.toString());
        player.dispose();
        player = AudioPlayer();
        await playSpecificTrack(audioTrackNumber: specificTrack);
      }
    }
  }

  void playNextTrack({required int nextTrackIndex}) async {
    specificTrack = nextTrackIndex;
    player.stop();
    await playSpecificTrack(audioTrackNumber: nextTrackIndex);
  }

  void playPreviousTrack({required int previousTrackIndex}) async {
    specificTrack = previousTrackIndex;
    player.stop();
    await playSpecificTrack(audioTrackNumber: previousTrackIndex);
  }

  void stopAudio() {
    player.stop();
  }

  void disposeAudio() {
    player.dispose();
  }
}
