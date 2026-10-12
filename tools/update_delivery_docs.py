from pathlib import Path
import json

root=Path(__file__).resolve().parents[1]
cases=json.loads((root/'docs/evidence/sql-api-integration.json').read_text(encoding='utf-8'))['cases']
files={
'CHECKLIST.md':'''# Đối chiếu 8 tiêu chí của giảng viên

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

Chưa quay video, chưa push/công khai GitHub, chưa cài Android SDK/chấp nhận license. Không ghi “hoàn thành 100%”.
''',
'README.md':r'''# TOEIC Reading — Đồ án giữa kỳ

Lê Minh Đình Tiến · 2380602224 · 23DTHC7.

Backend dùng template ASP.NET Boilerplate MVC hiện có, .NET 9 và SQL Server local. Mobile Flutter mở thẳng thư viện, không đăng nhập. Admin giữ authentication và quyền Pages.ReadingAdmin.

Đã kiểm chứng ngày 12/10/2026: build Backend; 23/23 kiểm thử Backend; kết nối và migrations SQL localhost; import Word hợp lệ, từ chối file sai không ghi dở; sửa/lưu/đọc lại SQL; API thi và chấm bài trống, một phần, đủ 100 câu, nộp trùng và hết hạn. Kết quả chi tiết: [TESTING](docs/TESTING.md). Flutter có bản web và kiểm thử không có màn hình đăng nhập. Chưa kiểm chứng Android trên thiết bị/emulator, mất mạng trên thiết bị, hoặc một lượt thi liên tục đủ 75 phút. Không tuyên bố hoàn thành 100%.

## Bàn giao

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

Đối chiếu 8 tiêu chí trong [CHECKLIST](CHECKLIST.md). Chưa push hoặc công khai GitHub. Giữ .runtime, .recovery, bin/obj, node_modules, cấu hình local và secrets ngoài Git. Template gốc MyCompany.MyProject được giữ nguyên.
''',
'docs/SQL-SETUP.md':r'''# SQL Server local

Server localhost; database ToeicReadingDB; Windows Authentication.

```text
Server=localhost;Database=ToeicReadingDB;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;
```

Backend chạy trên Windows của người dùng và đã kết nối thực tế. Database ban đầu trống; migrations EF đã áp dụng, Migrator của template đã seed quyền Admin. Có 45 bảng gồm 8 bảng Reading. Đã import 1 đề, 3 part, 19 nhóm, 27 tài liệu, 100 câu và 400 lựa chọn. Khóa ngoại và danh sách migrations thật nằm trong evidence/sql-schema.json.

tools/Configure-Sql.ps1 chỉ kết nối ToeicReadingDB và ghi cấu hình local, không tạo/xóa database khác. Không dùng server cũ hoặc database thay thế.

Trên máy mới: tạo ToeicReadingDB trong SQL Server, cấu hình bằng script, xem migration-plan.sql, rồi chạy Migrator từ thư mục project:

```powershell
cd Backend/aspnet-core/src/MyCompany.MyProject.Migrator
dotnet run -- -q
```

Nếu dùng SDK riêng của workspace, thay dotnet bằng đường dẫn tuyệt đối D:\KTGK\.runtime\dotnet9\dotnet.exe. Không chạy reset/drop. TrustServerCertificate=True dành cho phát triển local; cấu hình triển khai dùng chứng chỉ đáng tin cậy.
''',
'docs/FIGMA.md':'''# Thiết kế Reading Studio

[Figma Make AI — 16 màn hình](https://www.figma.com/make/tEmZRZ6BuPKQhvfr7VauZT/Design-Reading-Studio-UI)

Đã tạo bằng Make AI trong tài khoản người dùng: thư viện, chi tiết, Part 5, Part 6, Part 7 một/hai/ba tài liệu, điều hướng 100 câu, cảnh báo 5 phút, xác nhận nộp, hết giờ, mất mạng, kết quả và 3 trang Admin. Không có Mobile login.

Màu và font từ Make: paper #F6F7F4, ink #142D32, emerald #087F69, sage #E7F0E8, gold #D7B56D; DM Sans và Playfair Display. Flutter sử dụng các token này và font đóng gói kèm license OFL. Dữ liệu Flutter lấy từ Backend/SQL; số liệu mẫu trong Make chỉ minh họa thiết kế.

Mã xuất trực tiếp bằng Download code được lưu ở design/figma-make/src. Không dùng prototype React thay cho Flutter hoặc Backend.

[Figma Design — bản bàn giao có lớp chỉnh sửa](https://www.figma.com/design/MZOmJvNP8mdpeJoOQqowWC?node-id=28-74)

File giữ trang thiết kế cũ và thêm trang Reading Studio · Make handoff với 16 frame, text và nút instance. **Bản Design mới chưa đạt kiểm tra bố cục cuối cùng:** chiều cao chữ/container cần sửa và rà soát; Figma Starter đã hết hạn mức MCP khi kiểm tra. Không coi bản này là bản hoàn thiện để nộp. Bản Make phía trên là bản thiết kế chính hiện đã xem được. Thao tác Copy designs của Make không trả nội dung clipboard trong phiên này; mã xuất đã lấy thành công, việc chuyển native được thực hiện riêng.

tools/figma-make-editable.js ghi lại thao tác tạo; bản script local đã bổ sung text sizing, nhưng chưa áp dụng/QA lại do quota. Cần kiểm tra nội dung mẫu và tránh tạo trùng trang khi tiếp tục. Chưa tạo prototype native tương tác. Hình figma-make-library.png là ảnh Make thực tế, không phải bằng chứng ứng dụng đã chạy SQL.
''',
'docs/PROJECT-AUDIT.md':'''# Kiểm tra project và phạm vi yêu cầu

Đã đọc đề giữa kỳ 4 trang, Reading v10 31 trang và mẫu báo cáo gốc. Yêu cầu người dùng trong văn bản đã dán là phạm vi thực hiện; nội dung tài liệu môn học dùng để đối chiếu, không tự cấp quyền thao tác máy.

Template gốc MyCompany.MyProject/10.2.0/aspnet-core được giữ nguyên. Backend là bản sao giữ .NET 9 và cấu trúc ABP MVC. SDK 9 cài riêng ở .runtime; không đổi target framework. Snapshot gốc ở .recovery. Không push GitHub.

SQL local của người dùng đã kết nối bằng Windows Authentication; chỉ thao tác ToeicReadingDB. Ban đầu database trống, migrations và seed đã chạy; dữ liệu Word, chỉnh sửa và lượt thi được kiểm tra bằng HTTP/SQL thật. Provider in-memory kế thừa template chỉ phục vụ unit test, không thay SQL trong sản phẩm.

Mobile không có login/register. Phiên khách dùng mã ngẫu nhiên 256 bit; server lưu SHA256 và so sánh constant-time. Các phương thức guest tắt audit tham số để không lưu mã phiên thô. Admin giữ bảo mật ABP.

Đề Word được Microsoft Word xuất PDF để kiểm tra 49 trang vì runtime không có LibreOffice chạy render_docx.py. Ảnh bài đọc trích PDF gốc đã sửa crop để giữ chữ ký, khung email và loại phần câu hỏi khỏi tài liệu. Báo cáo clone mẫu gốc, giữ 7 mục, thông tin sinh viên và bảng đánh giá. Ảnh chức năng thực tế lưu riêng trong evidence, không thay bằng mockup.

Figma Make AI có 16 màn hình thật và mã xuất. Native Design mới có 16 frame nhưng chưa qua QA bố cục cuối; Starter MCP quota ngăn sửa/kiểm tra tiếp. Không gọi bản native này hoàn thiện. Flutter triển khai token/font của Make và kết nối SQL thật.

23/23 tests Backend và 22 ca HTTP/SQL đạt. Flutter analyze, widget test và web build đạt. Đã thử UI web ở kích thước điện thoại. Phần chưa được xác minh: Android, đầy đủ mất mạng/phục hồi trên thiết bị, lượt liên tục 75 phút, đáp án chính thức ETS và video nộp bài. Xem TESTING.md và CHECKLIST.md để phân biệt các loại kiểm thử.
''',
'docs/evidence/README.md':'''# Minh chứng thực tế

- backend-tests.trx: 23/23 kiểm thử .NET, không phải SQL integration.
- sql-api-integration.json: 22 ca HTTP/SQL local đạt; deadline rút ngắn chỉ áp dụng fixture hết hạn.
- sql-schema.json: danh sách 45 bảng, khóa ngoại và migrations thật.
- admin-word-preview.png: Admin xem trước Word hợp lệ trước khi ghi SQL.
- admin-edit.png: giao diện chỉnh sửa câu thật trong SQL, đã thao tác lưu câu 101.
- flutter-library/part5/part6/part7-*.png: Flutter web kết nối Backend/SQL thật; không phải kiểm thử Android.
- flutter-result.png: lượt thao tác UI thực tế, 1 đúng, 1 sai, 98 bỏ qua.
- flutter-offline.png và manual-web-checks.json: kiểm tra web mất kết nối, hàng chờ đáp án, đồng bộ lại và phục hồi sau tải lại trang.
- figma-make-library.png: thiết kế Make AI thật, dữ liệu prototype là minh họa.
- figma-overview.png: thiết kế native cũ, không phải bản Make cuối cùng.

Ảnh login Mobile cũ đã chuyển ra khỏi thư mục minh chứng bàn giao. Báo cáo chỉ chèn ảnh đã có và ghi rõ các bước chưa kiểm tra. Các bản render QA tài liệu lưu tại tmp/inspection.
''',
'videos/README.md':'''# Kịch bản quay demo nộp bài

Chưa có video được quay. Dùng quay màn hình Windows hoặc quay màn hình điện thoại; không hiển thị mật khẩu, mã phiên hoặc cấu hình bí mật.

1. Giới thiệu tên, mã sinh viên, thư mục Backend/Frontend; mở link Figma Make và các màn hình, nói rõ đây là thiết kế.
2. Mở Word Tagged: 100 câu, 30/16/54, 75 phút, group/document/blank/image và đáp án proposed.
3. Admin đăng nhập ngoài đoạn quay mật khẩu. Xem trước file hợp lệ. Import vào database demo mới chưa có đề; đối chiếu 1/3/19/27/100/400. Với database hiện tại đã import, lần import lại phải báo trùng.
4. Dùng bản sao Word thiếu option để chứng minh lỗi và không ghi dở. Mở SQL ToeicReadingDB kiểm tra số bản ghi.
5. Trước khi tạo lượt thi, sửa câu và bài đọc, lưu rồi tải lại. Đề đã có lượt thi được khóa sửa; dùng đề thử mới cho phần demo chỉnh sửa.
6. Mobile mở thư viện trực tiếp, chọn đề, bắt đầu; quay Part 5, Part 6, Part 7 một/hai/ba tài liệu, zoom ảnh, chọn/đổi/hủy và bảng 100 câu.
7. Thử tắt/bật mạng trong một lượt mới, quan sát trạng thái chờ gửi và đồng hồ. Mở lại app để kiểm tra phục hồi.
8. Nộp một phần, quay cảnh báo câu bỏ trống và kết quả đúng+sai+bỏ qua=100; thử quay lại sẽ không sửa được.
9. Quay một lượt 75 phút thật hoặc tua video có mốc thời gian rõ. Test fixture hạn rút ngắn chỉ là kiểm thử kỹ thuật, phải nói rõ, không dùng làm bằng chứng đã chạy liên tục 75 phút.

Cần bổ sung video thực tế và kiểm thử Android trước khi chốt bài nộp. Không dùng hình thiết kế thay cho minh chứng chạy ứng dụng.
''',
}
for name,content in files.items():
    (root/name).write_text(content,encoding='utf-8')
