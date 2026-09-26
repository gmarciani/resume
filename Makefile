# Makefile — build resume.pdf from the LaTeX sources in src/
#
#   make setup    install LaTeX dependencies (once)
#   make build    build $(BUILD_PDF) and copy to public/ (default)
#   make view     open the built PDF (does not build; errors if missing)
#   make watch    open the PDF and rebuild it whenever a source or asset file changes
#   make clean    remove the build folder

SRC_DIR   := src
BUILD_DIR := build
PUBLIC_DIR  := public
ASSETS_DIR  := assets
MAIN      := $(SRC_DIR)/main.tex
PDF_NAME    := resume.pdf
BUILD_PDF   := $(BUILD_DIR)/$(PDF_NAME)
PUBLIC_PDF  := $(PUBLIC_DIR)/$(PDF_NAME)

# Let xelatex find layout.tex / content.tex and the assets under src/ and root.
export TEXINPUTS := .:./$(SRC_DIR):

.PHONY: setup build view watch clean

setup:
	brew install --cask basictex inkscape
	brew install fswatch
	sudo tlmgr update --self
	sudo tlmgr install paracol fontawesome5 enumitem svg trimspaces transparent catchfile footmisc hyperxmp ifmtarg hyperxmp

build:
	mkdir -p $(BUILD_DIR)
	# Run xelatex twice: the first pass writes references (hyperref page labels
	# and PDF outlines) to main.aux/main.out; the second pass reads them back so
	# the PDF is correct. A single pass leaves these stale.
	xelatex --shell-escape -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR) $(MAIN)
	xelatex --shell-escape -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR) $(MAIN)
	# Copy in place (not mv) so $(BUILD_PDF) keeps its inode: PDF viewers such as
	# Preview watch the open file and reload it automatically when it is rewritten.
	cp $(BUILD_DIR)/main.pdf $(BUILD_PDF) && rm $(BUILD_DIR)/main.pdf
	cp $(BUILD_PDF) $(PUBLIC_PDF)

view:
	open $(BUILD_PDF)

# Requires fswatch (installed by `make setup`). Builds once and opens the PDF,
# then rebuilds on every change under src/ and assets/. After each successful
# rebuild the PDF is re-opened in the background (open -g) so the viewer refreshes
# without stealing focus. A failed build does not stop the loop. Stop with Ctrl-C.
watch: build
	@open $(BUILD_PDF)
	@echo "Watching $(SRC_DIR)/ and $(ASSETS_DIR)/ for changes (Ctrl-C to stop)..."
	@fswatch -o --latency 1 $(SRC_DIR) $(ASSETS_DIR) | while read -r _; do $(MAKE) build && open -g $(BUILD_PDF); done

clean:
	rm -rf $(BUILD_DIR)
