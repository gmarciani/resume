# Makefile — build resume.pdf from the LaTeX sources in src/
#
#   make build   build $(PDF) (default)
#   make view    open the built PDF (does not build; errors if missing)
#   make clean   remove the build folder

SRC_DIR   := src
BUILD_DIR := build
MAIN      := $(SRC_DIR)/main.tex
PDF       := $(BUILD_DIR)/resume.pdf

# Let xelatex find layout.tex / content.tex and the assets under src/ and root.
export TEXINPUTS := .:./$(SRC_DIR):

.PHONY: build view clean

build:
	mkdir -p $(BUILD_DIR)
	# Run xelatex twice: the first pass writes references (hyperref page labels
	# and PDF outlines) to main.aux/main.out; the second pass reads them back so
	# the PDF is correct. A single pass leaves these stale.
	xelatex -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR) $(MAIN)
	xelatex -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR) $(MAIN)
	mv $(BUILD_DIR)/main.pdf $(PDF)

view:
	open $(PDF)

clean:
	rm -rf $(BUILD_DIR)
