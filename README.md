# TOEIC Reading — Đồ án giữa kỳ

Lê Minh Đình Tiến · 2380602224 · 23DTHC7.

Backend dùng template ASP.NET Boilerplate MVC hiện có, .NET 9 và SQL Server local. Mobile Flutter mở thẳng thư viện, không đăng nhập. Admin demo local vào trực tiếp; ngoài Development/localhost vẫn yêu cầu quyền Pages.ReadingAdmin.

Đã kiểm chứng ngày 12/10/2026: build Backend; 25/25 kiểm thử Backend; kết nối và migrations SQL localhost; import Word hợp lệ, từ chối file sai không ghi dở; sửa/lưu/đọc lại SQL; API thi và chấm bài trống, một phần, đủ 100 câu, nộp trùng và hết hạn. Kết quả chi tiết: [TESTING](Backend/docs/TESTING.md). Flutter có bản web và kiểm thử không có màn hình đăng nhập. Chưa kiểm chứng Android trên thiết bị/emulator, mất mạng trên thiết bị, hoặc một lượt thi liên tục đủ 75 phút. Không tuyên bố hoàn thành 100%.

## Bàn giao

Repository này chứa source code; hai file Word đề thi/báo cáo được nộp riêng và không được upload theo yêu cầu sinh viên. Video sinh viên đã bổ sung trong `videos/`. Những đường dẫn Word, ảnh minh chứng và kết quả kiểm thử bên dưới mô tả artifact trên máy làm bài, không có sẵn trong repo.

Để chạy các test parser DOCX/integration, đặt file Word Tagged đã nộp riêng tại `Backend/docs/TOEIC-Reading-Test10-Tagged.docx`. Source ứng dụng chạy không cần file đó sau khi đã import đề vào SQL.


