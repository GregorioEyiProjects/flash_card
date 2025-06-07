import 'package:flash_card/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final bool? isExpanded;
  const AudioPlayerWidget({super.key, required this.audioUrl, this.isExpanded});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    debugPrint("AudioPlayerWidget initialized with URL: ${widget.audioUrl}");
  }

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      setState(() {
        _isExpanded = widget.isExpanded ?? false;
      });
    }
  }

  //Dispose
  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      //Pause the audio
      await _audioPlayer.pause();
    } else {
      // Start playing audio

      //Show loading indicator
      setState(() {
        _isLoading = true;
      });

      try {
        await _audioPlayer.setUrl(widget.audioUrl); // Set the audio URL
        await _audioPlayer.setVolume(1);
        await _audioPlayer.play(); // Play audio
      } catch (e) {
        debugPrint("Error playing audio: $e");
      } finally {
        setState(() {
          _isLoading = false;
          _isPlaying = true; // Change the playing state
        });
      }
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        // Displaying the audio URL
        Text(
          "Pronunciation", //_isExpanded
          style: textTheme.labelLarge /* TextStyle(
            fontSize: 12,
            color:
                _isExpanded
                    ? AppColors.textColorWhenIsEpanded
                    : AppColors.textColorWhenNotExpanded,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ), */,
        ),
        SizedBox(height: 10),
        _isLoading
            ? CircularProgressIndicator() // Show loading while buffering
            : IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30,
                color: Colors.blue,
              ),
              onPressed: _playPauseAudio, // Call play/pause function
            ),
      ],
    );
  }
}
