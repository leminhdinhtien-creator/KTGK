# Kiểm thử cuối ngày 12 tháng 10 năm 2026

25/25 Backend tests đạt; 2/2 Flutter widget tests đạt; Flutter analyze không có vấn đề. Build Backend và Flutter web thành công. Kiểm tra hiện tại dùng SQL Server thật localhost/ToeicReadingDB; không thay bằng SQLite hoặc dữ liệu mock trong sản phẩm.

## HTTP và SQL thật

| Ca | Kết quả |
|---|---|
| SQL connection and schema | PASS |
| Public exam library without login | PASS |
| Admin write rejects missing antiforgery token | PASS |
| Template Admin authentication remains available | PASS |
| Word preview before writing SQL | PASS |
| Invalid DOCX rejected with no partial records | PASS |
| Non-numeric Part 6 stem rejected without partial SQL writes | PASS |
| Existing valid imported exam reused | PASS |
| Actual SQL row counts | PASS |
| Duplicate import rejected | PASS |
| Admin preview grouping and image content | PASS |
| Anonymous start, 75-minute server deadline, answers withheld | PASS |
| Wrong session cannot read another attempt | PASS |
| Empty submission scored 0/0/100 | PASS |
| Choose, change and cancel persist on SQL | PASS |
| Restore same active attempt and answers | PASS |
| Partial submission and post-submit locking | PASS |
| Full submission scored 100/0/0; concurrent submit idempotent | PASS |
| Concurrent start creates one active attempt | PASS |
| Expired fixture rejects late answer and finalizes | PASS |
| Background worker submits closed-client expired fixture | PASS |
| All result counts total 100 | PASS |

Kiểm tra riêng `tools/final_admin_edit_check.py`: import Word mới, cập nhật nội dung câu/phương án/key, cập nhật và đọc lại văn bản/ảnh SQL đều đạt. Chỉ tạo fixture riêng; cleanup kiểm tra đúng ID/tên ngẫu nhiên và không có lượt thi. Hai đề hiện có được giữ nguyên. Không thử sửa đề cũ đã có lượt thi.

## Giao diện đã thao tác

Figma Make V2 đã tải về; web kiểm tra 1440×900 và 390×844: tìm đề, mở đề, chọn/đổi/hủy, khôi phục sau tải lại, Part 6 và Part 7 ba tài liệu, zoom, xác nhận nộp với câu còn trống, kết quả/lọc, chuyển Admin/User và xem trước theo nhóm. Cảnh báo 5 phút được đối chiếu mã; chưa quan sát bằng một lượt chờ đủ 75 phút.

## Phạm vi chưa xác minh

Source Flutter/Android có nhưng chưa chạy trên thiết bị/emulator. Chưa chạy lượt liên tục 75 phút; expiry/worker dùng deadline rút ngắn đúng fixture riêng, đề vẫn 75 phút. Đáp án proposed chưa đối chiếu key ETS chính thức. Video cũ 80,83 giây là giao diện V1 và chưa đủ demo từng chức năng. Xem FINAL-REVIEW.md để đối chiếu đầy đủ mục I–VI của đề.
