"""Verify the generated resume PDF is readable by resume parsers.

Resume/ATS parsers do not see the layout: they extract the text with a PDF
library and look for sections, contacts, and "title / employer, dates" blocks.
These tests extract build/resume.pdf with pdfminer.six (the extractor used by
the common open-source resume parsers, e.g. pyresparser) and check that every
element declared in src/content.tex comes out whole, in reading order, and
never mixed with the text of the other column.

Expected values are read from src/content.tex, src/main.tex and
gmresume/gmresume.cls, so the tests
follow content and layout changes without being edited.

Run with:  make build && make test
"""

import os
import re
from pathlib import Path

import pytest
from pdfminer.high_level import extract_pages, extract_text
from pdfminer.layout import LTTextContainer, LTTextLine
from pdfminer.pdfdocument import PDFDocument
from pdfminer.pdfparser import PDFParser
from pdfminer.pdftypes import resolve1

ROOT = Path(__file__).resolve().parent.parent
PDF = Path(os.environ.get("RESUME_PDF", ROOT / "build" / "resume.pdf"))
CONTENT = (ROOT / "src" / "content.tex").read_text()
# Only for the page geometry (paper width, margins, column ratio, gutter) that
# locates the column gutter in test_no_text_line_crosses_the_column_gutter:
# the class defaults, then the document's \cvset overrides.
SETTINGS = [(ROOT / "gmresume" / "gmresume.cls").read_text(), (ROOT / "src" / "main.tex").read_text()]

# Section labels rendered by \makecv, in reading order (left column, then right
# column, page by page).
SECTIONS_PAGE_1 = ["SUMMARY", "WORK EXPERIENCE", "SKILLS"]
SECTIONS_PAGE_2 = ["PROJECTS", "PUBLICATIONS", "EDUCATION", "AWARDS", "LANGUAGES"]


#----------------- helpers: content.tex parsing -----------------

def strip_comments(tex):
    return re.sub(r"(?<!\\)%.*", "", tex)


def brace_args(tex, start, count):
    """Return `count` {..} arguments starting at tex[start], skipping an optional [..]."""
    i = start
    if tex[i] == "[":
        i = tex.index("]", i) + 1
    args = []
    while len(args) < count:
        while tex[i].isspace():
            i += 1
        assert tex[i] == "{", f"expected '{{' at: {tex[i:i + 40]!r}"
        depth, j = 0, i
        while True:
            if tex[j] == "\\":
                j += 2  # skip escaped characters such as \& \{ and the \\ line break
                continue
            if tex[j] == "{":
                depth += 1
            elif tex[j] == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        args.append(tex[i + 1:j])
        i = j + 1
    return args


def declarations(macro, nargs):
    """All argument tuples of \\macro[opt]{..}{..} declared in content.tex."""
    tex = strip_comments(CONTENT)
    return [brace_args(tex, m.end(), nargs) for m in re.finditer(rf"\\{macro}(?=[\[{{\s])", tex)]


def plain(tex):
    """LaTeX snippet -> the text a reader sees."""
    tex = re.sub(r"\\(href|color)\{[^}]*\}", "", tex)         # keep link text, drop URL / color name
    tex = re.sub(r"\\(textit|textbf|emph)\b", "", tex)
    tex = tex.replace("\\&", "&").replace("~", " ").replace("\\\\", " ")
    tex = re.sub(r"\\[a-zA-Z]+\s*", "", tex)                 # remaining commands (\color, ...)
    tex = tex.replace("{", "").replace("}", "")
    return norm(tex)


def norm(text):
    return re.sub(r"\s+", " ", text.replace("\u2019", "'")).strip()


def setting(key):
    """Numeric value of a gmresume setting (in pt for lengths): the last `key = value`."""
    values = [m.group(1) for tex in SETTINGS
              for m in re.finditer(rf"(?<![\w.]){key}\s*=\s*([\d.]+)(?:pt)?\b", strip_comments(tex))]
    assert values, f"setting {key} not found"
    return float(values[-1])


#----------------- fixtures -----------------

@pytest.fixture(scope="session")
def pdf():
    if not PDF.exists():
        pytest.fail(f"{PDF} not found: run `make build` first")
    return PDF


@pytest.fixture(scope="session")
def lines(pdf):
    """Extracted text as non-empty, whitespace-normalized lines."""
    return [norm(l) for l in extract_text(pdf).splitlines() if norm(l)]


@pytest.fixture(scope="session")
def text(lines):
    """Extracted text as one whitespace-normalized string (ignores line wraps)."""
    return " ".join(lines)


@pytest.fixture(scope="session")
def document(pdf):
    """The parsed PDF document, for its Info dictionary, catalog and XMP stream."""
    with open(pdf, "rb") as f:
        doc = PDFDocument(PDFParser(f))
        # Resolve everything the tests read while the file is still open.
        doc.info_fields = {k: decode(resolve1(v)) for k, v in doc.info[0].items()}
        doc.lang = decode(resolve1(doc.catalog.get("Lang")))
        doc.xmp = resolve1(doc.catalog["Metadata"]).get_data().decode()
    return doc


