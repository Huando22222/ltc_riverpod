import 'package:ltc/features/lookup/domain/entities/booking_data_detail_entity.dart';
import 'package:ltc/features/lookup/domain/entities/package_group_entity.dart';

class LookUpUtil {
  static List<GroupItemEntity> groupServices(
    List<BookingDataDetailEntity> services,
  ) {
    final Map<String, List<BookingDataDetailEntity>> packages = {};
    final List<BookingDataDetailEntity> standalone = [];

    for (final s in services) {
      final pkgId = s.packageId?.trim();

      if (pkgId != null && pkgId.isNotEmpty) {
        packages.putIfAbsent(pkgId, () => []).add(s);
      } else {
        standalone.add(s);
      }
    }

    final result = <GroupItemEntity>[
      ...packages.entries.map((e) {
        final first = e.value.first;

        return GroupItemEntity(
          id: e.key,
          name: first.packageName?.trim().isNotEmpty == true
              ? first.packageName!
              : 'Gói dịch vụ',
          isPackage: true,
          services: e.value,
        );
      }),
    ];

    final Map<String, List<BookingDataDetailEntity>> standaloneGroups = {};

    for (final s in standalone) {
      standaloneGroups.putIfAbsent(s.serGroupId, () => []).add(s);
    }

    result.addAll(
      standaloneGroups.entries.map((e) {
        final first = e.value.first;

        return GroupItemEntity(
          id: e.key,
          name: first.serGroupName,
          isPackage: false,
          services: e.value,
        );
      }),
    );

    return result;
  }

  static List<String> formatServicesBullets(
    List<BookingDataDetailEntity> services,
  ) {
    return groupServices(services).map((g) {
      final names = g.services.map((e) => e.serName).join(' · ');
      return '• ${g.name}: $names';
    }).toList();
  }

  static String formatServicesLine(List<GroupItemEntity> groups) {
    return groups
        .map((g) {
          final names = g.services.map((s) => s.serName).join(' , ');
          return '${g.name}: $names';
        })
        .join('  |  ');
  }
}
