# Makefile — build resume.pdf from the LaTeX sources in src/
#
#   make build    build $(PDF) (default)
#   make view     open the built PDF (does not build; errors if missing)
#   make publish  copy the built PDF to the repo root, then commit and push
#   make clean    remove the build folder

SRC_DIR   := src
BUILD_DIR := build
MAIN      := $(SRC_DIR)/main.tex
PDF_NAME  := resume.pdf
PDF       := $(BUILD_DIR)/$(PDF_NAME)
# Published copy at the repo root — committed to the repo, not git-ignored.
ROOT_PDF  := $(PDF_NAME)

# Let xelatex find layout.tex / content.tex and the assets under src/ and root.
export TEXINPUTS := .:./$(SRC_DIR):

.PHONY: build view publish clean

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

# Publish the built PDF to the repo root, then commit and push it.
# Prompts for confirmation before touching git.
publish: build
	cp $(PDF) $(ROOT_PDF)
	@printf 'Are you sure you want to publish %s? [y/N] ' '$(ROOT_PDF)'; \
	read ans; \
	case "$$ans" in [Yy]*) ;; *) echo "Aborted."; exit 1;; esac
	git add $(ROOT_PDF)
	git commit -m "Update resume"
	git push

clean:
	rm -rf $(BUILD_DIR)
