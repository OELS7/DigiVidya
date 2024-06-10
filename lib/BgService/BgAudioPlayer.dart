import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
// Define a class named `bgAudioPlayer`
class bgAudioPlayer {
  // Declare a variable for concatenating audio source
  late ConcatenatingAudioSource concatenatingAudioSource;
  // Create an instance of AudioPlayer
  AudioPlayer player = AudioPlayer();
  // Variable to store the length of the playlist
  int playListLength = 0;
  // Variables to store the initial and specific track indices
  int initialTrack = 0, specificTrack = 0;
  // Constructor for `bgAudioPlayer` class with required concatenatingAudioSource
  bgAudioPlayer({required this.concatenatingAudioSource});

   // Method to initialize the audio player
  void initAudioPlayer() async {
    await _setAudioPlayer();// Call the method to set up the audio player
  }

  // Private method to set up the audio player
  Future<void> _setAudioPlayer() async {
    try {
      // await player.setAudioSource(preload: true, concatenatingAudioSource);
      // Get the length of the playlist
      playListLength = concatenatingAudioSource.length;
      // Play the specific track starting from the first track
      await playSpecificTrack(audioTrackNumber: 0);

      print(player.duration);
      print("Total length of Audio track is: $playListLength");
    } catch (e) {
      print(e.toString());
    }
  }

  // Method to play a specific track by track number
  Future<void> playSpecificTrack({required int audioTrackNumber}) async {
    // Check if the track number is valid
    if (audioTrackNumber >= 0 && audioTrackNumber < playListLength) {
      try {
        // Stop the player
        player.stop();
        // Set the audio source to the specific track and play it
        await player.setAudioSource(
            preload: true,
            ConcatenatingAudioSource(useLazyPreparation: true, children: [
              concatenatingAudioSource.children.elementAt(audioTrackNumber)
            ]));
        await player.play();
      } on PlatformException catch (e) {
        // Handle platform-specific exceptions
        player.dispose();  // Dispose the player
        player = AudioPlayer(); // Create a new instance of the player
        await playSpecificTrack(audioTrackNumber: specificTrack); // Retry playing the specific track
        //  print(e.toString());
      } on PlayerInterruptedException catch (e) {
        // Handle player interruption exceptions
        // print(e.message.toString());
      } on PlayerException catch (e) {
        // print(e.toString());
        player.dispose(); // Dispose the player
        player = AudioPlayer(); // Create a new instance of the player
        await playSpecificTrack(audioTrackNumber: specificTrack); // Retry playing the specific track
      }
    }
  }
  // Method to play the next track
  void playNextTrack({required int nextTrackIndex}) async {
    specificTrack = nextTrackIndex; // Update the specific track index
    player.stop(); // Stop the player
    await playSpecificTrack(audioTrackNumber: nextTrackIndex); // Play the next track
  }

  // Method to play the previous track
  void playPreviousTrack({required int previousTrackIndex}) async {
    specificTrack = previousTrackIndex; // Update the specific track index
    player.stop();// Stop the player
    await playSpecificTrack(audioTrackNumber: previousTrackIndex); // Play the previous track
  }

   // Method to stop the audio playback
  void stopAudio() {
    player.stop();// Stop the player
  }

  // Method to dispose the audio player
  void disposeAudio() {
    player.dispose(); // Dispose the player
  }

  // Method to check if the player is initialized and playing
  bool isPlayerInitialized(){
   return player.playing; // Return the playing status of the player
  }
}
