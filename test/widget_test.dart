import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_motocase/main.dart';

final _initialDropRates = {
  for (final entry in dropRates.value.entries)
    entry.key: Map<Tier, double>.from(entry.value),
};

void main() {
  setUp(() {
    tokens.value = 0;
    history.value = [];
    adminMode.value = false;
    dropRates.value = {
      for (final entry in _initialDropRates.entries)
        entry.key: Map<Tier, double>.from(entry.value),
    };
  });

  test('brand box PNGs are available in the Flutter asset bundle', () async {
    for (final brand in brands.keys) {
      final asset = await rootBundle.load('assets/boxes/${brand}Box.png');
      expect(asset.lengthInBytes, greaterThan(0), reason: brand);
    }
  });

  testWidgets('Wave 110i uses the supplied PNG instead of the SVG silhouette', (
    WidgetTester tester,
  ) async {
    final png = await rootBundle.load('assets/bikes/honda-wave110i.png');
    expect(png.lengthInBytes, greaterThan(0));

    final wave110i = brands['Honda']!.$2.firstWhere(
      (bike) => bike.name == 'Wave110i',
    );
    final drop = Drop(wave110i);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: BikeImage(drop))));
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(find.byType(Image));
    expect(
      image.image,
      isA<AssetImage>().having(
        (asset) => asset.assetName,
        'asset name',
        'assets/bikes/honda-wave110i.png',
      ),
    );
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('supplied Honda model images load instead of SVG silhouettes', (
    WidgetTester tester,
  ) async {
    const imageNames = {
      'ADV160': 'honda-adv160.png',
      'ADV350': 'honda-adv350.png',
      'Africa Twin': 'honda-africa-twin.png',
      'CB1000 GT': 'honda-cb1000-gt.png',
      'CB1000R': 'honda-cb1000r.png',
      'CB400 Super Four': 'honda-cb400-super-four.png',
      'CBR1000RR-R': 'honda-cbr1000rr-r.png',
      'CBR250RR': 'honda-cbr250rr.png',
      'CBR150R': 'honda-cbr150r.png',
      'CBR650R': 'honda-cbr650r.png',
      'Click125i': 'honda-click125i.png',
      'CRF300L': 'honda-crf300l.png',
      'Forza350': 'honda-forza350.png',
      'Forza750': 'honda-forza750.png',
      'Goldwing': 'honda-goldwing.png',
      'MSX125 Grom': 'honda-msx125-grom.png',
      'Monkey 125': 'honda-monkey-125.png',
      'Monkey FTR Limited Edition': 'honda-monkey-ftr-limited-edition.png',
      'NM4': 'honda-nm4.png',
      'PCX160': 'honda-pcx160.png',
      'Rebel 500': 'honda-rebel-500.png',
      'Wave125i': 'honda-wave125i.png',
      'X-ADV750': 'honda-x-adv750.png',
      'RC213V-S': 'honda-rc213v-s.png',
    };

    for (final entry in imageNames.entries) {
      final path = 'assets/bikes/${entry.value}';
      expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
      final bike = brands['Honda']!.$2.firstWhere(
        (model) => model.name == entry.key,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: BikeImage(Drop(bike)))),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.image,
        isA<AssetImage>().having(
          (asset) => asset.assetName,
          'asset name',
          path,
        ),
      );
      expect(find.byType(SvgPicture), findsNothing);
    }
  });

  testWidgets('supplied Yamaha model images load instead of SVG silhouettes', (
    WidgetTester tester,
  ) async {
    const imageNames = {
      'Aerox155': 'yamaha-aerox155.png',
      'Fino 125': 'yamaha-fino-125.png',
      'Grand Filano': 'yamaha-grand-filano.png',
      'MT-03': 'yamaha-mt-03.png',
      'MT-07': 'yamaha-mt-07.png',
      'MT-09': 'yamaha-mt-09.png',
      'MT-15': 'yamaha-mt-15.png',
      'NMAX155': 'yamaha-nmax155.png',
      'PG-1': 'yamaha-pg-1.png',
      'R1': 'yamaha-r1.png',
      'R15': 'yamaha-r15.png',
      'R7': 'yamaha-r7.png',
      'TMAX 530': 'yamaha-tmax-530.png',
      'Tenere 700': 'yamaha-tenere-700.png',
      'Tracer 9 GT': 'yamaha-tracer-9-gt.png',
      'XMAX Tech MAX': 'yamaha-xmax-tech-max.png',
      'XSR155': 'yamaha-xsr155.png',
      'YZF-R1 60th Ltd': 'yamaha-yzf-r1-60th-ltd.png',
      'YZF-R3': 'yamaha-yzf-r3.png',
    };

    for (final entry in imageNames.entries) {
      final path = 'assets/bikes/${entry.value}';
      expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
      final bike = brands['Yamaha']!.$2.firstWhere(
        (model) => model.name == entry.key,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: BikeImage(Drop(bike)))),
      );
      await tester.pumpAndSettle();

      final image = tester.widget<Image>(find.byType(Image));
      expect(
        image.image,
        isA<AssetImage>().having(
          (asset) => asset.assetName,
          'asset name',
          path,
        ),
      );
      expect(find.byType(SvgPicture), findsNothing);
    }
  });

  test('Wave 110i and Wave 125i stay under 80,000 baht', () {
    final hondaBikes = brands['Honda']!.$2;
    final wave110i = hondaBikes.firstWhere((bike) => bike.name == 'Wave110i');
    final wave125i = hondaBikes.firstWhere((bike) => bike.name == 'Wave125i');

    expect(wave110i.value, 42250);
    expect(wave125i.value, 61700);
    expect(wave110i.value, lessThanOrEqualTo(80000));
    expect(wave125i.value, lessThanOrEqualTo(80000));
  });

  test('gold-tier rare bikes have premium values', () {
    final bikes = brands.values.expand((brand) => brand.$2);
    final goldBikes = bikes.where((bike) => bike.tier == Tier.gd).toList();
    final rc213v = goldBikes.singleWhere((bike) => bike.name == 'RC213V-S');

    expect(rc213v.value, 8000000);
    expect(goldBikes, isNotEmpty);
    expect(
      goldBikes.every((bike) => bike.value >= 1000000),
      isTrue,
      reason: goldBikes
          .where((bike) => bike.value < 1000000)
          .map((bike) => '${bike.brand} ${bike.name}: ${bike.value}')
          .join(', '),
    );
  });

  test('Honda ADV and Forza models have the requested prices', () {
    final bikes = {for (final bike in brands['Honda']!.$2) bike.name: bike};

    expect(bikes['ADV350']!.value, 180000);
    expect(bikes['Forza350']!.value, 170000);
    expect(bikes['X-ADV750']!.value, 426000);
    expect(bikes['Forza750']!.value, 426000);
  });

  test('Honda Monkey FTR Limited Edition has the requested price', () {
    final bike = brands['Honda']!.$2.singleWhere(
      (bike) => bike.name == 'Monkey FTR Limited Edition',
    );

    expect(bike.cc, 125);
    expect(bike.value, 121900);
  });

  test('Honda model prices match the current model list', () {
    final hondaBikes = brands['Honda']!.$2;
    final click125i = hondaBikes.singleWhere(
      (bike) => bike.name == 'Click125i',
    );
    final cbr250rr = hondaBikes.singleWhere(
      (bike) => bike.name == 'CBR250RR',
    );

    expect(click125i.value, 55600);
    expect(cbr250rr.value, 259000);
    expect(hondaBikes.any((bike) => bike.name == 'CB650R'), isFalse);
  });

  test('Honda CB1000 GT replaces NSR250R SP', () {
    final hondaBikes = brands['Honda']!.$2;
    final cb1000Gt = hondaBikes.singleWhere(
      (bike) => bike.name == 'CB1000 GT',
    );

    expect(cb1000Gt.cc, 1000);
    expect(cb1000Gt.value, 514000);
    expect(cb1000Gt.tier, Tier.rd);
    expect(hondaBikes.any((bike) => bike.name == 'NSR250R SP'), isFalse);
  });

  test('Honda NM4 replaces CBR600RR at the requested price', () {
    final hondaBikes = brands['Honda']!.$2;
    final nm4 = hondaBikes.singleWhere((bike) => bike.name == 'NM4');

    expect(nm4.cc, 745);
    expect(nm4.value, 529000);
    expect(hondaBikes.any((bike) => bike.name == 'CBR600RR'), isFalse);
  });

  test('Yamaha PG-1 and MT-15 replace R25 and MT-25 at requested prices', () {
    final yamahaBikes = brands['Yamaha']!.$2;
    final pg1 = yamahaBikes.singleWhere((bike) => bike.name == 'PG-1');
    final mt15 = yamahaBikes.singleWhere((bike) => bike.name == 'MT-15');

    expect(pg1.cc, 114);
    expect(pg1.value, 57500);
    expect(mt15.cc, 155);
    expect(mt15.value, 101000);
    expect(yamahaBikes.any((bike) => bike.name == 'R25'), isFalse);
    expect(yamahaBikes.any((bike) => bike.name == 'MT-25'), isFalse);
  });

  test('Yamaha XMAX Tech MAX replaces XMAX300 at the existing price', () {
    final yamahaBikes = brands['Yamaha']!.$2;
    final xmaxTechMax = yamahaBikes.singleWhere(
      (bike) => bike.name == 'XMAX Tech MAX',
    );

    expect(xmaxTechMax.cc, 292);
    expect(xmaxTechMax.value, 205000);
    expect(yamahaBikes.any((bike) => bike.name == 'XMAX300'), isFalse);
  });

  test('Yamaha MT-09 replaces MT-10 at the requested price', () {
    final yamahaBikes = brands['Yamaha']!.$2;
    final mt09 = yamahaBikes.singleWhere((bike) => bike.name == 'MT-09');

    expect(mt09.cc, 890);
    expect(mt09.value, 399000);
    expect(yamahaBikes.any((bike) => bike.name == 'MT-10'), isFalse);
  });

  test('Honda Goldwing is gold tier', () {
    final goldwing = brands['Honda']!.$2.singleWhere(
      (bike) => bike.name == 'Goldwing',
    );

    expect(goldwing.tier, Tier.gd);
  });

  testWidgets('home shows unique collection progress for each tier', (
    WidgetTester tester,
  ) async {
    final hondaBikes = brands['Honda']!.$2;
    final wave110i = hondaBikes.singleWhere((bike) => bike.name == 'Wave110i');
    final wave125i = hondaBikes.singleWhere((bike) => bike.name == 'Wave125i');
    history.value = [Drop(wave110i), Drop(wave110i), Drop(wave125i)];

    await tester.pumpWidget(const MotoCaseApp());

    final (collected, total) = collectionProgress()[Tier.gray]!;
    expect(collected, 2);
    expect(total, greaterThanOrEqualTo(collected));
    expect(find.text('ความคืบหน้าการสะสม'), findsOneWidget);
    expect(find.text('สะสม $collected/$total'), findsOneWidget);
    expect(collectionProgress().keys, containsAll(Tier.values));
  });

  testWidgets('admin can add tokens after entering the correct password', (
    WidgetTester tester,
  ) async {
    tokens.value = 0;
    await tester.pumpWidget(const MotoCaseApp());

    await tester.tap(find.byTooltip('Admin'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('admin-password')),
      '1111',
    );
    await tester.tap(find.text('เข้าสู่ระบบ'));
    await tester.pumpAndSettle();
    expect(find.text('รหัสผ่านไม่ถูกต้อง'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-token-amount')), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('admin-password')),
      '1234',
    );
    await tester.tap(find.text('เข้าสู่ระบบ'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('admin-token-amount')), findsOneWidget);
    expect(adminMode.value, isTrue);

    await tester.enterText(
      find.byKey(const ValueKey('admin-token-amount')),
      '25',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'เพิ่ม Token'));
    await tester.pumpAndSettle();

    expect(tokens.value, 25);
    expect(find.text('Token: 25'), findsOneWidget);
    expect(find.text('เพิ่ม 25 Token เรียบร้อยแล้ว'), findsOneWidget);

    await tester.tap(find.text('Honda'));
    await tester.pumpAndSettle();
    expect(find.text('กล่อง Honda · Admin'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-drop-rate-panel')), findsOneWidget);

    final graySlider = tester.widget<Slider>(
      find.byKey(const ValueKey('drop-rate-gray')),
    );
    graySlider.onChanged!(50);
    await tester.pump();

    expect(dropRates.value['Honda']![Tier.gray], 50);
    expect(
      dropRates.value['Honda']!.values.fold(0.0, (sum, rate) => sum + rate),
      closeTo(100, 0.0001),
    );

    graySlider.onChanged!(100);
    await tester.pump();
    expect(
      List.generate(
        20,
        (_) => roll('Honda'),
      ).every((drop) => drop.bike.tier == Tier.gray),
      isTrue,
    );
  });

  testWidgets('win a token and use it to open a standard case', (
    WidgetTester tester,
  ) async {
    tokens.value = 0;
    await tester.pumpWidget(const MotoCaseApp());

    expect(find.text('MOTOCASE'), findsOneWidget);
    expect(find.text('Token: 0'), findsOneWidget);
    expect(find.text('Honda'), findsOneWidget);
    expect(find.text('📦'), findsNothing);
    for (final brand in brands.keys) {
      expect(find.byKey(ValueKey('brand-box-$brand')), findsOneWidget);
    }

    await tester.tap(find.text('Honda'));
    await tester.pumpAndSettle();

    expect(find.text('กล่อง Honda'), findsOneWidget);
    expect(find.text('เปิดกล่อง (1 Token)'), findsOneWidget);
    expect(find.text('มูลค่ารวมของกล่องนี้: ฿0'), findsOneWidget);
    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
    expect(find.textContaining('cc'), findsNothing);
    expect(find.textContaining('฿'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-drop-rate-panel')), findsNothing);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (1 Token)'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.textContaining('เล่น X/O เพื่อรับ Token'));
    await tester.pumpAndSettle();
    expect(find.text('ชนะ X/O รับ 1 Token'), findsOneWidget);

    for (final index in [0, 2, 4, 8]) {
      await tester.tap(find.byKey(ValueKey('tic-cell-$index')));
      await tester.pump();
    }

    expect(find.text('ชนะ! ได้รับ 1 Token'), findsOneWidget);
    expect(find.text('Token: 1'), findsOneWidget);

    await tester.tap(find.text('เล่นอีกครั้ง'));
    await tester.pump();
    expect(find.text('CPU เริ่มก่อน (O) · คุณเล่น X'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('tic-cell-4')))
          .child,
      isA<Text>().having((text) => text.data, 'cell mark', 'O'),
    );

    while (find.text('CPU เริ่มก่อน (O) · คุณเล่น X').evaluate().isNotEmpty) {
      final emptyCell = List.generate(9, (index) => index).firstWhere(
        (index) =>
            (tester
                        .widget<FilledButton>(
                          find.byKey(ValueKey('tic-cell-$index')),
                        )
                        .child
                    as Text)
                .data!
                .isEmpty,
      );
      await tester.tap(find.byKey(ValueKey('tic-cell-$emptyCell')));
      await tester.pump();
    }

    await tester.tap(find.text('เล่นอีกครั้ง'));
    await tester.pump();
    expect(find.text('คุณเริ่มก่อน (X) · CPU เล่น O'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('tic-cell-4')))
          .child,
      isA<Text>().having((text) => text.data, 'cell mark', ''),
    );

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Token คงเหลือ: 1'), findsOneWidget);

    await tester.tap(find.text('เปิดกล่อง (1 Token)'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
    expect(find.text('มูลค่ารวมของกล่องนี้: ฿0'), findsNothing);
    expect(find.textContaining('มูลค่ารวมของกล่องนี้: ฿'), findsOneWidget);
    expect(find.textContaining('มูลค่า ฿'), findsWidgets);
    expect(find.textContaining('Gen '), findsNothing);
    expect(find.textContaining('Pattern:'), findsNothing);
  });

  testWidgets('Ducati cases cost 20 tokens to open', (
    WidgetTester tester,
  ) async {
    tokens.value = 19;
    await tester.pumpWidget(const MotoCaseApp());
    await tester.ensureVisible(find.text('Ducati'));
    await tester.tap(find.text('Ducati'));
    await tester.pumpAndSettle();

    expect(find.text('เปิดกล่อง (20 Token)'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (20 Token)'),
          )
          .onPressed,
      isNull,
    );

    tokens.value = 20;
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (20 Token)'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('เปิดกล่อง (20 Token)'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
  });

  testWidgets('BMW cases cost 15 tokens to open', (WidgetTester tester) async {
    tokens.value = 14;
    await tester.pumpWidget(const MotoCaseApp());
    await tester.tap(find.text('BMW'));
    await tester.pumpAndSettle();

    expect(find.text('เปิดกล่อง (15 Token)'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (15 Token)'),
          )
          .onPressed,
      isNull,
    );

    tokens.value = 15;
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (15 Token)'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('เปิดกล่อง (15 Token)'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
  });
}
