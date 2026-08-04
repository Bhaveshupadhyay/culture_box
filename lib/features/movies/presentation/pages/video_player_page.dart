import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String videoUrl;
  final bool isTrailer;

  const VideoPlayerPage({
    super.key,
    required this.title,
    required this.videoUrl,
    this.isTrailer = false,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setLandscapeOrientation();
    _initializePlayer();
  }

  Future<void> _setLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _resetOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _initializePlayer() async {
    // Print the video link using debugPrint as requested by user
    debugPrint('[VideoPlayer] ========================================');
    debugPrint('[VideoPlayer] Playing video title: ${widget.title}');
    debugPrint('[VideoPlayer] Playing video URL: ${widget.videoUrl}');
    debugPrint('[VideoPlayer] ========================================');

    try {
      final uri = Uri.parse(widget.videoUrl);

      // Attach headers to prevent 403 Forbidden from ExoPlayer/CDN
      final Map<String, String> headers = {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      };

      final token = ServiceLocator.instance.authLocalStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: headers,
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        fullScreenByDefault: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.logoRedOrange,
          handleColor: AppColors.logoGold,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.logoGold),
          ),
        ),
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('[VideoPlayer] Error initializing player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load video stream (HTTP Error / 403).';
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    _resetOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_hasError)
              Center(
                child: Padding(
                  padding: AppSpacing.all24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                      AppSpacing.vGap16,
                      Text(
                        _errorMessage,
                        style: AppTextStyles.emptyStateTitle,
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.vGap8,
                      SelectableText(
                        'URL: ${widget.videoUrl}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.vGap24,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.logoRedOrange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized)
              Chewie(controller: _chewieController!)
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.logoGold),
                    AppSpacing.vGap16,
                    Text(
                      'Loading video player...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () async {
                    await _resetOrientation();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
