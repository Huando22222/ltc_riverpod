import 'package:ltc/features/booking/data/models/booking_param_mode.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

class BookingUtil {
  static double calculateServicePrice(List<ServiceEntity> services) {
    return services.fold<double>(0, (sum, e) => sum + (e.serPrice));
  }

  static double calculatePackagePrice(List<PackageEntity> packages) {
    return packages.fold(
      0.0,
      (sum, pkg) =>
          sum +
          pkg.services.fold(0.0, (sub, service) => sub + (service.serPrice)),
    );
  }

  static List<BookingServiceParamModel> toBookingModel({
    required List<ServiceEntity> services,
    required List<PackageEntity> packages,
    String? id,
    String? docId,
    String? aptId,
    String? specId,
  }) {
    final fromServiceList = services
        .map(
          (e) => BookingServiceParamModel(
            serId: e.serId,
            serCurrentTotal: e.serTotal,
            aptId: aptId,
            docId: docId,
            id: id,
            pkgId: null,
            specId: specId,
          ),
        )
        .toList();

    final fromPackageList = packages
        .expand(
          (pkg) => pkg.services.map(
            (service) => BookingServiceParamModel(
              serId: service.serId,
              serCurrentTotal: service.serTotal,
              aptId: aptId,
              docId: docId,
              id: id,
              pkgId: pkg.packageId,
              specId: specId,
            ),
          ),
        )
        .toList();

    return [...fromServiceList, ...fromPackageList];
  }
}
