# Kết quả kiểm thử — 12/10/2026

Backend build: thành công; 23/23 tests đạt, gồm parser DOCX thật, chấm điểm và bảo vệ mã phiên. Flutter analyze không có vấn đề, 1/1 widget test mở thư viện không login đạt. Bản web đã build; chưa kiểm thử Android.

## HTTP và SQL thật

Đã chạy tools/integration_check.py trên Backend localhost:5100 và SQL localhost/ToeicReadingDB. Không dùng SQLite cho ca tích hợp này. SQL-schema.json và sql-api-integration.json là kết quả thực tế.

| Ca | Trạng thái | Chi tiết |
|---|---|---|
| SQL connection and schema | PASS | 45 tables |
| Public exam library without login | PASS |  |
| Admin remains protected | PASS |  |
| Admin real authentication and permission | PASS |  |
| Word preview before writing SQL | PASS |  |
| Invalid DOCX rejected with no partial records | PASS |  |
| Existing valid imported exam reused | PASS |  |
| Actual SQL row counts | PASS | {'Exams': 1, 'Parts': 3, 'Groups': 19, 'Documents': 27, 'Questions': 100, 'Choices': 400} |
| Duplicate import rejected | PASS |  |
| Admin preview grouping and image content | PASS |  |
| Admin question/document edit persisted and original restored | PASS |  |
| Anonymous start, 75-minute server deadline, answers withheld | PASS |  |
| Wrong session cannot read another attempt | PASS |  |
| Empty submission scored 0/0/100 | PASS |  |
| Choose, change and cancel persist on SQL | PASS |  |
| Restore same active attempt and answers | PASS |  |
| Partial submission and post-submit locking | PASS |  |
| Full submission scored 100/0/0; concurrent submit idempotent | PASS |  |
| Concurrent start creates one active attempt | PASS |  |
| Expired fixture rejects late answer and finalizes | PASS |  |
| Background worker submits closed-client expired fixture | PASS |  |
| All result counts total 100 | PASS | 0 |

Ca hết hạn rút ngắn Deadline của đúng lượt thử riêng để kiểm tra server/worker, không đổi DurationMinutes của đề. Chưa chạy một lượt liên tục đủ 75 phút. Ca đủ 100 câu dùng đáp án proposed của bộ đề để xác minh cách tính 100/0/0, không xác minh tính chính thức của đáp án.

## Thủ công

Admin đăng nhập, mở đề trong SQL, sửa câu 101 rồi lưu và xem lại: đã chạy. Xem trước Word hợp lệ trên giao diện: đã chạy. Figma Make library và navigator các màn: đã xem. Ảnh thực tế ở docs/evidence. Bản Design mới chưa QA xong vì giới hạn Figma Starter.

Flutter web: đã mở thư viện/chi tiết, làm Part 5/6/7 một/hai/ba tài liệu, zoom, điều hướng 100 câu và nộp bài với kết quả 1 đúng, 1 sai, 98 bỏ qua. Khi Backend tạm ngừng, chọn đổi đáp án hiện hàng chờ và đồng hồ tiếp tục; khi kết nối lại hàng chờ được gửi. Tải lại trang phục hồi cùng lượt thi và thời hạn. Chi tiết ở evidence/manual-web-checks.json và ảnh thực tế.

Chưa xác minh: Android/thiết bị, gián đoạn mạng trên thiết bị, phục hồi ứng dụng sau khi hệ điều hành đóng, và timer liên tục 75 phút.

Parser trả lỗi đầu tiên thay vì gom mọi lỗi. Ảnh bài đọc giữ PDF gốc; văn bản trích có thể có lỗi khoảng trắng. Đáp án proposed không gọi là đáp án chính thức ETS.
