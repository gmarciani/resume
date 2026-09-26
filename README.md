# Resume

My resume, built with LaTeX.

Check it out at https://gmarciani.github.io/resume/resume.pdf.

## Requirements

- **macOS** with [Homebrew](https://brew.sh/) installed.
- **GNU Make** — included with the Xcode Command Line Tools
  (`xcode-select --install`).

Install all LaTeX dependencies (BasicTeX + required packages) with:

```sh
make setup
```

This installs [BasicTeX](https://tug.org/mactex/morepackages.html) via
Homebrew, adds the CTAN packages the document needs and building tools. 
You only need to run it once.

## Building

```sh
make build     # build build/resume.pdf and copy to public/ (default target)
make view      # open the built PDF
make watch     # build and open the PDF, then rebuild it on every change in src/ or assets/
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
