// Orion PDR slide theme, built on the vendored Diatypst source.
//
// Decks import this file, never `diatypst/lib.typ` directly, so that defaults
// and brand tokens live in one place. Small tweaks go here; structural changes
// (header, footer, title slide layout) go in `diatypst/lib.typ` and get logged
// in `diatypst/UPSTREAM.md`.

#import "diatypst/lib.typ" as diatypst

// Brand tokens -----------------------------------------------------------
// Charcoal + gold, sampled from the 2025 Orion PDR deck.
#let palette = (
  bg: rgb("#383838"),
  fg: rgb("#f3f3f3"),
  muted: rgb("#a8a8a8"),
  accent: rgb("#f1c232"),
  on-accent: rgb("#252323"),
  surface: rgb("#444444"),
  surface-strong: rgb("#505050"),
  rule: rgb("#5e5e5e"),
)

// Montserrat ships in assets/fonts; compile with `--font-path assets/fonts`.
#let fonts = (
  body: ("Montserrat", "Helvetica Neue", "Arial"),
  mono: ("Menlo", "DejaVu Sans Mono"),
)

#let logos = (
  // White lettering, for the charcoal background.
  inverted: image("../assets/logo/colour_horizontal_inverted.png"),
)

// Entry point ------------------------------------------------------------
#let orion-slides(body, ..args) = {
  set text(font: fonts.body, size: 11pt)
  set par(leading: 0.7em)
  show raw: set text(font: fonts.mono)
  set raw(theme: "code-dark.tmTheme")

  show: diatypst.slides.with(
    ratio: 16 / 9,
    layout: "medium",
    title-color: palette.accent,
    bg-color: palette.bg,
    colors: palette,
    logo: logos.inverted,
    theme: "normal",
    count: "dot-section",
    toc: true,
    toc-title: "Agenda",
    ..args,
  )
  body
}

// Helpers ----------------------------------------------------------------
#let accent(body) = text(fill: palette.accent, weight: "bold", body)
