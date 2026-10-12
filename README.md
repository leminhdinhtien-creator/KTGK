# TOEIC Reading — Đồ án giữa kỳ

Lê Minh Đình Tiến · 2380602224 · 23DTHC7.

Backend dùng template ASP.NET Boilerplate MVC hiện có, .NET 9 và SQL Server local. Mobile Flutter mở thẳng thư viện, không đăng nhập. Admin giữ authentication và quyền Pages.ReadingAdmin.

Đã kiểm chứng ngày 12/10/2026: build Backend; 23/23 kiểm thử Backend; kết nối và migrations SQL localhost; import Word hợp lệ, từ chối file sai không ghi dở; sửa/lưu/đọc lại SQL; API thi và chấm bài trống, một phần, đủ 100 câu, nộp trùng và hết hạn. Kết quả chi tiết: [TESTING](docs/TESTING.md). Flutter có bản web và kiểm thử không có màn hình đăng nhập. Chưa kiểm chứng Android trên thiết bị/emulator, mất mạng trên thiết bị, hoặc một lượt thi liên tục đủ 75 phút. Không tuyên bố hoàn thành 100%.

## Bàn giao

Repository này chứa source code; hai file Word đề thi/báo cáo được nộp riêng và không được upload theo yêu cầu sinh viên. Video full screen sẽ bổ sung trong `videos/`. Những đường dẫn Word, ảnh minh chứng và kết quả kiểm thử bên dưới mô tả artifact trên máy làm bài, không có sẵn trong repo.

Để chạy các test parser DOCX/integration, đặt file Word Tagged đã nộp riêng tại `docs/TOEIC-Reading-Test10-Tagged.docx`. Source ứng dụng chạy không cần file đó sau khi đã import đề vào SQL.


- Backend/aspnet-core: source MVC, parser Word, EF migrations, API và worker hết hạn.
- Frontend: source Flutter, Android và web; không dùng mock data trong ứng dụng.
- docs/TOEIC-Reading-Test10-Tagged.docx: 100 câu 101–200; Part 5/6/7 = 30/16/54; 19 nhóm, 27 tài liệu; 75 phút.
- docs/BaoCao-LeMinhDinhTien-2380602224.docx: báo cáo theo mẫu gốc, chỉ dùng ảnh chức năng thực tế.
- docs/ERD.png, docs/migration-plan.sql, docs/evidence: sơ đồ, schema và kết quả kiểm tra.
- [Figma Make AI](https://www.figma.com/make/tEmZRZ6BuPKQhvfr7VauZT/Design-Reading-Studio-UI): 16 màn hình prototype thật. [Chi tiết Figma](docs/FIGMA.md).
- design/figma-make/src: mã giao diện xuất trực tiếp từ Make, làm căn cứ triển khai Flutter.
- videos/README.md: kịch bản quay demo; chưa có video nộp bài.

Đáp án là **đề xuất**, chưa xác minh với đáp án ETS chính thức, không quy đổi điểm TOEIC. Bài đọc ảnh giữ bố cục PDF gốc; văn bản trích PDF cần đối chiếu khi biên tập.

## SQL và Backend

Máy chạy Backend là Windows local, cùng máy SQL của người dùng. Database duy nhất được thao tác: localhost/ToeicReadingDB. Windows Authentication, Encrypt=True, TrustServerCertificate=True cho demo local. Database đã có schema và dữ liệu thật; không cần import lại để xem demo.

```powershell
cd D:\KTGK
powershell -ExecutionPolicy Bypass -File tools/Configure-Sql.ps1
powershell -ExecutionPolicy Bypass -File tools/Start-Backend.ps1
```

Mở http://localhost:5100/Reading. Đăng nhập tài khoản Admin của template đã được seed. Password không nằm trong hướng dẫn bàn giao; dùng thông tin Admin hiện có. Script cấu hình không yêu cầu mật khẩu SQL, chỉ kiểm tra Windows Authentication và ghi file local. Nếu chuyển sang máy mới, đọc [SQL-SETUP](docs/SQL-SETUP.md) để chạy Migrator.

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
flutter build web --dart-define=API_URL=http://localhost:5100
```

tools/integration_check.py kiểm thử HTTP và SQL thật khi Backend đang chạy. Script tạo các lượt thử riêng và rút ngắn hạn của đúng fixture hết hạn; không sửa thời lượng đề 75 phút. Có thể chạy --setup-only để kiểm tra import/xem trước. Đề có lượt thi sẽ khóa kiểm thử sửa.

Đối chiếu 8 tiêu chí trong [CHECKLIST](CHECKLIST.md). Source đã upload lên https://github.com/leminhdinhtien-creator/KTGK (nhánh main); video bổ sung sau. Giữ .runtime, .recovery, bin/obj, node_modules, cấu hình local và secrets ngoài Git. Template gốc MyCompany.MyProject được giữ nguyên.
