// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/avatar/avatar_widget.dart';

import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';

class DoctorStepBodyWidget extends ConsumerWidget {
  final List<DoctorEntity> doctors;
  final DoctorEntity? selectedDoctor;
  final bool isLoading;
  final ValueChanged<DoctorEntity> onSelect;
  final VoidCallback onConfirm;

  const DoctorStepBodyWidget({
    super.key,
    required this.doctors,
    required this.selectedDoctor,
    required this.isLoading,
    required this.onSelect,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Danh sách bác sĩ ─────────────────
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (doctors.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Không có bác sĩ cho chuyên khoa này',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
            )
          else
            ...doctors.map(
              (doctor) => _DoctorTile(
                doctor: doctor,
                isSelected: selectedDoctor?.id == doctor.id,
                onTap: () => onSelect(doctor),
              ),
            ),

          // ── Nút tiếp theo ─────────────────────
          if (selectedDoctor != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tiếp theo'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DOCTOR TILE
// ─────────────────────────────────────────────

class _DoctorTile extends StatelessWidget {
  final DoctorEntity doctor;
  final bool isSelected;
  final VoidCallback onTap;

  const _DoctorTile({
    required this.doctor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withOpacity(0.02) : cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary.withOpacity(0.2) : cs.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AvatarWidget(initialLetter: doctor.name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.title != null
                        ? '${doctor.title} ${doctor.name}'
                        : 'Bs. ${doctor.name}',
                    style: tt.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? cs.primary : cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (doctor.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      doctor.description!,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // ── Check icon ──────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      key: const ValueKey('checked'),
                      size: 20,
                      color: cs.primary,
                    )
                  : Icon(
                      Icons.radio_button_unchecked_rounded,
                      key: const ValueKey('unchecked'),
                      size: 20,
                      color: cs.outlineVariant,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
