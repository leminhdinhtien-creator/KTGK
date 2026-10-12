using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using Abp.Dependency;
using Abp.UI;

namespace MyCompany.MyProject.Toeic;

public class TaggedWordParser : ITransientDependency
{
    private static readonly XNamespace W="http://schemas.openxmlformats.org/wordprocessingml/2006/main";
    private static readonly XNamespace R="http://schemas.openxmlformats.org/officeDocument/2006/relationships";
    private static readonly XNamespace A="http://schemas.openxmlformats.org/drawingml/2006/main";
    private static XDocument Xml(Stream s) => XDocument.Load(XmlReader.Create(s,new XmlReaderSettings{DtdProcessing=DtdProcessing.Prohibit,MaxCharactersInDocument=12_000_000}));
    public ReadingExam Parse(byte[] bytes)
    {
        try { return Read(bytes); }
        catch(UserFriendlyException) { throw; }
        catch(Exception e) when(e is InvalidDataException || e is XmlException || e is FormatException || e is ArgumentException || e is OverflowException)
        { throw new UserFriendlyException("DOCX hoặc Tags không hợp lệ. Kiểm tra cấu trúc và đóng thẻ."); }
    }
    private ReadingExam Read(byte[] bytes)
    {
        if(bytes.Length==0 || bytes.Length>25_000_000) Fail("File rỗng hoặc vượt 25 MB.");
        using var zip=new ZipArchive(new MemoryStream(bytes),ZipArchiveMode.Read);
        if(zip.Entries.Sum(e=>e.Length)>80_000_000) Fail("DOCX giải nén vượt 80 MB.");
        var main=zip.GetEntry("word/document.xml");
        if(main==null || zip.GetEntry("[Content_Types].xml")==null) Fail("Không phải DOCX hợp lệ.");
        using var stream=main.Open(); var document=Xml(stream);
        var relationships=new Dictionary<string,string>();
        var rel=zip.GetEntry("word/_rels/document.xml.rels");
        if(rel!=null) { using var rs=rel.Open(); foreach(var e in Xml(rs).Root.Elements()) if((string)e.Attribute("TargetMode")!="External") relationships[(string)e.Attribute("Id")]=(string)e.Attribute("Target"); }
        var images=new Dictionary<string,byte[]>(); var tags=new StringBuilder();
        foreach(var p in document.Descendants(W+"p"))
        {
            var text=string.Concat(p.Descendants().Where(t=>t.Name==W+"t" || t.Name==W+"br" || t.Name==W+"tab").Select(t=>t.Name==W+"t"?t.Value:t.Name==W+"br"?"\n":"\t"));
            foreach(var blip in p.Descendants(A+"blip"))
            {
                var id=(string)blip.Attribute(R+"embed");
                string target=null;
                if(id==null || !relationships.TryGetValue(id,out target)) Fail("Ảnh tham chiếu không tồn tại.");
                var path="word/"+target.TrimStart('/');
                if(target.StartsWith("/word/")) path=target.TrimStart('/');
                var entry=zip.GetEntry(path); if(entry==null) Fail("Ảnh tham chiếu không tồn tại: "+id);
                using var image=entry.Open(); using var ms=new MemoryStream(); image.CopyTo(ms); images[id]=ms.ToArray();
                if(text.Contains("<image")) text=text.Replace("embedded",id);
            }
            if(!string.IsNullOrWhiteSpace(text)) tags.AppendLine(text);
        }
        using var source=new MemoryStream(Encoding.UTF8.GetBytes(tags.ToString()));
        var root=Xml(source).Root;
        Require(root,"exam",new[]{"name","minutes","total","answerStatus"},new[]{"part"});
        if((int?)root.Attribute("minutes")!=75 || (int?)root.Attribute("total")!=100) Fail("Đề phải có 100 câu, 75 phút.");
        var exam=new ReadingExam{Name=Attr(root,"name"),AnswerStatus=Attr(root,"answerStatus"),SourceHash=Convert.ToHexString(SHA256.HashData(bytes))};
        if(exam.Name.Length>200 || !new[]{"proposed","verified"}.Contains(exam.AnswerStatus)) Fail("Tên đề hoặc trạng thái đáp án sai.");
        foreach(var p in root.Elements())
        {
            Require(p,"part",new[]{"number"},new[]{"group","question"});
            var part=new ReadingPart{Number=int.Parse(Attr(p,"number")),Exam=exam}; exam.Parts.Add(part);
            foreach(var node in p.Elements())
            {
                if(node.Name=="question") { if(part.Number!=5) Fail("Part 6/7 cần nhóm bài đọc."); part.Questions.Add(Question(node,part,null)); continue; }
                Require(node,"group",new[]{"id"},new[]{"document","question"});
                if(part.Number==5) Fail("Part 5 không có nhóm.");
                var group=new ReadingGroup{Key=Attr(node,"id"),Part=part}; part.Groups.Add(group);
                foreach(var d in node.Elements("document"))
                {
                    Require(d,"document",new[]{"order"},new[]{"text","image"});
                    var content=Single(d,"text"); Require(content,"text",Array.Empty<string>(),new[]{"blank"});
                    foreach(var blank in content.Elements()) { Require(blank,"blank",new[]{"number"},Array.Empty<string>()); if(blank.Value.Length>0) Fail("blank phải rỗng."); }
                    var text=string.Concat(content.Nodes().Select(n=>n is XElement e ? "{{"+Attr(e,"number")+"}}" : ((XText)n).Value));
                    var doc=new ReadingDocument{Order=int.Parse(Attr(d,"order")),Text=text,Group=group};
                    if(d.Elements("image").Count()>1) Fail("Một document chỉ có một image.");
                    var img=d.Element("image");
                    if(img!=null) { Require(img,"image",new[]{"ref"},Array.Empty<string>()); var key=Attr(img,"ref"); if(!images.TryGetValue(key,out var data)) Fail("Thiếu ảnh: "+key); ValidateImage(data); doc.Image=data; doc.ImageMime=data[0]==137?"image/png":"image/jpeg"; }
                    if(string.IsNullOrWhiteSpace(text)) Fail("Thiếu nội dung bài đọc nhóm "+group.Key);
                    group.Documents.Add(doc);
                }
                foreach(var q in node.Elements("question")) part.Questions.Add(Question(q,part,group));
                if(group.Documents.Count==0 || group.Documents.Count>3 || !part.Questions.Any(q=>q.Group==group)) Fail("Nhóm cần 1–3 tài liệu và câu hỏi: "+group.Key);
                if(group.Documents.Select(d=>d.Order).Distinct().Count()!=group.Documents.Count) Fail("Trùng thứ tự tài liệu: "+group.Key);
                if(part.Number==6) foreach(var q in part.Questions.Where(q=>q.Group==group)) if(group.Documents.Sum(d=>Count(d.Text,"{{"+q.Number+"}}"))!=1) Fail("Chỗ trống phải xuất hiện đúng một lần: "+q.Number);
                var expected=part.Questions.Where(q=>q.Group==group).Select(q=>q.Number).OrderBy(n=>n).ToArray();
                var blanks=node.Elements("document").SelectMany(d=>d.Element("text").Elements("blank")).Select(b=>int.Parse(Attr(b,"number"))).OrderBy(n=>n).ToArray();
                if(part.Number==6 && !blanks.SequenceEqual(expected)) Fail("Các blank không khớp câu hỏi nhóm "+group.Key);
                if(part.Number==7 && blanks.Length>0) Fail("Part 7 không có blank.");
            }
            if(part.Groups.Select(g=>g.Key).Distinct().Count()!=part.Groups.Count || part.Groups.Any(g=>g.Key.Length>80)) Fail("Mã nhóm trùng hoặc quá dài.");
        }
        if(!exam.Parts.Select(p=>p.Number).SequenceEqual(new[]{5,6,7})) Fail("Cần Part 5,6,7 theo đúng thứ tự.");
        foreach(var p in exam.Parts)
        {
            var first=p.Number==5?101:p.Number==6?131:147; var count=p.Number==5?30:p.Number==6?16:54;
            if(!p.Questions.Select(q=>q.Number).SequenceEqual(Enumerable.Range(first,count))) Fail("Part "+p.Number+": sai thứ tự, thiếu hoặc trùng số câu.");
        }
        if(exam.AnswerStatus=="verified" && exam.Parts.SelectMany(p=>p.Questions).Any(q=>q.AnswerStatus!="verified")) Fail("Đề verified còn câu chưa xác minh.");
        return exam;
    }
    private ReadingQuestion Question(XElement e,ReadingPart p,ReadingGroup g)
    {
        Require(e,"question",new[]{"number","answer","status"},new[]{"stem","option"});
        var n=int.Parse(Attr(e,"number")); var answer=Attr(e,"answer"); var status=Attr(e,"status");
        if(!new[]{"A","B","C","D"}.Contains(answer) || !new[]{"proposed","verified"}.Contains(status)) Fail("Đáp án hoặc trạng thái sai câu "+n);
        var stem=Single(e,"stem"); Require(stem,"stem",Array.Empty<string>(),Array.Empty<string>());
        if(string.IsNullOrWhiteSpace(stem.Value)) Fail("Thiếu stem câu "+n);
        if(p.Number==6 && stem.Value.Trim()!=n.ToString()) Fail("Part 6: nội dung câu hỏi phải chỉ là số câu "+n);
        var q=new ReadingQuestion{Number=n,Text=stem.Value,CorrectAnswer=answer,AnswerStatus=status,Part=p,Exam=p.Exam,Group=g};
        foreach(var c in e.Elements("option")) { Require(c,"option",new[]{"letter"},Array.Empty<string>()); if(string.IsNullOrWhiteSpace(c.Value)) Fail("Lựa chọn rỗng câu "+n); q.Choices.Add(new ReadingChoice{Letter=Attr(c,"letter"),Text=c.Value,Question=q}); }
        if(!q.Choices.Select(c=>c.Letter).SequenceEqual(new[]{"A","B","C","D"})) Fail("Câu "+n+": cần đúng 4 lựa chọn A/B/C/D.");
        return q;
    }
    public static void ValidateImage(byte[] bytes)
    {
        if(bytes==null || bytes.Length<8 || bytes.Length>8_000_000 || !(bytes.Take(8).SequenceEqual(new byte[]{137,80,78,71,13,10,26,10}) || (bytes[0]==255 && bytes[1]==216 && bytes[2]==255))) Fail("Ảnh phải là PNG/JPEG, tối đa 8 MB.");
    }
    private static int Count(string text,string token) => (text.Length-text.Replace(token,"").Length)/token.Length;
    private static XElement Single(XElement e,string name) { if(e.Elements(name).Count()!=1) Fail("Cần đúng một thẻ "+name); return e.Element(name); }
    private static string Attr(XElement e,string n) { var v=(string)e.Attribute(n); if(string.IsNullOrWhiteSpace(v)) Fail("Thiếu thuộc tính "+n+" trong "+e.Name); return v; }
    private static void Require(XElement e,string name,string[] attrs,string[] children)
    {
        if(e==null || e.Name!=name || e.Attributes().Any(a=>!attrs.Contains(a.Name.ToString())) || e.Elements().Any(c=>!children.Contains(c.Name.ToString()))) Fail("Sai cấu trúc thẻ "+name);
        foreach(var a in attrs) Attr(e,a);
        if(name!="text" && children.Length>0 && e.Nodes().OfType<XText>().Any(t=>!string.IsNullOrWhiteSpace(t.Value))) Fail("Văn bản phải nằm trong thẻ nội dung: "+name);
    }
    private static void Fail(string text) => throw new UserFriendlyException(text);
}
