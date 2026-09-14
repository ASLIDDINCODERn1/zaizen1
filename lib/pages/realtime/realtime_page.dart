import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/ui/app_theme.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key});

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  int _index = 0;
  int _gen = 0;
  bool _camOn = true;
  bool _micOn = true;
  bool _settingsOpen = true;
  bool _loading = true;
  String? _error;

  Map<String, String> _t(String code) {
    switch (code) {
      case 'ru':
        return {'live': 'Realtime', 'err': 'Камера недоступна', 'retry': 'Повторить'};
      case 'en':
        return {'live': 'Realtime', 'err': 'Camera unavailable', 'retry': 'Retry'};
      case 'ja':
        return {'live': 'Realtime', 'err': 'カメラを使えません', 'retry': '再試行'};
      default:
        return {'live': 'Realtime', 'err': 'Kamera ochilmadi', 'retry': 'Qayta urinish'};
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _boot();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed && _camOn) {
      _openCamera();
    }
  }

  Future<void> _boot() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final cam = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    if (!mounted) return;
    if (!cam.isGranted) {
      setState(() {
        _loading = false;
        _error = 'camera';
      });
      return;
    }
    _micOn = mic.isGranted;
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'empty';
        });
        return;
      }
      final front = _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
      _index = front >= 0 ? front : 0;
      await _openCamera();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'fail';
      });
    }
  }

  Future<void> _openCamera() async {
    if (_cameras.isEmpty) return;
    final gen = ++_gen;
    final old = _controller;
    _controller = null;
    await old?.dispose();
    if (!mounted || gen != _gen) return;

    Future<CameraController> create(bool audio) async {
      final next = CameraController(
        _cameras[_index],
        ResolutionPreset.medium,
        enableAudio: audio,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await next.initialize();
      await next.lockCaptureOrientation(DeviceOrientation.portraitUp);
      return next;
    }

    try {
      var next = await create(_micOn);
      if (!mounted || gen != _gen) {
        await next.dispose();
        return;
      }
      setState(() {
        _controller = next;
        _loading = false;
        _error = null;
        _camOn = true;
      });
    } catch (_) {
      try {
        final next = await create(false);
        if (!mounted || gen != _gen) {
          await next.dispose();
          return;
        }
        setState(() {
          _controller = next;
          _loading = false;
          _error = null;
          _camOn = true;
          _micOn = false;
        });
      } catch (_) {
        if (!mounted || gen != _gen) return;
        setState(() {
          _loading = false;
          _error = 'fail';
        });
      }
    }
  }

  Future<void> _flip() async {
    if (_cameras.length < 2 || _loading) return;
    setState(() {
      _index = (_index + 1) % _cameras.length;
      _loading = true;
    });
    await _openCamera();
  }

  Future<void> _toggleCam() async {
    if (_camOn) {
      setState(() => _camOn = false);
      try {
        await _controller?.pausePreview();
      } catch (_) {}
      return;
    }
    setState(() {
      _camOn = true;
      _loading = true;
    });
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      try {
        await controller.resumePreview();
        if (mounted) setState(() => _loading = false);
        return;
      } catch (_) {}
    }
    await _openCamera();
  }

  Future<void> _toggleMic() async {
    if (_loading) return;
    setState(() {
      _micOn = !_micOn;
      _loading = true;
    });
    await _openCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _gen++;
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    final t = _t(context.watch<LocaleProvider>().locale.languageCode);
    final controller = _controller;
    final ready = controller != null && controller.value.isInitialized && _camOn && _error == null && !_loading;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (ready)
            _FullPreview(controller: controller)
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [c.bgTop, c.bgBottom], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Center(
                child: _loading
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.video_camera_solid, color: c.textMuted, size: 42),
                          const SizedBox(height: 10),
                          Text(t['err']!, style: TextStyle(color: c.textMuted)),
                          const SizedBox(height: 12),
                          CupertinoButton(
                            onPressed: _boot,
                            child: Text(t['retry']!, style: TextStyle(color: c.primary)),
                          ),
                        ],
                      ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RoundBtn(
                    icon: CupertinoIcons.xmark,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(t['live']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _SideSettings(
                    open: _settingsOpen,
                    camOn: _camOn,
                    micOn: _micOn,
                    onTogglePanel: () => setState(() => _settingsOpen = !_settingsOpen),
                    onFlip: _flip,
                    onCam: _toggleCam,
                    onMic: _toggleMic,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullPreview extends StatelessWidget {
  final CameraController controller;
  const _FullPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final preview = controller.value.previewSize;
    final aspect = preview == null || preview.height == 0
        ? controller.value.aspectRatio
        : preview.height / preview.width;
    return ColoredBox(
      color: Colors.black,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.width * (aspect == 0 ? 16 / 9 : aspect),
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }
}

class _SideSettings extends StatelessWidget {
  final bool open;
  final bool camOn;
  final bool micOn;
  final VoidCallback onTogglePanel;
  final VoidCallback onFlip;
  final VoidCallback onCam;
  final VoidCallback onMic;

  const _SideSettings({
    required this.open,
    required this.camOn,
    required this.micOn,
    required this.onTogglePanel,
    required this.onFlip,
    required this.onCam,
    required this.onMic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundBtn(
          icon: CupertinoIcons.gear_alt_fill,
          active: open,
          onTap: onTogglePanel,
        ),
        if (open) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.38),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                _RoundBtn(icon: CupertinoIcons.switch_camera, onTap: onFlip),
                const SizedBox(height: 10),
                _RoundBtn(
                  icon: camOn ? CupertinoIcons.video_camera_solid : CupertinoIcons.video_camera,
                  active: camOn,
                  onTap: onCam,
                ),
                const SizedBox(height: 10),
                _RoundBtn(
                  icon: micOn ? CupertinoIcons.mic_fill : CupertinoIcons.mic_slash_fill,
                  active: micOn,
                  onTap: onMic,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _RoundBtn({required this.icon, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? c.primary.withValues(alpha: 0.9) : Colors.black.withValues(alpha: 0.4),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
