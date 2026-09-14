import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaizen/locale_provider.dart';
import 'package:zaizen/ui/app_theme.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key});

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _boot();
    });
  }

  Future<void> _boot() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _cameras = await availableCameras().timeout(const Duration(seconds: 4));
      if (_cameras.isEmpty) {
        if (mounted) setState(() { _loading = false; _error = 'empty'; });
        return;
      }
      final front = _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
      _index = front >= 0 ? front : 0;
      await _openCamera();
    } catch (_) {
      if (mounted) setState(() { _loading = false; _error = 'fail'; });
    }
  }

  Future<void> _openCamera() async {
    if (_cameras.isEmpty) return;
    final gen = ++_gen;
    final old = _controller;
    _controller = null;
    if (old != null) {
      try {
        await old.dispose();
      } catch (_) {}
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
    if (!mounted || gen != _gen) return;

    final next = CameraController(
      _cameras[_index],
      ResolutionPreset.low,
      enableAudio: false,
    );
    try {
      await next.initialize().timeout(const Duration(seconds: 5));
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
        await next.dispose();
      } catch (_) {}
      if (!mounted || gen != _gen) return;
      setState(() {
        _loading = false;
        _error = 'fail';
      });
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
    setState(() => _camOn = true);
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      try {
        await controller.resumePreview();
        if (mounted) setState(() {});
        return;
      } catch (_) {}
    }
    setState(() => _loading = true);
    await _openCamera();
  }

  void _toggleMic() {
    setState(() => _micOn = !_micOn);
  }

  @override
  void dispose() {
    _gen++;
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ZColors.of(context);
    final t = _t(context.watch<LocaleProvider>().locale.languageCode);
    final controller = _controller;
    final showPreview = controller != null && controller.value.isInitialized && _camOn;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (showPreview)
            CameraPreview(controller)
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
                          Icon(
                            _camOn ? CupertinoIcons.video_camera_solid : CupertinoIcons.video_camera,
                            color: c.textMuted,
                            size: 42,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 10),
                            Text(t['err']!, style: TextStyle(color: c.textMuted)),
                            const SizedBox(height: 12),
                            CupertinoButton(
                              onPressed: _boot,
                              child: Text(t['retry']!, style: TextStyle(color: c.primary)),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          if (_loading && !showPreview)
            const ColoredBox(
              color: Colors.black54,
              child: Center(child: CupertinoActivityIndicator(color: Colors.white)),
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
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _micOn ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
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
