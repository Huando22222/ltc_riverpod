// booking_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';
import 'package:ltc/features/booking/presentation/providers/booking_state.dart';
import 'package:ltc/features/doctor/domain/usecases/search_doctor_usecase.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/service/domain/usecases/get_package_detail_usecase.dart';
import 'package:ltc/features/service/domain/usecases/get_package_usecase.dart';
import 'package:ltc/features/service/domain/usecases/search_service_usecase.dart';
import 'package:ltc/features/specialty/domain/usecases/get_clinic_specialty_usecase.dart';

class BookingNotifier extends Notifier<BookingState> {
  BookingNotifier(this.dcomId);
  final String dcomId;

  @override
  BookingState build() {
    return BookingState(dcomId: dcomId);
  }

  // ── Helpers ──────────────────────────────────────────
  SearchServiceUsecase get _searchService =>
      ref.read(searchServiceUsecaseProvider);
  GetPackagesUsecase get _getPackages => ref.read(getPackagesUsecaseProvider);
  GetPackageDetailUsecase get _getPackageDetail =>
      ref.read(getPackageDetailUsecaseProvider);
  GetClinicSpecialtyUsecase get _getSpecialty =>
      ref.read(getClinicSpecialtyUsecaseProvider);
  SearchDoctorUsecase get _searchDoctor =>
      ref.read(searchDoctorUsecaseProvider);

  void addServices(List<ServiceEntity> services) {
    state = state.copyWith(
      selectedServices: [...state.selectedServices, ...services],
    );
  }

  void removeServices(List<ServiceEntity> services) {
    final serviceIdsToRemove = services.map((e) => e.serId).toSet();

    state = state.copyWith(
      selectedServices: state.selectedServices
          .where((e) => !serviceIdsToRemove.contains(e.serId))
          .toList(),
    );
  }

  void selectPatient(PatientBookingEntity patient) =>
      state = state.copyWith(selectedPatient: patient);
  //? MARK: LOAD
  Future<void> loadClinic() async {}

  Future<void> loadServices(String? search) async {
    state = state.copyWith(isLoadingServices: true);
    final result = await _searchService.call(search);

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (services) => state = state.copyWith(services: services),
    );
    state = state.copyWith(isLoadingServices: false);
  }

  Future<void> loadPackages() async {
    state = state.copyWith(isLoadingPackages: true);
    final result = await _getPackages.call();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (packages) => state = state.copyWith(packages: packages),
    );
    state = state.copyWith(isLoadingPackages: false);
  }

  Future<void> loadSpecialty() async {
    state = state.copyWith(isLoadingSpecialty: true);
    final result = await _getSpecialty.call(state.dcomId);
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (specialty) => state = state.copyWith(specialties: specialty),
    );
    state = state.copyWith(isLoadingSpecialty: false);
  }

  Future<void> loadDoctor() async {
    state = state.copyWith(isLoadingDoctors: true);
    final result = await _searchDoctor.call(
      dcomId: state.dcomId,
      specId: state.selectedSpecialty!.id,
    );
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (doctor) => state = state.copyWith(doctors: doctor),
    );
    state = state.copyWith(isLoadingDoctors: false);
  }

  void selectDate(DateTime date) => state = state.copyWith(selectedDate: date);
  void selectTimeSlot(TimeOfDay slot) =>
      state = state.copyWith(selectedTimeSlot: slot);
}

final bookingProvider = NotifierProvider.autoDispose
    .family<BookingNotifier, BookingState, String>(BookingNotifier.new);
