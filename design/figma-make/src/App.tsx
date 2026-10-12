import { useMemo, useState, type ReactNode } from "react"
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
  Circle,
  Clock3,
  CloudOff,
  FileCheck2,
  FileText,
  Filter,
  Flag,
  FolderOpen,
  Import,
  LayoutGrid,
  ListFilter,
  LoaderCircle,
  Menu,
  MoreHorizontal,
  PanelLeft,
  PencilLine,
  RefreshCw,
  Save,
  Search,
  Send,
  ShieldCheck,
  Timer,
  UploadCloud,
  UserRound,
  WifiOff,
  X,
  XCircle,
} from "lucide-react"
import LegacyApp from "./legacy/AppV1"

type ScreenId = "library" | "details" | "part5" | "part6" | "part7single" | "part7double" | "part7triple" | "navigator" | "warning" | "submit" | "expired" | "results" | "offline" | "adminUpload" | "adminPreview" | "adminEditor"

type Option = { key: string text: string }
type SaveState = "saved" | "saving" | "offline"

const screens: {
  id: ScreenId
  label: string
  area: "Người học" | "Quản lý đề"
}[] = [
  { id: "library", label: "Thư viện đề", area: "Người học" },
  { id: "details", label: "Chi tiết đề", area: "Người học" },
  { id: "part5", label: "Part 5 · Câu 101", area: "Người học" },
  { id: "part6", label: "Part 6 · Câu 131", area: "Người học" },
  { id: "part7single", label: "Part 7 · Một tài liệu", area: "Người học" },
  { id: "part7double", label: "Part 7 · Hai tài liệu", area: "Người học" },
  { id: "part7triple", label: "Part 7 · Ba tài liệu", area: "Người học" },
  { id: "navigator", label: "Điều hướng 101–200", area: "Người học" },
  { id: "warning", label: "Cảnh báo 5 phút", area: "Người học" },
  { id: "submit", label: "Xác nhận nộp bài", area: "Người học" },
  { id: "expired", label: "Hết giờ & tự nộp", area: "Người học" },
  { id: "offline", label: "Mất kết nối", area: "Người học" },
  { id: "results", label: "Kết quả", area: "Người học" },
  { id: "adminUpload", label: "Chọn file Word", area: "Quản lý đề" },
  { id: "adminPreview", label: "Xem trước & kiểm tra", area: "Quản lý đề" },
  { id: "adminEditor", label: "Biên tập & Import", area: "Quản lý đề" },
]

const OPTIONS_101 = [
  { key: "A", text: "your" },
  { key: "B", text: "you" },
  { key: "C", text: "yourself" },
  { key: "D", text: "yours" },
]

function Button({
  children,
  icon,
  variant = "primary",
  onClick,
  disabled,
  className = "",
}: {
  children: ReactNode
  icon?: ReactNode
  variant?: "primary" | "secondary" | "ghost" | "danger"
  onClick?: () => void
  disabled?: boolean
  className?: string
}) {
  return (
    <button
      type="button"
      className={`v2-button ${variant} ${className}`}
      onClick={onClick}
      disabled={disabled}
    >
      {icon}
      <span>{children}</span>
    </button>
  )
}

function IconButton({
  children,
  label,
  onClick,
}: {
  children: ReactNode
  label: string
  onClick?: () => void
}) {
  return (
    <button
      type="button"
      className="v2-icon-button"
      aria-label={label}
      onClick={onClick}
    >
      {children}
    </button>
  )
}

function Logo() {
  return (
    <div className="v2-logo">
      <span>
        <BookOpen size={19} />
      </span>
      <strong>Reading Studio</strong>
    </div>
  )
}

function ProductHeader({
  area,
  go,
}: {
  area: "learner" | "admin"
  go: (id: ScreenId) => void
}) {
  return (
    <header className="v2-product-header">
      <Logo />
      <nav className="v2-area-switch" aria-label="Khu vực sản phẩm">
        <button
          type="button"
          className={area === "learner" ? "active" : ""}
          onClick={() => go("library")}
        >
          <UserRound size={17} /> Người học
        </button>
        <button
          type="button"
          className={area === "admin" ? "active" : ""}
          onClick={() => go("adminUpload")}
        >
          <FolderOpen size={17} /> Quản lý đề
        </button>
      </nav>
      <div className="v2-header-note">
        Prototype giao diện · Không kết nối backend
      </div>
    </header>
  )
}

