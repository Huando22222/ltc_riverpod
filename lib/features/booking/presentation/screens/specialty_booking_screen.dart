import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/util/booking_util.dart';
import 'package:ltc/common/util/date_time_util.dart';
import 'package:ltc/common/widgets/scaffold/app_scaffold_widget.dart';
import 'package:ltc/common/widgets/size/animated_size_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/date_time_ext.dart';
import 'package:ltc/core/extensions/gender_ext.dart';
import 'package:ltc/core/helpers/in_app_notification_helper.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/booking/data/models/booking_param_mode.dart';
import 'package:ltc/features/booking/presentation/providers/booking_provider.dart';
import 'package:ltc/features/booking/presentation/providers/booking_state.dart';
import 'package:ltc/features/booking/presentation/widgets/confirm_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/confirm_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/doctor_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/doctor_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/patient_info_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/patient_info_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/specialty_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/specialty_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_header_widget.dart';

class SpecialtyBookingScreen extends ConsumerStatefulWidget {
  const SpecialtyBookingScreen({super.key});

  @override
  ConsumerState<SpecialtyBookingScreen> createState() =>
      _SpecialtyBookingScreenState();
}

class _SpecialtyBookingScreenState
    extends ConsumerState<SpecialtyBookingScreen> {
  ProviderSubscription? _sub;
  int _currentStep = 0;

  // step 0: chuyên khoa + dịch vụ
  // step 1: bác sĩ
  // step 2: ngày giờ
  // step 3: bệnh nhân
  // step 4: xác nhận

  int _maxValidStep(BookingState s) {
    if (s.selectedSpecialty == null || s.selectedServices.isEmpty) return 0;
    if (s.selectedDoctor == null) return 1;
    if (s.selectedDate == null || s.selectedTimeSlot == null) return 2;
    if (s.selectedPatient == null) return 3;
    return 4;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _sub = ref.listenManual<BookingState>(bookingProvider('A018'), (
        prev,
        next,
      ) {
        final maxStep = _maxValidStep(next);
        if (_currentStep > maxStep) {
          setState(() => _currentStep = maxStep);
        }
      });
    });
  }

  Future<void> _loadData() async {
    final bk = ref.read(bookingProvider('A018').notifier);
    await Future.wait([bk.loadSpecialty(), bk.loadServices(null)]);
  }

  /// Load doctors khi chuyên khoa thay đổi
  Future<void> _loadDoctors() async {
    await ref.read(bookingProvider('A018').notifier).loadDoctor();
  }

  @override
  void dispose() {
    _sub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final bk = ref.read(bookingProvider('A018').notifier);
    final bkState = ref.watch(bookingProvider('A018'));
    final auth = ref.read(currentUserProvider);

    return AppScaffoldWidget(
      title: tr.specialty,
      child: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingScreen,
            vertical: AppSpacing.md,
          ),
          child: VerticalStepperWidget(
            stepper: [
              // ── Step 0: Chuyên khoa + dịch vụ ────
              VerticalStepperItemWidget(
                isFirst: true,
                isActive: _currentStep == 0,
                isCheck: _currentStep > 0,
                header: SpecialtyStepHeaderWidget(
                  isActive: _currentStep == 0,
                  isCheck: _currentStep > 0,
                  selectedSpecialty: bkState.selectedSpecialty,
                  selectedServices: bkState.selectedServices,
                  onTap: _currentStep > 0
                      ? () => setState(() => _currentStep = 0)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 0,
                  child: SpecialtyStepBodyWidget(
                    dcomId: 'A018',
                    specialties: bkState.specialties,
                    allServices: bkState.services,
                    selectedServices: bkState.selectedServices,
                    selectedSpecialty: bkState.selectedSpecialty,
                    isLoadingSpecialty: bkState.isLoadingSpecialty,
                    isLoadingServices: bkState.isLoadingServices,
                    onConfirm: () async {
                      // Load doctors theo specialty vừa chọn rồi mới sang step 1
                      await _loadDoctors();
                      setState(() => _currentStep = 1);
                    },
                  ),
                ),
              ),

              // ── Step 1: Chọn bác sĩ ───────────────
              VerticalStepperItemWidget(
                isActive: _currentStep == 1,
                isCheck: _currentStep > 1,
                header: DoctorStepHeaderWidget(
                  isActive: _currentStep == 1,
                  isCheck: _currentStep > 1,
                  doctor: bkState.selectedDoctor,
                  onTap: _currentStep > 1
                      ? () => setState(() => _currentStep = 1)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 1,
                  child: DoctorStepBodyWidget(
                    doctors: bkState.doctors,
                    selectedDoctor: bkState.selectedDoctor,
                    isLoading: bkState.isLoadingDoctors,
                    onSelect: (doctor) => bk.selectDoctor(doctor),
                    onConfirm: () => setState(() => _currentStep = 2),
                  ),
                ),
              ),

              // ── Step 2: Ngày giờ ──────────────────
              VerticalStepperItemWidget(
                isActive: _currentStep == 2,
                isCheck: _currentStep > 2,
                header: TimeStepHeaderWidget(
                  isActive: _currentStep == 2,
                  isCheck: _currentStep > 2,
                  selectedDate: bkState.selectedDate,
                  selectedSlot: bkState.selectedTimeSlot,
                  onTap: _currentStep > 2
                      ? () => setState(() => _currentStep = 2)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 2,
                  child: TimeStepBodyWidget(
                    selectedDate: bkState.selectedDate,
                    selectedSlot: bkState.selectedTimeSlot,
                    onDateChanged: (d) => bk.selectDate(d),
                    onSlotChanged: (t) => bk.selectTimeSlot(t),
                    onConfirm: () => setState(() => _currentStep = 3),
                  ),
                ),
              ),

              // ── Step 3: Thông tin bệnh nhân ────────
              VerticalStepperItemWidget(
                isActive: _currentStep == 3,
                isCheck: _currentStep > 3,
                header: PatientInfoStepHeaderWidget(
                  isActive: _currentStep == 3,
                  isCheck: _currentStep > 3,
                  patientName: bkState.selectedPatient != null
                      ? '${bkState.selectedPatient!.fullname} · ${DateTimeUtil.formatAge(bkState.selectedPatient!.dob)}'
                      : null,
                  onTap: _currentStep > 3
                      ? () => setState(() => _currentStep = 3)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 3,
                  child: PatientInfoStepBodyWidget(
                    selected: bkState.selectedPatient,
                    onChanged: (patient) => bk.selectPatient(patient),
                    onConfirm: () {
                      if (bkState.selectedPatient != null) {
                        setState(() => _currentStep = 4);
                      }
                    },
                  ),
                ),
              ),

              // ── Step 4: Xác nhận ───────────────────
              VerticalStepperItemWidget(
                isLast: true,
                isActive: _currentStep == 4,
                isCheck: _currentStep > 4,
                header: ConfirmStepHeaderWidget(
                  isActive: _currentStep == 4,
                  isCheck: _currentStep > 4,
                ),
                body:
                    (bkState.selectedDate == null ||
                        bkState.selectedTimeSlot == null ||
                        bkState.selectedPatient == null)
                    ? const SizedBox.shrink()
                    : AnimatedSizeWidget(
                        isExpanded: _currentStep == 4,
                        child: ConfirmStepBodyWidget(
                          packages: [],
                          services: bkState.selectedServices,
                          selectedDate: bkState.selectedDate!,
                          selectedDoctor: bkState.selectedDoctor,
                          selectedSpecialty: bkState.selectedSpecialty,
                          selectedSlot: bkState.selectedTimeSlot!,
                          patient: bkState.selectedPatient!,
                          onSubmit: () async {
                            if (bkState.selectedPatient == null) return;
                            final result = await bk.bookingService(
                              BookingParamModel(
                                sex: bkState.selectedPatient!.gender.isMale,
                                address: bkState.selectedPatient!.address ?? '',
                                dob: bkState.selectedPatient!.dob,
                                name: bkState.selectedPatient!.fullname,
                                phone: bkState.selectedPatient!.phoneNumber,
                                refName: auth!.fullname,
                                refPhone: auth.phoneNumber,
                                userRefId: auth.userId,
                                dcomId: bkState.dcomId,
                                userId: auth.userId,
                                bookingDateTime: bkState.selectedDate!.withTime(
                                  bkState.selectedTimeSlot!,
                                ),
                                discountAmount: 0,
                                discountPercent: 0,
                                status: 0,
                                price: BookingUtil.calculateServicePrice(
                                  bkState.selectedServices,
                                ),
                                createdBy: auth.userId,
                                details: BookingUtil.toBookingModel(
                                  services: bkState.selectedServices,
                                  packages: bkState.selectedPackages,
                                ),
                                note: bkState.selectedPatient!.note,
                                request: bkState.selectedPatient!.request,
                                symptom: bkState.selectedPatient!.symptom,
                              ),
                            );
                            if (result != null) {
                              InAppNotificationHelper.showSuccess(
                                context,
                                message:
                                    'Đặt hẹn thành công với mã hẹn: $result',
                              );
                              context.pop();
                            } else {
                              InAppNotificationHelper.showError(
                                context,
                                message:
                                    'Đặt hẹn không thành công, thử lại sau',
                              );
                            }
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