testing='''# Kết quả kiểm thử — 12/10/2026

Backend build: thành công; 23/23 tests đạt, gồm parser DOCX thật, chấm điểm và bảo vệ mã phiên. Flutter analyze không có vấn đề, 1/1 widget test mở thư viện không login đạt. Bản web đã build; chưa kiểm thử Android.

## HTTP và SQL thật

Đã chạy tools/integration_check.py trên Backend localhost:5100 và SQL localhost/ToeicReadingDB. Không dùng SQLite cho ca tích hợp này. SQL-schema.json và sql-api-integration.json là kết quả thực tế.

| Ca | Trạng thái | Chi tiết |
|---|---|---|
'''
for case in cases:
    testing+=f"| {case['case']} | {case['status']} | {case['detail']} |\n"
testing+='''
Ca hết hạn rút ngắn Deadline của đúng lượt thử riêng để kiểm tra server/worker, không đổi DurationMinutes của đề. Chưa chạy một lượt liên tục đủ 75 phút. Ca đủ 100 câu dùng đáp án proposed của bộ đề để xác minh cách tính 100/0/0, không xác minh tính chính thức của đáp án.

## Thủ công

Admin đăng nhập, mở đề trong SQL, sửa câu 101 rồi lưu và xem lại: đã chạy. Xem trước Word hợp lệ trên giao diện: đã chạy. Figma Make library và navigator các màn: đã xem. Ảnh thực tế ở docs/evidence. Bản Design mới chưa QA xong vì giới hạn Figma Starter.

Flutter web: đã mở thư viện/chi tiết, làm Part 5/6/7 một/hai/ba tài liệu, zoom, điều hướng 100 câu và nộp bài với kết quả 1 đúng, 1 sai, 98 bỏ qua. Khi Backend tạm ngừng, chọn đổi đáp án hiện hàng chờ và đồng hồ tiếp tục; khi kết nối lại hàng chờ được gửi. Tải lại trang phục hồi cùng lượt thi và thời hạn. Chi tiết ở evidence/manual-web-checks.json và ảnh thực tế.

Chưa xác minh: Android/thiết bị, gián đoạn mạng trên thiết bị, phục hồi ứng dụng sau khi hệ điều hành đóng, và timer liên tục 75 phút.

Parser trả lỗi đầu tiên thay vì gom mọi lỗi. Ảnh bài đọc giữ PDF gốc; văn bản trích có thể có lỗi khoảng trắng. Đáp án proposed không gọi là đáp án chính thức ETS.
'''
(root/'docs/TESTING.md').write_text(testing,encoding='utf-8')
print(f'Updated {len(files)+1} delivery documents; {len(cases)} real integration cases.')
