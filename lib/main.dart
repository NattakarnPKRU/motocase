import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MotoCaseApp());

// ---------- ข้อมูล ----------
enum Tier { gray, lb, db, pu, pk, rd, gd }

// ชื่อเกรด, สี, น้ำหนักการสุ่ม
const kTier = {
  Tier.gray: ('เทา', Color(0xFF9AA3AD), 40.0),
  Tier.lb: ('ฟ้าอ่อน', Color(0xFF6EC6FF), 25.0),
  Tier.db: ('ฟ้าเข้ม', Color(0xFF3B6DFF), 15.0),
  Tier.pu: ('ม่วง', Color(0xFF9B5CFF), 9.0),
  Tier.pk: ('ชมพู', Color(0xFFFF4FA3), 5.0),
  Tier.rd: ('แดง', Color(0xFFFF3B3B), 2.5),
  Tier.gd: ('ทอง', Color(0xFFFFC933), 0.6),
};

String _normalizeModelKey(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
    .trim()
    .replaceAll(RegExp(r'\s+'), ' ');

final _modelPrices = <String, int>{
  'honda wave110i': 42250,
  'honda wave125i': 61700,
  'honda click125i': 55600,
  'honda msx125 grom': 69900,
  'honda monkey 125': 106400,
  'honda monkey ftr limited edition': 121900,
  'honda cbr150r': 96900,
  'honda pcx160': 97300,
  'honda adv160': 107900,
  'honda adv350': 180000,
  'honda forza350': 170000,
  'honda x adv750': 445000,
  'honda forza750': 429000,
  'honda cbr250rr': 259000,
  'honda crf300l': 153450,
  'honda cb1000r': 501500,
  'honda cb1000 gt': 514000,
  'honda nm4': 529000,
  'honda cbr1000rr r': 1074000,
  'honda africa twin': 629000,
  'honda rc213v s': 8700000,
  'honda goldwing': 1375000,
  'honda rebel 500': 228350,
  'honda cb400 super four': 332000,
  'yamaha nmax155': 112000,
  'yamaha r15': 118000,
  'yamaha pg 1': 57500,
  'yamaha mt 15': 101000,
  'yamaha mt 09': 399000,
  'yamaha aerox155': 109000,
  'yamaha xmax tech max': 205000,
  'yamaha mt 07': 299000,
  'yamaha r1': 999000,
  'yamaha tmax 530': 470000,
  'yamaha tracer 9 gt': 620000,
  'yamaha yzf r1 60th ltd': 1800000,
  'kawasaki ninja 250': 181500,
  'kawasaki z650': 366000,
  'kawasaki ninja zx 6r': 513000,
  'kawasaki z900rs': 640000,
  'kawasaki ninja zx 10r': 957000,
  'kawasaki ninja h2': 980000,
  'kawasaki ninja h2r': 5000000,
  'kawasaki z125 pro': 85500,
  'kawasaki w175': 64000,
  'bmw g 310 r': 169000,
  'bmw g 310 gs': 175000,
  'bmw g 650 gs': 442000,
  'bmw f 800 r': 379000,
  'bmw s 1000 rr': 676000,
  'bmw r 1250 gs': 786000,
  'bmw r 18': 930000,
  'bmw hp4 race': 5000000,
  'ducati monster 821': 435000,
  'ducati monster 937': 560000,
  'ducati panigale v2': 760000,
  'ducati panigale v4': 1040000,
  'ducati desertx': 619000,
  'ducati multistrada v4': 890000,
  'ducati superleggera v4': 4000000,
  'ducati desmosedici stradale': 8000000,
  'suzuki gsx r150': 90000,
  'suzuki gsx s150': 93000,
  'suzuki v strom 250': 158000,
  'suzuki gsx250r': 176000,
  'suzuki sv650': 362000,
  'suzuki hayabusa': 820000,
  'suzuki gsx r1000r': 990000,
  'suzuki rg500 gamma': 1500000,
  'suzuki katana 1100 ltd': 1500000,
};

class Bike {
  final String brand, name;
  final int cc, value;
  final bool gold;
  Bike(this.brand, this.name, this.cc, this.gold, this.value);
  factory Bike.parse(String brand, String s) {
    final p = s.split('|');
    final cc = int.parse(p[1]);
    final gold = p.length > 2;
    final name = p[0];
    final normalized = _normalizeModelKey('$brand $name');
    final formulaValue = cc * 520 + (gold ? 45000 : 0);
    final value = _modelPrices[normalized] ?? formulaValue;
    return Bike(brand, name, cc, gold, value);
  }
  Tier get tier => gold
      ? Tier.gd
      : cc <= 150
      ? Tier.gray
      : cc <= 200
      ? Tier.lb
      : cc <= 300
      ? Tier.db
      : cc <= 400
      ? Tier.pu
      : cc <= 800
      ? Tier.pk
      : Tier.rd;
  // ชื่อไฟล์รูป: assets/bikes/honda-pcx160.png
  String get slug => '$brand $name'
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

// 'ชื่อรุ่น|cc|g(ถ้าเป็นรุ่นลิมิเต็ด/หายาก)'
const _raw = {
  'Honda': (
    0xFFE60012,
    'Wave110i|110,Wave125i|125,Click125i|125,MSX125 Grom|125,Monkey 125|125,Monkey FTR Limited Edition|125,CBR150R|150,PCX160|160,ADV160|160,ADV350|330,Forza350|330,X-ADV750|745,Forza750|745,CBR250RR|250,CRF300L|286,CB400 Super Four|399,Rebel 500|471,NM4|745,CBR650R|649,CB1000R|998,CBR1000RR-R|1000,Africa Twin|1084,Goldwing|1833|g,RC213V-S|1000|g,CB1000 GT|1000',
  ),
  'Yamaha': (
    0xFF1B3A8F,
    'Fino 125|125,Grand Filano|125,NMAX155|155,R15|155,XSR155|155,Aerox155|155,PG-1|114,MT-15|155,XMAX Tech MAX|292,YZF-R3|321,MT-03|321,Tenere 700|689,MT-07|689,R7|689,TMAX 530|530,Tracer 9 GT|890,MT-09|890,R1|998,YZF-R1 60th Ltd|998|g',
  ),
  'Kawasaki': (
    0xFF3FA535,
    'Z125 Pro|125,Ninja 125|125,KLX140|144,W175|177,KLX230|233,Ninja 250|249,Z250|249,Ninja 400|399,Z400|399,Z650|649,Ninja 650|649,Ninja ZX-6R|636,Z900RS|948,Z H2|998,Ninja ZX-10R|998,Ninja H2|998,Ninja H2R|998|g',
  ),
  'BMW': (
    0xFF2D7FF9,
    'G 310 R|313,G 310 GS|313,G 310 RR|312,C 400 X|350,C 400 GT|350,G 650 GS|652,F 800 R|798,F 850 GS|853,F 900 R|895,S 1000 RR|999,R 1250 GS|1254,R nineT|1170,R 18|1802,M 1000 RR|999,HP4 Race|999|g',
  ),
  'Ducati': (
    0xFFE10600,
    'Scrambler Sixty2|399,Monster 797|797,Hypermotard 698|698,Scrambler Icon|803,Monster 821|821,Monster 937|937,DesertX|937,Panigale V2|955,Panigale V4|1103,Streetfighter V4|1103,Multistrada V4|1158,Diavel V4|1158,Superleggera V4|1103|g,Desmosedici Stradale|1000|g',
  ),
  'Suzuki': (
    0xFF2A52D6,
    'Address 125|125,Burgman Street|125,Raider R150|147,GSX-R150|147,GSX-S150|147,Gixxer 155|155,V-Strom 250|248,GSX250R|248,GSX-R400 JDM|399,GSX-R600|599,V-Strom 650|645,SV650|645,GSX-8S|776,Katana|999,GSX-R1000R|999,Hayabusa|1340,RG500 Gamma|498|g,Katana 1100 Ltd|1100|g',
  ),
};

final brands = _raw.map(
  (k, v) => MapEntry(k, (
    Color(v.$1),
    v.$2.split(',').map((model) => Bike.parse(k, model)).toList(),
  )),
);

Map<String, Map<Tier, double>> _defaultDropRates() => {
  for (final entry in brands.entries)
    entry.key: {
      for (final tier in entry.value.$2.map((bike) => bike.tier).toSet())
        tier:
            kTier[tier]!.$3 /
            entry.value.$2
                .map((bike) => bike.tier)
                .toSet()
                .fold(
                  0.0,
                  (sum, availableTier) => sum + kTier[availableTier]!.$3,
                ) *
            100,
    },
};

final adminMode = ValueNotifier<bool>(false);
final dropRates = ValueNotifier<Map<String, Map<Tier, double>>>(
  _defaultDropRates(),
);

void updateDropRate(String brand, Tier selectedTier, double value) {
  final current = dropRates.value[brand];
  if (current == null || !current.containsKey(selectedTier)) return;

  final otherTiers = current.keys
      .where((tier) => tier != selectedTier)
      .toList();
  final otherTotal = otherTiers.fold(0.0, (sum, tier) => sum + current[tier]!);
  final remaining = 100 - value;
  final updated = <Tier, double>{selectedTier: value};
  for (final tier in otherTiers) {
    updated[tier] = otherTotal > 0
        ? current[tier]! / otherTotal * remaining
        : remaining / otherTiers.length;
  }

  dropRates.value = {...dropRates.value, brand: updated};
}

class Drop {
  final Bike bike;
  Drop(this.bike);
}

final _rnd = Random();
final history = ValueNotifier<List<Drop>>([]);
final tokens = ValueNotifier<int>(0);

Map<Tier, (int, int)> collectionProgress() {
  final bikes = brands.values.expand((brand) => brand.$2).toList();
  final collected = history.value
      .map((drop) => '${drop.bike.brand}:${drop.bike.name}')
      .toSet();
  final bikesByTier = {
    for (final tier in Tier.values)
      tier: bikes.where((bike) => bike.tier == tier).toList(),
  };

  return {
    for (final tier in Tier.values)
      tier: (
        bikesByTier[tier]!
            .where((bike) => collected.contains('${bike.brand}:${bike.name}'))
            .length,
        bikesByTier[tier]!.length,
      ),
  };
}

String formatBaht(int value) => value.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => ',',
);

// ระบบสุ่ม: ถ่วงน้ำหนักตามเกรด (เฉพาะเกรดที่ค่ายนั้นมี) แล้วสุ่มรุ่นในเกรด
Drop roll(String brand) {
  final l = brands[brand]!.$2;
  final have = l.map((b) => b.tier).toSet().toList();
  final rates = dropRates.value[brand]!;
  var x = _rnd.nextDouble() * have.fold(0.0, (s, t) => s + rates[t]!);
  var t = have.first;
  for (final k in have) {
    x -= rates[k]!;
    if (x < 0) {
      t = k;
      break;
    }
  }
  final pool = l.where((b) => b.tier == t).toList();
  final b = pool[_rnd.nextInt(pool.length)];
  return Drop(b);
}

// ---------- ภาพเงารถ (SVG) แยกตามประเภท ----------
String typeOf(String n) {
  bool m(String p) => RegExp(p).hasMatch(n);
  if (m(r'Rebel|R 18|Diavel')) return 'cr';
  if (m(
    r'Click|PCX|ADV|Fino|Filano|NMAX|Aerox|XMAX|TMAX|Address|Burgman|C 400',
  ))
    return 'sc';
  if (m(r'Wave|Raider')) return 'ub';
  if (m(r'Grom|Monkey')) return 'mi';
  if (m(
    r'CBR|YZF|Ninja|GSX-R|GSX250R|S 1000|M 1000|HP4|Panigale|Superleggera|Desmosedici|RC213|NSR|RG500|310 RR|^R\d',
  ))
    return 'sp';
  if (m(r'Africa|CRF|KLX|Tenere|Tracer|GS$|Versys|V-Strom|DesertX|Multistrada'))
    return 'ad';
  return 'nk';
}

String svgOf(Drop d) {
  final color =
      '#${brands[d.bike.brand]!.$1.toARGB32().toRadixString(16).substring(2)}';
  final k = 'fill="$color" stroke="#0006"';
  String s(String p, num w, [String col = '#999']) =>
      '<path d="$p" fill="none" stroke="$col" stroke-width="$w" stroke-linecap="round"/>';
  String e(String p) => '<path d="$p" fill="#4a4f57"/>';
  String f(String p) => '<path d="$p" $k/>';
  const h = '<circle cx="130" cy="46" r="6" fill="#ddd" stroke="#0006"/>';
  final (r, a, z, body) = switch (typeOf(d.bike.name)) {
    'sp' => (
      20,
      40,
      162,
      e('M86 56L122 58L116 70L90 70Z') +
          s('M40 70L90 62', 5, '#555') +
          f('M62 58L84 40L124 36L146 46L132 56L98 60Z') +
          f('M124 36L154 44L160 52L134 54Z') +
          f('M38 50L66 44L80 40L72 58L44 58Z') +
          s('M52 46L84 42', 6, '#222') +
          s('M150 46L162 70', 4) +
          s('M128 34L138 30', 3),
    ),
    'ad' => (
      22,
      38,
      162,
      e('M88 56L124 58L118 70L92 70Z') +
          s('M38 70L92 62', 5, '#555') +
          f('M58 52L80 36L124 34L142 44L130 56L92 60Z') +
          f('M134 40L158 38L150 46Z') +
          f('M36 44L62 40L74 36L68 56L40 52Z') +
          '<path d="M130 34L136 16L142 18L138 36Z" fill="#9cc7e8" stroke="#0006"/>' +
          s('M48 38L86 34', 6, '#222') +
          s('M142 40L162 70', 4) +
          s('M130 24L146 20', 3),
    ),
    'sc' => (
      14,
      48,
      152,
      f('M40 62Q42 36 80 36L96 40L94 62Z') +
          f('M94 62L126 62L130 70L92 70Z') +
          f('M126 62L132 30L146 30L150 56Z') +
          s('M44 34Q70 28 94 36', 8, '#222') +
          s('M132 28L148 22', 4) +
          s('M144 32L152 70', 4) +
          e('M44 60L62 62L58 70L46 70Z'),
    ),
    'ub' => (
      17,
      42,
      156,
      e('M70 56L108 58L104 70L72 70Z') +
          f('M50 60L76 42L98 44L110 62Z') +
          f('M110 62L122 32L138 32L136 52Z') +
          s('M46 40L98 38', 8, '#222') +
          s('M136 34L154 70', 4) +
          s('M132 28L146 24', 4) +
          s('M42 70L74 64', 4, '#555'),
    ),
    'mi' => (
      14,
      48,
      150,
      e('M72 58L110 56L106 68L76 68Z') +
          f('M62 44L100 40L110 52L70 58Z') +
          s('M46 42L76 40', 7, '#222') +
          s('M112 40L134 70', 4) +
          s('M110 34L124 30', 4) +
          '<circle cx="124" cy="44" r="5" fill="#ddd"/>',
    ),
    'cr' => (
      21,
      36,
      164,
      e('M82 54L120 54L116 70L84 70Z') +
          f('M72 52Q90 30 118 40L112 54Z') +
          s('M30 56Q44 40 64 50', 5, color) +
          s('M42 52Q58 46 78 52', 6, '#222') +
          s('M126 42L168 70', 4) +
          s('M120 34L132 26L142 28', 3) +
          h,
    ),
    _ => (
      19,
      40,
      160,
      e('M80 54L120 56L114 70L84 70Z') +
          s('M40 70L86 62', 5, '#555') +
          f('M66 54L84 38L110 38L118 52L100 58Z') +
          f('M38 46L66 44L64 52L40 52Z') +
          s('M42 46L86 40', 8, '#222') +
          s('M122 44L160 70', 4) +
          s('M124 38L136 32', 4) +
          h,
    ),
  };
  String wheel(int x) =>
      '<circle cx="$x" cy="70" r="$r" fill="none" stroke="#15171a" stroke-width="7"/><circle cx="$x" cy="70" r="${r - 6}" fill="none" stroke="#8a8f98" stroke-width="2"/><circle cx="$x" cy="70" r="3" fill="#8a8f98"/>';
  return '<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">${wheel(a)}${wheel(z)}$body</svg>';
}

// รูปจริงจาก assets/bikes/<slug>.png ถ้าไม่มีไฟล์ใช้ภาพเงาแทนอัตโนมัติ
class BikeImage extends StatelessWidget {
  final Drop d;
  final double h;
  const BikeImage(this.d, {super.key, this.h = 90});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: h,
    width: double.infinity,
    child: Image.asset(
      'assets/bikes/${d.bike.slug}.png',
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          SvgPicture.string(svgOf(d), fit: BoxFit.contain),
    ),
  );
}

