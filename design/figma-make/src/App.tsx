import { useEffect, useMemo, useState, type ReactNode } from "react"
import {
  AlertCircle,
  ArrowLeft,
  ArrowRight,
  BookOpen,
  Check,
  CheckCircle2,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  CircleHelp,
  Clock3,
  CloudOff,
  Coffee,
  CopyCheck,
  Ellipsis,
  Expand,
  FileCheck2,
  FileText,
  Flag,
  LayoutGrid,
  Menu,
  MoreHorizontal,
  PackageCheck,
  PanelTop,
  PencilLine,
  RotateCcw,
  Search,
  Send,
  ShieldCheck,
  Timer,
  UploadCloud,
  X,
  XCircle,
} from "lucide-react"

type ScreenId = "library" | "details" | "part5" | "part6" | "part7single" | "part7double" | "part7triple" | "navigator" | "warning" | "submit" | "expired" | "results" | "offline" | "adminUpload" | "adminPreview" | "adminEditor"

type Option = { key: string text: string }

const screens: { id: ScreenId label: string group: string }[] = [
  { id: "library", label: "Thư viện đề", group: "Khám phá" },
  { id: "details", label: "Chi tiết đề", group: "Khám phá" },
  { id: "part5", label: "Part 5 · Q101", group: "Làm bài" },
  { id: "part6", label: "Part 6 · Q131", group: "Làm bài" },
  { id: "part7single", label: "Part 7 · 1 tài liệu", group: "Làm bài" },
  { id: "part7double", label: "Part 7 · 2 tài liệu", group: "Làm bài" },
  { id: "part7triple", label: "Part 7 · 3 tài liệu", group: "Làm bài" },
  { id: "navigator", label: "Điều hướng 101–200", group: "Trạng thái" },
  { id: "warning", label: "Cảnh báo 5 phút", group: "Trạng thái" },
  { id: "submit", label: "Xác nhận nộp bài", group: "Trạng thái" },
  { id: "expired", label: "Hết giờ · đã khóa", group: "Trạng thái" },
  { id: "offline", label: "Mất kết nối", group: "Trạng thái" },
  { id: "results", label: "Kết quả", group: "Trạng thái" },
  { id: "adminUpload", label: "Admin · Tải Word", group: "Quản trị" },
  { id: "adminPreview", label: "Admin · Xem trước", group: "Quản trị" },
  { id: "adminEditor", label: "Admin · Biên tập", group: "Quản trị" },
]

const part5Options: Option[] = [
  { key: "A", text: "your" },
  { key: "B", text: "you" },
  { key: "C", text: "yourself" },
  { key: "D", text: "yours" },
]

const receiptOptions: Option[] = [
  { key: "A", text: "A caterer" },
  { key: "B", text: "A vegetable market" },
  { key: "C", text: "A cafe" },
  { key: "D", text: "An online retailer" },
]

function Action({
  children,
  onClick,
  variant = "primary",
  icon,
  className = "",
  disabled = false,
}: {
  children: ReactNode
  onClick?: () => void
  variant?: "primary" | "secondary" | "ghost" | "danger"
  icon?: ReactNode
  className?: string
  disabled?: boolean
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className={`action action-${variant} ${className}`}
    >
      {icon}
      <span>{children}</span>
    </button>
  )
}

function IconAction({
  label,
  children,
  onClick,
}: {
  label: string
  children: ReactNode
  onClick?: () => void
}) {
  return (
    <button
      type="button"
      className="icon-action"
      aria-label={label}
      onClick={onClick}
    >
      {children}
    </button>
  )
}

function Brand({ compact = false }: { compact?: boolean }) {
  return (
    <div className="brand">
      <div className="brand-mark">
        <BookOpen size={compact ? 17 : 20} strokeWidth={2.3} />
      </div>
      <div>
        <div className="brand-name">Reading Studio</div>
        {!compact && <div className="brand-kicker">TOEIC Reading Practice</div>}
      </div>
    </div>
  )
}

