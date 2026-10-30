import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/design/components.dart';
import '../../core/design/tokens.dart';
import '../../core/speech/speech_ports.dart';
import '../../domain/practice/models.dart';
import '../../domain/practice/speech_matcher.dart';

/// Alat Fase 1: merekam hasil pengenalan per kata sebagai CSV, tanpa menyimpan suara.
class SpeechTestScreen extends ConsumerStatefulWidget {
  const SpeechTestScreen({super.key});

  @override
  ConsumerState<SpeechTestScreen> createState() => _SpeechTestScreenState();
}

class _SpeechTestScreenState extends ConsumerState<SpeechTestScreen> {
  int _index = 0;
  bool _listening = false;
  SpeechAvailability? _availability;
  final _rows = <String>['word,transcript,confidence,status,latency_ms'];
  String? _last;

  @override
  void initState() {
    super.initState();
    ref.read(recognizerProvider).prepare().then((a) {
      if (mounted) setState(() => _availability = a);
    });
  }

  Future<void> _test(Word word) async {
    setState(() => _listening = true);
    final watch = Stopwatch()..start();
    final hearing = await ref.read(recognizerProvider).listen().timeout(const Duration(seconds: 12), onTimeout: () => const SpeechHearing(''));
    watch.stop();
    final status = const SpeechMatcher().match(word, hearing).status.name;
    final safe = hearing.transcript.replaceAll('"', "'");
    _rows.add('${word.text},"$safe",${hearing.confidence ?? ''},$status,${watch.elapsedMilliseconds}');
    if (!mounted) return;
    setState(() {
      _listening = false;
      _last = '"$safe": $status (${watch.elapsedMilliseconds} ms)';
    });
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(contentProvider).words;
    final word = words[_index];
    return Scaffold(
      appBar: AppBar(title: const Text('Uji pengenalan ucapan')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Status: ${_availability?.name ?? 'memeriksa'}. Suara tidak disimpan.', style: AppText.bodyGuardian),
              const SizedBox(height: 12),
              CardBox(
                child: Column(
                  children: [
                    Text('${_index + 1} dari ${words.length}', style: AppText.caption),
                    const SizedBox(height: 8),
                    FittedBox(fit: BoxFit.scaleDown, child: Text(word.text, style: AppText.wordHero)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_last != null) Text(_last!, style: AppText.bodyStrong),
              const Spacer(),
              PrimaryAction(
                label: _listening ? 'Mendengarkan' : 'Uji kata ini',
                icon: Icons.mic_rounded,
                onPressed: _listening || _availability != SpeechAvailability.ready ? null : () => _test(word),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: QuietAction(label: 'Sebelumnya', onPressed: _index > 0 ? () => setState(() => _index--) : null)),
                  const SizedBox(width: 8),
                  Expanded(child: QuietAction(label: 'Berikutnya', onPressed: _index + 1 < words.length ? () => setState(() => _index++) : null)),
                ],
              ),
              const SizedBox(height: 8),
              QuietAction(
                label: 'Salin hasil (${_rows.length - 1} baris)',
                icon: Icons.copy_rounded,
                onPressed: _rows.length <= 1
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: _rows.join('\n')));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hasil tersalin.')));
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
