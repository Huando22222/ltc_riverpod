import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/common/widgets/scaffold/app_scaffold_widget.dart';
import 'package:ltc/common/widgets/size/animated_size_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/localization/app_strings.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/booking/presentation/providers/booking_provider.dart';
import 'package:ltc/features/booking/presentation/providers/booking_state.dart';
import 'package:ltc/features/booking/presentation/widgets/confirm_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/patient_info_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/service_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/service_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_body_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_header_widget.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  ConsumerState<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  ProviderSubscription? _sub;
  int _currentStep = 0;
  int _maxValidStep(BookingState s) {
    if (s.selectedServices.isEmpty) return 0; // phải có dịch vụ
    if (s.selectedDate == null || s.selectedTimeSlot == null)
      return 1; // phải có thời gian
    // if (s.selectedPatient == null) return 2; // phải có bệnh nhân
    return 3; // đủ hết → confirm
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadData();
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

  void loadData() async {
    final bk = ref.read(bookingProvider('A018').notifier);
    bk.loadServices(null);
  }

  @override
  void dispose() {
    _sub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final bkState = ref.watch(bookingProvider('A018'));

    return AppScaffoldWidget(
      title: tr.service,
      child: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.horizontalPaddingScreen,
            vertical: AppSpacing.md,
          ),
          child: VerticalStepperWidget(
            stepper: [
              // ── Step 1: Chọn dịch vụ ─────────────
              VerticalStepperItemWidget(
                isFirst: true,
                isActive: _currentStep == 0,
                isCheck: _currentStep > 0,
                header: ServiceStepHeaderWidget(
                  isActive: _currentStep == 0,
                  isCheck: _currentStep > 0,
                  selectedServices: bkState.selectedServices,
                  onTap: _currentStep > 0
                      ? () => setState(() => _currentStep = 0)
                      : null,
                ),
                body: AnimatedSizeWidget(
                  isExpanded: _currentStep == 0,
                  child: ServiceStepBodyWidget(
                    dcomId: 'A018',
                    selectedServices: bkState.selectedServices,
                    allServices: bkState.services,
                    isLoading: bkState.isLoadingServices,
                    onOpenModal: () => ModalHelper.showServiceModal(
                      context: context,
                      services: bkState.services,
                      selectedServices: bkState.selectedServices,
                      onAdd: (value) {
                        ref
                            .read(bookingProvider('A018').notifier)
                            .addServices(value);
                      },
                      onRemove: (value) {
                        ref
                            .read(bookingProvider('A018').notifier)
                            .removeServices(value);
                      },
                    ),
                    onConfirm: bkState.selectedServices.isNotEmpty
                        ? () => setState(() => _currentStep = 1)
                        : () {},
                  ),
                ),
              ),

              // ── Step 2: Chọn thời gian ────────────
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
                    onDateChanged: (d) => ref
                        .read(bookingProvider('A018').notifier)
                        .selectDate(d),
                    onSlotChanged: (t) => ref
                        .read(bookingProvider('A018').notifier)
                        .selectTimeSlot(t),
                    onConfirm: () => setState(() => _currentStep = 2),
                  ),
                ),
              ),

              // ── Step 3: Thông tin bệnh nhân ───────
              VerticalStepperItemWidget(
                isActive: _currentStep == 2,
                isCheck: _currentStep > 2,
                header: PatientInfoStepHeaderWidget(
                  isActive: _currentStep == 2,
                  isCheck: _currentStep > 2,
                  patientName: _currentStep > 2
                      ? 'Nguyễn Văn A · 01/01/1990'
                      : null,
                  onTap: _currentStep > 2
                      ? () => setState(() => _currentStep = 2)
                      : null,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
