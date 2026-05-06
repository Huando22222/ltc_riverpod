import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/scaffold/app_scaffold_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
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
  int _currentStep = 3;

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);

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
