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

  // Overlay & UI Control States
  bool _showControls = true;
  Timer? _hideTimer;
  bool _isLocked = false;
  bool _isDraggingSlider = false;
  double _sliderDragValue = 0.0;

  // Settings & Preferences
  double _playbackSpeed = 1.0;
  BoxFit _fitMode = BoxFit.contain; // Contain, Cover, Fill
  bool _isLooping = false;
  double _volume = 1.0;

  // Double-tap Seek Gesture Feedback
  int _tapCount = 0;
  Timer? _tapTimer;
  bool _showLeftFeedback = false;
  bool _showRightFeedback = false;
  Timer? _leftFeedbackTimer;
  Timer? _rightFeedbackTimer;

  // Vertical Volume Drag Feedback
  bool _showVolumeOverlay = false;
  Timer? _volumeOverlayTimer;
  double _dragStartY = 0.0;
  double _initialDragVolume = 1.0;

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
    debugPrint('[VideoPlayer] Playing title: ${widget.title}');

    try {
      final uri = Uri.parse(widget.videoUrl);

      final Map<String, String> headers = {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      };

      final token = ServiceLocator.instance.authLocalStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      _controller = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: headers,
      );

      await _controller!.initialize().timeout(const Duration(seconds: 15));
      _controller!.addListener(_onPlayerStateChanged);
      _controller!.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
          _errorMessage = '';
          _volume = _controller!.value.volume;
        });
        _startHideTimer();
      }
    } catch (e) {
      debugPrint('[VideoPlayer] Error initializing player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load video stream. Please check your internet connection and try again.';
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
      if (mounted && _controller != null && _controller!.value.isPlaying && !_isDraggingSlider && !_isLocked) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    if (_isLocked) return;
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _seekRelative(int seconds) {
    if (_controller == null || !_isInitialized) return;
    final currentPos = _controller!.value.position;
    final targetPos = currentPos + Duration(seconds: seconds);
    final duration = _controller!.value.duration;

    Duration finalPos = targetPos;
    if (targetPos < Duration.zero) {
      finalPos = Duration.zero;
    } else if (targetPos > duration) {
      finalPos = duration;
    }

    _controller!.seekTo(finalPos);
    _startHideTimer();
  }

  void _triggerDoubleTapFeedback({required bool isLeft}) {
    if (isLeft) {
      setState(() {
        _showLeftFeedback = true;
      });
      _leftFeedbackTimer?.cancel();
      _leftFeedbackTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _showLeftFeedback = false);
      });
    } else {
      setState(() {
        _showRightFeedback = true;
      });
      _rightFeedbackTimer?.cancel();
      _rightFeedbackTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _showRightFeedback = false);
      });
    }
  }

  void _onTapUp(TapUpDetails details, BoxConstraints constraints) {
    if (_isLocked) return;
    _tapCount++;
    final dx = details.localPosition.dx;
    final width = constraints.maxWidth;

    if (_tapCount == 1) {
      _tapTimer = Timer(const Duration(milliseconds: 250), () {
        if (_tapCount == 1) {
          _toggleControls();
        }
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      _tapTimer?.cancel();
      _tapCount = 0;
      if (dx < width / 2) {
        _seekRelative(-10);
        _triggerDoubleTapFeedback(isLeft: true);
      } else {
        _seekRelative(10);
        _triggerDoubleTapFeedback(isLeft: false);
      }
    }
  }

  void _onVerticalDragStart(DragStartDetails details, BoxConstraints constraints) {
    if (_isLocked || _controller == null) return;
    _dragStartY = details.localPosition.dy;
    _initialDragVolume = _controller!.value.volume;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_isLocked || _controller == null) return;
    final deltaY = _dragStartY - details.localPosition.dy;
    final totalHeight = constraints.maxHeight;
    final change = deltaY / totalHeight;

    final newVol = (_initialDragVolume + change).clamp(0.0, 1.0);
    _controller!.setVolume(newVol);
    setState(() {
      _volume = newVol;
      _showVolumeOverlay = true;
    });

    _volumeOverlayTimer?.cancel();
    _volumeOverlayTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showVolumeOverlay = false);
    });
  }

  Future<void> _handlePop() async {
    await _resetOrientation();
    if (mounted) {
      Navigator.pop(context);
    }
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

  void _showSettingsModal() {
    _startHideTimer();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Playback Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(color: Colors.white12, height: 24),

                      // Playback Speed Option
                      ListTile(
                        leading: const Icon(Icons.speed, color: Colors.white70),
                        title: const Text('Playback speed', style: TextStyle(color: Colors.white)),
                        trailing: Text(
                          _playbackSpeed == 1.0 ? 'Normal' : '${_playbackSpeed}x',
                          style: const TextStyle(color: Color(0xFFFF0000), fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showSpeedSelectionModal();
                        },
                      ),

                      // Video Aspect Ratio / Fit Mode Option
                      ListTile(
                        leading: const Icon(Icons.aspect_ratio, color: Colors.white70),
                        title: const Text('Video Fit Mode', style: TextStyle(color: Colors.white)),
                        trailing: Text(
                          _fitMode == BoxFit.contain
                              ? 'Fit (Original)'
                              : _fitMode == BoxFit.cover
                                  ? 'Zoom (Crop)'
                                  : 'Stretch (Fill)',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showFitModeSelectionModal();
                        },
                      ),

                      // Loop Video Toggle Option
                      SwitchListTile(
                        activeThumbColor: const Color(0xFFFF0000),
                        secondary: const Icon(Icons.repeat, color: Colors.white70),
                        title: const Text('Loop video', style: TextStyle(color: Colors.white)),
                        value: _isLooping,
                        onChanged: (val) {
                          setModalState(() {
                            _isLooping = val;
                          });
                          setState(() {
                            _isLooping = val;
                            _controller?.setLooping(val);
                          });
                        },
                      ),

                      // Lock Controls Option
                      ListTile(
                        leading: const Icon(Icons.lock_outline, color: Colors.white70),
                        title: const Text('Lock Screen Controls', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _isLocked = true;
                            _showControls = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSpeedSelectionModal() {
    final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Playback Speed',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: speeds.map((speed) {
                    final isSelected = speed == _playbackSpeed;
                    return ListTile(
                      title: Text(
                        speed == 1.0 ? 'Normal' : '${speed}x',
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFFF0000) : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFFF0000)) : null,
                      onTap: () {
                        setState(() {
                          _playbackSpeed = speed;
                          _controller?.setPlaybackSpeed(speed);
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFitModeSelectionModal() {
    final modes = [
      {'label': 'Fit (Original)', 'mode': BoxFit.contain},
      {'label': 'Zoom (Crop to Fill)', 'mode': BoxFit.cover},
      {'label': 'Stretch (Fill Screen)', 'mode': BoxFit.fill},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Video Fit Mode',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              ...modes.map((item) {
                final mode = item['mode'] as BoxFit;
                final isSelected = mode == _fitMode;
                return ListTile(
                  title: Text(
                    item['label'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFFF0000) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFFFF0000)) : null,
                  onTap: () {
                    setState(() {
                      _fitMode = mode;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _tapTimer?.cancel();
    _leftFeedbackTimer?.cancel();
    _rightFeedbackTimer?.cancel();
    _volumeOverlayTimer?.cancel();
    _controller?.removeListener(_onPlayerStateChanged);
    _controller?.dispose();
    _resetOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handlePop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: false,
          bottom: false,
          left: false,
          right: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // 1. Video Player Surface
                  if (_hasError)
                    _buildErrorView()
                  else if (_isInitialized && _controller != null)
                    Positioned.fill(
                      child: FittedBox(
                        fit: _fitMode,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _controller!.value.size.width > 0
                              ? _controller!.value.size.width
                              : 16,
                          height: _controller!.value.size.height > 0
                              ? _controller!.value.size.height
                              : 9,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    )
                  else
                    _buildLoadingView(),

                  // 2. Main Gesture Detector Area (Single Tap / Double Tap / Vertical Drag Volume)
                  if (_isInitialized && !_hasError)
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapUp: (details) => _onTapUp(details, constraints),
                        onVerticalDragStart: (details) => _onVerticalDragStart(details, constraints),
                        onVerticalDragUpdate: (details) => _onVerticalDragUpdate(details, constraints),
                        child: const SizedBox.expand(),
                      ),
                    ),

                  // 3. Double-tap Rewind Feedback (-10s) Overlay
                  if (_showLeftFeedback)
                    IgnorePointer(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: constraints.maxWidth * 0.4,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(100)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fast_rewind, color: Colors.white, size: 42),
                              SizedBox(height: 4),
                              Text(
                                '-10 seconds',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // 4. Double-tap Fast-Forward Feedback (+10s) Overlay
                  if (_showRightFeedback)
                    IgnorePointer(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: constraints.maxWidth * 0.4,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(100)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fast_forward, color: Colors.white, size: 42),
                              SizedBox(height: 4),
                              Text(
                                '+10 seconds',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // 5. Volume Drag Level Indicator Overlay
                  if (_showVolumeOverlay)
                    IgnorePointer(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _volume == 0 ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _volume,
                                    backgroundColor: Colors.white24,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF0000)),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${(_volume * 100).toInt()}%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // 6. Lock Mode Floating Button (When screen is locked)
                  if (_isLocked)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.7),
                        child: IconButton(
                          icon: const Icon(Icons.lock_open, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isLocked = false;
                              _showControls = true;
                            });
                            _startHideTimer();
                          },
                        ),
                      ),
                    ),

                  // 7. Main YouTube Controls Overlay (Top Bar, Center Play, Bottom Bar)
                  if (_isInitialized && !_hasError && !_isLocked)
                    AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: Stack(
                          children: [
                            // Scrim Background Overlay
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.45),
                              ),
                            ),

                            // Top Header Bar (Back button, Video Title, Settings)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black.withValues(alpha: 0.87), Colors.transparent],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                                      onPressed: _handlePop,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.settings, color: Colors.white, size: 24),
                                      onPressed: _showSettingsModal,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Center Play / Rewind / Fast-Forward Controls
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Skip 10s Rewind Button
                                  IconButton(
                                    iconSize: 42,
                                    icon: const Icon(Icons.replay_10, color: Colors.white),
                                    onPressed: () {
                                      _seekRelative(-10);
                                      _triggerDoubleTapFeedback(isLeft: true);
                                    },
                                  ),
                                  const SizedBox(width: 32),

                                  // Center Play / Pause / Replay Button
                                  GestureDetector(
                                    onTap: () {
                                      if (_controller!.value.isPlaying) {
                                        _controller!.pause();
                                      } else {
                                        _controller!.play();
                                        _startHideTimer();
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.6),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white24, width: 1.5),
                                      ),
                                      child: Icon(
                                        _controller!.value.isPlaying
                                            ? Icons.pause
                                            : (_controller!.value.position >= _controller!.value.duration &&
                                                    _controller!.value.duration > Duration.zero)
                                                ? Icons.replay
                                                : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32),

                                  // Skip 10s Forward Button
                                  IconButton(
                                    iconSize: 42,
                                    icon: const Icon(Icons.forward_10, color: Colors.white),
                                    onPressed: () {
                                      _seekRelative(10);
                                      _triggerDoubleTapFeedback(isLeft: false);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Bottom Controls Bar (Play Toggle, Time, YouTube Red Progress Bar, Options)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Custom YouTube Slider Bar
                                    _buildYouTubeProgressBar(),

                                    Row(
                                      children: [
                                        // Play / Pause Toggle
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            if (_controller!.value.isPlaying) {
                                              _controller!.pause();
                                            } else {
                                              _controller!.play();
                                              _startHideTimer();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(width: 12),

                                        // Time Display
                                        Text(
                                          '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),

                                        // Speed Indicator Badge
                                        GestureDetector(
                                          onTap: _showSpeedSelectionModal,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _playbackSpeed == 1.0 ? '1.0x' : '${_playbackSpeed}x',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Aspect Ratio Mode Toggle Button
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.aspect_ratio, color: Colors.white, size: 22),
                                          onPressed: _showFitModeSelectionModal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildYouTubeProgressBar() {
    final duration = _controller!.value.duration.inMilliseconds.toDouble();
    final position = _isDraggingSlider
        ? _sliderDragValue
        : _controller!.value.position.inMilliseconds.toDouble();

    final maxVal = duration > 0 ? duration : 1.0;
    final clampedPos = position.clamp(0.0, maxVal);

    // Get buffer ratio
    double bufferRatio = 0.0;
    if (_controller!.value.buffered.isNotEmpty && duration > 0) {
      final maxBuffered = _controller!.value.buffered.last.end.inMilliseconds.toDouble();
      bufferRatio = (maxBuffered / duration).clamp(0.0, 1.0);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Buffered Bar Background
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: bufferRatio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

              // Interactive YouTube Red Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: const Color(0xFFFF0000), // YouTube Red
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: const Color(0xFFFF0000),
                  overlayColor: const Color(0x33FF0000),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  trackShape: const RectangularSliderTrackShape(),
                ),
                child: Slider(
                  value: clampedPos,
                  min: 0.0,
                  max: maxVal,
                  onChangeStart: (val) {
                    setState(() {
                      _isDraggingSlider = true;
                      _sliderDragValue = val;
                    });
                    _hideTimer?.cancel();
                  },
                  onChanged: (val) {
                    setState(() {
                      _sliderDragValue = val;
                    });
                  },
                  onChangeEnd: (val) {
                    _controller?.seekTo(Duration(milliseconds: val.toInt()));
                    setState(() {
                      _isDraggingSlider = false;
                    });
                    _startHideTimer();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF0000)),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: AppTextStyles.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _isInitialized = false;
                    });
                    _controller?.dispose();
                    _controller = null;
                    _initializePlayer();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                  ),
                  onPressed: _handlePop,
                  child: const Text('Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

