# Hệ thống Thiết kế — LTC = 0785588272

> Bộ màu và quy chuẩn giao diện cho ứng dụng y tế LTC.  
> Được thiết kế để tạo cảm giác **chuyên nghiệp · tin cậy · hiện đại**.

---

## 1. Màu Chính (Primary)

Sử dụng cho CTA, logo, và các yếu tố thương hiệu chính.

| Tên                  | Hex       | Dùng khi                            |
| -------------------- | --------- | ----------------------------------- |
| `primary`            | `#2F80ED` | Button chính, icon active, link     |
| `primaryLight`       | `#EBF3FF` | Background chip, badge, card nhạt   |
| `primaryDark`        | `#1C5BB2` | Hover, pressed state                |
| `primaryGradientEnd` | `#56CCF2` | Gradient splash screen, hero button |

### Gradient chính

```
Linear: #2F80ED → #56CCF2  (135°)
```

---

## 2. Màu Trung Tính (Neutrals)

Sử dụng cho nền, văn bản, và đường phân cách.

| Tên               | Hex       | Dùng khi                         |
| ----------------- | --------- | -------------------------------- |
| `white`           | `#FFFFFF` | Nền card, màn hình chính         |
| `backgroundLight` | `#F8FAFE` | Nền scaffold (phân tách vùng)    |
| `border`          | `#E0E0E0` | Viền card, divider, input border |
| `textPrimary`     | `#1A1C1C` | Tiêu đề, văn bản quan trọng      |
| `textSecondary`   | `#666666` | Subtitle, mô tả                  |
| `textDisabled`    | `#9E9E9E` | Placeholder, disabled            |

---

## 3. Màu Trạng Thái (Semantic)

Sử dụng để thông báo trạng thái quy trình hoặc kết quả y khoa.

| Tên       | Hex       | Trạng thái                          |
| --------- | --------- | ----------------------------------- |
| `success` | `#27AE60` | Sẵn sàng · Hoàn thành · Bình thường |
| `warning` | `#F2994A` | Cần xem xét · Đang xử lý            |
| `error`   | `#EB5757` | Huỷ · Khẩn cấp · Lỗi                |
| `info`    | `#2F80ED` | Thông tin chung                     |

---

## 4. Màu Dark Mode

| Tên              | Hex       | Dùng khi                     |
| ---------------- | --------- | ---------------------------- |
| `surfaceDark`    | `#1E1E2E` | Card, AppBar trong dark mode |
| `backgroundDark` | `#121212` | Scaffold background          |
| `borderDark`     | `#2A2A3E` | Viền card, divider dark      |
| `inputDark`      | `#2A2A3E` | Fill input dark              |

---

## 5. Hiệu ứng (Visual Effects)

### Shadow

```dart
// Soft shadow — dùng cho card, bottom sheet
BoxShadow(
  color: Color(0x0A000000),   // rgba(0,0,0,0.04)
  blurRadius: 24,
  offset: Offset(0, 4),
)
```

### Gradient button

```dart
LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
)
```

---

## 6. Typography — Be Vietnam Pro

Font được thiết kế riêng cho tiếng Việt, dấu thanh rõ ràng.

| Token            | Size | Weight | Dùng khi           |
| ---------------- | ---- | ------ | ------------------ |
| `displayLarge`   | 57   | 700    | Hero, splash       |
| `headlineLarge`  | 32   | 600    | Tiêu đề màn hình   |
| `headlineMedium` | 28   | 600    | Section header     |
| `titleLarge`     | 20   | 600    | AppBar title       |
| `titleMedium`    | 16   | 500    | Card title         |
| `bodyLarge`      | 16   | 400    | Nội dung chính     |
| `bodyMedium`     | 14   | 400    | Nội dung phụ       |
| `bodySmall`      | 12   | 400    | Caption, timestamp |
| `labelLarge`     | 14   | 600    | Button text        |
| `labelSmall`     | 11   | 500    | Badge, chip        |

---

## 7. Spacing & Radius

### Spacing

| Token | Value | Dùng khi           |
| ----- | ----- | ------------------ |
| `xs`  | 4px   | Gap icon-text      |
| `sm`  | 8px   | Padding nhỏ        |
| `md`  | 16px  | Padding tiêu chuẩn |
| `lg`  | 24px  | Section gap        |
| `xl`  | 32px  | Khoảng cách lớn    |
| `xxl` | 48px  | Hero padding       |

### Border Radius

| Token        | Value | Dùng khi            |
| ------------ | ----- | ------------------- |
| `radiusSm`   | 8px   | Badge, chip nhỏ     |
| `radiusMd`   | 12px  | Card, input, button |
| `radiusLg`   | 16px  | Bottom sheet, modal |
| `radiusXl`   | 24px  | Card lớn            |
| `radiusFull` | 999px | Avatar, pill button |

---

## 8. Nguyên tắc sử dụng

```
✅ Dùng primaryLight làm background chip/badge — không dùng màu đậm
✅ Text trên nền primary → dùng white
✅ Divider luôn dùng border (#E0E0E0), không hardcode màu
✅ Spacing luôn dùng AppSpacing.* — không hardcode số
✅ Border radius luôn dùng AppSpacing.radius* — không hardcode số

❌ Không dùng primary cho text dài (khó đọc)
❌ Không mix success/error color ngoài semantic context
❌ Không dùng shadow nặng — chỉ dùng soft shadow rgba(0,0,0,0.04)
```