// ---------- UI ----------
class MotoCaseApp extends StatelessWidget {
  const MotoCaseApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MOTOCASE',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(
      useMaterial3: true,
    ).copyWith(scaffoldBackgroundColor: const Color(0xFF0E1116)),
    home: const HomePage(),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _collectionProgress() => ValueListenableBuilder<List<Drop>>(
    valueListenable: history,
    builder: (context, _, _) {
      final progress = collectionProgress();
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'ความคืบหน้าการสะสม',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 66,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Tier.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tier = Tier.values[index];
                  final (collected, total) = progress[tier]!;
                  return SizedBox(
                    key: ValueKey('collection-tier-${tier.name}'),
                    width: 140,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171C24),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kTier[tier]!.$2.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kTier[tier]!.$1,
                            style: TextStyle(
                              color: kTier[tier]!.$2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'สะสม $collected/$total',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: total == 0 ? 0 : collected / total,
                            minHeight: 4,
                            backgroundColor: Colors.white12,
                            color: kTier[tier]!.$2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );

  Future<void> _openAdmin(BuildContext context) async {
    final authorized = await showDialog<bool>(
      context: context,
      builder: (_) => const AdminPasswordDialog(),
    );
    if (authorized != true || !context.mounted) return;
    adminMode.value = true;

    final amount = await showDialog<int>(
      context: context,
      builder: (_) => const AdminTokenDialog(),
    );

    if (amount == null || !context.mounted) return;
    tokens.value += amount;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เพิ่ม $amount Token เรียบร้อยแล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'MOTOCASE',
        style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          key: const ValueKey('admin-button'),
          tooltip: 'Admin',
          onPressed: () => _openAdmin(context),
          icon: const Icon(Icons.admin_panel_settings_outlined),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: LayoutBuilder(
      builder: (context, constraints) => Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: min(constraints.maxWidth, 1480),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Card(
                    color: const Color(0xFF171C24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.token,
                            color: Color(0xFFFFC933),
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ValueListenableBuilder<int>(
                              valueListenable: tokens,
                              builder: (_, count, _) => Text(
                                'Token: $count',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TicTacToePage(),
                              ),
                            ),
                            icon: const Icon(Icons.sports_esports),
                            label: const Text('เล่น X/O'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เลือกกล่องรถที่ต้องการ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'สะสม Token จากเกม X/O แล้วเปิดกล่องเพื่อลุ้นรับรถ',
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _collectionProgress(),
                LayoutBuilder(
                  builder: (context, gridConstraints) => GridView.extent(
                    maxCrossAxisExtent: 236,
                    childAspectRatio: gridConstraints.maxWidth < 600
                        ? 0.92
                        : 1.1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      for (final e in brands.entries)
                        InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CasePage(e.key)),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: const Color(0xFF171C24),
                              border: Border.all(color: e.value.$1, width: 2),
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  e.value.$1.withValues(alpha: 0.12),
                                  const Color(0xFF171C24),
                                  const Color(0xFF13171E),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      'assets/boxes/${e.key}Box.png',
                                      key: ValueKey('brand-box-${e.key}'),
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      semanticLabel: 'กล่อง ${e.key}',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    e.key,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${e.value.$2.length} รุ่น',
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class AdminPasswordDialog extends StatefulWidget {
  const AdminPasswordDialog({super.key});

  @override
  State<AdminPasswordDialog> createState() => _AdminPasswordDialogState();
}

class _AdminPasswordDialogState extends State<AdminPasswordDialog> {
  final controller = TextEditingController();
  bool hasError = false;

  void _submit() {
    if (controller.text == '1234') {
      Navigator.pop(context, true);
    } else {
      setState(() => hasError = true);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('เข้าสู่ระบบ Admin'),
    content: TextField(
      key: const ValueKey('admin-password'),
      controller: controller,
      obscureText: true,
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'รหัสผ่าน',
        errorText: hasError ? 'รหัสผ่านไม่ถูกต้อง' : null,
      ),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('ยกเลิก'),
      ),
      FilledButton(onPressed: _submit, child: const Text('เข้าสู่ระบบ')),
    ],
  );
}

class AdminTokenDialog extends StatefulWidget {
  const AdminTokenDialog({super.key});

  @override
  State<AdminTokenDialog> createState() => _AdminTokenDialogState();
}

class _AdminTokenDialogState extends State<AdminTokenDialog> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('เพิ่ม Token'),
    content: Form(
      key: formKey,
      child: TextFormField(
        key: const ValueKey('admin-token-amount'),
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'จำนวน Token',
          hintText: 'ระบุจำนวนที่ต้องการเพิ่ม',
        ),
        validator: (value) {
          final count = int.tryParse(value ?? '');
          if (count == null || count < 1) {
            return 'กรุณาระบุจำนวนอย่างน้อย 1 Token';
          }
          return null;
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('ยกเลิก'),
      ),
      FilledButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Navigator.pop(context, int.parse(controller.text));
          }
        },
        child: const Text('เพิ่ม Token'),
      ),
    ],
  );
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  static const _wins = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<String?> board = List.filled(9, null);
  String? result;
  bool cpuStartsThisRound = false;

  String? _winner(List<String?> cells) {
    for (final line in _wins) {
      final mark = cells[line[0]];
      if (mark != null && mark == cells[line[1]] && mark == cells[line[2]]) {
        return mark;
      }
    }
    return null;
  }

  int? _findWinningMove(String mark) {
    for (var i = 0; i < board.length; i++) {
      if (board[i] != null) continue;
      final trial = List<String?>.of(board)..[i] = mark;
      if (_winner(trial) == mark) return i;
    }
    return null;
  }

  void _play(int index) {
    if (result != null || board[index] != null) return;
    setState(() {
      board[index] = 'X';
      if (_winner(board) == 'X') {
        result = 'ชนะ! ได้รับ 1 Token';
        tokens.value++;
        return;
      }
      if (board.every((cell) => cell != null)) {
        result = 'เสมอ ลองใหม่อีกครั้ง';
        return;
      }

      final cpuMove =
          _findWinningMove('O') ??
          _findWinningMove('X') ??
          board.indexWhere((cell) => cell == null);
      board[cpuMove] = 'O';
      if (_winner(board) == 'O') {
        result = 'CPU ชนะ ลองใหม่อีกครั้ง';
      } else if (board.every((cell) => cell != null)) {
        result = 'เสมอ ลองใหม่อีกครั้ง';
      }
    });
  }

  void _reset() {
    setState(() {
      cpuStartsThisRound = !cpuStartsThisRound;
      board = List.filled(9, null);
      result = null;
      if (cpuStartsThisRound) board[4] = 'O';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ชนะ X/O รับ 1 Token')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: tokens,
              builder: (_, count, _) => Text(
                'Token: $count',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result ??
                  (cpuStartsThisRound
                      ? 'CPU เริ่มก่อน (O) · คุณเล่น X'
                      : 'คุณเริ่มก่อน (X) · CPU เล่น O'),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 320,
              height: 320,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: board.length,
                itemBuilder: (_, index) => FilledButton(
                  key: ValueKey('tic-cell-$index'),
                  onPressed: result == null ? () => _play(index) : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2630),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    board[index] ?? '',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: board[index] == 'X'
                          ? const Color(0xFF6EC6FF)
                          : const Color(0xFFFF4FA3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (result != null)
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('เล่นอีกครั้ง'),
              ),
          ],
        ),
      ),
    ),
  );
}

class ItemCard extends StatelessWidget {
  final Drop d;
  final bool showDetails;
  const ItemCard(this.d, {super.key, this.showDetails = false});
  @override
  Widget build(BuildContext context) {
    final c = kTier[d.bike.tier]!.$2;
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2630),
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: c, width: 4)),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.center,
          colors: [c.withOpacity(.28), const Color(0xFF1F2630)],
        ),
      ),
      child: Column(
        children: [
          BikeImage(d),
          const SizedBox(height: 4),
          Text(
            d.bike.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          if (showDetails) ...[
            Text('${d.bike.cc}cc', style: TextStyle(fontSize: 12, color: c)),
            Text(
              '฿${formatBaht(d.bike.value)}',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}

class CasePage extends StatefulWidget {
  final String brand;
  const CasePage(this.brand, {super.key});
  @override
  State<CasePage> createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  static const itemW = 160.0; // กว้างการ์ด 150 + margin 10
  int get tokenCost => switch (widget.brand) {
    'Ducati' => 20,
    'BMW' => 15,
    _ => 1,
  };
  final sc = ScrollController();
  late List<Drop> strip;
  bool busy = false;
  int last = -1;
  int totalValue = 0;

  @override
  void initState() {
    super.initState();
    strip = List.generate(20, (_) => roll(widget.brand));
    sc.addListener(() {
      final i = (sc.offset / itemW).floor();
      if (i != last) {
        last = i;
        HapticFeedback.selectionClick();
        SystemSound.play(SystemSoundType.click);
      }
    });
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

  Future<void> open(double vw) async {
    if (busy || tokens.value < tokenCost) return;
    tokens.value -= tokenCost;
    final win = roll(widget.brand);
    const n = 60, w = 52;
    setState(() {
      busy = true;
      strip = List.generate(n, (i) => i == w ? win : roll(widget.brand));
    });
    sc.jumpTo(0);
    await WidgetsBinding.instance.endOfFrame;
    final target =
        w * itemW + itemW / 2 - vw / 2 + (_rnd.nextDouble() - .5) * 110;
    await sc.animateTo(
      target,
      duration: const Duration(milliseconds: 6500),
      curve: const Cubic(.08, .55, .12, 1),
    ); // ช้าลงแบบ CS2
    if (!mounted) return;
    history.value = [win, ...history.value];
    setState(() {
      busy = false;
      totalValue += win.bike.value;
    });
    await showResult(win);
  }

  Future<void> showResult(Drop d) => showDialog(
    context: context,
    builder: (_) {
      final (tn, c, _) = kTier[d.bike.tier]!;
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: .6, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        builder: (_, v, child) => Transform.scale(scale: v, child: child),
        child: Dialog(
          backgroundColor: const Color(0xFF171C24),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: c, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text(
                    'เกรด$tn',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: c,
                ),
                const SizedBox(height: 8),
                Text(
                  '${d.bike.brand} ${d.bike.name}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${d.bike.cc}cc',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'มูลค่า ฿${formatBaht(d.bike.value)}',
                  style: TextStyle(color: c, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                BikeImage(d, h: 170),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ปิด'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final bikes = brands[widget.brand]!.$2;
    final have = bikes.map((b) => b.tier).toSet().toList()
      ..sort((a, b) => a.index - b.index);
    return ValueListenableBuilder<bool>(
      valueListenable: adminMode,
      builder: (context, isAdmin, _) =>
          ValueListenableBuilder<Map<String, Map<Tier, double>>>(
            valueListenable: dropRates,
            builder: (context, allRates, _) {
              final rates = allRates[widget.brand]!;
              final total = rates.values.fold(0.0, (sum, rate) => sum + rate);
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    isAdmin
                        ? 'กล่อง ${widget.brand} · Admin'
                        : 'กล่อง ${widget.brand}',
                  ),
                ),
                body: LayoutBuilder(
                  builder: (context, box) => ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final t in have)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: kTier[t]!.$2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${kTier[t]!.$1} ${rates[t]!.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kTier[t]!.$2,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (isAdmin) ...[
                        Card(
                          key: const ValueKey('admin-drop-rate-panel'),
                          color: const Color(0xFF171C24),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.tune,
                                      color: Color(0xFFFFC933),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'ตั้งค่าเรทดรอป',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text('${total.toStringAsFixed(1)}%'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'ปรับเปอร์เซ็นต์ของแต่ละเกรด โดยเรทรวมจะคงที่ 100%',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                for (final t in have)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          kTier[t]!.$1,
                                          style: TextStyle(color: kTier[t]!.$2),
                                        ),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          key: ValueKey('drop-rate-${t.name}'),
                                          value: rates[t]!.clamp(0, 100),
                                          min: 0,
                                          max: 100,
                                          divisions: 100,
                                          activeColor: kTier[t]!.$2,
                                          label:
                                              '${rates[t]!.toStringAsFixed(1)}%',
                                          onChanged: busy
                                              ? null
                                              : (value) => updateDropRate(
                                                  widget.brand,
                                                  t,
                                                  value,
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 52,
                                        child: Text(
                                          '${rates[t]!.toStringAsFixed(1)}%',
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 190,
                            decoration: BoxDecoration(
                              color: const Color(0xFF171C24),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ListView.builder(
                                controller: sc,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemExtent: itemW,
                                itemCount: strip.length,
                                itemBuilder: (_, i) => ItemCard(strip[i]),
                              ),
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 190,
                            color: const Color(0xFFFFC933),
                          ), // เข็มชี้
                        ],
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: tokens,
                        builder: (context, count, _) => Column(
                          children: [
                            Text('Token คงเหลือ: $count'),
                            const SizedBox(height: 8),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF2ECC71),
                                foregroundColor: const Color(0xFF06210F),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: busy || count < tokenCost
                                  ? null
                                  : () => open(box.maxWidth - 24),
                              child: Text(
                                'เปิดกล่อง ($tokenCost Token)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (count < 1 && !busy)
                              TextButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TicTacToePage(),
                                  ),
                                ),
                                icon: const Icon(Icons.sports_esports),
                                label: const Text(
                                  'ไม่มี Token? เล่น X/O เพื่อรับ Token',
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'มูลค่ารวมของกล่องนี้: ฿${formatBaht(totalValue)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFC933),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<List<Drop>>(
                        valueListenable: history,
                        builder: (_, h, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ประวัติที่สุ่มได้ (${h.length})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (final d in h)
                                    ItemCard(d, showDetails: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
