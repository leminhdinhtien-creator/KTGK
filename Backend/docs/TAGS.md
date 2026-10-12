# Quy chuẩn Tags phiên bản 1

DOCX là gói ZIP Word hợp lệ, tối đa 25 MB; nội dung sau giải nén tối đa 80 MB. Nội dung Tags là XML duy nhất đặt trong các đoạn văn Word. Không thêm tiêu đề tự do ngoài `<exam>`. Dùng XML escaping: `&amp;`, `&lt;`, `&gt;` khi nội dung có ký tự đặc biệt.

```xml
<exam name="ETS TOEIC Reading Test 10" minutes="75" total="100" answerStatus="proposed">
<part number="5">
<question number="101" answer="B" status="proposed">
<stem>Please contact the product distributor, not the retail store, if ------- need replacement parts.</stem>
<option letter="A">your</option>
<option letter="B">you</option>
<option letter="C">yourself</option>
<option letter="D">yours</option>
</question>
<!-- Các câu 102–130 theo đúng cấu trúc trên -->
</part>
<part number="6">
<group id="g131-134">
<document order="1">
<text>To: All Employees. Please be advised it is time for the IT department to <blank number="131"/> mandatory server maintenance and updates. <!-- Các blank 132–134 phải xuất hiện đúng một lần trong bài đọc đầy đủ. --></text>
<image ref="embedded"/>
</document>
<!-- Các câu 131–134, mỗi câu có stem là số câu, 4 option và answer. -->
</group>
<!-- Các nhóm 135–138, 139–142, 143–146 -->
</part>
<part number="7">
<!-- Nhóm câu 147–200, 1–3 document mỗi nhóm -->
</part>
</exam>
```

Ví dụ trên minh họa cú pháp, chưa đủ 100 câu nên không import được. Ví dụ hoàn chỉnh hợp lệ là `TOEIC-Reading-Test10-Tagged.docx`. Thẻ image và ảnh PNG/JPEG phải nằm trong cùng một đoạn văn Word; ref="embedded" được parser chuyển thành relationship ID ảnh trong đoạn đó. Một document tối đa một ảnh; có thể bỏ image nếu chỉ dùng text. Ảnh được lưu dạng binary trong SQL cùng transaction, không phát sinh tệp ngoài database.

Part 5: question nằm trực tiếp trong part, số 101–130. Part 6: question nằm trong group có document, số 131–146; stem chỉ được chứa đúng số của câu hỏi (ví dụ `<stem>131</stem>`); từng câu phải có đúng một blank cùng số trong text của nhóm. Part 7: số 147–200, question nằm trong group có 1–3 document. Các số phải liên tục và đúng thứ tự. group id không trùng trong part; document order không trùng trong nhóm. option phải đúng A/B/C/D theo thứ tự, không rỗng. answer chỉ thuộc A/B/C/D. status và answerStatus chỉ nhận proposed hoặc verified. Đề verified không được còn câu proposed.

Ví dụ không hợp lệ: thiếu `</group>`, hai câu có cùng number, option letter="E", answer="X", thiếu text, image không có ảnh đính kèm, blank 131 lặp lại hoặc thuộc nhóm khác, tổng 99 câu. Parser từ chối trước khi ghi; lỗi ghi SQL được rollback toàn bộ qua ABP Unit of Work. Thông báo hiện xác định lỗi đầu tiên để sửa rồi kiểm tra lại.
