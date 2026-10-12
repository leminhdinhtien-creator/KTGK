# SQL Server local

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
