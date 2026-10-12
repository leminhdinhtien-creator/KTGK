# Đối chiếu cuối với đề gốc ngày 12 tháng 10 năm 2026

Đã đọc đủ 4 trang Đề thi giữa kỳ.pdf, đối chiếu Reading v10.pdf (31 trang), Word Tagged, schema/data SQL thật, source và video hiện có. Phạm vi đối chiếu là yêu cầu I–VI và 8 tiêu chí; không tự chấm điểm.

| Yêu cầu | Minh chứng hiện tại | Kết luận |
|---|---|---|
| Part 5 độc lập | 30 câu 101–130, bốn lựa chọn, không group | Đạt cấu trúc |
| Part 6 theo bài đọc | 16 câu 131–146, stem là số câu, blanks khớp nhóm; parser đã bổ sung từ chối stem sai | Đạt cấu trúc |
| Part 7 nhóm tài liệu | 54 câu 147–200; 10 nhóm đơn, 2 nhóm đôi, 3 nhóm ba tài liệu | Đạt cấu trúc |
| DOCX và Tags | 100 câu, 400 lựa chọn, 75 phút, 27 ảnh có cùng hash với ảnh trích PDF; nguồn PDF hash khớp | Đạt; key vẫn proposed |
| CSDL | Microsoft SQL Server localhost/ToeicReadingDB, 8 bảng Reading trong schema ABP | Đạt |
| Backend | ASP.NET Boilerplate MVC, thư mục Backend và Frontend giữ đúng | Đạt |
| Upload Word | Import bản mới thành công; file lỗi và stem Part 6 sai bị từ chối, không ghi dở | Đạt |
| Xem trước/biên tập | Preview trước/sau SQL đúng GroupKey; cập nhật câu/options/key/text/ảnh rồi đọc lại đúng | Đạt; đề có lượt thi được khóa sửa |
| Danh sách/thi/kết quả | API/SQL thử chọn/đổi/hủy/khôi phục, deadline 4500 giây, late answer/worker hết hạn, nộp đồng thời, ba loại kết quả tổng 100 | Đạt các ca đã chạy |
| Figma và hiện thực | Figma Make V2 thật, nguồn Download code, triển khai Flutter/MVC, kiểm tra browser 1440 và 390 | Đạt trên web responsive |
| Mobile | Source Flutter/Android có; chưa build/chạy trên điện thoại hay emulator | Chưa xác minh runtime Mobile theo mục V.2.a |
| Word báo cáo | Giữ mẫu 7 phần, ERD và ảnh chức năng; Word không bị sửa ở lượt audit này | Có artifact nộp riêng; ảnh một số phần là bản trước V2 |
| GitHub | Source và video trong repository KTGK; Word nộp riêng theo yêu cầu sinh viên | Có |
| Video demo từng chức năng | File 80,83 giây, 1920×1080, giao diện V1. Rà khung hình mỗi giây suốt video | Chưa đủ minh chứng; cần quay bổ sung/thay bản V2 |

## Kiểm chứng

25/25 Backend tests, 2/2 Flutter tests; Flutter analyze không có vấn đề. Build Backend và Flutter đã thành công. 22/22 ca HTTP/SQL đạt, gồm ca mới Part 6 non-numeric bị từ chối nguyên tử. Kiểm tra riêng fresh import và biên tập thực tế đạt; fixture do audit tạo đã được xóa sau khi kiểm tra đúng quyền sở hữu và không có lượt thi, hai đề gốc được giữ nguyên.

Đối chiếu văn bản PDF: 400 lựa chọn tìm được trên đúng trang nguồn; 20 stem Part 5 cần rà trực quan vì thứ tự trích PDF/ký tự blank, đã xem trang 2–4 và khớp. 27 ảnh DOCX khớp byte với tài liệu trích PDF gốc. Không coi key proposed là đáp án ETS chính thức.

## Video hiện có

Các khung hình cho thấy upload/xem trước, báo file trùng (khoảng giây 16), mở form sửa, thư viện, chi tiết, Part 5 và Part 6, chọn/nộp và kết quả. Chưa thấy import một đề mới thành công, biên tập lưu rồi tải lại chứng minh thay đổi, file sai Tags bị hủy, Part 7 một/hai/ba tài liệu, cảnh báo 5 phút/tự thu khi hết giờ, hoặc demo Mobile. Nội dung Figma và Word cũng chưa được giới thiệu thành bước demo. Đánh giá là rà khung hình mỗi giây, không nghe/chép âm thanh hay xác nhận toàn bộ thao tác rất ngắn giữa các khung hình.

## Cần chốt trước khi coi toàn bộ bài nộp hoàn tất

1. Chạy thử Flutter trên điện thoại/emulator để xác nhận phần ứng dụng di động; kiểm thử web không thay cho mục này. Thầy không yêu cầu nộp riêng bộ Android SDK, APK hay một video liên tục 75 phút.
2. Quay demo giao diện V2 đủ chức năng, dùng bản Word thử mới chưa có lượt thi cho import và biên tập; đưa video mới vào videos trên GitHub. Không sửa đề gốc/đề đã thi để quay.

Cảnh báo 5 phút trong UI được đối chiếu mã, server deadline/expiry đã chạy thực tế bằng fixture; chưa quan sát cảnh báo UI trong một lượt liên tục đủ 75 phút. Mức đẹp/thân thiện và điểm số cuối do giảng viên đánh giá.