- Backend/aspnet-core: source MVC, parser Word, EF migrations, API và worker hết hạn.
- Frontend: source Flutter, Android và web; không dùng mock data trong ứng dụng.
- Backend/docs/TOEIC-Reading-Test10-Tagged.docx: 100 câu 101–200; Part 5/6/7 = 30/16/54; 19 nhóm, 27 tài liệu; 75 phút.
- Backend/docs/BaoCao-LeMinhDinhTien-2380602224.docx: báo cáo theo mẫu gốc, chỉ dùng ảnh chức năng thực tế.
- Backend/docs/ERD.png, Backend/docs/migration-plan.sql, Backend/docs/evidence: sơ đồ, schema và kết quả kiểm tra.
- [Figma Make AI](https://www.figma.com/make/tEmZRZ6BuPKQhvfr7VauZT/Design-Reading-Studio-UI): 16 màn hình prototype thật. [Chi tiết Figma](Backend/docs/FIGMA.md).
- Frontend/design/figma-make/src: mã giao diện xuất trực tiếp từ Make, làm căn cứ triển khai Flutter.
- videos/README.md: kịch bản và video demo do sinh viên cung cấp.

Đáp án là **đề xuất**, chưa xác minh với đáp án ETS chính thức, không quy đổi điểm TOEIC. Bài đọc ảnh giữ bố cục PDF gốc; văn bản trích PDF cần đối chiếu khi biên tập.

## SQL và Backend

Máy chạy Backend là Windows local, cùng máy SQL của người dùng. Database duy nhất được thao tác: localhost/ToeicReadingDB. Windows Authentication, Encrypt=True, TrustServerCertificate=True cho demo local. Database đã có schema và dữ liệu thật; không cần import lại để xem demo.

```powershell
cd D:\KTGK
powershell -ExecutionPolicy Bypass -File Backend/tools/Configure-Sql.ps1
powershell -ExecutionPolicy Bypass -File Backend/tools/Start-Backend.ps1
```

Mở http://localhost:5100/ để chọn Admin hoặc User. Admin demo trên localhost không cần mật khẩu. Xem [LOCAL-DEMO](Backend/docs/LOCAL-DEMO.md) để build Flutter dưới /app/ và chạy cùng Backend. Script cấu hình không yêu cầu mật khẩu SQL, chỉ kiểm tra Windows Authentication và ghi file local. Nếu chuyển sang máy mới, đọc [SQL-SETUP](Backend/docs/SQL-SETUP.md) để chạy Migrator.

Nếu cần tạo lại tài nguyên giao diện Admin:

```powershell
cd Backend/aspnet-core/src/MyCompany.MyProject.Web.Mvc
npm install --ignore-scripts --no-audit --no-fund
node node_modules/gulp/bin/gulp.js buildDev
```

## Flutter

```powershell
cd D:\KTGK\Frontend
flutter pub get
flutter run -d chrome --web-port=5200 --dart-define=API_URL=http://localhost:5100
```

Mở trực tiếp thư viện. Nút cài đặt kết nối cho phép đổi địa chỉ Backend. Emulator Android dùng http://10.0.2.2:5100; điện thoại thật dùng địa chỉ LAN của máy Backend và cùng mạng. Backend demo chạy cổng 5100. Cần Android SDK để build APK/chạy Android; emulator chỉ cần khi không thử trên điện thoại. Chưa cài SDK hoặc chấp nhận license thay người dùng.

Phiên khách sinh mã ngẫu nhiên 256 bit lưu trong secure storage; gửi header X-Reading-Session. Server chỉ lưu hash, không trả đáp án trước nộp. Không xóa dữ liệu ứng dụng giữa lượt thi nếu muốn tiếp tục. Lựa chọn chưa gửi được lưu trên máy; gửi tới server sau hạn sẽ bị từ chối. Đề đã có lượt thi được khóa chỉnh sửa để bảo toàn kết quả.

Android cho phép HTTP để demo nội bộ; triển khai thật cần HTTPS. Bản web không thay cho xác minh Android.

## Kiểm tra lại

```powershell
dotnet test Backend/aspnet-core/test/MyCompany.MyProject.Tests
cd Frontend
flutter analyze
flutter test
flutter build web --base-href /app/ --dart-define=API_URL=http://localhost:5100
```

Backend/tools/integration_check.py kiểm thử HTTP và SQL thật khi Backend đang chạy. Script tạo các lượt thử riêng và rút ngắn hạn của đúng fixture hết hạn; không sửa thời lượng đề 75 phút. Có thể chạy --setup-only để kiểm tra import/xem trước. Đề có lượt thi sẽ khóa kiểm thử sửa.

Đối chiếu 8 tiêu chí trong [CHECKLIST](Backend/docs/CHECKLIST.md). Source đã upload lên https://github.com/leminhdinhtien-creator/KTGK (nhánh main); video đã bổ sung trong videos/. Giữ .runtime, .recovery, bin/obj, node_modules, cấu hình local và secrets ngoài Git. Template gốc MyCompany.MyProject được giữ nguyên.


Giao diện hiện tại lấy từ **Figma Make V2** “Upgrade Reading Studio Design”: thư viện tìm kiếm, màn thi responsive, tab bài đọc/câu hỏi và tài liệu, điều hướng 100 câu, trạng thái lưu, kết quả có bộ lọc và Admin xem theo nhóm. Nguồn xuất trực tiếp được giữ trong `Frontend/design/figma-make`, bản gốc trong `src/legacy`. Xem [bàn giao thiết kế V2](Backend/docs/FIGMA-V2-HANDOFF.md). Mở http://localhost:5100/ và nhấn Ctrl+F5 để nhận bản giao diện mới.


Đối chiếu cuối với đề gốc: [FINAL-REVIEW](Backend/docs/FINAL-REVIEW.md). Chức năng đã kiểm tra đạt; phần Mobile chưa chạy trên thiết bị/emulator và video mới đã thay bản 80,83 giây; cần rà soát nội dung video mới. Đã bổ sung kiểm tra Part 6 stem chỉ chứa đúng số câu; fresh import và biên tập SQL được kiểm thử trên fixture riêng.

## Cấu trúc bàn giao

Hai thư mục source chính: `Backend/` (ASP.NET MVC, database, docs, tools) và `Frontend/` (Flutter, design Figma). `videos/` chứa video theo yêu cầu thầy. README và .gitignore ở thư mục gốc. Các thư mục ẩn .runtime, .recovery, Backend/.work và Backend/.template-original chỉ phục vụ máy local, không đưa lên GitHub. Word và báo cáo trong Backend/docs được nộp riêng.

Kiểm tra lại sau khi gom thư mục: [kết quả ngày 12/10/2026](Backend/docs/RECHECK-2026-10-12.md). Đã rà video mới 93,20 giây; xem báo cáo để phân biệt chức năng đã kiểm thử và phần Mobile/video cần bổ sung.