function PrototypeMenu({
  current,
  onChange,
}: {
  current: ScreenId
  onChange: (id: ScreenId) => void
}) {
  const [open, setOpen] = useState(false)
  const active = screens.find((screen) => screen.id === current)!
  const groups = [...new Set(screens.map((screen) => screen.group))]

  return (
    <>
      <button
        type="button"
        className="prototype-trigger"
        onClick={() => setOpen(true)}
      >
        <Menu size={16} />
        <span>{active.label}</span>
        <ChevronDown size={15} />
      </button>
      {open && (
        <div className="sheet-backdrop" onMouseDown={() => setOpen(false)}>
          <div
            className="prototype-sheet"
            onMouseDown={(event) => event.stopPropagation()}
          >
            <div className="sheet-grabber" />
            <div className="sheet-heading">
              <div>
                <div className="eyebrow">Prototype navigator</div>
                <div className="sheet-title">Chuyển màn hình</div>
              </div>
              <IconAction label="Đóng" onClick={() => setOpen(false)}>
                <X size={20} />
              </IconAction>
            </div>
            <div className="menu-scroll">
              {groups.map((group) => (
                <div className="menu-group" key={group}>
                  <div className="menu-group-label">{group}</div>
                  <div className="menu-grid">
                    {screens
                      .filter((screen) => screen.group === group)
                      .map((screen) => (
                        <button
                          type="button"
                          key={screen.id}
                          className={`menu-item ${
                            screen.id === current ? "active" : ""
                          }`}
                          onClick={() => {
                            onChange(screen.id)
                            setOpen(false)
                          }}
                        >
                          <span>{screen.label}</span>
                          {screen.id === current && <Check size={16} />}
                        </button>
                      ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </>
  )
}

function MobileFrame({
  children,
  full = false,
}: {
  children: ReactNode
  full?: boolean
}) {
  return (
    <main className={`mobile-frame ${full ? "full-height" : ""}`}>
      {children}
    </main>
  )
}

function AppHeader({ title, back }: { title?: string back?: () => void }) {
  return (
    <header className="app-header">
      {back ? (
        <IconAction label="Quay lại" onClick={back}>
          <ChevronLeft size={22} />
        </IconAction>
      ) : (
        <Brand compact />
      )}
      {title && <div className="header-title">{title}</div>}
      <IconAction label="Thêm tùy chọn">
        <Ellipsis size={22} />
      </IconAction>
    </header>
  )
}

function SectionLabel({ children }: { children: ReactNode }) {
  return <div className="section-label">{children}</div>
}

function Stat({ value, label }: { value: string label: string }) {
  return (
    <div className="stat">
      <div className="stat-value">{value}</div>
      <div className="stat-label">{label}</div>
    </div>
  )
}

function Library({ go }: { go: (id: ScreenId) => void }) {
  return (
    <MobileFrame>
      <div className="library-hero">
        <AppHeader />
        <div className="hero-copy">
          <div className="eyebrow gold">Phòng đọc cá nhân</div>
          <div className="display-title">
            Luyện tập tập trung.
            <br />
            Tiến bộ có chủ đích.
          </div>
          <div className="hero-description">
            Bộ đề Reading được trình bày như một trải nghiệm thi thật — rõ ràng,
            tĩnh lặng và không xao nhãng.
          </div>
        </div>
        <div className="search-shell">
          <Search size={18} />
          <span>Tìm kiếm bộ đề</span>
          <div className="key-hint">⌘ K</div>
        </div>
      </div>
      <div className="content-pad library-content">
        <div className="section-row">
          <SectionLabel>Đề nổi bật</SectionLabel>
          <span className="muted-small">1 bộ đề</span>
        </div>
        <button
          type="button"
          className="featured-card"
          onClick={() => go("details")}
        >
          <div className="featured-top">
            <div className="official-seal">
              <ShieldCheck size={17} /> ETS FORMAT
            </div>
            <ArrowRight size={20} />
          </div>
          <div>
            <div className="card-kicker">Reading collection · No. 10</div>
            <div className="card-title">
              ETS TOEIC
              <br />
              Reading Test 10
            </div>
          </div>
          <div className="feature-stats">
            <Stat value="75'" label="Thời gian" />
            <Stat value="100" label="Câu hỏi" />
            <Stat value="3" label="Phần thi" />
          </div>
          <div className="card-action-row">
            <span>Sẵn sàng làm bài</span>
            <span className="round-arrow">
              <ArrowRight size={17} />
            </span>
          </div>
        </button>
        <div className="quiet-note">
          <BookOpen size={19} />
          <div>
            <strong>Một không gian đọc không gián đoạn</strong>
            <span>Tiến độ chỉ được lưu trên thiết bị trong prototype này.</span>
          </div>
        </div>
      </div>
    </MobileFrame>
  )
}

function Details({ go }: { go: (id: ScreenId) => void }) {
  return (
    <MobileFrame>
      <AppHeader title="Chi tiết bài thi" back={() => go("library")} />
      <div className="detail-cover">
        <div className="cover-orbit">
          <span>10</span>
        </div>
        <div className="eyebrow gold">ETS TOEIC · READING</div>
        <div className="detail-title">
          Reading
          <br />
          Test 10
        </div>
        <div className="detail-meta">
          <Clock3 size={16} /> 75 phút <span /> <FileText size={16} /> 100 câu
        </div>
      </div>
      <div className="content-pad">
        <SectionLabel>Cấu trúc bài thi</SectionLabel>
        <div className="structure-list">
          {[
            ["05", "Incomplete Sentences", "30 câu", "101–130"],
            ["06", "Text Completion", "16 câu", "131–146"],
            ["07", "Reading Comprehension", "54 câu", "147–200"],
          ].map((item) => (
            <div className="structure-row" key={item[0]}>
              <div className="part-number">{item[0]}</div>
              <div className="structure-copy">
                <strong>Part {item[0]}</strong>
                <span>{item[1]}</span>
              </div>
              <div className="structure-range">
                <strong>{item[2]}</strong>
                <span>{item[3]}</span>
              </div>
            </div>
          ))}
        </div>
        <div className="instruction-card">
          <CircleHelp size={20} />
          <div>
            <strong>Trước khi bắt đầu</strong>
            <span>
              Đồng hồ sẽ chạy liên tục. Bạn có thể đổi hoặc xóa đáp án trước khi
              nộp bài.
            </span>
          </div>
        </div>
        <Action
          className="wide"
          onClick={() => go("part5")}
          icon={<ArrowRight size={19} />}
        >
          Bắt đầu làm bài
        </Action>
        <div className="microcopy">
          Prototype giao diện · Không kết nối hệ thống thi
        </div>
      </div>
    </MobileFrame>
  )
}

function ExamTop({
  part,
  progress,
  go,
  seconds = "48:32",
  danger = false,
}: {
  part: string
  progress: string
  go: (id: ScreenId) => void
  seconds?: string
  danger?: boolean
}) {
  return (
    <>
      <div className="exam-top">
        <IconAction label="Thoát bài thi" onClick={() => go("details")}>
          <X size={21} />
        </IconAction>
        <div className="exam-part">
          <strong>{part}</strong>
          <span>{progress}</span>
        </div>
        <button
          type="button"
          className={`timer-pill ${danger ? "danger" : ""}`}
          onClick={() => go("warning")}
        >
          <Timer size={16} /> {seconds}
        </button>
      </div>
      <div className="progress-line">
        <span
          style={{ width: progress.split("/")[0] === "101" ? "2%" : "34%" }}
        />
      </div>
    </>
  )
}

function ChoiceList({
  options,
  selected,
  onSelect,
  proposed,
}: {
  options: Option[]
  selected: string | null
  onSelect: (key: string) => void
  proposed?: string
}) {
  return (
    <div className="choice-list">
      {options.map((option) => (
        <button
          type="button"
          key={option.key}
          className={`choice ${selected === option.key ? "selected" : ""} ${
            proposed === option.key ? "proposed" : ""
          }`}
          onClick={() => onSelect(option.key)}
        >
          <span className="choice-key">
            {selected === option.key ? <Check size={16} /> : option.key}
          </span>
          <span className="choice-text">{option.text}</span>
          {proposed === option.key && (
            <span className="proposed-label">Đề xuất</span>
          )}
        </button>
      ))}
    </div>
  )
}

function AnswerStatus({
  selected,
  onClear,
}: {
  selected: string | null
  onClear: () => void
}) {
  return selected ? (
    <div className="answer-state">
      <span>
        <CheckCircle2 size={17} /> Đã chọn {selected} · Chạm đáp án khác để đổi
      </span>
      <button type="button" onClick={onClear}>
        Xóa chọn
      </button>
    </div>
  ) : (
    <div className="answer-state empty">
      <span>
        <CircleHelp size={17} /> Chưa chọn đáp án
      </span>
    </div>
  )
}

function ExamFooter({
  go,
  next = "part6",
}: {
  go: (id: ScreenId) => void
  next?: ScreenId
}) {
  return (
    <div className="exam-footer">
      <IconAction label="Câu trước">
        <ArrowLeft size={21} />
      </IconAction>
      <Action
        variant="secondary"
        onClick={() => go("navigator")}
        icon={<LayoutGrid size={18} />}
      >
        Câu hỏi
      </Action>
      <Action onClick={() => go(next)} icon={<ArrowRight size={18} />}>
        Tiếp theo
      </Action>
    </div>
  )
}

function Part5({ go }: { go: (id: ScreenId) => void }) {
  const [selected, setSelected] = useState<string | null>(null)
  return (
    <MobileFrame full>
      <ExamTop part="Part 5" progress="101 / 200" go={go} />
      <div className="exam-scroll">
        <div className="question-heading">
          <div>
            <span>CÂU</span>
            <strong>101</strong>
          </div>
          <IconAction label="Đánh dấu câu hỏi">
            <Flag size={20} />
          </IconAction>
        </div>
        <div className="instruction">
          Chọn từ hoặc cụm từ phù hợp nhất để hoàn thành câu.
        </div>
        <div className="question-text">
          Please contact the product distributor, not the retail store, if{" "}
          <em>-------</em> need replacement parts.
        </div>
        <ChoiceList
          options={part5Options}
          selected={selected}
          onSelect={setSelected}
        />
        <AnswerStatus selected={selected} onClear={() => setSelected(null)} />
        <div className="answer-disclaimer">
          Đáp án đề xuất · chưa xác minh ETS
        </div>
      </div>
      <ExamFooter go={go} />
    </MobileFrame>
  )
}

function PassageToolbar({
  expanded,
  onExpand,
}: {
  expanded: boolean
  onExpand: () => void
}) {
  return (
    <div className="passage-toolbar">
      <span>
        <FileText size={16} /> Tài liệu đọc
      </span>
      <button type="button" onClick={onExpand}>
        {expanded ? (
          <>
            <X size={16} /> Thu gọn
          </>
        ) : (
          <>
            <Expand size={16} /> Mở rộng
          </>
        )}
      </button>
    </div>
  )
}

function Part6({ go }: { go: (id: ScreenId) => void }) {
  const [selected, setSelected] = useState<string | null>("B")
  const [expanded, setExpanded] = useState(false)
  return (
    <MobileFrame full>
      <ExamTop part="Part 6" progress="131 / 200" go={go} />
      <div
        className={`exam-scroll split-reading ${
          expanded ? "expanded-reading" : ""
        }`}
      >
        <PassageToolbar
          expanded={expanded}
          onExpand={() => setExpanded(!expanded)}
        />
        <article className="document letter">
          <div className="doc-date">May 14</div>
          <div className="doc-salutation">To all department managers,</div>
          <p>
            Please be advised it is time for the IT department to{" "}
            <mark>[131]</mark> mandatory server maintenance and updates.
          </p>
          <p>
            The work will begin this Friday at 8:00 P.M. Access to shared drives
            and internal applications may be temporarily unavailable.
          </p>
          <p>
            Please save all open files before leaving the office. Thank you for
            your cooperation.
          </p>
          <div className="doc-signoff">Information Technology Department</div>
        </article>
        {!expanded && (
          <div className="question-panel">
            <div className="compact-question-title">
              <span>131</span> Chọn đáp án phù hợp
            </div>
            <ChoiceList
              options={[
                { key: "A", text: "suggest" },
                { key: "B", text: "perform" },
                { key: "C", text: "cancel" },
                { key: "D", text: "revise" },
              ]}
              selected={selected}
              onSelect={setSelected}
            />
            <AnswerStatus
              selected={selected}
              onClear={() => setSelected(null)}
            />
            <div className="answer-disclaimer">
              Đáp án đề xuất · chưa xác minh ETS
            </div>
          </div>
        )}
      </div>
      <ExamFooter go={go} next="part7single" />
    </MobileFrame>
  )
}

function Receipt() {
  return (
    <article className="receipt">
      <Coffee size={26} />
      <div className="receipt-brand">SIOBHAN'S</div>
      <div className="receipt-location">TORONTO, ONTARIO</div>
      <div className="receipt-rule" />
      <div className="receipt-row">
        <span>Medium coffee</span>
        <span>$2.25</span>
      </div>
      <div className="receipt-row">
        <span>Large coffee</span>
        <span>$2.75</span>
      </div>
      <div className="receipt-row">
        <span>2 croissants</span>
        <span>$4.00</span>
      </div>
      <div className="receipt-rule" />
      <div className="receipt-row">
        <span>SUBTOTAL</span>
        <span>$9.00</span>
      </div>
      <div className="receipt-row">
        <span>HST</span>
        <span>$1.17</span>
      </div>
      <div className="receipt-row total">
        <span>TOTAL</span>
        <span>$10.17</span>
      </div>
      <div className="receipt-thanks">THANK YOU</div>
    </article>
  )
}

function Part7Single({ go }: { go: (id: ScreenId) => void }) {
  const [selected, setSelected] = useState<string | null>("C")
  const [expanded, setExpanded] = useState(false)
  return (
    <MobileFrame full>
      <ExamTop part="Part 7" progress="147 / 200" go={go} />
      <div
        className={`exam-scroll split-reading ${
          expanded ? "expanded-reading" : ""
        }`}
      >
        <PassageToolbar
          expanded={expanded}
          onExpand={() => setExpanded(!expanded)}
        />
        <Receipt />
        {!expanded && (
          <div className="question-panel">
            <div className="compact-question-title">
              <span>147</span> What type of business most likely provided the
              receipt?
            </div>
            <ChoiceList
              options={receiptOptions}
              selected={selected}
              onSelect={setSelected}
            />
            <AnswerStatus
              selected={selected}
              onClear={() => setSelected(null)}
            />
            <div className="answer-disclaimer">
              Đáp án đề xuất · chưa xác minh ETS
            </div>
          </div>
        )}
      </div>
      <ExamFooter go={go} next="part7double" />
    </MobileFrame>
  )
}

function FlightCard() {
  return (
    <article className="flight-card">
      <div className="flight-brand">
        <span className="quail-mark">Q</span>
        <strong>QUAIL AIRLINES</strong>
      </div>
      <div className="flight-label">FLIGHT CONFIRMATION</div>
      <div className="route">
        <div>
          <strong>YYZ</strong>
          <span>Toronto</span>
        </div>
        <div className="route-line">
          <span>QA 842</span>
        </div>
        <div>
          <strong>SFO</strong>
          <span>San Francisco</span>
        </div>
      </div>
      <div className="flight-grid">
        <div>
          <span>Date</span>
          <strong>18 JUN</strong>
        </div>
        <div>
          <span>Departure</span>
          <strong>09:40</strong>
        </div>
        <div>
          <span>Seat</span>
          <strong>14A</strong>
        </div>
      </div>
    </article>
  )
}

function Part7Double({ go }: { go: (id: ScreenId) => void }) {
  const [selected, setSelected] = useState<string | null>(null)
  return (
    <MobileFrame full>
      <ExamTop part="Part 7" progress="165 / 200" go={go} />
      <div className="exam-scroll split-reading">
        <PassageToolbar expanded={false} onExpand={() => {}} />
        <div className="doc-counter">Tài liệu 1 / 2</div>
        <FlightCard />
        <article className="message-doc">
          <div className="message-meta">
            <strong>Quail Alerts</strong>
            <span>08:12</span>
          </div>
          <p>
            Flight QA 842 to San Francisco is delayed due to operational checks.
            The new departure time is <strong>11:10 A.M.</strong> Please arrive
            at Gate C24 by 10:35 A.M.
          </p>
        </article>
        <div className="question-panel">
          <div className="compact-question-title">
            <span>165</span> Why was the message most likely sent?
          </div>
          <ChoiceList
            options={[
              { key: "A", text: "To confirm a seat upgrade" },
              { key: "B", text: "To announce a flight delay" },
              { key: "C", text: "To request passenger details" },
              { key: "D", text: "To change a destination" },
            ]}
            selected={selected}
            onSelect={setSelected}
          />
          <AnswerStatus selected={selected} onClear={() => setSelected(null)} />
          <div className="answer-disclaimer">
            Đáp án đề xuất · chưa xác minh ETS
          </div>
        </div>
      </div>
      <ExamFooter go={go} next="part7triple" />
    </MobileFrame>
  )
}

const tripleDocs = [
  {
    label: "Web",
    node: (
      <article className="web-doc">
        <div className="web-head">
          <PackageCheck size={22} />
          <strong>SINGH SUPPLIES</strong>
        </div>
        <div className="web-hero">
          Workplace essentials,
          <br />
          delivered thoughtfully.
        </div>
        <p>
          Free weekday delivery on orders over $100 within the Greater Toronto
          Area.
        </p>
        <div className="product-line">
          <span>Ergonomic desk lamp</span>
          <strong>$48.00</strong>
        </div>
        <div className="product-line">
          <span>Recycled paper, 5 packs</span>
          <strong>$32.50</strong>
        </div>
      </article>
    ),
  },
  {
    label: "Đơn hàng",
    node: (
      <article className="order-doc">
        <div className="doc-title">PURCHASE ORDER #SS-2048</div>
        <div className="form-row">
          <span>Customer</span>
          <strong>North & Vale Studio</strong>
        </div>
        <div className="form-row">
          <span>Delivery</span>
          <strong>Thursday, 20 June</strong>
        </div>
        <div className="form-row">
          <span>Items</span>
          <strong>
            4 desk lamps
            <br />
            10 paper packs
          </strong>
        </div>
        <div className="form-row total">
          <span>Total</span>
          <strong>$257.00</strong>
        </div>
      </article>
    ),
  },
  {
    label: "Email",
    node: (
      <article className="email-doc">
        <div className="email-row">
          <span>FROM</span>
          <strong>orders@singhsupplies.ca</strong>
        </div>
        <div className="email-row">
          <span>TO</span>
          <strong>maya@northvale.ca</strong>
        </div>
        <div className="email-row">
          <span>SUBJECT</span>
          <strong>Your delivery schedule</strong>
        </div>
        <p>Dear Ms. Chen,</p>
        <p>
          One of the desk lamps in your order is temporarily unavailable. We can
          deliver the remaining items Thursday and send the lamp at no
          additional charge next Monday.
        </p>
      </article>
    ),
  },
]

function Part7Triple({ go }: { go: (id: ScreenId) => void }) {
  const [tab, setTab] = useState(0)
  const [selected, setSelected] = useState<string | null>(null)
  return (
    <MobileFrame full>
      <ExamTop part="Part 7" progress="181 / 200" go={go} />
      <div className="exam-scroll split-reading">
        <div className="doc-tabs">
          {tripleDocs.map((doc, index) => (
            <button
              type="button"
              key={doc.label}
              className={tab === index ? "active" : ""}
              onClick={() => setTab(index)}
            >
              <span>{index + 1}</span>
              {doc.label}
            </button>
          ))}
        </div>
        {tripleDocs[tab].node}
        <div className="question-panel">
          <div className="compact-question-title">
            <span>181</span> What will Singh Supplies most likely do on Monday?
          </div>
          <ChoiceList
            options={[
              { key: "A", text: "Send a missing item" },
              { key: "B", text: "Collect a payment" },
              { key: "C", text: "Update its Web site" },
              { key: "D", text: "Deliver an entire order" },
            ]}
            selected={selected}
            onSelect={setSelected}
          />
          <AnswerStatus selected={selected} onClear={() => setSelected(null)} />
          <div className="answer-disclaimer">
            Đáp án đề xuất · chưa xác minh ETS
          </div>
        </div>
      </div>
      <ExamFooter go={go} next="navigator" />
    </MobileFrame>
  )
}

function QuestionGrid({ current = 147 }: { current?: number }) {
  const answered = useMemo(
    () =>
      new Set([
        101, 102, 103, 105, 108, 110, 114, 117, 121, 124, 131, 132, 135, 139,
        142, 147, 151, 158, 165, 172, 181,
      ]),
    [],
  )
  return (
    <div className="question-grid">
      {Array.from({ length: 100 }, (_, index) => index + 101).map((number) => (
        <button
          type="button"
          key={number}
          className={`${answered.has(number) ? "answered" : ""} ${
            number === current ? "current" : ""
          }`}
        >
          {number}
        </button>
      ))}
    </div>
  )
}

function Navigator({ go }: { go: (id: ScreenId) => void }) {
  return (
    <MobileFrame full>
      <AppHeader title="Tổng quan câu hỏi" back={() => go("part7single")} />
      <div className="navigator-summary">
        <div>
          <strong>21</strong>
          <span>Đã trả lời</span>
        </div>
        <div>
          <strong>79</strong>
          <span>Chưa trả lời</span>
        </div>
        <div>
          <strong>48:32</strong>
          <span>Còn lại</span>
        </div>
      </div>
      <div className="legend">
        <span>
          <i className="answered" />
          Đã trả lời
        </span>
        <span>
          <i />
          Chưa trả lời
        </span>
        <span>
          <i className="current" />
          Hiện tại
        </span>
      </div>
      <div className="navigator-scroll">
        <SectionLabel>Part 5 · 101–130</SectionLabel>
        <QuestionGrid current={147} />
      </div>
      <div className="navigator-footer">
        <Action variant="secondary" onClick={() => go("part7single")}>
          Quay lại câu 147
        </Action>
        <Action onClick={() => go("submit")} icon={<Send size={18} />}>
          Nộp bài
        </Action>
      </div>
    </MobileFrame>
  )
}

function StatusScreen({
  icon,
  eyebrow,
  title,
  description,
  children,
}: {
  icon: ReactNode
  eyebrow: string
  title: ReactNode
  description: string
  children: ReactNode
}) {
  return (
    <MobileFrame full>
      <div className="status-screen">
        <div className="status-icon">{icon}</div>
        <div className="eyebrow">{eyebrow}</div>
        <div className="status-title">{title}</div>
        <div className="status-description">{description}</div>
        {children}
      </div>
    </MobileFrame>
  )
}

function Warning({ go }: { go: (id: ScreenId) => void }) {
  return (
    <StatusScreen
      icon={<Timer size={30} />}
      eyebrow="Nhắc thời gian"
      title={
        <>
          Còn lại <span>05:00</span>
        </>
      }
      description="Bạn còn 5 phút để kiểm tra các câu chưa trả lời trước khi hệ thống tự động nộp bài."
    >
      <div className="warning-progress">
        <span />
      </div>
      <div className="status-fact">
        <AlertCircle size={18} />
        <span>
          <strong>12 câu</strong> vẫn chưa có đáp án
        </span>
      </div>
      <Action className="wide" onClick={() => go("navigator")}>
        Kiểm tra câu chưa trả lời
      </Action>
      <Action
        className="wide"
        variant="ghost"
        onClick={() => go("part7triple")}
      >
        Tiếp tục làm bài
      </Action>
    </StatusScreen>
  )
}

function Submit({ go }: { go: (id: ScreenId) => void }) {
  return (
    <StatusScreen
      icon={<Send size={28} />}
      eyebrow="Xác nhận nộp bài"
      title="Bạn đã hoàn tất?"
      description="Sau khi nộp, bạn sẽ không thể thay đổi đáp án của bài thi này."
    >
      <div className="submit-summary">
        <div>
          <CheckCircle2 size={20} />
          <span>
            <strong>88</strong> đã trả lời
          </span>
        </div>
        <div className="unanswered">
          <AlertCircle size={20} />
          <span>
            <strong>12</strong> chưa trả lời
          </span>
        </div>
      </div>
      <Action
        className="wide"
        onClick={() => go("results")}
        icon={<Send size={18} />}
      >
        Nộp bài ngay
      </Action>
      <Action
        className="wide"
        variant="secondary"
        onClick={() => go("navigator")}
      >
        Quay lại kiểm tra
      </Action>
    </StatusScreen>
  )
}

function Expired({ go }: { go: (id: ScreenId) => void }) {
  return (
    <StatusScreen
      icon={<Clock3 size={30} />}
      eyebrow="Bài thi đã kết thúc"
      title="Hết thời gian"
      description="Bài làm đã được khóa và tự động gửi. Các thay đổi sau thời điểm này sẽ không được ghi nhận."
    >
      <div className="locked-card">
        <ShieldCheck size={20} />
        <div>
          <strong>Đã khóa lúc 10:42</strong>
          <span>Trạng thái: tự động nộp bài</span>
        </div>
      </div>
      <Action className="wide" onClick={() => go("results")}>
        Xem kết quả minh họa
      </Action>
    </StatusScreen>
  )
}

function Offline({ go }: { go: (id: ScreenId) => void }) {
  return (
    <StatusScreen
      icon={<CloudOff size={30} />}
      eyebrow="Kết nối bị gián đoạn"
      title="Đáp án đang chờ gửi"
      description="Bạn vẫn có thể tiếp tục làm bài. 3 thay đổi gần nhất đang được lưu cục bộ và sẽ đồng bộ khi có mạng."
    >
      <div className="sync-list">
        {[
          ["Câu 178", "Đã lưu trên thiết bị"],
          ["Câu 179", "Đang chờ gửi"],
          ["Câu 181", "Đang chờ gửi"],
        ].map((item, index) => (
          <div key={item[0]}>
            <span className={index ? "pending-dot" : "saved-dot"} />{" "}
            <strong>{item[0]}</strong>
            <span>{item[1]}</span>
          </div>
        ))}
      </div>
      <Action
        className="wide"
        onClick={() => go("part7triple")}
        icon={<RotateCcw size={18} />}
      >
        Thử lại và tiếp tục
      </Action>
      <div className="microcopy">
        Prototype không thực sự gửi dữ liệu lên máy chủ
      </div>
    </StatusScreen>
  )
}

function Results({ go }: { go: (id: ScreenId) => void }) {
  return (
    <MobileFrame>
      <div className="result-hero">
        <AppHeader title="Kết quả bài thi" back={() => go("library")} />
        <div className="result-label">Minh họa thiết kế</div>
        <div className="result-score">
          <span>74</span>
          <small>/100</small>
        </div>
        <div className="result-caption">Câu trả lời đúng</div>
        <div className="score-ring">
          <Check size={22} />
        </div>
      </div>
      <div className="content-pad result-content">
        <div className="result-grid">
          <div className="correct">
            <CheckCircle2 />
            <strong>74</strong>
            <span>Đúng</span>
          </div>
          <div className="wrong">
            <XCircle />
            <strong>18</strong>
            <span>Sai</span>
          </div>
          <div className="skipped">
            <MoreHorizontal />
            <strong>8</strong>
            <span>Bỏ qua</span>
          </div>
        </div>
        <div className="sum-note">
          <Check size={16} /> 74 + 18 + 8 = 100 câu
        </div>
        <SectionLabel>Phân bố theo phần</SectionLabel>
        <div className="part-results">
          {[
            ["Part 5", "23 / 30", "77%"],
            ["Part 6", "11 / 16", "69%"],
            ["Part 7", "40 / 54", "74%"],
          ].map((item) => (
            <div key={item[0]}>
              <strong>{item[0]}</strong>
              <span>{item[1]}</span>
              <em>{item[2]}</em>
            </div>
          ))}
        </div>
        <div className="answer-disclaimer prominent">
          Đáp án đề xuất · chưa xác minh ETS
        </div>
        <Action className="wide" onClick={() => go("library")}>
          Về thư viện đề
        </Action>
      </div>
    </MobileFrame>
  )
}

function AdminShell({
  active,
  go,
  children,
}: {
  active: ScreenId
  go: (id: ScreenId) => void
  children: ReactNode
}) {
  return (
    <main className="admin-shell">
      <aside className="admin-sidebar">
        <Brand />
        <div className="admin-workspace">CONTENT WORKSPACE</div>
        <nav>
          {[
            ["adminUpload", UploadCloud, "Nhập đề thi"],
            ["adminPreview", PanelTop, "Xem trước đề"],
            ["adminEditor", PencilLine, "Biên tập nội dung"],
          ].map(([id, Icon, label]) => (
            <button
              type="button"
              className={active === id ? "active" : ""}
              onClick={() => go(id as ScreenId)}
              key={id as string}
            >
              <Icon size={19} />
              <span>{label as string}</span>
            </button>
          ))}
        </nav>
        <div className="sidebar-foot">
          <ShieldCheck size={18} />
          <div>
            <strong>Prototype quản trị</strong>
            <span>Không ghi dữ liệu thật</span>
          </div>
        </div>
      </aside>
      <section className="admin-main">
        <header className="admin-header">
          <div>
            <div className="eyebrow">READING STUDIO / ETS TEST 10</div>
            <strong>Quản trị nội dung</strong>
          </div>
          <div className="admin-header-actions">
            <span className="draft-pill">Bản nháp</span>
            <IconAction label="Tùy chọn">
              <Ellipsis size={21} />
            </IconAction>
          </div>
        </header>
        {children}
      </section>
    </main>
  )
}

function AdminUpload({ go }: { go: (id: ScreenId) => void }) {
  return (
    <AdminShell active="adminUpload" go={go}>
      <div className="admin-content">
        <div className="admin-title-row">
          <div>
            <div className="page-title">Nhập đề từ Word</div>
            <p>Kiểm tra cấu trúc và tính toàn vẹn trước khi tạo bản nháp.</p>
          </div>
          <Action
            onClick={() => go("adminPreview")}
            icon={<ArrowRight size={18} />}
          >
            Tiếp tục xem trước
          </Action>
        </div>
        <div className="upload-drop">
          <div className="upload-icon">
            <FileCheck2 size={30} />
          </div>
          <div>
            <strong>ETS_Reading_Test_10.docx</strong>
            <span>2.8 MB · đã tải lên 10:18 hôm nay</span>
          </div>
          <div className="upload-complete">
            <CheckCircle2 size={18} /> Đã phân tích
          </div>
        </div>
        <div className="validation-layout">
          <div className="validation-card">
            <div className="panel-heading">
              <div>
                <SectionLabel>Kết quả kiểm tra</SectionLabel>
                <strong>Cấu trúc hợp lệ</strong>
              </div>
              <div className="quality-score">
                96<span>/100</span>
              </div>
            </div>
            {[
              ["100 câu hỏi được nhận diện", "101–200", "good"],
              ["3 nhóm nội dung", "Part 5, 6, 7", "good"],
              ["12 tài liệu đọc", "Đã liên kết câu hỏi", "good"],
              ["2 đáp án cần xác minh", "Câu 163, 188", "warn"],
              ["1 kiểu chữ không hỗ trợ", "Đã thay bằng mặc định", "neutral"],
            ].map((item) => (
              <div className="validation-row" key={item[0]}>
                <span className={`validation-symbol ${item[2]}`}>
                  {item[2] === "good" ? (
                    <Check size={15} />
                  ) : (
                    <AlertCircle size={15} />
                  )}
                </span>
                <div>
                  <strong>{item[0]}</strong>
                  <span>{item[1]}</span>
                </div>
                <ChevronRight size={17} />
              </div>
            ))}
          </div>
          <div className="import-summary">
            <SectionLabel>Tóm tắt nội dung</SectionLabel>
            <div className="summary-number">100</div>
            <span>câu hỏi</span>
            <div className="summary-bar">
              <span style={{ width: "30%" }} />
              <span style={{ width: "16%" }} />
              <span style={{ width: "54%" }} />
            </div>
            <div className="summary-legend">
              <span>Part 5 · 30</span>
              <span>Part 6 · 16</span>
              <span>Part 7 · 54</span>
            </div>
            <div className="file-meta">
              <div>
                <span>Định dạng</span>
                <strong>DOCX</strong>
              </div>
              <div>
                <span>Ngôn ngữ</span>
                <strong>English</strong>
              </div>
              <div>
                <span>Thời lượng</span>
                <strong>75 phút</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
    </AdminShell>
  )
}

function AdminPreview({ go }: { go: (id: ScreenId) => void }) {
  return (
    <AdminShell active="adminPreview" go={go}>
      <div className="admin-content">
        <div className="admin-title-row">
          <div>
            <div className="page-title">Xem trước cấu trúc đề</div>
            <p>Đọc toàn bộ nhóm tài liệu và mối liên kết câu hỏi.</p>
          </div>
          <Action
            onClick={() => go("adminEditor")}
            icon={<PencilLine size={18} />}
          >
            Mở trình biên tập
          </Action>
        </div>
        <div className="preview-toolbar">
          <div className="segmented">
            <button type="button" className="active">
              Tất cả
            </button>
            <button type="button">Part 5</button>
            <button type="button">Part 6</button>
            <button type="button">Part 7</button>
          </div>
          <div className="preview-search">
            <Search size={17} /> Tìm câu hỏi, tài liệu...
          </div>
        </div>
        <div className="preview-table">
          <div className="preview-head">
            <span>Nhóm nội dung</span>
            <span>Câu hỏi</span>
            <span>Trạng thái</span>
            <span />
          </div>
          {[
            [
              "Part 5 · Incomplete Sentences",
              "101–130 · 30 câu",
              "Sẵn sàng",
              "30 câu đơn",
            ],
            [
              "IT Department Maintenance Notice",
              "131–134 · 4 câu",
              "Sẵn sàng",
              "Thư nội bộ",
            ],
            ["Siobhan’s Receipt", "147–148 · 2 câu", "Sẵn sàng", "Biên lai"],
            [
              "Quail Airlines",
              "165–169 · 5 câu",
              "Cần xem",
              "Xác nhận + tin nhắn",
            ],
            [
              "Singh Supplies",
              "181–185 · 5 câu",
              "Sẵn sàng",
              "Web + đơn hàng + email",
            ],
          ].map((row, index) => (
            <div className="preview-row" key={row[0]}>
              <div>
                <span className="doc-type">
                  {index === 0 ? (
                    <CopyCheck size={18} />
                  ) : (
                    <FileText size={18} />
                  )}
                </span>
                <div>
                  <strong>{row[0]}</strong>
                  <span>{row[3]}</span>
                </div>
              </div>
              <span>{row[1]}</span>
              <span
                className={
                  row[2] === "Cần xem" ? "review-status" : "ready-status"
                }
              >
                {row[2]}
              </span>
              <IconAction label="Mở">
                <ChevronRight size={18} />
              </IconAction>
            </div>
          ))}
        </div>
      </div>
    </AdminShell>
  )
}

function AdminEditor({ go }: { go: (id: ScreenId) => void }) {
  const [answer, setAnswer] = useState("B")
  return (
    <AdminShell active="adminEditor" go={go}>
      <div className="editor-layout">
        <div className="editor-tree">
          <div className="tree-head">
            <strong>Nội dung đề</strong>
            <IconAction label="Tìm kiếm">
              <Search size={18} />
            </IconAction>
          </div>
          <div className="tree-part">
            <span>PART 6</span>
            <strong>131–146</strong>
          </div>
          <button type="button" className="tree-group active">
            <FileText size={17} />
            <span>
              IT maintenance notice<small>131–134 · 1 tài liệu</small>
            </span>
          </button>
          <button type="button" className="tree-question active">
            <span>131</span>
            <strong>perform</strong>
            <CheckCircle2 size={15} />
          </button>
          {[132, 133, 134].map((number) => (
            <button type="button" className="tree-question" key={number}>
              <span>{number}</span>
              <strong>Câu hỏi {number}</strong>
            </button>
          ))}
          <div className="tree-part">
            <span>PART 7</span>
            <strong>147–200</strong>
          </div>
          <button type="button" className="tree-group">
            <FileText size={17} />
            <span>
              Siobhan’s Receipt<small>147–148 · 1 tài liệu</small>
            </span>
          </button>
          <button type="button" className="tree-group">
            <FileText size={17} />
            <span>
              Quail Airlines<small>165–169 · 2 tài liệu</small>
            </span>
          </button>
        </div>
        <div className="editor-canvas">
          <div className="editor-topline">
            <div>
              <span>PART 6 / NHÓM 04</span>
              <strong>IT Department Maintenance Notice</strong>
            </div>
            <div>
              <Action variant="secondary">Lưu nháp</Action>
              <Action>Xuất bản thay đổi</Action>
            </div>
          </div>
          <div className="editor-grid">
            <div className="field-card document-editor">
              <div className="field-label">
                <span>TÀI LIỆU ĐỌC</span>
                <button type="button">
                  <PencilLine size={15} /> Chỉnh sửa
                </button>
              </div>
              <article className="document letter">
                <div className="doc-date">May 14</div>
                <div className="doc-salutation">
                  To all department managers,
                </div>
                <p>
                  Please be advised it is time for the IT department to{" "}
                  <mark>[131]</mark> mandatory server maintenance and updates.
                </p>
                <p>
                  The work will begin this Friday at 8:00 P.M. Access to shared
                  drives and internal applications may be temporarily
                  unavailable.
                </p>
              </article>
            </div>
            <div className="field-card question-editor">
              <div className="field-label">
                <span>CÂU HỎI 131</span>
                <span className="required-pill">Bắt buộc</span>
              </div>
              <div className="field-block">
                <label>Nội dung câu hỏi</label>
                <div className="fake-input">
                  Chọn đáp án phù hợp nhất cho ô trống [131].
                </div>
              </div>
              <div className="field-block">
                <label>Phương án & đáp án đề xuất</label>
                <ChoiceList
                  options={[
                    { key: "A", text: "suggest" },
                    { key: "B", text: "perform" },
                    { key: "C", text: "cancel" },
                    { key: "D", text: "revise" },
                  ]}
                  selected={answer}
                  onSelect={setAnswer}
                  proposed={answer}
                />
              </div>
              <div className="editor-warning">
                <AlertCircle size={17} />
                <span>
                  <strong>Đáp án đề xuất · chưa xác minh ETS</strong>Luôn đối
                  chiếu nguồn trước khi xuất bản.
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </AdminShell>
  )
}

export default function App() {
  const initial = (window.location.hash.replace("#", "") ||
    "library") as ScreenId
  const [screen, setScreen] = useState<ScreenId>(
    screens.some((item) => item.id === initial) ? initial : "library",
  )

  const go = (id: ScreenId) => {
    setScreen(id)
    window.location.hash = id
    window.scrollTo({ top: 0, behavior: "smooth" })
  }

  useEffect(() => {
    const onHash = () => {
      const id = window.location.hash.replace("#", "") as ScreenId
      if (screens.some((item) => item.id === id)) setScreen(id)
    }
    window.addEventListener("hashchange", onHash)
    return () => window.removeEventListener("hashchange", onHash)
  }, [])

  const view = {
    library: <Library go={go} />,
    details: <Details go={go} />,
    part5: <Part5 go={go} />,
    part6: <Part6 go={go} />,
    part7single: <Part7Single go={go} />,
    part7double: <Part7Double go={go} />,
    part7triple: <Part7Triple go={go} />,
    navigator: <Navigator go={go} />,
    warning: <Warning go={go} />,
    submit: <Submit go={go} />,
    expired: <Expired go={go} />,
    offline: <Offline go={go} />,
    results: <Results go={go} />,
    adminUpload: <AdminUpload go={go} />,
    adminPreview: <AdminPreview go={go} />,
    adminEditor: <AdminEditor go={go} />,
  }[screen]

  return (
    <div className="app-shell">
      <PrototypeMenu current={screen} onChange={go} />
      {view}
    </div>
  )
}
