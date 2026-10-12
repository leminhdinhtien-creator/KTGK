# Reading Studio V2 từ Figma Make

Thiết kế được tạo bằng Make AI trong file hiện có ngày 12/10/2026, Version 2 “Upgrade Reading Studio Design”. Nguồn được tải bằng Files → File actions → Download code, giữ V1 trong src/legacy.

Link: https://www.figma.com/make/tEmZRZ6BuPKQhvfr7VauZT/Design-Reading-Studio-UI

Ứng dụng tiếp tục dùng Flutter và ASP.NET MVC với SQL thật. Prototype minh họa không thay thế dữ liệu Backend. Các thành phần đã chuyển theo thiết kế: ProductHeader, Library, ExamHeader, QuestionGrid, PassagePane, QuestionPane, Results và AdminLayout. Màu và kích thước lấy từ src/index.css. Trạng thái loading/error/mạng và kết quả trong bản chạy được nối với API thật, không đưa công tắc trạng thái minh họa vào ứng dụng.


| Thành phần Figma V2 | Bản chạy lấy dữ liệu thật |
|---|---|
| ProductHeader | Views/Studio/Index.cshtml và CSS V2 xuất trực tiếp từ Make; giữ hai khu vực khi chuyển vai trò |
| Library | Flutter listView/examCover/examInfo; tìm tên đề, thông tin và luồng chọn đề từ API |
| ExamHeader/QuestionGrid | Flutter examView/questionGrid; thời gian server, Part tabs, lưới 101–200 và trạng thái đã lưu |
| PassagePane/QuestionPane | Desktop tách vùng cuộn; mobile chuyển Bài đọc/Câu hỏi; tab tài liệu và zoom ảnh SQL |
| Results | Ba chỉ số chấm thật; lọc Tất cả/Đúng/Sai/Bỏ qua |
| Admin | Quy trình Word, tìm đề, chọn Part, tài liệu và câu hỏi trong cùng nhóm; biên tập dùng API cũ và CSRF |

GroupKey ở phản hồi xem trước Admin giữ quan hệ nhóm ngay cả trước khi EF cấp ID cho file Word. Đây là dữ liệu phục vụ hiển thị; cấu trúc SQL và cơ chế chấm không đổi.

Đã kiểm tra trên browser 1440×900 và 390×844: tìm đề, mở đề, chọn/đổi/hủy, khôi phục sau tải lại, ảnh/phóng to, tab ba tài liệu, xác nhận nộp, kết quả và lọc, chuyển Admin/User, xem trước Part 6. Build Backend/Flutter thành công, Flutter analyze không có vấn đề, 2 widget tests và 23 Backend tests đạt; 21 ca HTTP/SQL đã chạy lại, có thêm xác minh GroupKey trong Word preview trước khi lưu SQL. Android vẫn chưa chạy trên thiết bị/emulator.

Đã xuất và giữ nguyên nguồn Make V2, gồm cả V1 trong src/legacy. Trong ứng dụng không có menu chuyển trạng thái minh họa, số liệu giả, đánh dấu giả hoặc lời tuyên bố đang dùng backend khi chưa kết nối.
