# Đối chiếu 8 tiêu chí của giảng viên

Kết quả audit ngày 12/10/2026, dựa trên PDF gốc, artifact và kiểm thử thật. Không tự chấm điểm.

| Tiêu chí | Minh chứng chức năng | Cần chốt bàn giao |
|---|---|---|
| Word TOEIC | 100 câu, 30/16/54, Tags và 27 ảnh đúng nguồn PDF | Key proposed chưa xác minh ETS |
| CSDL phù hợp | SQL Server thật, 8 bảng Reading, quan hệ đề/phần/nhóm/tài liệu/câu/choice/attempt/answer | Đã có |
| Upload tạo đề từ Word | Fresh import đạt; file sai/Part 6 stem sai bị từ chối không ghi dở | Video cần thể hiện import thành công, không chỉ báo trùng |
| Chỉnh sửa nội dung đề | Câu/options/key/text/ảnh lưu rồi đọc lại đúng SQL ở fixture riêng | Video cần chứng minh thay đổi đã lưu; dùng đề chưa có lượt thi |
| Danh sách đề để chọn | API thật, tên/75 phút/100 câu, tìm kiếm, không login | Chạy Mobile thật |
| Thi và link thiết kế | Figma Make V2 đã đưa về app; chọn/đổi/hủy/lưu/restore, countdown, late answer/worker, xác nhận nộp | Chạy Mobile, bổ sung demo Part 7 và hết giờ |
| Kết quả thi | Đúng/sai/bỏ qua tổng100; nộp trùng nhất quán; lọc chi tiết | Video bản V2 |
| Giao diện thân thiện | Figma V2; layout desktop và mobile390, tab tài liệu, đọc/câu hỏi tách rõ | Đẹp/thân thiện và điểm cuối do giảng viên đánh giá |

25 Backend tests, 2 Flutter tests, 22 ca HTTP/SQL đều đạt. Có kiểm tra riêng fresh import và biên tập SQL. Xem docs/FINAL-REVIEW.md và docs/TESTING.md. Video cũ đã có trên GitHub nhưng chưa đủ nội dung; Mobile chưa kiểm thử trên điện thoại/emulator. Word không upload theo yêu cầu sinh viên.
