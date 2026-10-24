%-------------------------------------------------------------------------------
% gmresume.cls — two-page, two-column resume class. LAYOUT & STYLE ONLY.
% Defines page geometry, fonts, colors, and the macros a document uses to
% declare its content; \makeresume lays the declared content out. The class holds
% no resume content of its own.
%
% Requires XeLaTeX or LuaLaTeX (fontspec). Minimal document:
%
%   \documentclass{gmresume}
%   \resumeset{accent=22A39F}   % optional: override any setting (see SETTINGS)
%   \name{JANE DOE}
%   \job{Software Engineer}{Example Corp}{2020-Present}{What I did.}
%   \begin{document}
%   \makeresume
%   \end{document}
%
% Declare the content in the preamble, before \begin{document}: the PDF
% metadata it sets must be in place when the document starts.
%-------------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[2022-11-01] % \DeclareKeys, \SetKeys, \ProcessKeyOptions
\ProvidesClass{gmresume}[2026/10/24 v1.0.0 Two-page two-column resume]

\LoadClass[8pt]{extarticle} % base font size

\RequirePackage{geometry} % page size/margins are configured from the settings below
\RequirePackage{fontspec}
\RequirePackage{paracol}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{fontawesome5}
\RequirePackage{enumitem}
\RequirePackage{ragged2e}
\RequirePackage[hidelinks]{hyperref}
% hyperxmp writes an XMP metadata stream (Dublin Core) mirroring the \hypersetup
% Info fields, so web crawlers and document systems can read title/author/
% subject/keywords.
\RequirePackage{hyperxmp}
\RequirePackage{tikz}
\RequirePackage{qrcode}

%=============================================================================
%  SETTINGS — every tunable value is a key. The class defaults are set with
%  \resumeset at the end of this block; a document overrides any of them with
%  \resumeset{key=value, ...} in its preamble, or as a class option for simple
%  values (\documentclass[accent=FF0000]{gmresume}).
%  Everything below this block only references these settings.
%=============================================================================

% Storage for the settings (filled by the keys).
\newcommand{\sizename}{}
\newcommand{\sizerole}{}
\newcommand{\sizeheadline}{}
\newcommand{\sizelabel}{}
\newcommand{\sizeheadertext}{}
\newcommand{\sizebody}{}
\newcommand{\sizefooter}{}
\newlength{\bodycolsep}
\newlength{\resumesectioniconsep}
\newlength{\resumecoursebadgewidth}
\newlength{\resumeqrcodex}
\newlength{\resumeqrcodey}
\newlength{\resumeqrcodesize}
\newlength{\sectiongap}
\newlength{\sectionlabelgap}
\newlength{\headerblockgap}
\newlength{\headerblocklabelgap}
\newlength{\namegap}
\newlength{\rolegap}
\newlength{\headerbottomgap}
\newlength{\contactlinegap}
\newlength{\bodygap}
\newlength{\newlinegap}
\newlength{\entrytopgap}
\newlength{\entrymetagap}
\newlength{\edugap}
\newlength{\coursegap}
\newlength{\skillgap}
\newlength{\langtoppad}
\newlength{\langlinegap}
\newlength{\resumelistitemsep}
\newlength{\resumelisttopsep}
\newlength{\resumelistparsep}

