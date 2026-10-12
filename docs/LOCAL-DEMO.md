# Một link Admin và User

Mở **http://localhost:5100/**. Nút User mở Flutter; nút Admin mở giao diện quản lý đề. Hai màn được giữ khi chuyển vai trò nên việc chuyển nút không tải lại lượt thi. Người dùng không cần tài khoản.

Admin được vào trực tiếp khi chạy Development trên máy local và `ReadingDemo:AllowAnonymousAdmin=true`. API quản lý đề vẫn yêu cầu quyền ReadingAdmin khi truy cập từ địa chỉ khác localhost hoặc ngoài Development. Token chống CSRF vẫn áp dụng cho import/chỉnh sửa. Các trang quản trị ABP khác giữ đăng nhập như template.

Build Flutter trước khi chạy Backend:

```powershell
cd Frontend
flutter build web --base-href /app/ --dart-define=API_URL=http://localhost:5100
cd ..
powershell -ExecutionPolicy Bypass -File tools/Start-Backend.ps1
```

Backend phục vụ bản Flutter ở `/app/` từ `Frontend/build/web`. Không cần server web ở port 5200 cho bản demo chung. Android vẫn dùng API_URL phù hợp với máy/emulator.

Ảnh bài đọc được giải mã một lần và giữ byte ảnh qua mỗi lần đồng hồ cập nhật hoặc API trả JSON mới. Kiểm thử hồi quy xác minh ảnh không đổi provider và vị trí cuộn không bị reset qua nhiều tick.

Kiểm tra ngày 12/10/2026: trang chung/Flutter và Admin local trả HTTP 200; xem trước DOCX không cần đăng nhập đạt; thiếu CSRF trả 400; Admin truy cập qua IP LAN khi chưa đăng nhập trả 401. Flutter analyze không có vấn đề; 2 widget tests đạt.

Đề đã có lượt thi vẫn khóa chỉnh sửa để giữ kết quả cũ. Import cùng Word vẫn báo trùng. Dùng bản đề thử mới cho đoạn quay biên tập.
