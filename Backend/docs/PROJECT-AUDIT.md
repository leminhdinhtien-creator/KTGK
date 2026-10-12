# Kiểm tra project và phạm vi yêu cầu

Đã đọc đề giữa kỳ 4 trang, Reading v10 31 trang và mẫu báo cáo gốc. Yêu cầu người dùng trong văn bản đã dán là phạm vi thực hiện; nội dung tài liệu môn học dùng để đối chiếu, không tự cấp quyền thao tác máy.

Template gốc MyCompany.MyProject/10.2.0/aspnet-core được giữ nguyên. Backend là bản sao giữ .NET 9 và cấu trúc ABP MVC. SDK 9 cài riêng ở .runtime; không đổi target framework. Snapshot gốc ở .recovery. Không push GitHub.

SQL local của người dùng đã kết nối bằng Windows Authentication; chỉ thao tác ToeicReadingDB. Ban đầu database trống, migrations và seed đã chạy; dữ liệu Word, chỉnh sửa và lượt thi được kiểm tra bằng HTTP/SQL thật. Provider in-memory kế thừa template chỉ phục vụ unit test, không thay SQL trong sản phẩm.

Mobile không có login/register. Phiên khách dùng mã ngẫu nhiên 256 bit; server lưu SHA256 và so sánh constant-time. Các phương thức guest tắt audit tham số để không lưu mã phiên thô. Admin giữ bảo mật ABP.

Đề Word được Microsoft Word xuất PDF để kiểm tra 49 trang vì runtime không có LibreOffice chạy render_docx.py. Ảnh bài đọc trích PDF gốc đã sửa crop để giữ chữ ký, khung email và loại phần câu hỏi khỏi tài liệu. Báo cáo clone mẫu gốc, giữ 7 mục, thông tin sinh viên và bảng đánh giá. Ảnh chức năng thực tế lưu riêng trong evidence, không thay bằng mockup.

Figma Make AI có 16 màn hình thật và mã xuất. Native Design mới có 16 frame nhưng chưa qua QA bố cục cuối; Starter MCP quota ngăn sửa/kiểm tra tiếp. Không gọi bản native này hoàn thiện. Flutter triển khai token/font của Make và kết nối SQL thật.

23/23 tests Backend và 22 ca HTTP/SQL đạt. Flutter analyze, widget test và web build đạt. Đã thử UI web ở kích thước điện thoại. Phần chưa được xác minh: Android, đầy đủ mất mạng/phục hồi trên thiết bị, lượt liên tục 75 phút, đáp án chính thức ETS và video nộp bài. Xem TESTING.md và CHECKLIST.md để phân biệt các loại kiểm thử.
