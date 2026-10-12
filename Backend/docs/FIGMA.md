# Thiết kế Reading Studio

**Bản hiện tại: V2 “Upgrade Reading Studio Design”, tạo trong Figma Make ngày 12/10/2026, tải mã bằng Download code và triển khai lại trên ứng dụng.** Xem [bàn giao V2](FIGMA-V2-HANDOFF.md). V1 được giữ để đối chiếu.

[Figma Make AI — 16 màn hình](https://www.figma.com/make/tEmZRZ6BuPKQhvfr7VauZT/Design-Reading-Studio-UI)

Đã tạo bằng Make AI trong tài khoản người dùng: thư viện, chi tiết, Part 5, Part 6, Part 7 một/hai/ba tài liệu, điều hướng 100 câu, cảnh báo 5 phút, xác nhận nộp, hết giờ, mất mạng, kết quả và 3 trang Admin. Không có Mobile login.

Màu và font từ Make: paper #F6F7F4, ink #142D32, emerald #087F69, sage #E7F0E8, gold #D7B56D; DM Sans và Playfair Display. Flutter sử dụng các token này và font đóng gói kèm license OFL. Dữ liệu Flutter lấy từ Backend/SQL; số liệu mẫu trong Make chỉ minh họa thiết kế.

Mã xuất trực tiếp bằng Download code được lưu ở Frontend/design/figma-make/src. Không dùng prototype React thay cho Flutter hoặc Backend.

[Figma Design — bản bàn giao có lớp chỉnh sửa](https://www.figma.com/design/MZOmJvNP8mdpeJoOQqowWC?node-id=28-74)

File giữ trang thiết kế cũ và thêm trang Reading Studio · Make handoff với 16 frame, text và nút instance. **Bản Design mới chưa đạt kiểm tra bố cục cuối cùng:** chiều cao chữ/container cần sửa và rà soát; Figma Starter đã hết hạn mức MCP khi kiểm tra. Không coi bản này là bản hoàn thiện để nộp. Bản Make phía trên là bản thiết kế chính hiện đã xem được. Thao tác Copy designs của Make không trả nội dung clipboard trong phiên này; mã xuất đã lấy thành công, việc chuyển native được thực hiện riêng.

Backend/tools/figma-make-editable.js ghi lại thao tác tạo; bản script local đã bổ sung text sizing, nhưng chưa áp dụng/QA lại do quota. Cần kiểm tra nội dung mẫu và tránh tạo trùng trang khi tiếp tục. Chưa tạo prototype native tương tác. Hình figma-make-library.png là ảnh Make thực tế, không phải bằng chứng ứng dụng đã chạy SQL.
