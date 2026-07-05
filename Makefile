# Makefile — build resume.pdf from the LaTeX sources in src/
#
#   make setup    install LaTeX dependencies (once)
#   make build    build $(BUILD_PDF) and copy to public/ (default)
#   make view     open the built PDF (does not build; errors if missing)
#   make clean    remove the build folder

SRC_DIR   := src
BUILD_DIR := build
PUBLIC_DIR  := public
MAIN      := $(SRC_DIR)/main.tex
PDF_NAME    := resume.pdf
BUILD_PDF   := $(BUILD_DIR)/$(PDF_NAME)
PUBLIC_PDF  := $(PUBLIC_DIR)/$(PDF_NAME)

# Let xelatex find layout.tex / content.tex and the assets under src/ and root.
export TEXINPUTS := .:./$(SRC_DIR):

.PHONY: setup build view clean

setup:
	brew install --cask basictex
	sudo tlmgr update --self
	sudo tlmgr install paracol fontawesome5 enumitem

build:
	mkdir -p $(BUILD_DIR)
	# Run xelatex twice: the first pass writes references (hyperref page labels
	# and PDF outlines) to main.aux/main.out; the second pass reads them back so
	# the PDF is correct. A single pass leaves these stale.
	xelatex -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR) $(MAIN)
	xelatex -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR) $(MAIN)
	mv $(BUILD_DIR)/main.pdf $(BUILD_PDF)
	cp $(BUILD_PDF) $(PUBLIC_PDF)

view:
	open $(BUILD_PDF)

clean:
	rm -rf $(BUILD_DIR)
