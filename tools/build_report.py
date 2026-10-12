from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
from docx import Document
from docx.shared import Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.text.paragraph import Paragraph
import hashlib,json,zipfile
root=Path(__file__).resolve().parents[1]
out=root/'docs';ev=out/'evidence';ev.mkdir(exist_ok=True)
im=Image.new('RGB',(1700,1220),'#f7f9fc');d=ImageDraw.Draw(im)
f=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',32);bold=ImageFont.truetype('C:/Windows/Fonts/arialbd.ttf',34);title=ImageFont.truetype('C:/Windows/Fonts/arialbd.ttf',44)
d.text((50,35),'TOEIC Reading relational database',font=title,fill='#18374c')
boxes=[('ReadingExams',(50,130),['PK Id','Name, DurationMinutes = 75','TotalQuestions = 100','SourceHash UNIQUE','AnswerStatus']),('ReadingParts',(610,130),['PK Id, FK ExamId','Number (5 / 6 / 7)','UNIQUE (ExamId, Number)','AK (Id, ExamId)']),('ReadingGroups',(1170,130),['PK Id, FK PartId','Key','UNIQUE (PartId, Key)','AK (Id, PartId)']),('ReadingQuestions',(50,500),['PK Id, FK ExamId','FK (PartId, ExamId)','FK (GroupId, PartId) nullable','Number, Text, CorrectAnswer','UNIQUE (ExamId, Number)']),('ReadingChoices',(610,500),['PK Id, FK QuestionId','Letter (A / B / C / D), Text','UNIQUE (QuestionId, Letter)']),('ReadingDocuments',(1170,500),['PK Id, FK GroupId','Order, Text, TextWasEdited','Image VARBINARY','ImageMime','UNIQUE (GroupId, Order)']),('ReadingAttempts',(50,870),['PK Id GUID, FK ExamId','UserId -> AbpUsers (nullable)','GuestKeyHash SHA256 (64)','StartedAt, Deadline, Status','SubmittedAt','Correct, Wrong, Skipped']),('ReadingAnswers',(610,870),['PK Id, FK AttemptId','FK QuestionId, Letter','UQ (AttemptId, QuestionId)'])]
for start,end in [((540,210),(610,210)),((1100,210),(1170,210)),((1415,390),(1415,500)),((295,390),(295,500)),((855,390),(295,500)),((1170,390),(540,500)),((540,610),(610,610)),((25,250),(25,1000)),((25,250),(50,250)),((25,1000),(50,1000)),((295,780),(295,825)),((295,825),(855,825)),((855,825),(855,870)),((540,980),(610,980))]:
    d.line([start,end],fill='#7894a9',width=4);d.ellipse((end[0]-5,end[1]-5,end[0]+5,end[1]+5),fill='#087f78')
for name,(x,y),lines in boxes:
    d.rounded_rectangle((x,y,x+490,y+(300 if name=='ReadingAttempts' else 270)),radius=15,fill='white',outline='#d0dce6',width=2)
    d.rounded_rectangle((x,y,x+490,y+54),radius=15,fill='#173b53');d.rectangle((x,y+28,x+490,y+54),fill='#173b53')
    d.text((x+18,y+12),name,font=bold,fill='white')
    for i,s in enumerate(lines):d.text((x+18,y+78+i*33),s,font=f,fill='#20384a')
im.save(out/'ERD.png')
ref=Path(r'C:\Users\lemin\Downloads\BaoCao-LeMinhDinhTien-2380602224.docx')
doc=Document(ref)
sec=doc.sections[0]
(root/'tmp/inspection/artifact.md').write_text(f'# Report template contract\nReference: {ref}\nSHA256: {hashlib.sha256(ref.read_bytes()).hexdigest()}\nOne section, one rendered reference page. Preserve student name, ID, class, numbered seven headings, grading table, original styles and numbering.\nPage: {sec.page_width/914400:.3f} × {sec.page_height/914400:.3f} inches. Margins: {[round(x/914400,3) for x in (sec.top_margin,sec.bottom_margin,sec.left_margin,sec.right_margin)]}.\nEditable slots: blank paragraphs after each numbered heading; insert actual ERD and Figma images and short descriptions. Leave unchecked all grading items awaiting integration or answer confirmation.\n',encoding='utf-8')
def after(p,text=None,image=None,width=6):
    new=doc.add_paragraph();p._p.addnext(new._p)
    if text:new.add_run(text)
    if image:
        new.add_run().add_picture(str(image),width=Inches(width))
        new.alignment=WD_ALIGN_PARAGRAPH.CENTER
    return new
