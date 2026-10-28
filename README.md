# Orion PDR Slides

Typst slide deck built on a vendored, customizable copy of
[Diatypst](https://github.com/skriptum/Diatypst).

## Setup

1. Install Typst (0.13 or newer):

   ```sh
   brew install typst                 # macOS
   winget install --id Typst.Typst    # Windows
   ```

   Other platforms: see https://github.com/typst/typst#installation.

2. Build the slides:

   ```sh
   make          # writes build/slides.pdf
   make watch    # rebuilds on every save
   ```

   Without `make`:
   `typst compile --root . --font-path assets/fonts slides.typ build/slides.pdf`

### VS Code (live preview)

1. Install the **Tinymist Typst** extension.
2. Open `slides.typ` and click the preview icon in the top-right of the editor
   (or run **Typst Preview: Preview Opened File** from the command palette).

The repo's `.vscode/settings.json` already points Tinymist at the bundled
Montserrat font. In other editors, add `assets/fonts` to your Typst font
paths, or the slides fall back to Helvetica/Arial.

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
