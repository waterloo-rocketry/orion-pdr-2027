TYPST ?= typst
FONTS  := --font-path assets/fonts
SRC    := slides.typ
OUT    := build/slides.pdf

.PHONY: all watch clean

all: $(OUT)

$(OUT): $(SRC) $(wildcard theme/* theme/diatypst/*.typ assets/* assets/*/*)
	@mkdir -p build
	$(TYPST) compile --root . $(FONTS) $(SRC) $(OUT)

watch:
	@mkdir -p build
	$(TYPST) watch --root . $(FONTS) $(SRC) $(OUT)

clean:
	rm -rf build
