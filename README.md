# Giờ Làm – app đếm giờ làm cho iPhone

## Cài (làm 1 lần trên MacBook)
1. `brew install xcodegen`
2. `cd WorkTimer && xcodegen` → tạo ra `WorkTimer.xcodeproj`
3. Mở `WorkTimer.xcodeproj` bằng Xcode.
4. Click project WorkTimer → từng target (WorkTimer và WorkWidget) → Signing & Capabilities → chọn Team (Apple ID của Boss).
   - Nếu báo trùng bundle id / app group: đổi `jun1stic` thành tên khác ở `project.yml`
     (3 chỗ: bundleIdPrefix, group.com.jun1stic.worktimer, 2 PRODUCT_BUNDLE_IDENTIFIER) và ở `Shared/WorkStore.swift`, rồi chạy lại `xcodegen`.
5. Cắm iPhone, chọn iPhone ở thanh trên, bấm Run. Lần đầu: iPhone → Cài đặt → Cài đặt chung → VPN & Quản lý thiết bị → Tin cậy.
   (Apple ID free: app hết hạn sau 7 ngày, cắm Mac Run lại là xong.)

## Đặt lên màn hình chính
Giữ lâu màn hình → dấu + → tìm "Giờ Làm" → chọn widget nhỏ hoặc vừa. Bấm START / STOP ngay trên widget.
Widget hiện đồng hồ chạy + tổng giờ tuần (T2→CN) / mục tiêu 20h.

## Tự bật chế độ Work khi Start
iOS không cho app tự bật Focus, nên dùng Shortcuts (1 tap):
1. Shortcuts → tạo shortcut **Work Start**: action "Set Focus" → Work → Turn On, rồi action "Bắt đầu giờ làm" (của app Giờ Làm).
2. Tạo **Work Stop**: "Dừng giờ làm", rồi "Set Focus" → Turn Off.
3. Đưa 2 shortcut này ra màn hình chính (widget Shortcuts) hoặc gán vào Action Button (Cài đặt → Nút tác vụ → Shortcut).
Dùng cách này thì 1 chạm là vừa tính giờ vừa vào Work mode.

---
## Bản web (docs/) – không cần Xcode
Bật GitHub Pages: repo → Settings → Pages → Source: Deploy from a branch → `main` / `/docs` → Save.
Link: https://daiduong0106-dev.github.io/Deep-Work/
Safari → Chia sẻ → Thêm vào Màn hình chính.
Shortcut 1 chạm: "Set Focus: Work" + "Open URL" `https://daiduong0106-dev.github.io/Deep-Work/#start` (dừng thì dùng `#stop`).
