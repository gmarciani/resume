# Resume

My resume, buolt with LaTeX.

## Requirements

- **macOS** with [Homebrew](https://brew.sh/) installed.
- **GNU Make** — included with the Xcode Command Line Tools
  (`xcode-select --install`).

Install all LaTeX dependencies (BasicTeX + required packages) with:

```sh
make setup
```

This installs [BasicTeX](https://tug.org/mactex/morepackages.html) via
Homebrew and adds the CTAN packages the document needs (`paracol`,
`fontawesome5`, `enumitem`). You only need to run it once.

## Building

```sh
make build     # build build/resume.pdf (default target)
make view      # open the built PDF
make publish   # build, copy the PDF to the repo root, then commit and push (prompts first)
make clean     # remove the build/ folder
```

## Project Structure

```
src/main.tex       entry point (inputs layout + content, then \makecv)
src/layout.tex     all styling: theme settings, macros, document assembly
src/content.tex    CV content only — a flat list of element declarations
assets/fonts/      OpenType fonts (SF Pro), embedded at build time
assets/images/     section-header icons
build/             build output (git-ignored); holds resume.pdf
```