function PrototypeNav({
  current,
  version,
  onVersion,
  go,
}: {
  current: ScreenId
  version: 1 | 2
  onVersion: (version: 1 | 2) => void
  go: (id: ScreenId) => void
}) {
  const [open, setOpen] = useState(false)
  return (
    <>
      <button
        type="button"
        className="v2-prototype-trigger"
        onClick={() => setOpen(true)}
      >
        <Menu size={17} />
        <span>
          V{version} · {screens.find((item) => item.id === current)?.label}
        </span>
        <ChevronDown size={15} />
      </button>
      {open && (
        <div className="v2-overlay" onMouseDown={() => setOpen(false)}>
          <div
            className="v2-prototype-panel"
            onMouseDown={(event) => event.stopPropagation()}
          >
            <div className="v2-panel-head">
              <div>
                <span>Prototype navigator</span>
                <strong>Kiểm tra đủ 16 màn hình</strong>
              </div>
              <IconButton label="Đóng menu" onClick={() => setOpen(false)}>
                <X size={21} />
              </IconButton>
            </div>
            <div className="v2-version-switch">
              <button
                type="button"
                className={version === 2 ? "active" : ""}
                onClick={() => onVersion(2)}
              >
                Version 2 <span>Hiện tại</span>
              </button>
              <button
                type="button"
                className={version === 1 ? "active" : ""}
                onClick={() => onVersion(1)}
              >
                Version 1 <span>Bản gốc</span>
              </button>
            </div>
            {(["Người học", "Quản lý đề"] as const).map((area) => (
              <div className="v2-menu-group" key={area}>
                <span>{area}</span>
                <div>
                  {screens
                    .filter((item) => item.area === area)
                    .map((item, index) => (
                      <button
                        type="button"
                        className={item.id === current ? "active" : ""}
                        key={item.id}
                        onClick={() => {
                          onVersion(2)
                          go(item.id)
                          setOpen(false)
                        }}
                      >
                        <i>{String(index + 1).padStart(2, "0")}</i>
                        <span>{item.label}</span>
                        {item.id === current && <Check size={16} />}
                      </button>
                    ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </>
  )
}

function AppShell({
  children,
  go,
  area = "learner",
}: {
  children: ReactNode
  go: (id: ScreenId) => void
  area?: "learner" | "admin"
}) {
  return (
    <div className="v2-shell">
      <ProductHeader area={area} go={go} />
      {children}
    </div>
  )
}

function Library({ go }: { go: (id: ScreenId) => void }) {
  const [query, setQuery] = useState("")
  const [viewState, setViewState] = useState<"ready" | "loading" | "error">(
    "ready",
  )
  const matches = "ETS TOEIC Reading Test 10"
    .toLowerCase()
    .includes(query.toLowerCase())
  return (
    <AppShell go={go}>
      <main className="v2-library">
        <section className="v2-library-heading">
          <div>
            <span className="v2-kicker">Thư viện bài thi</span>
            <div className="v2-page-title">Chọn đề để bắt đầu</div>
            <p>Luyện Reading theo cấu trúc 100 câu trong 75 phút.</p>
          </div>
          <div className="v2-flow">
            {["Chọn đề", "Làm bài", "Xem kết quả"].map((item, index) => (
              <div key={item} className={index === 0 ? "active" : ""}>
                <span>{index + 1}</span>
                <strong>{item}</strong>
                {index < 2 && <ChevronRight size={16} />}
              </div>
            ))}
          </div>
        </section>
        <div className="v2-library-toolbar">
          <label className="v2-search">
            <Search size={19} />
            <input
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Tìm theo tên đề..."
            />
            {query && (
              <button type="button" onClick={() => setQuery("")}>
                <X size={17} />
              </button>
            )}
          </label>
          <div className="v2-state-demo">
            <span>Trạng thái:</span>
            {(["ready", "loading", "error"] as const).map((state) => (
              <button
                type="button"
                className={viewState === state ? "active" : ""}
                onClick={() => setViewState(state)}
                key={state}
              >
                {state === "ready"
                  ? "Sẵn sàng"
                  : state === "loading"
                    ? "Loading"
                    : "Error"}
              </button>
            ))}
          </div>
        </div>
        {viewState === "loading" ? (
          <StatePanel
            icon={<LoaderCircle className="spin" />}
            title="Đang tải thư viện đề"
            text="Vui lòng chờ trong giây lát."
          />
        ) : viewState === "error" ? (
          <StatePanel
            icon={<AlertCircle />}
            title="Không thể tải thư viện"
            text="Đây là trạng thái lỗi minh họa, không có yêu cầu backend."
            action="Thử lại"
            onAction={() => setViewState("ready")}
          />
        ) : !matches ? (
          <StatePanel
            icon={<Search />}
            title="Không tìm thấy đề phù hợp"
            text={`Không có kết quả cho “${query}”.`}
            action="Xóa tìm kiếm"
            onAction={() => setQuery("")}
          />
        ) : (
          <div className="v2-exam-grid">
            <article className="v2-exam-card">
              <div className="v2-card-visual">
                <span>ETS FORMAT</span>
                <strong>
                  Reading
                  <br />
                  Test <em>10</em>
                </strong>
                <div>Part 5 · Part 6 · Part 7</div>
              </div>
              <div className="v2-card-content">
                <div>
                  <span className="v2-tag">Đề nổi bật</span>
                  <span className="v2-muted">Cập nhật hôm nay</span>
                </div>
                <div className="v2-card-title">ETS TOEIC Reading Test 10</div>
                <p>
                  Bài thi Reading đầy đủ với câu đơn, điền đoạn văn và đọc hiểu
                  tài liệu.
                </p>
                <div className="v2-card-facts">
                  <span>
                    <Clock3 size={18} />
                    <strong>75 phút</strong>
                  </span>
                  <span>
                    <FileText size={18} />
                    <strong>100 câu</strong>
                  </span>
                  <span>
                    <LayoutGrid size={18} />
                    <strong>3 Part</strong>
                  </span>
                </div>
                <Button
                  className="wide"
                  onClick={() => go("details")}
                  icon={<ArrowRight size={18} />}
                >
                  Xem đề & bắt đầu
                </Button>
              </div>
            </article>
          </div>
        )}
      </main>
    </AppShell>
  )
}

function StatePanel({
  icon,
  title,
  text,
  action,
  onAction,
}: {
  icon: ReactNode
  title: string
  text: string
  action?: string
  onAction?: () => void
}) {
  return (
    <div className="v2-state-panel">
      <span>{icon}</span>
      <strong>{title}</strong>
      <p>{text}</p>
      {action && (
        <Button variant="secondary" onClick={onAction}>
          {action}
        </Button>
      )}
    </div>
  )
}

function Details({ go }: { go: (id: ScreenId) => void }) {
  return (
    <AppShell go={go}>
      <main className="v2-details">
        <button
          type="button"
          className="v2-back-link"
          onClick={() => go("library")}
        >
          <ChevronLeft size={18} /> Thư viện đề
        </button>
        <div className="v2-detail-layout">
          <section className="v2-detail-hero">
            <span className="v2-kicker light">ETS TOEIC · READING</span>
            <div>
              Reading Test <em>10</em>
            </div>
            <p>100 câu · 75 phút · 3 phần thi</p>
            <ShieldCheck size={42} />
          </section>
          <section className="v2-detail-content">
            <span className="v2-kicker">Thông tin bài thi</span>
            <div className="v2-page-title">Sẵn sàng bắt đầu?</div>
            <p className="v2-intro">
              Đồng hồ sẽ chạy liên tục. Bạn có thể đổi hoặc xóa đáp án trước khi
              nộp bài.
            </p>
            <div className="v2-part-list">
              {[
                ["Part 5", "Incomplete Sentences", "101–130", "30 câu"],
                ["Part 6", "Text Completion", "131–146", "16 câu"],
                ["Part 7", "Reading Comprehension", "147–200", "54 câu"],
              ].map((item, index) => (
                <div key={item[0]}>
                  <span>{index + 1}</span>
                  <div>
                    <strong>{item[0]}</strong>
                    <small>{item[1]}</small>
                  </div>
                  <div>
                    <strong>{item[3]}</strong>
                    <small>{item[2]}</small>
                  </div>
                </div>
              ))}
            </div>
            <div className="v2-notice">
              <AlertCircle size={19} />
              <span>
                <strong>Lưu ý</strong>Prototype chỉ minh họa luồng giao diện,
                không gửi dữ liệu về hệ thống.
              </span>
            </div>
            <Button
              className="wide"
              onClick={() => go("part5")}
              icon={<ArrowRight size={19} />}
            >
              Bắt đầu bài thi
            </Button>
          </section>
        </div>
      </main>
    </AppShell>
  )
}

function SaveBadge({ state }: { state: SaveState }) {
  const config = {
    saved: [<CheckCircle2 size={15} />, "Đã lưu"],
    saving: [<LoaderCircle size={15} className="spin" />, "Đang lưu"],
    offline: [<WifiOff size={15} />, "Mất kết nối"],
  } as const
  return (
    <div className={`v2-save-badge ${state}`}>
      {config[state][0]}
      <span>{config[state][1]}</span>
    </div>
  )
}

function ExamHeader({
  part,
  current,
  go,
  saveState,
  onGrid,
}: {
  part: number
  current: number
  go: (id: ScreenId) => void
  saveState: SaveState
  onGrid: () => void
}) {
  return (
    <header className="v2-exam-header">
      <div className="v2-exam-brand">
        <Logo />
        <button type="button" onClick={() => go("details")}>
          <X size={17} /> Thoát
        </button>
      </div>
      <nav className="v2-part-tabs">
        {[5, 6, 7].map((number) => (
          <button
            type="button"
            className={part === number ? "active" : ""}
            key={number}
            onClick={() =>
              go(
                number === 5 ? "part5" : number === 6 ? "part6" : "part7single",
              )
            }
          >
            Part {number}
          </button>
        ))}
      </nav>
      <div className="v2-exam-actions">
        <SaveBadge state={saveState} />
        <button type="button" className="v2-grid-trigger" onClick={onGrid}>
          <LayoutGrid size={17} />
          <span>{current}/200</span>
        </button>
        <button
          type="button"
          className="v2-fixed-timer"
          onClick={() => go("warning")}
        >
          <Timer size={17} />
          <strong>48:32</strong>
        </button>
        <Button onClick={() => go("submit")} icon={<Send size={17} />}>
          Nộp bài
        </Button>
      </div>
    </header>
  )
}

function QuestionGrid({
  current,
  go,
}: {
  current: number
  go?: (id: ScreenId) => void
}) {
  const answered = useMemo(
    () =>
      new Set([
        101, 102, 103, 108, 112, 117, 124, 131, 135, 142, 147, 151, 165, 172,
        181,
      ]),
    [],
  )
  return (
    <div className="v2-number-grid">
      {Array.from({ length: 100 }, (_, index) => index + 101).map((number) => (
        <button
          type="button"
          key={number}
          className={`${answered.has(number) ? "answered" : ""} ${
            number === current ? "current" : ""
          }`}
          onClick={() => number === 147 && go?.("part7single")}
        >
          {number}
        </button>
      ))}
    </div>
  )
}

function GridDrawer({
  current,
  close,
  go,
}: {
  current: number
  close: () => void
  go: (id: ScreenId) => void
}) {
  return (
    <div className="v2-overlay" onMouseDown={close}>
      <aside
        className="v2-grid-drawer"
        onMouseDown={(event) => event.stopPropagation()}
      >
        <div className="v2-panel-head">
          <div>
            <span>Tổng quan</span>
            <strong>Câu hỏi 101–200</strong>
          </div>
          <IconButton label="Đóng" onClick={close}>
            <X size={20} />
          </IconButton>
        </div>
        <div className="v2-grid-summary">
          <span>
            <strong>15</strong> Đã trả lời
          </span>
          <span>
            <strong>85</strong> Chưa trả lời
          </span>
        </div>
        <div className="v2-legend">
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
        <div className="v2-grid-scroll">
          <QuestionGrid current={current} go={go} />
        </div>
      </aside>
    </div>
  )
}

function AnswerCards({
  options,
  selected,
  onSelect,
}: {
  options: Option[]
  selected: string | null
  onSelect: (key: string | null) => void
}) {
  return (
    <>
      <div className="v2-answer-list">
        {options.map((option) => (
          <button
            type="button"
            className={selected === option.key ? "selected" : ""}
            key={option.key}
            onClick={() => onSelect(option.key)}
          >
            <span>
              {selected === option.key ? <Check size={17} /> : option.key}
            </span>
            <strong>{option.text}</strong>
            {selected === option.key && <small>Đã chọn</small>}
          </button>
        ))}
      </div>
      <div className="v2-answer-meta">
        <span>
          {selected
            ? `Đã chọn ${selected} · Chọn phương án khác để đổi`
            : "Chưa chọn đáp án"}
        </span>
        <button
          type="button"
          disabled={!selected}
          onClick={() => onSelect(null)}
        >
          Hủy lựa chọn
        </button>
      </div>
      <div className="v2-key-note">Đáp án đề xuất · chưa xác minh ETS</div>
    </>
  )
}

function ExamFooter({
  go,
  previous,
  next,
}: {
  go: (id: ScreenId) => void
  previous: ScreenId
  next: ScreenId
}) {
  return (
    <footer className="v2-exam-footer">
      <Button
        variant="secondary"
        onClick={() => go(previous)}
        icon={<ArrowLeft size={18} />}
      >
        Câu trước
      </Button>
      <Button onClick={() => go(next)}>
        Câu sau <ArrowRight size={18} />
      </Button>
    </footer>
  )
}

function ReadingTabs({
  count,
  active,
  onChange,
}: {
  count: number
  active: number
  onChange: (index: number) => void
}) {
  return (
    <div className="v2-doc-tabs">
      {Array.from({ length: count }, (_, index) => (
        <button
          type="button"
          className={active === index ? "active" : ""}
          onClick={() => onChange(index)}
          key={index}
        >
          Tài liệu {index + 1}
        </button>
      ))}
    </div>
  )
}

function ExamWorkspace({
  part,
  current,
  go,
  reading,
  question,
  options,
  next,
  previous,
  documentCount = 1,
  documentTab = 0,
  onDocumentTab,
}: {
  part: number
  current: number
  go: (id: ScreenId) => void
  reading: ReactNode
  question: ReactNode
  options: Option[]
  next: ScreenId
  previous: ScreenId
  documentCount?: number
  documentTab?: number
  onDocumentTab?: (index: number) => void
}) {
  const [selected, setSelected] = useState<string | null>(null)
  const [mobilePane, setMobilePane] = useState<"reading" | "question">(
    "question",
  )
  const [drawer, setDrawer] = useState(false)
  const [saveState, setSaveState] = useState<SaveState>("saved")

  const select = (key: string | null) => {
    setSelected(key)
    setSaveState("saving")
    window.setTimeout(() => setSaveState("saved"), 650)
  }

  return (
    <div className="v2-exam-page">
      <ExamHeader
        part={part}
        current={current}
        go={go}
        saveState={saveState}
        onGrid={() => setDrawer(true)}
      />
      <div className="v2-mobile-pane-switch">
        <button
          type="button"
          className={mobilePane === "reading" ? "active" : ""}
          onClick={() => setMobilePane("reading")}
        >
          <FileText size={17} />
          Bài đọc
        </button>
        <button
          type="button"
          className={mobilePane === "question" ? "active" : ""}
          onClick={() => setMobilePane("question")}
        >
          <Circle size={17} />
          Câu hỏi
        </button>
      </div>
      <main className="v2-exam-workspace">
        <aside className="v2-exam-sidebar">
          <div>
            <span>CÂU HỎI</span>
            <strong>101–200</strong>
          </div>
          <div className="v2-legend">
            <span>
              <i className="answered" />
              Đã làm
            </span>
            <span>
              <i />
              Chưa làm
            </span>
          </div>
          <div className="v2-side-grid">
            <QuestionGrid current={current} />
          </div>
        </aside>
        <section
          className={`v2-reading-pane ${
            mobilePane === "reading" ? "mobile-active" : ""
          }`}
        >
          <div className="v2-pane-head">
            <div>
              <span>PART {part}</span>
              <strong>Bài đọc</strong>
            </div>
            <button type="button" onClick={() => setMobilePane("question")}>
              Đến câu hỏi <ArrowRight size={16} />
            </button>
          </div>
          {documentCount > 1 && (
            <ReadingTabs
              count={documentCount}
              active={documentTab}
              onChange={onDocumentTab!}
            />
          )}
          <div className="v2-reading-scroll">{reading}</div>
        </section>
        <section
          className={`v2-question-pane ${
            mobilePane === "question" ? "mobile-active" : ""
          }`}
        >
          <div className="v2-question-scroll">
            <div className="v2-question-number">
              <span>Câu</span>
              <strong>{current}</strong>
              <IconButton label="Đánh dấu">
                <Flag size={20} />
              </IconButton>
            </div>
            <div className="v2-question-copy">{question}</div>
            <AnswerCards
              options={options}
              selected={selected}
              onSelect={select}
            />
            <div className="v2-save-demo">
              <span>Minh họa trạng thái lưu:</span>
              <button type="button" onClick={() => setSaveState("saved")}>
                Đã lưu
              </button>
              <button type="button" onClick={() => setSaveState("saving")}>
                Đang lưu
              </button>
              <button type="button" onClick={() => setSaveState("offline")}>
                Mất kết nối
              </button>
            </div>
          </div>
          <ExamFooter go={go} previous={previous} next={next} />
        </section>
      </main>
      {drawer && (
        <GridDrawer current={current} close={() => setDrawer(false)} go={go} />
      )}
    </div>
  )
}

function Part5({ go }: { go: (id: ScreenId) => void }) {
  return (
    <ExamWorkspace
      part={5}
      current={101}
      go={go}
      previous="details"
      next="part6"
      reading={
        <div className="v2-instruction-doc">
          <span>Hướng dẫn</span>
          <div>Part 5</div>
          <p>Chọn từ hoặc cụm từ phù hợp nhất để hoàn thành câu.</p>
          <small>Incomplete Sentences · Câu 101–130</small>
        </div>
      }
      question={
        <>
          Please contact the product distributor, not the retail store, if{" "}
          <mark>-------</mark> need replacement parts.
        </>
      }
      options={OPTIONS_101}
    />
  )
}

function MaintenanceDoc() {
  return (
    <article className="v2-letter">
      <div>May 14</div>
      <strong>To all department managers,</strong>
      <p>
        Please be advised it is time for the IT department to <mark>[131]</mark>{" "}
        mandatory server maintenance and updates.
      </p>
      <p>
        The work will begin this Friday at 8:00 P.M. Access to shared drives and
        internal applications may be temporarily unavailable.
      </p>
      <p>
        Please save all open files before leaving the office. Thank you for your
        cooperation.
      </p>
      <em>Information Technology Department</em>
    </article>
  )
}

function Part6({ go }: { go: (id: ScreenId) => void }) {
  return (
    <ExamWorkspace
      part={6}
      current={131}
      go={go}
      previous="part5"
      next="part7single"
      reading={<MaintenanceDoc />}
      question={
        <>
          Choose the word that best completes blank <mark>[131]</mark>.
        </>
      }
      options={[
        { key: "A", text: "suggest" },
        { key: "B", text: "perform" },
        { key: "C", text: "cancel" },
        { key: "D", text: "revise" },
      ]}
    />
  )
}

function ReceiptDoc() {
  return (
    <article className="v2-receipt">
      <strong>SIOBHAN'S</strong>
      <span>TORONTO, ONTARIO</span>
      <i />
      <div>
        <span>Medium coffee</span>
        <strong>$2.25</strong>
      </div>
      <div>
        <span>Large coffee</span>
        <strong>$2.75</strong>
      </div>
      <div>
        <span>2 croissants</span>
        <strong>$4.00</strong>
      </div>
      <i />
      <div>
        <span>SUBTOTAL</span>
        <strong>$9.00</strong>
      </div>
      <div>
        <span>HST</span>
        <strong>$1.17</strong>
      </div>
      <div className="total">
        <span>TOTAL</span>
        <strong>$10.17</strong>
      </div>
      <small>THANK YOU</small>
    </article>
  )
}

function Part7Single({ go }: { go: (id: ScreenId) => void }) {
  return (
    <ExamWorkspace
      part={7}
      current={147}
      go={go}
      previous="part6"
      next="part7double"
      reading={<ReceiptDoc />}
      question={<>What type of business most likely provided the receipt?</>}
      options={[
        { key: "A", text: "A caterer" },
        { key: "B", text: "A vegetable market" },
        { key: "C", text: "A cafe" },
        { key: "D", text: "An online retailer" },
      ]}
    />
  )
}

function FlightConfirmation() {
  return (
    <article className="v2-flight-doc">
      <div className="brand">QUAIL AIRLINES</div>
      <span>FLIGHT CONFIRMATION</span>
      <div className="route">
        <strong>YYZ</strong>
        <i>QA 842</i>
        <strong>SFO</strong>
      </div>
      <div className="route-label">
        <span>Toronto</span>
        <span>San Francisco</span>
      </div>
      <div className="facts">
        <span>
          Date<strong>18 JUN</strong>
        </span>
        <span>
          Departure<strong>09:40</strong>
        </span>
        <span>
          Seat<strong>14A</strong>
        </span>
      </div>
    </article>
  )
}

function FlightDelay() {
  return (
    <article className="v2-message-doc">
      <div>
        <strong>Quail Alerts</strong>
        <span>08:12</span>
      </div>
      <p>
        Flight QA 842 to San Francisco is delayed due to operational checks. The
        new departure time is <strong>11:10 A.M.</strong> Please arrive at Gate
        C24 by 10:35 A.M.
      </p>
    </article>
  )
}

function Part7Double({ go }: { go: (id: ScreenId) => void }) {
  const [tab, setTab] = useState(0)
  return (
    <ExamWorkspace
      part={7}
      current={165}
      go={go}
      previous="part7single"
      next="part7triple"
      documentCount={2}
      documentTab={tab}
      onDocumentTab={setTab}
      reading={tab === 0 ? <FlightConfirmation /> : <FlightDelay />}
      question={<>Why was the message most likely sent?</>}
      options={[
        { key: "A", text: "To confirm a seat upgrade" },
        { key: "B", text: "To announce a flight delay" },
        { key: "C", text: "To request passenger details" },
        { key: "D", text: "To change a destination" },
      ]}
    />
  )
}

const SinghDocs = [
  <article className="v2-web-doc" key="web">
    <div>
      <BookOpen size={20} />
      SINGH SUPPLIES
    </div>
    <strong>
      Workplace essentials,
      <br />
      delivered thoughtfully.
    </strong>
    <p>
      Free weekday delivery on orders over $100 within the Greater Toronto Area.
    </p>
    <span>
      Ergonomic desk lamp <b>$48.00</b>
    </span>
    <span>
      Recycled paper, 5 packs <b>$32.50</b>
    </span>
  </article>,
  <article className="v2-order-doc" key="order">
    <strong>PURCHASE ORDER #SS-2048</strong>
    <span>
      Customer <b>North & Vale Studio</b>
    </span>
    <span>
      Delivery <b>Thursday, 20 June</b>
    </span>
    <span>
      Items{" "}
      <b>
        4 desk lamps
        <br />
        10 paper packs
      </b>
    </span>
    <span>
      Total <b>$257.00</b>
    </span>
  </article>,
  <article className="v2-email-doc" key="email">
    <span>
      FROM <b>orders@singhsupplies.ca</b>
    </span>
    <span>
      TO <b>maya@northvale.ca</b>
    </span>
    <span>
      SUBJECT <b>Your delivery schedule</b>
    </span>
    <p>Dear Ms. Chen,</p>
    <p>
      One of the desk lamps in your order is temporarily unavailable. We can
      deliver the remaining items Thursday and send the lamp at no additional
      charge next Monday.
    </p>
  </article>,
]

function Part7Triple({ go }: { go: (id: ScreenId) => void }) {
  const [tab, setTab] = useState(0)
  return (
    <ExamWorkspace
      part={7}
      current={181}
      go={go}
      previous="part7double"
      next="navigator"
      documentCount={3}
      documentTab={tab}
      onDocumentTab={setTab}
      reading={SinghDocs[tab]}
      question={<>What will Singh Supplies most likely do on Monday?</>}
      options={[
        { key: "A", text: "Send a missing item" },
        { key: "B", text: "Collect a payment" },
        { key: "C", text: "Update its Web site" },
        { key: "D", text: "Deliver an entire order" },
      ]}
    />
  )
}

function Navigator({ go }: { go: (id: ScreenId) => void }) {
  return (
    <AppShell go={go}>
      <main className="v2-navigator-page">
        <div className="v2-navigator-head">
          <button
            type="button"
            className="v2-back-link"
            onClick={() => go("part7single")}
          >
            <ChevronLeft size={18} />
            Quay lại câu 147
          </button>
          <div>
            <span className="v2-kicker">Tổng quan bài thi</span>
            <div className="v2-page-title">Câu hỏi 101–200</div>
          </div>
          <div className="v2-navigator-actions">
            <SaveBadge state="saved" />
            <div className="v2-fixed-timer">
              <Timer size={17} />
              <strong>48:32</strong>
            </div>
            <Button onClick={() => go("submit")}>Nộp bài</Button>
          </div>
        </div>
        <div className="v2-navigator-layout">
          <aside>
            <div>
              <strong>15</strong>
              <span>Đã trả lời</span>
            </div>
            <div>
              <strong>85</strong>
              <span>Chưa trả lời</span>
            </div>
            <div>
              <strong>100</strong>
              <span>Tổng số câu</span>
            </div>
            <div className="v2-legend">
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
          </aside>
          <section>
            <div className="v2-grid-section">
              <strong>Part 5</strong>
              <span>101–130 · 30 câu</span>
            </div>
            <QuestionGrid current={147} go={go} />
          </section>
        </div>
      </main>
    </AppShell>
  )
}

function CenteredState({
  go,
  icon,
  kicker,
  title,
  text,
  children,
}: {
  go: (id: ScreenId) => void
  icon: ReactNode
  kicker: string
  title: string
  text: string
  children: ReactNode
}) {
  return (
    <AppShell go={go}>
      <main className="v2-centered-state">
        <div className="v2-state-icon">{icon}</div>
        <span className="v2-kicker">{kicker}</span>
        <div className="v2-state-title">{title}</div>
        <p>{text}</p>
        <div className="v2-state-actions">{children}</div>
      </main>
    </AppShell>
  )
}

function Warning({ go }: { go: (id: ScreenId) => void }) {
  return (
    <CenteredState
      go={go}
      icon={<Timer />}
      kicker="Cảnh báo thời gian"
      title="Còn lại 05:00"
      text="Bạn còn 5 phút để kiểm tra các câu chưa trả lời trước khi hệ thống tự động nộp bài."
    >
      <div className="v2-unanswered-callout">
        <AlertCircle size={19} />
        <span>
          <strong>12 câu</strong> chưa có đáp án
        </span>
      </div>
      <Button onClick={() => go("navigator")}>Xem câu chưa trả lời</Button>
      <Button variant="secondary" onClick={() => go("part7triple")}>
        Tiếp tục làm bài
      </Button>
    </CenteredState>
  )
}

function Submit({ go }: { go: (id: ScreenId) => void }) {
  return (
    <CenteredState
      go={go}
      icon={<Send />}
      kicker="Xác nhận nộp bài"
      title="Bạn đã hoàn tất?"
      text="Sau khi nộp, bạn không thể thay đổi câu trả lời."
    >
      <div className="v2-submit-counts">
        <span>
          <CheckCircle2 />
          <strong>88</strong> Đã trả lời
        </span>
        <span>
          <AlertCircle />
          <strong>12</strong> Chưa trả lời
        </span>
      </div>
      <Button onClick={() => go("results")} icon={<Send size={17} />}>
        Nộp bài ngay
      </Button>
      <Button variant="secondary" onClick={() => go("navigator")}>
        Quay lại kiểm tra
      </Button>
    </CenteredState>
  )
}

function Expired({ go }: { go: (id: ScreenId) => void }) {
  return (
    <CenteredState
      go={go}
      icon={<Clock3 />}
      kicker="Bài thi đã kết thúc"
      title="Hết thời gian"
      text="Bài làm đã được khóa và tự động nộp. Các thay đổi sau thời điểm này không được ghi nhận."
    >
      <div className="v2-lock-card">
        <ShieldCheck />
        <span>
          <strong>Đã khóa lúc 10:42</strong>Tự động nộp · Không thể chỉnh sửa
        </span>
      </div>
      <Button onClick={() => go("results")}>Xem kết quả minh họa</Button>
    </CenteredState>
  )
}

function Offline({ go }: { go: (id: ScreenId) => void }) {
  return (
    <CenteredState
      go={go}
      icon={<CloudOff />}
      kicker="Trạng thái kết nối"
      title="Đáp án đang chờ gửi"
      text="Bạn vẫn có thể làm bài. 3 thay đổi gần nhất đang lưu trên thiết bị và sẽ đồng bộ khi có mạng."
    >
      <div className="v2-sync-list">
        {[
          ["178", "Đã lưu"],
          ["179", "Đang chờ"],
          ["181", "Đang chờ"],
        ].map((item) => (
          <div key={item[0]}>
            <span className={item[1] === "Đã lưu" ? "ok" : ""} />
            <strong>Câu {item[0]}</strong>
            <small>{item[1]}</small>
          </div>
        ))}
      </div>
      <Button onClick={() => go("part7triple")} icon={<RefreshCw size={17} />}>
        Thử lại & tiếp tục
      </Button>
      <div className="v2-prototype-note">
        Minh họa thiết kế · Không thực sự gửi dữ liệu
      </div>
    </CenteredState>
  )
}

function Results({ go }: { go: (id: ScreenId) => void }) {
  const [filter, setFilter] = useState<"all" | "wrong" | "skipped">("all")
  const detail = [
    { number: 101, state: "Đúng", answer: "B" },
    { number: 131, state: "Sai", answer: "A" },
    { number: 147, state: "Bỏ qua", answer: "—" },
  ]
  const filtered =
    filter === "all"
      ? detail
      : detail.filter(
          (item) => item.state === (filter === "wrong" ? "Sai" : "Bỏ qua"),
        )
  return (
    <AppShell go={go}>
      <main className="v2-results">
        <section className="v2-results-head">
          <span className="v2-kicker light">Minh họa thiết kế</span>
          <div className="v2-page-title light">Kết quả bài thi</div>
          <p>Không quy đổi sang điểm TOEIC.</p>
        </section>
        <section className="v2-results-content">
          <div className="v2-result-cards">
            <div className="correct">
              <CheckCircle2 />
              <span>Đúng</span>
              <strong>74</strong>
            </div>
            <div className="wrong">
              <XCircle />
              <span>Sai</span>
              <strong>18</strong>
            </div>
            <div className="skipped">
              <MoreHorizontal />
              <span>Bỏ qua</span>
              <strong>8</strong>
            </div>
          </div>
          <div className="v2-result-toolbar">
            <div>
              <span className="v2-kicker">Chi tiết câu trả lời</span>
              <strong>74 + 18 + 8 = 100 câu</strong>
            </div>
            <div className="v2-filter-tabs">
              {([
                ["all", "Tất cả"],
                ["wrong", "Sai"],
                ["skipped", "Bỏ qua"],
              ] as const).map((item) => (
                <button
                  type="button"
                  className={filter === item[0] ? "active" : ""}
                  onClick={() => setFilter(item[0])}
                  key={item[0]}
                >
                  {item[1]}
                </button>
              ))}
            </div>
          </div>
          <div className="v2-result-list">
            {filtered.map((item) => (
              <button type="button" key={item.number}>
                <span>Câu {item.number}</span>
                <strong
                  className={
                    item.state === "Đúng"
                      ? "correct"
                      : item.state === "Sai"
                        ? "wrong"
                        : "skipped"
                  }
                >
                  {item.state}
                </strong>
                <small>Đáp án của bạn: {item.answer}</small>
                <ChevronRight size={18} />
              </button>
            ))}
            {!filtered.length && (
              <StatePanel
                icon={<ListFilter />}
                title="Không có câu phù hợp"
                text="Hãy chọn bộ lọc khác."
              />
            )}
          </div>
          <div className="v2-key-note prominent">
            Đáp án đề xuất · chưa xác minh ETS
          </div>
          <Button onClick={() => go("library")}>Về thư viện đề</Button>
        </section>
      </main>
    </AppShell>
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
    <AppShell go={go} area="admin">
      <div className="v2-admin-layout">
        <aside className="v2-admin-sidebar">
          <span className="v2-kicker">Danh sách đề</span>
          <button type="button" className="active">
            <FileText size={18} />
            <span>
              <strong>Reading Test 10</strong>
              <small>Bản nháp · 100 câu</small>
            </span>
          </button>
          <button type="button">
            <FileText size={18} />
            <span>
              <strong>Reading Test 09</strong>
              <small>Đã xuất bản</small>
            </span>
          </button>
          <Button
            variant="secondary"
            icon={<Import size={17} />}
            onClick={() => go("adminUpload")}
          >
            Nhập đề mới
          </Button>
        </aside>
        <main className="v2-admin-main">
          <div className="v2-admin-steps">
            {[
              ["adminUpload", "1", "Chọn Word"],
              ["adminPreview", "2", "Xem trước & kiểm tra"],
              ["adminEditor", "3", "Import"],
            ].map((item, index) => (
              <button
                type="button"
                className={active === item[0] ? "active" : ""}
                onClick={() => go(item[0] as ScreenId)}
                key={item[0]}
              >
                <span>
                  {active === item[0] ? <Check size={15} /> : item[1]}
                </span>
                <strong>{item[2]}</strong>
                {index < 2 && <i />}
              </button>
            ))}
          </div>
          {children}
        </main>
      </div>
    </AppShell>
  )
}

function AdminUpload({ go }: { go: (id: ScreenId) => void }) {
  return (
    <AdminShell active="adminUpload" go={go}>
      <section className="v2-admin-content">
        <div className="v2-admin-title">
          <div>
            <span className="v2-kicker">Bước 1 / 3</span>
            <div className="v2-page-title">Chọn file Word</div>
            <p>Tải file DOCX và kiểm tra định dạng trước khi xem trước.</p>
          </div>
          <Button disabled>
            Tiếp tục <ArrowRight size={17} />
          </Button>
        </div>
        <div className="v2-upload-card">
          <div className="v2-upload-zone">
            <UploadCloud size={32} />
            <strong>Kéo file Word vào đây</strong>
            <span>hoặc chọn từ máy tính · Tối đa 20 MB</span>
            <Button variant="secondary">Chọn file .docx</Button>
          </div>
          <div className="v2-file-row">
            <FileCheck2 size={25} />
            <span>
              <strong>ETS_Reading_Test_10.docx</strong>
              <small>2.8 MB · DOCX</small>
            </span>
            <div className="success">
              <CheckCircle2 size={17} /> Hợp lệ
            </div>
            <IconButton label="Xóa file">
              <X size={18} />
            </IconButton>
          </div>
        </div>
        <div className="v2-disabled-reason">
          <AlertCircle size={18} />
          <span>
            <strong>Nút Tiếp tục đang tắt trong trạng thái minh họa</strong>Chọn
            “Xem trước & kiểm tra” ở thanh bước để tiếp tục luồng prototype.
          </span>
        </div>
      </section>
    </AdminShell>
  )
}

function AdminPreview({ go }: { go: (id: ScreenId) => void }) {
  const [part, setPart] = useState("all")
  return (
    <AdminShell active="adminPreview" go={go}>
      <section className="v2-admin-content">
        <div className="v2-admin-title">
          <div>
            <span className="v2-kicker">Bước 2 / 3</span>
            <div className="v2-page-title">Xem trước & kiểm tra</div>
            <p>ETS_Reading_Test_10.docx · 100 câu · 12 tài liệu</p>
          </div>
          <Button onClick={() => go("adminEditor")}>
            Mở biên tập <ArrowRight size={17} />
          </Button>
        </div>
        <div className="v2-validation-summary">
          <div className="success">
            <CheckCircle2 />
            <span>
              <strong>98 mục hợp lệ</strong>Sẵn sàng import
            </span>
          </div>
          <div className="error">
            <AlertCircle />
            <span>
              <strong>2 lỗi cần kiểm tra</strong>Câu 163, 188
            </span>
          </div>
          <div>
            <FileText />
            <span>
              <strong>12 tài liệu</strong>Đã nhóm theo câu
            </span>
          </div>
        </div>
        <div className="v2-preview-tabs">
          {["all", "5", "6", "7"].map((item) => (
            <button
              type="button"
              className={part === item ? "active" : ""}
              onClick={() => setPart(item)}
              key={item}
            >
              {item === "all" ? "Tất cả" : `Part ${item}`}
            </button>
          ))}
        </div>
        <div className="v2-preview-list">
          {[
            ["Part 5 · Incomplete Sentences", "101–130", "30 câu", "success"],
            ["IT Department Maintenance Notice", "131–134", "4 câu", "success"],
            ["Siobhan’s Receipt", "147–148", "2 câu", "success"],
            ["Quail Airlines", "165–169", "5 câu", "error"],
            ["Singh Supplies", "181–185", "5 câu", "success"],
          ]
            .filter(
              (_, index) =>
                part === "all" ||
                (part === "5" && index === 0) ||
                (part === "6" && index === 1) ||
                (part === "7" && index > 1),
            )
            .map((item) => (
              <button type="button" key={item[0]}>
                <span className="doc">
                  <FileText />
                </span>
                <span>
                  <strong>{item[0]}</strong>
                  <small>
                    {item[1]} · {item[2]}
                  </small>
                </span>
                <i className={item[3]}>
                  {item[3] === "success" ? "Hợp lệ" : "Có lỗi"}
                </i>
                <ChevronRight size={18} />
              </button>
            ))}
        </div>
      </section>
    </AdminShell>
  )
}

function AdminEditor({ go }: { go: (id: ScreenId) => void }) {
  const [answer, setAnswer] = useState<string | null>("B")
  const [saved, setSaved] = useState(false)
  return (
    <AdminShell active="adminEditor" go={go}>
      <section className="v2-editor">
        <aside className="v2-editor-tree">
          <div>
            <strong>Nội dung đề</strong>
            <IconButton label="Tìm">
              <Search size={17} />
            </IconButton>
          </div>
          <span>PART 6 · 131–146</span>
          <button type="button" className="active">
            <FileText size={17} />
            <span>
              <strong>IT maintenance notice</strong>
              <small>131–134 · 1 tài liệu</small>
            </span>
          </button>
          {[131, 132, 133, 134].map((number) => (
            <button
              type="button"
              className={number === 131 ? "question active" : "question"}
              key={number}
            >
              <i>{number}</i>
              <span>Câu hỏi {number}</span>
              {number === 131 && <Check size={14} />}
            </button>
          ))}
          <span>PART 7 · 147–200</span>
          <button type="button">
            <FileText size={17} />
            <span>
              <strong>Siobhan’s Receipt</strong>
              <small>147–148 · 1 tài liệu</small>
            </span>
          </button>
        </aside>
        <div className="v2-editor-body">
          <div className="v2-editor-head">
            <div>
              <span className="v2-kicker">Part 6 / Nhóm 04</span>
              <div className="v2-page-title">Câu hỏi 131</div>
            </div>
            <div>
              {saved && (
                <span className="v2-save-success">
                  <CheckCircle2 size={16} />
                  Đã lưu
                </span>
              )}
              <Button onClick={() => setSaved(true)} icon={<Save size={17} />}>
                Lưu thay đổi
              </Button>
            </div>
          </div>
          <div className="v2-editor-columns">
            <div className="v2-editor-card">
              <label>
                Tài liệu đọc <span>Bắt buộc</span>
              </label>
              <p className="helper">Kiểm tra vị trí ô trống và nội dung gốc.</p>
              <MaintenanceDoc />
              <Button variant="secondary" icon={<PencilLine size={16} />}>
                Chỉnh sửa tài liệu
              </Button>
            </div>
            <div className="v2-editor-card">
              <label>
                Phương án trả lời <span>Bắt buộc</span>
              </label>
              <p className="helper">
                Chọn đáp án đề xuất. Có thể thay đổi trước khi import.
              </p>
              <AnswerCards
                options={[
                  { key: "A", text: "suggest" },
                  { key: "B", text: "perform" },
                  { key: "C", text: "cancel" },
                  { key: "D", text: "revise" },
                ]}
                selected={answer}
                onSelect={setAnswer}
              />
              <div className="v2-admin-error">
                <AlertCircle size={17} />
                <span>
                  <strong>Cần xác minh nguồn</strong>Đáp án đề xuất chưa được
                  xác minh ETS.
                </span>
              </div>
              <Button
                className="wide"
                onClick={() => setSaved(true)}
                icon={<Save size={17} />}
              >
                Lưu câu hỏi
              </Button>
            </div>
          </div>
        </div>
      </section>
    </AdminShell>
  )
}

function VersionTwo({
  screen,
  go,
  version,
  onVersion,
}: {
  screen: ScreenId
  go: (id: ScreenId) => void
  version: 1 | 2
  onVersion: (version: 1 | 2) => void
}) {
  const views: Record<ScreenId, ReactNode> = {
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
    results: <Results go={go} />,
    offline: <Offline go={go} />,
    adminUpload: <AdminUpload go={go} />,
    adminPreview: <AdminPreview go={go} />,
    adminEditor: <AdminEditor go={go} />,
  }
  return (
    <>
      <PrototypeNav
        current={screen}
        version={version}
        onVersion={onVersion}
        go={go}
      />
      {views[screen]}
    </>
  )
}

export default function App() {
  const [version, setVersion] = useState<1 | 2>(2)
  const [screen, setScreen] = useState<ScreenId>("library")
  const go = (id: ScreenId) => {
    setScreen(id)
    window.scrollTo({ top: 0, behavior: "smooth" })
  }

  if (version === 1) {
    return (
      <div className="v2-legacy-wrap">
        <button
          type="button"
          className="v2-back-to-current"
          onClick={() => setVersion(2)}
        >
          <ArrowLeft size={16} /> Quay lại Version 2
        </button>
        <LegacyApp />
      </div>
    )
  }

  return (
    <VersionTwo
      screen={screen}
      go={go}
      version={version}
      onVersion={setVersion}
    />
  )
}