def decode(value):
    """PDF string (bytes, PDFDocEncoding or UTF-16BE with BOM) -> str."""
    if not isinstance(value, bytes):
        return value
    return value[2:].decode("utf-16-be") if value.startswith(b"\xfe\xff") else value.decode("latin-1")


@pytest.fixture(scope="session")
def pages(pdf):
    return [" ".join(norm(l) for l in extract_text(pdf, page_numbers=[i]).splitlines() if norm(l))
            for i in range(2)]


#----------------- tests -----------------

def test_pdf_has_two_pages(pdf):
    assert len(list(extract_pages(pdf))) == 2


def test_header_is_extracted(lines):
    name, role, company = (declarations(m, 1)[0][0] for m in ("name", "role", "company"))
    assert plain(name) in lines
    assert f"{plain(role)} @ {plain(company)}" in lines


def test_contacts_are_extracted(text):
    email, linkedin, github = (declarations(m, 1)[0][0] for m in ("email", "linkedin", "github"))
    assert email in text
    assert f"linkedin.com/in/{linkedin}" in text
    assert f"github.com/{github}" in text


@pytest.mark.parametrize("page,sections", [(0, SECTIONS_PAGE_1), (1, SECTIONS_PAGE_2)])
def test_sections_in_reading_order(pages, page, sections):
    positions = [pages[page].find(s) for s in sections]
    assert -1 not in positions, f"missing section on page {page + 1}: {dict(zip(sections, positions))}"
    assert positions == sorted(positions), f"sections out of order on page {page + 1}"


def test_each_job_has_title_then_employer_and_dates(lines):
    jobs = declarations("job", 4)
    assert jobs, "no \\job found in content.tex"
    for title, employer, years, _ in jobs:
        title, meta = plain(title), f"{plain(employer)}, {plain(years)}"
        assert title in lines, f"job title not on its own line: {title!r}"
        following = lines[lines.index(title) + 1]
        assert following == meta, f"{title!r} is followed by {following!r}, expected {meta!r}"


def test_jobs_in_declared_order(pages):
    titles = [plain(j[0]) for j in declarations("job", 4)]
    positions = [pages[0].find(t) for t in titles]
    assert -1 not in positions and positions == sorted(positions), dict(zip(titles, positions))


def test_job_descriptions_are_extracted_whole(text):
    for *_, description in declarations("job", 4):
        for sentence in re.split(r"(?<=\.)\s+", plain(description)):
            assert sentence in text, f"job description sentence not extracted intact: {sentence!r}"


def test_summary_is_extracted_whole(text):
    summary = declarations("introduction", 1)[0][0]
    for sentence in re.split(r"(?<=\.)\s+", plain(summary)):
        assert sentence in text, f"summary sentence not extracted intact: {sentence!r}"


@pytest.mark.parametrize("macro,nargs", [("education", 3), ("publication", 2), ("project", 3), ("honour", 2)])
def test_entries_are_extracted(text, macro, nargs):
    for args in declarations(macro, nargs):
        for field in args[:2]:
            assert plain(field) in text, f"\\{macro} field not extracted intact: {plain(field)!r}"


def test_every_skill_keyword_is_extracted_as_a_whole_word(text):
    for category, items in declarations("skill", 2):
        assert plain(category) in text
        for item in (i.strip() for i in plain(items).split(",")):
            assert re.search(rf"(?<!\w){re.escape(item)}(?!\w)", text), f"skill keyword not found: {item!r}"


def test_no_text_line_crosses_the_column_gutter(pdf):
    """A line spanning both body columns means the parser mixed the two columns."""
    width = setting("paperwidth")
    left, right = setting("marginleft"), setting("marginright")
    colsep = setting("bodycolsep")
    gutter_start = left + setting("bodyratio") * (width - left - right - colsep)
    gutter_end = gutter_start + colsep

    crossing = []
    for page_no, page in enumerate(extract_pages(pdf), 1):
        for box in page:
            if not isinstance(box, LTTextContainer):
                continue
            for line in box:
                if isinstance(line, LTTextLine) and line.x0 < gutter_start and line.x1 > gutter_end:
                    crossing.append((page_no, norm(line.get_text())))
    assert not crossing, f"text lines spanning both columns: {crossing}"


@pytest.mark.parametrize("macro,field", [
    ("pdftitle", "Title"),
    ("pdfauthor", "Author"),
    ("pdfsubject", "Subject"),
    ("pdfkeywords", "Keywords"),
])
def test_info_dictionary_has_declared_metadata(document, macro, field):
    """LinkedIn and ATS tools read the classic Info dictionary."""
    assert document.info_fields.get(field) == plain(declarations(macro, 1)[0][0])


def test_catalog_has_declared_language(document):
    assert document.lang == declarations("pdflanguage", 1)[0][0]


def test_xmp_has_declared_language_and_source_url(document):
    language, = declarations("pdflanguage", 1)[0]
    url, = declarations("qrcodeurl", 1)[0]
    assert re.search(rf"<dc:language>\s*<rdf:Bag>\s*<rdf:li>{re.escape(language)}</rdf:li>", document.xmp)
    assert f"<dc:source>{url}</dc:source>" in document.xmp
