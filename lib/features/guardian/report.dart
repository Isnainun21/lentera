import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/child.dart';
import 'guardian_screens.dart';

/// Laporan hanya berisi angka dari ChildSummary, sama dengan yang tampil di layar.
Future<Uint8List> buildReport(ChildProfile child, ChildSummary s, DateTime now, {pw.Font? font}) async {
  final doc = pw.Document(title: 'Laporan Lentera');
  final theme = pw.ThemeData.withFont(base: font, bold: font);
  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    theme: theme,
    build: (_) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Laporan belajar ${child.nickname}', style: const pw.TextStyle(fontSize: 22)),
        pw.SizedBox(height: 4),
        pw.Text('Dibuat ${now.day}/${now.month}/${now.year}, level ${child.level}'),
        pw.SizedBox(height: 20),
        _row('Kata selesai minggu ini', '${s.wordsThisWeek}'),
        _row('Ketepatan minggu ini', percent(s.accuracy)),
        _row('Waktu latihan minggu ini', '${s.minutesThisWeek} menit'),
        _row('Huruf b', percent(s.letterAccuracy['b'])),
        _row('Huruf d', percent(s.letterAccuracy['d'])),
        pw.SizedBox(height: 20),
        pw.Text('7 hari terakhir', style: const pw.TextStyle(fontSize: 16)),
        pw.SizedBox(height: 6),
        for (final b in s.dayBars)
          _row('${b.day.day}/${b.day.month}', 'benar sendiri ${b.alone}, dibantu atau belum tepat ${b.helped}'),
        pw.SizedBox(height: 20),
        pw.Text('Kata yang perlu latihan', style: const pw.TextStyle(fontSize: 16)),
        pw.SizedBox(height: 6),
        pw.Text(s.difficult.isEmpty ? 'Belum ada.' : s.difficult.map((w) => w.text).join(', ')),
        pw.SizedBox(height: 24),
        pw.Text(
          'Ketepatan bergantung pada pengenalan ucapan perangkat dan bukan penilaian klinis.',
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    ),
  ));
  return doc.save();
}

pw.Widget _row(String label, String value) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(label), pw.Text(value)],
      ),
    );
