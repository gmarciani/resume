# Resume

My resume, buolt with LaTeX.

## Requirements

- **XeLaTeX** — the TeX engine used to compile the document (it is required
  because the résumé embeds local OpenType fonts via `fontspec`). Ships with
  [MacTeX](https://tug.org/mactex/) (or `brew install --cask mactex`).
- **GNU Make** — runs the build targets in the `Makefile`. Included with the
  Xcode Command Line Tools (`xcode-select --install`).

## Building

```sh
make build   # build build/resume.pdf (default target)
make view    # build, then open the PDF
make clean   # remove the build/ folder
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
