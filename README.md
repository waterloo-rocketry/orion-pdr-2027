# Orion PDR Slides

Typst slide deck built on a vendored, customizable copy of
[Diatypst](https://github.com/skriptum/Diatypst).

## Build

```sh
make          # build/slides.pdf
make watch    # rebuild on save
```

Requires Typst ≥ 0.13. Montserrat is bundled in `assets/fonts` and loaded
with `--font-path assets/fonts` (the Makefile does this). For editor previews
(e.g. Tinymist), add `assets/fonts` to the font paths setting.

## Layout

```
slides.typ               the deck
theme/theme.typ          Orion theme: palette, fonts, logos, defaults
theme/code-dark.tmTheme  syntax colours for code blocks
theme/diatypst/lib.typ   vendored Diatypst source (edit freely)
theme/diatypst/UPSTREAM.md  upstream commit + log of local modifications
assets/logo, assets/fonts
```

Colours and fonts go in `theme/theme.typ`. Layout changes (header, footer,
title/section slides) go in `theme/diatypst/lib.typ`. Log each one in
`UPSTREAM.md` so you can still merge upstream updates.
