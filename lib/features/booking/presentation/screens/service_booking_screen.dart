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
import 'package:ltc/features/booking/presentation/widgets/confirm_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/patient_info_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/service_step_header_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/time_step_header_widget.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  ConsumerState<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadData();
    });
  }

  void loadData() async {
    final bk = ref.read(bookingProvider('A018').notifier);
    bk.loadServices(null);
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final bkState = ref.watch(bookingProvider('A018'));

    return AppScaffoldWidget(
      title: tr.service,
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
              header: ServiceStepHeader(
                isActive: _currentStep == 0,
                isCheck: _currentStep > 0,
                serviceName: _currentStep > 0 ? 'Khám tổng quát' : null,
                onTap: _currentStep > 0
                    ? () => setState(() => _currentStep = 0)
                    : null,
              ),
              body: AnimatedSizeWidget(
                isExpanded: _currentStep == 0,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ModalHelper.showServiceModal(
                          context: context,
                          services: bkState.services,
                          selectedServices: bkState.selectedServices,
                          onConfirm: (value) {},
                        );
                      },
                      child: Text("data"),
                    ),
                  ],
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
                dateTime: _currentStep > 1
                    ? 'Thứ Ba, 06/05/2025 · 09:00'
                    : null,
                onTap: _currentStep > 1
                    ? () => setState(() => _currentStep = 1)
                    : null,
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
    );
  }
}
