// booking_state.dart
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';

enum BookingType { service, specialty, package }

class BookingState {
  final String dcomId;
  // — API data
  final List<PackageEntity> packages;
  final List<SpecialtyEntity> specialties;
  final List<ServiceEntity> services;
  final List<DoctorEntity> doctors;
  // — User đã chọn
  final List<ServiceEntity> selectedServices;
  final List<PackageEntity> selectedPackages;
  final DoctorEntity? selectedDoctor;
  final SpecialtyEntity? selectedSpecialty;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;

  // — Async state
  final bool isLoadingSpecialty;
  final bool isLoadingServices;
  final bool isLoadingPackages;
  final bool isLoadingDoctors;
  final String? errorMessage;

  const BookingState({
    required this.dcomId,
    this.packages = const [],
    this.specialties = const [],
    this.services = const [],
    this.doctors = const [],
    //
    this.selectedServices = const [],
    this.selectedPackages = const [],
    this.selectedDoctor,
    this.selectedSpecialty,
    this.selectedDate,
    this.selectedTimeSlot,
    this.isLoadingSpecialty = false,
    this.isLoadingServices = false,
    this.isLoadingPackages = false,
    this.isLoadingDoctors = false,
    this.errorMessage,
  });

  BookingState copyWith({
    List<PackageEntity>? packages,
    List<SpecialtyEntity>? specialties,
    List<ServiceEntity>? services,
    List<DoctorEntity>? doctors,
    //
    List<ServiceEntity>? selectedServices,
    List<PackageEntity>? selectedPackages,
    SpecialtyEntity? selectedSpecialty,
    DoctorEntity? selectedDoctor,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    bool? isLoadingSpecialty,
    bool? isLoadingServices,
    bool? isLoadingPackages,
    bool? isLoadingDoctors,
    String? errorMessage,
  }) {
    return BookingState(
      dcomId: this.dcomId,
      packages: packages ?? this.packages,
      specialties: specialties ?? this.specialties,
      services: services ?? this.services,
      doctors: doctors ?? this.doctors,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedPackages: selectedPackages ?? this.selectedPackages,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      isLoadingSpecialty: isLoadingSpecialty ?? this.isLoadingSpecialty,
      isLoadingServices: isLoadingServices ?? this.isLoadingServices,
      isLoadingPackages: isLoadingPackages ?? this.isLoadingPackages,
      isLoadingDoctors: isLoadingDoctors ?? this.isLoadingDoctors,
      errorMessage: errorMessage,
    );
  }

  BookingState resetSelections() {
    return copyWith(
      selectedServices: [],
      selectedPackages: [],
      selectedSpecialty: null,
      selectedDoctor: null,
      selectedDate: null,
      selectedTimeSlot: null,
    );
  }
}
