import 'dart:async';
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
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isRetrying = false;

  // Overlay & UI Control States
  bool _showControls = true;
  Timer? _hideTimer;

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
    debugPrint('[VideoPlayer] Playing title: ${widget.title}, URL: ${widget.videoUrl}');

    final cleanUrl = widget.videoUrl.trim();
    if (cleanUrl.isEmpty || (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://'))) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No valid video stream URL available for this content.';
      });
      return;
    }

    try {
      final uri = Uri.parse(cleanUrl);

      final Map<String, String> headers = {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      };

      // Only send app Bearer Authorization to CultureBox domain to avoid HTTP 401 on external CDNs
      if (cleanUrl.contains('cultureboxtv.com')) {
        final token = ServiceLocator.instance.authLocalStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      _controller = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: headers,
      );

      await _controller!.initialize().timeout(const Duration(seconds: 15));
      _controller!.addListener(_onPlayerStateChanged);

      setState(() {
        _isInitialized = true;
        _hasError = false;
        _isRetrying = false;
      });

      await _controller!.play();
      _startHideTimer();
    } catch (e) {
      debugPrint('[VideoPlayer] Error initializing player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Unable to play video stream. Please check network connection.';
          _isRetrying = false;
        });
      }
    }
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _controller != null && _controller!.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  Future<void> _retryPlayback() async {
    setState(() {
      _isRetrying = true;
      _hasError = false;
    });
    _controller?.dispose();
    _controller = null;
    await _initializePlayer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.removeListener(_onPlayerStateChanged);
    _controller?.dispose();
    _resetOrientation();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await _resetOrientation();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video Content
              if (_isInitialized && _controller != null)
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              else if (_hasError)
                Center(
                  child: Padding(
                    padding: AppSpacing.all24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                        AppSpacing.vGap16,
                        Text(
                          _errorMessage,
                          style: AppTextStyles.bodyText,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vGap24,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.logoRedOrange,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _isRetrying ? null : _retryPlayback,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                            AppSpacing.hGap16,
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Back'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(color: AppColors.logoGold),
                ),

              // Controls Overlay
              if (_showControls && _isInitialized)
                Container(
                  color: Colors.black45,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Bar
                        Padding(
                          padding: AppSpacing.all16,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              AppSpacing.hGap12,
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: AppTextStyles.detailsTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center Play/Pause Button
                        IconButton(
                          iconSize: 64,
                          icon: Icon(
                            _controller!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller!.value.isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
                              }
                            });
                            _startHideTimer();
                          },
                        ),

                        // Bottom Control Bar
                        Padding(
                          padding: AppSpacing.all16,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress Bar
                              VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.logoRedOrange,
                                  bufferedColor: Colors.white30,
                                  backgroundColor: Colors.white12,
                                ),
                              ),
                              AppSpacing.vGap8,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                                    style: AppTextStyles.cardSubtitle,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _controller!.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_controller!.value.volume > 0) {
                                          _controller!.setVolume(0);
                                        } else {
                                          _controller!.setVolume(1);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
