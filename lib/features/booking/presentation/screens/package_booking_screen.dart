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
import 'package:ltc/features/booking/presentation/widgets/package_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/package_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/patient_info_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/patient_info_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_header_widget.dart';

class PackageBookingScreen extends ConsumerStatefulWidget {
  const PackageBookingScreen({super.key});

  @override
  ConsumerState<PackageBookingScreen> createState() =>
      _PackageBookingScreenState();
}

class _PackageBookingScreenState extends ConsumerState<PackageBookingScreen> {
  ProviderSubscription? _sub;
  int _currentStep = 0;

  BookingNotifier get _notifier => ref.read(bookingProvider('A018').notifier);

  int _maxValidStep(BookingState s) {
    if (s.selectedPackages.isEmpty) return 0;
    if (s.selectedDate == null || s.selectedTimeSlot == null) return 1;
    if (s.selectedPatient == null) return 2;
    return 3;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.loadPackages();
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
      title: 'Đặt hẹn theo gói',
      child: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingScreen,
            vertical: AppSpacing.md,
          ),
          child: VerticalStepperWidget(
            stepper: [
              // ── Step 1: Chọn gói ──────────────────
              VerticalStepperItemWidget(
                isFirst: true,
                isActive: _currentStep == 0,
                isCheck: _currentStep > 0,
                header: PackageStepHeaderWidget(
                  isActive: _currentStep == 0,
                  isCheck: _currentStep > 0,
                  selectedPackages: bkState.selectedPackages,
                  onTap: _currentStep > 0
                      ? () => setState(() => _currentStep = 0)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 0,
                  child: PackageStepBodyWidget(
                    packages: bkState.packages,
                    selectedPackages: bkState.selectedPackages,
                    isLoading: bkState.isLoadingPackages,
                    onToggle: (pkg) => _notifier.togglePackage(pkg),
                    onConfirm: bkState.selectedPackages.isNotEmpty
                        ? () => setState(() => _currentStep = 1)
                        : () {},
                  ),
                ),
              ),

              // ── Step 2: Thời gian ─────────────────
              VerticalStepperItemWidget(
                isActive: _currentStep == 1,
                isCheck: _currentStep > 1,
                header: TimeStepHeaderWidget(
                  isActive: _currentStep == 1,
                  isCheck: _currentStep > 1,
                  selectedDate: bkState.selectedDate,
                  selectedSlot: bkState.selectedTimeSlot,
                  onTap: _currentStep > 1
                      ? () => setState(() => _currentStep = 1)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 1,
                  child: TimeStepBodyWidget(
                    selectedDate: bkState.selectedDate,
                    selectedSlot: bkState.selectedTimeSlot,
                    onDateChanged: (d) => _notifier.selectDate(d),
                    onSlotChanged: (t) => _notifier.selectTimeSlot(t),
                    onConfirm: () => setState(() => _currentStep = 2),
                  ),
                ),
              ),

              // ── Step 3: Bệnh nhân ─────────────────
              VerticalStepperItemWidget(
                isActive: _currentStep == 2,
                isCheck: _currentStep > 2,
                header: PatientInfoStepHeaderWidget(
                  isActive: _currentStep == 2,
                  isCheck: _currentStep > 2,
                  patientName: bkState.selectedPatient != null
                      ? '${bkState.selectedPatient!.fullname} · ${DateTimeUtil.formatAge(bkState.selectedPatient!.dob)}'
                      : null,
                  onTap: _currentStep > 2
                      ? () => setState(() => _currentStep = 2)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 2,
                  child: PatientInfoStepBodyWidget(
                    selected: bkState.selectedPatient,
                    onChanged: (patient) => _notifier.selectPatient(patient),
                    onConfirm: () {
                      if (bkState.selectedPatient != null) {
                        setState(() => _currentStep = 3);
                      }
                    },
                  ),
                ),
              ),

              // ── Step 4: Xác nhận ──────────────────
              VerticalStepperItemWidget(
                isLast: true,
                isActive: _currentStep == 3,
                isCheck: _currentStep > 3,
                header: ConfirmStepHeaderWidget(
                  isActive: _currentStep == 3,
                  isCheck: _currentStep > 3,
                ),
                body:
                    (bkState.selectedDate == null ||
                        bkState.selectedTimeSlot == null ||
                        bkState.selectedPatient == null ||
                        bkState.selectedPackages.isEmpty)
                    ? const SizedBox.shrink()
                    : AnimatedSizeWidget(
                        isExpanded: _currentStep == 3,
                        child: ConfirmStepBodyWidget(
                          packages: bkState.selectedPackages,
                          services: const [],
                          selectedDate: bkState.selectedDate!,
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
                                refName:
                                    auth!.fullname, //bkState.selectedPatient!.,
                                refPhone: auth
                                    .phoneNumber, //bkState.selectedPatient!.,
                                userRefId: auth.userId, // null,
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
                                    'Đặt hẹn thành công với mã hẹn: \n$result',
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