texts={
'Sơ đồ database':'Backend ASP.NET Boilerplate MVC / .NET 9 sử dụng SQL Server localhost, database ToeicReadingDB, Windows Authentication. EF migrations đã chạy; 45 bảng gồm 8 bảng Reading và các bảng ABP. Đã kiểm thử đọc/ghi, import và khóa ngoại trên SQL thật. Phiên khách lưu GuestKeyHash; UserId nullable giữ tương thích dữ liệu cũ. Không yêu cầu tài khoản người thi.',
'Hình ảnh giao diện thiết kế trên Figma / Google Stitch':'Figma Make AI đã tạo 16 màn hình Mobile và Admin, không có Mobile login. Flutter dùng màu xanh ngọc, nền giấy và font DM Sans / Playfair Display từ Make. Link chính: https://www.figma.com/make/tEmZRZ6BuPKQhvfr7VauZT/Design-Reading-Studio-UI . Bản Design có lớp chỉnh sửa tại https://www.figma.com/design/MZOmJvNP8mdpeJoOQqowWC ; trang bàn giao mới còn cần sửa chiều cao chữ và QA do gói Starter hết hạn mức MCP. Hình dưới là thiết kế Make, không phải minh chứng chạy SQL.',
'Giao diện Admin: Import đề thi':'Admin upload DOCX, xem trước trước khi ghi SQL, đọc Tags và kiểm tra toàn bộ cấu trúc. Import thật đạt: 1 đề, 3 phần, 19 nhóm, 27 tài liệu, 100 câu, 400 lựa chọn. File lỗi bị từ chối, số bản ghi không đổi; file trùng bị từ chối. Kết quả 22 ca HTTP/SQL được lưu trong docs/evidence/sql-api-integration.json. Hình dưới là màn hình xem trước Word hợp lệ trên Admin đang chạy.',
'Giao diện Admin: Chỉnh sửa nội dung đề thi sau khi import':'Admin sửa câu hỏi, phương án, đáp án, trạng thái xác minh, văn bản và ảnh bài đọc. Kiểm thử đã lưu rồi đọc lại câu hỏi/tài liệu trên SQL thật. Đã thao tác lưu câu 101 trên giao diện. Đề có lượt thi được khóa sửa để bảo toàn kết quả; văn bản đã sửa được ưu tiên khi hiển thị. Admin giữ authentication và quyền Pages.ReadingAdmin.',
'Giao diện Users: Chọn lựa đề thi':'Flutter vào trực tiếp thư viện, lấy danh sách qua API thật, không có đăng nhập/đăng ký. Chọn đề mở chi tiết 75 phút, 100 câu và cấu trúc 30/16/54. Mã phiên ngẫu nhiên lưu trong secure storage; server chỉ lưu hash và kiểm tra sở hữu lượt thi. Hình dưới là Flutter web kết nối Backend/SQL thật, kiểm tra ở kích thước 390 × 844; chưa phải kiểm thử Android.',
'Giao diện Users: Làm bài thi':'Đã thao tác Part 5, Part 6, Part 7 một/hai/ba tài liệu trên Flutter web; ảnh bài đọc giữ bố cục PDF và có zoom. Chọn/đổi/hủy, điều hướng 100 câu, lưu trạng thái, đồng hồ và cảnh báo nộp được lập trình. API/SQL kiểm thử lưu/khôi phục, khóa sau nộp, nộp trùng và server/worker hết hạn đạt. Ca hết hạn dùng fixture rút ngắn riêng, không đổi đề 75 phút. Chưa kiểm thử Android, gián đoạn mạng trên thiết bị hoặc một lượt liên tục đủ 75 phút.',
'Giao diện Users: Hiển thị kết quả bài thi':'Chấm đúng/sai/bỏ qua; tổng luôn bằng 100. HTTP/SQL thật đã kiểm tra bài trống 0/0/100, bài một phần 1/1/98 và bài đủ 100/0/0 theo bộ đáp án đề xuất. Nộp đồng thời cho một kết quả nhất quán, không sửa sau khi nộp. Hình dưới là kết quả lượt thao tác thực trên Flutter web. Đáp án chưa xác minh ETS; không quy đổi điểm TOEIC chính thức.'}
for p in list(doc.paragraphs):
    key=p.text.strip()
    if key not in texts:continue
    p.paragraph_format.keep_with_next=True
    if key!='Sơ đồ database':p.paragraph_format.page_break_before=True
    nextp=after(p,texts[key])
    if key=='Sơ đồ database':after(nextp,image=out/'ERD.png',width=6)
    pictures={
      'Hình ảnh giao diện thiết kế trên Figma / Google Stitch':('figma-make-library.png',5.8),
      'Giao diện Admin: Import đề thi':('admin-word-preview.png',6),
      'Giao diện Admin: Chỉnh sửa nội dung đề thi sau khi import':('admin-edit.png',6),
      'Giao diện Users: Chọn lựa đề thi':('flutter-library.png',3),
      'Giao diện Users: Làm bài thi':('flutter-part5.png',3),
      'Giao diện Users: Hiển thị kết quả bài thi':('flutter-result.png',3),
    }
    if key in pictures:
        name,width=pictures[key]
        if (ev/name).exists():after(nextp,image=ev/name,width=width)
for p in doc.paragraphs:
    if p.text.strip()=='Đánh giá:':
        p.paragraph_format.page_break_before=True
        p.paragraph_format.keep_with_next=True
for t in doc.tables:
    for r in t.rows[1:]:r.cells[-1].text=''
doc.save(out/'BaoCao-LeMinhDinhTien-2380602224.docx')
print('Report retained seven sections and original assessment table; integration items remain unchecked.')



