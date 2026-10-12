# Đối chiếu 8 tiêu chí của giảng viên

Kiểm tra ngày 12/10/2026. Kết quả dưới đây dựa trên artifact và kiểm thử thật, không phải tự chấm điểm.

| Tiêu chí | Điểm | Minh chứng đã có | Phần còn cần kiểm tra |
|---|---:|---|---|
| Word TOEIC | 1 | DOCX Tagged 100 câu 101–200, 30/16/54, 19 nhóm, 27 tài liệu, 75 phút; parser file thật đạt; đã render và rà soát 49 trang | Đáp án proposed, chưa đối chiếu key chính thức; văn bản trích PDF cần rà soát khoảng trắng khi biên tập |
| Thiết kế CSDL | 1 | ERD 8 bảng Reading; migrations thực tế; 45 bảng SQL localhost/ToeicReadingDB; FK và migrations ở sql-schema.json | Không còn bước kết nối/schema chưa thực hiện trên máy này |
| Upload/import Word | 1 | Import thật và row counts 1/3/19/27/100/400; file lỗi không ghi dở; trùng bị từ chối; giao diện xem trước Word thật | Bổ sung video demo theo kịch bản |
| Chỉnh sửa đề | 1 | API lưu/đọc lại câu và tài liệu trên SQL; thao tác lưu câu 101 qua Admin; admin-edit.png; đề có lượt thi khóa sửa | Video biên tập cần đề thử mới chưa có lượt thi |
| Danh sách đề | 1 | Flutter web mở thư viện trực tiếp từ API/SQL, không login; flutter-library.png | Xác minh trên Android |
| Thi và link Figma | 3 | Figma Make AI thật 16 màn; Flutter web các Part và zoom; 22 ca HTTP/SQL, chọn/đổi/hủy, phục hồi, nộp trùng, worker hết hạn | Android/thiết bị, lượt liên tục 75 phút, kiểm thử mất mạng đầy đủ; bản native Design cần sửa/QA vì hết quota |
| Kết quả thi | 1 | SQL/API bài trống 0/0/100, một phần 1/1/98, đủ 100/0/0; tổng=100, không sửa sau nộp; ảnh Flutter thực tế flutter-result.png | Bổ sung video; chấm theo key proposed |
| Giao diện đẹp, thân thiện | 1 | Make AI và Flutter dùng DM Sans/Playfair, ink/emerald/paper; đã kiểm tra kích thước điện thoại và sửa nút grid bị xuống dòng | QA bản Android và bản native Design; đánh giá của giảng viên |

Backend 23/23 tests đạt; Flutter 1/1 widget test đạt, analyze không có vấn đề, build web thành công. Bản web không thay kiểm thử Android. Ca deadline rút ngắn thuộc fixture thử riêng; đề vẫn 75 phút. Source Backend nằm ở Backend/aspnet-core/src; Frontend ở Frontend/lib/main.dart. Chi tiết: docs/TESTING.md, docs/FIGMA.md, docs/evidence.

Source đã upload lên GitHub/KTGK; chưa quay video, chưa cài Android SDK/chấp nhận license. Không ghi “hoàn thành 100%”.
