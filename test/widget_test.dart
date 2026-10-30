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

  testWidgets(
    'supplied Kawasaki model images load instead of SVG silhouettes',
    (WidgetTester tester) async {
      const imageNames = {
        'KLX140': 'kawasaki-klx140.png',
        'KLX230': 'kawasaki-klx230.png',
        'Ninja 125': 'kawasaki-ninja-125.png',
        'Ninja 250': 'kawasaki-ninja-250.png',
        'Ninja 400': 'kawasaki-ninja-400.png',
        'Ninja 650': 'kawasaki-ninja-650.png',
        'Ninja H2': 'kawasaki-ninja-h2.png',
        'Ninja H2R': 'kawasaki-ninja-h2r.png',
        'Ninja ZX-6R': 'kawasaki-ninja-zx-6r.png',
        'Ninja ZX-10R': 'kawasaki-ninja-zx-10r.png',
        'Versys 900': 'kawasaki-versys-900.png',
        'W175': 'kawasaki-w175.png',
        'Z125 Pro': 'kawasaki-z125-pro.png',
        'Z250': 'kawasaki-z250.png',
        'Z400': 'kawasaki-z400.png',
        'Z650': 'kawasaki-z650.png',
        'Z H2': 'kawasaki-z-h2.png',
      };

      for (final entry in imageNames.entries) {
        final path = 'assets/bikes/${entry.value}';
        expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
        final bike = brands['Kawasaki']!.$2.firstWhere(
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
    },
  );

  testWidgets('supplied BMW model images load instead of SVG silhouettes', (
    WidgetTester tester,
  ) async {
    const imageNames = {
      'C 400 GT': 'bmw-c-400-gt.png',
      'C 400 X': 'bmw-c-400-x.png',
      'F 800 R': 'bmw-f-800-r.png',
      'F 850 GS': 'bmw-f-850-gs.png',
      'F 900 R': 'bmw-f-900-r.png',
      'G 310 GS': 'bmw-g-310-gs.png',
      'G 310 R': 'bmw-g-310-r.png',
      'G 310 RR': 'bmw-g-310-rr.png',
      'G 650 GS': 'bmw-g-650-gs.png',
      'HP4 Race': 'bmw-hp4-race.png',
      'K 1600 Grand America': 'bmw-k-1600-grand-america.png',
      'M 1000 RR': 'bmw-m-1000-rr.png',
      'R 1250 GS': 'bmw-r-1250-gs.png',
      'R 1300 RT': 'bmw-r-1300-rt.png',
      'R 18': 'bmw-r-18.png',
      'R nineT': 'bmw-r-ninet.png',
      'S 1000 RR': 'bmw-s-1000-rr.png',
    };

    for (final entry in imageNames.entries) {
      final path = 'assets/bikes/${entry.value}';
      expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
      final bike = brands['BMW']!.$2.firstWhere(
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

  testWidgets('supplied Suzuki model images load instead of SVG silhouettes', (
    WidgetTester tester,
  ) async {
    const imageNames = {
      'Address 125': 'suzuki-address-125.png',
      'Burgman Street': 'suzuki-burgman-street.png',
      'Gixxer 155': 'suzuki-gixxer-155.png',
      'GSX-8S': 'suzuki-gsx-8s.png',
      'GSX-R1000R': 'suzuki-gsx-r1000r.png',
      'GSX-R150': 'suzuki-gsx-r150.png',
      'GSX-R400 JDM': 'suzuki-gsx-r400-jdm.png',
      'GSX-R600': 'suzuki-gsx-r600.png',
      'GSX-S150': 'suzuki-gsx-s150.png',
      'GSX250R': 'suzuki-gsx250r.png',
      'Hayabusa': 'suzuki-hayabusa.png',
      'Hayabusa Gen 1': 'suzuki-hayabusa-gen-1.png',
      'Katana': 'suzuki-katana.png',
      'Raider R150': 'suzuki-raider-r150.png',
      'RG500 Gamma': 'suzuki-rg500-gamma.png',
      'SV650': 'suzuki-sv650.png',
      'V-Strom 250': 'suzuki-v-strom-250.png',
      'V-Strom 650': 'suzuki-v-strom-650.png',
    };

    for (final entry in imageNames.entries) {
      final path = 'assets/bikes/${entry.value}';
      expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
      final bike = brands['Suzuki']!.$2.firstWhere(
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

  testWidgets('supplied Ducati model images load instead of SVG silhouettes', (
    WidgetTester tester,
  ) async {
    const imageNames = {
      'DesertX': 'ducati-desertx.png',
      'Diavel V4': 'ducati-diavel-v4.png',
      'Hypermotard 698': 'ducati-hypermotard-698.png',
      'Monster 797': 'ducati-monster-797.png',
      'Monster 821': 'ducati-monster-821.png',
      'Monster 937': 'ducati-monster-937.png',
      'Multistrada V4': 'ducati-multistrada-v4.png',
      'Panigale V2': 'ducati-panigale-v2.png',
      'Panigale V4': 'ducati-panigale-v4.png',
      'Panigale V4 Lamborghini': 'ducati-panigale-v4-lamborghini.png',
      'Scrambler Icon': 'ducati-scrambler-icon.png',
      'Scrambler Sixty2': 'ducati-scrambler-sixty2.png',
      'Streetfighter V4': 'ducati-streetfighter-v4.png',
      'Superleggera V4': 'ducati-superleggera-v4.png',
    };

    for (final entry in imageNames.entries) {
      final path = 'assets/bikes/${entry.value}';
      expect((await rootBundle.load(path)).lengthInBytes, greaterThan(0));
      final bike = brands['Ducati']!.$2.firstWhere(
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
    final bmwM1000Rr = goldBikes.singleWhere(
      (bike) => bike.name == 'M 1000 RR',
    );
    final premiumGoldBikes = goldBikes.where((bike) => bike != bmwM1000Rr);

    expect(rc213v.value, 8000000);
    expect(bmwM1000Rr.value, 999 * 520 + 45000);
    expect(goldBikes, isNotEmpty);
    expect(
      premiumGoldBikes.every((bike) => bike.value >= 1000000),
      isTrue,
      reason: premiumGoldBikes
          .where((bike) => bike.value < 1000000)
          .map((bike) => '${bike.brand} ${bike.name}: ${bike.value}')
          .join(', '),
    );
  });

  test('BMW M 1000 RR is gold tier without changing its formula price', () {
    final bike = brands['BMW']!.$2.singleWhere(
      (bike) => bike.name == 'M 1000 RR',
    );

    expect(bike.tier, Tier.gd);
    expect(bike.value, 999 * 520 + 45000);
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
    final cbr250rr = hondaBikes.singleWhere((bike) => bike.name == 'CBR250RR');

    expect(click125i.value, 55600);
    expect(cbr250rr.value, 259000);
    expect(hondaBikes.any((bike) => bike.name == 'CB650R'), isFalse);
  });

  test('Honda CB1000 GT replaces NSR250R SP', () {
    final hondaBikes = brands['Honda']!.$2;
    final cb1000Gt = hondaBikes.singleWhere((bike) => bike.name == 'CB1000 GT');

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

  test('Kawasaki Versys 900 replaces Z900RS at the requested price', () {
    final kawasakiBikes = brands['Kawasaki']!.$2;
    final versys900 = kawasakiBikes.singleWhere(
      (bike) => bike.name == 'Versys 900',
    );

    expect(versys900.cc, 900);
    expect(versys900.value, 484900);
    expect(kawasakiBikes.any((bike) => bike.name == 'Z900RS'), isFalse);
  });

  test('Honda Goldwing is gold tier', () {
    final goldwing = brands['Honda']!.$2.singleWhere(
      (bike) => bike.name == 'Goldwing',
    );

    expect(goldwing.tier, Tier.gd);
  });

  test(
    'BMW R 1300 RT and K 1600 Grand America are gold tier at listed prices',
    () {
      final bmwBikes = {for (final bike in brands['BMW']!.$2) bike.name: bike};
      final r1300Rt = bmwBikes['R 1300 RT']!;
      final k1600GrandAmerica = bmwBikes['K 1600 Grand America']!;

      expect(r1300Rt.value, 1439000);
      expect(r1300Rt.tier, Tier.gd);
      expect(k1600GrandAmerica.value, 1775000);
      expect(k1600GrandAmerica.tier, Tier.gd);
    },
  );

  test('Suzuki Hayabusa Gen 1 replaces Katana 1100 Ltd', () {
    final suzukiBikes = brands['Suzuki']!.$2;
    final hayabusaGen1 = suzukiBikes.singleWhere(
      (bike) => bike.name == 'Hayabusa Gen 1',
    );

    expect(hayabusaGen1.cc, 1298);
    expect(hayabusaGen1.value, 1500000);
    expect(hayabusaGen1.tier, Tier.gd);
    expect(suzukiBikes.any((bike) => bike.name == 'Katana 1100 Ltd'), isFalse);
    expect(suzukiBikes.any((bike) => bike.name == 'Hayabusa'), isTrue);
  });

  test('Ducati Panigale V4 Lamborghini replaces Desmosedici Stradale', () {
    final ducatiBikes = brands['Ducati']!.$2;
    final panigaleV4Lamborghini = ducatiBikes.singleWhere(
      (bike) => bike.name == 'Panigale V4 Lamborghini',
    );

    expect(panigaleV4Lamborghini.cc, 1103);
    expect(panigaleV4Lamborghini.value, 8000000);
    expect(panigaleV4Lamborghini.tier, Tier.gd);
    expect(
      ducatiBikes.any((bike) => bike.name == 'Desmosedici Stradale'),
      isFalse,
    );
    expect(ducatiBikes.any((bike) => bike.name == 'Panigale V4'), isTrue);
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

  testWidgets('coin mini-game awards coin tokens for 30 seconds', (
    WidgetTester tester,
  ) async {
    tokens.value = 0;
    await tester.pumpWidget(const MotoCaseApp());
    await tester.tap(find.byKey(const ValueKey('coin-game-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('เก็บเหรียญรับ Token'), findsOneWidget);
    expect(find.text('00:30'), findsOneWidget);
    final coinFinder = find.byKey(const ValueKey('token-coin-0'));
    final rewardText = tester.widget<Text>(
      find.byKey(const ValueKey('token-coin-reward-0')),
    );
    final reward = int.parse(rewardText.data!.substring(1));
    final fieldFinder = find.byKey(const ValueKey('coin-game-field'));
    final fieldSize = tester.getSize(fieldFinder);
    expect(fieldSize.width, greaterThan(300));

    expect(
      find.ancestor(of: coinFinder, matching: find.byType(Tooltip)),
      findsNothing,
    );

    await tester.tap(coinFinder);
    await tester.pump();

    expect(reward, anyOf(1, 3, 5));
    expect(tokens.value, reward);
    expect(find.text('เก็บได้ $reward Token'), findsOneWidget);
    expect(coinFinder, findsNothing);
    expect(find.byKey(const ValueKey('token-coin-4')), findsOneWidget);
    expect(tester.getSize(fieldFinder), fieldSize);

    final otherCoinReward = int.parse(
      tester
          .widget<Text>(find.byKey(const ValueKey('token-coin-reward-4')))
          .data!
          .substring(1),
    );
    await tester.tap(find.byKey(const ValueKey('token-coin-4')));
    await tester.pump();
    expect(tokens.value, reward + otherCoinReward);
    expect(find.byKey(const ValueKey('token-coin-4')), findsNothing);
    expect(tester.getSize(fieldFinder), fieldSize);

    await tester.pump(const Duration(milliseconds: 999));
    expect(coinFinder, findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    expect(coinFinder, findsOneWidget);
    final respawnedPosition = tester.widget<Positioned>(
      find.ancestor(of: coinFinder, matching: find.byType(Positioned)),
    );
    expect(respawnedPosition.top, isNot(14.0 + (0 % 3) * 102));

    final nextRewardText = tester.widget<Text>(
      find.byKey(const ValueKey('token-coin-reward-0')),
    );
    final nextReward = int.parse(nextRewardText.data!.substring(1));
    await tester.tap(coinFinder);
    await tester.pump();
    final expectedTokens = reward + otherCoinReward + nextReward;
    expect(tokens.value, expectedTokens);
    expect(find.text('เก็บได้ $expectedTokens Token'), findsOneWidget);

    await tester.pump(const Duration(seconds: 30));
    expect(find.text('หมดเวลา! ได้ $expectedTokens Token'), findsOneWidget);
    expect(find.byKey(const ValueKey('coin-game-restart')), findsOneWidget);
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

  testWidgets('earn a token in the coin game and use it to open a case', (
    WidgetTester tester,
  ) async {
    tokens.value = 0;
    await tester.pumpWidget(const MotoCaseApp());

    expect(find.text('MOTOCASE'), findsOneWidget);
    expect(find.text('Token: 0'), findsOneWidget);
    expect(find.text('เล่น X/O'), findsNothing);
    expect(find.text('Honda'), findsOneWidget);
    expect(find.text('📦'), findsNothing);
    for (final brand in brands.keys) {
      expect(find.byKey(ValueKey('brand-box-$brand')), findsOneWidget);
    }

    await tester.tap(find.text('Honda'));
    await tester.pumpAndSettle();

    expect(find.text('กล่อง Honda'), findsOneWidget);
    expect(find.text('เปิดกล่อง (20 Token)'), findsOneWidget);
    expect(find.text('มูลค่ารวมของกล่องนี้: ฿0'), findsOneWidget);
    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
    expect(find.textContaining('cc'), findsNothing);
    expect(find.textContaining('฿'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-drop-rate-panel')), findsNothing);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (20 Token)'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('ไม่มี Token? เก็บเหรียญเพื่อรับ Token'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    final coinFinder = find.byKey(const ValueKey('token-coin-0'));
    final rewardText = tester.widget<Text>(
      find.byKey(const ValueKey('token-coin-reward-0')),
    );
    final reward = int.parse(rewardText.data!.substring(1));
    await tester.tap(coinFinder);
    await tester.pump();
    expect(tokens.value, reward);
    Navigator.of(
      tester.element(find.byKey(const ValueKey('coin-game-timer'))),
    ).pop();
    await tester.pumpAndSettle();
    expect(find.text('Token คงเหลือ: $reward'), findsOneWidget);

    tokens.value += 20;
    await tester.pump();
    await tester.tap(find.text('เปิดกล่อง (20 Token)'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('Token คงเหลือ: $reward'), findsOneWidget);
    expect(find.text('มูลค่ารวมของกล่องนี้: ฿0'), findsNothing);
    expect(find.textContaining('มูลค่ารวมของกล่องนี้: ฿'), findsOneWidget);
    expect(find.textContaining('มูลค่า ฿'), findsWidgets);
    expect(find.textContaining('Gen '), findsNothing);
    expect(find.textContaining('Pattern:'), findsNothing);
  });

  testWidgets('Ducati cases cost 100 tokens to open', (
    WidgetTester tester,
  ) async {
    tokens.value = 99;
    await tester.pumpWidget(const MotoCaseApp());
    await tester.ensureVisible(find.text('Ducati'));
    await tester.tap(find.text('Ducati'));
    await tester.pumpAndSettle();

    expect(find.text('เปิดกล่อง (100 Token)'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (100 Token)'),
          )
          .onPressed,
      isNull,
    );

    tokens.value = 100;
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (100 Token)'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('เปิดกล่อง (100 Token)'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
  });

  testWidgets('BMW cases cost 80 tokens to open', (WidgetTester tester) async {
    tokens.value = 79;
    await tester.pumpWidget(const MotoCaseApp());
    await tester.tap(find.text('BMW'));
    await tester.pumpAndSettle();

    expect(find.text('เปิดกล่อง (80 Token)'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (80 Token)'),
          )
          .onPressed,
      isNull,
    );

    tokens.value = 80;
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'เปิดกล่อง (80 Token)'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('เปิดกล่อง (80 Token)'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('Token คงเหลือ: 0'), findsOneWidget);
  });

  testWidgets('Yamaha, Kawasaki, and Suzuki cases use their token rates', (
    WidgetTester tester,
  ) async {
    const tokenCosts = {'Yamaha': 25, 'Kawasaki': 30, 'Suzuki': 40};

    for (final entry in tokenCosts.entries) {
      tokens.value = entry.value - 1;
      await tester.pumpWidget(const MotoCaseApp());
      await tester.ensureVisible(find.text(entry.key));
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();

      final buttonText = 'เปิดกล่อง (${entry.value} Token)';
      expect(find.text(buttonText), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, buttonText))
            .onPressed,
        isNull,
      );

      tokens.value = entry.value;
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, buttonText))
            .onPressed,
        isNotNull,
      );

      Navigator.of(tester.element(find.text('กล่อง ${entry.key}'))).pop();
      await tester.pumpAndSettle();
    }
  });
}
