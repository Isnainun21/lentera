import 'package:flutter_test/flutter_test.dart';
import 'package:side/adaptive.dart';
import 'package:side/data.dart';
import 'package:side/models.dart';

void main() {
  group('PencocokanUcapan (RA-PRD-202)', () {
    final buku = BankKata.semua.firstWhere((k) => k.id == 'l2-1');

    test('ucapan utuh -> semua suku kata benar', () {
      expect(PencocokanUcapan.status(buku, 'buku'), StatusKecocokan.benar);
    });

    test('hanya suku kata pertama -> sebagian', () {
      final r = PencocokanUcapan.cocokkan(buku, 'bu');
      expect(r.cocok, [0]);
      expect(PencocokanUcapan.status(buku, 'bu'), StatusKecocokan.sebagian);
    });

    test('ucapan lain -> salah', () {
      expect(PencocokanUcapan.status(buku, 'meja'), StatusKecocokan.salah);
    });

    test('tidak sensitif huruf besar / tanda baca', () {
      expect(PencocokanUcapan.status(buku, 'BUKU!'), StatusKecocokan.benar);
    });
  });

  group('MesinAdaptif (RA-PRD-401)', () {
    test('naik level setelah 3 benar berturut-turut', () {
      final m = MesinAdaptif(naikSetelah: 3, turunSetelah: 2, levelMaks: 5);
      var level = 1;
      level = m.evaluasi(level, StatusKecocokan.benar);
      level = m.evaluasi(level, StatusKecocokan.benar);
      expect(level, 1);
      level = m.evaluasi(level, StatusKecocokan.benar);
      expect(level, 2);
    });

    test('turun level setelah 2 salah berturut-turut', () {
      final m = MesinAdaptif(naikSetelah: 3, turunSetelah: 2, levelMaks: 5);
      var level = 3;
      level = m.evaluasi(level, StatusKecocokan.salah);
      expect(level, 3);
      level = m.evaluasi(level, StatusKecocokan.salah);
      expect(level, 2);
    });

    test('benar reset streak salah', () {
      final m = MesinAdaptif();
      m.evaluasi(2, StatusKecocokan.salah);
      m.evaluasi(2, StatusKecocokan.benar);
      expect(m.streakSalah, 0);
      expect(m.evaluasi(2, StatusKecocokan.salah), 2);
    });

    test('level tidak keluar dari 1..5', () {
      final m = MesinAdaptif(naikSetelah: 1, turunSetelah: 1, levelMaks: 5);
      expect(m.evaluasi(5, StatusKecocokan.benar), 5);
      expect(m.evaluasi(1, StatusKecocokan.salah), 1);
    });
  });

  group('BankKata', () {
    test('setiap level punya kata dan suku kata terisi', () {
      for (var lv = 1; lv <= 5; lv++) {
        final k = BankKata.untukLevel(lv);
        expect(k, isNotEmpty, reason: 'level $lv kosong');
        expect(k.every((e) => e.sukuKata.isNotEmpty), isTrue);
      }
    });
  });
}