\DeclareKeys[gmresume]{
  % Page
  paperwidth          .store = \resumepaperwidth,
  paperheight         .store = \resumepaperheight,
  margintop           .store = \resumemargintop,
  marginbottom        .store = \resumemarginbottom,
  marginleft          .store = \resumemarginleft,
  marginright         .store = \resumemarginright,
  % Fonts
  fontdir             .store = \fontdir,
  fontregular         .store = \fontregular,
  fontbold            .store = \fontbold,
  fontitalic          .store = \fontitalic,
  fontbolditalic      .store = \fontbolditalic,
  fontlight           .store = \fontlight,
  % Colors
  accent              .code  = \definecolor{accent}{HTML}{#1},
  primary             .code  = \definecolor{primary}{HTML}{#1},
  secondary           .code  = \definecolor{secondary}{HTML}{#1},
  % Font sizes, each as {size}{leading}
  namesize            .code  = \renewcommand{\sizename}{\fontsize#1\selectfont},
  rolesize            .code  = \renewcommand{\sizerole}{\fontsize#1\selectfont},
  headlinesize        .code  = \renewcommand{\sizeheadline}{\fontsize#1\selectfont},
  labelsize           .code  = \renewcommand{\sizelabel}{\fontsize#1\selectfont},
  headertextsize      .code  = \renewcommand{\sizeheadertext}{\fontsize#1\selectfont},
  bodysize            .code  = \renewcommand{\sizebody}{\fontsize#1\selectfont},
  footersize          .code  = \renewcommand{\sizefooter}{\fontsize#1\selectfont},
  % Text
  linespread          .store = \resumelinespread,
  nametracking        .store = \resumenametracking,
  % Layout
  headerratio         .store = \headerratio,
  bodyratio           .store = \bodyratio,
  bodycolsep          .code  = \setlength{\bodycolsep}{#1},
  worksplit           .store = \resumeworksplit,
  sectioniconsize     .store = \resumesectioniconsize,
  sectioniconraise    .store = \resumesectioniconraise,
  sectioniconsep      .code  = \setlength{\resumesectioniconsep}{#1},
  coursebadgewidth    .code  = \setlength{\resumecoursebadgewidth}{#1},
  qrcodex             .code  = \setlength{\resumeqrcodex}{#1},
  qrcodey             .code  = \setlength{\resumeqrcodey}{#1},
  qrcodesize          .code  = \setlength{\resumeqrcodesize}{#1},
  % Vertical spacing
  sectiongap          .code  = \setlength{\sectiongap}{#1},
  sectionlabelgap     .code  = \setlength{\sectionlabelgap}{#1},
  headerblockgap      .code  = \setlength{\headerblockgap}{#1},
  headerblocklabelgap .code  = \setlength{\headerblocklabelgap}{#1},
  namegap             .code  = \setlength{\namegap}{#1},
  rolegap             .code  = \setlength{\rolegap}{#1},
  headerbottomgap     .code  = \setlength{\headerbottomgap}{#1},
  contactlinegap      .code  = \setlength{\contactlinegap}{#1},
  bodygap             .code  = \setlength{\bodygap}{#1},
  newlinegap          .code  = \setlength{\newlinegap}{#1},
  entrytopgap         .code  = \setlength{\entrytopgap}{#1},
  entrymetagap        .code  = \setlength{\entrymetagap}{#1},
  edugap              .code  = \setlength{\edugap}{#1},
  coursegap           .code  = \setlength{\coursegap}{#1},
  skillgap            .code  = \setlength{\skillgap}{#1},
  langtoppad          .code  = \setlength{\langtoppad}{#1},
  langlinegap         .code  = \setlength{\langlinegap}{#1},
  langcellwidth       .store = \resumelangcellwidth,
  % Bullet lists
  listindent          .store = \resumelistindent,
  listitemsep         .code  = \setlength{\resumelistitemsep}{#1},
  listtopsep          .code  = \setlength{\resumelisttopsep}{#1},
  listparsep          .code  = \setlength{\resumelistparsep}{#1},
}

% \resumeset{key=value, ...} overrides settings; use it in the document preamble.
\newcommand{\resumeset}[1]{\SetKeys[gmresume]{#1}}

% Class defaults.
\resumeset{
  %--- Page: paper dimensions and margins ------------------------------------
  paperwidth   = 595pt,
  paperheight  = 842pt,
  margintop    = 22pt,
  marginbottom = 20pt,
  marginleft   = 26pt,
  marginright  = 19pt,
  %--- Fonts: file names, looked up in fontdir (empty: the TeX distribution) -
  % Latin Modern Sans ships with every TeX Live, so the class works out of the
  % box; point these at any other .otf/.ttf files. It has no light weight, so
  % fontlight falls back to the regular face.
  fontdir        = {},
  fontregular    = lmsans10-regular.otf,
  fontbold       = lmsans10-bold.otf,
  fontitalic     = lmsans10-oblique.otf,
  fontbolditalic = lmsans10-boldoblique.otf,
  fontlight      = lmsans10-regular.otf,
  %--- Colors (hex, without the leading #) -----------------------------------
  accent    = 22A39F, % section headers, role line, links, badges
  primary   = 1A1A1A, % primary text (name, titles, headline, body)
  secondary = 666666, % secondary text (education, footer, entry meta)
  %--- Font sizes as {size}{leading} -----------------------------------------
  namesize       = {23pt}{25pt},  % header name
  rolesize       = {9pt}{11pt},   % header role line
  headlinesize   = {10pt}{12pt},  % header tagline
  labelsize      = {8pt}{8pt},    % section + block labels
  headertextsize = {8pt}{10pt},   % header block lines (location, contacts)
  bodysize       = {8.8pt}{11pt}, % normal body text
  footersize     = {6pt}{8pt},    % small-print footer
  %--- Text: line spacing and the name's letter-spacing (tracking) -----------
  linespread   = 1.02,
  nametracking = 4.0,
  %--- Layout: column ratios, gutter, work split, icon/badge, QR code --------
  headerratio      = 0.74,    % header row: left column share (0-1)
  bodyratio        = 0.505,   % body rows: left column share (0-1)
  bodycolsep       = 14pt,    % gutter between body columns (at 8pt pdftotext merges lines of the two columns; below 13pt pdfminer splits skill names)
  worksplit        = 1,       % first N jobs go in the left column, rest in the right
  sectioniconsize  = 9pt,     % section-header icon height
  sectioniconraise = -0.18em, % icon vertical nudge onto the label baseline
  sectioniconsep   = 6pt,     % gap icon -> section label
  coursebadgewidth = 13pt,    % course grade badge width
  qrcodex          = 320pt,   % header QR code: offset from the page left edge
  qrcodey          = 18pt,    % header QR code: offset from the page top edge
  qrcodesize       = 50pt,    % header QR code: side length
  %--- Vertical spacing ------------------------------------------------------
  % The document never sets \vspace itself; these lengths control every gap and
  % the structural macros below insert them automatically. Keep the BETWEEN-
  % block gaps larger than the WITHIN-element gaps so sections stay visually
  % separated from the lines inside a single element.
  % Between blocks:
  sectiongap          = 6pt,   % between sections (e.g. Introduction -> Experience)
  sectionlabelgap     = 4pt,   % section label -> its content
  headerblockgap      = 6pt,   % between header right-column blocks
  headerblocklabelgap = 2pt,   % header block label -> its lines
  % Within the header:
  namegap             = 6pt,   % name -> role line
  rolegap             = 2pt,   % role line -> headline
  headerbottomgap     = 4pt,   % below the whole header
  contactlinegap      = 1pt,   % between contact lines
  % Within an element:
  bodygap             = 3pt,   % between consecutive body paragraphs / entries
  newlinegap          = 3pt,   % between \\ new lines in a body
  entrytopgap         = 2.4pt, % above an entry title
  entrymetagap        = 1pt,   % below an entry meta line
  edugap              = 2.4pt, % above an education row
  coursegap           = 1.8pt, % between course rows
  skillgap            = 2.4pt, % above a skill row
  langtoppad          = 2.4pt, % lead-in above the language pair
  langlinegap         = 1pt,   % language name -> level line
  langcellwidth       = 0.5,   % language cell width as a share of the column
  %--- Bullet lists (itemize) inside any body --------------------------------
  listindent  = 1em, % bullet indentation
  listitemsep = 0pt, % between list items
  listtopsep  = 1pt, % above/below the whole list
  listparsep  = 0pt, % between paragraphs in an item
}
\ProcessKeyOptions[gmresume]
%=============================================================================

%----------------- APPLIES THE SETTINGS ABOVE (do not edit below) -----------------
% Settings can change until \begin{document}, so the ones that cannot be
% re-applied later (geometry, fonts, PDF metadata) are applied at its very
% start: begindocument/before runs ahead of every package's \AtBeginDocument
% code, which is where hyperref and hyperxmp read the metadata (pdflang in
% particular is ignored if set any later).
\AddToHook{begindocument/before}{%
  \geometry{
    paperwidth=\resumepaperwidth, paperheight=\resumepaperheight,
    top=\resumemargintop, bottom=\resumemarginbottom,
    left=\resumemarginleft, right=\resumemarginright
  }%
  \edef\resume@setfonts{%
    \noexpand\setmainfont{\fontregular}[%
      \ifx\fontdir\@empty\else Path = \fontdir,\fi
      BoldFont       = \fontbold,
      ItalicFont     = \fontitalic,
      BoldItalicFont = \fontbolditalic]%
    \noexpand\newfontfamily\noexpand\sflight{\fontlight}[%
      \ifx\fontdir\@empty\else Path = \fontdir\fi]}%
  \resume@setfonts
  \applymetadata
  \color{primary}%
  \linespread{\resumelinespread}%
  \normalsize}

% hyperxmp moves Author/Keywords to the XMP stream only; keeppdfinfo also
% keeps them in the classic Info dictionary, which LinkedIn and ATS tools read.
% The metadata values themselves are declared by the document (see
% \applymetadata below).
\hypersetup{keeppdfinfo = true}

% Prevent line-break hyphenation from splitting words in the text layer
% (e.g. "High Per-formance Computing"), which breaks ATS/AI keyword matching.
\hyphenpenalty=10000
\exhyphenpenalty=10000
\tolerance=2000
\emergencystretch=3em % last-resort stretch so unhyphenated long words wrap instead of overflowing the column

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\JustifyingParindent}{0pt}
\renewcommand\normalsize{\sizebody} % applied at \begin{document}

% Tracks whether the next \body is the first of its group (no leading gap) or a
% follow-on paragraph (gets \bodygap). Reset by every macro that opens a group.
\newif\ifresumefirstbody
\newcommand{\resetbodygap}{\global\resumefirstbodytrue}
\resetbodygap

%----------------- CONTENT BUCKETS (the document fills these) ----------------
% The document declares only elements. Each element macro appends its rendered
% form to one of these lists; \makeresume (invoked once, by the document) lays the
% lists out into sections, columns and pages. No structure lives in the document.
\makeatletter
\newcommand{\appendto}[2]{\g@addto@macro#1{#2}}
\makeatother
% Work experience is split across the page-1 column boundary: the first
% \resumeworksplit jobs fill the left column, the rest continue in the right column
% (reproducing the original hand-placed layout). \resumeworksplit is set above.
\newcounter{resumejobno}
\newcommand{\resumeintro}{}
\newcommand{\resumeworkleft}{}
\newcommand{\resumeworkright}{}
\newcommand{\resumeprojects}{}
\newcommand{\resumepubs}{}
\newcommand{\resumeedu}{}
\newcommand{\resumecourses}{}
\newcommand{\resumehonours}{}
\newcommand{\resumeskills}{}
\newcommand{\resumelangs}{}
\newcommand{\resumesectionfootnote}{}
\newcommand{\resumefootertext}{}

%----------------- STRUCTURAL MACROS -----------------
% Header block: name, role, tagline (left) + location/contacts (right)
% -- Declarative header fields ---------------------------------------------
% The document only DECLARES facts with these setters; it never touches the
% document structure. \makeresumeheader renders them into the two-column header.
%
%   \name{JANE DOE}
%   \role{SOFTWARE ENGINEER}          % rendered bold
%   \company{Example Corp}            % rendered normal weight, after "@"
%   \headline{One-line professional tagline}
%   \location[https://maps.google.com/...]{City, Country} % URL optional
%   \email{jane.doe@example.com}
%   \linkedin{janedoe}            % handle only; label/URL are built here
%   \github{janedoe}              % handle only
%   \qrcodeurl{https://example.com/resume.pdf} % encoded in the header QR code; also the PDF source URL
%   \makeresumeheader
%
% Any field left unset is simply omitted from the rendered header.
\newcommand{\resumename}{}     \newcommand{\name}[1]{\renewcommand{\resumename}{#1}}
\newcommand{\resumerole}{}     \newcommand{\role}[1]{\renewcommand{\resumerole}{#1}}
\newcommand{\resumecompany}{}  \newcommand{\company}[1]{\renewcommand{\resumecompany}{#1}}
\newcommand{\resumeheadline}{} \newcommand{\headline}[1]{\renewcommand{\resumeheadline}{#1}}
% Location accepts an optional URL: \location[https://maps...]{Boston, MA, ...}
% When given, the location text becomes a clickable link.
\newcommand{\resumelocation}{}
\newcommand{\resumelocationurl}{}
\newcommand{\location}[2][]{%
  \renewcommand{\resumelocation}{#2}\renewcommand{\resumelocationurl}{#1}}
\newcommand{\resumeemail}{}    \newcommand{\email}[1]{\renewcommand{\resumeemail}{#1}}
\newcommand{\resumelinkedin}{} \newcommand{\linkedin}[1]{\renewcommand{\resumelinkedin}{#1}}
\newcommand{\resumegithub}{}   \newcommand{\github}[1]{\renewcommand{\resumegithub}{#1}}
\newcommand{\resumeqrcodeurl}{} \newcommand{\qrcodeurl}[1]{\renewcommand{\resumeqrcodeurl}{#1}}

% \iffield{\resumexxx}{code} runs code only when field xxx was set (non-empty).
\newcommand{\iffield}[2]{\ifx\relax#1\relax\else\ifx#1\empty\else#2\fi\fi}

% Render the header from the declared fields.
\newcommand{\makeresumeheader}{%
  \resumecheckcontact
  \columnratio{\headerratio}%
  \begin{paracol}{2}
  {\bfseries\sizename\color{primary}\addfontfeature{LetterSpace=\resumenametracking}\resumename}\\[\namegap]
  {\sizerole\color{accent}{\bfseries\resumerole}\iffield{\resumecompany}{ @ \resumecompany}}\\[\rolegap]
  {\sizeheadline\color{primary}\resumeheadline}
  \switchcolumn
  \resumefirstheaderblocktrue
  \iffield{\resumelocation}{\headerblock{LOCATION}{%
    \ifx\resumelocationurl\empty\resumelocation\else\href{\resumelocationurl}{\resumelocation}\fi}}%
  \ifresumehascontact\headerblock{CONTACTS}{\resumecontactlines}\fi
  \end{paracol}%
  \iffield{\resumeqrcodeurl}{\tikz[remember picture,overlay]{%
    \node[anchor=north west, inner sep=0pt] at ([xshift=\resumeqrcodex, yshift=-\resumeqrcodey]current page.north west)
      {\qrcode[height=\resumeqrcodesize]{\resumeqrcodeurl}};}}%
  \vspace{\headerbottomgap}%
}

% -- Declarative PDF metadata fields ---------------------------------------
% LinkedIn and many HR/ATS tools read these fields; \pdfkeywords carries
% role-relevant terms for keyword matching. \qrcodeurl doubles as dc:source
% (the canonical URL) in the XMP stream.
%
%   \pdftitle{Jane Doe - Resume}
%   \pdfauthor{Jane Doe}
%   \pdfsubject{Software Engineer - Distributed Systems}
%   \pdfkeywords{Software Engineer, Distributed Systems, Python}
%   \pdflanguage{en}
\newcommand{\resumepdftitle}{}    \newcommand{\pdftitle}[1]{\renewcommand{\resumepdftitle}{#1}}
\newcommand{\resumepdfauthor}{}   \newcommand{\pdfauthor}[1]{\renewcommand{\resumepdfauthor}{#1}}
\newcommand{\resumepdfsubject}{}  \newcommand{\pdfsubject}[1]{\renewcommand{\resumepdfsubject}{#1}}
\newcommand{\resumepdfkeywords}{} \newcommand{\pdfkeywords}[1]{\renewcommand{\resumepdfkeywords}{#1}}
\newcommand{\resumepdflanguage}{} \newcommand{\pdflanguage}[1]{\renewcommand{\resumepdflanguage}{#1}}

% Write the declared metadata into the PDF. Called at the very start of
% \begin{document} (see APPLIES THE SETTINGS ABOVE), after the document has
% declared its content in the preamble.
\newcommand{\applymetadata}{%
  \hypersetup{
    pdftitle    = {\resumepdftitle},
    pdfauthor   = {\resumepdfauthor},
    pdfsubject  = {\resumepdfsubject},
    pdfkeywords = {\resumepdfkeywords},
    pdflang     = {\resumepdflanguage},
    pdfsource   = {\resumeqrcodeurl}
  }}

% True when at least one contact handle was declared.
\newif\ifresumehascontact
\newcommand{\resumecheckcontact}{%
  \iffield{\resumeemail}{\global\resumehascontacttrue}%
  \iffield{\resumelinkedin}{\global\resumehascontacttrue}%
  \iffield{\resumegithub}{\global\resumehascontacttrue}}

% Assemble the contact lines from whichever handles were declared.
% Show full URLs as visible text so text-only parsers capture them (not just
% the embedded hyperlink target).
\newcommand{\resumecontactlines}{%
  \iffield{\resumeemail}{\href{mailto:\resumeemail}{\resumeemail}\\[\contactlinegap]}%
  \iffield{\resumelinkedin}{\href{https://linkedin.com/in/\resumelinkedin}{linkedin.com/in/\resumelinkedin}\\[\contactlinegap]}%
  \iffield{\resumegithub}{\href{https://github.com/\resumegithub}{github.com/\resumegithub}}%
}

% A labelled block for the header right column (e.g. Location, Contacts).
% #1 = label  #2 = lines. A leading gap separates stacked blocks; the first
% block in the column gets none.
\newif\ifresumefirstheaderblock
\newcommand{\headerblock}[2]{%
  \ifresumefirstheaderblock\global\resumefirstheaderblockfalse\else\vspace{\headerblockgap}\fi
  {\color{accent}\sizelabel #1}\\[\headerblocklabelgap]{\sizeheadertext #2\par}}

%----------------- STRUCTURAL SKELETON (used only by \makeresume) -----------------
% The document never calls any of these; \makeresume assembles the document.
% Open / close the two independent body columns
\newcommand{\bodystart}{%
  \columnratio{\bodyratio}\setlength{\columnsep}{\bodycolsep}\begin{paracol}{2}}
\newcommand{\bodyend}{\end{paracol}}
% Switch from the left body column to the right one
\newcommand{\rightcolumn}{\switchcolumn}
% Page break that repeats the header on the new page
\newcommand{\resumenewpage}{\newpage\makeresumeheader}

% Section header: icon + accent-colored uppercase label
% #1 = icon name (icons/gmresume-<name>.pdf, installed with the class), #2 = label
\newcommand{\resumesection}[2]{%
  \resetbodygap
  \vspace{\sectiongap}%
  \noindent\raisebox{\resumesectioniconraise}{\includegraphics[height=\resumesectioniconsize]{gmresume-#1}}\hspace{\resumesectioniconsep}%
  {\color{accent}\sizelabel #2}\par
  \vspace{\sectionlabelgap}%
}

%----------------- ELEMENT RENDERERS (private) -----------------
% These typeset one element. The public element macros below only APPEND a
% call to one of these into a section bucket; nothing is typeset until \makeresume.

% Entry: bold title, secondary meta line. Optional URL makes the title a clickable
% teal link.  \entry[url]{Title}{Meta}
\newcommand{\entry}[3][]{%
  \resetbodygap
  \vspace{\entrytopgap}%
  {\bfseries\ifx\relax#1\relax #2\else\href{#1}{\color{accent}#2}\fi}\par
  {\color{secondary}#3}\par
  \vspace{\entrymetagap}%
}
% Entry variant where linked titles use primary color instead of accent.
\newcommand{\entryprimary}[3][]{%
  \resetbodygap
  \vspace{\entrytopgap}%
  {\bfseries\ifx\relax#1\relax #2\else\href{#1}{\color{primary}#2}\fi}\par
  {\color{secondary}#3}\par
  \vspace{\entrymetagap}%
}
% A \\ inside any element body starts a new line separated by \newlinegap.
\newcommand{\bodynewline}{\par\vspace{\newlinegap}}
% Justified body paragraph. Consecutive paragraphs are separated by \bodygap;
% the first after a section/entry gets no leading gap. Within the text, \\
% inserts a \newlinegap-spaced new line.
% The finite \rightskip stretch lets a hard-to-justify line end slightly short
% instead of widening its word gaps: pdfminer (used by most resume parsers)
% splits a line at any gap wider than ~2 glyph widths and may reorder the parts.
\long\def\body#1{%
  \ifresumefirstbody\global\resumefirstbodyfalse\else\vspace{\bodygap}\fi
  \noindent\begingroup\justifying\rightskip=0pt plus 2em\setlength{\parindent}{0pt}\let\\\bodynewline #1\par\endgroup}
% Education row: bold degree, school + years on one line, grade on third line.
\newcommand{\renderedu}[3]{%
  \resetbodygap
  \vspace{\edugap}{\bfseries #1}\par
  {\color{secondary}#2}\par
  {\color{secondary}#3}\par}
% Course row: name (left) + teal grade badge (right).
\newcommand{\rendercourse}[2]{%
  \noindent#1\hfill\colorbox{accent}{\makebox[\resumecoursebadgewidth][c]{\color{white}\bfseries#2}}\par
  \vspace{\coursegap}}
% Skill row: bold category + description.
\newcommand{\renderskill}[2]{%
  \vspace{\skillgap}\noindent{\bfseries #1}\quad #2\par}
% One language proficiency as a half-column cell; consecutive cells sit side by
% side, so declaring two languages reproduces the original paired row.
\newcommand{\renderlanguage}[2]{%
  \begin{minipage}[t]{\resumelangcellwidth\columnwidth}{\bfseries #1}\\[\langlinegap]{\color{secondary}#2}\end{minipage}}
% Small-print note rendered directly under the Education section (same column),
% so a starred remark stays next to the entry it refers to.
\newcommand{\resumeedunote}{%
  \iffield{\resumefootertext}{\vspace{\edugap}{\sflight\sizefooter\color{secondary}\resumefootertext\par}}}

%----------------- ELEMENT DECLARATIONS (the document uses only these) -------
% Each macro appends its element to the relevant section bucket. The content is
% a flat list of these calls: no sections, columns, pages, or body plumbing.
% In any body/description, \\ starts a new line spaced by \newlinegap.
%
%   \introduction{First line.\\ Second line.\\ Third line.}
%   \job[url]{Title}{Employer}{Years}{Description with a\\ new line}
%   \project[url]{Title}{Meta}{Description with a\\ new line}
%   \sectionfootnote{Trailing italic note under a section.}
%   \publication[url]{Title}{Venue}     % URL optional; title becomes a link
%   \education{Degree}{School}{Years and grade}
%   \course{Name}{Grade}
%   \skill{Category}{Comma-separated items}
%   \lang{Name}{Level}
%   \footer{Small-print note shown under the Education section.}
% Introduction: a single element. Like every body, \\ starts a new line
% (spaced by \newlinegap). Declare exactly one \introduction.
\long\def\introduction#1{\appendto\resumeintro{\body{#1}}}
% Jobs route to the left column bucket until \resumeworksplit is reached, then to
% the right column bucket — so the document just lists jobs in order.
\newcommand{\job}[5][]{%
  \stepcounter{resumejobno}%
  \ifnum\value{resumejobno}>\resumeworksplit\relax
    \appendto\resumeworkright{\entry[#1]{#2}{#3, #4}\body{#5}}%
  \else
    \appendto\resumeworkleft{\entry[#1]{#2}{#3, #4}\body{#5}}%
  \fi}
\newcommand{\project}[4][]{\appendto\resumeprojects{\entryprimary[#1]{#2}{#3}\body{#4}}}
\newcommand{\sectionfootnote}[1]{\appendto\resumesectionfootnote{\body{\color{secondary}\itshape #1}}}
\newcommand{\publication}[3][]{\appendto\resumepubs{\entryprimary[#1]{#2}{#3}}}
\newcommand{\honour}[2]{\appendto\resumehonours{\entry{#1}{#2}}}
\newcommand{\education}[3]{\appendto\resumeedu{\renderedu{#1}{#2}{#3}}}
\newcommand{\course}[2]{\appendto\resumecourses{\rendercourse{#1}{#2}}}
\newcommand{\skill}[2]{\appendto\resumeskills{\renderskill{#1}{#2}}}
\newcommand{\lang}[2]{\appendto\resumelangs{\renderlanguage{#1}{#2}}}
\newcommand{\footer}[1]{\renewcommand{\resumefootertext}{#1}}

%----------------- DOCUMENT ASSEMBLY -----------------
% Renders the whole resume from the declared header fields and section buckets.
% Fixed placement: page 1 (Intro+Work | Work+Skills),
% page 2 (Projects | Publications+Education+Awards+Languages).
\newcommand{\makeresume}{%
  \makeresumeheader
  % --- Page 1 ---
  \bodystart
    \resumesection{introduction}{SUMMARY}\resumeintro
    \resumesection{work}{WORK EXPERIENCE}\resumeworkleft
  \rightcolumn
    \resumeworkright
    \resumesection{skills}{SKILLS}\resumeskills
  \bodyend
  % --- Page 2 ---
  \resumenewpage
  \bodystart
    \resumesection{projects}{PROJECTS}\resumeprojects\resumesectionfootnote
    %\resumesection{courses}{MAIN COURSES}\resumecourses
  \rightcolumn
    \resumesection{publications}{PUBLICATIONS}\resumepubs
    \resumesection{education}{EDUCATION}\resumeedu\resumeedunote
    \resumesection{honours}{AWARDS}\resumehonours
    % Languages is rendered only when the document declared at least one \lang.
    \iffield{\resumelangs}{\resumesection{languages}{LANGUAGES}\vspace{\langtoppad}\noindent\resumelangs\par}
  \bodyend
}

\setlist[itemize]{leftmargin=\resumelistindent, itemsep=\resumelistitemsep, topsep=\resumelisttopsep, parsep=\resumelistparsep}
