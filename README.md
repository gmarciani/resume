# Resume

My resume, built with LaTeX.

Check it out at https://gmarciani.github.io/resume/resume.pdf.

## Requirements

- **macOS** with [Homebrew](https://brew.sh/) installed.
- **GNU Make** — included with the Xcode Command Line Tools
  (`xcode-select --install`).

Install all dependencies (BasicTeX + required packages) and the `gmresume`
class with:

```sh
make setup
```

This installs [BasicTeX](https://tug.org/mactex/morepackages.html) via
Homebrew, adds the CTAN packages the document needs and building tools, and
links the [`gmresume`](#using-the-gmresume-class) class into your personal TeX
tree. You only need to run it once.

## Building

```sh
make build     # build build/resume.pdf and copy to public/ (default target)
make test      # check the built PDF's text and metadata
make view      # open the built PDF
make watch     # build and open the PDF, then rebuild it on every change in src/, gmresume/ or assets/
make clean     # remove the build/ folder
```

## Using the gmresume class

The layout is a reusable LaTeX class, `gmresume`, with no resume content of
its own. To write your own resume with it:

1. Install the class into your personal TeX tree straight from GitHub:

   ```sh
   texmf="$(kpsewhich -var-value TEXMFHOME)/tex/latex" && mkdir -p "$texmf"
   curl -fsSL https://github.com/gmarciani/resume/archive/refs/heads/main.tar.gz \
     | tar -xz -C "$texmf" --strip-components=1 resume-main/gmresume
   ```

2. Write a document that starts with `\documentclass{gmresume}` and compile
   it from any folder with XeLaTeX or LuaLaTeX.

3. Customize the content by declaring it in the preamble with the macros documented
   in [`gmresume/gmresume.cls`](gmresume/gmresume.cls), then call `\makeresume` in
   the body; override any layout setting with `\resumeset{key=value, ...}`.

## Project Structure

```
.
├── src/
│   ├── main.tex          entry point (gmresume class + font settings, inputs content, then \makeresume)
│   └── content.tex       Resume content only — a flat list of element declarations
├── gmresume/
│   ├── gmresume.cls      the reusable class: settings, macros, document assembly
│   ├── assets/           section-header icons, SVG sources
│   └── icons/            section-header icons, PDFs generated from the SVGs (make build-assets); used by the class
├── assets/
│   └── fonts/            OpenType fonts (SF Pro), embedded at build time; not part of the class
├── tests/                PDF text and metadata tests (pdfminer.six, run in CI)
└── build/                build output (git-ignored); holds resume.pdf
```
