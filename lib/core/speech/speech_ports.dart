import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../domain/practice/models.dart';

enum SpeechAvailability { ready, noPermission, noIndonesian, unavailable }

abstract interface class SpeechRecognizer {
  String get engineName;
  Future<SpeechAvailability> prepare();

  /// Selesai dengan hasil akhir. Transkrip kosong berarti tidak ada ucapan yang tertangkap.
  Future<SpeechHearing> listen();
  Future<void> stop();
}

abstract interface class Speaker {
  /// [onWord] menerima posisi kata yang sedang diucapkan dalam [text], bila mesin suara melaporkannya.
  Future<void> speak(String text, {double rate, void Function(int start, int end)? onWord});
  Future<void> stop();
}

const indonesianLocale = 'id_ID';

class DeviceSpeechRecognizer implements SpeechRecognizer {
  final _stt = stt.SpeechToText();
  bool _ready = false;
  Completer<SpeechHearing>? _pending;
  String _latest = '';
  double? _confidence;

  @override
  String get engineName => 'speech_to_text';

  @override
  Future<SpeechAvailability> prepare() async {
    try {
      _ready = await _stt.initialize(onStatus: _onStatus, onError: (_) => _complete());
    } catch (_) {
      return SpeechAvailability.unavailable;
    }
    if (!_ready) {
      return await _stt.hasPermission ? SpeechAvailability.unavailable : SpeechAvailability.noPermission;
    }
    final locales = await _stt.locales();
    final hasIndonesian = locales.any((l) => l.localeId.toLowerCase().replaceAll('-', '_') == 'id_id');
    // Sebagian perangkat Android tidak melaporkan daftar bahasa sama sekali.
    return locales.isEmpty || hasIndonesian ? SpeechAvailability.ready : SpeechAvailability.noIndonesian;
  }

  void _onStatus(String status) {
    if (status == stt.SpeechToText.doneStatus) _complete();
  }

  void _complete() {
    final pending = _pending;
    if (pending == null || pending.isCompleted) return;
    _pending = null;
    pending.complete(SpeechHearing(_latest, confidence: _confidence));
  }

  @override
  Future<SpeechHearing> listen() async {
    _latest = '';
    _confidence = null;
    final pending = Completer<SpeechHearing>();
    _pending = pending;
    await _stt.listen(
      onResult: (r) {
        _latest = r.recognizedWords;
        if (r.hasConfidenceRating) _confidence = r.confidence;
        if (r.finalResult) _complete();
      },
      listenOptions: stt.SpeechListenOptions(
        localeId: indonesianLocale,
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 2),
        cancelOnError: true,
        partialResults: true,
      ),
    );
    return pending.future;
  }

  @override
  Future<void> stop() => _stt.stop();
}

class DeviceSpeaker implements Speaker {
  DeviceSpeaker() {
    _tts.setLanguage('id-ID').catchError((_) => null);
    _tts.awaitSpeakCompletion(true).catchError((_) => null);
    _tts.setProgressHandler((_, start, end, _) => _onWord?.call(start, end));
  }

  final _tts = FlutterTts();
  void Function(int start, int end)? _onWord;

  @override
  Future<void> speak(String text, {double rate = 0.4, void Function(int start, int end)? onWord}) async {
    try {
      _onWord = onWord;
      await _tts.setSpeechRate(rate);
      await _tts.speak(text);
    } catch (_) {
      // Suara hanya bantuan. Latihan tetap berjalan bila mesin suara tidak ada.
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
